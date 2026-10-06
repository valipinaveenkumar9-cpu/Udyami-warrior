import 'package:flutter/material.dart';
import '../widgets/form_layout.dart';
import '../widgets/onboarding_components.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/widgets/shake_widget.dart';
import '../../data/cloud_patra_api.dart';

class DefaultCompanyForm extends StatefulWidget {
  final String? verticalId;
  final String? companyName;
  const DefaultCompanyForm({super.key, this.verticalId, this.companyName});

  @override
  State<DefaultCompanyForm> createState() => _DefaultCompanyFormState();
}

class _DefaultCompanyFormState extends State<DefaultCompanyForm> {
  int _currentStep = 0;
  final int _totalSteps = 7;
  bool _isLoading = false;

  // Step 1: Basic Info
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _mobileController = TextEditingController();
  final _wardLocalityController = TextEditingController();
  bool _isMember = false;
  final _memberIdController = TextEditingController();
  bool _isVerifyingMember = false;
  bool _isMemberVerified = false;
  String? _verifiedMemberName;

  // Step 2: Services & Geofence
  List<dynamic> _availableSubVerticals = [];
  final GlobalKey<ShakeWidgetState> _memberWarningShakeKey = GlobalKey<ShakeWidgetState>();
  final GlobalKey<ShakeWidgetState> _validationShakeKey = GlobalKey<ShakeWidgetState>();
  String? _validationError;

  String? _selectedSubVerticalId; // Only allow one sub-vertical based on API payload
  
  final Set<String> _selectedServices = {};
  
  // Geofence / Territory variables
  final _wardAppliedController = TextEditingController();

  int get _totalFdAmount {
    double total = 0;
    for (var service in _selectedServices) {
      for (var item in _availableSubVerticals) {
        if (item['subVerticalName'] == service) {
          total += double.tryParse(item['fdAmount']?.toString() ?? '100000') ?? 100000;
          break;
        }
      }
    }
    return total.toInt();
  }

  // Step 3 & 4: Business Details
  final _businessAddressController = TextEditingController();
  String _ownership = 'OWNED';
  final _landmarkController = TextEditingController();
  bool _dedicatedSpace = true;
  bool _internetAccess = true;
  bool _priorExperience = false;
  final _priorExperienceDescController = TextEditingController();
  final _yearsExperienceController = TextEditingController(text: '0');
  final _expectedMembersController = TextEditingController(text: '0');
  bool _willEmployStaff = false;
  String _dashboardComfort = 'NO';
  String _availability = 'WEEKDAYS';

  // Consents
  bool _declarePremises = true;
  bool _understandCoreRole = true;
  bool _consentIdentity = false;
  bool _consentBackground = false;
  bool _consentInactive = false;
  bool _agreeSummary = false;

  @override
  void initState() {
    super.initState();
    _wardAppliedController.addListener(() {
      setState(() {});
    });
    _fetchSubVerticals();
  }

  @override
  void dispose() {
    _wardAppliedController.dispose();
    super.dispose();
  }
  
  Future<void> _fetchSubVerticals() async {
    if (widget.verticalId != null) {
      final subs = await CloudPatraApi.getSubBusinessVerticals(widget.verticalId!);
      setState(() {
        _availableSubVerticals = subs;
      });
    }
  }


  Future<void> _verifyMember() async {
    if (_memberIdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a Member ID')),
      );
      return;
    }
    
    setState(() {
      _isVerifyingMember = true;
      _isMemberVerified = false;
      _verifiedMemberName = null;
    });

    final user = await CloudPatraApi.verifyMemberId(_memberIdController.text.trim());
    
    setState(() {
      _isVerifyingMember = false;
      if (user != null) {
        _isMemberVerified = true;
        _verifiedMemberName = user['name'] ?? user['fullName'] ?? 'Verified Member';
        // Pre-fill some fields if available
        if (user['name'] != null && _nameController.text.isEmpty) _nameController.text = user['name'];
        if (user['mobileNumber'] != null && _mobileController.text.isEmpty) _mobileController.text = user['mobileNumber'];
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member verified successfully!'), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member ID not found. Please check and try again.'), backgroundColor: Colors.red),
        );
      }
    });
  }

  Future<void> _onContinue() async {
    setState(() {
      _validationError = null;
    });

    if (_currentStep == 0) {
      if (!_isMember) {
        _memberWarningShakeKey.currentState?.shake();
        return;
      }
      if (!_isMemberVerified) {
        setState(() {
          _validationError = 'Please enter and verify your Udyami / FCMCSL member ID.';
        });
        _validationShakeKey.currentState?.shake();
        return;
      }
      if (_nameController.text.trim().isEmpty) {
        setState(() {
          _validationError = 'You missed a section: Please enter your full name.';
        });
        _validationShakeKey.currentState?.shake();
        return;
      }
      if (_dobController.text.trim().isEmpty) {
        setState(() {
          _validationError = 'You missed a section: Please enter your date of birth.';
        });
        _validationShakeKey.currentState?.shake();
        return;
      }
      if (_mobileController.text.trim().isEmpty) {
        setState(() {
          _validationError = 'You missed a section: Please enter your mobile number.';
        });
        _validationShakeKey.currentState?.shake();
        return;
      }
      if (_wardLocalityController.text.trim().isEmpty) {
        setState(() {
          _validationError = 'You missed a section: Please enter your ward / hobli / locality of residence.';
        });
        _validationShakeKey.currentState?.shake();
        return;
      }
    } else if (_currentStep == 1) {
      if (_selectedServices.isEmpty) {
        setState(() => _validationError = 'You missed a section: Please select at least one service.');
        _validationShakeKey.currentState?.shake();
        return;
      }
      if (_wardAppliedController.text.trim().isEmpty) {
        setState(() => _validationError = 'You missed a section: Please enter the ward applied for.');
        _validationShakeKey.currentState?.shake();
        return;
      }
    } else if (_currentStep == 2) {
      if (_businessAddressController.text.trim().isEmpty) {
        setState(() => _validationError = 'You missed a section: Please enter your business / office address.');
        _validationShakeKey.currentState?.shake();
        return;
      }
      if (!_declarePremises) {
        setState(() => _validationError = 'You missed a section: Please accept the premises declaration.');
        _validationShakeKey.currentState?.shake();
        return;
      }
    } else if (_currentStep == 3) {
      if (_yearsExperienceController.text.trim().isEmpty) {
        setState(() => _validationError = 'You missed a section: Please enter your years of relevant experience.');
        _validationShakeKey.currentState?.shake();
        return;
      }
      if (_expectedMembersController.text.trim().isEmpty) {
        setState(() => _validationError = 'You missed a section: Please enter the expected subscribers you will onboard in Month 1.');
        _validationShakeKey.currentState?.shake();
        return;
      }
      if (!_understandCoreRole) {
        setState(() => _validationError = 'You missed a section: Please confirm you understand the core CP role.');
        _validationShakeKey.currentState?.shake();
        return;
      }
    } else if (_currentStep == 5) {
      if (!_consentIdentity || !_consentBackground || !_consentInactive || !_agreeSummary) {
        setState(() => _validationError = 'You missed a section: Please read and accept all declarations and consents to proceed.');
        _validationShakeKey.currentState?.shake();
        return;
      }
    }
    // Log data based on current step before moving forward
    print('DEV DEBUG - _onContinue - cloud_patra_form.dart - Completing Step ${_currentStep + 1} of $_totalSteps');
    switch (_currentStep) {
      case 0:
        print('DEV DEBUG - Form Data [Step 1]: Name=${_nameController.text}, DOB=${_dobController.text}, Mobile=${_mobileController.text}, Locality=${_wardLocalityController.text}, isMember=$_isMember, memberId=${_memberIdController.text}, verified=$_isMemberVerified');
        break;
      case 1:
        print('DEV DEBUG - Form Data [Step 2]: SelectedServices=$_selectedServices, AppliedWard=${_wardAppliedController.text}');
        break;
      case 2:
        print('DEV DEBUG - Form Data [Step 3]: Address=${_businessAddressController.text}, Ownership=$_ownership, Landmark=${_landmarkController.text}, DedicatedSpace=$_dedicatedSpace, Internet=$_internetAccess, PriorExp=$_priorExperience');
        break;
      case 3:
        print('DEV DEBUG - Form Data [Step 4]: ExpDesc=${_priorExperienceDescController.text}, YearsExp=${_yearsExperienceController.text}, SubscribersMonth1=${_expectedMembersController.text}, EmployStaff=$_willEmployStaff, ComfortApp=$_dashboardComfort, TrainingAvail=$_availability');
        break;
      case 4:
        print('DEV DEBUG - Form Data [Step 5]: Financial review acknowledged.');
        break;
      case 5:
        print('DEV DEBUG - Form Data [Step 6]: Consents -> Identity=$_consentIdentity, Background=$_consentBackground, Inactive=$_consentInactive, AgreeSummary=$_agreeSummary');
        break;
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep += 1);
    } else {
      if (!_agreeSummary || !_consentIdentity || !_consentBackground) {
        print('DEV DEBUG - _onContinue - cloud_patra_form.dart - FAILED: Consents missing on final step');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept all required consents to proceed.')),
        );
        return;
      }

      print('DEV DEBUG - _onContinue - cloud_patra_form.dart - Submitting Form...');
      setState(() => _isLoading = true);

      // Map to exact schema from swagger
      final body = {
        "fullName": _nameController.text.trim(),
        "dateOfBirth": _dobController.text.trim().isNotEmpty ? _dobController.text.trim() : "1995-05-20", // Mock date for now if empty
        "mobileNumber": _mobileController.text.trim(),
        "residenceLocality": _wardLocalityController.text.trim(),
        "isExistingMember": _isMember,
        "memberId": _isMember ? _memberIdController.text.trim() : null,
        "subVerticalId": _selectedSubVerticalId ?? widget.verticalId, // Use selected sub-vertical or fallback to vertical
        "selectedServices": _selectedServices.toList(),
        "appliedTerritory": _wardAppliedController.text.trim(),
        "wardId": null,
        "businessOfficeAddress": _businessAddressController.text.trim(),
        "ownership": _ownership,
        "nearestLandmark": _landmarkController.text.trim(),
        "hasDedicatedWalkInSpace": _dedicatedSpace,
        "hasInternetAndDigitalCapability": _internetAccess,
        "hasRelevantExperience": _priorExperience,
        "premisesDeclarationAccepted": _declarePremises,
        "experienceDescription": _priorExperienceDescController.text.trim(),
        "yearsOfExperience": int.tryParse(_yearsExperienceController.text) ?? 0,
        "expectedSubscribersMonthOne": int.tryParse(_expectedMembersController.text) ?? 0,
        "willEmploySupportStaff": _willEmployStaff,
        "dashboardComfort": _dashboardComfort,
        "trainingAvailability": _availability,
        "kycResponsibilityAccepted": _understandCoreRole,
        "identityVerificationConsent": _consentIdentity,
        "backgroundVerificationConsent": _consentBackground,
        "trainingRequirementAccepted": _consentInactive,
        "agreementAccepted": _agreeSummary,
        "agreementVersion": "CP_AGREEMENT_V1.0"
      };

      final success = await CloudPatraApi.registerCloudPatraCpApplication(body);
      
      setState(() => _isLoading = false);

      if (success && mounted) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Application Submitted'),
              ],
            ),
            content: const Text('Your application has been successfully sent for review by your Ward Chairman.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // close form
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit application. Please try again.')),
        );
      }
    }
  }

  void _onBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
        _validationError = null;
      });
    } else {
      Navigator.pop(context);
    }
  }

  Widget _buildStepContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_validationError != null)
          ShakeWidget(
            key: _validationShakeKey,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200, width: 1.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _validationError!,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        _buildCurrentStep(),
      ],
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FormSectionHeader(title: 'Section A'),
            FormToggleRow(
              label: 'Existing FCMCSL / Udyami member?',
              value: _isMember,
              onChanged: (val) => setState(() => _isMember = val),
            ),
            if (!_isMember)
              ShakeWidget(
                key: _memberWarningShakeKey,
                child: const WarningNote(
                  text: 'You\'ll need to be an FCMCSL / Udyami member before you can become a Channel Partner. Please complete member registration first — come back to this application once you\'re enrolled.',
                ),
              ),
            if (_isMember)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Udyami / FCMCSL member ID',
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: context.colors.primaryDarkBlue),
                        children: const [TextSpan(text: ' *', style: TextStyle(color: Colors.red))],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _memberIdController,
                            style: const TextStyle(fontSize: 13.5),
                            decoration: InputDecoration(
                              hintText: 'e.g. UDYM001',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.colors.disabledBorder, width: 1.5)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.colors.disabledBorder, width: 1.5)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.colors.orangeWarning, width: 2)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _isVerifyingMember ? null : _verifyMember,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.primaryDarkBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          child: _isVerifyingMember 
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Verify'),
                        ),
                      ],
                    ),
                    if (_isMemberVerified)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 16),
                            const SizedBox(width: 4),
                            Text('Verified: $_verifiedMemberName', style: const TextStyle(color: Colors.green, fontSize: 11.5, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            FormTextField(
              controller: _nameController, 
              label: 'Full name', 
              isRequired: true,
              hint: 'As per Aadhaar / PAN',
            ),
            Row(
              children: [
                Expanded(
                  child: FormTextField(
                    controller: _dobController,
                    label: 'Date of birth',
                    isRequired: true,
                    hint: 'YYYY-MM-DD',
                    helperText: 'Minimum age 21 years',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FormTextField(
                    controller: _mobileController,
                    label: 'Mobile number',
                    isRequired: true,
                    hint: 'OTP verified',
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            FormTextField(
              controller: _wardLocalityController,
              label: 'Ward / Hobli / Locality of residence',
              isRequired: true,
              hint: 'Must be local to ward applied for',
            ),
            const WarningNote(
              text: 'Eligibility: applicants must be local residents of the ward or district applied for.',
              isWarning: false,
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FormSectionHeader(title: 'Section B'),
            const Text(
              'Services you\'ll be Channel Partner for *',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
            ),
            const SizedBox(height: 4),
            const Text(
              'Select every service you\'ll acquire subscribers into — one Fixed Deposit unit is charged per service selected.',
              style: TextStyle(fontSize: 10.8, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Builder(
              builder: (context) {
                final servicesToShow = _availableSubVerticals.map((e) => e['subVerticalName'].toString()).toList();

                if (servicesToShow.isEmpty) {
                  return const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()));
                }

                return Wrap(
                  spacing: 8.0,
                  runSpacing: 6.0,
                  children: servicesToShow.map((serviceName) {
                    final isSelected = _selectedServices.contains(serviceName);
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          String? matchedId;
                          for (var item in _availableSubVerticals) {
                            if (item['subVerticalName'] == serviceName) {
                              matchedId = item['subVerticalId'];
                              break;
                            }
                          }

                          if (isSelected) {
                            _selectedServices.remove(serviceName);
                            if (matchedId != null && _selectedSubVerticalId == matchedId) {
                              _selectedSubVerticalId = null;
                            }
                          } else {
                            _selectedServices.add(serviceName);
                            if (matchedId != null) {
                              _selectedSubVerticalId ??= matchedId;
                            }
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? context.colors.primaryDarkBlue : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? context.colors.primaryDarkBlue : context.colors.disabledBorder, 
                            width: 1.5
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? context.colors.orangeLight : Colors.grey.shade400,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              serviceName,
                              style: TextStyle(
                                fontSize: 13,
                                color: isSelected ? context.colors.orangeLight : context.colors.primaryDarkBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            ),
            const SizedBox(height: 18),
            const SizedBox(height: 18),
            FormTextField(
              controller: _wardAppliedController,
              label: 'Ward / territory applied for',
              isRequired: true,
              hint: 'e.g. Basavanagudi — Ward 14',
              helperText: 'You\'ll acquire subscribers from this ward/territory, across every service selected above.',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: context.colors.primaryDarkBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_selectedServices.length} services selected',
                        style: const TextStyle(fontSize: 11, color: Colors.white70),
                      ),
                      const Text(
                        'Fixed Deposit required',
                        style: TextStyle(fontSize: 11, color: Colors.white70),
                      ),
                    ],
                  ),
                  Text(
                    '₹$_totalFdAmount',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: context.colors.orangeLight),
                  ),
                ],
              ),
            ),
            if (_selectedServices.isNotEmpty)
              const WarningNote(
                text: 'Good to know: if you resign or are terminated, this Fixed Deposit is reverted back within 30 days. You can also choose to leave it deposited with us instead of withdrawing it.',
                isWarning: false,
              ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FormSectionHeader(title: 'Section C'),
            FormTextField(
              controller: _businessAddressController,
              label: 'Business / office address',
              isRequired: true,
              hint: 'Where members can walk in for onboarding, KYC & document handover',
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ownership', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: context.colors.primaryDarkBlue)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: context.colors.disabledBorder, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _ownership,
                            isExpanded: true,
                            items: ['OWNED', 'RENTED', 'LEASED'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13.5)))).toList(),
                            onChanged: (val) => setState(() => _ownership = val!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FormTextField(
                    controller: _landmarkController,
                    label: 'Nearest landmark',
                    hint: 'Optional',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FormToggleRow(
              label: 'Dedicated space for member walk-ins / KYC',
              value: _dedicatedSpace,
              onChanged: (val) => setState(() => _dedicatedSpace = val),
            ),
            FormToggleRow(
              label: 'Internet access & digital documentation capability',
              value: _internetAccess,
              onChanged: (val) => setState(() => _internetAccess = val),
            ),
            FormToggleRow(
              label: 'Prior legal, documentation or financial services experience',
              value: _priorExperience,
              onChanged: (val) => setState(() => _priorExperience = val),
            ),
            FormCheckbox(
              text: 'I declare my premises is suitable for member onboarding, physical document handling and may be inspected before approval.',
              value: _declarePremises,
              onChanged: (val) => setState(() => _declarePremises = val ?? false),
            ),
            const WarningNote(
              text: 'Members complete KYC and hand over property documents for PatraVault™ scanning through you — please ensure a private, reliable space with internet access.',
              isWarning: false,
            ),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FormSectionHeader(title: 'Section D'),
            FormTextField(
              controller: _priorExperienceDescController,
              label: 'Prior legal, documentation, financial services or co-operative experience',
              hint: 'Describe briefly',
            ),
            Row(
              children: [
                Expanded(
                  child: FormTextField(
                    controller: _yearsExperienceController,
                    label: 'Years of relevant experience',
                    hint: 'e.g. 3',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FormTextField(
                    controller: _expectedMembersController,
                    label: 'Expected subscribers onboarded, Month 1',
                    hint: 'e.g. 12',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            FormToggleRow(
              label: 'Will employ support / field staff',
              value: _willEmployStaff,
              onChanged: (val) => setState(() => _willEmployStaff = val),
            ),
            FormToggleRow(
              label: 'Comfortable with Channel Partner dashboard app',
              value: _dashboardComfort == 'WITH_TRAINING',
              onChanged: (val) => setState(() => _dashboardComfort = val ? 'WITH_TRAINING' : 'NO'),
              falseText: 'No',
              trueText: 'With training',
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Availability for onboarding training', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: context.colors.primaryDarkBlue)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: context.colors.disabledBorder, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _availability,
                      isExpanded: true,
                      items: ['WEEKDAYS', 'WEEKENDS', 'BOTH', 'FLEXIBLE'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13.5)))).toList(),
                      onChanged: (val) => setState(() => _availability = val!),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FormCheckbox(
              text: 'I understand that completing subscriber KYC accurately and acquiring genuine, verified subscriptions is a core part of the CP role.',
              value: _understandCoreRole,
              onChanged: (val) => setState(() => _understandCoreRole = val ?? false),
            ),
          ],
        );
      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FormSectionHeader(title: 'Section E'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [context.colors.primaryDarkBlue, context.colors.primaryDarkBlue.withValues(alpha: 0.8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Text(
                    'TOTAL FIXED DEPOSIT PAYABLE',
                    style: TextStyle(color: context.colors.orangeLight, fontSize: 10, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '₹$_totalFdAmount',
                    style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Based on your selected ${_selectedServices.length} services',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 14),
                    width: 200,
                    height: 1.5,
                    color: context.colors.orangeWarning.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
            const CommissionCard(
              icon: '🎯',
              title: 'Your commission',
              description: Text.rich(
                TextSpan(
                  text: 'A flat ',
                  children: [
                    TextSpan(text: '3%', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    TextSpan(text: ' commission on every lead you bring in through your ward, across your approved services.'),
                  ],
                ),
              ),
            ),
            const WarningNote(
              text: 'No payment is collected in this application. Your Ward Chairman reviews and approves it first — only after approval will you be asked to pay the Fixed Deposit above, within 7 days.',
            ),
          ],
        );
      case 5:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FormSectionHeader(title: 'Section F'),
            FormCheckbox(
              text: 'I consent to identity verification (Aadhaar / PAN / bank penny-drop) via an authorised, DPDP-compliant provider.',
              value: _consentIdentity,
              onChanged: (val) => setState(() => _consentIdentity = val ?? false),
            ),
            FormCheckbox(
              text: 'I consent to background verification under the CP Eligibility Policy.',
              value: _consentBackground,
              onChanged: (val) => setState(() => _consentBackground = val ?? false),
            ),
            FormCheckbox(
              text: 'I understand my account stays inactive until mandatory onboarding training is completed.',
              value: _consentInactive,
              onChanged: (val) => setState(() => _consentInactive = val ?? false),
            ),
            const SizedBox(height: 18),
            const FormSectionHeader(title: 'Section G — Your agreement, simplified'),
            const Text(
              'Here\'s what you\'re agreeing to, in plain language. The full legal agreement — reviewed by our lawyer — is what actually governs your relationship with us; this is just an easy-to-read summary of it.',
              style: TextStyle(fontSize: 12.5, color: Colors.grey, height: 1.55),
            ),
            const SizedBox(height: 14),
            const CommissionCard(
              icon: '🪪',
              title: '1. Membership comes first',
              description: Text('You must already be a Udyami Bharat / FCMCSL member before you can apply to become a Channel Partner.'),
            ),
            const CommissionCard(
              icon: '📝',
              title: '2. How you get onboarded',
              description: Text('You apply through the CloudPatra Channel Partners app. Your Ward Chairman checks your application and either approves or rejects it — there\'s no payment at this stage.'),
            ),
            const CommissionCard(
              icon: '💰',
              title: '3. Fixed Deposit',
              description: Text.rich(TextSpan(children: [
                TextSpan(text: 'You pay '),
                TextSpan(text: 'the Fixed Deposit amount for each service', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                TextSpan(text: ' you\'re approved for. Due within 7 days of approval.'),
              ])),
            ),
            const CommissionCard(
              icon: '🎯',
              title: '4. What you earn',
              description: Text.rich(TextSpan(children: [
                TextSpan(text: 'A flat '),
                TextSpan(text: '3%', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                TextSpan(text: ' commission on every lead you bring in through your ward.'),
              ])),
            ),
            const CommissionCard(
              icon: '⚠️',
              title: '5. If things don\'t work out',
              description: Text('If you\'re consistently inefficient — for example, in acquiring genuine subscribers or completing KYC — we can end your Channel Partner status. You can also resign any time by giving 30 days\' notice.'),
            ),
            const CommissionCard(
              icon: '🔁',
              title: '6. Getting your Fixed Deposit back',
              description: Text.rich(TextSpan(children: [
                TextSpan(text: 'Whether you resign or are removed, your FD is returned within '),
                TextSpan(text: '30 days', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                TextSpan(text: ' through our bank. Or you can choose to '),
                TextSpan(text: 'leave it deposited', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                TextSpan(text: ' with us instead — even after you\'ve left.'),
              ])),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
              margin: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFBF6E9),
                border: Border.all(color: context.colors.orangeDark, width: 1.5, style: BorderStyle.none),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text('📄', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This summary simplifies the full Channel Partner Onboarding & Fixed Deposit Agreement. Read the complete legal text before accepting.',
                      style: TextStyle(fontSize: 11.3, color: Colors.brown.shade800, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const WarningNote(
              text: 'This is a simplified explanation for readability only. In case of any difference, the full legal agreement — not this summary — is what legally applies. Approval is at the sole discretion of your Ward Chairman.',
            ),
            FormCheckbox(
              text: 'I have read this summary and the full Channel Partner Onboarding & Fixed Deposit Agreement, and I agree to its terms.',
              value: _agreeSummary,
              onChanged: (val) => setState(() => _agreeSummary = val ?? false),
            ),
          ],
        );
      case 6:
        final catText = _selectedServices.isNotEmpty ? _selectedServices.join(', ') : 'No services selected';
        final wardText = _wardAppliedController.text.trim().isNotEmpty ? _wardAppliedController.text.trim() : 'no ward selected';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FormSectionHeader(title: 'Review'),
            CommissionCard(
              icon: '📋',
              title: 'Services & ward',
              description: Text('$catText — $wardText'),
            ),
            CommissionCard(
              icon: '💰',
              title: 'Fixed Deposit payable (after approval)',
              description: Text('₹$_totalFdAmount'),
            ),
            const CommissionCard(
              icon: '✅',
              title: 'Consent',
              description: Text('All declarations in Section F–G confirmed.'),
            ),
            const WarningNote(
              text: 'No payment now. By tapping Submit, your application goes straight to your Ward Chairman for approval.',
              isWarning: false,
            ),
            if (_isLoading) 
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0: return 'Your details';
      case 1: return 'Services & ward';
      case 2: return 'Business readiness';
      case 3: return 'Experience';
      case 4: return 'Deposit & earnings';
      case 5: return 'Consent';
      case 6: return 'Review & submit';
      default: return '';
    }
  }

  String _getStepSubtitle() {
    switch (_currentStep) {
      case 0: return 'Section A — Personal & Identity';
      case 1: return 'Section B — what you\'ll sell, and where';
      case 2: return 'Section C — your onboarding & KYC space';
      case 3: return 'Section D — operating capability';
      case 4: return 'Section E — Fixed Deposit and commission';
      case 5: return 'Section F & G — verification & declaration';
      case 6: return 'Check everything before sending';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormLayout(
      brandName: widget.companyName ?? 'Cloud Patra',
      currentStep: _currentStep,
      totalSteps: _totalSteps,
      stepTitle: _getStepTitle(),
      stepSubtitle: _getStepSubtitle(),
      onBack: _isLoading ? () {} : _onBack,
      onContinue: _isLoading ? () {} : _onContinue,
      continueText: _currentStep == _totalSteps - 1 ? 'Submit application' : 'Continue',
      body: _buildStepContent(),
    );
  }
}

