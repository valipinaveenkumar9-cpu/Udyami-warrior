import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:uk_circle_partners/core/models/ward_model.dart';
import '../../data/cloud_patra_api.dart';

class MapSelectionModal extends StatefulWidget {
  final LatLng? initialLocation;
  final WardModel? selectedWard;
  final String? wardName;
  final Map<String, dynamic>? geoJson;

  const MapSelectionModal({
    super.key,
    this.initialLocation,
    this.selectedWard,
    this.wardName,
    this.geoJson,
  });

  @override
  State<MapSelectionModal> createState() => _MapSelectionModalState();
}

class _MapSelectionModalState extends State<MapSelectionModal> {
  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? _selectedLocation;
  String? _selectedAddress;
  bool _isFetchingAddress = false;
  bool _isLoading = true;
  final Set<Polygon> _wardPolygons = {};
  final List<List<LatLng>> _validBoundaries = [];
  LatLng? _wardCenter;
  int _polygonIdCounter = 0;
  bool _hasLocationPermission = false;

  @override
  void initState() {
    super.initState();
    _checkInitialPermission();
    if (widget.initialLocation != null && widget.initialLocation!.latitude != 0.0) {
      _selectedLocation = widget.initialLocation;
    }

    if (widget.geoJson != null) {
      _parseWardPolygons(widget.geoJson!);
    } else if (widget.selectedWard != null) {
      _fetchWardBoundaries();
    } else if (widget.wardName != null && widget.wardName!.isNotEmpty) {
      _fetchWardMapByName(widget.wardName!);
    } else {
      if (_selectedLocation == null) {
        _getCurrentLocation();
      } else {
        _isLoading = false;
      }
    }
  }

  Future<void> _checkInitialPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      if (mounted) {
        setState(() {
          _hasLocationPermission = true;
        });
      }
    }
  }

  String? _selectedPincode;

  String? _extractPincode(dynamic data, String? displayName) {
    if (data is Map && data['address'] is Map) {
      final postcode = data['address']['postcode']?.toString().trim();
      if (postcode != null) {
        final match = RegExp(r'\b\d{6}\b').firstMatch(postcode);
        if (match != null) return match.group(0);
      }
    }
    if (displayName != null) {
      final match = RegExp(r'\b\d{6}\b').firstMatch(displayName);
      if (match != null) return match.group(0);
    }
    return null;
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    setState(() => _isFetchingAddress = true);
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=18&addressdetails=1',
      );
      final response = await http.get(
        url,
        headers: {'User-Agent': 'UdyamiWarriorApp/1.0'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final displayName = data['display_name'] as String?;
        final extractedPin = _extractPincode(data, displayName);

        if (displayName != null && displayName.isNotEmpty) {
          if (mounted) {
            setState(() {
              _selectedAddress = displayName;
              _selectedPincode = extractedPin;
              _isFetchingAddress = false;
            });
          }
          return;
        }
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        _selectedAddress = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
        _isFetchingAddress = false;
      });
    }
  }

  Future<void> _fetchWardBoundaries() async {
    if (widget.selectedWard?.geoJson != null) {
      _parseWardPolygons(widget.selectedWard!.geoJson!);
    }

    if (_wardPolygons.isEmpty && widget.selectedWard != null) {
      await _fetchWardMapByName(widget.selectedWard!.wardName);
    }
  }

  Future<void> _fetchWardMapByName(String name) async {
    try {
      final response = await CloudPatraApi.getWardMap(name);
      if (response != null && response['data'] != null) {
        _parseWardPolygons(response['data']);
      } else if (response != null && response['type'] != null) {
        _parseWardPolygons(response);
      }
    } catch (e) {
      debugPrint('MapSelectionModal: Error fetching ward map: $e');
    }

    if (_wardPolygons.isEmpty) {
      // Default geofencing boundary for Nelamangala Kasaba / user's selected working area
      final center = const LatLng(13.0991, 77.3941);
      final defaultPolygon = [
        const LatLng(13.1180, 77.3720),
        const LatLng(13.1180, 77.4160),
        const LatLng(13.0800, 77.4160),
        const LatLng(13.0800, 77.3720),
      ];
      _addPolygon(defaultPolygon);
      _wardCenter = center;
      _selectedLocation = center;
      _isLoading = false;
      if (mounted) {
        setState(() {});
        _moveCameraTo(center, 13.5);
      }
    }
  }

  void _parseWardPolygons(Map<String, dynamic> geoJson) {
    List features = [];
    if (geoJson['type'] == 'FeatureCollection') {
      features = geoJson['features'] ?? [];
    } else if (geoJson['type'] == 'Feature') {
      features = [geoJson];
    } else if (geoJson['type'] == 'Polygon' || geoJson['type'] == 'MultiPolygon') {
      features = [{'geometry': geoJson}];
    }

    if (features.isEmpty) return;

    bool foundPolygon = false;
    double sumLat = 0;
    double sumLng = 0;
    int pointCount = 0;

    for (final feature in features) {
      if (feature is! Map) continue;
      final geometry = feature['geometry'];
      if (geometry == null || geometry is! Map) continue;

      final type = geometry['type'];
      final coords = geometry['coordinates'];

      if (type == 'Polygon' && coords is List && coords.isNotEmpty) {
        final polygonCoords = coords[0] as List;
        final List<LatLng> polygonPoints = [];
        for (final coord in polygonCoords) {
          if (coord is List && coord.length >= 2) {
            final lng = double.tryParse(coord[0].toString()) ?? 0.0;
            final lat = double.tryParse(coord[1].toString()) ?? 0.0;
            polygonPoints.add(LatLng(lat, lng));
            sumLat += lat;
            sumLng += lng;
            pointCount++;
          }
        }
        if (polygonPoints.isNotEmpty) {
          _addPolygon(polygonPoints);
          foundPolygon = true;
        }
      } else if (type == 'MultiPolygon' && coords is List) {
        for (final polygonCoordsWrap in coords) {
          if (polygonCoordsWrap is List && polygonCoordsWrap.isNotEmpty) {
            final polygonCoords = polygonCoordsWrap[0] as List;
            final List<LatLng> polygonPoints = [];
            for (final coord in polygonCoords) {
              if (coord is List && coord.length >= 2) {
                final lng = double.tryParse(coord[0].toString()) ?? 0.0;
                final lat = double.tryParse(coord[1].toString()) ?? 0.0;
                polygonPoints.add(LatLng(lat, lng));
                sumLat += lat;
                sumLng += lng;
                pointCount++;
              }
            }
            if (polygonPoints.isNotEmpty) {
              _addPolygon(polygonPoints);
              foundPolygon = true;
            }
          }
        }
      }
    }

    if (foundPolygon && pointCount > 0) {
      _wardCenter = LatLng(sumLat / pointCount, sumLng / pointCount);
      
      final lat = _wardCenter!.latitude;
      final lng = _wardCenter!.longitude;
      
      final outerBounds = [
        LatLng(lat - 20, lng - 20),
        LatLng(lat - 20, lng + 20),
        LatLng(lat + 20, lng + 20),
        LatLng(lat + 20, lng - 20),
      ];

      _wardPolygons.add(
        Polygon(
          polygonId: const PolygonId('out_of_bounds_overlay'),
          points: outerBounds,
          holes: _validBoundaries,
          fillColor: Colors.red.withValues(alpha: 0.15),
          strokeWidth: 0,
        )
      );
    }

    if (_wardPolygons.isNotEmpty && _wardCenter != null) {
      if (mounted) {
        setState(() {
          if (_selectedLocation == null) {
            _selectedLocation = _wardCenter;
            _getAddressFromLatLng(_selectedLocation!);
          }
          _isLoading = false;
        });
        _moveCameraTo(_wardCenter!, 14.0);
      }
    } else {
      if (_selectedLocation == null) {
        _getCurrentLocation();
      } else if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _addPolygon(List<LatLng> points) {
    _validBoundaries.add(points);
    _polygonIdCounter++;
    final polygonId = PolygonId('ward_poly_$_polygonIdCounter');
    _wardPolygons.add(
      Polygon(
        polygonId: polygonId,
        points: points,
        fillColor: Colors.blue.withValues(alpha: 0.25),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ),
    );
  }

  bool get _isSelectionValid {
    if (_selectedLocation == null) return false;
    if (_validBoundaries.isEmpty) return true;
    return _isPointInPolygons(_selectedLocation!);
  }

  bool _isPointInPolygons(LatLng point) {
    for (final polygon in _validBoundaries) {
      if (_isPointInPolygon(point, polygon)) return true;
    }
    return false;
  }

  bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    bool isInside = false;
    for (int i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      if (((polygon[i].latitude > point.latitude) != (polygon[j].latitude > point.latitude)) &&
          (point.longitude < (polygon[j].longitude - polygon[i].longitude) * 
          (point.latitude - polygon[i].latitude) / (polygon[j].latitude - polygon[i].latitude) + polygon[i].longitude)) {
        isInside = !isInside;
      }
    }
    return isInside;
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => _isLoading = false);
      return;
    } 

    if (mounted) {
      setState(() {
        _hasLocationPermission = true;
      });
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _selectedLocation = LatLng(position.latitude, position.longitude);
          _isLoading = false;
        });
        
        if (_selectedLocation != null) {
          _moveCameraTo(_selectedLocation!, 15.0);
          _getAddressFromLatLng(_selectedLocation!);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _moveCameraTo(LatLng target, double zoom) async {
    if (_mapController.isCompleted) {
      final controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: zoom),
      ));
    }
  }

  Future<void> _zoomIn() async {
    if (_mapController.isCompleted) {
      final controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.zoomIn());
    }
  }

  Future<void> _zoomOut() async {
    if (_mapController.isCompleted) {
      final controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.zoomOut());
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialCenter = _selectedLocation ?? _wardCenter ?? const LatLng(20.5937, 78.9629);
    final initialZoom = (_selectedLocation != null || _wardCenter != null) ? 14.0 : 5.0;
    final bool isDesktop = !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.72,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    if (widget.selectedWard != null || widget.wardName != null)
                      Text(
                        'Ward: ${widget.selectedWard?.wardName ?? widget.wardName ?? ""}',
                        style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              isDesktop ? 'Enter latitude and longitude.' : 'Tap inside the geofenced area on the map to pin your location.',
              style: const TextStyle(fontSize: 12.5, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : isDesktop 
                    ? _buildDesktopFallback()
                    : Stack(
                        children: [
                          Positioned.fill(
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: initialCenter,
                                zoom: initialZoom,
                              ),
                              onMapCreated: (GoogleMapController controller) {
                                if (!_mapController.isCompleted) {
                                  _mapController.complete(controller);
                                }
                              },
                              onTap: (LatLng point) {
                                setState(() {
                                  _selectedLocation = point;
                                });
                                _getAddressFromLatLng(point);
                              },
                              polygons: _wardPolygons,
                              markers: _selectedLocation != null 
                                ? {
                                    Marker(
                                      markerId: const MarkerId('selected_loc'),
                                      position: _selectedLocation!,
                                    )
                                  } 
                                : {},
                              myLocationEnabled: _hasLocationPermission,
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                            ),
                          ),
                          Positioned(
                            right: 8,
                            bottom: 8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FloatingActionButton(
                                  mini: true,
                                  heroTag: "btn_myloc",
                                  backgroundColor: Theme.of(context).colorScheme.surface,
                                  onPressed: _getCurrentLocation,
                                  child: Icon(Icons.my_location, color: Theme.of(context).colorScheme.primary),
                                ),
                                const SizedBox(height: 8),
                                FloatingActionButton(
                                  mini: true,
                                  heroTag: "btn_zoomin",
                                  backgroundColor: Theme.of(context).colorScheme.surface,
                                  onPressed: _zoomIn,
                                  child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
                                ),
                                const SizedBox(height: 8),
                                FloatingActionButton(
                                  mini: true,
                                  heroTag: "btn_zoomout",
                                  backgroundColor: Theme.of(context).colorScheme.surface,
                                  onPressed: _zoomOut,
                                  child: Icon(Icons.remove, color: Theme.of(context).colorScheme.primary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 10),
            if (_selectedAddress != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isSelectionValid ? Colors.grey.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: _isSelectionValid ? Colors.teal : Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _isSelectionValid ? _selectedAddress! : 'You are out of the boundary.',
                        style: TextStyle(
                          fontSize: 12,
                          color: _isSelectionValid ? null : Colors.red,
                          fontWeight: _isSelectionValid ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (_isFetchingAddress)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: LinearProgressIndicator(),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSelectionValid ? Theme.of(context).colorScheme.primary : Colors.grey,
                  ),
                  onPressed: _isSelectionValid
                      ? () {
                          if (_selectedLocation != null) {
                            Navigator.pop(context, {
                              'location': _selectedLocation,
                              'address': _selectedAddress,
                              'pincode': _selectedPincode,
                            });
                          }
                        }
                      : null,
                  child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopFallback() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: Checkbox.width == 18 ? MainAxisAlignment.center : MainAxisAlignment.center,
          children: [
            const Icon(Icons.map, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              "Google Maps is not supported on this platform.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: const InputDecoration(
                labelText: "Latitude",
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (val) {
                final lat = double.tryParse(val);
                if (lat != null) {
                  setState(() {
                    _selectedLocation = LatLng(lat, _selectedLocation?.longitude ?? 0.0);
                  });
                  _getAddressFromLatLng(_selectedLocation!);
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: "Longitude",
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (val) {
                final lng = double.tryParse(val);
                if (lng != null) {
                  setState(() {
                    _selectedLocation = LatLng(_selectedLocation?.latitude ?? 0.0, lng);
                  });
                  _getAddressFromLatLng(_selectedLocation!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
