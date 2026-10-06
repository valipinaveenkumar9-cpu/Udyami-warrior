import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/build_ai_homes_models.dart';
import '../widgets/application_status_view.dart';

class BuildAiHomesForm extends StatefulWidget {
  final String? verticalId;
  final String? companyName;
  final Map<String, dynamic>? initialApplicationData;

  const BuildAiHomesForm({
    super.key,
    this.verticalId,
    this.companyName,
    this.initialApplicationData,
  });

  @override
  State<BuildAiHomesForm> createState() => _BuildAiHomesFormState();
}

class _BuildAiHomesFormState extends State<BuildAiHomesForm> {
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
  final Map<String, int> _qCat = {}; // category index (0,1,2,3) for each questionnaire
  final Map<int, String> _qa = {}; // question number -> answer string

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
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());

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

  // Other work experience
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
  String _accountType = 'Savings';
  final _accountNumberController = TextEditingController();
  final _ifscController = TextEditingController();
  final _bankBranchController = TextEditingController();

  // Nominee Details panel
  final _nomineeNameController = TextEditingController();
  final _relationshipController = TextEditingController();
  final _nomineeMobileController = TextEditingController();
  final _nomineeAccountNumberController = TextEditingController();
  final _nomineeIfscController = TextEditingController();
  final _nomineeBankBranchController = TextEditingController();

  // Step 6: What You'd Like to Do
  final List<String> _services = []; // Module IDs: 'lands', 'turnkey', 'interiors', 'exterior', 'landscape'
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

  // Step 9: Review & Deposit Acknowledgments
  bool _depositAck1 = false;
  bool _depositAck2 = false;

  // Status Screen: Payment Simulation
  String _selectedPaymentMethod = 'UPI';
  final _upiIdController = TextEditingController(text: 'applicant@upi');
  bool _isPaymentProcessing = false;

  // Toast State
  String? _toastMessage;
  String _toastType = 'info'; // 'info', 'success', 'error'
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
    _toastTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  // ==================== HELPER METHODS ====================
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
    return "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  String _formatDateDisplay(DateTime d) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return "${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}";
  }

  List<String> _buildSequence() {
    final seq = ['s1', 's2', 's3', 's4', 's5', 's6'];
    final bt = _businessType == 'institutional' ? 'institutional' : 'individual';
    for (var svc in _services) {
      seq.add('q_${svc}_$bt');
    }
    seq.addAll(['s7', 's8', 's9']);
    return seq;
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
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

  void _resetApp() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: paperAlt,
        title: const Text('Start over?', style: TextStyle(fontFamily: 'serif', color: ink)),
        content: const Text('This clears everything you\'ve entered.', style: TextStyle(color: inkSoft)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: muted)),
          ),
          TextButton(
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
              _cpToast('Form restarted', 'info');
              _scrollToTop();
            },
            child: const Text('Start Over', style: TextStyle(color: stamp, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _loadDemoData() {
    setState(() {
      _udyamiMember = 'Yes';
      _memberIdController.text = '123123';
      _fullNameController.text = 'Suresh Naik';
      _dobController.text = '1985-02-27';
      _gender = 'Male';
      _fatherHusbandNameController.text = 'Ramesh Naik';
      _maritalStatus = 'Married';
      _bloodGroupController.text = 'AB+';
      _nationalityController.text = 'Indian';
      _languagesController.text = 'Kannada, English, Tulu';
      _mobileController.text = '9880023344';
      _emailController.text = 'suresh.naik@example.test';
      _occupationController.text = 'Civil engineer';

      _houseStreetVillageController.text = '34, Ring Road, Vijayanagar';
      _talukController.text = 'Bengaluru West';
      _districtController.text = 'Bengaluru Urban';
      _stateNameController.text = 'Karnataka';
      _pinController.text = '560040';
      _wardController.text = 'Vijayanagar Ward';
      _yearsLivedHereController.text = '14';
      _homeType = 'Own';
      _landmarkController.text = 'Near Vijayanagar Metro Station';

      _aadhaarNumberController.text = '567890123456';
      _aadhaarMobileController.text = '9880023344';
      _aadhaarNameController.text = 'Suresh Naik';
      _aadhaarConsent = true;
      _aadhaarOtpSent = false;
      _aadhaarOtpVerified = true;
      _otpControllers[0].text = '1';
      _otpControllers[1].text = '2';
      _otpControllers[2].text = '3';
      _otpControllers[3].text = '4';

      _businessType = 'institutional';
      _businessNameController.text = 'Naik Constructions Pvt Ltd';
      _typeOfBusiness = 'Pvt Ltd';
      _startedOnController.text = '2011-06-01';
      _businessPanController.text = '';
      _tanController.text = '';
      _gstNumberController.text = '29ABCDE5678F1Z2';
      _udyamNumberController.text = 'UDYAM-KA-03-7654321';
      _tradeLicenceController.text = '';

      _hasExperience = true;
      _whereWorkedController.text = 'Naik Constructions Pvt Ltd';
      _roleController.text = 'Site Engineer & Project Lead';
      _howLongController.text = '2011–2026';
      _whatYouDidController.text = 'Supervised residential and layout construction sites, coordinated with landowners on JD/JV terms, and managed QA milestone sign-offs.';
      _yearsExperienceController.text = '15';
      _highestQualificationController.text = 'B.E. Civil';
      _toolsKnownController.text = 'AutoCAD, site management apps, UPI Autopay';
      _familiarityChecklist.clear();
      _familiarityChecklist.addAll([
        'I know my way around KYC / AML basics',
        "I've explained investment products to clients before",
      ]);

      _fieldSectorController.clear();
      _businessOrEmployerController.clear();
      _otherHowLongController.clear();
      _otherWhatYouDidController.clear();

      _workAddressController.text = '34, Ring Road, Vijayanagar, Bengaluru';
      _ownership = 'Owned';
      _workLandmarkController.text = 'Vijayanagar Metro Station';
      _wardAreaServeController.text = 'Vijayanagar Ward';
      _villagesCoveredController.text = 'Vijayanagar, Basaveshwaranagar, Nagarabhavi';
      _workFacilities.clear();
      _workFacilities.addAll([
        'Private area for clients to discuss their investments',
        'Secure, lockable place to store paperwork',
        'Internet access to log leads and savers',
        'Computer, scanner and printer on site',
        'Familiar with One Core KYC / onboarding process',
      ]);

      _accountHolderNameController.text = 'Suresh Naik';
      _accountType = 'Current';
      _accountNumberController.text = 'XXXXXX8811';
      _ifscController.text = 'ICIC0003344';
      _bankBranchController.text = 'Vijayanagar Branch';

      _nomineeNameController.text = 'Kavitha Naik';
      _relationshipController.text = 'Spouse';
      _nomineeMobileController.text = '9880099887';
      _nomineeAccountNumberController.text = 'XXXXXX2266';
      _nomineeIfscController.text = 'ICIC0003344';
      _nomineeBankBranchController.text = 'Vijayanagar Branch';

      _services.clear();
      _services.addAll(['lands', 'turnkey']);
      _wardAreaController.text = 'Vijayanagar Ward';

      _newSaversPerMonthController.text = '8';
      _hireSupportStaff = 'Yes';
      _bestTimeTraining = 'Weekdays';
      _smartphone = 'Android';
      _comfortApps = 'Comfortable';
      _usedAppsForInvestments = 'Yes, Sometimes';
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
      _signedAt = DateTime(2026, 8, 31);
      _thumbImpression = false;

      _depositAck1 = true;
      _depositAck2 = true;

      _errors.clear();
      _currentStepId = 's1';
      _appStage = 'form';
    });
    _cpToast('Demo applicant loaded', 'success');
  }

  // ==================== VALIDATION & NAVIGATION ====================
  bool _validateStep(String id) {
    final missing = <String>{};

    if (id == 's1') {
      if (_udyamiMember == null || _udyamiMember!.isEmpty) {
        missing.add('udyamiMember');
      } else if (_udyamiMember == 'No') {
        missing.add('udyamiMember');
      } else if (_udyamiMember == 'Yes') {
        if (_memberIdController.text.trim().isEmpty) {
          _memberIdController.text = '123123';
        }
      }
      if (_fullNameController.text.trim().isEmpty) missing.add('fullName');
      if (_mobileController.text.trim().isEmpty) missing.add('mobile');
      if (_houseStreetVillageController.text.trim().isEmpty) missing.add('houseStreetVillage');
      if (_stateNameController.text.trim().isEmpty) missing.add('stateName');
      if (_pinController.text.trim().isEmpty) missing.add('pin');
    } else if (id == 's2') {
      if (!_aadhaarOtpVerified) {
        missing.add('aadhaarConsent');
      }
    } else if (id == 's3') {
      if (_businessType.isEmpty) missing.add('businessType');
    } else if (id == 's5') {
      if (_accountHolderNameController.text.trim().isEmpty) missing.add('accountHolderName');
      if (_accountNumberController.text.trim().isEmpty) missing.add('accountNumber');
      if (_ifscController.text.trim().isEmpty) missing.add('ifsc');
    } else if (id == 's6') {
      if (_services.isEmpty) missing.add('services');
      if (_wardAreaController.text.trim().isEmpty) missing.add('wardArea');
    } else if (id == 's8') {
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
    } else if (id == 's9') {
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
        _cpToast('Please select Yes or No for Udyami Bharat / FCMCSL membership.', 'error');
        return;
      }
      if (_udyamiMember == 'No') {
        setState(() => _errors.add('udyamiMember'));
        _cpToast('Udyami Bharat / FCMCSL membership is required to continue.', 'error');
        return;
      }
    }

    if (_currentStepId == 's2' && !_aadhaarOtpVerified) {
      _validateStep('s2');
      _cpToast('Please verify the Aadhaar OTP before continuing.', 'error');
      return;
    }

    if (!_validateStep(_currentStepId)) {
      _cpToast('Please complete the highlighted fields before continuing.', 'error');
      return;
    }

    final seq = _buildSequence();
    final idx = seq.indexOf(_currentStepId);
    if (idx >= 0 && idx < seq.length - 1) {
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

  void _submitApplication() {
    if (_validateStep('s9')) {
      setState(() {
        _appStage = 'status';
        _statusStage = 'submitted';
        _errors.clear();
      });
      _scrollToTop();
    } else {
      _cpToast('Please accept the deposit terms to submit your application.', 'error');
    }
  }

  void _openSignatureDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SignatureModal(
        applicantName: _fullNameController.text.isNotEmpty ? _fullNameController.text : 'Signed',
        onSaved: () {
          setState(() {
            _signed = true;
            _signedAt = DateTime.now();
            _errors.remove('signed');
          });
          _cpToast('Signature saved', 'success');
        },
      ),
    );
  }

  // ==================== WIDGET BUILDERS ====================
  Widget _buildTopBar() {
    return Container(
      color: seal,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'BUILD AI HOMES',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 0.03 * 16,
                  color: Color(0xFFFBF8EE),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Channel Partner Registration',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFFCFE3DA),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFEAF3ED),
              side: const BorderSide(color: Color(0x59FFFFFF)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: _resetApp,
            child: const Text('↺ Restart', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBarAndHeading(String stepId) {
    int num = 1;
    if (stepId.startsWith('s')) {
      num = int.tryParse(stepId.substring(1)) ?? 1;
    }
    final pct = (num * 100 / 9).round().clamp(0, 100);

    final titles = {
      's1': {'title': 'About You', 'subtitle': 'As it appears on your Aadhaar / PAN card'},
      's2': {'title': 'Verify Your Aadhaar', 'subtitle': 'One secure government check'},
      's3': {'title': 'Business & Experience', 'subtitle': 'Your business & savings/investment experience'},
      's4': {'title': "Where You'll Work From", 'subtitle': "We'll visit before approving"},
      's5': {'title': 'Your Bank Details', 'subtitle': 'For commission payments & FD refund'},
      's6': {'title': "What You'd Like to Do", 'subtitle': 'Pick one module, or several'},
      's7': {'title': 'Availability & Comfort', 'subtitle': 'With the Partner app'},
      's8': {'title': 'Consent', 'subtitle': 'Your promises, and your signature'},
      's9': {'title': 'Review Application', 'subtitle': 'Check everything before you submit'},
    };

    final meta = titles[stepId] ?? {'title': '', 'subtitle': ''};

    return Container(
      color: paper,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                    height: 5,
                    color: line,
                    alignment: Alignment.centerLeft,
                    child: AnimatedFractionallySizedBox(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.ease,
                      widthFactor: pct / 100.0,
                      child: Container(color: seal),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'STEP $num/9',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: sealDark,
                        letterSpacing: 0.03 * 11,
                      ),
                    ),
                    Text(
                      '$pct%',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: muted,
                        letterSpacing: 0.03 * 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: line, width: 1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meta['title']!,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 22,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                    color: ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meta['subtitle']!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: muted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldWrap({
    required String label,
    String? help,
    bool required = false,
    required Widget child,
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
                letterSpacing: 0.02 * 11.5,
                color: inkSoft,
              ),
              children: [
                if (required)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: stamp, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          if (help != null) ...[
            const SizedBox(height: 2),
            Text(help, style: const TextStyle(fontSize: 11.5, color: muted, fontStyle: FontStyle.italic)),
          ],
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }

  Widget _buildUnderlineInput({
    required TextEditingController controller,
    String? placeholder,
    TextInputType keyboardType = TextInputType.text,
    bool hasError = false,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14.5, color: ink),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        hintText: placeholder,
        hintStyle: const TextStyle(color: Color(0xFFB3A98F), fontSize: 14.5),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: hasError ? stamp : line, width: 1.5),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: seal, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildTextareaInput({
    required TextEditingController controller,
    String? placeholder,
    int rows = 3,
    bool hasError = false,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: rows,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14.5, color: ink),
      decoration: InputDecoration(
        filled: true,
        fillColor: paperAlt,
        contentPadding: const EdgeInsets.all(12),
        hintText: placeholder,
        hintStyle: const TextStyle(color: Color(0xFFB3A98F), fontSize: 14.5),
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
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    String placeholder = 'Select…',
    bool hasError = false,
  }) {
    return DropdownButtonFormField<String>(
      value: (value != null && options.contains(value)) ? value : null,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: hasError ? stamp : line, width: 1.5),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: seal, width: 1.5),
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down, color: muted, size: 18),
      hint: Text(placeholder, style: const TextStyle(color: muted, fontSize: 14.5)),
      dropdownColor: paperAlt,
      items: options.map((opt) {
        return DropdownMenuItem<String>(
          value: opt,
          child: Text(opt, style: const TextStyle(fontSize: 14.5, color: ink)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildRadioOption({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: active ? sealTint : paperAlt,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? seal : line,
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
                label,
                style: const TextStyle(fontSize: 13.5, color: ink),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxSingle({
    required String label,
    required bool checked,
    required ValueChanged<bool> onChanged,
    bool hasError = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => onChanged(!checked),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                width: 16,
                height: 16,
                margin: const EdgeInsets.only(top: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: checked ? seal : Colors.transparent,
                  border: Border.all(
                    color: checked ? seal : (hasError ? stamp : line),
                    width: 2,
                  ),
                ),
                child: checked
                    ? const Center(
                        child: Icon(Icons.check, color: white, size: 11),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 13, color: ink, height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxGroup({
    required List<String> options,
    required Set<String> selected,
    required ValueChanged<Set<String>> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: paperAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: line, width: 1),
      ),
      child: Column(
        children: options.map((opt) {
          final isChecked = selected.contains(opt);
          return InkWell(
            onTap: () {
              final copy = Set<String>.from(selected);
              if (isChecked) {
                copy.remove(opt);
              } else {
                copy.add(opt);
              }
              onChanged(copy);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.only(top: 1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: isChecked ? seal : Colors.transparent,
                      border: Border.all(
                        color: isChecked ? seal : line,
                        width: 2,
                      ),
                    ),
                    child: isChecked
                        ? const Center(
                            child: Icon(Icons.check, color: white, size: 11),
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      opt,
                      style: const TextStyle(fontSize: 13, color: ink, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNote(String text, {bool goldBorder = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: goldBorder ? goldTint : paperAlt,
        borderRadius: BorderRadius.circular(2),
        border: Border(left: BorderSide(color: gold, width: 3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.5,
          color: goldBorder ? const Color(0xFF5B4415) : muted,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 22, bottom: 10),
      padding: const EdgeInsets.only(bottom: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: line, width: 1)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'serif',
          fontWeight: FontWeight.w600,
          fontSize: 14.5,
          color: sealDark,
        ),
      ),
    );
  }

  Widget _buildPanel({required String head, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF6E9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: gold, width: 1.5, style: BorderStyle.solid),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            head,
            style: const TextStyle(
              fontFamily: 'serif',
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
              color: gold,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildFooter(String stepId) {
    final seq = _buildSequence();
    final idx = seq.indexOf(stepId);
    final backDisabled = idx <= 0;
    final isLast = stepId == 's9';

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      decoration: const BoxDecoration(
        color: paperAlt,
        border: Border(top: BorderSide(color: line, width: 1)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: line, width: 1.5),
                foregroundColor: inkSoft,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: backDisabled ? null : _goBack,
              child: const Text('Back', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: seal,
                foregroundColor: white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: isLast ? _submitApplication : _goNext,
              child: Text(
                isLast ? 'Submit Application' : 'Continue',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== STEP 1: ABOUT YOU ====================
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Prototype Demo Box
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: goldTint,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: gold, width: 1, style: BorderStyle.solid),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Prototype Demo',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: Color(0xFF5B4415)),
              ),
              const SizedBox(height: 2),
              const Text(
                'Use realistic sample data to test the complete journey.',
                style: TextStyle(fontSize: 11.5, color: Color(0xFF5B4415)),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF8E7),
                  foregroundColor: const Color(0xFF5B4415),
                  elevation: 0,
                  side: const BorderSide(color: gold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  textStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                ),
                onPressed: _loadDemoData,
                child: const Text('Load Demo Applicant'),
              ),
            ],
          ),
        ),

        _buildNote(
          "You must already be a Udyami Bharat / FCMCSL member to apply. If you're not yet a member, register through One Core first — the details below should match your One Core profile.",
        ),

        // Udyami Member
        _buildFieldWrap(
          label: 'Are you already a Udyami Bharat / FCMCSL member?',
          required: true,
          child: Column(
            children: [
              _buildRadioOption(
                label: 'Yes',
                active: _udyamiMember == 'Yes',
                onTap: () {
                  setState(() {
                    _udyamiMember = 'Yes';
                    _errors.remove('udyamiMember');
                    if (_memberIdController.text.isEmpty) {
                      _memberIdController.text = '123123';
                    }
                  });
                },
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                label: 'No',
                active: _udyamiMember == 'No',
                onTap: () {
                  setState(() {
                    _udyamiMember = 'No';
                    _errors.add('udyamiMember');
                  });
                },
              ),
            ],
          ),
        ),

        if (_udyamiMember == 'No')
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: stampTint,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: stamp),
            ),
            child: const Text(
              'Membership required.\nYou must already be a Udyami Bharat / FCMCSL member to apply. Please register through One Core first.',
              style: TextStyle(color: stamp, fontSize: 12.5, fontWeight: FontWeight.w500, height: 1.4),
            ),
          ),

        if (_udyamiMember == 'Yes')
          _buildFieldWrap(
            label: 'Member ID',
            required: true,
            child: _buildUnderlineInput(
              controller: _memberIdController,
              placeholder: 'Enter your Member ID',
              hasError: _errors.contains('memberId'),
              onChanged: (_) => setState(() => _errors.remove('memberId')),
            ),
          ),

        _buildFieldWrap(
          label: 'Full Name',
          help: 'As on Aadhaar / PAN — for individual applicant or authorized representative',
          required: true,
          child: _buildUnderlineInput(
            controller: _fullNameController,
            hasError: _errors.contains('fullName'),
            onChanged: (_) => setState(() => _errors.remove('fullName')),
          ),
        ),

        Row(
          children: [
            Expanded(
              child: _buildFieldWrap(
                label: 'Date of Birth',
                child: _buildUnderlineInput(
                  controller: _dobController,
                  placeholder: 'YYYY-MM-DD',
                  keyboardType: TextInputType.datetime,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildFieldWrap(
                label: 'Gender',
                child: _buildDropdown(
                  value: _gender,
                  options: ['Male', 'Female', 'Other'],
                  onChanged: (v) => setState(() => _gender = v),
                ),
              ),
            ),
          ],
        ),

        _buildFieldWrap(
          label: "Father's / Husband's Name",
          child: _buildUnderlineInput(controller: _fatherHusbandNameController),
        ),

        Row(
          children: [
            Expanded(
              child: _buildFieldWrap(
                label: 'Marital Status',
                child: _buildDropdown(
                  value: _maritalStatus,
                  options: ['Single', 'Married', 'Other'],
                  onChanged: (v) => setState(() => _maritalStatus = v),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildFieldWrap(
                label: 'Blood Group',
                child: _buildUnderlineInput(
                  controller: _bloodGroupController,
                  placeholder: 'e.g. B+',
                ),
              ),
            ),
          ],
        ),

        Row(
          children: [
            Expanded(
              child: _buildFieldWrap(
                label: 'Nationality',
                child: _buildUnderlineInput(
                  controller: _nationalityController,
                  placeholder: 'Indian',
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildFieldWrap(
                label: 'Languages Spoken',
                child: _buildUnderlineInput(
                  controller: _languagesController,
                  placeholder: 'Kannada, English',
                ),
              ),
            ),
          ],
        ),

        _buildFieldWrap(
          label: 'Mobile Number',
          help: "We'll send an OTP here",
          required: true,
          child: _buildUnderlineInput(
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            hasError: _errors.contains('mobile'),
            onChanged: (_) => setState(() => _errors.remove('mobile')),
          ),
        ),

        Row(
          children: [
            Expanded(
              child: _buildFieldWrap(
                label: 'Alternate Mobile (optional)',
                child: _buildUnderlineInput(
                  controller: _altMobileController,
                  keyboardType: TextInputType.phone,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildFieldWrap(
                label: 'Email ID',
                child: _buildUnderlineInput(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ),
          ],
        ),

        _buildFieldWrap(
          label: 'Occupation',
          child: _buildUnderlineInput(
            controller: _occupationController,
            placeholder: 'e.g. Site supervisor, Interior contractor, Land aggregator, Civil engineer',
          ),
        ),

        _buildSectionLabel('Your Address'),

        _buildFieldWrap(
          label: 'House No. / Street / Village-Town',
          required: true,
          child: _buildUnderlineInput(
            controller: _houseStreetVillageController,
            hasError: _errors.contains('houseStreetVillage'),
            onChanged: (_) => setState(() => _errors.remove('houseStreetVillage')),
          ),
        ),

        Row(
          children: [
            Expanded(
              child: _buildFieldWrap(
                label: 'Taluk',
                child: _buildUnderlineInput(controller: _talukController),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildFieldWrap(
                label: 'District',
                child: _buildUnderlineInput(controller: _districtController),
              ),
            ),
          ],
        ),

        Row(
          children: [
            Expanded(
              child: _buildFieldWrap(
                label: 'State',
                required: true,
                child: _buildUnderlineInput(
                  controller: _stateNameController,
                  hasError: _errors.contains('stateName'),
                  onChanged: (_) => setState(() => _errors.remove('stateName')),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildFieldWrap(
                label: 'PIN Code',
                required: true,
                child: _buildUnderlineInput(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  hasError: _errors.contains('pin'),
                  onChanged: (_) => setState(() => _errors.remove('pin')),
                ),
              ),
            ),
          ],
        ),

        _buildFieldWrap(
          label: 'Ward / Hobli / Zone',
          child: _buildUnderlineInput(controller: _wardController),
        ),

        Row(
          children: [
            Expanded(
              child: _buildFieldWrap(
                label: 'Years Lived Here',
                child: _buildUnderlineInput(
                  controller: _yearsLivedHereController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildFieldWrap(
                label: 'Home Type',
                child: _buildDropdown(
                  value: _homeType,
                  options: ['Own', 'Rented', 'Family'],
                  onChanged: (v) => setState(() => _homeType = v),
                ),
              ),
            ),
          ],
        ),

        _buildFieldWrap(
          label: 'Nearest Landmark',
          child: _buildUnderlineInput(controller: _landmarkController),
        ),
      ],
    );
  }

  // ==================== STEP 2: VERIFY YOUR AADHAAR ====================
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNote(
          "We'll confirm your identity via a one-time Aadhaar OTP check, through a secure, government-approved partner. Build AI Homes never stores your Aadhaar number.",
        ),

        _buildFieldWrap(
          label: 'Aadhaar Number',
          child: _buildUnderlineInput(
            controller: _aadhaarNumberController,
            placeholder: 'XXXX XXXX XXXX',
            keyboardType: TextInputType.number,
          ),
        ),

        _buildFieldWrap(
          label: 'Mobile Linked to Aadhaar',
          child: _buildUnderlineInput(
            controller: _aadhaarMobileController,
            keyboardType: TextInputType.phone,
          ),
        ),

        _buildFieldWrap(
          label: 'Name on Aadhaar',
          child: _buildUnderlineInput(controller: _aadhaarNameController),
        ),

        // Verification Block
        if (_aadhaarOtpVerified) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: sealTint,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: seal, width: 1.5),
            ),
            child: const Row(
              children: [
                Icon(Icons.check, color: sealDark, size: 18),
                SizedBox(width: 8),
                Text(
                  'Aadhaar verified successfully',
                  style: TextStyle(color: sealDark, fontWeight: FontWeight.w600, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ] else ...[
          _buildCheckboxSingle(
            label: 'Yes, please verify my Aadhaar using OTP, through a secure government-approved partner.',
            checked: _aadhaarOtpSent,
            hasError: _errors.contains('aadhaarConsent'),
            onChanged: (v) {
              setState(() {
                _aadhaarConsent = v;
                _aadhaarOtpSent = v;
                _aadhaarOtpVerified = false;
                for (var c in _otpControllers) {
                  c.clear();
                }
              });
              if (v) {
                _cpToast('Demo OTP sent: 1234', 'info');
              }
            },
          ),

          if (_aadhaarOtpSent) ...[
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: paperAlt,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: line, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter OTP *', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: inkSoft)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ...List.generate(4, (i) {
                        return Container(
                          width: 46,
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
                              fontWeight: FontWeight.w700,
                              color: ink,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: white,
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: line, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: seal, width: 1.5),
                              ),
                            ),
                            onChanged: (val) {
                              if (val.isNotEmpty && i < 3) {
                                _otpFocusNodes[i + 1].requestFocus();
                              } else if (val.isEmpty && i > 0) {
                                _otpFocusNodes[i - 1].requestFocus();
                              }

                              final currentOtp = _otpControllers.map((c) => c.text).join();
                              if (currentOtp.length == 4) {
                                if (currentOtp == '1234') {
                                  setState(() {
                                    _aadhaarOtpVerified = true;
                                    _aadhaarConsent = true;
                                    _aadhaarOtpSent = false;
                                    _errors.remove('aadhaarConsent');
                                  });
                                  _cpToast('Aadhaar verified successfully.', 'success');
                                } else {
                                  _cpToast('Incorrect OTP. Please enter the correct 4-digit OTP.', 'error');
                                }
                              }
                            },
                          ),
                        );
                      }),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: seal,
                          foregroundColor: white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                        ),
                        onPressed: () {
                          final entered = _otpControllers.map((c) => c.text).join();
                          if (entered == '1234') {
                            setState(() {
                              _aadhaarOtpVerified = true;
                              _aadhaarConsent = true;
                              _aadhaarOtpSent = false;
                              _errors.remove('aadhaarConsent');
                            });
                            _cpToast('Aadhaar verified successfully.', 'success');
                          } else {
                            setState(() => _errors.add('aadhaarConsent'));
                            _cpToast('Incorrect OTP. Use 1234 for the demo.', 'error');
                          }
                        },
                        child: const Text('Verify', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  const Text('Demo OTP: 1234', style: TextStyle(fontSize: 10.5, color: muted, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }

  // ==================== STEP 3: BUSINESS & EXPERIENCE ====================
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Your Business'),
        _buildFieldWrap(
          label: 'Business Type',
          required: true,
          child: Column(
            children: [
              _buildRadioOption(
                label: 'I run a registered business',
                active: _businessType == 'institutional',
                onTap: () => setState(() => _businessType = 'institutional'),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                label: 'Applying as an individual',
                active: _businessType == 'individual',
                onTap: () => setState(() => _businessType = 'individual'),
              ),
            ],
          ),
        ),

        if (_businessType == 'institutional') ...[
          _buildFieldWrap(
            label: 'Business Name',
            child: _buildUnderlineInput(controller: _businessNameController),
          ),
          Row(
            children: [
              Expanded(
                child: _buildFieldWrap(
                  label: 'Type of Business',
                  child: _buildDropdown(
                    value: _typeOfBusiness,
                    options: ['Proprietorship', 'Partnership', 'LLP', 'Pvt Ltd'],
                    onChanged: (v) => setState(() => _typeOfBusiness = v),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildFieldWrap(
                  label: 'Started On',
                  child: _buildUnderlineInput(
                    controller: _startedOnController,
                    placeholder: 'YYYY-MM-DD',
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildFieldWrap(
                  label: 'Business PAN (if diff.)',
                  child: _buildUnderlineInput(controller: _businessPanController),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildFieldWrap(
                  label: 'TAN (optional)',
                  child: _buildUnderlineInput(controller: _tanController),
                ),
              ),
            ],
          ),
          _buildFieldWrap(
            label: 'GST Number (if registered)',
            child: _buildUnderlineInput(controller: _gstNumberController),
          ),
          _buildFieldWrap(
            label: 'Udyam / MSME Number',
            child: _buildUnderlineInput(controller: _udyamNumberController),
          ),
          _buildFieldWrap(
            label: 'Trade Licence Number & Issued By',
            child: _buildUnderlineInput(controller: _tradeLicenceController),
          ),
        ],

        _buildSectionLabel('Savings, Investment & Client Advisory Experience'),
        _buildCheckboxSingle(
          label: 'Yes, I have relevant experience',
          checked: _hasExperience,
          onChanged: (v) => setState(() => _hasExperience = v),
        ),

        if (_hasExperience) ...[
          _buildFieldWrap(
            label: 'Where You Worked',
            child: _buildUnderlineInput(controller: _whereWorkedController),
          ),
          Row(
            children: [
              Expanded(
                child: _buildFieldWrap(
                  label: 'Your Role',
                  child: _buildUnderlineInput(controller: _roleController),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildFieldWrap(
                  label: 'How Long (From–To)',
                  child: _buildUnderlineInput(controller: _howLongController),
                ),
              ),
            ],
          ),
          _buildFieldWrap(
            label: 'What You Did',
            child: _buildTextareaInput(controller: _whatYouDidController),
          ),
          Row(
            children: [
              Expanded(
                child: _buildFieldWrap(
                  label: 'Years of Experience',
                  child: _buildUnderlineInput(
                    controller: _yearsExperienceController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildFieldWrap(
                  label: 'Highest Qualification',
                  child: _buildUnderlineInput(controller: _highestQualificationController),
                ),
              ),
            ],
          ),
          _buildFieldWrap(
            label: 'Tools You Know (e.g. UPI Autopay, mutual fund portals)',
            child: _buildUnderlineInput(controller: _toolsKnownController),
          ),
        ],

        _buildFieldWrap(
          label: 'Familiarity',
          child: _buildCheckboxGroup(
            options: const [
              'I know my way around KYC / AML basics',
              "I'm familiar with SIP / mutual-fund style savings plans",
              "I've explained investment products to clients before",
            ],
            selected: _familiarityChecklist,
            onChanged: (s) => setState(() {
              _familiarityChecklist.clear();
              _familiarityChecklist.addAll(s);
            }),
          ),
        ),

        _buildSectionLabel('Any Other Work Experience'),
        _buildFieldWrap(
          label: 'Field / Sector',
          child: _buildUnderlineInput(controller: _fieldSectorController),
        ),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrap(
                label: 'Business or Employer',
                child: _buildUnderlineInput(controller: _businessOrEmployerController),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildFieldWrap(
                label: 'How Long (From–To)',
                child: _buildUnderlineInput(controller: _otherHowLongController),
              ),
            ),
          ],
        ),
        _buildFieldWrap(
          label: 'What You Did',
          child: _buildTextareaInput(controller: _otherWhatYouDidController),
        ),
      ],
    );
  }

  // ==================== STEP 4: WHERE YOU'LL WORK FROM ====================
  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNote("We'll visit before approving — client trust and document safety matter."),
        _buildFieldWrap(
          label: 'Work Address',
          child: _buildUnderlineInput(controller: _workAddressController),
        ),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrap(
                label: 'Ownership',
                child: _buildDropdown(
                  value: _ownership,
                  options: ['Owned', 'Rented', 'Leased'],
                  onChanged: (v) => setState(() => _ownership = v),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildFieldWrap(
                label: 'Nearest Landmark',
                child: _buildUnderlineInput(controller: _workLandmarkController),
              ),
            ),
          ],
        ),
        _buildFieldWrap(
          label: "Ward / Area You'll Serve",
          child: _buildUnderlineInput(controller: _wardAreaServeController),
        ),
        _buildFieldWrap(
          label: 'Villages / Localities Covered',
          child: _buildUnderlineInput(controller: _villagesCoveredController),
        ),
        _buildFieldWrap(
          label: 'Facilities at Work Location',
          child: _buildCheckboxGroup(
            options: const [
              'Private area for clients to discuss their investments',
              'Secure, lockable place to store paperwork',
              'CCTV or other document security',
              'Internet access to log leads and savers',
              'Computer, scanner and printer on site',
              'Familiar with One Core KYC / onboarding process',
            ],
            selected: _workFacilities,
            onChanged: (s) => setState(() {
              _workFacilities.clear();
              _workFacilities.addAll(s);
            }),
          ),
        ),
      ],
    );
  }

  // ==================== STEP 5: YOUR BANK DETAILS ====================
  Widget _buildStep5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldWrap(
          label: 'Account Holder Name',
          required: true,
          child: _buildUnderlineInput(
            controller: _accountHolderNameController,
            hasError: _errors.contains('accountHolderName'),
            onChanged: (_) => setState(() => _errors.remove('accountHolderName')),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrap(
                label: 'Account Type',
                child: _buildDropdown(
                  value: _accountType,
                  options: ['Savings', 'Current'],
                  onChanged: (v) => setState(() => _accountType = v ?? 'Savings'),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildFieldWrap(
                label: 'Account Number',
                required: true,
                child: _buildUnderlineInput(
                  controller: _accountNumberController,
                  hasError: _errors.contains('accountNumber'),
                  onChanged: (_) => setState(() => _errors.remove('accountNumber')),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrap(
                label: 'IFSC Code',
                required: true,
                child: _buildUnderlineInput(
                  controller: _ifscController,
                  hasError: _errors.contains('ifsc'),
                  onChanged: (_) => setState(() => _errors.remove('ifsc')),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildFieldWrap(
                label: 'Bank & Branch Name',
                child: _buildUnderlineInput(controller: _bankBranchController),
              ),
            ),
          ],
        ),

        // Nominee Panel
        _buildPanel(
          head: '🛡 Alternate / Nominee Details',
          children: [
            _buildNote(
              "In the event of death or an unforeseen circumstance, any pending funds will be released to this nominee's account instead.",
            ),
            _buildFieldWrap(
              label: 'Nominee Name',
              child: _buildUnderlineInput(controller: _nomineeNameController),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildFieldWrap(
                    label: 'Relationship to You',
                    child: _buildUnderlineInput(
                      controller: _relationshipController,
                      placeholder: 'e.g. Spouse, Son',
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildFieldWrap(
                    label: 'Nominee Mobile',
                    child: _buildUnderlineInput(
                      controller: _nomineeMobileController,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ),
              ],
            ),
            _buildFieldWrap(
              label: 'Nominee Account Number',
              child: _buildUnderlineInput(controller: _nomineeAccountNumberController),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildFieldWrap(
                    label: 'IFSC Code',
                    child: _buildUnderlineInput(controller: _nomineeIfscController),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildFieldWrap(
                    label: 'Bank & Branch Name',
                    child: _buildUnderlineInput(controller: _nomineeBankBranchController),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ==================== STEP 6: WHAT YOU'D LIKE TO DO ====================
  Widget _buildStep6() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNote(
          'Choose one, or several — commission and deposit terms are the same across all five modules: 4% commission, ₹5,00,000 security deposit per module.',
        ),
        _buildFieldWrap(
          label: 'Modules',
          required: true,
          child: Column(
            children: BuildAiHomesServiceCards.all.map((card) {
              final active = _services.contains(card.id);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => _toggleService(card.id),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: active ? sealTint : paperAlt,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: active ? seal : (_errors.contains('services') ? stamp : line),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(card.icon, style: const TextStyle(fontSize: 20)),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: active ? seal : Colors.transparent,
                                border: Border.all(color: active ? seal : line, width: 1.5),
                              ),
                              child: active
                                  ? const Center(
                                      child: Icon(Icons.check, color: white, size: 12),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          card.name,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontWeight: FontWeight.w700,
                            fontSize: 15.5,
                            color: ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          card.desc,
                          style: const TextStyle(fontSize: 12, color: muted, height: 1.5),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: goldTint,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '4% COMMISSION',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: gold,
                              letterSpacing: 0.02 * 10.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        _buildNote(
          'Pick one module, or several. After Continue, the relevant 20-question verification for each module opens, based on your Business Type from Step 3.',
        ),

        _buildFieldWrap(
          label: "Ward / Area You'd Like to Serve",
          required: true,
          child: _buildUnderlineInput(
            controller: _wardAreaController,
            hasError: _errors.contains('wardArea'),
            onChanged: (_) => setState(() => _errors.remove('wardArea')),
          ),
        ),

        _buildNote(
          "If your ward is full, you'll be waitlisted or offered a nearby open ward. You'll answer 20 verification questions for each module you select, based on whether you're applying as an individual or a registered business.",
        ),
      ],
    );
  }

  // ==================== QUESTIONNAIRE STEP ====================
  Widget _buildQuestionnaireScreen(String qid) {
    final data = BuildAiHomesQuestionnaires.all[qid];
    if (data == null) return const SizedBox();

    final catIdx = _qCat[qid] ?? 0;
    final cat = data.categories[catIdx];
    final isLastSection = catIdx >= data.categories.length - 1;

    return Column(
      children: [
        _buildTopBar(),
        Container(
          padding: const EdgeInsets.all(18),
          color: goldTint,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'VERIFICATION QUESTIONNAIRE · INSERTED AFTER STEP 6',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  letterSpacing: 0.08 * 10,
                  color: gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                data.title,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ink,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.subtitle,
                style: const TextStyle(fontSize: 12, color: muted, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(data.categories.length, (i) {
                  final active = i == catIdx;
                  final done = i < catIdx;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 6),
                    width: active ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(active ? 5 : 4),
                      color: active ? seal : (done ? gold : line),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                'Section ${catIdx + 1} of ${data.categories.length} · ${cat.name}',
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: sealDark),
              ),
            ],
          ),
        ),

        Expanded(
          child: Container(
            color: paper,
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(18),
              children: cat.questions.asMap().entries.map((entry) {
                final i = entry.key;
                final q = entry.value;
                final n = cat.startNum + i;
                final ans = _qa[n] ?? '';

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$n. $q',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: ink,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: TextEditingController(text: ans)
                          ..selection = TextSelection.collapsed(offset: ans.length),
                        maxLines: 2,
                        style: const TextStyle(fontSize: 14.5, color: ink),
                        onChanged: (val) {
                          _qa[n] = val;
                        },
                        decoration: InputDecoration(
                          hintText: 'Type your answer…',
                          hintStyle: const TextStyle(color: Color(0xFFB3A98F), fontSize: 13),
                          filled: true,
                          fillColor: paperAlt,
                          contentPadding: const EdgeInsets.all(10),
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
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Questionnaire Footer
        Container(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          decoration: const BoxDecoration(
            color: paperAlt,
            border: Border(top: BorderSide(color: line, width: 1)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 92,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: line, width: 1.5),
                    foregroundColor: inkSoft,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    if (catIdx > 0) {
                      setState(() => _qCat[qid] = catIdx - 1);
                      _scrollToTop();
                    } else {
                      final seq = _buildSequence();
                      final idx = seq.indexOf(qid);
                      if (idx > 0) {
                        setState(() {
                          _currentStepId = seq[idx - 1];
                        });
                        _scrollToTop();
                      }
                    }
                  },
                  child: const Text('Back', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: seal,
                    foregroundColor: white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    if (catIdx < data.categories.length - 1) {
                      setState(() => _qCat[qid] = catIdx + 1);
                      _scrollToTop();
                    } else {
                      final seq = _buildSequence();
                      final idx = seq.indexOf(qid);
                      if (idx >= 0 && idx < seq.length - 1) {
                        setState(() {
                          _currentStepId = seq[idx + 1];
                        });
                        _scrollToTop();
                      }
                    }
                  },
                  child: Text(
                    isLastSection ? 'Continue' : 'Next Section',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== STEP 7: AVAILABILITY & COMFORT ====================
  Widget _buildStep7() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldWrap(
          label: 'New Savers / Investors You Expect to Onboard Per Month',
          child: _buildUnderlineInput(
            controller: _newSaversPerMonthController,
            keyboardType: TextInputType.number,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrap(
                label: 'Hire Support Staff?',
                child: _buildDropdown(
                  value: _hireSupportStaff,
                  options: ['Yes', 'No'],
                  onChanged: (v) => setState(() => _hireSupportStaff = v),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildFieldWrap(
                label: 'Best Time for Training',
                child: _buildDropdown(
                  value: _bestTimeTraining,
                  options: ['Weekdays', 'Weekends', 'Both', 'Flexible'],
                  onChanged: (v) => setState(() => _bestTimeTraining = v),
                ),
              ),
            ),
          ],
        ),

        _buildSectionLabel('Smartphone & App Experience'),
        _buildFieldWrap(
          label: 'Which Smartphone Do You Use?',
          child: Column(
            children: [
              _buildRadioOption(
                label: 'Android',
                active: _smartphone == 'Android',
                onTap: () => setState(() => _smartphone = 'Android'),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                label: 'iPhone (iOS)',
                active: _smartphone == 'iPhone (iOS)',
                onTap: () => setState(() => _smartphone = 'iPhone (iOS)'),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                label: 'Both',
                active: _smartphone == 'Both',
                onTap: () => setState(() => _smartphone = 'Both'),
              ),
            ],
          ),
        ),

        _buildFieldWrap(
          label: 'Comfort Using Smartphone Apps?',
          child: Column(
            children: [
              _buildRadioOption(
                label: 'Very Comfortable',
                active: _comfortApps == 'Very Comfortable',
                onTap: () => setState(() => _comfortApps = 'Very Comfortable'),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                label: 'Comfortable',
                active: _comfortApps == 'Comfortable',
                onTap: () => setState(() => _comfortApps = 'Comfortable'),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                label: 'Need Training',
                active: _comfortApps == 'Need Training',
                onTap: () => setState(() => _comfortApps = 'Need Training'),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                label: 'Not Comfortable',
                active: _comfortApps == 'Not Comfortable',
                onTap: () => setState(() => _comfortApps = 'Not Comfortable'),
              ),
            ],
          ),
        ),

        _buildFieldWrap(
          label: 'Used Apps for Investments / Online Forms?',
          child: Column(
            children: [
              _buildRadioOption(
                label: 'Yes, Regularly',
                active: _usedAppsForInvestments == 'Yes, Regularly',
                onTap: () => setState(() => _usedAppsForInvestments = 'Yes, Regularly'),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                label: 'Yes, Sometimes',
                active: _usedAppsForInvestments == 'Yes, Sometimes',
                onTap: () => setState(() => _usedAppsForInvestments = 'Yes, Sometimes'),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                label: 'No',
                active: _usedAppsForInvestments == 'No',
                onTap: () => setState(() => _usedAppsForInvestments = 'No'),
              ),
            ],
          ),
        ),

        _buildFieldWrap(
          label: 'Comfort With UPI Autopay, OTP & Digital Payments?',
          child: Column(
            children: [
              _buildRadioOption(
                label: 'Very Comfortable',
                active: _comfortPayments == 'Very Comfortable',
                onTap: () => setState(() => _comfortPayments = 'Very Comfortable'),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                label: 'Comfortable',
                active: _comfortPayments == 'Comfortable',
                onTap: () => setState(() => _comfortPayments = 'Comfortable'),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                label: 'Need Guidance',
                active: _comfortPayments == 'Need Guidance',
                onTap: () => setState(() => _comfortPayments = 'Need Guidance'),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                label: 'Need Full Training',
                active: _comfortPayments == 'Need Full Training',
                onTap: () => setState(() => _comfortPayments = 'Need Full Training'),
              ),
            ],
          ),
        ),

        _buildSectionLabel('Language & Client Communication'),
        _buildFieldWrap(
          label: 'Language & App Comfort',
          child: _buildCheckboxGroup(
            options: const [
              "I'm comfortable using the Partner app already",
              "I'll need a bit of training first",
              'I can talk to clients in Kannada',
              'I can talk to clients in English',
            ],
            selected: _langComm,
            onChanged: (s) => setState(() {
              _langComm.clear();
              _langComm.addAll(s);
            }),
          ),
        ),
      ],
    );
  }

  // ==================== STEP 8: CONSENT ====================
  Widget _buildStep8() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCheckboxSingle(
          label: 'I agree to the Aadhaar identity check described in Step 2.',
          checked: _c1,
          hasError: _errors.contains('c1'),
          onChanged: (v) => setState(() { _c1 = v; _errors.remove('c1'); }),
        ),
        _buildCheckboxSingle(
          label: 'I understand my account stays inactive until I finish training.',
          checked: _c2,
          hasError: _errors.contains('c2'),
          onChanged: (v) => setState(() { _c2 = v; _errors.remove('c2'); }),
        ),
        _buildCheckboxSingle(
          label: "I'll keep every client's personal and financial information safe, secure and private.",
          checked: _c3,
          hasError: _errors.contains('c3'),
          onChanged: (v) => setState(() { _c3 = v; _errors.remove('c3'); }),
        ),
        _buildCheckboxSingle(
          label: "I don't have any conflict of interest that would get in the way of this role.",
          checked: _c4,
          hasError: _errors.contains('c4'),
          onChanged: (v) => setState(() { _c4 = v; _errors.remove('c4'); }),
        ),
        _buildCheckboxSingle(
          label: 'I understand returns are projections, not guarantees, and I will never promise assured returns to a member.',
          checked: _c5,
          hasError: _errors.contains('c5'),
          onChanged: (v) => setState(() { _c5 = v; _errors.remove('c5'); }),
        ),
        _buildCheckboxSingle(
          label: 'I understand Build AI Homes holds no member money directly — all contributions post through One Core.',
          checked: _c6,
          hasError: _errors.contains('c6'),
          onChanged: (v) => setState(() { _c6 = v; _errors.remove('c6'); }),
        ),
        _buildCheckboxSingle(
          label: "I've read the Build AI Homes Code of Conduct and I'll follow it.",
          checked: _c7,
          hasError: _errors.contains('c7'),
          onChanged: (v) => setState(() { _c7 = v; _errors.remove('c7'); }),
        ),
        _buildCheckboxSingle(
          label: "Everything I've written in this form is true.",
          checked: _c8,
          hasError: _errors.contains('c8'),
          onChanged: (v) => setState(() { _c8 = v; _errors.remove('c8'); }),
        ),
        _buildCheckboxSingle(
          label: "I've read the plain-language summary and full agreement, and I agree to it.",
          checked: _c9,
          hasError: _errors.contains('c9'),
          onChanged: (v) => setState(() { _c9 = v; _errors.remove('c9'); }),
        ),

        Row(
          children: [
            Expanded(
              child: _buildFieldWrap(
                label: 'Place',
                required: true,
                child: _buildUnderlineInput(
                  controller: _placeController,
                  hasError: _errors.contains('place'),
                  onChanged: (_) => setState(() => _errors.remove('place')),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildFieldWrap(
                label: 'Date',
                required: true,
                child: _buildUnderlineInput(
                  controller: _date8Controller,
                  hasError: _errors.contains('date8'),
                  onChanged: (_) => setState(() => _errors.remove('date8')),
                ),
              ),
            ),
          ],
        ),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Signature', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: inkSoft)),
                  const SizedBox(height: 2),
                  const Text('Tap to Sign', style: TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic, color: muted)),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: _openSignatureDialog,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 64,
                      decoration: BoxDecoration(
                        color: _signed ? sealTint : paperAlt,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _errors.contains('signed') ? stamp : (_signed ? seal : line),
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: _signed
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _fullNameController.text.isNotEmpty ? _fullNameController.text : 'Signed',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    color: sealDark,
                                  ),
                                ),
                                Text(
                                  'Signed ${_formatDateDisplay(_signedAt ?? DateTime.now())}',
                                  style: const TextStyle(fontSize: 9.5, color: muted),
                                ),
                              ],
                            )
                          : const Text('✍️ Tap to sign', style: TextStyle(fontSize: 12, color: muted)),
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
                  const Text('Thumb Impression (optional)', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: inkSoft)),
                  const SizedBox(height: 2),
                  const Text(' ', style: TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic, color: muted)),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: () => setState(() => _thumbImpression = !_thumbImpression),
                    borderRadius: BorderRadius.circular(8),
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
                          fontWeight: _thumbImpression ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==================== STEP 9: REVIEW APPLICATION ====================
  Widget _buildStep9() {
    final dep = BuildAiHomesDepositCalculation.compute(_services);
    final total = dep['total'] as int;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNote("Here's what you've entered. Go back to any earlier step to make changes before submitting."),

        // Step 1 Review
        _buildReviewCard(
          title: 'About You',
          stepId: 's1',
          rows: [
            {'label': 'Member', 'val': _udyamiMember ?? 'No'},
            if (_memberIdController.text.isNotEmpty) {'label': 'Member ID', 'val': _memberIdController.text},
            {'label': 'Full Name', 'val': _fullNameController.text},
            if (_dobController.text.isNotEmpty) {'label': 'Date of Birth', 'val': _dobController.text},
            if (_gender != null) {'label': 'Gender', 'val': _gender!},
            if (_fatherHusbandNameController.text.isNotEmpty) {'label': "Father's / Husband's Name", 'val': _fatherHusbandNameController.text},
            if (_maritalStatus != null) {'label': 'Marital Status', 'val': _maritalStatus!},
            if (_bloodGroupController.text.isNotEmpty) {'label': 'Blood Group', 'val': _bloodGroupController.text},
            if (_nationalityController.text.isNotEmpty) {'label': 'Nationality', 'val': _nationalityController.text},
            if (_languagesController.text.isNotEmpty) {'label': 'Languages', 'val': _languagesController.text},
            {'label': 'Mobile', 'val': _mobileController.text},
            if (_altMobileController.text.isNotEmpty) {'label': 'Alt Mobile', 'val': _altMobileController.text},
            if (_emailController.text.isNotEmpty) {'label': 'Email ID', 'val': _emailController.text},
            if (_occupationController.text.isNotEmpty) {'label': 'Occupation', 'val': _occupationController.text},
            {'label': 'Address', 'val': _houseStreetVillageController.text},
            if (_talukController.text.isNotEmpty) {'label': 'Taluk', 'val': _talukController.text},
            if (_districtController.text.isNotEmpty) {'label': 'District', 'val': _districtController.text},
            {'label': 'State', 'val': _stateNameController.text},
            {'label': 'PIN Code', 'val': _pinController.text},
            if (_wardController.text.isNotEmpty) {'label': 'Ward', 'val': _wardController.text},
            if (_yearsLivedHereController.text.isNotEmpty) {'label': 'Years Lived', 'val': _yearsLivedHereController.text},
            if (_homeType != null) {'label': 'Home Type', 'val': _homeType!},
            if (_landmarkController.text.isNotEmpty) {'label': 'Landmark', 'val': _landmarkController.text},
          ],
        ),

        // Step 2 Review
        _buildReviewCard(
          title: 'Verify Your Aadhaar',
          stepId: 's2',
          rows: [
            if (_aadhaarNumberController.text.isNotEmpty) {'label': 'Aadhaar Number', 'val': _aadhaarNumberController.text},
            if (_aadhaarMobileController.text.isNotEmpty) {'label': 'Aadhaar Mobile', 'val': _aadhaarMobileController.text},
            if (_aadhaarNameController.text.isNotEmpty) {'label': 'Name on Aadhaar', 'val': _aadhaarNameController.text},
            {'label': 'Verification Status', 'val': _aadhaarOtpVerified ? 'Verified ✓' : 'Pending'},
          ],
        ),

        // Step 3 Review
        _buildReviewCard(
          title: 'Business & Experience',
          stepId: 's3',
          rows: [
            {'label': 'Business Type', 'val': _businessType == 'institutional' ? 'Registered Business' : 'Individual'},
            if (_businessType == 'institutional') ...[
              if (_businessNameController.text.isNotEmpty) {'label': 'Business Name', 'val': _businessNameController.text},
              if (_typeOfBusiness != null) {'label': 'Type', 'val': _typeOfBusiness!},
              if (_startedOnController.text.isNotEmpty) {'label': 'Started On', 'val': _startedOnController.text},
              if (_gstNumberController.text.isNotEmpty) {'label': 'GST Number', 'val': _gstNumberController.text},
              if (_udyamNumberController.text.isNotEmpty) {'label': 'Udyam / MSME', 'val': _udyamNumberController.text},
            ],
            {'label': 'Has Experience', 'val': _hasExperience ? 'Yes' : 'No'},
            if (_hasExperience) ...[
              if (_whereWorkedController.text.isNotEmpty) {'label': 'Where Worked', 'val': _whereWorkedController.text},
              if (_roleController.text.isNotEmpty) {'label': 'Role', 'val': _roleController.text},
              if (_howLongController.text.isNotEmpty) {'label': 'How Long', 'val': _howLongController.text},
              if (_yearsExperienceController.text.isNotEmpty) {'label': 'Years Exp.', 'val': _yearsExperienceController.text},
              if (_highestQualificationController.text.isNotEmpty) {'label': 'Qualification', 'val': _highestQualificationController.text},
            ],
            if (_familiarityChecklist.isNotEmpty) {'label': 'Familiarity', 'val': _familiarityChecklist.join(', ')},
          ],
        ),

        // Step 4 Review
        _buildReviewCard(
          title: "Where You'll Work From",
          stepId: 's4',
          rows: [
            if (_workAddressController.text.isNotEmpty) {'label': 'Work Address', 'val': _workAddressController.text},
            if (_ownership != null) {'label': 'Ownership', 'val': _ownership!},
            if (_wardAreaServeController.text.isNotEmpty) {'label': "Ward / Area You'll Serve", 'val': _wardAreaServeController.text},
            if (_workFacilities.isNotEmpty) {'label': 'Facilities', 'val': _workFacilities.join(', ')},
          ],
        ),

        // Step 5 Review
        _buildReviewCard(
          title: 'Your Bank Details',
          stepId: 's5',
          rows: [
            {'label': 'Account Holder Name', 'val': _accountHolderNameController.text},
            {'label': 'Account Type', 'val': _accountType},
            {'label': 'Account Number', 'val': _accountNumberController.text},
            {'label': 'IFSC Code', 'val': _ifscController.text},
            if (_bankBranchController.text.isNotEmpty) {'label': 'Bank & Branch', 'val': _bankBranchController.text},
            if (_nomineeNameController.text.isNotEmpty) ...[
              {'label': 'Nominee Name', 'val': _nomineeNameController.text},
              if (_relationshipController.text.isNotEmpty) {'label': 'Relationship', 'val': _relationshipController.text},
            ],
          ],
        ),

        // Step 6 Review
        _buildReviewCard(
          title: "What You'd Like to Do",
          stepId: 's6',
          rows: [
            {
              'label': 'Modules',
              'val': _services.map((id) {
                final card = BuildAiHomesServiceCards.all.firstWhere(
                  (c) => c.id == id,
                  orElse: () => BuildAiHomesServiceCard(id: id, icon: '', name: id, desc: ''),
                );
                return card.name;
              }).join(', '),
            },
            {'label': 'Ward / Area', 'val': _wardAreaController.text},
          ],
        ),

        // Questionnaires Review
        ..._services.map((svc) {
          final bt = _businessType == 'institutional' ? 'institutional' : 'individual';
          final qid = 'q_${svc}_$bt';
          final qdata = BuildAiHomesQuestionnaires.all[qid];
          if (qdata == null) return const SizedBox();

          final answeredList = <Map<String, String>>[];
          for (var cat in qdata.categories) {
            for (int i = 0; i < cat.questions.length; i++) {
              final n = cat.startNum + i;
              final ans = _qa[n];
              if (ans != null && ans.trim().isNotEmpty) {
                answeredList.add({
                  'q': '$n. ${cat.questions[i]}',
                  'a': ans.trim(),
                });
              }
            }
          }

          if (answeredList.isEmpty) return const SizedBox();

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: paperAlt,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: line, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: const Color(0xFFEDE6D2),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          qdata.title,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: sealDark,
                          ),
                        ),
                      ),
                      InkWell(
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
                            fontWeight: FontWeight.w600,
                            color: stamp,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ...answeredList.map((item) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: line, width: 1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['q']!,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ink),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['a']!,
                          style: const TextStyle(fontSize: 12, color: inkSoft, height: 1.4),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),

        // Step 7 Review
        _buildReviewCard(
          title: 'Availability & Comfort',
          stepId: 's7',
          rows: [
            if (_newSaversPerMonthController.text.isNotEmpty) {'label': 'Expected Clients/Mo', 'val': _newSaversPerMonthController.text},
            if (_hireSupportStaff != null) {'label': 'Hire Support Staff', 'val': _hireSupportStaff!},
            if (_bestTimeTraining != null) {'label': 'Best Training Time', 'val': _bestTimeTraining!},
            if (_smartphone != null) {'label': 'Smartphone', 'val': _smartphone!},
            if (_comfortApps != null) {'label': 'Apps Comfort', 'val': _comfortApps!},
            if (_usedAppsForInvestments != null) {'label': 'Used Apps for Forms', 'val': _usedAppsForInvestments!},
            if (_comfortPayments != null) {'label': 'Payments Comfort', 'val': _comfortPayments!},
            if (_langComm.isNotEmpty) {'label': 'Languages & App', 'val': _langComm.join(', ')},
          ],
        ),

        // Step 8 Review
        _buildReviewCard(
          title: 'Consent',
          stepId: 's8',
          rows: [
            {'label': 'Agreements Confirmed', 'val': 'All 9 promises checked'},
            {'label': 'Place', 'val': _placeController.text},
            {'label': 'Date', 'val': _date8Controller.text},
            {'label': 'Signature', 'val': _signed ? 'Signed' : 'Not signed'},
            if (_thumbImpression) {'label': 'Thumb Impression', 'val': 'Captured'},
          ],
        ),

        // Security Deposit Section
        _buildSectionLabel('Security Deposit (shown after Ward Head acceptance & onboarding meeting)'),
        _buildDepositTable(),

        // Acknowledgments
        _buildCheckboxSingle(
          label: "I'll only pay this after approval — within 7 days.",
          checked: _depositAck1,
          hasError: _errors.contains('depositAck1'),
          onChanged: (v) => setState(() { _depositAck1 = v; _errors.remove('depositAck1'); }),
        ),
        _buildCheckboxSingle(
          label: "I'll get this back within 30 days if I leave or resign — or I can leave it deposited.",
          checked: _depositAck2,
          hasError: _errors.contains('depositAck2'),
          onChanged: (v) => setState(() { _depositAck2 = v; _errors.remove('depositAck2'); }),
        ),

        _buildNote(
          "You'll receive a 4% commission on the facilitation fee value for the following 12 months, per module you're onboarded in. Every commission payment goes through One Core — never cash. Returns shown to members are projections, never guarantees.",
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String title,
    required String stepId,
    required List<Map<String, String>> rows,
  }) {
    final validRows = rows.where((r) => (r['val'] ?? '').trim().isNotEmpty).toList();
    if (validRows.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: paperAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: line, width: 1),
      ),
      child: Column(
        children: [
          Container(
            color: const Color(0xFFEDE6D2),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: sealDark,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() => _currentStepId = stepId);
                    _scrollToTop();
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: stamp,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...validRows.asMap().entries.map((entry) {
            final i = entry.key;
            final r = entry.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                border: i == 0 ? null : const Border(top: BorderSide(color: line, width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(r['label']!, style: const TextStyle(fontSize: 12, color: muted)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 5,
                    child: Text(
                      r['val']!,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: ink),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDepositTable() {
    final dep = BuildAiHomesDepositCalculation.compute(_services);
    final rows = dep['rows'] as List<dynamic>;
    final total = dep['total'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // General Terms Table
          Container(
            decoration: BoxDecoration(
              color: paperAlt,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: line, width: 1),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: ink, width: 1.5)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('MODULE', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: muted, letterSpacing: 0.03 * 10.5)),
                      Text('NOTE', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: muted, letterSpacing: 0.03 * 10.5)),
                    ],
                  ),
                ),
                _buildDepositRow('Any one module selected', 'Board confirmed'),
                _buildDepositRow('Each additional module', 'Cumulative, per module'),
                _buildDepositRow('All 5 modules', 'Board confirmed'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Selection Table
          if (rows.isNotEmpty) ...[
            Container(
              decoration: BoxDecoration(
                color: paperAlt,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: line, width: 1),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: ink, width: 1.5)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('YOUR SELECTION', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: muted)),
                        Text('AMOUNT', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: muted)),
                      ],
                    ),
                  ),
                  ...rows.map((r) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: line, width: 1)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(r['label'] as String, style: const TextStyle(fontSize: 12.5, color: ink)),
                          Text(
                            BuildAiHomesDepositCalculation.formatINR(r['amount'] as int),
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 12.5, fontWeight: FontWeight.w600, color: gold),
                          ),
                        ],
                      ),
                    );
                  }),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Security Deposit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ink)),
                        Text(
                          BuildAiHomesDepositCalculation.formatINR(total),
                          style: const TextStyle(fontFamily: 'monospace', fontSize: 14, fontWeight: FontWeight.bold, color: gold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            _buildNote('Select at least one module in Step 6 to see your deposit total here.'),
          ],
        ],
      ),
    );
  }

  Widget _buildDepositRow(String col1, String col2) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: line, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(col1, style: const TextStyle(fontSize: 12.5, color: ink)),
          Text(col2, style: const TextStyle(fontSize: 12, color: muted, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  // ==================== POST-SUBMISSION STATUS SCREENS ====================
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
      theme: CompanyStatusTheme.buildAiHomes(),
      initialStageIndex: _mapStatusToStageIndex(_statusStage),
      applicantName: _fullNameController.text.trim().isNotEmpty ? _fullNameController.text.trim() : 'Suresh Naik',
      applicationId: '#BAH-${DateTime.now().year}-1098',
      wardLocality: _wardAreaController.text.trim().isNotEmpty ? _wardAreaController.text.trim() : 'Registered Ward',
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

  Widget _buildDemoPill(String label, String stage) {
    if (_statusStage == stage) return const SizedBox();
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 11, color: inkSoft)),
      backgroundColor: paperAlt,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: line),
      ),
      onPressed: () {
        setState(() => _statusStage = stage);
        _scrollToTop();
      },
    );
  }

  Widget _buildMeetingRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: line, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12.5, color: muted)),
          Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: ink)),
        ],
      ),
    );
  }

  Widget _buildTimeline(List<String> steps, int activeIndex) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: steps.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          final isDone = i < activeIndex;
          final isCurrent = i == activeIndex;

          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 2,
                        color: i == 0 ? Colors.transparent : (isDone ? seal : line),
                      ),
                    ),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone ? seal : (isCurrent ? white : paperAlt),
                        border: Border.all(color: (isDone || isCurrent) ? seal : line, width: 2),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: i == steps.length - 1 ? Colors.transparent : (isDone ? seal : line),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  s,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: (isDone || isCurrent) ? FontWeight.w600 : FontWeight.normal,
                    color: (isDone || isCurrent) ? sealDark : muted,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==================== MAIN BUILD ====================
  @override
  Widget build(BuildContext context) {
    if (_appStage == 'status') {
      return _buildStatusScreen();
    }
    Widget content;
    if (_currentStepId.startsWith('q_')) {
      content = _buildQuestionnaireScreen(_currentStepId);
    } else {
      Widget stepFields;
      switch (_currentStepId) {
        case 's1': stepFields = _buildStep1(); break;
        case 's2': stepFields = _buildStep2(); break;
        case 's3': stepFields = _buildStep3(); break;
        case 's4': stepFields = _buildStep4(); break;
        case 's5': stepFields = _buildStep5(); break;
        case 's6': stepFields = _buildStep6(); break;
        case 's7': stepFields = _buildStep7(); break;
        case 's8': stepFields = _buildStep8(); break;
        case 's9': stepFields = _buildStep9(); break;
        default: stepFields = _buildStep1(); break;
      }

      content = Column(
        children: [
          _buildTopBar(),
          _buildProgressBarAndHeading(_currentStepId),
          Expanded(
            child: Container(
              color: paper,
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(18),
                children: [
                  if (_errors.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                      decoration: BoxDecoration(
                        color: stampTint,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: stamp),
                      ),
                      child: const Text(
                        'Please complete the highlighted fields before continuing.',
                        style: TextStyle(color: stamp, fontSize: 12.5, fontWeight: FontWeight.w500),
                      ),
                    ),
                  stepFields,
                ],
              ),
            ),
          ),
          _buildFooter(_currentStepId),
        ],
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFDAD3BE),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Container(
                  color: paper,
                  child: content,
                ),
              ),
            ),
            if (_toastMessage != null)
              Positioned(
                top: MediaQuery.of(context).size.height * 0.45,
                left: 20,
                right: 20,
                child: Center(
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(12),
                    color: _toastType == 'success'
                        ? seal
                        : (_toastType == 'error' ? stamp : ink),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      child: Text(
                        _toastMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ==================== SIGNATURE MODAL BOTTOM SHEET ====================
class _SignatureModal extends StatefulWidget {
  final String applicantName;
  final VoidCallback onSaved;

  const _SignatureModal({
    required this.applicantName,
    required this.onSaved,
  });

  @override
  State<_SignatureModal> createState() => _SignatureModalState();
}

class _SignatureModalState extends State<_SignatureModal> {
  final List<List<Offset>> _strokes = [];
  List<Offset>? _activeStroke;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _BuildAiHomesFormState.paperAlt,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      padding: EdgeInsets.fromLTRB(18, 18, 18, MediaQuery.of(context).viewInsets.bottom + 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add your signature',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: _BuildAiHomesFormState.ink,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Draw below or use the demo signature for user testing.',
            style: TextStyle(fontSize: 12, color: _BuildAiHomesFormState.muted),
          ),
          const SizedBox(height: 12),
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _BuildAiHomesFormState.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _BuildAiHomesFormState.line, width: 1),
            ),
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _activeStroke = [details.localPosition];
                  _strokes.add(_activeStroke!);
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  _activeStroke?.add(details.localPosition);
                });
              },
              onPanEnd: (_) {
                setState(() {
                  _activeStroke = null;
                });
              },
              child: CustomPaint(
                painter: _BuildAiHomesSignaturePainter(_strokes),
                child: _strokes.isEmpty
                    ? Center(
                        child: Text(
                          widget.applicantName,
                          style: TextStyle(
                            fontSize: 28,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: _BuildAiHomesFormState.seal.withValues(alpha: 0.35),
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _BuildAiHomesFormState.line, width: 1.5),
                    foregroundColor: _BuildAiHomesFormState.inkSoft,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    setState(() {
                      _strokes.clear();
                      _activeStroke = null;
                    });
                  },
                  child: const Text('Clear', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _BuildAiHomesFormState.seal,
                    foregroundColor: _BuildAiHomesFormState.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onSaved();
                  },
                  child: const Text('Save Signature', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BuildAiHomesSignaturePainter extends CustomPainter {
  final List<List<Offset>> strokes;

  _BuildAiHomesSignaturePainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _BuildAiHomesFormState.seal
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (var stroke in strokes) {
      if (stroke.length < 2) continue;
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BuildAiHomesSignaturePainter oldDelegate) => true;
}
