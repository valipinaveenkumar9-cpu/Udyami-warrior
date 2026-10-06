import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/yuva_udyami_models.dart';
import '../widgets/application_status_view.dart';

class YuvaUdyamiForm extends StatefulWidget {
  final String? verticalId;
  final String? companyName;
  final Map<String, dynamic>? initialApplicationData;

  const YuvaUdyamiForm({
    super.key,
    this.verticalId,
    this.companyName,
    this.initialApplicationData,
  });

  @override
  State<YuvaUdyamiForm> createState() => _YuvaUdyamiFormState();
}

class _YuvaUdyamiFormState extends State<YuvaUdyamiForm> {
  // Theme Palette matching HTML CSS :root exactly
  static const Color ink = Color(0xFF1E2A44);
  static const Color inkSoft = Color(0xFF3E4A63);
  static const Color paper = Color(0xFFF3EEDD);
  static const Color paperAlt = Color(0xFFFBF8EE);
  static const Color seal = Color(0xFF0E5C4A);
  static const Color sealDark = Color(0xFF0A4438);
  static const Color sealTint = Color(0xFFE3ECE5);
  static const Color stamp = Color(0xFFA13D2E);
  static const Color stampTint = Color(0xFFF3E3DF);
  static const Color gold = Color(0xFFA9791F);
  static const Color goldTint = Color(0xFFF1E7CC);
  static const Color line = Color(0xFFD9D0B8);
  static const Color muted = Color(0xFF7A7360);
  static const Color white = Color(0xFFFFFFFF);

  // App Navigation & Lifecycle
  String _currentStepId = 's1';
  String _appStage = 'form'; // 'form' or 'status'
  String _statusStage = 'submitted'; // 'submitted','meeting','rejected','notselected','payment','onboarded'
  final Set<String> _errors = {};
  final Map<String, int> _qCat = {}; // category index (0..3) for each questionnaire
  final Map<int, String> _qa = {}; // question index -> answer string

  // Step 1: About You
  String? _udyamiMember; // 'Yes' or 'No'
  final _memberIdController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _dobController = TextEditingController();
  String? _gender;
  final _fatherHusbandNameController = TextEditingController();
  String? _maritalStatus;
  final _bloodGroupController = TextEditingController();
  final _nationalityController = TextEditingController(text: 'Indian');
  final _languagesController = TextEditingController();
  final _mobileController = TextEditingController();
  final _altMobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _occupationController = TextEditingController();

  // Address
  final _houseStreetVillageController = TextEditingController();
  final _talukController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateNameController = TextEditingController();
  final _pinController = TextEditingController();
  final _wardController = TextEditingController();
  final _yearsLivedHereController = TextEditingController();
  String? _homeType;
  final _landmarkController = TextEditingController();

  // Step 2: Verify Your Aadhaar
  final _aadhaarNumberController = TextEditingController();
  final _aadhaarMobileController = TextEditingController();
  final _aadhaarNameController = TextEditingController();
  bool _aadhaarConsent = false;
  bool _aadhaarOtpSent = false;
  bool _aadhaarOtpVerified = false;
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(4, (_) => FocusNode());

  // Step 3: Business & Experience
  String _businessType = 'individual'; // 'institutional' or 'individual'
  final _businessNameController = TextEditingController();
  String? _typeOfBusiness;
  final _startedOnController = TextEditingController();
  final _businessPanController = TextEditingController();
  final _tanController = TextEditingController();
  final _gstNumberController = TextEditingController();
  final _udyamNumberController = TextEditingController();
  final _tradeLicenceController = TextEditingController();

  bool _hasExperience = false;
  final _whereWorkedController = TextEditingController();
  final _roleController = TextEditingController();
  final _howLongController = TextEditingController();
  final _whatYouDidController = TextEditingController();
  final _yearsExperienceController = TextEditingController();
  final _highestQualificationController = TextEditingController();
  final _toolsKnownController = TextEditingController();
  final Set<String> _familiarityChecklist = {};

  final _fieldSectorController = TextEditingController();
  final _businessOrEmployerController = TextEditingController();
  final _otherHowLongController = TextEditingController();
  final _otherWhatYouDidController = TextEditingController();

  // Step 4: Where You'll Work From
  final _workAddressController = TextEditingController();
  String? _ownership;
  final _workLandmarkController = TextEditingController();
  final _wardAreaServeController = TextEditingController();
  final _villagesCoveredController = TextEditingController();
  final Set<String> _workFacilities = {};

  // Step 5: Your Bank Details
  final _accountHolderNameController = TextEditingController();
  String? _accountType = 'Savings';
  final _accountNumberController = TextEditingController();
  final _ifscController = TextEditingController();
  final _bankBranchController = TextEditingController();

  // Nominee Details Panel
  final _nomineeNameController = TextEditingController();
  final _relationshipController = TextEditingController();
  final _nomineeMobileController = TextEditingController();
  final _nomineeAccountNumberController = TextEditingController();
  final _nomineeIfscController = TextEditingController();
  final _nomineeBankBranchController = TextEditingController();

  // Step 6: What You'd Like to Do
  final List<String> _services = [];
  final _wardAreaController = TextEditingController();

  // Step 7: Availability & Comfort
  final _newSaversPerMonthController = TextEditingController();
  String? _hireSupportStaff;
  String? _bestTimeTraining;
  String? _smartphone;
  String? _comfortApps;
  String? _usedAppsForInvestments;
  String? _comfortPayments;
  final Set<String> _langComm = {};

  // Step 8: Consent
  bool _c1 = false;
  bool _c2 = false;
  bool _c3 = false;
  bool _c4 = false;
  bool _c5 = false;
  bool _c6 = false;
  bool _c7 = false;
  bool _c8 = false;
  bool _c9 = false;
  final _placeController = TextEditingController();
  final _date8Controller = TextEditingController();
  bool _signed = false;
  DateTime? _signedAt;
  bool _thumbImpression = false;

  // Step 9: Review acknowledgements
  bool _depositAck1 = false;
  bool _depositAck2 = false;

  // Status Screen: Payment Simulation
  String _selectedPaymentMethod = 'UPI';
  final _upiIdController = TextEditingController(text: 'applicant@upi');
  bool _isPaymentProcessing = false;

  // Toast Notification
  String? _toastMessage;
  String _toastType = 'info';
  Timer? _toastTimer;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _date8Controller.text = _formatDateYMD(now);

    if (widget.initialApplicationData != null) {
      _appStage = 'status';
      final status = widget.initialApplicationData!['status'] ??
          widget.initialApplicationData!['applicationStatus'] ??
          'submitted';
      _statusStage = status.toString().toLowerCase();
    }
  }

  @override
  void dispose() {
    _memberIdController.dispose();
    _fullNameController.dispose();
    _dobController.dispose();
    _fatherHusbandNameController.dispose();
    _bloodGroupController.dispose();
    _nationalityController.dispose();
    _languagesController.dispose();
    _mobileController.dispose();
    _altMobileController.dispose();
    _emailController.dispose();
    _occupationController.dispose();

    _houseStreetVillageController.dispose();
    _talukController.dispose();
    _districtController.dispose();
    _stateNameController.dispose();
    _pinController.dispose();
    _wardController.dispose();
    _yearsLivedHereController.dispose();
    _landmarkController.dispose();

    _aadhaarNumberController.dispose();
    _aadhaarMobileController.dispose();
    _aadhaarNameController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _otpFocusNodes) {
      f.dispose();
    }

    _businessNameController.dispose();
    _startedOnController.dispose();
    _businessPanController.dispose();
    _tanController.dispose();
    _gstNumberController.dispose();
    _udyamNumberController.dispose();
    _tradeLicenceController.dispose();

    _whereWorkedController.dispose();
    _roleController.dispose();
    _howLongController.dispose();
    _whatYouDidController.dispose();
    _yearsExperienceController.dispose();
    _highestQualificationController.dispose();
    _toolsKnownController.dispose();

    _fieldSectorController.dispose();
    _businessOrEmployerController.dispose();
    _otherHowLongController.dispose();
    _otherWhatYouDidController.dispose();

    _workAddressController.dispose();
    _workLandmarkController.dispose();
    _wardAreaServeController.dispose();
    _villagesCoveredController.dispose();

    _accountHolderNameController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    _bankBranchController.dispose();

    _nomineeNameController.dispose();
    _relationshipController.dispose();
    _nomineeMobileController.dispose();
    _nomineeAccountNumberController.dispose();
    _nomineeIfscController.dispose();
    _nomineeBankBranchController.dispose();

    _wardAreaController.dispose();

    _newSaversPerMonthController.dispose();
    _placeController.dispose();
    _date8Controller.dispose();

    _upiIdController.dispose();
    _scrollController.dispose();
    _toastTimer?.cancel();
    super.dispose();
  }

  // Sequence Generation
  List<String> _buildSequence() {
    final seq = ['s1', 's2', 's3', 's4', 's5', 's6'];
    final bt = _businessType == 'institutional' ? 'institutional' : 'individual';
    for (final svc in _services) {
      seq.add('q_${svc}_$bt');
    }
    seq.addAll(['s7', 's8', 's9']);
    return seq;
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _cpToast(String message, [String type = 'info']) {
    _toastTimer?.cancel();
    setState(() {
      _toastMessage = message;
      _toastType = type;
    });
    _toastTimer = Timer(const Duration(milliseconds: 2400), () {
      if (mounted) {
        setState(() {
          _toastMessage = null;
        });
      }
    });
  }

  String _formatDateYMD(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String _formatDateDisplay(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }

  String _formatINR(num n) {
    final str = n.toInt().toString();
    if (str.length <= 3) return '₹$str';
    final last3 = str.substring(str.length - 3);
    final rest = str.substring(0, str.length - 3);
    final buffer = StringBuffer();
    for (int i = 0; i < rest.length; i++) {
      if (i > 0 && (rest.length - i) % 2 == 0) {
        buffer.write(',');
      }
      buffer.write(rest[i]);
    }
    return '₹${buffer.toString()},$last3';
  }

  Map<String, dynamic> _computeDeposit() {
    final rows = _services.map((id) {
      final card = YuvaUdyamiServiceCards.all.firstWhere(
        (c) => c.id == id,
        orElse: () => YuvaUdyamiServiceCard(id: id, icon: '', name: id, desc: ''),
      );
      return {'label': card.name, 'amount': YuvaUdyamiServiceCards.depositPerModule};
    }).toList();
    final total = _services.length * YuvaUdyamiServiceCards.depositPerModule;
    return {'rows': rows, 'total': total};
  }

  void _loadDemoApplicant() {
    setState(() {
      _udyamiMember = 'Yes';
      _memberIdController.text = '123123';
      _fullNameController.text = 'Priya Sharma';
      _dobController.text = '1994-06-21';
      _gender = 'Female';
      _fatherHusbandNameController.text = 'Ravi Sharma';
      _maritalStatus = 'Single';
      _bloodGroupController.text = 'A+';
      _nationalityController.text = 'Indian';
      _languagesController.text = 'Kannada, English, Hindi';
      _mobileController.text = '9900112233';
      _emailController.text = 'priya.sharma@example.test';
      _occupationController.text = 'Skills trainer';

      _houseStreetVillageController.text = '7, Cross Road, Indiranagar';
      _talukController.text = 'Bengaluru East';
      _districtController.text = 'Bengaluru Urban';
      _stateNameController.text = 'Karnataka';
      _pinController.text = '560038';
      _wardController.text = 'Indiranagar Ward';
      _yearsLivedHereController.text = '6';
      _homeType = 'Rented';
      _landmarkController.text = 'Near Indiranagar Metro Station';

      _aadhaarNumberController.text = '345678901234';
      _aadhaarMobileController.text = '9900112233';
      _aadhaarNameController.text = 'Priya Sharma';
      _aadhaarConsent = true;
      _aadhaarOtpSent = false;
      _aadhaarOtpVerified = true;

      _businessType = 'individual';
      _hasExperience = true;
      _whereWorkedController.text = 'SkillBridge Academy';
      _roleController.text = 'Lead Skills Trainer';
      _howLongController.text = '2018–2026';
      _whatYouDidController.text =
          'Ran cohort-based skilling workshops, tracked learner progress and helped placement-ready candidates connect with employers.';
      _yearsExperienceController.text = '8';
      _highestQualificationController.text = 'MBA';
      _toolsKnownController.text =
          'LMS platforms, Google Sheets, WhatsApp Business';
      _familiarityChecklist.clear();
      _familiarityChecklist.addAll([
        'I know my way around KYC / AML basics',
        "I'm familiar with SIP / mutual-fund style savings plans",
      ]);

      _workAddressController.text = '7, Cross Road, Indiranagar, Bengaluru';
      _ownership = 'Rented';
      _workLandmarkController.text = 'Indiranagar Metro Station';
      _wardAreaServeController.text = 'Indiranagar Ward';
      _villagesCoveredController.text = 'Indiranagar, Domlur, HAL Layout';
      _workFacilities.clear();
      _workFacilities.addAll([
        'Private area for clients to discuss their investments',
        'Internet access to log leads and savers',
        'Computer, scanner and printer on site',
        'Familiar with One Core KYC / onboarding process',
      ]);

      _accountHolderNameController.text = 'Priya Sharma';
      _accountType = 'Savings';
      _accountNumberController.text = 'XXXXXX9021';
      _ifscController.text = 'ICIC0001122';
      _bankBranchController.text = 'Indiranagar Branch';

      _nomineeNameController.text = 'Ravi Sharma';
      _relationshipController.text = 'Father';
      _nomineeMobileController.text = '9900011122';
      _nomineeAccountNumberController.text = 'XXXXXX6650';
      _nomineeIfscController.text = 'ICIC0001122';
      _nomineeBankBranchController.text = 'Indiranagar Branch';

      _services.clear();
      _services.addAll(['intermediate', 'skillmatch']);
      _wardAreaController.text = 'Indiranagar Ward';

      _newSaversPerMonthController.text = '20';
      _hireSupportStaff = 'No';
      _bestTimeTraining = 'Weekdays';
      _smartphone = 'Android';
      _comfortApps = 'Very Comfortable';
      _usedAppsForInvestments = 'Yes, Regularly';
      _comfortPayments = 'Very Comfortable';
      _langComm.clear();
      _langComm.addAll([
        "I'm comfortable using the Partner app already",
        'I can talk to clients in Kannada',
        'I can talk to clients in English',
      ]);

      _c1 = true;
      _c2 = true;
      _c3 = true;
      _c4 = true;
      _c5 = true;
      _c6 = true;
      _c7 = true;
      _c8 = true;
      _c9 = true;
      _placeController.text = 'Bengaluru';
      _date8Controller.text = '2026-08-31';
      _signed = true;
      _signedAt = DateTime.now();

      _depositAck1 = true;
      _depositAck2 = true;

      _appStage = 'form';
      _currentStepId = 's1';
      _errors.clear();
    });
    _cpToast('Demo applicant loaded', 'success');
  }

  void _resetApp() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: paperAlt,
        title: const Text(
          'Start over?',
          style: TextStyle(
            color: ink,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
          ),
        ),
        content: const Text(
          "This clears everything you've entered.",
          style: TextStyle(color: inkSoft),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: muted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: stamp,
              foregroundColor: white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _currentStepId = 's1';
                _appStage = 'form';
                _statusStage = 'submitted';
                _errors.clear();
                _qCat.clear();
                _qa.clear();

                _udyamiMember = null;
                _memberIdController.clear();
                _fullNameController.clear();
                _dobController.clear();
                _gender = null;
                _fatherHusbandNameController.clear();
                _maritalStatus = null;
                _bloodGroupController.clear();
                _nationalityController.text = 'Indian';
                _languagesController.clear();
                _mobileController.clear();
                _altMobileController.clear();
                _emailController.clear();
                _occupationController.clear();

                _houseStreetVillageController.clear();
                _talukController.clear();
                _districtController.clear();
                _stateNameController.clear();
                _pinController.clear();
                _wardController.clear();
                _yearsLivedHereController.clear();
                _homeType = null;
                _landmarkController.clear();

                _aadhaarNumberController.clear();
                _aadhaarMobileController.clear();
                _aadhaarNameController.clear();
                _aadhaarConsent = false;
                _aadhaarOtpSent = false;
                _aadhaarOtpVerified = false;
                for (var c in _otpControllers) {
                  c.clear();
                }

                _businessType = 'individual';
                _businessNameController.clear();
                _typeOfBusiness = null;
                _startedOnController.clear();
                _businessPanController.clear();
                _tanController.clear();
                _gstNumberController.clear();
                _udyamNumberController.clear();
                _tradeLicenceController.clear();

                _hasExperience = false;
                _whereWorkedController.clear();
                _roleController.clear();
                _howLongController.clear();
                _whatYouDidController.clear();
                _yearsExperienceController.clear();
                _highestQualificationController.clear();
                _toolsKnownController.clear();
                _familiarityChecklist.clear();

                _fieldSectorController.clear();
                _businessOrEmployerController.clear();
                _otherHowLongController.clear();
                _otherWhatYouDidController.clear();

                _workAddressController.clear();
                _ownership = null;
                _workLandmarkController.clear();
                _wardAreaServeController.clear();
                _villagesCoveredController.clear();
                _workFacilities.clear();

                _accountHolderNameController.clear();
                _accountType = 'Savings';
                _accountNumberController.clear();
                _ifscController.clear();
                _bankBranchController.clear();

                _nomineeNameController.clear();
                _relationshipController.clear();
                _nomineeMobileController.clear();
                _nomineeAccountNumberController.clear();
                _nomineeIfscController.clear();
                _nomineeBankBranchController.clear();

                _services.clear();
                _wardAreaController.clear();

                _newSaversPerMonthController.clear();
                _hireSupportStaff = null;
                _bestTimeTraining = null;
                _smartphone = null;
                _comfortApps = null;
                _usedAppsForInvestments = null;
                _comfortPayments = null;
                _langComm.clear();

                _c1 = false;
                _c2 = false;
                _c3 = false;
                _c4 = false;
                _c5 = false;
                _c6 = false;
                _c7 = false;
                _c8 = false;
                _c9 = false;
                _placeController.clear();
                _date8Controller.text = _formatDateYMD(DateTime.now());
                _signed = false;
                _signedAt = null;
                _thumbImpression = false;

                _depositAck1 = false;
                _depositAck2 = false;
              });
              _scrollToTop();
              _cpToast('Form reset', 'info');
            },
            child: const Text('Start Over'),
          ),
        ],
      ),
    );
  }

  bool _validateCurrentStep() {
    final missing = <String>{};

    if (_currentStepId == 's1') {
      if (_udyamiMember == null) {
        missing.add('udyamiMember');
      } else if (_udyamiMember == 'No') {
        missing.add('udyamiMember');
      } else if (_udyamiMember == 'Yes' &&
          _memberIdController.text.trim().isEmpty) {
        missing.add('memberId');
      }

      if (_fullNameController.text.trim().isEmpty) missing.add('fullName');
      if (_mobileController.text.trim().isEmpty) missing.add('mobile');
      if (_houseStreetVillageController.text.trim().isEmpty) {
        missing.add('houseStreetVillage');
      }
      if (_stateNameController.text.trim().isEmpty) missing.add('stateName');
      if (_pinController.text.trim().isEmpty) missing.add('pin');
    } else if (_currentStepId == 's2') {
      if (!_aadhaarOtpVerified) {
        missing.add('aadhaarConsent');
      }
    } else if (_currentStepId == 's3') {
      if (_businessType == 'institutional' &&
          _businessNameController.text.trim().isEmpty) {
        missing.add('businessName');
      }
    } else if (_currentStepId == 's5') {
      if (_accountHolderNameController.text.trim().isEmpty) {
        missing.add('accountHolderName');
      }
      if (_accountNumberController.text.trim().isEmpty) {
        missing.add('accountNumber');
      }
      if (_ifscController.text.trim().isEmpty) missing.add('ifsc');
    } else if (_currentStepId == 's6') {
      if (_services.isEmpty) missing.add('services');
      if (_wardAreaController.text.trim().isEmpty) missing.add('wardArea');
    } else if (_currentStepId == 's8') {
      if (!_c1) missing.add('c1');
      if (!_c2) missing.add('c2');
      if (!_c3) missing.add('c3');
      if (!_c4) missing.add('c4');
      if (!_c5) missing.add('c5');
      if (!_c6) missing.add('c6');
      if (!_c7) missing.add('c7');
      if (!_c8) missing.add('c8');
      if (!_c9) missing.add('c9');
      if (_placeController.text.trim().isEmpty) missing.add('place');
      if (_date8Controller.text.trim().isEmpty) missing.add('date8');
      if (!_signed) missing.add('signed');
    } else if (_currentStepId == 's9') {
      if (!_depositAck1) missing.add('depositAck1');
      if (!_depositAck2) missing.add('depositAck2');
    }

    setState(() {
      _errors.clear();
      _errors.addAll(missing);
    });

    return missing.isEmpty;
  }

  void _goNext() {
    if (_currentStepId == 's1') {
      if (_udyamiMember == null) {
        setState(() => _errors.add('udyamiMember'));
        _cpToast(
          'Please select Yes or No for Udyami Bharat / FCMCSL membership.',
          'error',
        );
        return;
      }
      if (_udyamiMember == 'No') {
        setState(() => _errors.add('udyamiMember'));
        _cpToast(
          'Udyami Bharat / FCMCSL membership is required to continue.',
          'error',
        );
        return;
      }
      if (_udyamiMember == 'Yes' && _memberIdController.text.trim().isEmpty) {
        _memberIdController.text = '123123';
      }
    }

    if (_currentStepId == 's2' && !_aadhaarOtpVerified) {
      _validateCurrentStep();
      _cpToast('Please verify the Aadhaar OTP before continuing.', 'error');
      return;
    }

    if (!_validateCurrentStep()) {
      _cpToast('Please complete the highlighted fields before continuing.', 'error');
      return;
    }

    final seq = _buildSequence();
    final idx = seq.indexOf(_currentStepId);
    if (idx > -1 && idx < seq.length - 1) {
      setState(() {
        _currentStepId = seq[idx + 1];
        _errors.clear();
      });
      _scrollToTop();
    }
  }

  void _goBack() {
    final seq = _buildSequence();
    final idx = seq.indexOf(_currentStepId);
    if (idx > 0) {
      setState(() {
        _currentStepId = seq[idx - 1];
        _errors.clear();
      });
      _scrollToTop();
    }
  }

  void _toggleService(String id) {
    setState(() {
      if (_services.contains(id)) {
        _services.remove(id);
      } else {
        _services.add(id);
      }
      _errors.remove('services');
    });
  }

  void _verifyOtp() {
    final entered = _otpControllers.map((c) => c.text).join();
    if (entered == '1234') {
      setState(() {
        _aadhaarOtpVerified = true;
        _aadhaarConsent = true;
        _aadhaarOtpSent = false;
        for (var c in _otpControllers) {
          c.clear();
        }
        _errors.remove('aadhaarConsent');
      });
      _cpToast('Aadhaar verified successfully.', 'success');
    } else {
      setState(() {
        _errors.add('aadhaarConsent');
      });
      _cpToast('Incorrect OTP. Use 1234 for the demo.', 'error');
    }
  }

  void _openSignatureSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: paperAlt,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return _SignatureDrawingSheet(
          onSave: () {
            setState(() {
              _signed = true;
              _signedAt = DateTime.now();
              _errors.remove('signed');
            });
            Navigator.pop(ctx);
            _cpToast('Signature saved', 'success');
          },
        );
      },
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime initialDate = DateTime.now();
    try {
      if (controller.text.isNotEmpty) {
        initialDate = DateTime.parse(controller.text);
      }
    } catch (_) {}

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1940),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: seal,
              onPrimary: white,
              surface: paperAlt,
              onSurface: ink,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        controller.text = _formatDateYMD(picked);
      });
    }
  }

  // BUILD WIDGET TREE
  @override
  Widget build(BuildContext context) {
    if (_appStage == 'status') {
      return _buildStatusScreen();
    }
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: const Color(0xFFDAD3BE),
        body: SafeArea(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 430),
              color: paper,
              child: Stack(
                children: [
                  Column(
                    children: [
                      _buildTopBar(),
                      Expanded(
                        child: _appStage == 'status'
                            ? _buildStatusScreen()
                            : _currentStepId.startsWith('q_')
                                ? _buildQuestionnaireScreen(_currentStepId)
                                : _buildFormStepScreen(_currentStepId),
                      ),
                    ],
                  ),
                  if (_toastMessage != null) _buildToastWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToastWidget() {
    final isError = _toastType == 'error';
    final isSuccess = _toastType == 'success';
    final bgColor = isError ? stamp : (isSuccess ? seal : ink);

    return Positioned(
      top: 70,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            _toastMessage!,
            style: const TextStyle(
              color: white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: seal,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'YUVA UDYAMI',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: paperAlt,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Channel Partner Registration',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFCFE3DA),
                ),
              ),
            ],
          ),
          OutlinedButton(
            onPressed: _resetApp,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0x59FFFFFF)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              '↺ Restart',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFFEAF3ED),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormStepScreen(String id) {
    final stepNum = int.tryParse(id.replaceAll('s', '')) ?? 1;
    final pct = ((stepNum * 100) ~/ 9).clamp(0, 100);

    final titles = {
      's1': 'About You',
      's2': 'Verify Your Aadhaar',
      's3': 'Business & Experience',
      's4': "Where You'll Work From",
      's5': 'Your Bank Details',
      's6': "What You'd Like to Do",
      's7': 'Availability & Comfort',
      's8': 'Consent',
      's9': 'Review Application',
    };

    final subtitles = {
      's1': 'As it appears on your Aadhaar / PAN card',
      's2': 'One secure government check',
      's3': 'Your business & savings/investment experience',
      's4': "We'll visit before approving",
      's5': 'For commission payments & FD refund',
      's6': 'Pick one module, or several',
      's7': 'With the Partner app',
      's8': 'Your promises, and your signature',
      's9': 'Check everything before you submit',
    };

    return Column(
      children: [
        // Progress Bar
        Container(
          color: paper,
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 5,
                decoration: BoxDecoration(
                  color: line,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: pct / 100.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: seal,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'STEP $stepNum/9',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color: sealDark,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    '$pct%',
                    style: const TextStyle(
                      fontSize: 11,
                      color: muted,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Step Heading
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
          decoration: const BoxDecoration(
            color: paper,
            border: Border(bottom: BorderSide(color: line)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titles[id] ?? '',
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitles[id] ?? '',
                style: const TextStyle(
                  fontSize: 13,
                  color: muted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),

        // Demo banner on Step 1
        if (id == 's1')
          Container(
            margin: const EdgeInsets.fromLTRB(18, 10, 18, 0),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: goldTint,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: gold, style: BorderStyle.solid),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Prototype demo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFF5B4415),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Use realistic sample data to test the complete journey.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF5B4415),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _loadDemoApplicant,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF8E7),
                    foregroundColor: const Color(0xFF5B4415),
                    side: const BorderSide(color: gold),
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    textStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Load Demo'),
                ),
              ],
            ),
          ),

        // Content Body
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildErrorBanner(),
                if (id == 's1') ..._buildStep1Fields(),
                if (id == 's2') ..._buildStep2Fields(),
                if (id == 's3') ..._buildStep3Fields(),
                if (id == 's4') ..._buildStep4Fields(),
                if (id == 's5') ..._buildStep5Fields(),
                if (id == 's6') ..._buildStep6Fields(),
                if (id == 's7') ..._buildStep7Fields(),
                if (id == 's8') ..._buildStep8Fields(),
                if (id == 's9') ..._buildStep9Fields(),
              ],
            ),
          ),
        ),

        // Footer
        _buildFooter(
          onBack: _goBack,
          onContinue: id == 's9' ? _submitApplication : _goNext,
          continueText: id == 's9' ? 'Submit Application' : 'Continue',
          canBack: id != 's1',
        ),
      ],
    );
  }

  Widget _buildErrorBanner() {
    if (_currentStepId == 's1' && _udyamiMember == 'No') {
      return Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: stampTint,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: stamp),
        ),
        child: const Text(
          'Membership required.\nYou must already be a Udyami Bharat / FCMCSL member to apply. Please register through One Core first.',
          style: TextStyle(
            color: stamp,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    if (_errors.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: stampTint,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: stamp),
        ),
        child: const Text(
          'Please complete the highlighted fields before continuing.',
          style: TextStyle(
            color: stamp,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  // STEP 1 FIELDS
  List<Widget> _buildStep1Fields() {
    return [
      _buildNote(
        "You must already be a Udyami Bharat / FCMCSL member to apply. If you're not yet a member, register through One Core first — the details below should match your One Core profile.",
      ),
      _buildRadioGroup(
        label: 'Are you already a Udyami Bharat / FCMCSL member?',
        required: true,
        options: const ['Yes', 'No'],
        value: _udyamiMember,
        hasError: _errors.contains('udyamiMember'),
        onChanged: (val) {
          setState(() {
            _udyamiMember = val;
            _errors.remove('udyamiMember');
            if (val == 'Yes' && _memberIdController.text.isEmpty) {
              _memberIdController.text = '123123';
            }
          });
        },
      ),
      if (_udyamiMember == 'Yes')
        _buildTextField(
          controller: _memberIdController,
          label: 'Member ID',
          placeholder: 'Enter your Member ID',
          required: true,
          hasError: _errors.contains('memberId'),
          onChanged: (_) => setState(() => _errors.remove('memberId')),
        ),
      _buildTextField(
        controller: _fullNameController,
        label: 'Full Name',
        help:
            'As on Aadhaar / PAN — for individual applicant or authorized representative',
        required: true,
        hasError: _errors.contains('fullName'),
        onChanged: (_) => setState(() => _errors.remove('fullName')),
      ),
      Row(
        children: [
          Expanded(
            child: _buildDateField(
              controller: _dobController,
              label: 'Date of Birth',
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildSelectField(
              label: 'Gender',
              value: _gender,
              options: const ['Male', 'Female', 'Other'],
              onChanged: (v) => setState(() => _gender = v),
            ),
          ),
        ],
      ),
      _buildTextField(
        controller: _fatherHusbandNameController,
        label: "Father's / Husband's Name",
      ),
      Row(
        children: [
          Expanded(
            child: _buildSelectField(
              label: 'Marital Status',
              value: _maritalStatus,
              options: const ['Single', 'Married', 'Other'],
              onChanged: (v) => setState(() => _maritalStatus = v),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              controller: _bloodGroupController,
              label: 'Blood Group',
              placeholder: 'e.g. B+',
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: _nationalityController,
              label: 'Nationality',
              placeholder: 'Indian',
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              controller: _languagesController,
              label: 'Languages Spoken',
              placeholder: 'Kannada, English',
            ),
          ),
        ],
      ),
      _buildTextField(
        controller: _mobileController,
        label: 'Mobile Number',
        help: "We'll send an OTP here",
        required: true,
        keyboardType: TextInputType.phone,
        hasError: _errors.contains('mobile'),
        onChanged: (_) => setState(() => _errors.remove('mobile')),
      ),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: _altMobileController,
              label: 'Alternate Mobile (optional)',
              keyboardType: TextInputType.phone,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              controller: _emailController,
              label: 'Email ID',
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ],
      ),
      _buildTextField(
        controller: _occupationController,
        label: 'Occupation',
        placeholder:
            'e.g. Career counselor, Skills trainer, HR professional, Entrepreneurship mentor',
      ),
      _buildSectionLabel('Your Address'),
      _buildTextField(
        controller: _houseStreetVillageController,
        label: 'House No. / Street / Village-Town',
        required: true,
        hasError: _errors.contains('houseStreetVillage'),
        onChanged: (_) => setState(() => _errors.remove('houseStreetVillage')),
      ),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: _talukController,
              label: 'Taluk',
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              controller: _districtController,
              label: 'District',
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: _stateNameController,
              label: 'State',
              required: true,
              hasError: _errors.contains('stateName'),
              onChanged: (_) => setState(() => _errors.remove('stateName')),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              controller: _pinController,
              label: 'PIN Code',
              required: true,
              keyboardType: TextInputType.number,
              hasError: _errors.contains('pin'),
              onChanged: (_) => setState(() => _errors.remove('pin')),
            ),
          ),
        ],
      ),
      _buildTextField(
        controller: _wardController,
        label: 'Ward / Hobli / Zone',
      ),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: _yearsLivedHereController,
              label: 'Years Lived Here',
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildSelectField(
              label: 'Home Type',
              value: _homeType,
              options: const ['Own', 'Rented', 'Family'],
              onChanged: (v) => setState(() => _homeType = v),
            ),
          ),
        ],
      ),
      _buildTextField(
        controller: _landmarkController,
        label: 'Nearest Landmark',
      ),
    ];
  }

  // STEP 2 FIELDS
  List<Widget> _buildStep2Fields() {
    return [
      _buildNote(
        "We'll confirm your identity via a one-time Aadhaar OTP check, through a secure, government-approved partner. Yuva Udyami never stores your Aadhaar number.",
      ),
      _buildTextField(
        controller: _aadhaarNumberController,
        label: 'Aadhaar Number',
        placeholder: 'XXXX XXXX XXXX',
        keyboardType: TextInputType.number,
      ),
      _buildTextField(
        controller: _aadhaarMobileController,
        label: 'Mobile Linked to Aadhaar',
        keyboardType: TextInputType.phone,
      ),
      _buildTextField(
        controller: _aadhaarNameController,
        label: 'Name on Aadhaar',
      ),
      const SizedBox(height: 10),
      if (_aadhaarOtpVerified)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: sealTint,
            border: Border.all(color: seal, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: const [
              Icon(Icons.check_circle, color: sealDark, size: 20),
              SizedBox(width: 8),
              Text(
                'Aadhaar verified successfully',
                style: TextStyle(
                  color: sealDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        )
      else ...[
        _buildCheckbox(
          label:
              'Yes, please verify my Aadhaar using OTP, through a secure government-approved partner.',
          required: true,
          value: _aadhaarConsent,
          hasError: _errors.contains('aadhaarConsent'),
          onChanged: (v) {
            setState(() {
              _aadhaarConsent = v;
              _aadhaarOtpSent = v;
              _aadhaarOtpVerified = false;
              if (v) _errors.remove('aadhaarConsent');
            });
          },
        ),
        if (_aadhaarOtpSent) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: paperAlt,
              border: Border.all(color: line, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter OTP *',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: inkSoft,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(4, (i) {
                          return Container(
                            width: 44,
                            height: 50,
                            margin: const EdgeInsets.only(right: 8),
                            child: TextField(
                              controller: _otpControllers[i],
                              focusNode: _otpFocusNodes[i],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: ink,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                filled: true,
                                fillColor: white,
                                contentPadding: EdgeInsets.zero,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: _errors.contains('aadhaarConsent')
                                        ? stamp
                                        : line,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: seal,
                                    width: 2,
                                  ),
                                ),
                              ),
                              onChanged: (val) {
                                if (val.isNotEmpty && i < 3) {
                                  _otpFocusNodes[i + 1].requestFocus();
                                }
                                final entered =
                                    _otpControllers.map((c) => c.text).join();
                                if (entered.length == 4) {
                                  _verifyOtp();
                                }
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: seal,
                        foregroundColor: white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: const Text(
                        'Verify',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Demo OTP: 1234',
                  style: TextStyle(
                    fontSize: 11,
                    color: muted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    ];
  }

  // STEP 3 FIELDS
  List<Widget> _buildStep3Fields() {
    return [
      _buildSectionLabel('Your Business'),
      _buildRadioGroup(
        label: 'Business Type',
        required: true,
        options: const [
          {'value': 'institutional', 'label': 'I run a registered business'},
          {'value': 'individual', 'label': 'Applying as an individual'},
        ],
        value: _businessType,
        onChanged: (v) {
          setState(() {
            _businessType = v ?? 'individual';
          });
        },
      ),
      if (_businessType == 'institutional') ...[
        _buildTextField(
          controller: _businessNameController,
          label: 'Business Name',
          required: true,
          hasError: _errors.contains('businessName'),
          onChanged: (_) => setState(() => _errors.remove('businessName')),
        ),
        Row(
          children: [
            Expanded(
              child: _buildSelectField(
                label: 'Type of Business',
                value: _typeOfBusiness,
                options: const [
                  'Proprietorship',
                  'Partnership',
                  'LLP',
                  'Pvt Ltd'
                ],
                onChanged: (v) => setState(() => _typeOfBusiness = v),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildDateField(
                controller: _startedOnController,
                label: 'Started On',
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _businessPanController,
                label: 'Business PAN (if diff.)',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildTextField(
                controller: _tanController,
                label: 'TAN (optional)',
              ),
            ),
          ],
        ),
        _buildTextField(
          controller: _gstNumberController,
          label: 'GST Number (if registered)',
        ),
        _buildTextField(
          controller: _udyamNumberController,
          label: 'Udyam / MSME Number',
        ),
        _buildTextField(
          controller: _tradeLicenceController,
          label: 'Trade Licence Number & Issued By',
        ),
      ],
      _buildSectionLabel('Savings, Investment & Client Advisory Experience'),
      _buildCheckbox(
        label: 'Yes, I have relevant experience',
        value: _hasExperience,
        onChanged: (v) => setState(() => _hasExperience = v),
      ),
      if (_hasExperience) ...[
        _buildTextField(
          controller: _whereWorkedController,
          label: 'Where You Worked',
        ),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _roleController,
                label: 'Your Role',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildTextField(
                controller: _howLongController,
                label: 'How Long (From–To)',
              ),
            ),
          ],
        ),
        _buildTextArea(
          controller: _whatYouDidController,
          label: 'What You Did',
        ),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _yearsExperienceController,
                label: 'Years of Experience',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildTextField(
                controller: _highestQualificationController,
                label: 'Highest Qualification',
              ),
            ),
          ],
        ),
        _buildTextField(
          controller: _toolsKnownController,
          label: 'Tools You Know (e.g. UPI Autopay, mutual fund portals)',
        ),
      ],
      const SizedBox(height: 10),
      _buildCheckboxGroup(
        label: 'Familiarity',
        options: const [
          'I know my way around KYC / AML basics',
          "I'm familiar with SIP / mutual-fund style savings plans",
          "I've explained investment products to clients before",
        ],
        selectedValues: _familiarityChecklist,
        onChanged: (opt, val) {
          setState(() {
            if (val) {
              _familiarityChecklist.add(opt);
            } else {
              _familiarityChecklist.remove(opt);
            }
          });
        },
      ),
      _buildSectionLabel('Any Other Work Experience'),
      _buildTextField(
        controller: _fieldSectorController,
        label: 'Field / Sector',
      ),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: _businessOrEmployerController,
              label: 'Business or Employer',
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              controller: _otherHowLongController,
              label: 'How Long (From–To)',
            ),
          ),
        ],
      ),
      _buildTextArea(
        controller: _otherWhatYouDidController,
        label: 'What You Did',
      ),
    ];
  }

  // STEP 4 FIELDS
  List<Widget> _buildStep4Fields() {
    return [
      _buildNote(
        "We'll visit before approving — client trust and document safety matter.",
      ),
      _buildTextField(
        controller: _workAddressController,
        label: 'Work Address',
      ),
      Row(
        children: [
          Expanded(
            child: _buildSelectField(
              label: 'Ownership',
              value: _ownership,
              options: const ['Owned', 'Rented', 'Leased'],
              onChanged: (v) => setState(() => _ownership = v),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              controller: _workLandmarkController,
              label: 'Nearest Landmark',
            ),
          ),
        ],
      ),
      _buildTextField(
        controller: _wardAreaServeController,
        label: "Ward / Area You'll Serve",
      ),
      _buildTextField(
        controller: _villagesCoveredController,
        label: 'Villages / Localities Covered',
      ),
      const SizedBox(height: 10),
      _buildCheckboxGroup(
        label: 'Facilities at Work Location',
        options: const [
          'Private area for clients to discuss their investments',
          'Secure, lockable place to store paperwork',
          'CCTV or other document security',
          'Internet access to log leads and savers',
          'Computer, scanner and printer on site',
          'Familiar with One Core KYC / onboarding process',
        ],
        selectedValues: _workFacilities,
        onChanged: (opt, val) {
          setState(() {
            if (val) {
              _workFacilities.add(opt);
            } else {
              _workFacilities.remove(opt);
            }
          });
        },
      ),
    ];
  }

  // STEP 5 FIELDS
  List<Widget> _buildStep5Fields() {
    return [
      _buildTextField(
        controller: _accountHolderNameController,
        label: 'Account Holder Name',
        required: true,
        hasError: _errors.contains('accountHolderName'),
        onChanged: (_) => setState(() => _errors.remove('accountHolderName')),
      ),
      Row(
        children: [
          Expanded(
            child: _buildSelectField(
              label: 'Account Type',
              value: _accountType,
              options: const ['Savings', 'Current'],
              onChanged: (v) => setState(() => _accountType = v),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              controller: _accountNumberController,
              label: 'Account Number',
              required: true,
              hasError: _errors.contains('accountNumber'),
              onChanged: (_) => setState(() => _errors.remove('accountNumber')),
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: _ifscController,
              label: 'IFSC Code',
              required: true,
              hasError: _errors.contains('ifsc'),
              onChanged: (_) => setState(() => _errors.remove('ifsc')),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              controller: _bankBranchController,
              label: 'Bank & Branch Name',
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      // Nominee panel
      Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFBF6E9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: gold,
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🛡 Alternate / Nominee Details',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: gold,
              ),
            ),
            const SizedBox(height: 10),
            _buildNote(
              "In the event of death or an unforeseen circumstance, any pending funds will be released to this nominee's account instead.",
            ),
            _buildTextField(
              controller: _nomineeNameController,
              label: 'Nominee Name',
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _relationshipController,
                    label: 'Relationship to You',
                    placeholder: 'e.g. Spouse, Son',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildTextField(
                    controller: _nomineeMobileController,
                    label: 'Nominee Mobile',
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            _buildTextField(
              controller: _nomineeAccountNumberController,
              label: 'Nominee Account Number',
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _nomineeIfscController,
                    label: 'IFSC Code',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildTextField(
                    controller: _nomineeBankBranchController,
                    label: 'Bank & Branch Name',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }

  // STEP 6 FIELDS
  List<Widget> _buildStep6Fields() {
    return [
      _buildNote(
        'Choose one, or several — commission and deposit terms are the same across all three modules: 4% commission, ₹5,00,000 security deposit per module.',
      ),
      if (_errors.contains('services'))
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: stampTint,
            border: Border.all(color: stamp),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'Please select at least one module.',
            style: TextStyle(color: stamp, fontSize: 12),
          ),
        ),
      ...YuvaUdyamiServiceCards.all.map((card) {
        final active = _services.contains(card.id);
        return GestureDetector(
          onTap: () => _toggleService(card.id),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: active ? sealTint : paperAlt,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: active ? seal : line,
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active ? seal : Colors.transparent,
                      border: Border.all(
                        color: active ? seal : line,
                        width: 1.5,
                      ),
                    ),
                    child: active
                        ? const Center(
                            child: Icon(
                              Icons.check,
                              color: white,
                              size: 14,
                            ),
                          )
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.icon,
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        card.name,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        card.desc,
                        style: const TextStyle(
                          fontSize: 12,
                          color: muted,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: goldTint,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          card.commission,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: gold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      _buildNote(
        'Pick one module, or several. After Continue, the relevant 20-question verification for each module opens, based on your Business Type from Step 3.',
      ),
      const SizedBox(height: 8),
      _buildTextField(
        controller: _wardAreaController,
        label: "Ward / Area You'd Like to Serve",
        required: true,
        hasError: _errors.contains('wardArea'),
        onChanged: (_) => setState(() => _errors.remove('wardArea')),
      ),
      _buildNote(
        "If your ward is full, you'll be waitlisted or offered a nearby open ward. You'll answer 20 verification questions for each module you select, based on whether you're applying as an individual or a registered business.",
      ),
    ];
  }

  // QUESTIONNAIRE SCREEN
  Widget _buildQuestionnaireScreen(String qid) {
    final data = YuvaUdyamiQuestionnaires.all[qid];
    if (data == null) {
      return Center(
        child: Text('Questionnaire not found: $qid'),
      );
    }

    final catIdx = _qCat[qid] ?? 0;
    final cat = data.categories[catIdx];
    final isLastSection = catIdx == data.categories.length - 1;

    return Column(
      children: [
        // Questionnaire Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: const BoxDecoration(
            color: goldTint,
            border: Border(bottom: BorderSide(color: line)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'VERIFICATION QUESTIONNAIRE · INSERTED AFTER STEP 6',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.bold,
                  color: gold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                data.title,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: muted,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              // Dots
              Row(
                children: List.generate(data.categories.length, (i) {
                  final active = i == catIdx;
                  final done = i < catIdx;
                  return Container(
                    margin: const EdgeInsets.only(right: 6),
                    width: active ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? seal : (done ? gold : line),
                      borderRadius: BorderRadius.circular(active ? 5 : 4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                'Section ${catIdx + 1} of ${data.categories.length} · ${cat.name}',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: sealDark,
                ),
              ),
            ],
          ),
        ),

        // Questions Content
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: cat.questions.asMap().entries.map((entry) {
                final idx = entry.key;
                final qText = entry.value;
                final qNum = cat.startNum + idx;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$qNum. $qText',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: ink,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: TextEditingController(text: _qa[qNum] ?? '')
                          ..selection = TextSelection.fromPosition(
                            TextPosition(offset: (_qa[qNum] ?? '').length),
                          ),
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Type your answer…',
                          hintStyle: const TextStyle(color: Color(0xFFB3A98F)),
                          filled: true,
                          fillColor: paperAlt,
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: line, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: line, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: seal, width: 1.5),
                          ),
                        ),
                        onChanged: (val) {
                          _qa[qNum] = val;
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Footer
        _buildFooter(
          onBack: () {
            if (catIdx > 0) {
              setState(() {
                _qCat[qid] = catIdx - 1;
              });
              _scrollToTop();
            } else {
              _goBack();
            }
          },
          onContinue: () {
            if (!isLastSection) {
              setState(() {
                _qCat[qid] = catIdx + 1;
              });
              _scrollToTop();
            } else {
              final seq = _buildSequence();
              final curIdx = seq.indexOf(qid);
              if (curIdx >= 0 && curIdx < seq.length - 1) {
                setState(() {
                  _currentStepId = seq[curIdx + 1];
                });
                _scrollToTop();
              }
            }
          },
          continueText: isLastSection ? 'Continue' : 'Next Section',
          canBack: true,
        ),
      ],
    );
  }

  // STEP 7 FIELDS
  List<Widget> _buildStep7Fields() {
    return [
      _buildTextField(
        controller: _newSaversPerMonthController,
        label: 'New Savers / Investors You Expect to Onboard Per Month',
        keyboardType: TextInputType.number,
      ),
      Row(
        children: [
          Expanded(
            child: _buildRadioGroup(
              label: 'Hire Support Staff?',
              options: const ['Yes', 'No'],
              value: _hireSupportStaff,
              onChanged: (v) => setState(() => _hireSupportStaff = v),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildSelectField(
              label: 'Best Time for Training',
              value: _bestTimeTraining,
              options: const ['Weekdays', 'Weekends', 'Both', 'Flexible'],
              onChanged: (v) => setState(() => _bestTimeTraining = v),
            ),
          ),
        ],
      ),
      _buildSectionLabel('Smartphone & App Experience'),
      _buildRadioGroup(
        label: 'Which Smartphone Do You Use?',
        options: const ['Android', 'iPhone (iOS)', 'Both'],
        value: _smartphone,
        onChanged: (v) => setState(() => _smartphone = v),
      ),
      _buildRadioGroup(
        label: 'Comfort Using Smartphone Apps?',
        options: const [
          'Very Comfortable',
          'Comfortable',
          'Need Training',
          'Not Comfortable'
        ],
        value: _comfortApps,
        onChanged: (v) => setState(() => _comfortApps = v),
      ),
      _buildRadioGroup(
        label: 'Used Apps for Investments / Online Forms?',
        options: const ['Yes, Regularly', 'Yes, Sometimes', 'No'],
        value: _usedAppsForInvestments,
        onChanged: (v) => setState(() => _usedAppsForInvestments = v),
      ),
      _buildRadioGroup(
        label: 'Comfort With UPI Autopay, OTP & Digital Payments?',
        options: const [
          'Very Comfortable',
          'Comfortable',
          'Need Guidance',
          'Need Full Training'
        ],
        value: _comfortPayments,
        onChanged: (v) => setState(() => _comfortPayments = v),
      ),
      _buildSectionLabel('Language & Client Communication'),
      _buildCheckboxGroup(
        label: 'Language & App Comfort',
        options: const [
          "I'm comfortable using the Partner app already",
          "I'll need a bit of training first",
          'I can talk to clients in Kannada',
          'I can talk to clients in English',
        ],
        selectedValues: _langComm,
        onChanged: (opt, val) {
          setState(() {
            if (val) {
              _langComm.add(opt);
            } else {
              _langComm.remove(opt);
            }
          });
        },
      ),
    ];
  }

  // STEP 8 FIELDS
  List<Widget> _buildStep8Fields() {
    return [
      _buildCheckbox(
        label: 'I agree to the Aadhaar identity check described in Step 2.',
        required: true,
        value: _c1,
        hasError: _errors.contains('c1'),
        onChanged: (v) => setState(() {
          _c1 = v;
          if (v) _errors.remove('c1');
        }),
      ),
      _buildCheckbox(
        label: 'I understand my account stays inactive until I finish training.',
        required: true,
        value: _c2,
        hasError: _errors.contains('c2'),
        onChanged: (v) => setState(() {
          _c2 = v;
          if (v) _errors.remove('c2');
        }),
      ),
      _buildCheckbox(
        label:
            "I'll keep every client's personal and financial information safe, secure and private.",
        required: true,
        value: _c3,
        hasError: _errors.contains('c3'),
        onChanged: (v) => setState(() {
          _c3 = v;
          if (v) _errors.remove('c3');
        }),
      ),
      _buildCheckbox(
        label:
            "I don't have any conflict of interest that would get in the way of this role.",
        required: true,
        value: _c4,
        hasError: _errors.contains('c4'),
        onChanged: (v) => setState(() {
          _c4 = v;
          if (v) _errors.remove('c4');
        }),
      ),
      _buildCheckbox(
        label:
            'I understand returns are projections, not guarantees, and I will never promise assured returns to a member.',
        required: true,
        value: _c5,
        hasError: _errors.contains('c5'),
        onChanged: (v) => setState(() {
          _c5 = v;
          if (v) _errors.remove('c5');
        }),
      ),
      _buildCheckbox(
        label:
            'I understand Yuva Udyami holds no member money directly — all contributions post through One Core.',
        required: true,
        value: _c6,
        hasError: _errors.contains('c6'),
        onChanged: (v) => setState(() {
          _c6 = v;
          if (v) _errors.remove('c6');
        }),
      ),
      _buildCheckbox(
        label: "I've read the Yuva Udyami Code of Conduct and I'll follow it.",
        required: true,
        value: _c7,
        hasError: _errors.contains('c7'),
        onChanged: (v) => setState(() {
          _c7 = v;
          if (v) _errors.remove('c7');
        }),
      ),
      _buildCheckbox(
        label: "Everything I've written in this form is true.",
        required: true,
        value: _c8,
        hasError: _errors.contains('c8'),
        onChanged: (v) => setState(() {
          _c8 = v;
          if (v) _errors.remove('c8');
        }),
      ),
      _buildCheckbox(
        label:
            "I've read the plain-language summary and full agreement, and I agree to it.",
        required: true,
        value: _c9,
        hasError: _errors.contains('c9'),
        onChanged: (v) => setState(() {
          _c9 = v;
          if (v) _errors.remove('c9');
        }),
      ),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: _placeController,
              label: 'Place',
              required: true,
              hasError: _errors.contains('place'),
              onChanged: (_) => setState(() => _errors.remove('place')),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildDateField(
              controller: _date8Controller,
              label: 'Date',
              required: true,
              hasError: _errors.contains('date8'),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Signature *',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: inkSoft,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tap to Sign',
                  style: TextStyle(
                    fontSize: 11,
                    color: muted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _openSignatureSheet,
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: _signed ? sealTint : paperAlt,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _errors.contains('signed')
                            ? stamp
                            : (_signed ? seal : line),
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _signed
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _fullNameController.text.isNotEmpty
                                    ? _fullNameController.text
                                    : 'Signed',
                                style: const TextStyle(
                                  fontFamily: 'serif',
                                  fontSize: 20,
                                  color: sealDark,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              if (_signedAt != null)
                                Text(
                                  'Signed ${_formatDateDisplay(_signedAt!)}',
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    color: muted,
                                  ),
                                ),
                            ],
                          )
                        : const Text(
                            '✍️ Tap to sign',
                            style: TextStyle(fontSize: 12, color: muted),
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thumb Impression (optional)',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: inkSoft,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  ' ',
                  style: TextStyle(fontSize: 11),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _thumbImpression = !_thumbImpression;
                    });
                  },
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: _thumbImpression ? sealTint : paperAlt,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _thumbImpression ? seal : line,
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _thumbImpression ? '👍 Captured' : 'Tap to capture',
                      style: TextStyle(
                        fontSize: 12,
                        color: _thumbImpression ? sealDark : muted,
                        fontWeight: _thumbImpression
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  // STEP 9 FIELDS (REVIEW)
  List<Widget> _buildStep9Fields() {
    return [
      _buildNote(
        "Here's what you've entered. Go back to any earlier step to make changes before submitting.",
      ),
      _buildReviewBlocks(),
      const SizedBox(height: 14),
      _buildSectionLabel('Security Deposit (shown after Ward Head acceptance & onboarding meeting)'),
      _buildDepositTable(),
      const SizedBox(height: 12),
      _buildCheckbox(
        label: "I'll only pay this after approval — within 7 days.",
        required: true,
        value: _depositAck1,
        hasError: _errors.contains('depositAck1'),
        onChanged: (v) => setState(() {
          _depositAck1 = v;
          if (v) _errors.remove('depositAck1');
        }),
      ),
      _buildCheckbox(
        label:
            "I'll get this back within 30 days if I leave or resign — or I can leave it deposited.",
        required: true,
        value: _depositAck2,
        hasError: _errors.contains('depositAck2'),
        onChanged: (v) => setState(() {
          _depositAck2 = v;
          if (v) _errors.remove('depositAck2');
        }),
      ),
      _buildNote(
        "You'll receive a 4% commission on the facilitation fee value for the following 12 months, per module you're onboarded in. Every commission payment goes through One Core — never cash. Returns shown to members are projections, never guarantees.",
      ),
    ];
  }

  Widget _buildReviewBlocks() {
    final modulesName = _services.map((s) {
      final card = YuvaUdyamiServiceCards.all.firstWhere(
        (c) => c.id == s,
        orElse: () => YuvaUdyamiServiceCard(id: s, icon: '', name: s, desc: ''),
      );
      return card.name;
    }).join(', ');

    final sections = [
      {
        'id': 's1',
        'title': 'About You',
        'rows': [
          if (_memberIdController.text.isNotEmpty)
            {'label': 'Member ID', 'value': _memberIdController.text},
          {'label': 'Full Name', 'value': _fullNameController.text},
          if (_dobController.text.isNotEmpty)
            {'label': 'Date of Birth', 'value': _dobController.text},
          if (_gender != null) {'label': 'Gender', 'value': _gender!},
          if (_mobileController.text.isNotEmpty)
            {'label': 'Mobile Number', 'value': _mobileController.text},
          if (_stateNameController.text.isNotEmpty)
            {'label': 'State', 'value': _stateNameController.text},
          if (_pinController.text.isNotEmpty)
            {'label': 'PIN Code', 'value': _pinController.text},
        ],
      },
      {
        'id': 's2',
        'title': 'Verify Your Aadhaar',
        'rows': [
          if (_aadhaarNumberController.text.isNotEmpty)
            {'label': 'Aadhaar Number', 'value': _aadhaarNumberController.text},
          {
            'label': 'Aadhaar Status',
            'value': _aadhaarOtpVerified ? 'Verified' : 'Pending',
          },
        ],
      },
      {
        'id': 's3',
        'title': 'Business & Experience',
        'rows': [
          {
            'label': 'Business Type',
            'value': _businessType == 'institutional'
                ? 'Registered Business'
                : 'Individual',
          },
          if (_businessNameController.text.isNotEmpty)
            {'label': 'Business Name', 'value': _businessNameController.text},
          if (_hasExperience) ...[
            if (_whereWorkedController.text.isNotEmpty)
              {'label': 'Where You Worked', 'value': _whereWorkedController.text},
            if (_roleController.text.isNotEmpty)
              {'label': 'Your Role', 'value': _roleController.text},
          ],
        ],
      },
      {
        'id': 's4',
        'title': "Where You'll Work From",
        'rows': [
          if (_workAddressController.text.isNotEmpty)
            {'label': 'Work Address', 'value': _workAddressController.text},
          if (_ownership != null) {'label': 'Ownership', 'value': _ownership!},
          if (_wardAreaServeController.text.isNotEmpty)
            {
              'label': "Ward / Area You'll Serve",
              'value': _wardAreaServeController.text,
            },
        ],
      },
      {
        'id': 's5',
        'title': 'Your Bank Details',
        'rows': [
          {
            'label': 'Account Holder Name',
            'value': _accountHolderNameController.text,
          },
          {'label': 'Account Number', 'value': _accountNumberController.text},
          {'label': 'IFSC Code', 'value': _ifscController.text},
          if (_nomineeNameController.text.isNotEmpty)
            {'label': 'Nominee Name', 'value': _nomineeNameController.text},
        ],
      },
      {
        'id': 's6',
        'title': "What You'd Like to Do",
        'rows': [
          {'label': 'Modules', 'value': modulesName},
          if (_wardAreaController.text.isNotEmpty)
            {
              'label': "Ward / Area You'd Like to Serve",
              'value': _wardAreaController.text,
            },
        ],
      },
      {
        'id': 's7',
        'title': 'Availability & Comfort',
        'rows': [
          if (_newSaversPerMonthController.text.isNotEmpty)
            {
              'label': 'Expected New Savers / Month',
              'value': _newSaversPerMonthController.text,
            },
          if (_smartphone != null)
            {'label': 'Smartphone', 'value': _smartphone!},
        ],
      },
      {
        'id': 's8',
        'title': 'Consent',
        'rows': [
          if (_placeController.text.isNotEmpty)
            {'label': 'Place', 'value': _placeController.text},
          if (_date8Controller.text.isNotEmpty)
            {'label': 'Date', 'value': _date8Controller.text},
          {'label': 'Signature', 'value': _signed ? 'Signed' : 'Pending'},
          if (_thumbImpression)
            {'label': 'Thumb Impression', 'value': 'Captured'},
        ],
      },
    ];

    final bt = _businessType == 'institutional' ? 'institutional' : 'individual';
    final qids = _services.map((s) => 'q_${s}_$bt').toList();

    return Column(
      children: [
        ...sections.map((sec) {
          final rows = sec['rows'] as List<Map<String, String>>;
          if (rows.isEmpty) return const SizedBox.shrink();

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: paperAlt,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: line),
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDE6D2),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        sec['title'] as String,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: sealDark,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentStepId = sec['id'] as String;
                          });
                          _scrollToTop();
                        },
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: stamp,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ...rows.map((r) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: line)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r['label']!,
                          style: const TextStyle(fontSize: 12, color: muted),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            r['value']!,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),

        // Questionnaire Review Blocks
        ...qids.map((qid) {
          final qData = YuvaUdyamiQuestionnaires.all[qid];
          if (qData == null) return const SizedBox.shrink();

          final answeredList = <Widget>[];
          for (var c in qData.categories) {
            answeredList.add(
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                color: paper,
                child: Text(
                  c.name,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: sealDark,
                  ),
                ),
              ),
            );

            for (int i = 0; i < c.questions.length; i++) {
              final n = c.startNum + i;
              final ans = (_qa[n] ?? '').trim();
              if (ans.isNotEmpty) {
                answeredList.add(
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: line)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$n. ${c.questions[i]}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: inkSoft,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ans,
                          style: const TextStyle(fontSize: 12, color: ink),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: paperAlt,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDE6D2),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          qData.title,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: sealDark,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentStepId = qid;
                          });
                          _scrollToTop();
                        },
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: stamp,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ...answeredList,
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDepositTable() {
    final deposit = _computeDeposit();
    final rows = deposit['rows'] as List<dynamic>;
    final total = deposit['total'] as int;

    return Container(
      decoration: BoxDecoration(
        color: paperAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: line),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: line, width: 1.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'MODULE',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: muted,
                  ),
                ),
                Text(
                  'AMOUNT',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),
          ...rows.map((r) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: line)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    r['label'] as String,
                    style: const TextStyle(fontSize: 12.5, color: ink),
                  ),
                  Text(
                    _formatINR(r['amount'] as num),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: gold,
                    ),
                  ),
                ],
              ),
            );
          }),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: const Color(0xFFEDE6D2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Security Deposit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: ink,
                  ),
                ),
                Text(
                  _formatINR(total),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: gold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitApplication() {
    if (_validateCurrentStep()) {
      setState(() {
        _appStage = 'status';
        _statusStage = 'submitted';
      });
      _scrollToTop();
      _cpToast('Application submitted successfully!', 'success');
    } else {
      _cpToast('Please check the required acknowledgements.', 'error');
    }
  }

  // STATUS SCREEN
  int _mapStatusToStageIndex(String stage) {
    switch (stage) {
      case 'submitted':
        return 1; // Under Review
      case 'meeting':
      case 'interrogation':
        return 2; // Interrogation
      case 'training':
        return 3; // Training
      case 'completed':
      case 'payment':
        return 4; // Completed
      case 'onboarded':
      case 'active':
        return 5; // Active
      default:
        return 1;
    }
  }

  Widget _buildStatusScreen() {
    return ApplicationStatusView(
      theme: CompanyStatusTheme.yuvaUdyami(),
      initialStageIndex: _mapStatusToStageIndex(_statusStage),
      applicantName: _fullNameController.text.trim().isNotEmpty ? _fullNameController.text.trim() : 'Pooja Hegde',
      applicationId: '#YU-${DateTime.now().year}-7720',
      wardLocality: _wardAreaController.text.trim().isNotEmpty ? _wardAreaController.text.trim() : 'Ward 08, Malleshwaram',
      onRestart: _resetApp,
      onStageChanged: (stageIndex) {
        setState(() {
          if (stageIndex <= 0) {
            _statusStage = 'submitted';
          } else if (stageIndex == 1) {
            _statusStage = 'submitted';
          } else if (stageIndex == 2) {
            _statusStage = 'meeting';
          } else if (stageIndex == 3) {
            _statusStage = 'training';
          } else if (stageIndex == 4) {
            _statusStage = 'payment';
          } else {
            _statusStage = 'onboarded';
          }
        });
      },
    );
  }

  Widget _buildDemoStatusBtn(String statusId, String label) {
    final active = _statusStage == statusId;
    return ActionChip(
      label: Text(label),
      backgroundColor: active ? sealTint : paperAlt,
      side: BorderSide(color: active ? seal : line),
      labelStyle: TextStyle(
        fontSize: 11,
        color: active ? sealDark : inkSoft,
        fontWeight: active ? FontWeight.bold : FontWeight.normal,
      ),
      onPressed: () {
        setState(() => _statusStage = statusId);
      },
    );
  }

  Widget _buildMeetingRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.5, color: muted)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: ink,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(List<String> steps, int activeIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: steps.asMap().entries.map((e) {
          final idx = e.key;
          final title = e.value;
          final done = idx < activeIndex;
          final current = idx == activeIndex;

          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 2,
                        color: idx == 0 ? Colors.transparent : (done || current ? seal : line),
                      ),
                    ),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done ? seal : (current ? white : paperAlt),
                        border: Border.all(
                          color: done || current ? seal : line,
                          width: 2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: idx == steps.length - 1 ? Colors.transparent : (done ? seal : line),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: (done || current) ? FontWeight.bold : FontWeight.normal,
                    color: (done || current) ? sealDark : muted,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // WIDGET HELPERS
  Widget _buildNote(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: paperAlt,
        border: Border(left: BorderSide(color: gold, width: 3)),
      ),
      child: Text(
        text.replaceAll('<strong>', '').replaceAll('</strong>', ''),
        style: const TextStyle(
          fontSize: 12.5,
          color: muted,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 22, bottom: 10),
      padding: const EdgeInsets.only(bottom: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: line)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'serif',
          fontWeight: FontWeight.bold,
          fontSize: 14.5,
          color: sealDark,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? placeholder,
    String? help,
    bool required = false,
    bool hasError = false,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: inkSoft,
              ),
              children: [
                if (required)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: stamp),
                  ),
              ],
            ),
          ),
          if (help != null) ...[
            const SizedBox(height: 2),
            Text(
              help,
              style: const TextStyle(
                fontSize: 11.5,
                color: muted,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14.5, color: ink),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(color: Color(0xFFB3A98F)),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: hasError ? stamp : line,
                  width: 1.5,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: seal, width: 2),
              ),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String label,
    String? placeholder,
    bool required = false,
    bool hasError = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: inkSoft,
              ),
              children: [
                if (required)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: stamp),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: 3,
            style: const TextStyle(fontSize: 14.5, color: ink),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(color: Color(0xFFB3A98F)),
              filled: true,
              fillColor: paperAlt,
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: hasError ? stamp : line, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: hasError ? stamp : line, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: seal, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    bool required = false,
    bool hasError = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: inkSoft,
              ),
              children: [
                if (required)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: stamp),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () => _selectDate(context, controller),
            child: AbsorbPointer(
              child: TextField(
                controller: controller,
                style: const TextStyle(fontSize: 14.5, color: ink),
                decoration: InputDecoration(
                  hintText: 'YYYY-MM-DD',
                  hintStyle: const TextStyle(color: Color(0xFFB3A98F)),
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                  suffixIcon: const Icon(Icons.calendar_today,
                      size: 16, color: muted),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: hasError ? stamp : line,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: seal, width: 2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectField({
    required String label,
    required String? value,
    required List<String> options,
    required void Function(String?) onChanged,
    bool required = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: inkSoft,
              ),
              children: [
                if (required)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: stamp),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            key: ValueKey('$label-$value'),
            initialValue: value != null && options.contains(value) ? value : null,
            isDense: true,
            style: const TextStyle(fontSize: 14.5, color: ink),
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: line, width: 1.5),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: seal, width: 2),
              ),
            ),
            hint: const Text('Select…',
                style: TextStyle(color: Color(0xFFB3A98F), fontSize: 14.5)),
            items: options.map((opt) {
              return DropdownMenuItem(value: opt, child: Text(opt));
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildRadioGroup({
    required String label,
    required List<dynamic> options,
    required String? value,
    required void Function(String?) onChanged,
    bool required = false,
    bool hasError = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: inkSoft,
              ),
              children: [
                if (required)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: stamp),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: options.map((opt) {
              final val = opt is Map ? opt['value'] : opt.toString();
              final text = opt is Map ? opt['label'] : opt.toString();
              final active = value == val;

              return GestureDetector(
                onTap: () => onChanged(val),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: active ? sealTint : paperAlt,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: hasError ? stamp : (active ? seal : line),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 17,
                        height: 17,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: active ? seal : line,
                            width: 2,
                          ),
                        ),
                        child: active
                            ? Center(
                                child: Container(
                                  width: 9,
                                  height: 9,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: seal,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          text,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox({
    required String label,
    required bool value,
    required void Function(bool) onChanged,
    bool required = false,
    bool hasError = false,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: paperAlt,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hasError ? stamp : line,
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                color: value ? seal : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: value ? seal : line,
                  width: 2,
                ),
              ),
              child: value
                  ? const Center(
                      child: Icon(Icons.check, size: 13, color: white),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: ink,
                    height: 1.4,
                  ),
                  children: [
                    if (required)
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(color: stamp),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxGroup({
    required String label,
    required List<String> options,
    required Set<String> selectedValues,
    required void Function(String, bool) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: inkSoft,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: paperAlt,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: line),
          ),
          child: Column(
            children: options.map((opt) {
              final active = selectedValues.contains(opt);
              return GestureDetector(
                onTap: () => onChanged(opt, !active),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: active ? seal : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: active ? seal : line,
                            width: 2,
                          ),
                        ),
                        child: active
                            ? const Center(
                                child: Icon(Icons.check, size: 11, color: white),
                              )
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          opt,
                          style: const TextStyle(
                            fontSize: 13,
                            color: ink,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter({
    required VoidCallback onBack,
    required VoidCallback onContinue,
    required String continueText,
    required bool canBack,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: const BoxDecoration(
        color: paperAlt,
        border: Border(top: BorderSide(color: line)),
      ),
      child: Row(
        children: [
          OutlinedButton(
            onPressed: canBack ? onBack : null,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: line),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Back',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: inkSoft,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: seal,
                foregroundColor: white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                continueText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// SIGNATURE SHEET
class _SignatureDrawingSheet extends StatefulWidget {
  final VoidCallback onSave;

  const _SignatureDrawingSheet({required this.onSave});

  @override
  State<_SignatureDrawingSheet> createState() => _SignatureDrawingSheetState();
}

class _SignatureDrawingSheetState extends State<_SignatureDrawingSheet> {
  final List<Offset?> _points = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        18,
        18,
        18,
        18 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Add your signature',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E2A44),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Draw below or use the demo signature for user testing.',
            style: TextStyle(fontSize: 12, color: Color(0xFF7A7360)),
          ),
          const SizedBox(height: 12),
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD9D0B8)),
            ),
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  final renderBox = context.findRenderObject() as RenderBox?;
                  if (renderBox != null) {
                    _points.add(details.localPosition);
                  }
                });
              },
              onPanEnd: (_) => setState(() => _points.add(null)),
              child: CustomPaint(
                painter: _SignaturePainter(points: _points),
                size: Size.infinite,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              OutlinedButton(
                onPressed: () => setState(() => _points.clear()),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFD9D0B8)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Clear',
                  style: TextStyle(color: Color(0xFF3E4A63)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E5C4A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Save Signature'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset?> points;

  _SignaturePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0E5C4A)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.5;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
