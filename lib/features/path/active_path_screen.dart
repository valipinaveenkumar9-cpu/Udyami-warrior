import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uk_circle_partners/core/services/api_service.dart';
import 'package:uk_circle_partners/core/services/background_location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/thems/app_colors.dart';
import '../../core/utils/session_manager.dart';
import '../invite/finish_path_screen.dart';
import '../invite/field_survey_screen.dart';

class ActivePathScreen extends StatefulWidget {
  final Map<String, dynamic> routeData;

  const ActivePathScreen({super.key, required this.routeData});

  @override
  State<ActivePathScreen> createState() => _ActivePathScreenState();
}

class _ActivePathScreenState extends State<ActivePathScreen> {
  final ApiService _apiService = ApiService();
  final BackgroundLocationService _bgLocationService = BackgroundLocationService();
  
  // Get real ID from session instead of hardcoded dummy
  final String _channelPartnerId = SessionManager.user?['id'] ?? SessionManager.user?['userId'] ?? SessionManager.user?['_id'] ?? '';
  String? _currentRouteId;
  bool _isLoading = true;
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  
  final List<LatLng> _fullRoutePoints = [];
  LatLngBounds? _routeBounds;
  Timer? _pollingTimer;
  Map<String, dynamic>? _trackingData;
  BitmapDescriptor? _bikeIcon;
  BitmapDescriptor? _startIcon;
  BitmapDescriptor? _endIcon;
  double _currentBearing = 0.0;
  LatLng? _lastLocation;

  @override
  void initState() {
    super.initState();
    _loadIcons();
    _parseRouteData();
    _initJourney();
  }

  Future<void> _loadIcons() async {
    _startIcon = await _createCircleIcon(const Color(0xFF1E7A54), 40.0);
    _endIcon = await _createCircleIcon(const Color(0xFFD32F2F), 40.0);
    _bikeIcon = await _createRapidoBikeIcon();
    if (mounted) setState(() {});
  }

  Future<BitmapDescriptor> _createCircleIcon(Color color, double size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = color;
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.15;
      
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, borderPaint);

    final ui.Image image = await pictureRecorder.endRecording().toImage(size.toInt(), size.toInt());
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> _createRapidoBikeIcon() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final double targetSize = 70.0; // Reduced size for map marker
    final double originalSize = 120.0;
    final double center = originalSize / 2;

    canvas.scale(targetSize / originalSize);

    // Draw shadow
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center, center), width: 45, height: 90),
        const Radius.circular(10)
      ),
      shadowPaint,
    );

    // Bike Body (chassis/seat)
    final Paint bikePaint = Paint()..color = Colors.red.shade700;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center, center + 5), width: 22, height: 75),
        const Radius.circular(5)
      ),
      bikePaint,
    );

    // Front Wheel (black, protruding upwards since bearing 0 is North/Up)
    final Paint wheelPaint = Paint()..color = Colors.black87;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center, center - 40), width: 8, height: 25),
        const Radius.circular(2)
      ),
      wheelPaint,
    );

    // Rear Wheel
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center, center + 45), width: 10, height: 25),
        const Radius.circular(2)
      ),
      wheelPaint,
    );

    // Handlebars
    final Paint handlePaint = Paint()..color = Colors.grey.shade300;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center, center - 25), width: 45, height: 5),
        const Radius.circular(2)
      ),
      handlePaint,
    );

    // Rider Shoulders
    final Paint shoulderPaint = Paint()..color = Colors.blueGrey.shade800;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center, center + 8), width: 40, height: 25),
        const Radius.circular(12)
      ),
      shoulderPaint,
    );

    // Helmet (Rapido Yellow)
    final Paint helmetPaint = Paint()..color = const Color(0xFFFFC107);
    canvas.drawCircle(Offset(center, center), 18, helmetPaint);

    // Helmet Visor (black, pointing forward/up)
    final Paint visorPaint = Paint()..color = Colors.black87;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center, center - 12), width: 22, height: 8),
        const Radius.circular(4)
      ),
      visorPaint,
    );

    final ui.Image image = await pictureRecorder.endRecording().toImage(targetSize.toInt(), targetSize.toInt());
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }

  double _calculateBearing(LatLng start, LatLng end) {
    double startLat = start.latitude * pi / 180;
    double startLng = start.longitude * pi / 180;
    double endLat = end.latitude * pi / 180;
    double endLng = end.longitude * pi / 180;

    double dLng = endLng - startLng;

    double y = sin(dLng) * cos(endLat);
    double x = cos(startLat) * sin(endLat) - sin(startLat) * cos(endLat) * cos(dLng);

    double bearing = atan2(y, x) * 180 / pi;
    return (bearing + 360) % 360;
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _parseRouteData() {
    try {
      if (widget.routeData['routePath'] != null && widget.routeData['routePath']['coordinates'] != null) {
        List<dynamic> coords = widget.routeData['routePath']['coordinates'];
        
        double minLat = 90.0;
        double maxLat = -90.0;
        double minLng = 180.0;
        double maxLng = -180.0;

        for (var coord in coords) {
          // GeoJSON is [longitude, latitude]
          double lng = (coord[0] as num).toDouble();
          double lat = (coord[1] as num).toDouble();
          LatLng point = LatLng(lat, lng);
          _fullRoutePoints.add(point);
          
          if (lat < minLat) minLat = lat;
          if (lat > maxLat) maxLat = lat;
          if (lng < minLng) minLng = lng;
          if (lng > maxLng) maxLng = lng;
        }

        if (_fullRoutePoints.isNotEmpty) {
          _routeBounds = LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          );

          _updateMapOverlays();
        }
      }
    } catch (e) {
      print("Error parsing route data: $e");
    }
  }

  void _updateMapOverlays() {
    _polylines.clear();
    _markers.clear();

    String journeyStatus = _trackingData?['route']?['status'] ?? widget.routeData['status'] ?? 'Assigned';
    LatLng? currentLocation;

    if (_trackingData != null && _trackingData!['currentLocation'] != null) {
      var curr = _trackingData!['currentLocation'];
      currentLocation = LatLng(double.parse(curr['latitude'].toString()), double.parse(curr['longitude'].toString()));
    } else if (_fullRoutePoints.isNotEmpty) {
      if (journeyStatus == 'Completed') {
        currentLocation = _fullRoutePoints.last;
      } else {
        currentLocation = _fullRoutePoints.first;
      }
    }

    if (_fullRoutePoints.isNotEmpty) {
      if (journeyStatus == 'Completed') {
        // Entire route is green
        _polylines.add(Polyline(
          polylineId: const PolylineId('covered_route'),
          points: _fullRoutePoints,
          color: const Color(0xFF1E7A54), // Green
          width: 6,
          jointType: JointType.round,
          endCap: Cap.roundCap,
          startCap: Cap.roundCap,
        ));
      } else {
        int closestIndex = 0;
        if (currentLocation != null) {
          double minDistance = double.infinity;
          for (int i = 0; i < _fullRoutePoints.length; i++) {
            double dist = _calculateDistance(currentLocation, _fullRoutePoints[i]);
            if (dist < minDistance) {
              minDistance = dist;
              closestIndex = i;
            }
          }
        }

        List<LatLng> coveredPoints = _fullRoutePoints.sublist(0, closestIndex + 1);
        List<LatLng> remainingPoints = _fullRoutePoints.sublist(closestIndex);

        if (coveredPoints.length > 1) {
          _polylines.add(Polyline(
            polylineId: const PolylineId('covered_route'),
            points: coveredPoints,
            color: const Color(0xFF1E7A54), // Green for covered assigned path
            width: 6,
            jointType: JointType.round,
            endCap: Cap.roundCap,
            startCap: Cap.roundCap,
          ));
        }

        if (remainingPoints.length > 1) {
          _polylines.add(Polyline(
            polylineId: const PolylineId('remaining_route'),
            points: remainingPoints,
            color: const Color(0xFF2563EB), // Blue for remaining assigned path
            width: 6,
            jointType: JointType.round,
            endCap: Cap.roundCap,
            startCap: Cap.roundCap,
          ));
        }
      }
    }

    // Add start and end markers
    if (_fullRoutePoints.isNotEmpty) {
      _markers.add(
        Marker(
          markerId: const MarkerId('start_point'),
          position: _fullRoutePoints.first,
          icon: _startIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'Start'),
          anchor: const Offset(0.5, 0.5),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('end_point'),
          position: _fullRoutePoints.last,
          icon: _endIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'End'),
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }

    // Current location marker
    if (currentLocation != null) {
      if (_lastLocation != null && _lastLocation != currentLocation) {
        _currentBearing = _calculateBearing(_lastLocation!, currentLocation);
      }
      _lastLocation = currentLocation;

      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: currentLocation,
          icon: _bikeIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          infoWindow: const InfoWindow(title: 'You'),
          anchor: const Offset(0.5, 0.5),
          rotation: _currentBearing,
          flat: true,
        ),
      );
      
      // Animate the camera to follow the moving bike
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentLocation,
          zoom: 17.0,
          bearing: 0, // Keep map facing North, let the bike rotate
        )
      ));
    }

    if (mounted) setState(() {});
  }

  Future<void> _startJourney() async {
    setState(() => _isLoading = true);
    if (_currentRouteId != null && _channelPartnerId.isNotEmpty) {
      await _apiService.startJourney(_currentRouteId!, _channelPartnerId);
      setState(() {
        widget.routeData['status'] = 'Started';
      });

      // Send initial GPS coordinate immediately to prevent 400 Bad Request on quick completion
      try {
        Position? position;
        try {
          position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high, timeLimit: const Duration(seconds: 3));
        } catch (_) {
          position = await Geolocator.getLastKnownPosition();
        }
        
        if (position != null) {
          final prefs = await SharedPreferences.getInstance();
          List<dynamic> traversed = [];
          traversed.add([position.longitude, position.latitude]);
          await prefs.setString('bg_traversed_coords', jsonEncode(traversed));
          
          await _apiService.updateLiveLocation(
            routeId: _currentRouteId!,
            channelPartnerId: _channelPartnerId,
            latitude: position.latitude,
            longitude: position.longitude,
            accuracy: position.accuracy,
            speed: position.speed,
            battery: 100.0,
          );
        }
      } catch (e) {
        print("Initial GPS fetch failed: $e");
      }

      await _fetchTrackingData();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _initJourney() async {
    _currentRouteId = widget.routeData['routeId'];
    
    // Start tracking immediately even before 'Start Journey' is clicked
    if (_currentRouteId != null && _channelPartnerId.isNotEmpty && widget.routeData['routePath'] != null && widget.routeData['routePath']['coordinates'] != null) {
      List<dynamic> rawCoords = widget.routeData['routePath']['coordinates'];
      await _bgLocationService.startTracking(_currentRouteId!, _channelPartnerId, rawCoords);
    }
    
    // 3. Start polling trackCPRoute
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchTrackingData();
    });
    // Fetch immediately too
    await _fetchTrackingData();
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchTrackingData() async {
    if (_channelPartnerId.isEmpty) return;
    
    try {
      final backendData = await _apiService.trackCPRoute(_channelPartnerId);
      if (backendData != null && 
          backendData['data'] != null && 
          backendData['data']['route'] != null && 
          backendData['data']['route']['routeId'] == _currentRouteId) {
        _trackingData = backendData['data'];
      } else {
        // Fallback to local storage if API fails or hasn't started yet
        final prefs = await SharedPreferences.getInstance();
        await prefs.reload();
        
        List<Map<String, dynamic>> localHistory = [];
        final bgRouteId = prefs.getString('bg_route_id'); // Match the key from BackgroundLocationService
        
        // Only load the local tracking coords if they belong to this exact route
        if (bgRouteId == _currentRouteId) {
          final traversedStr = prefs.getString('bg_traversed_coords') ?? '[]';
          List<dynamic> traversed = jsonDecode(traversedStr);
          for (var pt in traversed) {
            localHistory.add({
              'longitude': pt[0],
              'latitude': pt[1],
              'isOnRoute': true, // default fallback
            });
          }
        }
        
        String journeyStatus = widget.routeData['status'] ?? 'Assigned';
        
        Map<String, dynamic>? currentLoc;
        if (localHistory.isNotEmpty) {
          currentLoc = localHistory.last;
        } else {
          // If no history, try to get live location to show the bike before starting
          try {
            Position? pos = await Geolocator.getLastKnownPosition();
            if (pos != null) {
              currentLoc = {
                'latitude': pos.latitude,
                'longitude': pos.longitude,
              };
            }
          } catch (_) {}
        }

        _trackingData = {
          'route': {'routeId': _currentRouteId, 'status': journeyStatus},
          'trackingHistory': localHistory,
          'currentLocation': currentLoc,
        };
      }

      _updateMapOverlays();
      if (mounted) {
        setState(() {}); // Trigger a rebuild to reflect updated overlays and markers
      }
    } catch (e) {
      print("Error polling tracking data locally: $e");
    }
  }

  double _calculateDistance(LatLng p1, LatLng p2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((p2.latitude - p1.latitude) * p) / 2 + 
          c(p1.latitude * p) * c(p2.latitude * p) * 
          (1 - c((p2.longitude - p1.longitude) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  Future<void> _handleCheckOut() async {
    if (_currentRouteId != null && _channelPartnerId.isNotEmpty) {
      // 1. Complete Journey API
      bool success = await _apiService.completeJourney(_currentRouteId!, _channelPartnerId);
      
      if (success) {
        _pollingTimer?.cancel();
        
        // Stop the background live tracking sending from app to backend once the journey completes
        await _bgLocationService.stopTracking();
        // NOTE: The always sending live tracking behavior was previously here (by omitting the stopTracking call).
        // It is commented out conceptually; if you need live tracking to continue after completion in the future,
        // simply comment out the `await _bgLocationService.stopTracking();` line above.

        // 3. Update local state
        setState(() {
          widget.routeData['status'] = 'Completed';
        });
        await _fetchTrackingData();
        
        if (mounted) {
          // Calculate total distance
          double totalDist = 0;
          for (int i = 0; i < _fullRoutePoints.length - 1; i++) {
            totalDist += _calculateDistance(_fullRoutePoints[i], _fullRoutePoints[i+1]);
          }
          
          // Calculate traveled distance
          double traveledDist = 0;
          List<LatLng> covered = [];
          if (_trackingData != null && _trackingData!['trackingHistory'] != null) {
            List<dynamic> history = _trackingData!['trackingHistory'];
            for (var p in history) {
              covered.add(LatLng(double.parse(p['latitude'].toString()), double.parse(p['longitude'].toString())));
            }
          }
          for (int i = 0; i < covered.length - 1; i++) {
            traveledDist += _calculateDistance(covered[i], covered[i+1]);
          }
        
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FinishPathScreen(
              routeName: widget.routeData['routeName'] ?? 'Unknown Route',
              traveledDistanceMeters: traveledDist * 1000,
              totalDistanceMeters: totalDist * 1000,
            )),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to complete journey. Ensure you wait at least 5 seconds after starting so GPS data is logged.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final routeName = widget.routeData['routeName'] ?? 'Unknown Route';
    String journeyStatus = _trackingData?['route']?['status'] ?? widget.routeData['status'] ?? 'Assigned';
    // Fallback position if route parsing failed
    final LatLng initialPosition = _fullRoutePoints.isNotEmpty ? _fullRoutePoints.first : const LatLng(12.9716, 77.5946);

    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      appBar: AppBar(
        backgroundColor: context.colors.cardBackground,
        foregroundColor: context.colors.primaryDarkBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active: $routeName',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.colors.primaryDarkBlue,
                    ),
                  ),
                  Text(
                    'Checked in just now',
                    style: TextStyle(
                      fontSize: 12,
                      color: context.colors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFDE8E8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'REC',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: context.colors.redWarningDark,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Offline Status Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: context.colors.lightGreyBlue,
            child: Row(
              children: [
                Icon(Icons.wifi_off, size: 16, color: context.colors.primaryDarkBlue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tracking live location every 5s',
                    style: TextStyle(fontSize: 13, color: context.colors.primaryDarkBlue),
                  ),
                ),
              ],
            ),
          ),

          // Map area
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.60,
            width: double.infinity,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: initialPosition,
                    zoom: 16.0,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    if (_routeBounds != null) {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        _mapController?.animateCamera(
                          CameraUpdate.newLatLngBounds(_routeBounds!, 50.0),
                        );
                      });
                    }
                  },
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),
                // Badge
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: context.colors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: context.colors.defaultText.withValues(alpha: 0.1), blurRadius: 4),
                      ],
                    ),
                    child: Text(
                      'Inside path area · GPS good',
                      style: TextStyle(fontSize: 12, color: context.colors.primaryDarkBlue, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                // Beat Tracker
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.colors.lightGreyBlue),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'THIS STOP',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: context.colors.chartAxis),
                          ),
                          Text(
                            '#13 of 34',
                            style: TextStyle(fontSize: 14, color: Color(0xFF3D4B60), fontWeight: FontWeight.w600, fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 42,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildBar('done'),
                            _buildBar('done'),
                            _buildBar('ref'),
                            _buildBar('done'),
                            _buildBar('done'),
                            _buildBar('na'),
                            _buildBar('done'),
                            _buildBar('done'),
                            _buildBar('ref'),
                            _buildBar('done'),
                            _buildBar('na'),
                            _buildBar('done'),
                            _buildBar('now'),
                            _buildBar('empty'),
                            _buildBar('empty'),
                            _buildBar('empty'),
                            _buildBar('empty'),
                            _buildBar('empty'),
                          ],
                        ),
                      ),
                      // Axis
                      Stack(
                        children: [
                          Positioned(left: 0, right: 0, top: 0, child: Container(height: 1, color: const Color(0xFF93A7C6))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTickColumn('0', CrossAxisAlignment.start),
                              _buildTickColumn('400 m', CrossAxisAlignment.center),
                              _buildTickColumn('800 m', CrossAxisAlignment.center),
                              _buildTickColumn('1.2 km', CrossAxisAlignment.end),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Mark Stop Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.colors.lightGreyBlue),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MARK THIS STOP',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: context.colors.chartAxis),
                      ),
                      const SizedBox(height: 16),
                        Row(
                        children: [
                          Expanded(child: _buildSegmentButton('Not home')),
                          const SizedBox(width: 8),
                          Expanded(child: _buildSegmentButton('Refused')),
                          const SizedBox(width: 8),
                          Expanded(child: _buildSegmentButton('Come back')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Actions
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.cardBackground,
              border: Border(top: BorderSide(color: context.colors.lightGreyBlue)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (journeyStatus == 'Assigned' || journeyStatus == 'Pending' || journeyStatus == 'Upcoming')
                  /*
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CreateInviteFormScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.primaryDarkBlue,
                        foregroundColor: context.colors.cardBackground,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.build, size: 20),
                      label: const Text('Create Form Schema', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  */
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _startJourney,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.primaryDarkBlue,
                        foregroundColor: context.colors.cardBackground,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.play_arrow, size: 20),
                      label: const Text('Start Journey', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                  ),
                if (journeyStatus == 'Started' || journeyStatus == 'In Progress' || journeyStatus == 'Active') ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FieldSurveyScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.greenSuccess,
                        foregroundColor: context.colors.cardBackground,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.assignment, size: 20),
                      label: const Text('Fill Invite Form', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _handleCheckOut,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.redWarningDark,
                        foregroundColor: context.colors.cardBackground,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.stop, size: 20),
                      label: const Text('End Journey', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                  ),
                ],
                if (journeyStatus == 'Completed')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.lightGreyBlue,
                        foregroundColor: context.colors.secondaryText,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.check_circle, size: 20),
                      label: const Text('Journey Completed', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFD3DDEA)),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, color: Color(0xFF16233A), fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildBar(String status) {
    Color? color;
    Color? borderColor;
    double height = 24;
    bool isYou = status == 'now';

    switch (status) {
      case 'done':
        color = const Color(0xFF2C4470);
        break;
      case 'ref':
        color = Colors.white;
        borderColor = const Color(0xFFC4362E);
        break;
      case 'na':
        color = const Color(0xFFDAE0EA);
        break;
      case 'now':
        color = const Color(0xFFF2A93B);
        height = 32;
        break;
      case 'empty':
      default:
        color = const Color(0xFFB1C0D6);
        break;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isYou)
              CustomPaint(
                size: const Size(8, 6),
                painter: _TrianglePainter(color: color),
              ),
            if (isYou) const SizedBox(height: 2),
            Container(
              height: height,
              decoration: BoxDecoration(
                color: color,
                border: borderColor != null
                    ? Border.all(color: borderColor, width: 1.5)
                    : null,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTickColumn(String label, CrossAxisAlignment alignment) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(width: 1, height: 6, color: const Color(0xFF93A7C6)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF93A7C6), fontFamily: 'monospace'),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
