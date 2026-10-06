import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uk_circle_partners/core/models/ward_model.dart';
import 'package:uk_circle_partners/core/utils/session_manager.dart';
import '../../data/cloud_patra_api.dart';
import '../../data/expo_ambassador_api.dart';
import '../widgets/map_selection_modal.dart';
import 'package:uk_circle_partners/features/home/presentation/main_screen.dart';

class _FormColors {
  static const Color ink = Color(0xFF1E2A44);
  static const Color inkSoft = Color(0xFF3E4A63);
  static const Color paper = Color(0xFFF3EEDD);
  static const Color paperAlt = Color(0xFFFBF8EE);
  static const Color seal = Color(0xFF0E5C4A);
  static const Color sealDark = Color(0xFF0A4438);
  static const Color sealTint = Color(0xFFE3ECE5);
  static const Color stamp = Color(0xFFA13D2E);
  static const Color gold = Color(0xFFA9791F);
  static const Color goldTint = Color(0xFFF1E7CC);
  static const Color line = Color(0xFFD9D0B8);
  static const Color muted = Color(0xFF7A7360);
  static const Color disabled = Color(0xFFECE6D3);
  static const Color saffron = Color(0xFFE67722);
}

class ExpoAmbassadorForm extends StatefulWidget {
  final String companyName;
  final Function(String applicationId)? onSubmitted;

  const ExpoAmbassadorForm({
    super.key,
    this.companyName = 'EXPO Ambassador',
    this.onSubmitted,
  });

  @override
  State<ExpoAmbassadorForm> createState() => _ExpoAmbassadorFormState();
}

class _ExpoAmbassadorFormState extends State<ExpoAmbassadorForm> {
  // Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  // Selected values
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedTaluk;
  String? _selectedWardName;
  String? _selectedWardId;
  String? _selectedAvailability;
  List<String> _selectedLanguages = [];
  String? _selectedExperience;
  LatLng? _selectedLatLng;

  bool _consentChecked = false;
  bool _isSubmitting = false;
  bool _isLoadingMap = false;
  String? _submittedAppId;

  // Status stage for submitted application (Dynamically updated via EXPO Ambassador Ward Chairman API)
  String _currentStatusStage = 'SUBMITTED'; // 'SUBMITTED', 'UNDER_CONSIDERATION', 'APPROVED', 'REJECTED'

  final Map<String, String> _errors = {};

  // API Wards Data
  List<WardModel> _allWards = [];
  List<String> _apiStates = [];
  final Map<String, List<String>> _apiDistricts = {};
  final Map<String, List<String>> _apiTaluks = {};

  final List<String> _availabilityOptions = [
    "Weekends only",
    "Weekdays only",
    "Full-time during expos",
    "Flexible"
  ];

  final List<String> _languageOptions = [
    "English", "Hindi", "Kannada", "Telugu", "Tamil", "Malayalam", "Marathi", "Bengali", "Gujarati", "Punjabi", "Odia", "Urdu", "Other"
  ];

  final List<String> _experienceOptions = [
    "None",
    "Less than 1 year",
    "1–3 years",
    "3+ years"
  ];

  String get _verifiedMobile {
    final user = SessionManager.user;
    final mobile = user?['mobileNumber'] ?? user?['mobile'] ?? user?['phone'] ?? '7349625941';
    return mobile.toString();
  }

  @override
  void initState() {
    super.initState();
    try {
      final uid = SessionManager.userId;
      final savedId = uid != null 
          ? (SessionManager.getString('last_submitted_expo_app_id_$uid') ?? SessionManager.getString('last_submitted_expo_app_id'))
          : SessionManager.getString('last_submitted_expo_app_id');
      if (savedId != null && savedId.isNotEmpty) {
        _submittedAppId = savedId;
      }
    } catch (_) {}

    _fetchWardData();
    _fetchApplicationStatus();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _areaController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _fetchWardData() async {
    try {
      final res = await CloudPatraApi.getAllWards();
      if (res != null && res['data'] != null) {
        final List<dynamic> rawList = res['data'] is List ? res['data'] : [];
        final Map<String, Set<String>> distMap = {};
        final Map<String, Set<String>> talukMap = {};
        final Set<String> states = {};
        final List<WardModel> loadedWards = [];

        for (var item in rawList) {
          if (item is Map<String, dynamic>) {
            final ward = WardModel.fromJson(item);
            loadedWards.add(ward);
            if (ward.state.isNotEmpty) {
              states.add(ward.state);
              if (ward.district.isNotEmpty) {
                distMap.putIfAbsent(ward.state, () => {}).add(ward.district);
                if (ward.taluka.isNotEmpty) {
                  talukMap.putIfAbsent(ward.district, () => {}).add(ward.taluka);
                }
              }
            }
          }
        }

        if (mounted) {
          setState(() {
            _allWards = loadedWards;
            if (states.isNotEmpty) {
              _apiStates = states.toList()..sort();
              distMap.forEach((k, v) {
                _apiDistricts[k] = v.toList()..sort();
              });
              talukMap.forEach((k, v) {
                _apiTaluks[k] = v.toList()..sort();
              });
            }
          });
        }
      }
    } catch (_) {}
  }

  Future<void> _fetchApplicationStatus() async {
    try {
      final uid = SessionManager.userId;
      final mobile = _verifiedMobile;

      if (_submittedAppId == null) {
        try {
          final savedId = (uid != null ? SessionManager.getString('last_submitted_expo_app_id_$uid') : null) ??
              (mobile.isNotEmpty ? SessionManager.getString('last_submitted_expo_app_id_$mobile') : null);
          if (savedId != null && savedId.isNotEmpty) {
            setState(() {
              _submittedAppId = savedId;
            });
          }
        } catch (_) {}
      }

      final res = await ExpoAmbassadorApi.getMyApplications();
      if (res.success && res.data != null && res.data!.isNotEmpty) {
        final apps = res.data!;
        dynamic myApp;
        if (_submittedAppId != null) {
          try {
            myApp = apps.firstWhere(
              (app) =>
                  app['applicationNumber'] == _submittedAppId ||
                  app['applicationId'] == _submittedAppId ||
                  app['_id'] == _submittedAppId ||
                  app['id'] == _submittedAppId,
            );
          } catch (_) {}
        }

        myApp ??= apps.firstWhere(
          (app) => (app['programType'] ?? '').toString().toUpperCase() == 'EXPO_AMBASSADOR',
          orElse: () => null,
        );

        if (myApp != null) {
          final appId = (myApp['applicationNumber'] ?? myApp['applicationId'] ?? myApp['_id'] ?? myApp['id']).toString();
          
          if (mounted) {
            setState(() {
              _submittedAppId = appId;
              if (myApp['fullName'] != null) _fullNameController.text = myApp['fullName'].toString();
              if (myApp['email'] != null) _emailController.text = myApp['email'].toString();
              if (myApp['taluk'] != null) _selectedTaluk = myApp['taluk'].toString();
              if (myApp['district'] != null) _selectedDistrict = myApp['district'].toString();
              if (myApp['availability'] != null) _selectedAvailability = myApp['availability'].toString();
              if (myApp['languages'] != null && myApp['languages'] is List) {
                _selectedLanguages = (myApp['languages'] as List).map((e) => e.toString()).toList();
              }
            });
          }

          try {
            if (uid != null) {
              await SessionManager.setString('last_submitted_expo_app_id_$uid', appId);
            }
            if (mobile.isNotEmpty) {
              await SessionManager.setString('last_submitted_expo_app_id_$mobile', appId);
            }
          } catch (_) {}

          final rawStatus = (myApp['status'] ?? myApp['applicationStatus'] ?? myApp['approvalStatus'] ?? '').toString().toUpperCase();

          if (mounted) {
            setState(() {
              if (rawStatus.contains('APPROV') || rawStatus.contains('ACCEPT') || rawStatus.contains('ACTIVE')) {
                _currentStatusStage = 'APPROVED';
              } else if (rawStatus.contains('REJECT') || rawStatus.contains('DECLIN') || rawStatus.contains('DENIED')) {
                _currentStatusStage = 'REJECTED';
              } else if (rawStatus.contains('CONSIDER') || rawStatus.contains('REVIEW') || rawStatus.contains('IN_PROGRESS')) {
                _currentStatusStage = 'UNDER_CONSIDERATION';
              } else {
                _currentStatusStage = 'SUBMITTED';
              }
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _submittedAppId = null;
              _currentStatusStage = 'SUBMITTED';
            });
          }
          try {
            if (uid != null) await SessionManager.remove('last_submitted_expo_app_id_$uid');
            if (mobile.isNotEmpty) await SessionManager.remove('last_submitted_expo_app_id_$mobile');
          } catch (_) {}
        }
      } else {
        if (mounted) {
          setState(() {
            _submittedAppId = null;
            _currentStatusStage = 'SUBMITTED';
          });
        }
        try {
          if (uid != null) await SessionManager.remove('last_submitted_expo_app_id_$uid');
          if (mobile.isNotEmpty) await SessionManager.remove('last_submitted_expo_app_id_$mobile');
        } catch (_) {}
      }
    } catch (e) {
      debugPrint('Error fetching EXPO Ambassador application status: $e');
    }
  }

  void _openMapPicker() async {
    WardModel? selectedWard;
    if (_selectedWardId != null) {
      try {
        selectedWard = _allWards.firstWhere((w) => w.wardId == _selectedWardId);
      } catch (_) {}
    } else if (_selectedWardName != null) {
      try {
        selectedWard = _allWards.firstWhere((w) => w.wardName == _selectedWardName);
      } catch (_) {}
    }

    final areaName = selectedWard?.wardName ?? _selectedWardName ?? _selectedTaluk ?? _selectedDistrict ?? '';
    setState(() => _isLoadingMap = true);

    Map<String, dynamic>? geoJson = selectedWard?.geoJson;
    if (geoJson == null && areaName.isNotEmpty) {
      try {
        final res = await CloudPatraApi.getWardMap(areaName);
        if (res != null && res['data'] != null) {
          geoJson = res['data'];
        } else if (res != null && res['type'] != null) {
          geoJson = res;
        }
      } catch (_) {}
    }

    if (!mounted) return;
    setState(() => _isLoadingMap = false);

    if (areaName.isNotEmpty) {
      await SessionManager.setUserWard(areaName);
    }
    if (geoJson != null) {
      await SessionManager.setString('user_ward_geojson', jsonEncode(geoJson));
    }

    final dynamic result = await showDialog(
      context: context,
      builder: (context) => MapSelectionModal(
        initialLocation: _selectedLatLng,
        selectedWard: selectedWard,
        wardName: areaName.isNotEmpty ? areaName : null,
        geoJson: geoJson,
      ),
    );

    if (result != null) {
      if (result is Map<String, dynamic>) {
        final loc = result['location'] as LatLng?;
        final addr = result['address'] as String?;
        final pin = result['pincode'] as String?;
        setState(() {
          if (loc != null) _selectedLatLng = loc;
          if (addr != null && addr.isNotEmpty) {
            _areaController.text = addr;
          } else if (loc != null) {
            _areaController.text = '${loc.latitude.toStringAsFixed(4)}, ${loc.longitude.toStringAsFixed(4)}';
          }
          if (pin != null && pin.isNotEmpty) {
            _pincodeController.text = pin;
            _errors.remove('pincode');
          }
          _errors.remove('area');
        });
      } else if (result is LatLng) {
        setState(() {
          _selectedLatLng = result;
          if (_areaController.text.trim().isEmpty) {
            _areaController.text = '${result.latitude.toStringAsFixed(4)}, ${result.longitude.toStringAsFixed(4)}';
          }
          _errors.remove('area');
        });
      }
    }
  }

  List<String> get _states => _apiStates;

  List<String> get _districts {
    if (_selectedState == null) return [];
    return _apiDistricts[_selectedState] ?? [];
  }

  List<String> get _taluks {
    if (_selectedDistrict == null) return [];
    return _apiTaluks[_selectedDistrict] ?? [];
  }

  List<WardModel> get _wardsForTaluk {
    if (_selectedTaluk == null) return [];
    return _allWards
        .where((w) => w.taluka.toLowerCase() == _selectedTaluk!.toLowerCase())
        .toList()..sort((a, b) => a.wardName.compareTo(b.wardName));
  }

  List<String> get _wardNames {
    return _wardsForTaluk.map((w) => w.wardName).where((n) => n.isNotEmpty).toSet().toList();
  }

  int get _completedCount {
    int count = 0;
    if (_fullNameController.text.trim().isNotEmpty) count++;
    if (_emailController.text.trim().isNotEmpty && RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(_emailController.text.trim())) count++;
    if (_selectedState != null && _selectedState!.isNotEmpty) count++;
    if (_selectedDistrict != null && _selectedDistrict!.isNotEmpty) count++;
    if (_selectedTaluk != null && _selectedTaluk!.isNotEmpty) count++;
    if (_areaController.text.trim().isNotEmpty) count++;
    if (_pincodeController.text.trim().isNotEmpty && RegExp(r'^\d{6}$').hasMatch(_pincodeController.text.trim())) count++;
    if (_selectedAvailability != null && _selectedAvailability!.isNotEmpty) count++;
    if (_selectedLanguages.isNotEmpty) count++;
    if (_selectedExperience != null && _selectedExperience!.isNotEmpty) count++;
    if (_consentChecked) count++;
    return count;
  }

  void _submitForm() async {
    setState(() {
      _errors.clear();
    });

    if (_fullNameController.text.trim().isEmpty) {
      _errors['fullName'] = 'Full Name is required.';
    }

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _errors['email'] = 'Email Address is required.';
    } else if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      _errors['email'] = 'Enter a valid email address.';
    }

    if (_selectedState == null || _selectedState!.isEmpty) {
      _errors['state'] = 'Select your state.';
    }

    if (_selectedDistrict == null || _selectedDistrict!.isEmpty) {
      _errors['district'] = 'Select your district.';
    }

    if (_selectedTaluk == null || _selectedTaluk!.isEmpty) {
      _errors['taluk'] = 'Select your taluk.';
    }

    // Ward is mandatory: the application is routed to THIS ward's Ward Chairman.
    // Without a wardId the backend rejects the submission.
    if (_selectedWardId == null || _selectedWardId!.isEmpty) {
      _errors['ward'] = _wardsForTaluk.isEmpty && _selectedTaluk != null
          ? 'No wards are configured for this taluk yet.'
          : 'Select your Ward/Hobli.';
    }

    if (_areaController.text.trim().isEmpty) {
      _errors['area'] = 'Area is required.';
    }

    final pincode = _pincodeController.text.trim();
    if (pincode.isEmpty) {
      _errors['pincode'] = 'Pincode is required.';
    } else if (!RegExp(r'^\d{6}$').hasMatch(pincode)) {
      _errors['pincode'] = 'Enter a 6-digit pincode.';
    }

    if (_selectedAvailability == null || _selectedAvailability!.isEmpty) {
      _errors['availability'] = 'Select your availability.';
    }

    if (_selectedLanguages.isEmpty) {
      _errors['languages'] = 'Select at least one language.';
    }

    if (_selectedExperience == null || _selectedExperience!.isEmpty) {
      _errors['experience'] = 'Select your experience.';
    }

    if (!_consentChecked) {
      _errors['consent'] = 'Please accept the ambassador terms to continue.';
    }

    if (_errors.isNotEmpty) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the highlighted fields.'),
          backgroundColor: _FormColors.stamp,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Only the fields the backend accepts. The server generates the
    // application number, sets the status, takes userId/mobile from the
    // login token and routes it to the Ward Chairman of `wardId`.
    final payload = {
      'fullName': _fullNameController.text.trim(),
      'email': _emailController.text.trim(),
      'state': _selectedState,
      'district': _selectedDistrict,
      'taluk': _selectedTaluk,
      'wardId': _selectedWardId,
      'area': _areaController.text.trim(),
      'pincode': _pincodeController.text.trim(),
      'availability': _selectedAvailability,
      'languages': _selectedLanguages,
      'experience': _selectedExperience,
      if (_selectedLatLng != null) 'latitude': _selectedLatLng!.latitude,
      if (_selectedLatLng != null) 'longitude': _selectedLatLng!.longitude,
      'consentAccepted': _consentChecked,
    };

    final result = await ExpoAmbassadorApi.submitApplication(payload);

    if (!mounted) return;

    // Never show the success screen unless the server actually saved it —
    // otherwise the Ward Chairman never receives the application.
    if (!result.success || result.data == null) {
      final msg = result.message;
      if (msg.toLowerCase().contains('already') || msg.toLowerCase().contains('application')) {
        String? existingAppId;
        final regex = RegExp(r'\(([^)]+)\)');
        final match = regex.firstMatch(msg);
        if (match != null) {
          existingAppId = match.group(1);
        }

        if (existingAppId != null && existingAppId.isNotEmpty) {
          setState(() {
            _isSubmitting = false;
            _submittedAppId = existingAppId;
            if (msg.toLowerCase().contains('approv') || msg.toLowerCase().contains('accept')) {
              _currentStatusStage = 'APPROVED';
            } else if (msg.toLowerCase().contains('reject') || msg.toLowerCase().contains('declin')) {
              _currentStatusStage = 'REJECTED';
            } else {
              _currentStatusStage = 'UNDER_CONSIDERATION';
            }
          });

          try {
            final uid = SessionManager.userId;
            if (uid != null) {
              await SessionManager.setString('last_submitted_expo_app_id_$uid', existingAppId);
            }
            await SessionManager.setString('last_submitted_expo_app_id', existingAppId);
          } catch (_) {}

          return;
        }
      }

      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message), backgroundColor: _FormColors.stamp),
      );
      return;
    }

    // Server-issued number (e.g. UBW-EXP-482913) — the same one the Ward Chairman sees.
    final appId = (result.data!['applicationNumber'] ?? result.data!['applicationId']).toString();

    setState(() {
      _isSubmitting = false;
      _submittedAppId = appId;
      _currentStatusStage = 'SUBMITTED';
    });

    try {
      final uid = SessionManager.userId;
      if (uid != null) {
        await SessionManager.setString('last_submitted_expo_app_id_$uid', appId);
      }
      await SessionManager.setString('last_submitted_expo_app_id', appId);
    } catch (_) {}

    // Start listening/fetching status updates from EXPO Ambassador Ward Chairman API
    _fetchApplicationStatus();

    if (widget.onSubmitted != null) {
      widget.onSubmitted!(appId);
    }
  }

  void _openSelectModal({
    required String title,
    required String subtitle,
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onSelected,
    bool multi = false,
    List<String>? selectedValues,
    ValueChanged<List<String>>? onMultiSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _SelectBottomSheet(
          title: title,
          subtitle: subtitle,
          options: options,
          selectedValue: selectedValue,
          onSelected: onSelected,
          multi: multi,
          selectedValues: selectedValues ?? [],
          onMultiSelected: onMultiSelected,
        );
      },
    );
  }

  Widget _buildTricolorBar() {
    return SizedBox(
      height: 4,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(child: Container(color: _FormColors.saffron)),
          Expanded(child: Container(color: _FormColors.paper)),
          Expanded(child: Container(color: _FormColors.seal)),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final done = _completedCount;
    final pct = done / 11.0;

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Form completion', style: TextStyle(fontSize: 11.5, color: _FormColors.muted)),
              Text('$done of 11', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: _FormColors.sealDark)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: _FormColors.disabled,
              valueColor: const AlwaysStoppedAnimation<Color>(_FormColors.seal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String number, String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      margin: const EdgeInsets.only(top: 22, bottom: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _FormColors.line, width: 1.0)),
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: _FormColors.seal,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Serif',
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: _FormColors.sealDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required String fieldKey,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    final error = _errors[fieldKey];

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: _FormColors.inkSoft,
              ),
              children: const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: _FormColors.stamp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: error != null ? _FormColors.stamp : _FormColors.seal, width: 1.5),
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              maxLength: maxLength,
              textCapitalization: textCapitalization,
              style: const TextStyle(fontSize: 14.5, color: _FormColors.ink),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Color(0xFFB3A98F), fontSize: 14),
                border: InputBorder.none,
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              ),
              onChanged: (_) {
                if (_errors.containsKey(fieldKey)) {
                  setState(() {
                    _errors.remove(fieldKey);
                  });
                }
              },
            ),
          ),
          if (error != null) ...[
            const SizedBox(height: 6),
            Text(error, style: const TextStyle(color: _FormColors.stamp, fontSize: 11.5)),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectorTile({
    required String label,
    required String? value,
    required String placeholder,
    required VoidCallback onTap,
    required String fieldKey,
    bool disabled = false,
    IconData icon = Icons.location_on_outlined,
    bool isMulti = false,
    List<String>? multiValues,
  }) {
    final error = _errors[fieldKey];

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: _FormColors.inkSoft,
              ),
              children: const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: _FormColors.stamp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: disabled ? null : onTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              constraints: const BoxConstraints(minHeight: 50),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: disabled ? _FormColors.disabled : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: error != null ? _FormColors.stamp : _FormColors.seal, width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: disabled ? const Color(0xFFE2DBC5) : _FormColors.sealTint,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Icon(icon, color: disabled ? const Color(0xFFA79E86) : _FormColors.sealDark, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: isMulti
                        ? (multiValues != null && multiValues.isNotEmpty)
                            ? Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: multiValues.map((v) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _FormColors.seal,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(v, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                                        const SizedBox(width: 4),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedLanguages.remove(v);
                                            });
                                          },
                                          child: const Icon(Icons.close, color: Colors.white, size: 14),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              )
                            : Text(placeholder, style: const TextStyle(color: Color(0xFFB3A98F), fontSize: 14.5))
                        : Text(
                            value ?? placeholder,
                            style: TextStyle(
                              fontSize: 14.5,
                              color: value != null ? _FormColors.ink : (disabled ? const Color(0xFFA79E86) : const Color(0xFFB3A98F)),
                              fontWeight: value != null ? FontWeight.w500 : FontWeight.normal,
                            ),
                          ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: _FormColors.muted, size: 20),
                ],
              ),
            ),
          ),
          if (error != null) ...[
            const SizedBox(height: 6),
            Text(error, style: const TextStyle(color: _FormColors.stamp, fontSize: 11.5)),
          ] else if (isMulti) ...[
            const SizedBox(height: 6),
            const Text('You can pick more than one.', style: TextStyle(color: _FormColors.muted, fontSize: 11.5)),
          ],
        ],
      ),
    );
  }

  Widget _buildMobileReadOnly() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Mobile Number', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: _FormColors.inkSoft)),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                decoration: BoxDecoration(color: _FormColors.sealTint, borderRadius: BorderRadius.circular(20)),
                child: const Text('✓ Verified', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: _FormColors.sealDark)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                height: 48,
                width: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _FormColors.seal, width: 1.5),
                ),
                child: const Text('+91', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: _FormColors.inkSoft)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _FormColors.seal, width: 1.5),
                  ),
                  child: Text(_verifiedMobile, style: const TextStyle(fontSize: 14.5, color: _FormColors.inkSoft, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPipeline() {
    final isSubmitted = _currentStatusStage == 'SUBMITTED';
    final isUnderConsideration = _currentStatusStage == 'UNDER_CONSIDERATION' || _currentStatusStage == 'UNDER_REVIEW';
    final isApproved = _currentStatusStage == 'APPROVED';
    final isRejected = _currentStatusStage == 'REJECTED';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: _FormColors.paperAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _FormColors.line, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(30, 42, 68, 0.04),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Application Status',
                style: TextStyle(
                  fontFamily: 'Serif',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: _FormColors.ink,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isApproved
                      ? _FormColors.sealTint
                      : (isRejected
                          ? const Color(0xFFF3E3DF)
                          : (isUnderConsideration ? _FormColors.goldTint : Colors.blue.withValues(alpha: 0.1))),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isApproved
                        ? _FormColors.seal
                        : (isRejected
                            ? _FormColors.stamp
                            : (isUnderConsideration ? _FormColors.gold : Colors.blue)),
                  ),
                ),
                child: Text(
                  isApproved
                      ? 'Approved'
                      : (isRejected
                          ? 'Rejected'
                          : (isUnderConsideration ? 'Under Consideration' : 'Submitted')),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isApproved
                        ? _FormColors.sealDark
                        : (isRejected
                            ? _FormColors.stamp
                            : (isUnderConsideration ? const Color(0xFF5B4415) : Colors.blue[800])),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Step 1: Application Submitted
          _buildStatusStepItem(
            stepNumber: '1',
            title: 'Application Submitted',
            subtitle: 'Forwarded to Ward Chairman for verification',
            isCompleted: !isSubmitted,
            isActive: isSubmitted,
            isLast: false,
          ),

          // Step 2: Under Consideration
          _buildStatusStepItem(
            stepNumber: '2',
            title: 'Under Consideration',
            subtitle: 'Sent to Ward Chairman for review & approval',
            isCompleted: isApproved || isRejected,
            isActive: isUnderConsideration,
            isLast: false,
          ),

          // Step 3: Approved / Rejected
          _buildStatusStepItem(
            stepNumber: '3',
            title: isApproved
                ? 'Application Approved 🎉'
                : (isRejected ? 'Application Rejected' : 'Approved / Rejected'),
            subtitle: isApproved
                ? 'Congratulations! Approved by Ward Chairman.'
                : (isRejected
                    ? 'Thank you for applying. Application was rejected by Ward Chairman.'
                    : 'Final status decision will be updated by Ward Chairman.'),
            isCompleted: isApproved,
            isRejected: isRejected,
            isActive: isApproved || isRejected,
            isLast: true,
          ),
        ],
      ),
    );
  }

  // Demo stage button removed

  Widget _buildStatusStepItem({
    required String stepNumber,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isActive,
    required bool isLast,
    bool isRejected = false,
  }) {
    Color nodeColor = _FormColors.disabled;
    Widget nodeChild = Text(stepNumber, style: const TextStyle(fontSize: 11, color: _FormColors.muted, fontWeight: FontWeight.bold));

    if (isCompleted) {
      nodeColor = _FormColors.seal;
      nodeChild = const Icon(Icons.check, size: 14, color: Colors.white);
    } else if (isRejected) {
      nodeColor = _FormColors.stamp;
      nodeChild = const Icon(Icons.close, size: 14, color: Colors.white);
    } else if (isActive) {
      nodeColor = _FormColors.gold;
      nodeChild = const SizedBox(
        width: 8,
        height: 8,
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: nodeColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: nodeChild,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: isCompleted ? _FormColors.seal : _FormColors.line,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: (isCompleted || isActive) ? FontWeight.bold : FontWeight.w500,
                      color: isRejected
                          ? _FormColors.stamp
                          : ((isCompleted || isActive) ? _FormColors.ink : _FormColors.muted),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11.5, color: _FormColors.muted, height: 1.35),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return RefreshIndicator(
      onRefresh: _fetchApplicationStatus,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
        child: Column(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                color: _FormColors.sealTint,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: _FormColors.seal, size: 40),
            ),
            const SizedBox(height: 18),
            const Text(
              'Application submitted',
              style: TextStyle(
                fontFamily: 'Serif',
                fontWeight: FontWeight.bold,
                fontSize: 21,
                color: _FormColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Your ',
                style: const TextStyle(fontSize: 13, color: _FormColors.inkSoft, height: 1.55),
                children: [
                  const TextSpan(text: 'EXPO Ambassador', style: TextStyle(fontWeight: FontWeight.bold, color: _FormColors.ink)),
                  const TextSpan(text: ' application has been received & sent to your Ward Chairman.'),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: _FormColors.paperAlt,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _FormColors.gold, width: 1.5),
              ),
              child: Text(
                'Application ID · $_submittedAppId',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Monospace',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: _FormColors.ink,
                ),
              ),
            ),

            // Application Status Bar / Pipeline (Synced with EXPO Ambassador Ward Chairman API)
            _buildStatusPipeline(),

            // Demo Simulator Controls removed

            // Summary Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _FormColors.paperAlt,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _FormColors.line, width: 1.5),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Name', _fullNameController.text.trim()),
                  _buildSummaryRow('Location', '${_selectedTaluk ?? ""}, ${_selectedDistrict ?? ""}'),
                  _buildSummaryRow('Availability', _selectedAvailability ?? ''),
                  _buildSummaryRow('Languages', _selectedLanguages.join(', ')),
                ],
              ),
            ),
            const SizedBox(height: 26),
            if (_currentStatusStage == 'APPROVED') ...[
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: _FormColors.sealTint,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _FormColors.seal, width: 1.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_rounded, color: _FormColors.seal, size: 28),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Application Approved! 🎉',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _FormColors.sealDark),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Your EXPO Ambassador application has been approved by the Ward Chairman. You now have full access to the dashboard.',
                            style: TextStyle(fontSize: 12, color: _FormColors.inkSoft),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0E5C4A), Color(0xFF12735E)],
                    ),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => MainScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.dashboard_rounded, color: Colors.white),
                    label: const Text('Go to Dashboard', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _FormColors.line),
                  color: _FormColors.paperAlt,
                ),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Back to Companies', style: TextStyle(color: _FormColors.ink, fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: _FormColors.muted, fontSize: 12.5)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: _FormColors.ink, fontSize: 12.5, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _FormColors.ink, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'EXPO Ambassador',
              style: TextStyle(
                fontFamily: 'Serif',
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: _FormColors.ink,
              ),
            ),
            Text('Ambassador application', style: TextStyle(fontSize: 11.5, color: _FormColors.muted)),
          ],
        ),
        actions: [
          if (_submittedAppId != null)
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: _FormColors.ink),
              onPressed: _fetchApplicationStatus,
              tooltip: 'Refresh Status',
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: _buildTricolorBar(),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: _submittedAppId != null
              ? _buildSuccessView()
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Form Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _FormColors.gold, width: 1.5),
                          gradient: const LinearGradient(
                            colors: [_FormColors.goldTint, Color(0xFFFBF6E9)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: _FormColors.gold,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: const Text('EX', style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('EXPO Ambassador', style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF5B4415))),
                                  SizedBox(height: 3),
                                  Text(
                                    'Be the face of the UB WARRIORS Expo. Fill in a few details to get started.',
                                    style: TextStyle(fontSize: 12, color: Color(0xFF6B5624), height: 1.45),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      _buildProgressBar(),

                      // Section 1: Personal Details
                      _buildSectionHeader('1', 'Personal Details'),
                      _buildTextField(
                        label: 'Full Name',
                        controller: _fullNameController,
                        hint: 'Enter your full name',
                        fieldKey: 'fullName',
                        textCapitalization: TextCapitalization.words,
                      ),
                      _buildMobileReadOnly(),
                      _buildTextField(
                        label: 'Email Address',
                        controller: _emailController,
                        hint: 'name@example.com',
                        fieldKey: 'email',
                        keyboardType: TextInputType.emailAddress,
                      ),

                      // Section 2: Address
                      _buildSectionHeader('2', 'Address'),
                      _buildSelectorTile(
                        label: 'State',
                        value: _selectedState,
                        placeholder: 'Select State',
                        fieldKey: 'state',
                        icon: Icons.map_outlined,
                        onTap: () {
                          _openSelectModal(
                            title: 'Select State',
                            subtitle: 'Select State',
                            options: _states,
                            selectedValue: _selectedState,
                            onSelected: (val) {
                              setState(() {
                                if (_selectedState != val) {
                                  _selectedState = val;
                                  _selectedDistrict = null;
                                  _selectedTaluk = null;
                                  _selectedWardName = null;
                                  _selectedWardId = null;
                                  _errors.remove('state');
                                }
                              });
                            },
                          );
                        },
                      ),
                      _buildSelectorTile(
                        label: 'District',
                        value: _selectedDistrict,
                        placeholder: _selectedState == null ? 'Select a State first' : 'Select District',
                        disabled: _selectedState == null,
                        fieldKey: 'district',
                        icon: Icons.map_outlined,
                        onTap: () {
                          _openSelectModal(
                            title: 'Select District',
                            subtitle: _selectedState ?? '',
                            options: _districts,
                            selectedValue: _selectedDistrict,
                            onSelected: (val) {
                              setState(() {
                                if (_selectedDistrict != val) {
                                  _selectedDistrict = val;
                                  _selectedTaluk = null;
                                  _selectedWardName = null;
                                  _selectedWardId = null;
                                  _errors.remove('district');
                                }
                              });
                            },
                          );
                        },
                      ),
                      _buildSelectorTile(
                        label: 'Taluk',
                        value: _selectedTaluk,
                        placeholder: _selectedDistrict == null ? 'Select a District first' : 'Select Taluk',
                        disabled: _selectedDistrict == null,
                        fieldKey: 'taluk',
                        icon: Icons.pin_drop_outlined,
                        onTap: () {
                          _openSelectModal(
                            title: 'Select Taluk',
                            subtitle: '${_selectedDistrict ?? ""}, ${_selectedState ?? ""}',
                            options: _taluks,
                            selectedValue: _selectedTaluk,
                            onSelected: (val) {
                              setState(() {
                                if (_selectedTaluk != val) {
                                  _selectedTaluk = val;
                                  _selectedWardName = null;
                                  _selectedWardId = null;
                                  _errors.remove('taluk');
                                }
                              });
                            },
                          );
                        },
                      ),
                      _buildSelectorTile(
                        label: 'Ward/Hobli',
                        value: _selectedWardName,
                        placeholder: _selectedTaluk == null ? 'Select a Taluk first' : 'Select Ward/Hobli',
                        disabled: _selectedTaluk == null,
                        fieldKey: 'ward',
                        icon: Icons.check_box_outline_blank_rounded,
                        onTap: () {
                          _openSelectModal(
                            title: 'Select Ward/Hobli',
                            subtitle: '${_selectedTaluk ?? ""}, ${_selectedDistrict ?? ""}',
                            options: _wardNames.isNotEmpty ? _wardNames : [_selectedTaluk ?? 'Default Ward'],
                            selectedValue: _selectedWardName,
                            onSelected: (val) {
                              setState(() {
                                _selectedWardName = val;
                                // Match inside the selected taluk only — ward names repeat
                                // across taluks, and wardId decides which Ward Chairman
                                // receives this application.
                                final matches = _wardsForTaluk.where((w) => w.wardName == val);
                                _selectedWardId = matches.isNotEmpty ? matches.first.wardId : null;
                                _errors.remove('ward');
                              });
                              // AS SOON AS WARD/HOBLI IS SELECTED, OPEN GEOFENCING MAP IMMEDIATELY!
                              Future.microtask(() => _openMapPicker());
                            },
                          );
                        },
                      ),
                      _buildTextField(
                        label: 'Area',
                        controller: _areaController,
                        hint: 'Selected address from geo marking will appear here',
                        fieldKey: 'area',
                      ),
                      _buildTextField(
                        label: 'Pincode',
                        controller: _pincodeController,
                        hint: '6-digit pincode',
                        fieldKey: 'pincode',
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                      ),

                      // Section 3: Ambassador Details
                      _buildSectionHeader('3', 'Ambassador Details'),
                      _buildSelectorTile(
                        label: 'Availability',
                        value: _selectedAvailability,
                        placeholder: 'Your Availability',
                        fieldKey: 'availability',
                        icon: Icons.access_time,
                        onTap: () {
                          _openSelectModal(
                            title: 'Your Availability',
                            subtitle: '',
                            options: _availabilityOptions,
                            selectedValue: _selectedAvailability,
                            onSelected: (val) {
                              setState(() {
                                _selectedAvailability = val;
                                _errors.remove('availability');
                              });
                            },
                          );
                        },
                      ),
                      _buildSelectorTile(
                        label: 'Languages You Speak',
                        value: null,
                        placeholder: 'Select languages',
                        fieldKey: 'languages',
                        icon: Icons.language,
                        isMulti: true,
                        multiValues: _selectedLanguages,
                        onTap: () {
                          _openSelectModal(
                            title: 'Languages You Speak',
                            subtitle: 'Select all that apply',
                            options: _languageOptions,
                            selectedValue: null,
                            onSelected: (_) {},
                            multi: true,
                            selectedValues: _selectedLanguages,
                            onMultiSelected: (vals) {
                              setState(() {
                                _selectedLanguages = vals;
                                if (_selectedLanguages.isNotEmpty) {
                                  _errors.remove('languages');
                                }
                              });
                            },
                          );
                        },
                      ),
                      _buildSelectorTile(
                        label: 'Event / Promotion Experience',
                        value: _selectedExperience,
                        placeholder: 'Your Experience',
                        fieldKey: 'experience',
                        icon: Icons.star_border_rounded,
                        onTap: () {
                          _openSelectModal(
                            title: 'Your Experience',
                            subtitle: '',
                            options: _experienceOptions,
                            selectedValue: _selectedExperience,
                            onSelected: (val) {
                              setState(() {
                                _selectedExperience = val;
                                _errors.remove('experience');
                              });
                            },
                          );
                        },
                      ),

                      // Consent Checkbox
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0, bottom: 6.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _consentChecked = !_consentChecked;
                              if (_consentChecked) _errors.remove('consent');
                            });
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                margin: const EdgeInsets.only(top: 1),
                                decoration: BoxDecoration(
                                  color: _consentChecked ? _FormColors.seal : _FormColors.paperAlt,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _errors.containsKey('consent') ? _FormColors.stamp : (_consentChecked ? _FormColors.seal : _FormColors.line),
                                    width: 1.5,
                                  ),
                                ),
                                child: _consentChecked
                                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'I confirm the details above are correct and agree to the UB WARRIORS ambassador terms.',
                                  style: TextStyle(fontSize: 12.5, color: _FormColors.inkSoft, height: 1.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_errors.containsKey('consent')) ...[
                        Text(_errors['consent']!, style: const TextStyle(color: _FormColors.stamp, fontSize: 11.5)),
                      ],

                      const SizedBox(height: 18),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF12735E), _FormColors.seal],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(14, 92, 74, 0.45),
                                blurRadius: 16,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Submit Application',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

// Modal Bottom Sheet Widget for Dropdowns
class _SelectBottomSheet extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String> onSelected;
  final bool multi;
  final List<String> selectedValues;
  final ValueChanged<List<String>>? onMultiSelected;

  const _SelectBottomSheet({
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
    this.multi = false,
    this.selectedValues = const [],
    this.onMultiSelected,
  });

  @override
  State<_SelectBottomSheet> createState() => _SelectBottomSheetState();
}

class _SelectBottomSheetState extends State<_SelectBottomSheet> {
  late TextEditingController _searchController;
  late List<String> _tempMulti;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _tempMulti = List.from(widget.selectedValues);
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.options.where((o) {
      if (_query.isEmpty) return true;
      return o.toLowerCase().contains(_query);
    }).toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.78,
      ),
      decoration: const BoxDecoration(
        color: _FormColors.paper,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 10, bottom: 4),
            decoration: BoxDecoration(
              color: _FormColors.line,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          // Head
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontFamily: 'Serif',
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: _FormColors.ink,
                      ),
                    ),
                    if (widget.subtitle.isNotEmpty)
                      Text(
                        widget.subtitle,
                        style: const TextStyle(fontSize: 11.5, color: _FormColors.muted),
                      ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: _FormColors.ink),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          // Search box (shown when list > 7)
          if (widget.options.length > 7)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _FormColors.seal, width: 1.5),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(fontSize: 14, color: _FormColors.ink),
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Color(0xFFB3A98F), fontSize: 14),
                    prefixIcon: Icon(Icons.search, size: 18, color: _FormColors.muted),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          // List
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Text('No options available.', style: TextStyle(color: _FormColors.muted, fontSize: 13)),
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final isSel = widget.multi
                          ? _tempMulti.contains(item)
                          : widget.selectedValue == item;

                      return InkWell(
                        onTap: () {
                          if (widget.multi) {
                            setState(() {
                              if (_tempMulti.contains(item)) {
                                _tempMulti.remove(item);
                              } else {
                                _tempMulti.add(item);
                              }
                            });
                          } else {
                            widget.onSelected(item);
                            Navigator.of(context).pop();
                          }
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: widget.multi ? BoxShape.rectangle : BoxShape.circle,
                                  borderRadius: widget.multi ? BorderRadius.circular(6) : null,
                                  color: isSel ? _FormColors.seal : _FormColors.paperAlt,
                                  border: Border.all(
                                    color: isSel ? _FormColors.seal : _FormColors.line,
                                    width: 1.5,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: isSel
                                    ? const Icon(
                                        Icons.check,
                                        size: 13,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                item,
                                style: TextStyle(
                                  fontSize: 14.5,
                                  color: _FormColors.ink,
                                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Foot for Multi Select
          if (widget.multi)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _FormColors.seal, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        setState(() {
                          _tempMulti.clear();
                        });
                      },
                      child: const Text('Clear', style: TextStyle(color: _FormColors.sealDark, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF12735E), _FormColors.seal],
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        onPressed: () {
                          if (widget.onMultiSelected != null) {
                            widget.onMultiSelected!(_tempMulti);
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          _tempMulti.isNotEmpty ? 'Done (${_tempMulti.length})' : 'Done',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
