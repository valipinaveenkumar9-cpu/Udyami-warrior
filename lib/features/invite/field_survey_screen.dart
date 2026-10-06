import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'dart:io';
import 'dart:convert';
import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/services/api_service.dart';
import 'package:uk_circle_partners/core/utils/session_manager.dart';
import 'package:uk_circle_partners/core/models/ward_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class FieldSurveyScreen extends StatefulWidget {
  const FieldSurveyScreen({super.key});

  @override
  State<FieldSurveyScreen> createState() => _FieldSurveyScreenState();
}

class _FieldSurveyScreenState extends State<FieldSurveyScreen> {
  int _currentStep = 0;
  final int _totalSteps = 6; 
  bool _isSaving = false;

  // --- State for Step 1 ---
  File? _houseImage;
  final ImagePicker _picker = ImagePicker();

  // --- State for Step 2 ---
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  bool _isGettingLocation = false;
  
  // Geofence / Map variables
  List<WardModel> _allWards = [];
  List<String> _states = [];
  List<String> _districts = [];
  List<String> _talukas = [];
  List<WardModel> _wards = [];
  
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedTaluka;
  String? _selectedWardId;
  String? _selectedWardName;
  
  // Google Map states
  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? _selectedMapLocation;
  bool _isLoadingMap = false;
  final Set<Polygon> _wardPolygons = {};
  LatLng? _wardCenter;
  int _polygonIdCounter = 0;

  // --- State for Step 3 ---
  final TextEditingController _surveyNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // --- State for Step 4 ---
  String? _selectedLocationType;
  final List<Map<String, dynamic>> _locationTypes = [
    {'title': 'Empty Plot', 'icon': Icons.landscape_outlined},
    {'title': 'Residence', 'icon': Icons.home_outlined},
    {'title': 'Semi Residence', 'icon': Icons.house_siding_outlined},
    {'title': 'Building', 'icon': Icons.business_outlined},
    {'title': 'Commercial', 'icon': Icons.storefront_outlined},
    {'title': 'Industrial', 'icon': Icons.factory_outlined},
    {'title': 'Agricultural', 'icon': Icons.agriculture_outlined},
    {'title': 'Institutional', 'icon': Icons.account_balance_outlined},
    {'title': 'Mixed Use', 'icon': Icons.category_outlined},
    {'title': 'Others', 'icon': Icons.widgets_outlined},
  ];

  // --- State for Step 5 ---
  int _numberOfUpperFloors = 3;

  // --- State for Step 6 ---
  int _selectedFloorIndex = 0;
  List<Map<String, String?>> _floorDetails = [];

  @override
  void initState() {
    super.initState();
    _initFloorDetails();
    _fetchWards();
  }

  Future<void> _fetchWards() async {
    try {
      final response = await ApiService().getAllWards();
      if (response != null && response['success'] == true) {
        final List rawData = response['data'] ?? [];
        if (mounted) {
          setState(() {
            _allWards = rawData.map((w) => WardModel.fromJson(w as Map<String, dynamic>)).toList();
            _states = _allWards.map((w) => w.state).toSet().toList();
            _states.sort();
          });
        }
      }
    } catch (e) {
      print('Error fetching wards: $e');
    }
  }

  void _onStateChanged(String? state) {
    setState(() {
      _selectedState = state;
      _selectedDistrict = null;
      _selectedTaluka = null;
      _selectedWardId = null;
      _selectedWardName = null;
      
      _districts = _allWards.where((w) => w.state == state).map((w) => w.district).toSet().toList();
      _districts.sort();
      _talukas = [];
      _wards = [];
      
      _selectedMapLocation = null;
    });
  }

  void _onDistrictChanged(String? district) {
    setState(() {
      _selectedDistrict = district;
      _selectedTaluka = null;
      _selectedWardId = null;
      _selectedWardName = null;
      
      _talukas = _allWards.where((w) => w.district == district && w.state == _selectedState).map((w) => w.taluka).toSet().toList();
      _talukas.sort();
      _wards = [];
      
      _selectedMapLocation = null;
    });
  }

  void _onTalukaChanged(String? taluka) {
    setState(() {
      _selectedTaluka = taluka;
      _selectedWardId = null;
      _selectedWardName = null;
      
      _wards = _allWards.where((w) => w.taluka == taluka && w.district == _selectedDistrict && w.state == _selectedState).toList();
      _wards.sort((a, b) => a.wardName.compareTo(b.wardName));
      
      _selectedMapLocation = null;
    });
  }

  void _onWardChanged(String? wardId) {
    setState(() {
      _selectedWardId = wardId;
      if (wardId != null) {
        final selected = _wards.firstWhere((w) => w.wardId == wardId);
        _selectedWardName = selected.wardName;
        _fetchWardBoundaries(_selectedWardName!);
      } else {
        _selectedWardName = null;
      }
      _selectedMapLocation = null;
    });
  }

  Future<void> _fetchWardBoundaries(String wardName) async {
    setState(() {
      _isLoadingMap = true;
      _wardPolygons.clear();
      _wardCenter = null;
    });

    try {
      final response = await ApiService().getWardMap(wardName);
      if (response != null && response['success'] == true && response['data'] != null) {
        _parseWardPolygons(response['data']);
      }
    } catch (e) {
      print("DEV DEBUG - error fetching ward map dynamically: $e");
    }

    if (_wardPolygons.isNotEmpty && _wardCenter != null) {
      if (mounted) {
        setState(() {
          _isLoadingMap = false;
        });
        _moveCameraTo(_wardCenter!, 14.0);
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoadingMap = false;
        });
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
    }
  }

  void _addPolygon(List<LatLng> points) {
    _polygonIdCounter++;
    final polygonId = PolygonId('ward_poly_$_polygonIdCounter');
    _wardPolygons.add(
      Polygon(
        polygonId: polygonId,
        points: points,
        fillColor: Colors.blue.withValues(alpha: 0.15),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ),
    );
  }

  Future<void> _moveCameraTo(LatLng target, double zoom) async {
    if (_mapController.isCompleted) {
      final controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: zoom),
      ));
    }
  }

  void _initFloorDetails() {
    _floorDetails = List.generate(
      _numberOfUpperFloors + 1, // Ground + upper floors
      (index) => {
        'type': null,
        'ifResidential': null,
        'occupancyType': null,
      },
    );
  }

  void _updateFloorCount(int increment) {
    setState(() {
      int newCount = _numberOfUpperFloors + increment;
      if (newCount >= 0 && newCount <= 20) {
        _numberOfUpperFloors = newCount;
        
        // Adjust floor details list length
        int totalFloors = _numberOfUpperFloors + 1;
        if (_floorDetails.length < totalFloors) {
          while (_floorDetails.length < totalFloors) {
            _floorDetails.add({'type': null, 'ifResidential': null, 'occupancyType': null});
          }
        } else if (_floorDetails.length > totalFloors) {
          _floorDetails.removeRange(totalFloors, _floorDetails.length);
        }
        if (_selectedFloorIndex >= totalFloors) {
          _selectedFloorIndex = totalFloors - 1;
        }
      }
    });
  }

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    _surveyNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source != null) {
      try {
        final XFile? image = await _picker.pickImage(source: source);
        if (image != null) {
          setState(() {
            _houseImage = File(image.path);
          });
        }
      } catch (e) {
        debugPrint('Error picking image: $e');
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() { _isGettingLocation = false; });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() { _isGettingLocation = false; });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latController.text = position.latitude.toString();
        _lngController.text = position.longitude.toString();
        _isGettingLocation = false;
      });
    } catch (e) {
      setState(() { _isGettingLocation = false; });
      debugPrint('Error getting location: $e');
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _submitSurvey();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _submitSurvey() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final userId = SessionManager.user?['id'] ?? SessionManager.user?['userId'] ?? SessionManager.user?['_id'] ?? '';
      if (userId.isEmpty) {
        throw Exception('User ID is not found. Please log in again.');
      }

      if (_houseImage == null) {
        throw Exception('Please capture a House Image (Step 1) before submitting.');
      }

      List<Map<String, dynamic>> finalFloors = [];
      for (int i = 0; i < _floorDetails.length; i++) {
        if (_floorDetails[i]['type'] == null || _floorDetails[i]['type'] == 'Select Type') {
          throw Exception('Details are missing for ${i == 0 ? "Ground Floor" : "Floor $i"}. Please select each floor and provide its details.');
        }
        String? type = _floorDetails[i]['type'];
        String? occ = _floorDetails[i]['occupancyType'];
        
        String? finalResOcc;
        String? finalOccType;
        
        if (type == 'Commercial') {
          finalResOcc = null;
          finalOccType = 'OFFICE';
        } else {
          if (occ == 'Owner') {
            finalResOcc = 'OWNER_OCCUPIED';
            finalOccType = 'SELF OCCUPIED';
          } else if (occ == 'Tenant') {
            finalResOcc = 'RENTED';
            finalOccType = 'TENANT OCCUPIED';
          } else if (occ == 'Vacant') {
            finalResOcc = 'VACANT';
            finalOccType = 'VACANT';
          } else {
            finalResOcc = occ?.toUpperCase();
            finalOccType = occ?.toUpperCase();
          }
        }

        Map<String, dynamic> floor = {
          'floorNumber': i,
          'floorType': i == 0 ? 'GROUND' : 'UPPER',
          'usageType': type?.toUpperCase(),
          'residentialOccupancy': finalResOcc,
          'occupancyType': finalOccType,
        };
        
        finalFloors.add(floor);
      }

      await ApiService().submitSurveyData(
        cpUserId: userId,
        latitude: _latController.text.isNotEmpty ? _latController.text : '0.0',
        longitude: _lngController.text.isNotEmpty ? _lngController.text : '0.0',
        surveyNumber: _surveyNumberController.text,
        locationAddress: _addressController.text,
        locationType: _selectedLocationType?.toUpperCase() ?? 'UNKNOWN',
        numberOfFloors: _numberOfUpperFloors,
        floors: jsonEncode(finalFloors),
        houseImagePath: _houseImage?.path,
      );

      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Survey Submitted Successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  String get _currentFormattedDate {
    return DateFormat('dd MMM yyyy, h:mm a').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light.pageBackground,
      appBar: CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: Column(
        children: [
          // Header Status Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.light.secondaryText),
                    const SizedBox(width: 8),
                    Text(_currentFormattedDate, style: TextStyle(color: AppColors.light.secondaryText, fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: AppColors.light.redWarningDark),
                    const SizedBox(width: 4),
                    Text('Location not set', style: TextStyle(color: AppColors.light.redWarningDark, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          
          // Stepper Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: _buildStepperHeader(),
          ),
          const Divider(height: 1, thickness: 1),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildCurrentStepContent(),
            ),
          ),

          // Bottom Bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildStepperHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_totalSteps, (index) {
        bool isActive = index == _currentStep;
        bool isCompleted = index < _currentStep;
        String title = '';
        switch(index) {
          case 0: title = 'House\nImage'; break;
          case 1: title = 'Coordinates'; break;
          case 2: title = 'Survey No. &\nAddress'; break;
          case 3: title = 'Location\nType'; break;
          case 4: title = 'No. of\nFloors'; break;
          case 5: title = 'Floor-wise\nDetails'; break;
        }

        return Expanded(
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? AppColors.light.greenSuccess : (isCompleted ? AppColors.light.greenSuccess.withValues(alpha: 0.2) : Colors.white),
                  border: Border.all(color: isActive || isCompleted ? AppColors.light.greenSuccess : AppColors.light.disabledBorder, width: 2),
                ),
                alignment: Alignment.center,
                child: isCompleted 
                    ? Icon(Icons.check, size: 16, color: AppColors.light.greenSuccess)
                    : Text('${index + 1}', style: TextStyle(
                        color: isActive ? Colors.white : AppColors.light.secondaryText,
                        fontWeight: FontWeight.bold,
                      )),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: isActive ? AppColors.light.greenSuccess : AppColors.light.secondaryText,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStepTitle(String stepNumber, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.light.greenSuccess,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(stepNumber, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Text(subtitle, style: TextStyle(color: AppColors.light.secondaryText, fontSize: 14)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0: return _buildStep1();
      case 1: return _buildStep2();
      case 2: return _buildStep3();
      case 3: return _buildStep4();
      case 4: return _buildStep5();
      case 5: return _buildStep6();
      default: return const SizedBox.shrink();
    }
  }

  // --- Step 1: House Image ---
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('1', 'Capture House Image', 'Take a clear front-facing photo of the property'),
        
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.light.greenSuccess, width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(16),
            ),
            child: _houseImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(_houseImage!, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home_work, size: 80, color: AppColors.light.greenSuccess.withValues(alpha: 0.3)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.light.greenSuccess,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 32),
                      ),
                      const SizedBox(height: 16),
                      const Text('Tap to capture or upload', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Camera opens directly on mobile', style: TextStyle(color: AppColors.light.secondaryText, fontSize: 12)),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.light.disabledBorder),
          ),
          child: Row(
            children: [
              Icon(Icons.camera_alt_outlined, color: AppColors.light.greenSuccess),
              const SizedBox(width: 12),
              const Text('Tap to capture or upload', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.light.disabledBorder),
          ),
          child: Row(
            children: [
              Icon(Icons.phone_android, color: AppColors.light.greenSuccess),
              const SizedBox(width: 12),
              const Text('Camera opens directly on mobile', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  // --- Step 2: Location ---
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('2', 'Location (Latitude & Longitude)', 'Auto-fill from GPS or enter manually'),
        
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Latitude', style: TextStyle(color: AppColors.light.secondaryText, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _latController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      hintText: 'e.g. 12.9716',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.light.disabledBorder)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Longitude', style: TextStyle(color: AppColors.light.secondaryText, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _lngController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      hintText: 'e.g. 77.5946',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.light.disabledBorder)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _getCurrentLocation,
            icon: _isGettingLocation 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.my_location),
            label: const Text('Use current location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.light.greenSuccess,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(child: Text('Tap the button above to auto-detect coordinates.', style: TextStyle(color: AppColors.light.secondaryText, fontSize: 12))),
        
        const SizedBox(height: 32),
        const Text('Select Region', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 12),
        // Dropdowns for State, District, Taluka, Ward
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _selectedState,
                isExpanded: true,
                hint: const Text('State'),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _states.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: _onStateChanged,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _selectedDistrict,
                isExpanded: true,
                hint: const Text('District'),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: _onDistrictChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _selectedTaluka,
                isExpanded: true,
                hint: const Text('Taluka'),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _talukas.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: _onTalukaChanged,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _selectedWardId,
                isExpanded: true,
                hint: const Text('Ward'),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _wards.map((w) => DropdownMenuItem(value: w.wardId, child: Text(w.wardName))).toList(),
                onChanged: _onWardChanged,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        if (_selectedWardId != null) ...[
          const Text('Ward Map', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 8),
          const Text('Tap anywhere on the map to pin the exact location.', style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 12),
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.light.disabledBorder),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _isLoadingMap
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _wardCenter ?? const LatLng(20.5937, 78.9629),
                      zoom: _wardCenter != null ? 14.0 : 5.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      if (!_mapController.isCompleted) {
                        _mapController.complete(controller);
                      }
                    },
                    onTap: (LatLng point) {
                      setState(() {
                        _selectedMapLocation = point;
                        _latController.text = point.latitude.toStringAsFixed(6);
                        _lngController.text = point.longitude.toStringAsFixed(6);
                      });
                    },
                    polygons: _wardPolygons,
                    markers: _selectedMapLocation != null
                      ? {
                          Marker(
                            markerId: const MarkerId('selected_loc'),
                            position: _selectedMapLocation!,
                          )
                        }
                      : {},
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
            ),
          ),
        ] else ...[
          Center(
            child: Column(
              children: [
                Icon(Icons.map_outlined, size: 60, color: AppColors.light.greenSuccess.withValues(alpha: 0.5)),
                const SizedBox(height: 8),
                const Text('Select a ward to view map boundaries', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
        
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.light.disabledBorder),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on_outlined, color: AppColors.light.greenSuccess),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Location will appear here', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('Latitude & Longitude', style: TextStyle(color: AppColors.light.secondaryText, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Step 3: Survey Details ---
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('3', 'Survey Number / Location Details', 'Provide survey number and readable address'),
        
        Text('Survey Number', style: TextStyle(color: AppColors.light.secondaryText, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _surveyNumberController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.description_outlined),
            hintText: 'Enter survey number',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.light.disabledBorder)),
          ),
        ),
        const SizedBox(height: 24),
        
        Text('Location / Address', style: TextStyle(color: AppColors.light.secondaryText, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _addressController,
          maxLines: 4,
          decoration: InputDecoration(
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 60),
              child: Icon(Icons.location_on_outlined),
            ),
            hintText: 'Enter full location / address',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.light.disabledBorder)),
          ),
        ),
        const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('0/300', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
        ),
      ],
    );
  }

  // --- Step 4: Location Type ---
  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('4', 'Location Type', 'Select the type that best matches the property'),
        
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: _locationTypes.length,
          itemBuilder: (context, index) {
            final type = _locationTypes[index];
            final isSelected = _selectedLocationType == type['title'];
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedLocationType = type['title'];
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.light.greenSuccess : AppColors.light.disabledBorder,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(type['icon'], size: 32, color: isSelected ? AppColors.light.greenSuccess : AppColors.light.secondaryText),
                    const SizedBox(height: 8),
                    Text(
                      type['title'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.light.greenSuccess : AppColors.light.primaryDarkBlue,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // --- Step 5: Number of Floors ---
  Widget _buildStep5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('5', 'Number of Floors', 'Floors above ground level (Ground Floor is always included)'),
        
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.light.disabledBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _updateFloorCount(-1),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.light.greenSuccess.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.remove, color: AppColors.light.greenSuccess, size: 32),
                ),
              ),
              const SizedBox(width: 48),
              Column(
                children: [
                  Text('$_numberOfUpperFloors', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                  const Text('upper floors', style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(width: 48),
              GestureDetector(
                onTap: () => _updateFloorCount(1),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.light.greenSuccess.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: AppColors.light.greenSuccess, size: 32),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.light.greenSuccess.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$_numberOfUpperFloors -> Ground${List.generate(_numberOfUpperFloors, (i) => " + ${i + 1}${_getOrdinalSuffix(i + 1)}").join()}',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.light.greenSuccess, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }

  String _getOrdinalSuffix(int number) {
    if (number >= 11 && number <= 13) return 'th';
    switch (number % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }

  // --- Step 6: Floor-wise Details ---
  Widget _buildStep6() {
    int totalFloors = _numberOfUpperFloors + 1;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('6', 'Floor-wise Details', 'Rendered as a building structure - ground floor at the base'),
        
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side: Building Structure
            SizedBox(
              width: 100,
              child: Column(
                children: [
                  // Roof triangle
                  CustomPaint(
                    size: const Size(100, 30),
                    painter: RoofPainter(color: AppColors.light.disabledBorder),
                  ),
                  // Floors (Top to Bottom)
                  ...List.generate(totalFloors, (index) {
                    int invertedIndex = totalFloors - 1 - index;
                    bool isSelected = _selectedFloorIndex == invertedIndex;
                    String label = invertedIndex == 0 ? 'G' : '$invertedIndex';
                    String name = invertedIndex == 0 ? 'Ground Floor' : '$invertedIndex${_getOrdinalSuffix(invertedIndex)} Floor';
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFloorIndex = invertedIndex;
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.light.greenSuccess.withValues(alpha: 0.2) : Colors.white,
                          border: Border.all(
                            color: isSelected ? AppColors.light.greenSuccess : AppColors.light.disabledBorder,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isSelected ? AppColors.light.greenSuccess : AppColors.light.primaryDarkBlue)),
                            const SizedBox(width: 8),
                            Expanded(child: Text(name, style: TextStyle(fontSize: 10, color: AppColors.light.secondaryText), overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),
                    );
                  }),
                  // Base line
                  Container(height: 4, width: 120, color: AppColors.light.greenSuccess),
                ],
              ),
            ),
            const SizedBox(width: 16),
            
            // Right Side: Details Form
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.light.greenSuccess,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _selectedFloorIndex == 0 ? 'Ground Floor' : '$_selectedFloorIndex${_getOrdinalSuffix(_selectedFloorIndex)} Floor',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildDropdown(
                    label: 'Commercial / Residential',
                    value: _floorDetails[_selectedFloorIndex]['type'],
                    items: const ['Select Type', 'Commercial', 'Residential', 'Mixed'],
                    onChanged: (val) {
                      setState(() {
                        _floorDetails[_selectedFloorIndex]['type'] = val == 'Select Type' ? null : val;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  _buildDropdown(
                    label: 'If Residential',
                    value: _floorDetails[_selectedFloorIndex]['ifResidential'],
                    items: const ['Select', 'Family', 'Bachelors', 'Students', 'PG', 'Others'],
                    onChanged: (val) {
                      setState(() {
                        _floorDetails[_selectedFloorIndex]['ifResidential'] = val == 'Select' ? null : val;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  _buildDropdown(
                    label: 'Occupancy Type',
                    value: _floorDetails[_selectedFloorIndex]['occupancyType'],
                    items: const ['Select', 'Owner', 'Tenant', 'Vacant'],
                    onChanged: (val) {
                      setState(() {
                        _floorDetails[_selectedFloorIndex]['occupancyType'] = val == 'Select' ? null : val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        Center(
          child: TextButton.icon(
            onPressed: () {
              // Add a custom floor logic if needed
            },
            icon: Icon(Icons.add, color: AppColors.light.greenSuccess),
            label: Text('+ Add another floor (terrace, mezzanine, etc.)', style: TextStyle(color: AppColors.light.greenSuccess, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({required String label, required String? value, required List<String> items, required Function(String?) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColors.light.primaryDarkBlue, fontWeight: FontWeight.w500, fontSize: 12)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.light.disabledBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value ?? items.first,
              icon: const Icon(Icons.keyboard_arrow_down),
              style: TextStyle(color: AppColors.light.primaryDarkBlue),
              onChanged: onChanged,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: TextStyle(color: item == items.first && value == null ? Colors.grey : AppColors.light.primaryDarkBlue)),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // --- Bottom Navigation Bar ---
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(color: AppColors.light.pageBackground, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Icon(Icons.save_outlined, size: 20, color: AppColors.light.primaryDarkBlue),
                      const SizedBox(width: 8),
                      Expanded(child: Text('Drafts saved to your device only.', style: TextStyle(fontSize: 10, color: AppColors.light.secondaryText))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(color: AppColors.light.orangeLight, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Icon(Icons.bar_chart, size: 20, color: AppColors.light.orangeWarning),
                      const SizedBox(width: 8),
                      Expanded(child: Text('0 surveys submitted today (shared across surveyors)', style: TextStyle(fontSize: 10, color: AppColors.light.orangeDark))),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _prevStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: AppColors.light.greenSuccess),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, color: AppColors.light.greenSuccess, size: 18),
                      const SizedBox(width: 8),
                      Text('Back', style: TextStyle(color: AppColors.light.greenSuccess, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isSaving ? null : (_currentStep == _totalSteps - 1 ? _submitSurvey : _nextStep),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.light.greenSuccess,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isSaving 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_currentStep == _totalSteps - 1 ? 'Submit Survey' : 'Next', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(width: 8),
                            if (_currentStep < _totalSteps - 1)
                              const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RoofPainter extends CustomPainter {
  final Color color;

  RoofPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Path path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();

    Paint fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
