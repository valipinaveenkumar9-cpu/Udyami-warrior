import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/first_go_stay_models.dart';
import '../widgets/application_status_view.dart';

class FirstGoStayForm extends StatefulWidget {
  final String? verticalId;
  final String? companyName;
  final Map<String, dynamic>? initialApplicationData;

  const FirstGoStayForm({
    super.key,
    this.verticalId,
    this.companyName,
    this.initialApplicationData,
  });

  @override
  State<FirstGoStayForm> createState() => _FirstGoStayFormState();
}

class _FirstGoStayFormState extends State<FirstGoStayForm> {
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
  String _statusStage =
      'submitted'; // 'submitted','meeting','rejected','notselected','payment','onboarded'
  final Set<String> _errors = {};
  final Map<String, int> _qCat =
      {}; // category index (0,1,2,3) for each questionnaire
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
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
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
  final List<String> _familiarityChecklist = [];

  // Other Work Experience
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
  final List<String> _workFacilities = [];

  // Step 5: Bank Details
  final _accountHolderNameController = TextEditingController();
  String _accountType = 'Savings';
  final _accountNumberController = TextEditingController();
  final _ifscController = TextEditingController();
  final _bankBranchController = TextEditingController();

  // Nominee Details
  final _nomineeNameController = TextEditingController();
  final _relationshipController = TextEditingController();
  final _nomineeMobileController = TextEditingController();
  final _nomineeAccountNumberController = TextEditingController();
  final _nomineeIfscController = TextEditingController();
  final _nomineeBankBranchController = TextEditingController();

  // Step 6: What You'd Like to Do
  List<String> _services = [];
  final _wardAreaController = TextEditingController();

  // Step 7: Availability & Comfort
  final _newSaversPerMonthController = TextEditingController();
  String? _hireSupportStaff;
  String? _bestTimeTraining;
  String? _smartphone;
  String? _comfortApps;
  String? _usedAppsForInvestments;
  String? _comfortPayments;
  final List<String> _langComm = [];

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

  // Step 9: Review Deposit Acknowledgements
  bool _depositAck1 = false;
  bool _depositAck2 = false;

  // Simulated Payment in Status Screen
  String _selectedPayMethod = 'UPI';
  final _upiIdController = TextEditingController();
  bool _isPaying = false;

  // Toast Overlay Support
  OverlayEntry? _toastEntry;

  // Scroll Controller
  final ScrollController _scrollController = ScrollController();

  static const Map<String, Map<String, String>> _stepMeta = {
    's1': {
      'title': 'About You',
      'subtitle': 'As it appears on your Aadhaar / PAN card',
    },
    's2': {
      'title': 'Verify Your Aadhaar',
      'subtitle': 'One secure government check',
    },
    's3': {
      'title': 'Business & Experience',
      'subtitle': 'Your business & savings/investment experience',
    },
    's4': {
      'title': "Where You'll Work From",
      'subtitle': "We'll visit before approving",
    },
    's5': {
      'title': 'Your Bank Details',
      'subtitle': 'For commission payments & FD refund',
    },
    's6': {
      'title': "What You'd Like to Do",
      'subtitle': 'Pick one module, or several',
    },
    's7': {
      'title': 'Availability & Comfort',
      'subtitle': 'With the Partner app',
    },
    's8': {'title': 'Consent', 'subtitle': 'Your promises, and your signature'},
    's9': {
      'title': 'Review Application',
      'subtitle': 'Check everything before you submit',
    },
  };

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _date8Controller.text = _formatDateYMD(now);

    if (widget.initialApplicationData != null) {
      _appStage = 'status';
      final s =
          widget.initialApplicationData!['status'] ??
          widget.initialApplicationData!['applicationStatus'] ??
          'submitted';
      _statusStage = s.toString().toLowerCase();
    }
  }

  @override
  void dispose() {
    _toastEntry?.remove();
    _scrollController.dispose();
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
    super.dispose();
  }

  String _formatDateYMD(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String _formatDateShort(DateTime? d) {
    if (d == null) return '';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }

  String _formatINR(int amount) {
    final s = amount.toString();
    if (s.length <= 3) return '₹$s';
    final last3 = s.substring(s.length - 3);
    final rest = s.substring(0, s.length - 3);
    final reg = RegExp(r'\B(?=(\d{2})+(?!\d))');
    return '₹${rest.replaceAll(reg, ',')},$last3';
  }

  void _showToast(
    String message, {
    bool isError = false,
    bool isSuccess = false,
  }) {
    _toastEntry?.remove();
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.45,
        left: 20,
        right: 20,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: isError ? stamp : (isSuccess ? seal : ink),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isError
                      ? const Color(0xFF7F2E23)
                      : (isSuccess ? sealDark : Colors.transparent),
                  width: 2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(entry);
    _toastEntry = entry;
    Timer(const Duration(milliseconds: 2200), () {
      if (_toastEntry == entry) {
        entry.remove();
        _toastEntry = null;
      }
    });
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  List<String> _buildSequence() {
    final seq = ['s1', 's2', 's3', 's4', 's5', 's6'];
    final bt = _businessType == 'institutional'
        ? 'institutional'
        : 'individual';
    for (final svc in _services) {
      seq.add('q_${svc}_$bt');
    }
    seq.addAll(['s7', 's8', 's9']);
    return seq;
  }

  bool _validateStep(String id) {
    final missing = <String>{};

    if (id == 's1') {
      if (_udyamiMember == null || _udyamiMember!.isEmpty) {
        missing.add('udyamiMember');
      } else if (_udyamiMember == 'No') {
        missing.add('udyamiMember');
      } else if (_udyamiMember == 'Yes' &&
          _memberIdController.text.trim().isEmpty) {
        missing.add('memberId');
      }

      if (_fullNameController.text.trim().isEmpty) missing.add('fullName');
      if (_mobileController.text.trim().isEmpty) missing.add('mobile');
      if (_houseStreetVillageController.text.trim().isEmpty)
        missing.add('houseStreetVillage');
      if (_stateNameController.text.trim().isEmpty) missing.add('stateName');
      if (_pinController.text.trim().isEmpty) missing.add('pin');
    } else if (id == 's2') {
      if (!_aadhaarConsent || !_aadhaarOtpVerified) {
        missing.add('aadhaarConsent');
      }
    } else if (id == 's3') {
      if (_businessType == 'institutional' &&
          _businessNameController.text.trim().isEmpty) {
        missing.add('businessName');
      }
    } else if (id == 's5') {
      if (_accountHolderNameController.text.trim().isEmpty)
        missing.add('accountHolderName');
      if (_accountNumberController.text.trim().isEmpty)
        missing.add('accountNumber');
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
      if (_udyamiMember == null || _udyamiMember!.isEmpty) {
        setState(() => _errors.add('udyamiMember'));
        _showToast(
          'Please select Yes or No for Udyami Bharat / FCMCSL membership.',
          isError: true,
        );
        return;
      }
      if (_udyamiMember == 'No') {
        setState(() => _errors.add('udyamiMember'));
        _showToast(
          'Udyami Bharat / FCMCSL membership is required to continue.',
          isError: true,
        );
        return;
      }
      if (_udyamiMember == 'Yes' && _memberIdController.text.trim().isEmpty) {
        _memberIdController.text = '123123';
      }
    }

    if (!_validateStep(_currentStepId)) {
      if (_currentStepId == 's2' && !_aadhaarOtpVerified) {
        _showToast(
          'Please verify the Aadhaar OTP before continuing.',
          isError: true,
        );
      } else if (_currentStepId == 's6' && _services.isEmpty) {
        _showToast(
          'Please select at least one module to continue.',
          isError: true,
        );
      } else {
        _showToast(
          'Please complete the highlighted fields before continuing.',
          isError: true,
        );
      }
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
    if (!_validateStep('s9')) {
      _showToast(
        'Please acknowledge the deposit terms before submitting.',
        isError: true,
      );
      return;
    }
    setState(() {
      _appStage = 'status';
      _statusStage = 'submitted';
    });
    _scrollToTop();
    _showToast('Application submitted successfully!', isSuccess: true);
  }

  void _resetApp() {
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
  }

  void _loadDemoApplicant() {
    final d = FirstGoStayDemoApplicantData.sample;
    setState(() {
      _udyamiMember = d['udyamiMember'];
      _memberIdController.text = d['memberId'];
      _fullNameController.text = d['fullName'];
      _dobController.text = d['dob'];
      _gender = d['gender'];
      _fatherHusbandNameController.text = d['fatherHusbandName'];
      _maritalStatus = d['maritalStatus'];
      _bloodGroupController.text = d['bloodGroup'];
      _nationalityController.text = d['nationality'];
      _languagesController.text = d['languages'];
      _mobileController.text = d['mobile'];
      _altMobileController.text = d['altMobile'];
      _emailController.text = d['email'];
      _occupationController.text = d['occupation'];

      _houseStreetVillageController.text = d['houseStreetVillage'];
      _talukController.text = d['taluk'];
      _districtController.text = d['district'];
      _stateNameController.text = d['stateName'];
      _pinController.text = d['pin'];
      _wardController.text = d['ward'];
      _yearsLivedHereController.text = d['yearsLivedHere'];
      _homeType = d['homeType'];
      _landmarkController.text = d['landmark'];

      _aadhaarNumberController.text = d['aadhaarNumber'];
      _aadhaarMobileController.text = d['aadhaarMobile'];
      _aadhaarNameController.text = d['aadhaarName'];
      _aadhaarConsent = true;
      _aadhaarOtpSent = false;
      _aadhaarOtpVerified = true;

      _businessType = d['businessType'];
      _businessNameController.text = d['businessName'];
      _typeOfBusiness = d['typeOfBusiness'];
      _startedOnController.text = d['startedOn'];
      _businessPanController.text = d['businessPan'];
      _tanController.text = d['tan'];
      _gstNumberController.text = d['gstNumber'];
      _udyamNumberController.text = d['udyamNumber'];
      _tradeLicenceController.text = d['tradeLicence'];

      _hasExperience = d['hasExperience'];
      _whereWorkedController.text = d['whereWorked'];
      _roleController.text = d['role'];
      _howLongController.text = d['howLong'];
      _whatYouDidController.text = d['whatYouDid'];
      _yearsExperienceController.text = d['yearsExperience'];
      _highestQualificationController.text = d['highestQualification'];
      _toolsKnownController.text = d['toolsKnown'];
      _familiarityChecklist.clear();
      _familiarityChecklist.addAll(
        List<String>.from(d['familiarityChecklist']),
      );

      _workAddressController.text = d['workAddress'];
      _ownership = d['ownership'];
      _workLandmarkController.text = d['workLandmark'];
      _wardAreaServeController.text = d['wardAreaServe'];
      _villagesCoveredController.text = d['villagesCovered'];
      _workFacilities.clear();
      _workFacilities.addAll(List<String>.from(d['workFacilities']));

      _accountHolderNameController.text = d['accountHolderName'];
      _accountType = d['accountType'];
      _accountNumberController.text = d['accountNumber'];
      _ifscController.text = d['ifsc'];
      _bankBranchController.text = d['bankBranch'];

      _nomineeNameController.text = d['nomineeName'];
      _relationshipController.text = d['relationship'];
      _nomineeMobileController.text = d['nomineeMobile'];
      _nomineeAccountNumberController.text = d['nomineeAccountNumber'];
      _nomineeIfscController.text = d['nomineeIfsc'];
      _nomineeBankBranchController.text = d['nomineeBankBranch'];

      _services = List<String>.from(d['services']);
      _wardAreaController.text = d['wardArea'];

      _newSaversPerMonthController.text = d['newSaversPerMonth'];
      _hireSupportStaff = d['hireSupportStaff'];
      _bestTimeTraining = d['bestTimeTraining'];
      _smartphone = d['smartphone'];
      _comfortApps = d['comfortApps'];
      _usedAppsForInvestments = d['usedAppsForInvestments'];
      _comfortPayments = d['comfortPayments'];
      _langComm.clear();
      _langComm.addAll(List<String>.from(d['langComm']));

      _c1 = d['c1'];
      _c2 = d['c2'];
      _c3 = d['c3'];
      _c4 = d['c4'];
      _c5 = d['c5'];
      _c6 = d['c6'];
      _c7 = d['c7'];
      _c8 = d['c8'];
      _c9 = d['c9'];
      _placeController.text = d['place'];
      _date8Controller.text = d['date8'];
      _signed = d['signed'];
      _signedAt = DateTime.now();
      _thumbImpression = d['thumbImpression'];

      _depositAck1 = d['depositAck1'];
      _depositAck2 = d['depositAck2'];

      _errors.clear();
    });

    _showToast('Demo applicant loaded', isSuccess: true);
  }

  void _openSignatureModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SignatureModal(
        applicantName: _fullNameController.text.trim().isNotEmpty
            ? _fullNameController.text.trim()
            : 'Signed',
        onSave: () {
          setState(() {
            _signed = true;
            _signedAt = DateTime.now();
            _errors.remove('signed');
          });
          _showToast('Signature saved', isSuccess: true);
        },
      ),
    );
  }

  // --- BUILD METHODS ---

  @override
  Widget build(BuildContext context) {
    if (_appStage == 'status') {
      return _buildStatusScreen();
    }
    return Scaffold(
      backgroundColor: paper,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopbar(),
            Expanded(
              child: _currentStepId.startsWith('q_')
                  ? _buildQuestionnaireScreen(_currentStepId)
                  : _buildStepScreen(_currentStepId),
            ),
          ],
        ),
      ),
    );
  }

  // Topbar
  Widget _buildTopbar() {
    return Container(
      color: seal,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FIRSTGO',
                style: TextStyle(
                  fontFamily: 'serif',
                  color: paperAlt,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Channel Partner Registration',
                style: TextStyle(
                  color: Color(0xFFCFE3DA),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
              foregroundColor: const Color(0xFFEAF3ED),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: paperAlt,
                  title: const Text(
                    'Start over?',
                    style: TextStyle(fontFamily: 'serif', color: ink),
                  ),
                  content: const Text(
                    'This clears everything you\'ve entered.',
                    style: TextStyle(color: inkSoft),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: muted),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _resetApp();
                      },
                      child: const Text(
                        'Restart',
                        style: TextStyle(
                          color: stamp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: const Text('↺ Restart', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  // Step Progress Header
  Widget _buildStepHeader(String id) {
    final meta = _stepMeta[id]!;
    final num = int.parse(id.substring(1));
    final pct = (num * 100 / 9).round().clamp(0, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
          child: Column(
            children: [
              Container(
                height: 5,
                decoration: BoxDecoration(
                  color: line,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: pct / 100,
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
                    'STEP $num/9',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: sealDark,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    '$pct%',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: muted,
                      letterSpacing: 0.5,
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
            border: Border(bottom: BorderSide(color: line)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meta['title']!,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: ink,
                  height: 1.15,
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
    );
  }

  // Error Banner
  Widget _buildErrorBanner() {
    if (_currentStepId == 's1' && _udyamiMember == 'No') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        margin: const EdgeInsets.only(bottom: 14),
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
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    if (_errors.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        margin: const EdgeInsets.only(bottom: 14),
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
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  // Demo Box on Step 1
  Widget _buildDemoBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: goldTint,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: gold, style: BorderStyle.solid),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Prototype demo',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Color(0xFF5B4415),
            ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size.zero,
            ),
            onPressed: _loadDemoApplicant,
            child: const Text(
              'Load Demo Applicant',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // Footer / Navigation
  Widget _buildFooter(String id) {
    final seq = _buildSequence();
    final idx = seq.indexOf(id);
    final backDisabled = idx <= 0;
    final isLast = id == 's9';

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: const BoxDecoration(
        color: paperAlt,
        border: Border(top: BorderSide(color: line)),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: backDisabled ? null : _goBack,
              child: const Text(
                'Back',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: isLast ? _submitApplication : _goNext,
              child: Text(
                isLast ? 'Submit Application' : 'Continue',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Step Screen Builder
  Widget _buildStepScreen(String id) {
    return Column(
      children: [
        _buildStepHeader(id),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (id == 's1') _buildDemoBanner(),
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
        _buildFooter(id),
      ],
    );
  }

  // --- STEP 1: ABOUT YOU ---
  List<Widget> _buildStep1Fields() {
    return [
      _buildNote(
        "You must already be a Udyami Bharat / FCMCSL member to apply. If you're not yet a member, register through One Core first — the details below should match your One Core profile.",
      ),
      _buildRadioGroup(
        label: 'Are you already a Udyami Bharat / FCMCSL member?*',
        errorKey: 'udyamiMember',
        options: ['Yes', 'No'],
        value: _udyamiMember,
        onChanged: (v) => setState(() {
          _udyamiMember = v;
          _errors.remove('udyamiMember');
          if (v == 'Yes' && _memberIdController.text.isEmpty) {
            _memberIdController.text = '123123';
          }
        }),
      ),
      if (_udyamiMember == 'Yes')
        _buildTextField(
          label: 'Member ID*',
          errorKey: 'memberId',
          controller: _memberIdController,
          placeholder: 'Enter your Member ID',
        ),
      _buildTextField(
        label: 'Full Name*',
        errorKey: 'fullName',
        controller: _fullNameController,
        help:
            'As on Aadhaar / PAN — for individual applicant or authorized representative',
      ),
      Row(
        children: [
          Expanded(
            child: _buildDateField(
              label: 'Date of Birth',
              controller: _dobController,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildSelectField(
              label: 'Gender',
              value: _gender,
              options: ['Male', 'Female', 'Other'],
              onChanged: (v) => setState(() => _gender = v),
            ),
          ),
        ],
      ),
      _buildTextField(
        label: "Father's / Husband's Name",
        controller: _fatherHusbandNameController,
      ),
      Row(
        children: [
          Expanded(
            child: _buildSelectField(
              label: 'Marital Status',
              value: _maritalStatus,
              options: ['Single', 'Married', 'Other'],
              onChanged: (v) => setState(() => _maritalStatus = v),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              label: 'Blood Group',
              controller: _bloodGroupController,
              placeholder: 'e.g. B+',
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              label: 'Nationality',
              controller: _nationalityController,
              placeholder: 'Indian',
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              label: 'Languages Spoken',
              controller: _languagesController,
              placeholder: 'Kannada, English',
            ),
          ),
        ],
      ),
      _buildTextField(
        label: 'Mobile Number*',
        errorKey: 'mobile',
        controller: _mobileController,
        keyboardType: TextInputType.phone,
        help: "We'll send an OTP here",
      ),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              label: 'Alternate Mobile (optional)',
              controller: _altMobileController,
              keyboardType: TextInputType.phone,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              label: 'Email ID',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ],
      ),
      _buildTextField(
        label: 'Occupation',
        controller: _occupationController,
        placeholder:
            'e.g. Travel agent, Tour operator, Corporate travel desk, Visa consultant',
      ),
      _buildSectionLabel('Your Address'),
      _buildTextField(
        label: 'House No. / Street / Village-Town*',
        errorKey: 'houseStreetVillage',
        controller: _houseStreetVillageController,
      ),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              label: 'Taluk',
              controller: _talukController,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              label: 'District',
              controller: _districtController,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              label: 'State*',
              errorKey: 'stateName',
              controller: _stateNameController,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              label: 'PIN Code*',
              errorKey: 'pin',
              controller: _pinController,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
      _buildTextField(
        label: 'Ward / Hobli / Zone',
        controller: _wardController,
      ),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              label: 'Years Lived Here',
              controller: _yearsLivedHereController,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildSelectField(
              label: 'Home Type',
              value: _homeType,
              options: ['Own', 'Rented', 'Family'],
              onChanged: (v) => setState(() => _homeType = v),
            ),
          ),
        ],
      ),
      _buildTextField(
        label: 'Nearest Landmark',
        controller: _landmarkController,
      ),
    ];
  }

  // --- STEP 2: VERIFY YOUR AADHAAR ---
  List<Widget> _buildStep2Fields() {
    return [
      _buildNote(
        "We'll confirm your identity via a one-time Aadhaar OTP check, through a secure, government-approved partner. FirstGo never stores your Aadhaar number.",
      ),
      _buildTextField(
        label: 'Aadhaar Number',
        controller: _aadhaarNumberController,
        placeholder: 'XXXX XXXX XXXX',
        keyboardType: TextInputType.number,
      ),
      _buildTextField(
        label: 'Mobile Linked to Aadhaar',
        controller: _aadhaarMobileController,
        keyboardType: TextInputType.phone,
      ),
      _buildTextField(
        label: 'Name on Aadhaar',
        controller: _aadhaarNameController,
      ),
      const SizedBox(height: 10),
      _buildAadhaarVerifyWidget(),
    ];
  }

  Widget _buildAadhaarVerifyWidget() {
    if (_aadhaarOtpVerified) {
      return Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: sealTint,
          border: Border.all(color: seal, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Text(
              '✓',
              style: TextStyle(
                color: sealDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Aadhaar verified successfully',
              style: TextStyle(
                color: sealDark,
                fontWeight: FontWeight.w600,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      );
    }

    final hasErr = _errors.contains('aadhaarConsent');

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _aadhaarConsent = !_aadhaarConsent;
                _aadhaarOtpSent = _aadhaarConsent;
                _aadhaarOtpVerified = false;
                for (var c in _otpControllers) {
                  c.clear();
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _aadhaarOtpSent ? sealTint : paperAlt,
                border: Border.all(
                  color: hasErr ? stamp : (_aadhaarOtpSent ? seal : line),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.only(top: 2, right: 10),
                    decoration: BoxDecoration(
                      color: _aadhaarOtpSent ? seal : Colors.transparent,
                      border: Border.all(
                        color: _aadhaarOtpSent ? seal : line,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: _aadhaarOtpSent
                        ? const Center(
                            child: Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  const Expanded(
                    child: Text(
                      'Yes, please verify my Aadhaar using OTP, through a secure government-approved partner.',
                      style: TextStyle(color: ink, fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_aadhaarOtpSent) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: paperAlt,
                border: Border.all(color: line, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter OTP*',
                    style: TextStyle(
                      color: inkSoft,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: List.generate(4, (index) {
                            return Container(
                              width: 44,
                              height: 48,
                              margin: const EdgeInsets.only(right: 8),
                              child: TextField(
                                controller: _otpControllers[index],
                                focusNode: _otpFocusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
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
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: hasErr ? stamp : line,
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
                                  if (val.isNotEmpty) {
                                    if (index < 3) {
                                      _otpFocusNodes[index + 1].requestFocus();
                                    } else {
                                      _otpFocusNodes[index].unfocus();
                                      _checkAndVerifyOtp();
                                    }
                                  } else if (val.isEmpty && index > 0) {
                                    _otpFocusNodes[index - 1].requestFocus();
                                  }
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: seal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        onPressed: _checkAndVerifyOtp,
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
                  const SizedBox(height: 7),
                  const Text(
                    'Demo OTP: 1234',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: muted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _checkAndVerifyOtp() {
    final enteredOtp = _otpControllers.map((c) => c.text).join();
    if (enteredOtp == '1234') {
      setState(() {
        _aadhaarOtpVerified = true;
        _aadhaarConsent = true;
        _aadhaarOtpSent = false;
        _errors.remove('aadhaarConsent');
      });
      _showToast('Aadhaar verified successfully.', isSuccess: true);
    } else {
      setState(() {
        _errors.add('aadhaarConsent');
      });
      _showToast('Incorrect OTP. Use 1234 for the demo.', isError: true);
    }
  }

  // --- STEP 3: BUSINESS & EXPERIENCE ---
  List<Widget> _buildStep3Fields() {
    return [
      _buildSectionLabel('Your Business'),
      _buildRadioGroup(
        label: 'Business Type*',
        errorKey: 'businessType',
        options: [
          {'value': 'institutional', 'label': 'I run a registered business'},
          {'value': 'individual', 'label': 'Applying as an individual'},
        ],
        value: _businessType,
        onChanged: (v) => setState(() {
          _businessType = v!;
          _errors.remove('businessType');
        }),
      ),
      if (_businessType == 'institutional') ...[
        _buildTextField(
          label: 'Business Name*',
          errorKey: 'businessName',
          controller: _businessNameController,
        ),
        Row(
          children: [
            Expanded(
              child: _buildSelectField(
                label: 'Type of Business',
                value: _typeOfBusiness,
                options: ['Proprietorship', 'Partnership', 'LLP', 'Pvt Ltd'],
                onChanged: (v) => setState(() => _typeOfBusiness = v),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildDateField(
                label: 'Started On',
                controller: _startedOnController,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'Business PAN (if diff.)',
                controller: _businessPanController,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildTextField(
                label: 'TAN (optional)',
                controller: _tanController,
              ),
            ),
          ],
        ),
        _buildTextField(
          label: 'GST Number (if registered)',
          controller: _gstNumberController,
        ),
        _buildTextField(
          label: 'Udyam / MSME Number',
          controller: _udyamNumberController,
        ),
        _buildTextField(
          label: 'Trade Licence Number & Issued By',
          controller: _tradeLicenceController,
        ),
      ],
      _buildSectionLabel('Savings, Investment & Client Advisory Experience'),
      _buildCheckboxSingle(
        label: 'Yes, I have relevant experience',
        value: _hasExperience,
        onChanged: (v) => setState(() => _hasExperience = v ?? false),
      ),
      if (_hasExperience) ...[
        _buildTextField(
          label: 'Where You Worked',
          controller: _whereWorkedController,
        ),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'Your Role',
                controller: _roleController,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildTextField(
                label: 'How Long (From–To)',
                controller: _howLongController,
              ),
            ),
          ],
        ),
        _buildTextareaField(
          label: 'What You Did',
          controller: _whatYouDidController,
        ),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'Years of Experience',
                controller: _yearsExperienceController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildTextField(
                label: 'Highest Qualification',
                controller: _highestQualificationController,
              ),
            ),
          ],
        ),
        _buildTextField(
          label: 'Tools You Know (e.g. UPI Autopay, mutual fund portals)',
          controller: _toolsKnownController,
        ),
      ],
      _buildCheckboxGroup(
        label: 'Familiarity',
        options: [
          'I know my way around KYC / AML basics',
          "I'm familiar with SIP / mutual-fund style savings plans",
          "I've explained investment products to clients before",
        ],
        selectedList: _familiarityChecklist,
      ),
      _buildSectionLabel('Any Other Work Experience'),
      _buildTextField(
        label: 'Field / Sector',
        controller: _fieldSectorController,
      ),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              label: 'Business or Employer',
              controller: _businessOrEmployerController,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              label: 'How Long (From–To)',
              controller: _otherHowLongController,
            ),
          ),
        ],
      ),
      _buildTextareaField(
        label: 'What You Did',
        controller: _otherWhatYouDidController,
      ),
    ];
  }

  // --- STEP 4: WHERE YOU'LL WORK FROM ---
  List<Widget> _buildStep4Fields() {
    return [
      _buildNote(
        "We'll visit before approving — client trust and document safety matter.",
      ),
      _buildTextField(
        label: 'Work Address',
        controller: _workAddressController,
      ),
      Row(
        children: [
          Expanded(
            child: _buildSelectField(
              label: 'Ownership',
              value: _ownership,
              options: ['Owned', 'Rented', 'Leased'],
              onChanged: (v) => setState(() => _ownership = v),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              label: 'Nearest Landmark',
              controller: _workLandmarkController,
            ),
          ),
        ],
      ),
      _buildTextField(
        label: "Ward / Area You'll Serve",
        controller: _wardAreaServeController,
      ),
      _buildTextField(
        label: 'Villages / Localities Covered',
        controller: _villagesCoveredController,
      ),
      _buildCheckboxGroup(
        label: 'Facilities at Work Location',
        options: [
          'Private area for clients to discuss their investments',
          'Secure, lockable place to store paperwork',
          'CCTV or other document security',
          'Internet access to log leads and savers',
          'Computer, scanner and printer on site',
          'Familiar with One Core KYC / onboarding process',
        ],
        selectedList: _workFacilities,
      ),
    ];
  }

  // --- STEP 5: YOUR BANK DETAILS ---
  List<Widget> _buildStep5Fields() {
    return [
      _buildTextField(
        label: 'Account Holder Name*',
        errorKey: 'accountHolderName',
        controller: _accountHolderNameController,
      ),
      Row(
        children: [
          Expanded(
            child: _buildSelectField(
              label: 'Account Type',
              value: _accountType,
              options: ['Savings', 'Current'],
              onChanged: (v) => setState(() => _accountType = v!),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              label: 'Account Number*',
              errorKey: 'accountNumber',
              controller: _accountNumberController,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              label: 'IFSC Code*',
              errorKey: 'ifsc',
              controller: _ifscController,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              label: 'Bank & Branch Name',
              controller: _bankBranchController,
            ),
          ),
        ],
      ),
      // Nominee Panel
      Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFBF6E9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: gold, width: 1.5, style: BorderStyle.solid),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '🛡 Alternate / Nominee Details',
              style: TextStyle(
                fontFamily: 'serif',
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
                color: gold,
              ),
            ),
            const SizedBox(height: 8),
            _buildNote(
              "In the event of death or an unforeseen circumstance, any pending funds will be released to this nominee's account instead.",
            ),
            _buildTextField(
              label: 'Nominee Name',
              controller: _nomineeNameController,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Relationship to You',
                    controller: _relationshipController,
                    placeholder: 'e.g. Spouse, Son',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildTextField(
                    label: 'Nominee Mobile',
                    controller: _nomineeMobileController,
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            _buildTextField(
              label: 'Nominee Account Number',
              controller: _nomineeAccountNumberController,
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'IFSC Code',
                    controller: _nomineeIfscController,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildTextField(
                    label: 'Bank & Branch Name',
                    controller: _nomineeBankBranchController,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }

  // --- STEP 6: WHAT YOU'D LIKE TO DO ---
  List<Widget> _buildStep6Fields() {
    return [
      _buildNote(
        'Choose one, or several — commission and deposit terms are the same across all twelve modules: 4% commission, ₹5,00,000 security deposit per module.',
      ),
      const Text(
        'Modules*',
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: inkSoft,
        ),
      ),
      const SizedBox(height: 8),
      ...FirstGoStayConstants.serviceCards.map((card) {
        final active = _services.contains(card.id);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (active) {
                _services.remove(card.id);
              } else {
                _services.add(card.id);
              }
              _errors.remove('services');
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: active ? sealTint : paperAlt,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: active
                    ? seal
                    : (_errors.contains('services') ? stamp : line),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
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
                              size: 14,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(card.icon, style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(right: 28),
                      child: Text(
                        card.name,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontWeight: FontWeight.w700,
                          fontSize: 15.5,
                          color: ink,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card.desc,
                      style: const TextStyle(
                        fontSize: 12,
                        color: muted,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
      _buildNote(
        'Pick one module, or several. After Continue, the relevant 20-question verification for each module opens, based on your Business Type from Step 3.',
      ),
      _buildTextField(
        label: "Ward / Area You'd Like to Serve*",
        errorKey: 'wardArea',
        controller: _wardAreaController,
      ),
      _buildNote(
        "If your ward is full, you'll be waitlisted or offered a nearby open ward. You'll answer 20 verification questions for each module you select, based on whether you're applying as an individual or a registered business.",
      ),
    ];
  }

  // --- STEP 7: AVAILABILITY & COMFORT ---
  List<Widget> _buildStep7Fields() {
    return [
      _buildTextField(
        label: 'New Savers / Investors You Expect to Onboard Per Month',
        controller: _newSaversPerMonthController,
        keyboardType: TextInputType.number,
      ),
      Row(
        children: [
          Expanded(
            child: _buildRadioGroup(
              label: 'Hire Support Staff?',
              options: ['Yes', 'No'],
              value: _hireSupportStaff,
              onChanged: (v) => setState(() => _hireSupportStaff = v),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildSelectField(
              label: 'Best Time for Training',
              value: _bestTimeTraining,
              options: ['Weekdays', 'Weekends', 'Both', 'Flexible'],
              onChanged: (v) => setState(() => _bestTimeTraining = v),
            ),
          ),
        ],
      ),
      _buildSectionLabel('Smartphone & App Experience'),
      _buildRadioGroup(
        label: 'Which Smartphone Do You Use?',
        options: ['Android', 'iPhone (iOS)', 'Both'],
        value: _smartphone,
        onChanged: (v) => setState(() => _smartphone = v),
      ),
      _buildRadioGroup(
        label: 'Comfort Using Smartphone Apps?',
        options: [
          'Very Comfortable',
          'Comfortable',
          'Need Training',
          'Not Comfortable',
        ],
        value: _comfortApps,
        onChanged: (v) => setState(() => _comfortApps = v),
      ),
      _buildRadioGroup(
        label: 'Used Apps for Investments / Online Forms?',
        options: ['Yes, Regularly', 'Yes, Sometimes', 'No'],
        value: _usedAppsForInvestments,
        onChanged: (v) => setState(() => _usedAppsForInvestments = v),
      ),
      _buildRadioGroup(
        label: 'Comfort With UPI Autopay, OTP & Digital Payments?',
        options: [
          'Very Comfortable',
          'Comfortable',
          'Need Guidance',
          'Need Full Training',
        ],
        value: _comfortPayments,
        onChanged: (v) => setState(() => _comfortPayments = v),
      ),
      _buildSectionLabel('Language & Client Communication'),
      _buildCheckboxGroup(
        label: 'Language & App Comfort',
        options: [
          "I'm comfortable using the Partner app already",
          "I'll need a bit of training first",
          'I can talk to clients in Kannada',
          'I can talk to clients in English',
        ],
        selectedList: _langComm,
      ),
    ];
  }

  // --- STEP 8: CONSENT ---
  List<Widget> _buildStep8Fields() {
    return [
      _buildCheckboxSingle(
        label: 'I agree to the Aadhaar identity check described in Step 2.*',
        errorKey: 'c1',
        value: _c1,
        onChanged: (v) => setState(() {
          _c1 = v ?? false;
          _errors.remove('c1');
        }),
      ),
      _buildCheckboxSingle(
        label:
            'I understand my account stays inactive until I finish training.*',
        errorKey: 'c2',
        value: _c2,
        onChanged: (v) => setState(() {
          _c2 = v ?? false;
          _errors.remove('c2');
        }),
      ),
      _buildCheckboxSingle(
        label:
            "I'll keep every client's personal and financial information safe, secure and private.*",
        errorKey: 'c3',
        value: _c3,
        onChanged: (v) => setState(() {
          _c3 = v ?? false;
          _errors.remove('c3');
        }),
      ),
      _buildCheckboxSingle(
        label:
            "I don't have any conflict of interest that would get in the way of this role.*",
        errorKey: 'c4',
        value: _c4,
        onChanged: (v) => setState(() {
          _c4 = v ?? false;
          _errors.remove('c4');
        }),
      ),
      _buildCheckboxSingle(
        label:
            'I understand returns are projections, not guarantees, and I will never promise assured returns to a member.*',
        errorKey: 'c5',
        value: _c5,
        onChanged: (v) => setState(() {
          _c5 = v ?? false;
          _errors.remove('c5');
        }),
      ),
      _buildCheckboxSingle(
        label:
            'I understand FirstGo holds no member money directly — all contributions post through One Core.*',
        errorKey: 'c6',
        value: _c6,
        onChanged: (v) => setState(() {
          _c6 = v ?? false;
          _errors.remove('c6');
        }),
      ),
      _buildCheckboxSingle(
        label: "I've read the FirstGo Code of Conduct and I'll follow it.*",
        errorKey: 'c7',
        value: _c7,
        onChanged: (v) => setState(() {
          _c7 = v ?? false;
          _errors.remove('c7');
        }),
      ),
      _buildCheckboxSingle(
        label: "Everything I've written in this form is true.*",
        errorKey: 'c8',
        value: _c8,
        onChanged: (v) => setState(() {
          _c8 = v ?? false;
          _errors.remove('c8');
        }),
      ),
      _buildCheckboxSingle(
        label:
            "I've read the plain-language summary and full agreement, and I agree to it.*",
        errorKey: 'c9',
        value: _c9,
        onChanged: (v) => setState(() {
          _c9 = v ?? false;
          _errors.remove('c9');
        }),
      ),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              label: 'Place*',
              errorKey: 'place',
              controller: _placeController,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildDateField(
              label: 'Date*',
              errorKey: 'date8',
              controller: _date8Controller,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Signature*',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: inkSoft,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Tap to Sign',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: muted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _openSignatureModal,
                  child: Container(
                    height: 64,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: _signed ? sealTint : paperAlt,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _errors.contains('signed')
                            ? stamp
                            : (_signed ? seal : line),
                        width: 1.5,
                        style: _signed ? BorderStyle.solid : BorderStyle.none,
                      ),
                    ),
                    child: Center(
                      child: _signed
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _fullNameController.text.trim().isNotEmpty
                                      ? _fullNameController.text.trim()
                                      : 'Signed',
                                  style: const TextStyle(
                                    fontFamily: 'serif',
                                    fontStyle: FontStyle.italic,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: sealDark,
                                  ),
                                ),
                                Text(
                                  'Signed ${_formatDateShort(_signedAt)}',
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
                const SizedBox(height: 2),
                const Text(' ', style: TextStyle(fontSize: 11.5)),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () =>
                      setState(() => _thumbImpression = !_thumbImpression),
                  child: Container(
                    height: 64,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: _thumbImpression ? sealTint : paperAlt,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _thumbImpression ? seal : line,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _thumbImpression ? '👍 Captured' : 'Tap to capture',
                        style: TextStyle(
                          fontSize: 12,
                          color: _thumbImpression ? sealDark : muted,
                          fontWeight: _thumbImpression
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
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

  // --- STEP 9: REVIEW APPLICATION ---
  List<Widget> _buildStep9Fields() {
    final deposit = _services.length * FirstGoStayConstants.depositPerModule;

    return [
      _buildNote(
        "Here's what you've entered. Go back to any earlier step to make changes before submitting.",
      ),
      _buildReviewSummary(),
      const SizedBox(height: 16),
      const Text(
        'Security Deposit',
        style: TextStyle(
          fontFamily: 'serif',
          fontWeight: FontWeight.w600,
          fontSize: 14.5,
          color: sealDark,
        ),
      ),
      const Text(
        '(shown after Ward Head acceptance & onboarding meeting)',
        style: TextStyle(
          fontSize: 11,
          color: muted,
          fontStyle: FontStyle.italic,
        ),
      ),
      const SizedBox(height: 8),
      _buildDepositTable(deposit),
      const SizedBox(height: 14),
      _buildCheckboxSingle(
        label: "I'll only pay this after approval — within 7 days.*",
        errorKey: 'depositAck1',
        value: _depositAck1,
        onChanged: (v) => setState(() {
          _depositAck1 = v ?? false;
          _errors.remove('depositAck1');
        }),
      ),
      _buildCheckboxSingle(
        label:
            "I'll get this back within 30 days if I leave or resign — or I can leave it deposited.*",
        errorKey: 'depositAck2',
        value: _depositAck2,
        onChanged: (v) => setState(() {
          _depositAck2 = v ?? false;
          _errors.remove('depositAck2');
        }),
      ),
      _buildNote(
        "You'll receive a 4% commission on the facilitation fee value for the following 12 months, per module you're onboarded in. Every commission payment goes through One Core — never cash. Returns shown to members are projections, never guarantees.",
      ),
    ];
  }

  Widget _buildReviewSummary() {
    final reviewStepIds = ['s1', 's2', 's3', 's4', 's5', 's6', 's7', 's8'];
    final blocks = <Widget>[];

    for (final stepId in reviewStepIds) {
      final rows = <MapEntry<String, String>>[];

      if (stepId == 's1') {
        if (_udyamiMember != null)
          rows.add(MapEntry('Udyami Member', _udyamiMember!));
        if (_memberIdController.text.isNotEmpty)
          rows.add(MapEntry('Member ID', _memberIdController.text));
        if (_fullNameController.text.isNotEmpty)
          rows.add(MapEntry('Full Name', _fullNameController.text));
        if (_dobController.text.isNotEmpty)
          rows.add(MapEntry('Date of Birth', _dobController.text));
        if (_gender != null) rows.add(MapEntry('Gender', _gender!));
        if (_mobileController.text.isNotEmpty)
          rows.add(MapEntry('Mobile', _mobileController.text));
        if (_emailController.text.isNotEmpty)
          rows.add(MapEntry('Email', _emailController.text));
        if (_occupationController.text.isNotEmpty)
          rows.add(MapEntry('Occupation', _occupationController.text));
        if (_houseStreetVillageController.text.isNotEmpty)
          rows.add(MapEntry('Address', _houseStreetVillageController.text));
        if (_stateNameController.text.isNotEmpty)
          rows.add(MapEntry('State', _stateNameController.text));
        if (_pinController.text.isNotEmpty)
          rows.add(MapEntry('PIN', _pinController.text));
      } else if (stepId == 's2') {
        if (_aadhaarNumberController.text.isNotEmpty)
          rows.add(MapEntry('Aadhaar Number', _aadhaarNumberController.text));
        if (_aadhaarOtpVerified)
          rows.add(const MapEntry('Aadhaar Status', 'Verified via OTP'));
      } else if (stepId == 's3') {
        rows.add(
          MapEntry(
            'Business Type',
            _businessType == 'institutional'
                ? 'Registered Business'
                : 'Individual',
          ),
        );
        if (_businessType == 'institutional' &&
            _businessNameController.text.isNotEmpty) {
          rows.add(MapEntry('Business Name', _businessNameController.text));
        }
        if (_hasExperience) {
          rows.add(const MapEntry('Relevant Experience', 'Yes'));
          if (_whereWorkedController.text.isNotEmpty)
            rows.add(MapEntry('Where Worked', _whereWorkedController.text));
          if (_roleController.text.isNotEmpty)
            rows.add(MapEntry('Role', _roleController.text));
        }
      } else if (stepId == 's4') {
        if (_workAddressController.text.isNotEmpty)
          rows.add(MapEntry('Work Address', _workAddressController.text));
        if (_wardAreaServeController.text.isNotEmpty)
          rows.add(MapEntry('Ward Served', _wardAreaServeController.text));
      } else if (stepId == 's5') {
        if (_accountHolderNameController.text.isNotEmpty)
          rows.add(
            MapEntry('Account Holder', _accountHolderNameController.text),
          );
        if (_accountNumberController.text.isNotEmpty)
          rows.add(MapEntry('Account Number', _accountNumberController.text));
        if (_ifscController.text.isNotEmpty)
          rows.add(MapEntry('IFSC', _ifscController.text));
      } else if (stepId == 's6') {
        if (_services.isNotEmpty) {
          final svcNames = _services
              .map((id) {
                final card = FirstGoStayConstants.serviceCards.firstWhere(
                  (c) => c.id == id,
                  orElse: () => FirstGoStayServiceCard(
                    id: id,
                    icon: '',
                    name: id,
                    desc: '',
                  ),
                );
                return card.name;
              })
              .join(', ');
          rows.add(MapEntry('Modules', svcNames));
        }
        if (_wardAreaController.text.isNotEmpty)
          rows.add(MapEntry('Preferred Ward', _wardAreaController.text));
      } else if (stepId == 's7') {
        if (_newSaversPerMonthController.text.isNotEmpty)
          rows.add(
            MapEntry(
              'Expected Savers/Month',
              _newSaversPerMonthController.text,
            ),
          );
        if (_smartphone != null) rows.add(MapEntry('Smartphone', _smartphone!));
      } else if (stepId == 's8') {
        if (_signed) rows.add(const MapEntry('Signature', 'Signed'));
        if (_thumbImpression)
          rows.add(const MapEntry('Thumb Impression', 'Captured'));
        if (_placeController.text.isNotEmpty)
          rows.add(MapEntry('Place', _placeController.text));
        if (_date8Controller.text.isNotEmpty)
          rows.add(MapEntry('Date', _date8Controller.text));
      }

      if (rows.isNotEmpty) {
        blocks.add(
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: paperAlt,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  color: const Color(0xFFEDE6D2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _stepMeta[stepId]!['title']!,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: sealDark,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentStepId = stepId;
                            _errors.clear();
                          });
                          _scrollToTop();
                        },
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                            color: stamp,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ...rows.map(
                  (r) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: line)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            r.key,
                            style: const TextStyle(color: muted, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          r.value,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: ink,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
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
    }

    // Questionnaire Answers in Review
    final bt = _businessType == 'institutional'
        ? 'institutional'
        : 'individual';
    for (final svc in _services) {
      final qid = 'q_${svc}_$bt';
      final data = FirstGoStayQuestionnaires.all[qid];
      if (data == null) continue;

      final answeredQuestions = <Widget>[];
      for (final cat in data.categories) {
        final catAnswers = <Widget>[];
        for (int i = 0; i < cat.questions.length; i++) {
          final n = cat.startNum + i;
          final ans = (_qa[n] ?? '').trim();
          if (ans.isNotEmpty) {
            catAnswers.add(
              Container(
                padding: const EdgeInsets.all(11),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: line)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$n. ${cat.questions[i]}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ans,
                      style: const TextStyle(
                        fontSize: 12,
                        color: inkSoft,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
        if (catAnswers.isNotEmpty) {
          answeredQuestions.add(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: paper,
              child: Text(
                cat.name,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: sealDark,
                ),
              ),
            ),
          );
          answeredQuestions.addAll(catAnswers);
        }
      }

      if (answeredQuestions.isNotEmpty) {
        blocks.add(
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: paperAlt,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  color: const Color(0xFFEDE6D2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.title,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: sealDark,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentStepId = qid;
                            _errors.clear();
                          });
                          _scrollToTop();
                        },
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                            color: stamp,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ...answeredQuestions,
              ],
            ),
          ),
        );
      }
    }

    return Column(children: blocks);
  }

  Widget _buildDepositTable(int totalDeposit) {
    return Container(
      decoration: BoxDecoration(
        color: paperAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: line),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: ink, width: 1.5)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MODULE',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: muted,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'AMOUNT',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: muted,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          ..._services.map((id) {
            final card = FirstGoStayConstants.serviceCards.firstWhere(
              (c) => c.id == id,
              orElse: () =>
                  FirstGoStayServiceCard(id: id, icon: '', name: id, desc: ''),
            );
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: line)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    card.name,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: ink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _formatINR(FirstGoStayConstants.depositPerModule),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12.5,
                      color: gold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: const Color(0xFFFBF6E9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Security Deposit',
                  style: TextStyle(
                    fontSize: 13,
                    color: ink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatINR(totalDeposit),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    color: gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- QUESTIONNAIRE SCREENS ---
  Widget _buildQuestionnaireScreen(String qid) {
    final data = FirstGoStayQuestionnaires.all[qid];
    if (data == null) {
      return Center(
        child: ElevatedButton(
          onPressed: _goNext,
          child: const Text('Continue'),
        ),
      );
    }

    final catIdx = _qCat[qid] ?? 0;
    final cat = data.categories[catIdx];
    final isLastCat = catIdx >= data.categories.length - 1;

    return Column(
      children: [
        Container(
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
                  color: gold,
                  fontWeight: FontWeight.w700,
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
                style: const TextStyle(
                  fontSize: 12,
                  color: muted,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(data.categories.length, (i) {
                  final active = i == catIdx;
                  final done = i < catIdx;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: active ? 20 : 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 6),
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
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: cat.questions.asMap().entries.map((entry) {
                final n = cat.startNum + entry.key;
                final q = entry.value;
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
                      TextFormField(
                        initialValue: _qa[n] ?? '',
                        maxLines: 3,
                        style: const TextStyle(fontSize: 14.5, color: ink),
                        decoration: InputDecoration(
                          hintText: 'Type your answer…',
                          hintStyle: const TextStyle(
                            color: Color(0xFFB3A98F),
                            fontSize: 13.5,
                          ),
                          filled: true,
                          fillColor: paperAlt,
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: line,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: seal,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          _qa[n] = val;
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
          decoration: const BoxDecoration(
            color: paperAlt,
            border: Border(top: BorderSide(color: line)),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (catIdx > 0) {
                      setState(() => _qCat[qid] = catIdx - 1);
                      _scrollToTop();
                    } else {
                      _goBack();
                    }
                  },
                  child: const Text(
                    'Back',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (!isLastCat) {
                      setState(() => _qCat[qid] = catIdx + 1);
                      _scrollToTop();
                    } else {
                      final seq = _buildSequence();
                      final idx = seq.indexOf(qid);
                      if (idx >= 0 && idx < seq.length - 1) {
                        setState(() {
                          _currentStepId = seq[idx + 1];
                          _errors.clear();
                        });
                        _scrollToTop();
                      }
                    }
                  },
                  child: Text(
                    isLastCat ? 'Continue' : 'Next Section',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- STATUS SCREENS ---
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
      theme: CompanyStatusTheme.firstGoStay(),
      initialStageIndex: _mapStatusToStageIndex(_statusStage),
      applicantName: _fullNameController.text.trim().isNotEmpty ? _fullNameController.text.trim() : 'Vikramaditya Shinde',
      applicationId: '#FGS-${DateTime.now().year}-9021',
      wardLocality: _wardAreaController.text.trim().isNotEmpty ? _wardAreaController.text.trim() : 'Ward 04, Whitefield',
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

  Widget _buildTimeline(List<String> steps, int activeIdx) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: steps.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          final isDone = i < activeIdx;
          final isCurrent = i == activeIdx;

          return Expanded(
            child: Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? seal
                        : (isCurrent ? Colors.white : paperAlt),
                    border: Border.all(
                      color: (isDone || isCurrent) ? seal : line,
                      width: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  s,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: (isDone || isCurrent)
                        ? FontWeight.w600
                        : FontWeight.normal,
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

  Widget _buildMeetingRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: muted, fontSize: 12.5)),
          Text(
            value,
            style: const TextStyle(
              color: ink,
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoControls() {
    final outcomes = [
      {'id': 'submitted', 'label': 'Submitted'},
      {'id': 'meeting', 'label': 'Meeting Scheduled'},
      {'id': 'rejected', 'label': 'Rejected'},
      {'id': 'notselected', 'label': 'Not Selected'},
      {'id': 'payment', 'label': 'Payment'},
      {'id': 'onboarded', 'label': 'Onboarded'},
    ].where((x) => x['id'] != _statusStage).toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
      decoration: const BoxDecoration(
        color: paperAlt,
        border: Border(
          top: BorderSide(color: line, style: BorderStyle.solid),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'DEMO · PREVIEW OTHER OUTCOMES',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 0.5,
              color: muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              ...outcomes.map(
                (o) => OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: line),
                    backgroundColor: paperAlt,
                    foregroundColor: inkSoft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => setState(() => _statusStage = o['id']!),
                  child: Text(
                    o['label']!,
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: line),
                  backgroundColor: paperAlt,
                  foregroundColor: inkSoft,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _resetApp,
                child: const Text(
                  '↺ Start Over',
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- REUSABLE FIELD BUILDERS ---

  Widget _buildNote(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: paperAlt,
        border: Border(left: BorderSide(color: gold, width: 3)),
        borderRadius: BorderRadius.horizontal(right: Radius.circular(2)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12.5, color: muted, height: 1.5),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 22, 0, 10),
      padding: const EdgeInsets.only(bottom: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: line)),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? errorKey,
    String? placeholder,
    String? help,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final hasErr = errorKey != null && _errors.contains(errorKey);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
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
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14.5, color: ink),
            decoration: InputDecoration(
              isDense: true,
              hintText: placeholder,
              hintStyle: const TextStyle(
                color: Color(0xFFB3A98F),
                fontSize: 14.5,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 2,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: hasErr ? stamp : line,
                  width: 1.5,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: seal, width: 2),
              ),
            ),
            onChanged: (val) {
              if (errorKey != null) {
                setState(() => _errors.remove(errorKey));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    String? errorKey,
  }) {
    final hasErr = errorKey != null && _errors.contains(errorKey);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
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
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () async {
              final initial =
                  DateTime.tryParse(controller.text) ?? DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: initial,
                firstDate: DateTime(1940),
                lastDate: DateTime(2035),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: seal,
                        onPrimary: Colors.white,
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
                  if (errorKey != null) _errors.remove(errorKey);
                });
              }
            },
            child: AbsorbPointer(
              child: TextField(
                controller: controller,
                style: const TextStyle(fontSize: 14.5, color: ink),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'YYYY-MM-DD',
                  hintStyle: const TextStyle(
                    color: Color(0xFFB3A98F),
                    fontSize: 14.5,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 2,
                  ),
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: muted,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: hasErr ? stamp : line,
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
    required ValueChanged<String?> onChanged,
    String? errorKey,
  }) {
    final hasErr = errorKey != null && _errors.contains(errorKey);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
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
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: (value != null && options.contains(value)) ? value : null,
            style: const TextStyle(fontSize: 14.5, color: ink),
            dropdownColor: paperAlt,
            icon: const Icon(Icons.arrow_drop_down, color: muted),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Select…',
              hintStyle: const TextStyle(
                color: Color(0xFFB3A98F),
                fontSize: 14.5,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 2,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: hasErr ? stamp : line,
                  width: 1.5,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: seal, width: 2),
              ),
            ),
            items: options
                .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                .toList(),
            onChanged: (v) {
              onChanged(v);
              if (errorKey != null) {
                setState(() => _errors.remove(errorKey));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextareaField({
    required String label,
    required TextEditingController controller,
    String? placeholder,
    String? errorKey,
  }) {
    final hasErr = errorKey != null && _errors.contains(errorKey);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
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
          TextField(
            controller: controller,
            maxLines: 3,
            style: const TextStyle(fontSize: 14.5, color: ink),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(
                color: Color(0xFFB3A98F),
                fontSize: 13.5,
              ),
              filled: true,
              fillColor: paperAlt,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: hasErr ? stamp : line,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: seal, width: 1.5),
              ),
            ),
            onChanged: (val) {
              if (errorKey != null) {
                setState(() => _errors.remove(errorKey));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRadioGroup({
    required String label,
    required List<dynamic> options,
    required String? value,
    required ValueChanged<String?> onChanged,
    String? errorKey,
  }) {
    final hasErr = errorKey != null && _errors.contains(errorKey);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: hasErr ? stamp : inkSoft,
            ),
          ),
          const SizedBox(height: 6),
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
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: active ? sealTint : paperAlt,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: active ? seal : line, width: 1.5),
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
                          style: const TextStyle(fontSize: 13.5, color: ink),
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

  Widget _buildCheckboxSingle({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
    String? errorKey,
  }) {
    final hasErr = errorKey != null && _errors.contains(errorKey);
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: paperAlt,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: hasErr ? stamp : line, width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.only(top: 2, right: 10),
              decoration: BoxDecoration(
                color: value ? seal : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: value ? seal : line, width: 2),
              ),
              child: value
                  ? const Center(
                      child: Icon(Icons.check, size: 12, color: Colors.white),
                    )
                  : null,
            ),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 13, color: ink, height: 1.4),
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
    required List<String> selectedList,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: paperAlt,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: line),
            ),
            child: Column(
              children: options.map((opt) {
                final active = selectedList.contains(opt);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (active) {
                        selectedList.remove(opt);
                      } else {
                        selectedList.add(opt);
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.only(top: 2, right: 10),
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
                                  child: Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                        Expanded(
                          child: Text(
                            opt,
                            style: const TextStyle(
                              fontSize: 13,
                              color: ink,
                              height: 1.4,
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
      ),
    );
  }
}

// --- SIGNATURE DRAWING BOTTOM SHEET ---
class _SignatureModal extends StatefulWidget {
  final String applicantName;
  final VoidCallback onSave;

  const _SignatureModal({required this.applicantName, required this.onSave});

  @override
  State<_SignatureModal> createState() => _SignatureModalState();
}

class _SignatureModalState extends State<_SignatureModal> {
  final List<List<Offset>> _strokes = [];
  List<Offset>? _current;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _FirstGoStayFormState.paperAlt,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      padding: EdgeInsets.fromLTRB(
        18,
        18,
        18,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
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
              color: _FirstGoStayFormState.ink,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Draw below or save with your full name.',
            style: TextStyle(fontSize: 12, color: _FirstGoStayFormState.muted),
          ),
          const SizedBox(height: 12),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _FirstGoStayFormState.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _FirstGoStayFormState.line, width: 1.5),
            ),
            child: GestureDetector(
              onPanStart: (d) {
                setState(() {
                  _current = [d.localPosition];
                  _strokes.add(_current!);
                });
              },
              onPanUpdate: (d) {
                setState(() {
                  _current?.add(d.localPosition);
                });
              },
              onPanEnd: (_) => _current = null,
              child: CustomPaint(
                painter: _SignaturePainter(_strokes),
                child: _strokes.isEmpty
                    ? Center(
                        child: Text(
                          widget.applicantName,
                          style: TextStyle(
                            fontSize: 28,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: _FirstGoStayFormState.seal.withValues(
                              alpha: 0.35,
                            ),
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
                    side: const BorderSide(
                      color: _FirstGoStayFormState.line,
                      width: 1.5,
                    ),
                    foregroundColor: _FirstGoStayFormState.inkSoft,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => setState(() => _strokes.clear()),
                  child: const Text(
                    'Clear',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _FirstGoStayFormState.seal,
                    foregroundColor: _FirstGoStayFormState.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    widget.onSave();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save Signature',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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

class _SignaturePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  _SignaturePainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _FirstGoStayFormState.sealDark
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      final path = Path();
      path.moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
