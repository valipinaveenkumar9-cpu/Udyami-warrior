import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/first_choice_bank_models.dart';
import '../widgets/application_status_view.dart';

class FirstChoiceBankForm extends StatefulWidget {
  final String? verticalId;
  final String? companyName;
  final Map<String, dynamic>? initialApplicationData;

  const FirstChoiceBankForm({
    super.key,
    this.verticalId,
    this.companyName,
    this.initialApplicationData,
  });

  @override
  State<FirstChoiceBankForm> createState() => _FirstChoiceBankFormState();
}

class _FirstChoiceBankFormState extends State<FirstChoiceBankForm> {
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
  final List<String> _services = []; // 'loans', 'goldsilver', 'piggy', 'fdrd'
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
    's8': {
      'title': 'Consent',
      'subtitle': 'Your promises, and your signature',
    },
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

  String _formatDateYMD(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String _formatDateDisplay(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }

  String _formatINR(int n) {
    final s = n.toString();
    if (s.length <= 3) return '₹$s';
    final last3 = s.substring(s.length - 3);
    final rest = s.substring(0, s.length - 3);
    final buffer = StringBuffer();
    for (int i = 0; i < rest.length; i++) {
      if (i > 0 && (rest.length - i) % 2 == 0) {
        buffer.write(',');
      }
      buffer.write(rest[i]);
    }
    return '₹${buffer.toString()},$last3';
  }

  void _cpToast(String message, [String type = 'info']) {
    _toastTimer?.cancel();
    setState(() {
      _toastMessage = message;
      _toastType = type;
    });
    _toastTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _toastMessage = null;
        });
      }
    });
  }

  List<String> _buildSequence() {
    final seq = ['s1', 's2', 's3', 's4', 's5', 's6'];
    final bt = _businessType == 'institutional' ? 'institutional' : 'individual';
    for (final svc in _services) {
      seq.add('q_${svc}_$bt');
    }
    seq.addAll(['s7', 's8', 's9']);
    return seq;
  }

  void _loadDemoApplicant() {
    final d = FirstChoiceBankDemoApplicantData.sample;
    setState(() {
      _udyamiMember = d['udyamiMember'];
      _memberIdController.text = d['memberId'] ?? '123123';
      _fullNameController.text = d['fullName'] ?? 'Manjunath Gowda';
      _dobController.text = d['dob'] ?? '1988-11-02';
      _gender = d['gender'] ?? 'Male';
      _fatherHusbandNameController.text =
          d['fatherHusbandName'] ?? 'Siddappa Gowda';
      _maritalStatus = d['maritalStatus'] ?? 'Married';
      _bloodGroupController.text = d['bloodGroup'] ?? 'O+';
      _nationalityController.text = d['nationality'] ?? 'Indian';
      _languagesController.text = d['languages'] ?? 'Kannada, English, Hindi';
      _mobileController.text = d['mobile'] ?? '9845098450';
      _altMobileController.text = d['altMobile'] ?? '';
      _emailController.text = d['email'] ?? 'manjunath.gowda@example.test';
      _occupationController.text =
          d['occupation'] ?? 'Cooperative society staff';

      _houseStreetVillageController.text =
          d['houseStreetVillage'] ?? '12, Temple Street, Malleshwaram';
      _talukController.text = d['taluk'] ?? 'Bengaluru North';
      _districtController.text = d['district'] ?? 'Bengaluru Urban';
      _stateNameController.text = d['stateName'] ?? 'Karnataka';
      _pinController.text = d['pin'] ?? '560003';
      _wardController.text = d['ward'] ?? 'Malleshwaram Ward';
      _yearsLivedHereController.text = d['yearsLivedHere'] ?? '11';
      _homeType = d['homeType'] ?? 'Own';
      _landmarkController.text = d['landmark'] ?? 'Near Malleshwaram Circle';

      _aadhaarNumberController.text = d['aadhaarNumber'] ?? '234567890123';
      _aadhaarMobileController.text = d['aadhaarMobile'] ?? '9845098450';
      _aadhaarNameController.text = d['aadhaarName'] ?? 'Manjunath Gowda';
      _aadhaarConsent = true;
      _aadhaarOtpSent = false;
      _aadhaarOtpVerified = true;

      _businessType = d['businessType'] ?? 'individual';
      _hasExperience = d['hasExperience'] ?? true;
      _whereWorkedController.text =
          d['whereWorked'] ?? 'Malleshwaram Cooperative Credit Society';
      _roleController.text = d['role'] ?? 'Savings Officer';
      _howLongController.text = d['howLong'] ?? '2016–2026';
      _whatYouDidController.text = d['whatYouDid'] ??
          'Managed member savings passbooks, set up recurring deposits and helped members apply for loan-against-FD facilities.';
      _yearsExperienceController.text = d['yearsExperience'] ?? '10';
      _highestQualificationController.text = d['highestQualification'] ?? 'B.Com';
      _toolsKnownController.text = d['toolsKnown'] ??
          'UPI Autopay, mutual fund portals, core banking software';
      _familiarityChecklist.clear();
      _familiarityChecklist
          .addAll(List<String>.from(d['familiarityChecklist'] ?? []));

      _workAddressController.text =
          d['workAddress'] ?? '12, Temple Street, Malleshwaram, Bengaluru';
      _ownership = d['ownership'] ?? 'Owned';
      _workLandmarkController.text =
          d['workLandmark'] ?? 'Malleshwaram Circle';
      _wardAreaServeController.text =
          d['wardAreaServe'] ?? 'Malleshwaram Ward';
      _villagesCoveredController.text = d['villagesCovered'] ??
          'Malleshwaram, Rajajinagar, Sadashivanagar';
      _workFacilities.clear();
      _workFacilities.addAll(List<String>.from(d['workFacilities'] ?? []));

      _accountHolderNameController.text =
          d['accountHolderName'] ?? 'Manjunath Gowda';
      _accountType = d['accountType'] ?? 'Savings';
      _accountNumberController.text =
          d['accountNumber'] ?? 'XXXXXX5590';
      _ifscController.text = d['ifsc'] ?? 'SBIN0009876';
      _bankBranchController.text = d['bankBranch'] ?? 'Malleshwaram Branch';

      _nomineeNameController.text = d['nomineeName'] ?? 'Lakshmi Gowda';
      _relationshipController.text = d['relationship'] ?? 'Spouse';
      _nomineeMobileController.text = d['nomineeMobile'] ?? '9845011223';
      _nomineeAccountNumberController.text =
          d['nomineeAccountNumber'] ?? 'XXXXXX3345';
      _nomineeIfscController.text = d['nomineeIfsc'] ?? 'SBIN0009876';
      _nomineeBankBranchController.text =
          d['nomineeBankBranch'] ?? 'Malleshwaram Branch';

      _services.clear();
      _services.addAll(['loans', 'piggy']);
      _wardAreaController.text = d['wardArea'] ?? 'Malleshwaram Ward';

      _newSaversPerMonthController.text = d['newSaversPerMonth'] ?? '15';
      _hireSupportStaff = d['hireSupportStaff'] ?? 'No';
      _bestTimeTraining = d['bestTimeTraining'] ?? 'Weekends';
      _smartphone = d['smartphone'] ?? 'Android';
      _comfortApps = d['comfortApps'] ?? 'Very Comfortable';
      _usedAppsForInvestments = d['usedAppsForInvestments'] ?? 'Yes, Regularly';
      _comfortPayments = d['comfortPayments'] ?? 'Very Comfortable';
      _langComm.clear();
      _langComm.addAll(List<String>.from(d['langComm'] ?? []));

      _c1 = true;
      _c2 = true;
      _c3 = true;
      _c4 = true;
      _c5 = true;
      _c6 = true;
      _c7 = true;
      _c8 = true;
      _c9 = true;
      _placeController.text = d['place'] ?? 'Bengaluru';
      _date8Controller.text = d['date8'] ?? '2026-08-31';

      _depositAck1 = true;
      _depositAck2 = true;
      _signed = true;
      _signedAt = DateTime.now();

      // Pre-fill questionnaire answers for Loans and Piggy demo
      for (int i = 1; i <= 20; i++) {
        _qa[i] =
            'Understanding of closed-loop vendor disbursal, KYC eligibility, and member credit documentation.';
      }
      for (int i = 81; i <= 100; i++) {
        _qa[i] =
            'Experienced in guiding daily micro-savers along the life-stage ladder with complete ledger transparency.';
      }

      _currentStepId = 's1';
      _appStage = 'form';
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
            fontFamily: 'serif',
            color: ink,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "This clears everything you've entered.",
          style: TextStyle(color: inkSoft, fontSize: 13.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: inkSoft)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: seal,
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
            },
            child: const Text('Start Over'),
          ),
        ],
      ),
    );
  }

  bool _validateStep(String id) {
    final missing = <String>{};
    if (id == 's1') {
      if (_udyamiMember == null || _udyamiMember!.isEmpty) {
        missing.add('udyamiMember');
      }
      if (_udyamiMember == 'Yes' &&
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
    } else if (id == 's2') {
      if (!_aadhaarOtpVerified) missing.add('aadhaarConsent');
    } else if (id == 's3') {
      if (_businessType.isEmpty) missing.add('businessType');
    } else if (id == 's5') {
      if (_accountHolderNameController.text.trim().isEmpty) {
        missing.add('accountHolderName');
      }
      if (_accountNumberController.text.trim().isEmpty) {
        missing.add('accountNumber');
      }
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
        setState(() {
          _errors.add('udyamiMember');
        });
        _cpToast(
          'Please select Yes or No for Udyami Bharat / FCMCSL membership.',
          'error',
        );
        return;
      }
      if (_udyamiMember == 'No') {
        setState(() {
          _errors.add('udyamiMember');
        });
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
      _validateStep('s2');
      _cpToast('Please verify the Aadhaar OTP before continuing.', 'error');
      return;
    }

    final valid = _validateStep(_currentStepId);
    if (!valid) {
      _cpToast(
        'Please complete the highlighted fields before continuing.',
        'error',
      );
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

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _openSignatureDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _SignatureModal(
        onSave: () {
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

  @override
  Widget build(BuildContext context) {
    if (_appStage == 'status') {
      return _buildStatusScreen();
    }
    return Scaffold(
      backgroundColor: const Color(0xFFD8D1BD),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 430),
            color: paper,
            child: Stack(
              children: [
                Column(
                  children: [
                    _buildTopbar(),
                    Expanded(
                      child: _currentStepId.startsWith('q_')
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
    );
  }

  Widget _buildToastWidget() {
    Color bg = ink;
    if (_toastType == 'success') bg = seal;
    if (_toastType == 'error') bg = stamp;

    return Positioned(
      left: 20,
      right: 20,
      bottom: 86,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            _toastMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopbar() {
    return Container(
      color: seal,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ONE CORE',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.5,
                  color: paperAlt,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Channel Partner Registration',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFCFE3DA),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: _resetApp,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: white.withValues(alpha: 0.35)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '↺ Restart',
                style: TextStyle(fontSize: 11, color: Color(0xFFEAF3ED)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String id) {
    int stepNum = 1;
    if (id.startsWith('s')) {
      stepNum = int.tryParse(id.substring(1)) ?? 1;
    } else {
      stepNum = 6;
    }
    final pct = (stepNum * 100 / 9).round().clamp(0, 100);

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
      child: Column(
        children: [
          Container(
            height: 5,
            decoration: BoxDecoration(
              color: line,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: pct,
                  child: Container(
                    decoration: BoxDecoration(
                      color: seal,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                Expanded(flex: 100 - pct, child: const SizedBox()),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'STEP $stepNum/9',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: sealDark,
                  letterSpacing: 0.4,
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
    );
  }

  Widget _buildStepHeading(String id) {
    final meta = _stepMeta[id] ?? {'title': '', 'subtitle': ''};
    return Container(
      width: double.infinity,
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
              fontWeight: FontWeight.bold,
              color: ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            meta['subtitle']!,
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter({
    required VoidCallback onBack,
    required VoidCallback onNext,
    bool backDisabled = false,
    String nextLabel = 'Continue',
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: paperAlt,
        border: Border(top: BorderSide(color: line)),
        boxShadow: [
          BoxShadow(
            color: Color(0x121E2A44),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            height: 46,
            child: OutlinedButton(
              onPressed: backDisabled ? null : onBack,
              style: OutlinedButton.styleFrom(
                foregroundColor: inkSoft,
                side: const BorderSide(color: line),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Back', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 46,
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: seal,
                  foregroundColor: white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  nextLabel,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== FORM SCREENS ====================

  Widget _buildFormStepScreen(String id) {
    return Column(
      children: [
        _buildProgressBar(id),
        _buildStepHeading(id),
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            children: [
              if (id == 's1') _buildDemoApplicantBanner(),
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
        _buildFooter(
          onBack: _goBack,
          onNext: id == 's9'
              ? () {
                  if (_validateStep('s9')) {
                    setState(() {
                      _appStage = 'status';
                      _statusStage = 'submitted';
                    });
                  }
                }
              : _goNext,
          backDisabled: id == 's1',
          nextLabel: id == 's9' ? 'Submit Application' : 'Continue',
        ),
      ],
    );
  }

  Widget _buildDemoApplicantBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: goldTint,
        border: Border.all(color: gold, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(9),
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
            onPressed: _loadDemoApplicant,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFF8E7),
              foregroundColor: const Color(0xFF5B4415),
              side: const BorderSide(color: gold),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            child: const Text(
              'Load Demo Applicant',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    if (_currentStepId == 's1' && _udyamiMember == 'No') {
      return Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: stampTint,
          border: Border.all(color: stamp),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'Membership required.\nYou must already be a Udyami Bharat / FCMCSL member to apply. Please register through One Core first.',
          style: TextStyle(color: stamp, fontSize: 12.5, fontWeight: FontWeight.w500),
        ),
      );
    }
    if (_errors.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: stampTint,
          border: Border.all(color: stamp),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'Please complete the highlighted fields before continuing.',
          style: TextStyle(color: stamp, fontSize: 12.5, fontWeight: FontWeight.w500),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  // ==================== STEP 1: ABOUT YOU ====================

  List<Widget> _buildStep1Fields() {
    return [
      _buildNote(
        "You must already be a Udyami Bharat / FCMCSL member to apply. If you're not yet a member, register through One Core first — the details below should match your One Core profile.",
      ),
      _buildRadioGroup(
        label: 'Are you already a Udyami Bharat / FCMCSL member?',
        required: true,
        keyName: 'udyamiMember',
        selectedValue: _udyamiMember,
        options: const [
          {'val': 'Yes', 'label': 'Yes'},
          {'val': 'No', 'label': 'No'},
        ],
        onChanged: (val) {
          setState(() {
            _udyamiMember = val;
            if (val == 'Yes' && _memberIdController.text.isEmpty) {
              _memberIdController.text = '123123';
            }
            _errors.remove('udyamiMember');
          });
        },
      ),
      if (_udyamiMember == 'Yes')
        _buildTextField(
          label: 'Member ID',
          required: true,
          keyName: 'memberId',
          controller: _memberIdController,
          hint: 'Enter your Member ID',
        ),
      _buildTextField(
        label: 'Full Name',
        required: true,
        keyName: 'fullName',
        controller: _fullNameController,
        help:
            'As on Aadhaar / PAN — for individual applicant or authorized representative',
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              options: const ['Male', 'Female', 'Other'],
              onChanged: (val) => setState(() => _gender = val),
            ),
          ),
        ],
      ),
      _buildTextField(
        label: "Father's / Husband's Name",
        controller: _fatherHusbandNameController,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildSelectField(
              label: 'Marital Status',
              value: _maritalStatus,
              options: const ['Single', 'Married', 'Other'],
              onChanged: (val) => setState(() => _maritalStatus = val),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              label: 'Blood Group',
              controller: _bloodGroupController,
              hint: 'e.g. B+',
            ),
          ),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildTextField(
              label: 'Nationality',
              controller: _nationalityController,
              hint: 'Indian',
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              label: 'Languages Spoken',
              controller: _languagesController,
              hint: 'Kannada, English',
            ),
          ),
        ],
      ),
      _buildTextField(
        label: 'Mobile Number',
        required: true,
        keyName: 'mobile',
        controller: _mobileController,
        help: "We'll send an OTP here",
        keyboardType: TextInputType.phone,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
        hint:
            'e.g. Insurance agent, Cooperative society staff, Savings group leader, Loan facilitator',
      ),
      _buildSectionLabel('Your Address'),
      _buildTextField(
        label: 'House No. / Street / Village-Town',
        required: true,
        keyName: 'houseStreetVillage',
        controller: _houseStreetVillageController,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildTextField(
              label: 'State',
              required: true,
              keyName: 'stateName',
              controller: _stateNameController,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              label: 'PIN Code',
              required: true,
              keyName: 'pin',
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
              options: const ['Own', 'Rented', 'Family'],
              onChanged: (val) => setState(() => _homeType = val),
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

  // ==================== STEP 2: VERIFY AADHAAR ====================

  List<Widget> _buildStep2Fields() {
    return [
      _buildNote(
        "We'll confirm your identity via a one-time Aadhaar OTP check, through a secure, government-approved partner. One Core never stores your Aadhaar number.",
      ),
      _buildTextField(
        label: 'Aadhaar Number',
        controller: _aadhaarNumberController,
        hint: 'XXXX XXXX XXXX',
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
      _buildAadhaarVerifyBlock(),
    ];
  }

  Widget _buildAadhaarVerifyBlock() {
    if (_aadhaarOtpVerified) {
      return Container(
        margin: const EdgeInsets.only(top: 8, bottom: 18),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: sealTint,
          border: Border.all(color: seal, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Text('✓ ', style: TextStyle(color: sealDark, fontWeight: FontWeight.bold, fontSize: 16)),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            margin: const EdgeInsets.only(top: 6, bottom: 10),
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
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(top: 2, right: 10),
                  decoration: BoxDecoration(
                    color: _aadhaarOtpSent ? seal : Colors.transparent,
                    border: Border.all(color: _aadhaarOtpSent ? seal : line, width: 2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: _aadhaarOtpSent
                      ? const Icon(Icons.check, size: 13, color: white)
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
                const Row(
                  children: [
                    Text(
                      'Enter OTP',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: inkSoft),
                    ),
                    Text('*', style: TextStyle(color: stamp, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: List.generate(4, (i) {
                          return Container(
                            width: 44,
                            height: 48,
                            margin: const EdgeInsets.only(right: 8),
                            child: TextField(
                              controller: _otpControllers[i],
                              focusNode: _otpFocusNodes[i],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                color: ink,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                contentPadding: EdgeInsets.zero,
                                filled: true,
                                fillColor: white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: line, width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: seal, width: 2),
                                ),
                              ),
                              onChanged: (val) {
                                if (val.isNotEmpty && i < 3) {
                                  _otpFocusNodes[i + 1].requestFocus();
                                }
                                final entered = _otpControllers.map((c) => c.text).join();
                                if (entered.length == 4) {
                                  _verifyOtp(entered);
                                }
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          final entered = _otpControllers.map((c) => c.text).join();
                          _verifyOtp(entered);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: seal,
                          foregroundColor: white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text('Verify', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Demo OTP: 1234',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontStyle: FontStyle.italic,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  void _verifyOtp(String otp) {
    if (otp == '1234') {
      setState(() {
        _aadhaarOtpVerified = true;
        _aadhaarOtpSent = false;
        _errors.remove('aadhaarConsent');
      });
      _cpToast('Aadhaar verified successfully', 'success');
    } else {
      setState(() {
        _aadhaarOtpVerified = false;
        _errors.add('aadhaarConsent');
      });
      _cpToast('Incorrect OTP. Use 1234 for the demo.', 'error');
    }
  }

  // ==================== STEP 3: BUSINESS & EXPERIENCE ====================

  List<Widget> _buildStep3Fields() {
    return [
      _buildSectionLabel('Your Business'),
      _buildRadioGroup(
        label: 'Business Type',
        required: true,
        keyName: 'businessType',
        selectedValue: _businessType,
        options: const [
          {'val': 'institutional', 'label': 'I run a registered business'},
          {'val': 'individual', 'label': 'Applying as an individual'},
        ],
        onChanged: (val) => setState(() {
          _businessType = val!;
          _errors.remove('businessType');
        }),
      ),
      if (_businessType == 'institutional') ...[
        _buildTextField(
          label: 'Business Name',
          controller: _businessNameController,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildSelectField(
                label: 'Type of Business',
                value: _typeOfBusiness,
                options: const [
                  'Proprietorship',
                  'Partnership',
                  'LLP',
                  'Pvt Ltd',
                ],
                onChanged: (val) => setState(() => _typeOfBusiness = val),
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
        onChanged: (val) => setState(() => _hasExperience = val),
      ),
      if (_hasExperience) ...[
        _buildTextField(
          label: 'Where You Worked',
          controller: _whereWorkedController,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
        _buildTextArea(
          label: 'What You Did',
          controller: _whatYouDidController,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
        selectedValues: _familiarityChecklist,
        options: const [
          'I know my way around KYC / AML basics',
          "I'm familiar with SIP / mutual-fund style savings plans",
          "I've explained investment products to clients before",
        ],
        onChanged: (item, selected) {
          setState(() {
            if (selected) {
              _familiarityChecklist.add(item);
            } else {
              _familiarityChecklist.remove(item);
            }
          });
        },
      ),
      _buildSectionLabel('Any Other Work Experience'),
      _buildTextField(
        label: 'Field / Sector',
        controller: _fieldSectorController,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
      _buildTextArea(
        label: 'What You Did',
        controller: _otherWhatYouDidController,
      ),
    ];
  }

  // ==================== STEP 4: WORK LOCATION ====================

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildSelectField(
              label: 'Ownership',
              value: _ownership,
              options: const ['Owned', 'Rented', 'Leased'],
              onChanged: (val) => setState(() => _ownership = val),
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
        selectedValues: _workFacilities,
        options: const [
          'Private area for clients to discuss their investments',
          'Secure, lockable place to store paperwork',
          'CCTV or other document security',
          'Internet access to log leads and savers',
          'Computer, scanner and printer on site',
          'Familiar with One Core KYC / onboarding process',
        ],
        onChanged: (item, selected) {
          setState(() {
            if (selected) {
              _workFacilities.add(item);
            } else {
              _workFacilities.remove(item);
            }
          });
        },
      ),
    ];
  }

  // ==================== STEP 5: BANK DETAILS ====================

  List<Widget> _buildStep5Fields() {
    return [
      _buildTextField(
        label: 'Account Holder Name',
        required: true,
        keyName: 'accountHolderName',
        controller: _accountHolderNameController,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildSelectField(
              label: 'Account Type',
              value: _accountType,
              options: const ['Savings', 'Current'],
              onChanged: (val) => setState(() => _accountType = val ?? 'Savings'),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildTextField(
              label: 'Account Number',
              required: true,
              keyName: 'accountNumber',
              controller: _accountNumberController,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildTextField(
              label: 'IFSC Code',
              required: true,
              keyName: 'ifsc',
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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFBF6E9),
          border: Border.all(color: gold, width: 1.5, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🛡 Alternate / Nominee Details',
              style: TextStyle(
                fontFamily: 'serif',
                fontWeight: FontWeight.bold,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Relationship to You',
                    controller: _relationshipController,
                    hint: 'e.g. Spouse, Son',
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
              crossAxisAlignment: CrossAxisAlignment.start,
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

  // ==================== STEP 6: SERVICES SELECTION ====================

  List<Widget> _buildStep6Fields() {
    return [
      _buildNote(
        'Choose one, or several — commission and deposit terms are the same across all four modules: 4% commission, ₹5,00,000 security deposit per module.',
      ),
      _buildServicesPicker(),
      _buildTextField(
        label: "Ward / Area You'd Like to Serve",
        required: true,
        keyName: 'wardArea',
        controller: _wardAreaController,
      ),
      _buildNote(
        "If your ward is full, you'll be waitlisted or offered a nearby open ward. You'll answer 20 verification questions for each module you select, based on whether you're applying as an individual or a registered business.",
      ),
    ];
  }

  Widget _buildServicesPicker() {
    final hasErr = _errors.contains('services');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Modules',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: inkSoft,
              ),
            ),
            Text('*', style: TextStyle(color: stamp, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ...FirstChoiceBankServiceCards.all.map((card) {
          final isSelected = _services.contains(card.id);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
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
                color: isSelected ? sealTint : paperAlt,
                border: Border.all(
                  color: isSelected
                      ? seal
                      : (hasErr ? stamp : line),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10),
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
                        color: isSelected ? seal : Colors.transparent,
                        border: Border.all(color: isSelected ? seal : line, width: 1.5),
                      ),
                      child: isSelected
                          ? const Center(
                              child: Text(
                                '✓',
                                style: TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            )
                          : null,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(card.icon, style: const TextStyle(fontSize: 22)),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(right: 28),
                        child: Text(
                          card.name,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontWeight: FontWeight.bold,
                            fontSize: 15.5,
                            color: ink,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        card.desc,
                        style: const TextStyle(fontSize: 12, color: muted, height: 1.45),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: goldTint,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          card.badge,
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
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ==================== DYNAMIC QUESTIONNAIRE SCREEN ====================

  Widget _buildQuestionnaireScreen(String qid) {
    final data = FirstChoiceBankQuestionnaires.all[qid];
    if (data == null) {
      return Center(child: Text('Unknown questionnaire: $qid'));
    }

    final catIdx = _qCat[qid] ?? 0;
    final cat = data.categories[catIdx];
    final isLastSection = catIdx == data.categories.length - 1;

    return Column(
      children: [
        // Questionnaire Header
        Container(
          width: double.infinity,
          color: goldTint,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'VERIFICATION QUESTIONNAIRE · INSERTED AFTER STEP 6',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
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
              const SizedBox(height: 10),
              Row(
                children: List.generate(data.categories.length, (i) {
                  final isActive = i == catIdx;
                  final isDone = i < catIdx;
                  return Container(
                    width: isActive ? 20 : 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? seal
                          : (isDone ? gold : line),
                      borderRadius: BorderRadius.circular(isActive ? 5 : 4),
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
        // Questions content
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(18),
            itemCount: cat.questions.length,
            itemBuilder: (ctx, i) {
              final qNum = cat.startNum + i;
              final qText = cat.questions[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
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
                      maxLines: 3,
                      controller: TextEditingController(text: _qa[qNum] ?? '')
                        ..selection = TextSelection.collapsed(
                          offset: (_qa[qNum] ?? '').length,
                        ),
                      onChanged: (val) {
                        _qa[qNum] = val;
                      },
                      style: const TextStyle(fontSize: 13.5, color: ink),
                      decoration: InputDecoration(
                        hintText: 'Type your answer…',
                        hintStyle: const TextStyle(color: Color(0xFFB3A98F), fontSize: 13),
                        filled: true,
                        fillColor: paperAlt,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: line, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: seal, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Footer navigation
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
          onNext: () {
            if (!isLastSection) {
              setState(() {
                _qCat[qid] = catIdx + 1;
              });
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
          nextLabel: isLastSection ? 'Continue' : 'Next Section',
        ),
      ],
    );
  }

  // ==================== STEP 7: AVAILABILITY & COMFORT ====================

  List<Widget> _buildStep7Fields() {
    return [
      _buildTextField(
        label: 'New Savers / Investors You Expect to Onboard Per Month',
        controller: _newSaversPerMonthController,
        keyboardType: TextInputType.number,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildSelectField(
              label: 'Hire Support Staff?',
              value: _hireSupportStaff,
              options: const ['Yes', 'No'],
              onChanged: (val) => setState(() => _hireSupportStaff = val),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildSelectField(
              label: 'Best Time for Training',
              value: _bestTimeTraining,
              options: const ['Weekdays', 'Weekends', 'Both', 'Flexible'],
              onChanged: (val) => setState(() => _bestTimeTraining = val),
            ),
          ),
        ],
      ),
      _buildSectionLabel('Smartphone & App Experience'),
      _buildRadioGroup(
        label: 'Which Smartphone Do You Use?',
        selectedValue: _smartphone,
        options: const [
          {'val': 'Android', 'label': 'Android'},
          {'val': 'iPhone (iOS)', 'label': 'iPhone (iOS)'},
          {'val': 'Both', 'label': 'Both'},
        ],
        onChanged: (val) => setState(() => _smartphone = val),
      ),
      _buildRadioGroup(
        label: 'Comfort Using Smartphone Apps?',
        selectedValue: _comfortApps,
        options: const [
          {'val': 'Very Comfortable', 'label': 'Very Comfortable'},
          {'val': 'Comfortable', 'label': 'Comfortable'},
          {'val': 'Need Training', 'label': 'Need Training'},
          {'val': 'Not Comfortable', 'label': 'Not Comfortable'},
        ],
        onChanged: (val) => setState(() => _comfortApps = val),
      ),
      _buildRadioGroup(
        label: 'Used Apps for Investments / Online Forms?',
        selectedValue: _usedAppsForInvestments,
        options: const [
          {'val': 'Yes, Regularly', 'label': 'Yes, Regularly'},
          {'val': 'Yes, Sometimes', 'label': 'Yes, Sometimes'},
          {'val': 'No', 'label': 'No'},
        ],
        onChanged: (val) => setState(() => _usedAppsForInvestments = val),
      ),
      _buildRadioGroup(
        label: 'Comfort With UPI Autopay, OTP & Digital Payments?',
        selectedValue: _comfortPayments,
        options: const [
          {'val': 'Very Comfortable', 'label': 'Very Comfortable'},
          {'val': 'Comfortable', 'label': 'Comfortable'},
          {'val': 'Need Guidance', 'label': 'Need Guidance'},
          {'val': 'Need Full Training', 'label': 'Need Full Training'},
        ],
        onChanged: (val) => setState(() => _comfortPayments = val),
      ),
      _buildSectionLabel('Language & Client Communication'),
      _buildCheckboxGroup(
        label: 'Language & App Comfort',
        selectedValues: _langComm,
        options: const [
          "I'm comfortable using the Partner app already",
          "I'll need a bit of training first",
          'I can talk to clients in Kannada',
          'I can talk to clients in English',
        ],
        onChanged: (item, selected) {
          setState(() {
            if (selected) {
              _langComm.add(item);
            } else {
              _langComm.remove(item);
            }
          });
        },
      ),
    ];
  }

  // ==================== STEP 8: CONSENT ====================

  List<Widget> _buildStep8Fields() {
    return [
      _buildCheckboxSingle(
        label: 'I agree to the Aadhaar identity check described in Step 2.',
        required: true,
        keyName: 'c1',
        value: _c1,
        onChanged: (val) => setState(() {
          _c1 = val;
          _errors.remove('c1');
        }),
      ),
      _buildCheckboxSingle(
        label: 'I understand my account stays inactive until I finish training.',
        required: true,
        keyName: 'c2',
        value: _c2,
        onChanged: (val) => setState(() {
          _c2 = val;
          _errors.remove('c2');
        }),
      ),
      _buildCheckboxSingle(
        label:
            "I'll keep every client's personal and financial information safe, secure and private.",
        required: true,
        keyName: 'c3',
        value: _c3,
        onChanged: (val) => setState(() {
          _c3 = val;
          _errors.remove('c3');
        }),
      ),
      _buildCheckboxSingle(
        label:
            "I don't have any conflict of interest that would get in the way of this role.",
        required: true,
        keyName: 'c4',
        value: _c4,
        onChanged: (val) => setState(() {
          _c4 = val;
          _errors.remove('c4');
        }),
      ),
      _buildCheckboxSingle(
        label:
            'I understand returns are projections, not guarantees, and I will never promise assured returns to a member.',
        required: true,
        keyName: 'c5',
        value: _c5,
        onChanged: (val) => setState(() {
          _c5 = val;
          _errors.remove('c5');
        }),
      ),
      _buildCheckboxSingle(
        label:
            'I understand One Core holds no member money directly — all contributions post through One Core.',
        required: true,
        keyName: 'c6',
        value: _c6,
        onChanged: (val) => setState(() {
          _c6 = val;
          _errors.remove('c6');
        }),
      ),
      _buildCheckboxSingle(
        label: "I've read the One Core Code of Conduct and I'll follow it.",
        required: true,
        keyName: 'c7',
        value: _c7,
        onChanged: (val) => setState(() {
          _c7 = val;
          _errors.remove('c7');
        }),
      ),
      _buildCheckboxSingle(
        label: "Everything I've written in this form is true.",
        required: true,
        keyName: 'c8',
        value: _c8,
        onChanged: (val) => setState(() {
          _c8 = val;
          _errors.remove('c8');
        }),
      ),
      _buildCheckboxSingle(
        label:
            "I've read the plain-language summary and full agreement, and I agree to it.",
        required: true,
        keyName: 'c9',
        value: _c9,
        onChanged: (val) => setState(() {
          _c9 = val;
          _errors.remove('c9');
        }),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildTextField(
              label: 'Place',
              required: true,
              keyName: 'place',
              controller: _placeController,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildDateField(
              label: 'Date',
              required: true,
              keyName: 'date8',
              controller: _date8Controller,
            ),
          ),
        ],
      ),
      // Signature Pad and Thumb Impression
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Signature', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: inkSoft)),
                const SizedBox(height: 2),
                const Text('Tap to Sign', style: TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic, color: muted)),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _openSignatureDialog,
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: _signed ? sealTint : paperAlt,
                      border: Border.all(
                        color: _errors.contains('signed')
                            ? stamp
                            : (_signed ? seal : line),
                        width: 1.5,
                        style: _signed ? BorderStyle.solid : BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
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
                                    fontStyle: FontStyle.italic,
                                    fontSize: 18,
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
                const Text(' ', style: TextStyle(fontSize: 11.5)),
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
                      border: Border.all(
                        color: _thumbImpression ? seal : line,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        _thumbImpression ? '👍 Captured' : 'Tap to capture',
                        style: TextStyle(
                          fontSize: 12,
                          color: _thumbImpression ? sealDark : muted,
                          fontWeight: _thumbImpression ? FontWeight.w600 : FontWeight.normal,
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
      const SizedBox(height: 16),
    ];
  }

  // ==================== STEP 9: REVIEW ====================

  List<Widget> _buildStep9Fields() {
    return [
      _buildNote(
        "Here's what you've entered. Go back to any earlier step to make changes before submitting.",
      ),
      _buildReviewSummary(),
      _buildSectionLabel(
        'Security Deposit',
        subtitle: '(shown after Ward Head acceptance & onboarding meeting)',
      ),
      _buildDepositTable(),
      _buildCheckboxSingle(
        label: "I'll only pay this after approval — within 7 days.",
        required: true,
        keyName: 'depositAck1',
        value: _depositAck1,
        onChanged: (val) => setState(() {
          _depositAck1 = val;
          _errors.remove('depositAck1');
        }),
      ),
      _buildCheckboxSingle(
        label:
            "I'll get this back within 30 days if I leave or resign — or I can leave it deposited.",
        required: true,
        keyName: 'depositAck2',
        value: _depositAck2,
        onChanged: (val) => setState(() {
          _depositAck2 = val;
          _errors.remove('depositAck2');
        }),
      ),
      _buildNote(
        "You'll receive a 4% commission on the facilitation fee value for the following 12 months, per module you're onboarded in. Every commission payment goes through One Core — never cash. Returns shown to members are projections, never guarantees.",
      ),
    ];
  }

  Widget _buildReviewSummary() {
    final blocks = <Widget>[];

    void addReviewBlock(String id, String title, List<Map<String, String>> rows) {
      if (rows.isEmpty) return;
      blocks.add(
        Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: paperAlt,
            border: Border.all(color: line),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: sealDark,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentStepId = id;
                          _appStage = 'form';
                          _errors.clear();
                        });
                        _scrollToTop();
                      },
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          color: stamp,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...rows.map((r) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: line, width: 0.8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Text(
                          r['label']!,
                          style: const TextStyle(fontSize: 12, color: muted),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        flex: 6,
                        child: Text(
                          r['val']!,
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
        ),
      );
    }

    // s1
    final s1Rows = <Map<String, String>>[];
    if (_udyamiMember != null) {
      s1Rows.add({'label': 'Member?', 'val': _udyamiMember!});
    }
    if (_memberIdController.text.isNotEmpty) {
      s1Rows.add({'label': 'Member ID', 'val': _memberIdController.text});
    }
    if (_fullNameController.text.isNotEmpty) {
      s1Rows.add({'label': 'Full Name', 'val': _fullNameController.text});
    }
    if (_mobileController.text.isNotEmpty) {
      s1Rows.add({'label': 'Mobile', 'val': _mobileController.text});
    }
    if (_houseStreetVillageController.text.isNotEmpty) {
      s1Rows.add({
        'label': 'Address',
        'val':
            '${_houseStreetVillageController.text}, ${_talukController.text}, ${_districtController.text}, ${_stateNameController.text} - ${_pinController.text}',
      });
    }
    addReviewBlock('s1', 'About You', s1Rows);

    // s2
    final s2Rows = <Map<String, String>>[];
    if (_aadhaarNumberController.text.isNotEmpty) {
      s2Rows.add({'label': 'Aadhaar Number', 'val': _aadhaarNumberController.text});
    }
    s2Rows.add({'label': 'Aadhaar Status', 'val': _aadhaarOtpVerified ? 'Verified' : 'Unverified'});
    addReviewBlock('s2', 'Verify Your Aadhaar', s2Rows);

    // s3
    final s3Rows = <Map<String, String>>[];
    s3Rows.add({'label': 'Business Type', 'val': _businessType});
    if (_businessType == 'institutional' && _businessNameController.text.isNotEmpty) {
      s3Rows.add({'label': 'Business Name', 'val': _businessNameController.text});
    }
    s3Rows.add({'label': 'Has Experience', 'val': _hasExperience ? 'Yes' : 'No'});
    if (_hasExperience && _whereWorkedController.text.isNotEmpty) {
      s3Rows.add({'label': 'Worked At', 'val': _whereWorkedController.text});
    }
    addReviewBlock('s3', 'Business & Experience', s3Rows);

    // s4
    final s4Rows = <Map<String, String>>[];
    if (_workAddressController.text.isNotEmpty) {
      s4Rows.add({'label': 'Work Address', 'val': _workAddressController.text});
    }
    if (_ownership != null) {
      s4Rows.add({'label': 'Ownership', 'val': _ownership!});
    }
    if (_wardAreaServeController.text.isNotEmpty) {
      s4Rows.add({'label': 'Ward Served', 'val': _wardAreaServeController.text});
    }
    addReviewBlock('s4', "Where You'll Work From", s4Rows);

    // s5
    final s5Rows = <Map<String, String>>[];
    if (_accountHolderNameController.text.isNotEmpty) {
      s5Rows.add({'label': 'Account Holder', 'val': _accountHolderNameController.text});
      s5Rows.add({'label': 'Account Number', 'val': _accountNumberController.text});
      s5Rows.add({'label': 'IFSC', 'val': _ifscController.text});
    }
    if (_nomineeNameController.text.isNotEmpty) {
      s5Rows.add({'label': 'Nominee', 'val': _nomineeNameController.text});
    }
    addReviewBlock('s5', 'Your Bank Details', s5Rows);

    // s6
    final s6Rows = <Map<String, String>>[];
    if (_services.isNotEmpty) {
      final names = _services.map((id) {
        final card = FirstChoiceBankServiceCards.all.firstWhere(
          (c) => c.id == id,
          orElse: () => FirstChoiceBankServiceCard(id: id, icon: '', name: id, desc: ''),
        );
        return card.name;
      }).join(', ');
      s6Rows.add({'label': 'Modules', 'val': names});
    }
    if (_wardAreaController.text.isNotEmpty) {
      s6Rows.add({'label': 'Preferred Ward', 'val': _wardAreaController.text});
    }
    addReviewBlock('s6', "What You'd Like to Do", s6Rows);

    // s7
    final s7Rows = <Map<String, String>>[];
    if (_newSaversPerMonthController.text.isNotEmpty) {
      s7Rows.add({'label': 'Expected Savers/Mo', 'val': _newSaversPerMonthController.text});
    }
    if (_smartphone != null) {
      s7Rows.add({'label': 'Smartphone', 'val': _smartphone!});
    }
    addReviewBlock('s7', 'Availability & Comfort', s7Rows);

    // s8
    final s8Rows = <Map<String, String>>[];
    s8Rows.add({'label': 'Consents Accepted', 'val': '9 of 9'});
    if (_placeController.text.isNotEmpty) {
      s8Rows.add({'label': 'Place', 'val': _placeController.text});
    }
    s8Rows.add({'label': 'Signature', 'val': _signed ? 'Signed' : 'Not signed'});
    if (_thumbImpression) {
      s8Rows.add({'label': 'Thumb Impression', 'val': 'Captured'});
    }
    addReviewBlock('s8', 'Consent', s8Rows);

    // Questionnaires Review Blocks
    final bt = _businessType == 'institutional' ? 'institutional' : 'individual';
    for (final svc in _services) {
      final qid = 'q_${svc}_$bt';
      final qData = FirstChoiceBankQuestionnaires.all[qid];
      if (qData == null) continue;

      final qRows = <Widget>[];
      for (final cat in qData.categories) {
        qRows.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            color: paper,
            child: Text(
              cat.name,
              style: const TextStyle(
                fontFamily: 'serif',
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: sealDark,
              ),
            ),
          ),
        );
        for (int i = 0; i < cat.questions.length; i++) {
          final n = cat.startNum + i;
          final ans = _qa[n]?.trim() ?? '';
          if (ans.isNotEmpty) {
            qRows.add(
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: line, width: 0.8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$n. ${cat.questions[i]}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: inkSoft,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ans,
                      style: const TextStyle(fontSize: 12, color: ink, height: 1.4),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      }

      if (qRows.isNotEmpty) {
        blocks.add(
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: paperAlt,
              border: Border.all(color: line),
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: const Color(0xFFEDE6D2),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        qData.title,
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
                            _appStage = 'form';
                            _errors.clear();
                          });
                          _scrollToTop();
                        },
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                            color: stamp,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ...qRows,
              ],
            ),
          ),
        );
      }
    }

    return Column(children: blocks);
  }

  Widget _buildDepositTable() {
    final totalDeposit = _services.length * FirstChoiceBankServiceCards.depositPerModule;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6, bottom: 14),
          decoration: BoxDecoration(
            border: Border.all(color: line),
            borderRadius: BorderRadius.circular(6),
            color: paperAlt,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: ink, width: 1.5)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('MODULE', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: muted)),
                    Text('NOTE', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: muted)),
                  ],
                ),
              ),
              _buildTableRow('Any one module selected', 'Board confirmed'),
              _buildTableRow('Each additional module', 'Cumulative, per module'),
              _buildTableRow('All 4 modules', 'Board confirmed'),
            ],
          ),
        ),
        if (_services.isNotEmpty) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              border: Border.all(color: line),
              borderRadius: BorderRadius.circular(6),
              color: paperAlt,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: ink, width: 1.5)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('YOUR SELECTION', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: muted)),
                      Text('AMOUNT', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: muted)),
                    ],
                  ),
                ),
                ..._services.map((id) {
                  final card = FirstChoiceBankServiceCards.all.firstWhere(
                    (c) => c.id == id,
                    orElse: () => FirstChoiceBankServiceCard(id: id, icon: '', name: id, desc: ''),
                  );
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: line, width: 0.8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(card.name, style: const TextStyle(fontSize: 12.5, color: ink)),
                        Text(
                          _formatINR(FirstChoiceBankServiceCards.depositPerModule),
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: gold,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: line, width: 1.5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Security Deposit',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ink),
                      ),
                      Text(
                        _formatINR(totalDeposit),
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: gold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ] else
          _buildNote('Select at least one module in Step 6 to see your deposit total here.'),
      ],
    );
  }

  Widget _buildTableRow(String left, String right) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: line, width: 0.8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: const TextStyle(fontSize: 12.5, color: ink)),
          Text(right, style: const TextStyle(fontSize: 12.5, color: muted, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  // ==================== STATUS SCREEN ====================

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
      theme: CompanyStatusTheme.firstChoiceBank(),
      initialStageIndex: _mapStatusToStageIndex(_statusStage),
      applicantName: _fullNameController.text.trim().isNotEmpty ? _fullNameController.text.trim() : 'Rajesh Shenoy',
      applicationId: '#FCB-${DateTime.now().year}-6602',
      wardLocality: _wardAreaController.text.trim().isNotEmpty ? _wardAreaController.text.trim() : 'Ward 15, Indiranagar',
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

  Widget _buildMeetingRow(String label, String val, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12.5, color: muted)),
          Text(val, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: ink)),
        ],
      ),
    );
  }

  Widget _buildTimeline({required List<String> steps, required int activeIdx}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isDone = i < activeIdx;
          final isCurrent = i == activeIdx;
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
                        color: isDone ? seal : white,
                        border: Border.all(
                          color: isDone || isCurrent ? seal : line,
                          width: 2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: i == steps.length - 1
                            ? Colors.transparent
                            : (i < activeIdx - 1 ? seal : line),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  steps[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isDone || isCurrent ? FontWeight.w600 : FontWeight.normal,
                    color: isDone || isCurrent ? sealDark : muted,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDemoControls() {
    final all = [
      {'id': 'submitted', 'label': 'Submitted'},
      {'id': 'meeting', 'label': 'Meeting Scheduled'},
      {'id': 'rejected', 'label': 'Rejected'},
      {'id': 'notselected', 'label': 'Not Selected'},
      {'id': 'payment', 'label': 'Payment'},
      {'id': 'onboarded', 'label': 'Onboarded'},
    ].where((x) => x['id'] != _statusStage).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: paperAlt,
        border: Border(top: BorderSide(color: line, style: BorderStyle.solid)),
      ),
      child: Column(
        children: [
          const Text(
            'DEMO · PREVIEW OTHER OUTCOMES',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 0.8,
              fontWeight: FontWeight.bold,
              color: muted,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              ...all.map((item) {
                return OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _statusStage = item['id']!;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: paperAlt,
                    foregroundColor: inkSoft,
                    side: const BorderSide(color: line),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(item['label']!, style: const TextStyle(fontSize: 11)),
                );
              }),
              OutlinedButton(
                onPressed: _resetApp,
                style: OutlinedButton.styleFrom(
                  backgroundColor: paperAlt,
                  foregroundColor: inkSoft,
                  side: const BorderSide(color: line),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('↺ Start Over', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== FORM FIELD BUILDERS ====================

  Widget _buildNote(String text, {bool goldBorder = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: goldBorder ? paperAlt : goldTint,
        border: Border(
          left: BorderSide(
            color: goldBorder ? gold : gold,
            width: 3,
          ),
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.5,
          color: goldBorder ? muted : const Color(0xFF5B4415),
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label, {String? subtitle}) {
    return Container(
      margin: const EdgeInsets.only(top: 22, bottom: 10),
      padding: const EdgeInsets.only(bottom: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: line)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'serif',
              fontWeight: FontWeight.w600,
              fontSize: 14.5,
              color: sealDark,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: muted,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    String? help,
    bool required = false,
    String? keyName,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final hasErr = keyName != null && _errors.contains(keyName);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: inkSoft,
                  letterSpacing: 0.2,
                ),
              ),
              if (required)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: stamp,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          if (help != null) ...[
            const SizedBox(height: 2),
            Text(
              help,
              style: const TextStyle(
                fontSize: 11.5,
                fontStyle: FontStyle.italic,
                color: muted,
              ),
            ),
          ],
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14.5, color: ink),
            onChanged: (val) {
              if (keyName != null && _errors.contains(keyName)) {
                setState(() => _errors.remove(keyName));
              }
            },
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFFB3A98F), fontSize: 14.5),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: hasErr ? stamp : line,
                  width: 1.5,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: seal, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextArea({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool required = false,
    String? keyName,
  }) {
    final hasErr = keyName != null && _errors.contains(keyName);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: inkSoft,
                ),
              ),
              if (required)
                const Text(
                  ' *',
                  style: TextStyle(color: stamp, fontWeight: FontWeight.bold),
                ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: 3,
            style: const TextStyle(fontSize: 14, color: ink),
            onChanged: (val) {
              if (keyName != null && _errors.contains(keyName)) {
                setState(() => _errors.remove(keyName));
              }
            },
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFFB3A98F), fontSize: 13.5),
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
                borderSide: const BorderSide(color: seal, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    bool required = false,
    String? keyName,
  }) {
    final hasErr = keyName != null && _errors.contains(keyName);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: inkSoft,
                ),
              ),
              if (required)
                const Text(
                  ' *',
                  style: TextStyle(color: stamp, fontWeight: FontWeight.bold),
                ),
            ],
          ),
          const SizedBox(height: 4),
          InkWell(
            onTap: () async {
              DateTime initialDate = DateTime.now();
              if (controller.text.isNotEmpty) {
                try {
                  initialDate = DateTime.parse(controller.text);
                } catch (_) {}
              }
              final picked = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(1930),
                lastDate: DateTime(2040),
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
                  if (keyName != null) _errors.remove(keyName);
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: hasErr ? stamp : line,
                    width: 1.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.text.isNotEmpty ? controller.text : 'Select Date…',
                    style: TextStyle(
                      fontSize: 14,
                      color: controller.text.isNotEmpty ? ink : const Color(0xFFB3A98F),
                    ),
                  ),
                  const Icon(Icons.calendar_today, size: 16, color: muted),
                ],
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
    bool required = false,
    String? keyName,
  }) {
    final hasErr = keyName != null && _errors.contains(keyName);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: inkSoft,
                ),
              ),
              if (required)
                const Text(
                  ' *',
                  style: TextStyle(color: stamp, fontWeight: FontWeight.bold),
                ),
            ],
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            key: ValueKey(value),
            initialValue: (value != null && options.contains(value)) ? value : null,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: hasErr ? stamp : line,
                  width: 1.5,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: seal, width: 1.5),
              ),
            ),
            dropdownColor: paperAlt,
            hint: const Text('Select…', style: TextStyle(color: Color(0xFFB3A98F), fontSize: 14)),
            icon: const Icon(Icons.arrow_drop_down, color: muted),
            items: options.map((opt) {
              return DropdownMenuItem<String>(
                value: opt,
                child: Text(opt, style: const TextStyle(fontSize: 14, color: ink)),
              );
            }).toList(),
            onChanged: (val) {
              onChanged(val);
              if (keyName != null && _errors.contains(keyName)) {
                setState(() => _errors.remove(keyName));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRadioGroup({
    required String label,
    required String? selectedValue,
    required List<Map<String, String>> options,
    required ValueChanged<String?> onChanged,
    bool required = false,
    String? keyName,
  }) {
    final hasErr = keyName != null && _errors.contains(keyName);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: inkSoft,
                ),
              ),
              if (required)
                const Text(
                  ' *',
                  style: TextStyle(color: stamp, fontWeight: FontWeight.bold),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            children: options.map((opt) {
              final isSelected = selectedValue == opt['val'];
              return GestureDetector(
                onTap: () => onChanged(opt['val']),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? sealTint : paperAlt,
                    border: Border.all(
                      color: hasErr ? stamp : (isSelected ? seal : line),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 17,
                        height: 17,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? seal : line,
                            width: 2,
                          ),
                        ),
                        child: isSelected
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
                          opt['label']!,
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
    required ValueChanged<bool> onChanged,
    bool required = false,
    String? keyName,
  }) {
    final hasErr = keyName != null && _errors.contains(keyName);

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: paperAlt,
          border: Border.all(
            color: hasErr ? stamp : line,
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
                color: value ? seal : Colors.transparent,
                border: Border.all(color: value ? seal : line, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: value
                  ? const Icon(Icons.check, size: 12, color: white)
                  : null,
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(fontSize: 13, color: ink, height: 1.4),
                    ),
                  ),
                  if (required)
                    const Text(
                      ' *',
                      style: TextStyle(color: stamp, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxGroup({
    required String label,
    required Set<String> selectedValues,
    required List<String> options,
    required void Function(String item, bool selected) onChanged,
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
              border: Border.all(color: line),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: options.map((opt) {
                final isSelected = selectedValues.contains(opt);
                return GestureDetector(
                  onTap: () => onChanged(opt, !isSelected),
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
                            color: isSelected ? seal : Colors.transparent,
                            border: Border.all(color: isSelected ? seal : line, width: 2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, size: 12, color: white)
                              : null,
                        ),
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
          ),
        ],
      ),
    );
  }
}

// ==================== SIGNATURE MODAL BOTTOM SHEET ====================

class _SignatureModal extends StatefulWidget {
  final VoidCallback onSave;

  const _SignatureModal({required this.onSave});

  @override
  State<_SignatureModal> createState() => _SignatureModalState();
}

class _SignatureModalState extends State<_SignatureModal> {
  final List<List<Offset>> _strokes = [];
  List<Offset>? _currentStroke;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 18,
        right: 18,
        top: 18,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: _FirstChoiceBankFormState.paperAlt,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 50,
            offset: Offset(0, -18),
          ),
        ],
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
              color: _FirstChoiceBankFormState.ink,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Draw below or use the demo signature for user testing.',
            style: TextStyle(fontSize: 12, color: _FirstChoiceBankFormState.muted),
          ),
          const SizedBox(height: 12),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: _FirstChoiceBankFormState.white,
              border: Border.all(color: _FirstChoiceBankFormState.line, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    _currentStroke = [details.localPosition];
                    _strokes.add(_currentStroke!);
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    _currentStroke?.add(details.localPosition);
                  });
                },
                onPanEnd: (details) {
                  _currentStroke = null;
                },
                child: CustomPaint(
                  painter: _SignaturePainter(_strokes),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _strokes.clear();
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _FirstChoiceBankFormState.inkSoft,
                      side: const BorderSide(color: _FirstChoiceBankFormState.line),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Clear', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onSave();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _FirstChoiceBankFormState.seal,
                      foregroundColor: _FirstChoiceBankFormState.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Save Signature', style: TextStyle(fontWeight: FontWeight.w600)),
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
      ..color = _FirstChoiceBankFormState.seal
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      final path = Path();
      path.moveTo(stroke[0].dx, stroke[0].dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
