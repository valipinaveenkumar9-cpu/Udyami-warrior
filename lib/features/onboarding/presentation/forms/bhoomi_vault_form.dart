import 'package:flutter/material.dart';
import '../../models/bhoomi_vault_models.dart';
import '../widgets/application_status_view.dart';

class BhoomiVaultForm extends StatefulWidget {
  final String? verticalId;
  final String? companyName;
  final Map<String, dynamic>? initialApplicationData;

  const BhoomiVaultForm({
    super.key,
    this.verticalId,
    this.companyName,
    this.initialApplicationData,
  });

  @override
  State<BhoomiVaultForm> createState() => _BhoomiVaultFormState();
}

class _BhoomiVaultFormState extends State<BhoomiVaultForm> {
  // CSS Palette matching HTML :root
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
  String _statusStage = 'submitted'; // 'submitted', 'meeting', 'rejected', 'notselected', 'payment', 'onboarded'
  final Map<String, int> _qCat = {}; // qid -> category index
  final Map<int, String> _qa = {}; // questionNum -> answer
  final Set<String> _errors = {};

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
  String _occupation = 'other'; // 'lawyer' (Land / Revenue Professional) or 'other'
  final _occupationSpecifyController = TextEditingController();
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
  // Land & Liaison Work Experience
  bool _hasLegalExperience = false;
  final _whereWorkedController = TextEditingController();
  final _roleController = TextEditingController();
  final _howLongController = TextEditingController();
  final _whatYouDidController = TextEditingController();
  final _yearsExperienceController = TextEditingController();
  final _highestQualificationController = TextEditingController();
  final _toolsKnownController = TextEditingController();
  final List<String> _familiarityChecklist = [];
  // Land / Revenue Professional Details
  String _practiceType = 'Independent';
  final _lawFirmNameController = TextEditingController();
  final _yearsInPracticeController = TextEditingController();
  final _seniorAdvocateNameController = TextEditingController();
  final _seniorDesignationController = TextEditingController();
  final _firmChamberNameController = TextEditingController();
  final List<String> _kindOfCases = [];
  String? _handledLandDisputes;
  final _howManyLandDisputesController = TextEditingController();
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
  // Land / Revenue Licences
  final _advocateBarNumberController = TextEditingController();
  final _documentWriterLicenceController = TextEditingController();
  final _registeredValuerCertController = TextEditingController();
  final _notaryRegNumberController = TextEditingController();

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
  List<String> _services = []; // 'setuconnect', 'setufield'
  final _wardAreaController = TextEditingController();

  // Step 7: Availability & Comfort
  final _casesPerMonthController = TextEditingController();
  String? _hireSupportStaff;
  String? _bestTimeTraining;
  String? _smartphone;
  String? _comfortApps;
  String? _usedAppsForDocs;
  String? _comfortGPS;
  final List<String> _langComm = [];

  // Step 8: Consent
  bool _c1 = false;
  bool _c2 = false;
  bool _c3 = false;
  bool _c4 = false;
  bool _c8 = false;
  bool _c5 = false;
  bool _c6 = false;
  bool _c7 = false;
  final _placeController = TextEditingController();
  final _date8Controller = TextEditingController();
  bool _signed = false;
  DateTime? _signedAt;
  bool _thumbImpression = false;

  // Simulated Payment
  String _selectedPayMethod = 'UPI';
  final _upiIdController = TextEditingController();
  bool _isPaying = false;

  // Toast Overlay Support
  OverlayEntry? _toastEntry;

  // Scroll Controller
  final ScrollController _scrollController = ScrollController();

  static const Map<String, Map<String, String>> _stepMeta = {
    's1': {'title': 'About You', 'subtitle': 'As it appears on your Aadhaar / PAN card'},
    's2': {'title': 'Verify Your Aadhaar', 'subtitle': 'One secure government check'},
    's3': {'title': 'Business & Experience', 'subtitle': 'Your business, land & liaison experience'},
    's4': {'title': "Where You'll Work From", 'subtitle': "We'll visit before approving"},
    's5': {'title': 'Your Bank Details', 'subtitle': 'For commission payments & FD refund'},
    's6': {'title': "What You'd Like to Do", 'subtitle': 'Liaisoning & Procurement — select one'},
    's7': {'title': 'Availability & Comfort', 'subtitle': 'With the Partner app'},
    's8': {'title': 'Consent', 'subtitle': 'Your promises, and your signature'},
    's9': {'title': 'Review Application', 'subtitle': 'Check everything before you submit'},
  };

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _date8Controller.text = _formatDateYMD(now);

    if (widget.initialApplicationData != null) {
      _appStage = 'status';
      final s = widget.initialApplicationData!['status'] ??
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
    _occupationSpecifyController.dispose();

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

    _lawFirmNameController.dispose();
    _yearsInPracticeController.dispose();
    _seniorAdvocateNameController.dispose();
    _seniorDesignationController.dispose();
    _firmChamberNameController.dispose();
    _howManyLandDisputesController.dispose();

    _fieldSectorController.dispose();
    _businessOrEmployerController.dispose();
    _otherHowLongController.dispose();
    _otherWhatYouDidController.dispose();

    _workAddressController.dispose();
    _workLandmarkController.dispose();
    _wardAreaServeController.dispose();
    _villagesCoveredController.dispose();

    _advocateBarNumberController.dispose();
    _documentWriterLicenceController.dispose();
    _registeredValuerCertController.dispose();
    _notaryRegNumberController.dispose();

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

    _casesPerMonthController.dispose();
    _placeController.dispose();
    _date8Controller.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  static String _formatDateYMD(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  static String _formatDateDisplay(DateTime d) {
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day.toString().padLeft(2, '0')} ${m[d.month - 1]} ${d.year}';
  }

  List<String> _buildSequence() {
    final seq = ['s1', 's2', 's3', 's4', 's5', 's6'];
    final bt = _businessType == 'institutional' ? 'institutional' : 'individual';
    final selected = _services.isNotEmpty ? _services.first : null;
    if (selected == 'setuconnect') {
      seq.add('q_setuconnect_$bt');
    } else if (selected == 'setufield') {
      seq.add('q_setufield_$bt');
    }
    seq.addAll(['s7', 's8', 's9']);
    return seq;
  }

  List<List<String>> _computeDeposit(List<String> services) {
    final hasConnect = services.contains('setuconnect');
    final hasField = services.contains('setufield');
    final rows = <List<String>>[];
    if (hasConnect && hasField) {
      rows.add(['Both, together', '₹4,00,000', 'Board confirmed']);
    } else {
      if (hasConnect) rows.add(['SetuConnect (Lead)', '₹2,00,000', 'Board confirmed']);
      if (hasField) rows.add(['SetuField (Solver)', '₹2,00,000', 'Board confirmed']);
    }
    return rows;
  }

  String _getDepositAmount() {
    final dep = _computeDeposit(_services);
    return dep.isNotEmpty ? dep.last[1] : '₹2,00,000';
  }

  void _cpToast(String message, [String type = 'normal']) {
    _toastEntry?.remove();
    _toastEntry = null;

    final overlay = Overlay.of(context);

    Color bg = ink;
    Border? border;
    if (type == 'error') {
      bg = stamp;
      border = Border.all(color: const Color(0xFF7F2E23), width: 1.5);
    } else if (type == 'success') {
      bg = seal;
      border = Border.all(color: sealDark, width: 1.5);
    }

    _toastEntry = OverlayEntry(
      builder: (ctx) => Positioned(
        top: MediaQuery.of(ctx).size.height * 0.45,
        left: 24,
        right: 24,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 360),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
                border: border,
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 8)),
                ],
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: white, fontSize: 13, fontWeight: FontWeight.w600, height: 1.4),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_toastEntry!);
    Future.delayed(const Duration(milliseconds: 2200), () {
      _toastEntry?.remove();
      _toastEntry = null;
    });
  }

  void _loadDemoApplicant() {
    final d = BhoomiVaultDemoApplicantData.sample;
    setState(() {
      _udyamiMember = d['udyamiMember'];
      _memberIdController.text = d['memberId'] ?? '';
      _fullNameController.text = d['fullName'] ?? '';
      _dobController.text = d['dob'] ?? '';
      _gender = d['gender'];
      _fatherHusbandNameController.text = d['fatherHusbandName'] ?? '';
      _maritalStatus = d['maritalStatus'];
      _bloodGroupController.text = d['bloodGroup'] ?? '';
      _nationalityController.text = d['nationality'] ?? 'Indian';
      _languagesController.text = d['languages'] ?? '';
      _mobileController.text = d['mobile'] ?? '';
      _altMobileController.text = d['altMobile'] ?? '';
      _emailController.text = d['email'] ?? '';
      _occupation = d['occupation'] ?? 'other';
      _occupationSpecifyController.text = d['occupationSpecify'] ?? '';

      _houseStreetVillageController.text = d['houseStreetVillage'] ?? '';
      _talukController.text = d['taluk'] ?? '';
      _districtController.text = d['district'] ?? '';
      _stateNameController.text = d['stateName'] ?? '';
      _pinController.text = d['pin'] ?? '';
      _wardController.text = d['ward'] ?? '';
      _yearsLivedHereController.text = d['yearsLivedHere'] ?? '';
      _homeType = d['homeType'];
      _landmarkController.text = d['landmark'] ?? '';

      _aadhaarNumberController.text = d['aadhaarNumber'] ?? '';
      _aadhaarMobileController.text = d['aadhaarMobile'] ?? '';
      _aadhaarNameController.text = d['aadhaarName'] ?? '';
      _aadhaarConsent = true;
      _aadhaarOtpSent = false;
      _aadhaarOtpVerified = true;

      _businessType = d['businessType'] ?? 'individual';
      _hasLegalExperience = d['hasLegalExperience'] ?? true;
      _whereWorkedController.text = d['whereWorked'] ?? '';
      _roleController.text = d['role'] ?? '';
      _howLongController.text = d['howLong'] ?? '';
      _whatYouDidController.text = d['whatYouDid'] ?? '';
      _yearsExperienceController.text = d['yearsExperience'] ?? '';
      _highestQualificationController.text = d['highestQualification'] ?? '';
      _toolsKnownController.text = d['toolsKnown'] ?? '';
      _familiarityChecklist.clear();
      _familiarityChecklist.addAll(List<String>.from(d['familiarityChecklist'] ?? []));

      _workAddressController.text = d['workAddress'] ?? '';
      _ownership = d['ownership'];
      _workLandmarkController.text = d['workLandmark'] ?? '';
      _wardAreaServeController.text = d['wardAreaServe'] ?? '';
      _villagesCoveredController.text = d['villagesCovered'] ?? '';
      _workFacilities.clear();
      _workFacilities.addAll(List<String>.from(d['workFacilities'] ?? []));

      _accountHolderNameController.text = d['accountHolderName'] ?? '';
      _accountType = d['accountType'] ?? 'Savings';
      _accountNumberController.text = d['accountNumber'] ?? '';
      _ifscController.text = d['ifsc'] ?? '';
      _bankBranchController.text = d['bankBranch'] ?? '';

      _nomineeNameController.text = d['nomineeName'] ?? '';
      _relationshipController.text = d['relationship'] ?? '';
      _nomineeMobileController.text = d['nomineeMobile'] ?? '';
      _nomineeAccountNumberController.text = d['nomineeAccountNumber'] ?? '';
      _nomineeIfscController.text = d['nomineeIfsc'] ?? '';
      _nomineeBankBranchController.text = d['nomineeBankBranch'] ?? '';

      _services = ['setuconnect'];
      _wardAreaController.text = d['wardArea'] ?? '';

      _casesPerMonthController.text = d['casesPerMonth'] ?? '';
      _hireSupportStaff = d['hireSupportStaff'];
      _bestTimeTraining = d['bestTimeTraining'];
      _smartphone = d['smartphone'];
      _comfortApps = d['comfortApps'];
      _usedAppsForDocs = d['usedAppsForDocs'];
      _comfortGPS = d['comfortGPS'];
      _langComm.clear();
      _langComm.addAll(List<String>.from(d['langComm'] ?? []));

      _c1 = true;
      _c2 = true;
      _c3 = true;
      _c4 = true;
      _c8 = true;
      _c5 = true;
      _c6 = true;
      _c7 = true;
      _placeController.text = d['place'] ?? 'Bengaluru';
      _date8Controller.text = d['date8'] ?? '2026-08-31';

      _signed = true;
      _signedAt = DateTime.now();

      // Pre-populate QA for SetuConnect
      for (int i = 1; i <= 35; i++) {
        _qa[i] = 'Verified during prior experience with land records and documentation.';
      }

      _errors.clear();
      _appStage = 'form';
      _currentStepId = 's1';
    });
    _cpToast('Demo applicant loaded', 'success');
  }

  void _resetApp() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: paperAlt,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Start over?', style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold, color: ink)),
        content: const Text("This clears everything you've entered.", style: TextStyle(fontSize: 13, color: muted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: muted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: seal, foregroundColor: white),
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
                _occupation = 'other';
                _occupationSpecifyController.clear();

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

                _hasLegalExperience = false;
                _whereWorkedController.clear();
                _roleController.clear();
                _howLongController.clear();
                _whatYouDidController.clear();
                _yearsExperienceController.clear();
                _highestQualificationController.clear();
                _toolsKnownController.clear();
                _familiarityChecklist.clear();

                _practiceType = 'Independent';
                _lawFirmNameController.clear();
                _yearsInPracticeController.clear();
                _seniorAdvocateNameController.clear();
                _seniorDesignationController.clear();
                _firmChamberNameController.clear();
                _kindOfCases.clear();
                _handledLandDisputes = null;
                _howManyLandDisputesController.clear();

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

                _advocateBarNumberController.clear();
                _documentWriterLicenceController.clear();
                _registeredValuerCertController.clear();
                _notaryRegNumberController.clear();

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

                _casesPerMonthController.clear();
                _hireSupportStaff = null;
                _bestTimeTraining = null;
                _smartphone = null;
                _comfortApps = null;
                _usedAppsForDocs = null;
                _comfortGPS = null;
                _langComm.clear();

                _c1 = false;
                _c2 = false;
                _c3 = false;
                _c4 = false;
                _c8 = false;
                _c5 = false;
                _c6 = false;
                _c7 = false;
                _placeController.clear();
                _date8Controller.text = _formatDateYMD(DateTime.now());
                _signed = false;
                _signedAt = null;
                _thumbImpression = false;
              });
              _cpToast('Application reset.', 'normal');
            },
            child: const Text('Start Over', style: TextStyle(color: stamp)),
          ),
        ],
      ),
    );
  }

  bool _validateStep(String id) {
    _errors.clear();

    if (id == 's1') {
      if (_udyamiMember == null) {
        _errors.add('udyamiMember');
      } else if (_udyamiMember == 'No') {
        _errors.add('udyamiMember');
      } else if (_udyamiMember == 'Yes' && _memberIdController.text.trim().isEmpty) {
        _errors.add('memberId');
      }
      if (_fullNameController.text.trim().isEmpty) _errors.add('fullName');
      if (_mobileController.text.trim().isEmpty) _errors.add('mobile');
      if (_houseStreetVillageController.text.trim().isEmpty) _errors.add('houseStreetVillage');
      if (_stateNameController.text.trim().isEmpty) _errors.add('stateName');
      if (_pinController.text.trim().isEmpty) _errors.add('pin');
    } else if (id == 's2') {
      if (!_aadhaarOtpVerified) _errors.add('aadhaarConsent');
    } else if (id == 's3') {
      if (_businessType.isEmpty) _errors.add('businessType');
    } else if (id == 's5') {
      if (_accountHolderNameController.text.trim().isEmpty) _errors.add('accountHolderName');
      if (_accountNumberController.text.trim().isEmpty) _errors.add('accountNumber');
      if (_ifscController.text.trim().isEmpty) _errors.add('ifsc');
    } else if (id == 's6') {
      if (_services.isEmpty) _errors.add('services');
      if (_wardAreaController.text.trim().isEmpty) _errors.add('wardArea');
    } else if (id == 's8') {
      if (!_c1) _errors.add('c1');
      if (!_c2) _errors.add('c2');
      if (!_c3) _errors.add('c3');
      if (!_c4) _errors.add('c4');
      if (!_c8) _errors.add('c8');
      if (!_c5) _errors.add('c5');
      if (!_c6) _errors.add('c6');
      if (!_c7) _errors.add('c7');
      if (_placeController.text.trim().isEmpty) _errors.add('place');
      if (_date8Controller.text.trim().isEmpty) _errors.add('date8');
      if (!_signed) _errors.add('signed');
    }

    setState(() {});
    return _errors.isEmpty;
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
      if (_udyamiMember == 'Yes' && _memberIdController.text.trim().isEmpty) {
        _memberIdController.text = '123123';
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

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }
  }

  void _toggleService(String id) {
    setState(() {
      _services = [id];
      _errors.remove('services');
    });
  }

  void _openSignatureBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _SignatureModal(
        applicantName: _fullNameController.text.isNotEmpty ? _fullNameController.text : 'Applicant Signature',
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

  @override
  Widget build(BuildContext context) {
    if (_appStage == 'status') {
      return _buildStatusScreen();
    }
    return Scaffold(
      backgroundColor: const Color(0xFFDAD3BE),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 430),
            color: paper,
            child: _currentStepId.startsWith('q_')
                ? _buildQuestionnaireScreen(_currentStepId)
                : _buildFormStepScreen(_currentStepId),
          ),
        ),
      ),
    );
  }

  // ==================== TOP BAR ====================
  Widget _buildTopBar() {
    return Container(
      color: seal,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BHOOMIVAULT',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 0.5,
                  color: paperAlt,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Channel Partner Registration',
                style: TextStyle(fontSize: 11, color: Color(0xFFCFE3DA), fontWeight: FontWeight.w500),
              ),
            ],
          ),
          InkWell(
            onTap: _resetApp,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
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

  // ==================== PROGRESS BAR ====================
  Widget _buildProgress(String stepId) {
    final num = int.tryParse(stepId.replaceAll(RegExp(r'\D'), '')) ?? 1;
    final pct = (num * 100 / 9).round().clamp(0, 100);

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
      child: Column(
        children: [
          Container(
            height: 5,
            decoration: BoxDecoration(color: line, borderRadius: BorderRadius.circular(3)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: pct / 100.0,
              child: Container(
                decoration: BoxDecoration(color: seal, borderRadius: BorderRadius.circular(3)),
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
                ),
              ),
              Text(
                '$pct%',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== STEP HEADING ====================
  Widget _buildStepHeading(String stepId) {
    final meta = _stepMeta[stepId] ?? {'title': 'Registration', 'subtitle': 'Complete details'};

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: line, width: 1.0)),
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
              fontStyle: FontStyle.italic,
              color: muted,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== FOOTER NAV ====================
  Widget _buildFooter({required String stepId, required VoidCallback onNext, String? nextLabel}) {
    final seq = _buildSequence();
    final idx = seq.indexOf(stepId);
    final backDisabled = idx <= 0;
    final isLast = stepId == 's9';

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: const BoxDecoration(
        color: paperAlt,
        border: Border(top: BorderSide(color: line, width: 1.0)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: line, width: 1.5),
                backgroundColor: Colors.transparent,
                foregroundColor: backDisabled ? inkSoft.withValues(alpha: 0.35) : inkSoft,
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
              onPressed: onNext,
              child: Text(
                nextLabel ?? (isLast ? 'Submit Application' : 'Continue'),
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== REUSABLE FIELD BUILDERS ====================
  Widget _buildNote(String text, {bool goldBorder = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: goldBorder ? goldTint : paperAlt,
        border: Border(
          left: BorderSide(color: goldBorder ? gold : gold, width: 3),
        ),
        borderRadius: BorderRadius.circular(2),
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

  Widget _buildFieldWrap({
    required String label,
    bool required = false,
    String? help,
    required Widget child,
  }) {
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
              if (required) const Text(' *', style: TextStyle(color: stamp, fontWeight: FontWeight.bold)),
            ],
          ),
          if (help != null) ...[
            const SizedBox(height: 3),
            Text(help, style: const TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic, color: muted)),
          ],
          const SizedBox(height: 5),
          child,
        ],
      ),
    );
  }

  Widget _buildUnderlineInput({
    required TextEditingController controller,
    String? placeholder,
    bool hasError = false,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14.5, color: ink),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: const TextStyle(color: Color(0xFFB3A98F), fontSize: 14.5),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: hasError ? stamp : line, width: 1.5),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: seal, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildUnderlineSelect({
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    String placeholder = 'Select…',
    bool hasError = false,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: (value != null && options.contains(value)) ? value : null,
      hint: Text(placeholder, style: const TextStyle(color: Color(0xFFB3A98F), fontSize: 14.5)),
      icon: const Icon(Icons.arrow_drop_down, color: muted, size: 20),
      isDense: true,
      dropdownColor: paperAlt,
      style: const TextStyle(fontSize: 14.5, color: ink),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: hasError ? stamp : line, width: 1.5),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: seal, width: 1.5),
        ),
      ),
      items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTextarea({
    required TextEditingController controller,
    String? placeholder,
    int rows = 3,
    bool hasError = false,
  }) {
    return TextField(
      controller: controller,
      maxLines: rows,
      style: const TextStyle(fontSize: 14, color: ink),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: const TextStyle(color: Color(0xFFB3A98F), fontSize: 14),
        filled: true,
        fillColor: paperAlt,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
          border: Border.all(color: active ? seal : line, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 17,
              height: 17,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: active ? seal : line, width: 2),
              ),
              child: active
                  ? Center(
                      child: Container(
                        width: 7,
                        height: 7,
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
    return InkWell(
      onTap: () => onChanged(!checked),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: paperAlt,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: hasError ? stamp : line, width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: checked ? seal : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: checked ? seal : line, width: 2),
              ),
              child: checked
                  ? const Icon(Icons.check, size: 12, color: white)
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
    );
  }

  Widget _buildCheckboxGroup({
    required List<String> options,
    required List<String> selectedValues,
    required ValueChanged<List<String>> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: paperAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: line, width: 1.0),
      ),
      child: Column(
        children: options.map((opt) {
          final isChecked = selectedValues.contains(opt);
          return InkWell(
            onTap: () {
              final updated = List<String>.from(selectedValues);
              if (isChecked) {
                updated.remove(opt);
              } else {
                updated.add(opt);
              }
              onChanged(updated);
            },
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
                      color: isChecked ? seal : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: isChecked ? seal : line, width: 2),
                    ),
                    child: isChecked
                        ? const Icon(Icons.check, size: 12, color: white)
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

  Widget _buildSectionLabel(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 22, bottom: 10),
      padding: const EdgeInsets.only(bottom: 6),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: line, width: 1.0)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'serif',
          fontWeight: FontWeight.w600,
          fontSize: 14.5,
          color: sealDark,
        ),
      ),
    );
  }

  Widget _buildPanel({required String head, required Widget child}) {
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
          child,
        ],
      ),
    );
  }

  // ==================== STEP 1: ABOUT YOU ====================
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Demo Loader Box
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: goldTint,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: gold, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Prototype demo',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: Color(0xFF5B4415)),
              ),
              const SizedBox(height: 2),
              const Text(
                'Use realistic sample data to test the complete journey.',
                style: TextStyle(fontSize: 11.5, color: Color(0xFF5B4415)),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _loadDemoApplicant,
                borderRadius: BorderRadius.circular(7),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E7),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: gold),
                  ),
                  child: const Text(
                    'Load Demo Applicant',
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF5B4415)),
                  ),
                ),
              ),
            ],
          ),
        ),

        _buildNote(
          "You must already be a Udyami Bharat / FCMCSL member to apply. If you're not yet a member, register through One Core first — the details below should match your One Core profile.",
        ),

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
                    _memberIdController.text = '123123';
                    _errors.remove('udyamiMember');
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
                    _memberIdController.clear();
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
              style: TextStyle(color: stamp, fontSize: 12.5, fontWeight: FontWeight.w500),
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
          help: 'As on Aadhaar / PAN',
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
                  placeholder: 'DD-MM-YYYY',
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildFieldWrap(
                label: 'Gender',
                child: _buildUnderlineSelect(
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
                child: _buildUnderlineSelect(
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
          required: true,
          child: Column(
            children: [
              _buildRadioOption(
                label: 'Land / Revenue Professional',
                active: _occupation == 'lawyer',
                onTap: () => setState(() => _occupation = 'lawyer'),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                label: 'Other Occupation',
                active: _occupation == 'other',
                onTap: () => setState(() => _occupation = 'other'),
              ),
            ],
          ),
        ),

        if (_occupation == 'other')
          _buildFieldWrap(
            label: 'Please Specify',
            child: _buildUnderlineInput(
              controller: _occupationSpecifyController,
              placeholder: 'e.g. Retired Village Accountant, Licensed Surveyor, Property broker',
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
                child: _buildUnderlineSelect(
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

  // ==================== STEP 2: VERIFY AADHAAR ====================
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNote(
          "DEMO ONLY — Aadhaar fields below are optional. Only the OTP verification flow is required for this prototype.",
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

        if (_aadhaarOtpVerified)
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
                  '✓ Aadhaar verified successfully',
                  style: TextStyle(color: sealDark, fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )
        else ...[
          _buildCheckboxSingle(
            label: 'Yes, please verify my Aadhaar using OTP, through a secure government-approved partner.',
            checked: _aadhaarOtpSent,
            hasError: _errors.contains('aadhaarConsent'),
            onChanged: (val) {
              setState(() {
                _aadhaarConsent = val;
                _aadhaarOtpSent = val;
                _aadhaarOtpVerified = false;
              });
            },
          ),
          if (_aadhaarOtpSent)
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: paperAlt,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: line, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  'Enter OTP',
                                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: inkSoft),
                                ),
                                Text(' *', style: TextStyle(color: stamp, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(4, (index) {
                                return Container(
                                  width: 46,
                                  height: 50,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: line, width: 1.5),
                                  ),
                                  child: TextField(
                                    controller: _otpControllers[index],
                                    focusNode: _otpFocusNodes[index],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: ink,
                                    ),
                                    decoration: const InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onChanged: (v) {
                                      if (v.isNotEmpty && index < 3) {
                                        _otpFocusNodes[index + 1].requestFocus();
                                      }
                                      final entered = _otpControllers.map((c) => c.text).join();
                                      if (entered.length == 4) {
                                        if (entered == '1234') {
                                          setState(() {
                                            _aadhaarOtpVerified = true;
                                            _aadhaarConsent = true;
                                            _aadhaarOtpSent = false;
                                            _errors.remove('aadhaarConsent');
                                          });
                                          _cpToast('Aadhaar verified successfully.', 'success');
                                        } else {
                                          _cpToast('Incorrect OTP. Use 1234 for the demo.', 'error');
                                        }
                                      }
                                    },
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
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
                  const Text(
                    'Demo OTP: 1234',
                    style: TextStyle(fontSize: 10.5, fontStyle: FontStyle.italic, color: muted),
                  ),
                ],
              ),
            ),
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
                  child: _buildUnderlineSelect(
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

        _buildSectionLabel('Land & Liaison Work Experience'),
        _buildCheckboxSingle(
          label: 'Yes, I have relevant experience',
          checked: _hasLegalExperience,
          onChanged: (val) => setState(() => _hasLegalExperience = val),
        ),

        if (_hasLegalExperience) ...[
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
                  child: _buildUnderlineInput(
                    controller: _howLongController,
                    placeholder: 'e.g. 2019–2026',
                  ),
                ),
              ),
            ],
          ),
          _buildFieldWrap(
            label: 'What You Did',
            child: _buildTextarea(
              controller: _whatYouDidController,
              placeholder: 'Describe your daily tasks...',
            ),
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
                  child: _buildUnderlineInput(
                    controller: _highestQualificationController,
                    placeholder: 'e.g. B.Com, LLB',
                  ),
                ),
              ),
            ],
          ),
          _buildFieldWrap(
            label: 'Tools You Know (e.g. DigiLocker, Bhoomi Portal)',
            child: _buildUnderlineInput(controller: _toolsKnownController),
          ),
        ],

        _buildFieldWrap(
          label: 'Familiarity',
          child: _buildCheckboxGroup(
            options: const [
              'I know my way around revenue / land records offices',
              "I'm familiar with the sub-registrar's process",
              "I've prepared or reviewed liaison paperwork before",
            ],
            selectedValues: _familiarityChecklist,
            onChanged: (list) => setState(() {
              _familiarityChecklist.clear();
              _familiarityChecklist.addAll(list);
            }),
          ),
        ),

        if (_occupation == 'lawyer')
          _buildPanel(
            head: '⚖ Shown because Occupation = Land / Revenue Professional — Professional Details',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldWrap(
                  label: 'Practice Type',
                  child: Column(
                    children: [
                      _buildRadioOption(
                        label: 'Independent',
                        active: _practiceType == 'Independent',
                        onTap: () => setState(() => _practiceType = 'Independent'),
                      ),
                      const SizedBox(height: 8),
                      _buildRadioOption(
                        label: 'Attached to an Office / Firm',
                        active: _practiceType == 'Attached to an Office / Firm',
                        onTap: () => setState(() => _practiceType = 'Attached to an Office / Firm'),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildFieldWrap(
                        label: 'Firm / Office Name (if any)',
                        child: _buildUnderlineInput(controller: _lawFirmNameController),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildFieldWrap(
                        label: 'Years in This Field',
                        child: _buildUnderlineInput(
                          controller: _yearsInPracticeController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_practiceType == 'Attached to an Office / Firm') ...[
                  _buildFieldWrap(
                    label: "Supervising Officer's / Senior's Name",
                    child: _buildUnderlineInput(controller: _seniorAdvocateNameController),
                  ),
                  _buildFieldWrap(
                    label: 'Designation',
                    child: _buildUnderlineInput(
                      controller: _seniorDesignationController,
                      placeholder: 'e.g. Deputy Tahsildar, Senior Surveyor',
                    ),
                  ),
                  _buildFieldWrap(
                    label: 'Office / Firm Name',
                    child: _buildUnderlineInput(controller: _firmChamberNameController),
                  ),
                ],
                _buildFieldWrap(
                  label: 'Kind of Liaison Work You Handle',
                  child: _buildCheckboxGroup(
                    options: const [
                      'Mutation & khata transfers',
                      'Conversion (NA) orders',
                      'Survey & boundary work',
                      'RTC / encumbrance certificate procurement',
                      'Sub-registrar liaison',
                      'Other',
                    ],
                    selectedValues: _kindOfCases,
                    onChanged: (list) => setState(() {
                      _kindOfCases.clear();
                      _kindOfCases.addAll(list);
                    }),
                  ),
                ),
                _buildFieldWrap(
                  label: 'Handled Title or Boundary Dispute Cases?',
                  child: Column(
                    children: [
                      _buildRadioOption(
                        label: 'Yes',
                        active: _handledLandDisputes == 'Yes',
                        onTap: () => setState(() => _handledLandDisputes = 'Yes'),
                      ),
                      const SizedBox(height: 8),
                      _buildRadioOption(
                        label: 'No',
                        active: _handledLandDisputes == 'No',
                        onTap: () => setState(() => _handledLandDisputes = 'No'),
                      ),
                    ],
                  ),
                ),
                if (_handledLandDisputes == 'Yes')
                  _buildFieldWrap(
                    label: 'If Yes, Roughly How Many (optional)',
                    child: _buildUnderlineInput(
                      controller: _howManyLandDisputesController,
                      placeholder: 'e.g. 12 cases',
                    ),
                  ),
              ],
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
          child: _buildTextarea(controller: _otherWhatYouDidController),
        ),
      ],
    );
  }

  // ==================== STEP 4: WHERE YOU'LL WORK FROM ====================
  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNote("We'll visit before approving — document safety matters."),
        _buildFieldWrap(
          label: 'Work Address',
          child: _buildUnderlineInput(controller: _workAddressController),
        ),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrap(
                label: 'Ownership',
                child: _buildUnderlineSelect(
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
          label: "Taluk / Hobli You'll Serve",
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
              'Private area for clients to hand over documents',
              'Secure, lockable place to store originals',
              'CCTV or other document security',
              'Internet access to scan and upload',
              'Computer, scanner and printer on site',
              'Familiar with revenue office / sub-registrar process',
            ],
            selectedValues: _workFacilities,
            onChanged: (list) => setState(() {
              _workFacilities.clear();
              _workFacilities.addAll(list);
            }),
          ),
        ),

        if (_occupation == 'lawyer')
          _buildPanel(
            head: '⚖ Shown because Occupation = Land / Revenue Professional — Licences That Strengthen Your Application',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldWrap(
                  label: 'Licensed Surveyor Certificate No. (if any)',
                  child: _buildUnderlineInput(controller: _advocateBarNumberController),
                ),
                _buildFieldWrap(
                  label: "Document Writer's Licence No. (if any)",
                  child: _buildUnderlineInput(controller: _documentWriterLicenceController),
                ),
                _buildFieldWrap(
                  label: 'Village Accountant / Revenue Official ID (if ex-official)',
                  child: _buildUnderlineInput(controller: _registeredValuerCertController),
                ),
                _buildFieldWrap(
                  label: 'RERA Agent Registration No. (if any)',
                  child: _buildUnderlineInput(controller: _notaryRegNumberController),
                ),
              ],
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
                child: _buildUnderlineSelect(
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
                  keyboardType: TextInputType.number,
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

        _buildPanel(
          head: '🛡 Alternate / Nominee Details',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                child: _buildUnderlineInput(
                  controller: _nomineeAccountNumberController,
                  keyboardType: TextInputType.number,
                ),
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
        ),
      ],
    );
  }

  // ==================== STEP 6: WHAT YOU'D LIKE TO DO ====================
  Widget _buildStep6() {
    final servicesList = [
      {
        'id': 'setuconnect',
        'icon': '🔗',
        'name': 'SetuConnect',
        'desc': "Spots and refers Liaisoning & Procurement leads — government visits, mutation/khata/conversion follow-ups, missing-record procurement. Doesn't visit offices or execute the task.",
      },
      {
        'id': 'setufield',
        'icon': '🛠️',
        'name': 'SetuField',
        'desc': 'Executes the Liaisoning & Procurement work end-to-end — government visits, approvals, mutation/khata/conversion follow-ups, and missing-record procurement via SetuDocs™ — and records outcomes & expenses.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNote('Select one role — SetuConnect refers leads, SetuField executes tasks.'),

        Column(
          children: servicesList.map((c) {
            final isSelected = _services.contains(c['id']);
            return InkWell(
              onTap: () => _toggleService(c['id']!),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? sealTint : paperAlt,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? seal : (_errors.contains('services') ? stamp : line),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c['icon']!, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c['name']!,
                            style: const TextStyle(
                              fontFamily: 'serif',
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: ink,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c['desc']!,
                            style: const TextStyle(fontSize: 12, color: muted, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? seal : Colors.transparent,
                        border: Border.all(color: isSelected ? seal : line, width: 1.5),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, size: 12, color: white)
                          : null,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 6),
        _buildFieldWrap(
          label: "Taluk / Hobli You'd Like to Serve",
          required: true,
          child: _buildUnderlineInput(
            controller: _wardAreaController,
            placeholder: 'e.g. Jayanagar Ward',
            hasError: _errors.contains('wardArea'),
            onChanged: (_) => setState(() => _errors.remove('wardArea')),
          ),
        ),

        _buildNote("If your taluk is full, you'll be waitlisted or offered a nearby open taluk."),
      ],
    );
  }

  // ==================== QUESTIONNAIRE SCREEN ====================
  Widget _buildQuestionnaireScreen(String qid) {
    final data = BhoomiVaultQuestionnaires.all[qid];
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

    return Column(
      children: [
        _buildTopBar(),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
          decoration: const BoxDecoration(
            color: goldTint,
            border: Border(bottom: BorderSide(color: line, width: 1.0)),
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
                  fontWeight: FontWeight.w600,
                  color: gold,
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
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: muted),
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(data.categories.length, (i) {
                  final isActive = i == catIdx;
                  final isDone = i < catIdx;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 6),
                    width: isActive ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive ? seal : (isDone ? gold : line),
                      borderRadius: BorderRadius.circular(isActive ? 5 : 4),
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
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(cat.questions.length, (i) {
                final n = cat.startNum + i;
                final qText = cat.questions[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$n. $qText',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: ink, height: 1.4),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        key: ValueKey('q_${qid}_$n'),
                        initialValue: _qa[n] ?? '',
                        maxLines: 2,
                        style: const TextStyle(fontSize: 13.5, color: ink),
                        onChanged: (val) => _qa[n] = val,
                        decoration: InputDecoration(
                          hintText: 'Type your answer…',
                          hintStyle: const TextStyle(color: Color(0xFFB3A98F), fontSize: 13),
                          filled: true,
                          fillColor: paperAlt,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              }),
            ),
          ),
        ),

        // Questionnaire footer
        Container(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
          decoration: const BoxDecoration(
            color: paperAlt,
            border: Border(top: BorderSide(color: line, width: 1.0)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 92,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: line, width: 1.5),
                    backgroundColor: Colors.transparent,
                    foregroundColor: inkSoft,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    if (catIdx > 0) {
                      setState(() => _qCat[qid] = catIdx - 1);
                      _scrollToTop();
                    } else {
                      _goBack();
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
                      _goNext();
                    }
                  },
                  child: Text(
                    catIdx < data.categories.length - 1 ? 'Next Section' : 'Continue',
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
          label: 'Tasks You Expect Per Month',
          child: _buildUnderlineInput(
            controller: _casesPerMonthController,
            keyboardType: TextInputType.number,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrap(
                label: 'Hire Support Staff?',
                child: Column(
                  children: [
                    _buildRadioOption(
                      label: 'Yes',
                      active: _hireSupportStaff == 'Yes',
                      onTap: () => setState(() => _hireSupportStaff = 'Yes'),
                    ),
                    const SizedBox(height: 8),
                    _buildRadioOption(
                      label: 'No',
                      active: _hireSupportStaff == 'No',
                      onTap: () => setState(() => _hireSupportStaff = 'No'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildFieldWrap(
                label: 'Best Time for Training',
                child: _buildUnderlineSelect(
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
          label: 'Used Apps for Documents / Online Forms?',
          child: Column(
            children: [
              _buildRadioOption(
                label: 'Yes, Regularly',
                active: _usedAppsForDocs == 'Yes, Regularly',
                onTap: () => setState(() => _usedAppsForDocs = 'Yes, Regularly'),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                label: 'Yes, Sometimes',
                active: _usedAppsForDocs == 'Yes, Sometimes',
                onTap: () => setState(() => _usedAppsForDocs = 'Yes, Sometimes'),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                label: 'No',
                active: _usedAppsForDocs == 'No',
                onTap: () => setState(() => _usedAppsForDocs = 'No'),
              ),
            ],
          ),
        ),

        _buildFieldWrap(
          label: 'Comfort with GPS, Camera, OTP & Payments?',
          child: Column(
            children: [
              _buildRadioOption(
                label: 'Very Comfortable',
                active: _comfortGPS == 'Very Comfortable',
                onTap: () => setState(() => _comfortGPS = 'Very Comfortable'),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                label: 'Comfortable',
                active: _comfortGPS == 'Comfortable',
                onTap: () => setState(() => _comfortGPS = 'Comfortable'),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                label: 'Need Guidance',
                active: _comfortGPS == 'Need Guidance',
                onTap: () => setState(() => _comfortGPS = 'Need Guidance'),
              ),
              const SizedBox(height: 8),
              _buildRadioOption(
                label: 'Need Full Training',
                active: _comfortGPS == 'Need Full Training',
                onTap: () => setState(() => _comfortGPS = 'Need Full Training'),
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
            selectedValues: _langComm,
            onChanged: (list) => setState(() {
              _langComm.clear();
              _langComm.addAll(list);
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
          onChanged: (v) => setState(() {
            _c1 = v;
            if (v) _errors.remove('c1');
          }),
        ),
        _buildCheckboxSingle(
          label: 'I understand my account stays inactive until I finish training.',
          checked: _c2,
          hasError: _errors.contains('c2'),
          onChanged: (v) => setState(() {
            _c2 = v;
            if (v) _errors.remove('c2');
          }),
        ),
        _buildCheckboxSingle(
          label: "I'll keep every parcel's documents and land records safe, secure and private.",
          checked: _c3,
          hasError: _errors.contains('c3'),
          onChanged: (v) => setState(() {
            _c3 = v;
            if (v) _errors.remove('c3');
          }),
        ),
        _buildCheckboxSingle(
          label: "I don't have any conflict of interest that would get in the way of this role.",
          checked: _c4,
          hasError: _errors.contains('c4'),
          onChanged: (v) => setState(() {
            _c4 = v;
            if (v) _errors.remove('c4');
          }),
        ),
        _buildCheckboxSingle(
          label: "I consent to my verification and liaison task records being logged for audit, per BhoomiVault's data-privacy rules.",
          checked: _c8,
          hasError: _errors.contains('c8'),
          onChanged: (v) => setState(() {
            _c8 = v;
            if (v) _errors.remove('c8');
          }),
        ),
        _buildCheckboxSingle(
          label: "I've read the BhoomiVault Code of Conduct and I'll follow it.",
          checked: _c5,
          hasError: _errors.contains('c5'),
          onChanged: (v) => setState(() {
            _c5 = v;
            if (v) _errors.remove('c5');
          }),
        ),
        _buildCheckboxSingle(
          label: "Everything I've written in this form is true.",
          checked: _c6,
          hasError: _errors.contains('c6'),
          onChanged: (v) => setState(() {
            _c6 = v;
            if (v) _errors.remove('c6');
          }),
        ),
        _buildCheckboxSingle(
          label: "I've read the plain-language summary and full agreement, and I agree to it.",
          checked: _c7,
          hasError: _errors.contains('c7'),
          onChanged: (v) => setState(() {
            _c7 = v;
            if (v) _errors.remove('c7');
          }),
        ),

        const SizedBox(height: 10),
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

        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('Signature', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: inkSoft)),
                      Text(' *', style: TextStyle(color: stamp, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text('Tap to Sign', style: TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic, color: muted)),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: _openSignatureBottomSheet,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 64,
                      decoration: BoxDecoration(
                        color: _signed ? sealTint : paperAlt,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _errors.contains('signed') ? stamp : (_signed ? seal : line),
                          width: 1.5,
                          style: _signed ? BorderStyle.solid : BorderStyle.none,
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
                                    fontFamily: 'serif',
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
                        border: Border.all(color: _thumbImpression ? seal : line, width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _thumbImpression ? '👍 Captured' : 'Tap to capture',
                        style: TextStyle(fontSize: 12, color: _thumbImpression ? sealDark : muted, fontWeight: FontWeight.w600),
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
    final depRows = _computeDeposit(_services);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNote("Here's what you've entered. Go back to any earlier step to make changes before submitting."),

        // Step 1 Review
        _buildReviewCard(
          title: 'About You',
          stepId: 's1',
          rows: [
            {'label': 'Member of Udyami Bharat', 'val': _udyamiMember ?? '-'},
            if (_udyamiMember == 'Yes') {'label': 'Member ID', 'val': _memberIdController.text},
            {'label': 'Full Name', 'val': _fullNameController.text},
            if (_dobController.text.isNotEmpty) {'label': 'Date of Birth', 'val': _dobController.text},
            if (_gender != null) {'label': 'Gender', 'val': _gender!},
            if (_fatherHusbandNameController.text.isNotEmpty) {'label': "Father's / Husband's Name", 'val': _fatherHusbandNameController.text},
            {'label': 'Mobile Number', 'val': _mobileController.text},
            if (_emailController.text.isNotEmpty) {'label': 'Email ID', 'val': _emailController.text},
            {'label': 'Occupation', 'val': _occupation == 'lawyer' ? 'Land / Revenue Professional' : (_occupationSpecifyController.text.isNotEmpty ? _occupationSpecifyController.text : 'Other')},
            {'label': 'House / Street / Village', 'val': _houseStreetVillageController.text},
            if (_talukController.text.isNotEmpty) {'label': 'Taluk', 'val': _talukController.text},
            if (_districtController.text.isNotEmpty) {'label': 'District', 'val': _districtController.text},
            {'label': 'State', 'val': _stateNameController.text},
            {'label': 'PIN Code', 'val': _pinController.text},
            if (_wardController.text.isNotEmpty) {'label': 'Ward', 'val': _wardController.text},
          ],
        ),

        // Step 2 Review
        _buildReviewCard(
          title: 'Verify Your Aadhaar',
          stepId: 's2',
          rows: [
            if (_aadhaarNumberController.text.isNotEmpty) {'label': 'Aadhaar Number', 'val': _aadhaarNumberController.text},
            if (_aadhaarNameController.text.isNotEmpty) {'label': 'Name on Aadhaar', 'val': _aadhaarNameController.text},
            {'label': 'Consent Given', 'val': _aadhaarConsent ? 'Yes' : 'No'},
            {'label': 'Verification Status', 'val': _aadhaarOtpVerified ? 'Verified via OTP' : 'Pending'},
          ],
        ),

        // Step 3 Review
        _buildReviewCard(
          title: 'Business & Experience',
          stepId: 's3',
          rows: [
            {'label': 'Business Type', 'val': _businessType == 'institutional' ? 'Registered Business' : 'Individual'},
            if (_businessType == 'institutional' && _businessNameController.text.isNotEmpty) {'label': 'Business Name', 'val': _businessNameController.text},
            if (_hasLegalExperience) ...[
              if (_whereWorkedController.text.isNotEmpty) {'label': 'Where You Worked', 'val': _whereWorkedController.text},
              if (_roleController.text.isNotEmpty) {'label': 'Role', 'val': _roleController.text},
              if (_howLongController.text.isNotEmpty) {'label': 'How Long', 'val': _howLongController.text},
            ],
            if (_familiarityChecklist.isNotEmpty) {'label': 'Familiarity', 'val': _familiarityChecklist.join(', ')},
            if (_occupation == 'lawyer') ...[
              {'label': 'Practice Type', 'val': _practiceType},
              if (_lawFirmNameController.text.isNotEmpty) {'label': 'Firm / Office', 'val': _lawFirmNameController.text},
            ],
          ],
        ),

        // Step 4 Review
        _buildReviewCard(
          title: "Where You'll Work From",
          stepId: 's4',
          rows: [
            if (_workAddressController.text.isNotEmpty) {'label': 'Work Address', 'val': _workAddressController.text},
            if (_ownership != null) {'label': 'Ownership', 'val': _ownership!},
            if (_wardAreaServeController.text.isNotEmpty) {'label': "Taluk / Hobli You'll Serve", 'val': _wardAreaServeController.text},
            if (_workFacilities.isNotEmpty) {'label': 'Facilities', 'val': _workFacilities.join(', ')},
          ],
        ),

        // Step 5 Review
        _buildReviewCard(
          title: 'Your Bank Details',
          stepId: 's5',
          rows: [
            {'label': 'Account Holder', 'val': _accountHolderNameController.text},
            {'label': 'Account Number', 'val': _accountNumberController.text},
            {'label': 'IFSC Code', 'val': _ifscController.text},
            if (_nomineeNameController.text.isNotEmpty) {'label': 'Nominee Name', 'val': _nomineeNameController.text},
            if (_relationshipController.text.isNotEmpty) {'label': 'Nominee Relationship', 'val': _relationshipController.text},
          ],
        ),

        // Step 6 Review
        _buildReviewCard(
          title: "What You'd Like to Do",
          stepId: 's6',
          rows: [
            {'label': 'Services', 'val': _services.map((s) {
              if (s == 'setuconnect') return 'SetuConnect';
              if (s == 'setufield') return 'SetuField';
              return s;
            }).join(', ')},
            {'label': 'Taluk / Hobli', 'val': _wardAreaController.text},
          ],
        ),

        // Dynamic Questionnaires Review
        ..._buildQuestionnairesReview(),

        // Step 7 Review
        _buildReviewCard(
          title: 'Availability & Comfort',
          stepId: 's7',
          rows: [
            if (_casesPerMonthController.text.isNotEmpty) {'label': 'Expected Tasks / Month', 'val': _casesPerMonthController.text},
            if (_hireSupportStaff != null) {'label': 'Hire Support Staff', 'val': _hireSupportStaff!},
            if (_bestTimeTraining != null) {'label': 'Best Time for Training', 'val': _bestTimeTraining!},
            if (_smartphone != null) {'label': 'Smartphone', 'val': _smartphone!},
            if (_comfortApps != null) {'label': 'Comfort with Apps', 'val': _comfortApps!},
            if (_langComm.isNotEmpty) {'label': 'Languages & App Comfort', 'val': _langComm.join(', ')},
          ],
        ),

        // Step 8 Review
        _buildReviewCard(
          title: 'Consent',
          stepId: 's8',
          rows: [
            {'label': 'Place', 'val': _placeController.text},
            {'label': 'Date', 'val': _date8Controller.text},
            {'label': 'Signature', 'val': _signed ? 'Signed' : 'Not Signed'},
            if (_thumbImpression) {'label': 'Thumb Impression', 'val': 'Captured'},
          ],
        ),

        // Deposit Schedule Table
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 18),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: paperAlt,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: line, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SECURITY DEPOSIT SCHEDULE',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: sealDark),
              ),
              const SizedBox(height: 8),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2.0),
                  1: FlexColumnWidth(1.2),
                  2: FlexColumnWidth(1.2),
                },
                children: [
                  const TableRow(
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: ink, width: 1.5))),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Text('SERVICE', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: muted)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Text('DEPOSIT', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: muted)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Text('STATUS', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: muted)),
                      ),
                    ],
                  ),
                  ...depRows.map((r) => TableRow(
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: line, width: 1.0))),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(r[0], style: const TextStyle(fontSize: 12.5, color: ink)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(r[1], style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w600, fontSize: 12.5, color: gold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(r[2], style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: muted)),
                      ),
                    ],
                  )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String title,
    required String stepId,
    required List<Map<String, String>> rows,
  }) {
    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: paperAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: line, width: 1.0),
      ),
      clipBehavior: Clip.antiAlias,
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
                  style: const TextStyle(fontFamily: 'serif', fontWeight: FontWeight.w600, fontSize: 13, color: sealDark),
                ),
                InkWell(
                  onTap: () {
                    setState(() => _currentStepId = stepId);
                    _scrollToTop();
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: stamp, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
          ...rows.map((r) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: line, width: 1.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Text(r['label']!, style: const TextStyle(fontSize: 12, color: muted)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 6,
                  child: Text(
                    r['val']!,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: ink),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  List<Widget> _buildQuestionnairesReview() {
    final bt = _businessType == 'institutional' ? 'institutional' : 'individual';
    final qids = <String>[];
    if (_services.contains('setuconnect')) qids.add('q_setuconnect_$bt');
    if (_services.contains('setufield')) qids.add('q_setufield_$bt');

    return qids.map((qid) {
      final data = BhoomiVaultQuestionnaires.all[qid];
      if (data == null) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: paperAlt,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: line, width: 1.0),
        ),
        clipBehavior: Clip.antiAlias,
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
                      data.title,
                      style: const TextStyle(fontFamily: 'serif', fontWeight: FontWeight.w600, fontSize: 13, color: sealDark),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() => _currentStepId = qid);
                      _scrollToTop();
                    },
                    child: const Text(
                      'Edit',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: stamp, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
            ...data.categories.expand((cat) {
              return [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: const BoxDecoration(
                    color: paper,
                    border: Border(
                      top: BorderSide(color: line, width: 1.0),
                      bottom: BorderSide(color: line, width: 1.0),
                    ),
                  ),
                  child: Text(
                    cat.name,
                    style: const TextStyle(fontFamily: 'serif', fontSize: 11.5, fontWeight: FontWeight.w700, color: sealDark),
                  ),
                ),
                ...List.generate(cat.questions.length, (i) {
                  final n = cat.startNum + i;
                  final qText = cat.questions[i];
                  final answer = (_qa[n] ?? '').trim();
                  if (answer.isEmpty) return const SizedBox.shrink();

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: line, width: 1.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$n. $qText', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ink)),
                        const SizedBox(height: 4),
                        Text(answer, style: const TextStyle(fontSize: 12, color: inkSoft, height: 1.45)),
                      ],
                    ),
                  );
                }),
              ];
            }),
          ],
        ),
      );
    }).toList();
  }

  // ==================== FORM STEP CONTAINER ====================
  Widget _buildFormStepScreen(String stepId) {
    Widget content;
    switch (stepId) {
      case 's1':
        content = _buildStep1();
        break;
      case 's2':
        content = _buildStep2();
        break;
      case 's3':
        content = _buildStep3();
        break;
      case 's4':
        content = _buildStep4();
        break;
      case 's5':
        content = _buildStep5();
        break;
      case 's6':
        content = _buildStep6();
        break;
      case 's7':
        content = _buildStep7();
        break;
      case 's8':
        content = _buildStep8();
        break;
      case 's9':
        content = _buildStep9();
        break;
      default:
        content = const SizedBox.shrink();
    }

    return Column(
      children: [
        _buildTopBar(),
        _buildProgress(stepId),
        _buildStepHeading(stepId),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_errors.isNotEmpty && stepId != 's1')
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
                content,
              ],
            ),
          ),
        ),
        _buildFooter(
          stepId: stepId,
          onNext: () {
            if (stepId == 's9') {
              setState(() {
                _appStage = 'status';
                _statusStage = 'submitted';
              });
              _cpToast('Application submitted successfully!', 'success');
            } else {
              _goNext();
            }
          },
        ),
      ],
    );
  }

  // ==================== STATUS SCREENS ====================
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
      theme: CompanyStatusTheme.bhoomiVault(),
      initialStageIndex: _mapStatusToStageIndex(_statusStage),
      applicantName: _fullNameController.text.trim().isNotEmpty ? _fullNameController.text.trim() : 'Vikramaditya Shinde',
      applicationId: '#BV-${DateTime.now().year}-3921',
      wardLocality: _wardAreaController.text.trim().isNotEmpty ? _wardAreaController.text.trim() : 'Taluk Office, Hubli',
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

  Widget _buildMeetingRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: line, width: 1.0)),
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

  Widget _buildTimeline(List<String> steps, int currentIdx) {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isDone = i < currentIdx;
          final isCurrent = i == currentIdx;

          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 2,
                        color: i == 0 ? Colors.transparent : (isDone || isCurrent ? seal : line),
                      ),
                    ),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone ? seal : (isCurrent ? white : paperAlt),
                        border: Border.all(color: isDone || isCurrent ? seal : line, width: 2),
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
                  steps[i],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isDone || isCurrent ? FontWeight.w600 : FontWeight.w400,
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

  Widget _buildDemoBtn(String label, String stageId) {
    if (_statusStage == stageId) return const SizedBox.shrink();
    return InkWell(
      onTap: () => setState(() => _statusStage = stageId),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: paperAlt,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: line),
        ),
        child: Text(label, style: const TextStyle(fontSize: 11, color: inkSoft)),
      ),
    );
  }
}

// ==================== SIGNATURE MODAL BOTTOM SHEET ====================
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
        color: _BhoomiVaultFormState.paperAlt,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      padding: EdgeInsets.fromLTRB(18, 18, 18, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add your signature',
            style: TextStyle(fontFamily: 'serif', fontSize: 19, fontWeight: FontWeight.w700, color: _BhoomiVaultFormState.ink),
          ),
          const SizedBox(height: 4),
          const Text(
            'Draw below or save with your full name.',
            style: TextStyle(fontSize: 12, color: _BhoomiVaultFormState.muted),
          ),
          const SizedBox(height: 12),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _BhoomiVaultFormState.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _BhoomiVaultFormState.line, width: 1.5),
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
                            color: _BhoomiVaultFormState.seal.withValues(alpha: 0.35),
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
                    side: const BorderSide(color: _BhoomiVaultFormState.line, width: 1.5),
                    foregroundColor: _BhoomiVaultFormState.inkSoft,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => setState(() => _strokes.clear()),
                  child: const Text('Clear', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _BhoomiVaultFormState.seal,
                    foregroundColor: _BhoomiVaultFormState.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    widget.onSave();
                    Navigator.pop(context);
                  },
                  child: const Text('Save Signature', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
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
      ..color = _BhoomiVaultFormState.sealDark
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
