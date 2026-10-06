import 'package:flutter/material.dart';
import '../../models/circlepac_survey_models.dart';
import '../../data/circlepac_mock_repository.dart';
import '../../theme/circlepac_colors.dart';
import '../widgets/survey_question_widgets.dart';

class CirclepacSurveyForm extends StatefulWidget {
  final VoterRecord? initialVoter;

  const CirclepacSurveyForm({super.key, this.initialVoter});

  @override
  State<CirclepacSurveyForm> createState() => _CirclepacSurveyFormState();
}

class _CirclepacSurveyFormState extends State<CirclepacSurveyForm> {
  int _currentStep = 0; // 0 to 8 (9 steps)
  final ScrollController _scrollController = ScrollController();

  // Voter data container
  late VoterRecord _voter;

  // Form Controllers for Step 1: Personal
  late TextEditingController _nameController;
  late TextEditingController _fatherNameController;
  late TextEditingController _motherNameController;
  late TextEditingController _familySurnameController;
  late TextEditingController _homeAddressController;
  late TextEditingController _mobileController;
  late TextEditingController _aadhaarController;
  late TextEditingController _voterIdController;
  late TextEditingController _casteCertNumberController;
  late TextEditingController _dobController;
  late TextEditingController _ageController;
  late TextEditingController _placeOfBirthController;
  late TextEditingController _ancestorBirthPlaceController;
  late TextEditingController _religionController;
  late TextEditingController _casteSubcasteController;

  // Form Controllers for Step 2: Family
  late TextEditingController _totalMembersController;
  late TextEditingController _spouseNameController;
  late TextEditingController _spouseOccupationController;
  late TextEditingController _fatherOccupationController;
  late TextEditingController _motherOccupationController;
  late TextEditingController _siblingsController;
  late TextEditingController _childrenBelow6Controller;
  late TextEditingController _youthsController;
  late TextEditingController _monthlyIncomeController;

  // Form Controllers for Step 3: Education
  late TextEditingController _highSchoolController;
  late TextEditingController _collegeController;
  late TextEditingController _majorController;
  late TextEditingController _literateCountController;
  late TextEditingController _extracurricularController;
  late TextEditingController _certificationsController;

  // Form Controllers for Step 4: Geographic
  late TextEditingController _permAddressController;
  late TextEditingController _presentAddressController;
  late TextEditingController _districtController;
  late TextEditingController _talukController;
  late TextEditingController _constituencyController;
  late TextEditingController _wardController;
  late TextEditingController _landAreaController;
  late TextEditingController _nearestCityController;
  late TextEditingController _waterSourceController;
  late TextEditingController _vehicleDetailsController;
  late TextEditingController _hospitalDistController;
  late TextEditingController _schoolDistController;

  // Form Controllers for Step 5: Social Media
  late TextEditingController _handlesController;
  late TextEditingController _followersController;
  late TextEditingController _onlineCommunitiesController;
  late TextEditingController _personalWebsiteController;

  // Form Controllers for Step 6: Professional
  late TextEditingController _mainOccupationController;
  late TextEditingController _orgNameController;
  late TextEditingController _businessNatureController;
  late TextEditingController _employeesCountController;

  // Form Controllers for Step 7: Political
  late TextEditingController _registeredVotersInHouseController;
  late TextEditingController _preferredPartyController;
  late TextEditingController _expectedSurveyBenefitController;

  // Form Controllers for Step 8: Contact
  late TextEditingController _altMobileController;
  late TextEditingController _emailController;
  late TextEditingController _whatsAppController;

  // Form Controllers for Step 9: Donation
  late TextEditingController _avgDonationAmountController;

  final Set<String> _validationErrors = {};

  final List<String> _stepTitles = [
    'Personal Info',
    'Family Info',
    'Education',
    'Geographic',
    'Social Media',
    'Professional',
    'Political',
    'Contact History',
    'Donation & Tag',
  ];

  @override
  void initState() {
    super.initState();
    _voter = widget.initialVoter ?? CirclepacMockRepository().generateDemoVoter();
    _initControllers();
  }

  void _initControllers() {
    // Step 1
    _nameController = TextEditingController(text: _voter.personal.name);
    _fatherNameController = TextEditingController(text: _voter.personal.fatherName);
    _motherNameController = TextEditingController(text: _voter.personal.motherName);
    _familySurnameController = TextEditingController(text: _voter.personal.familySurname);
    _homeAddressController = TextEditingController(text: _voter.personal.homeAddress);
    _mobileController = TextEditingController(text: _voter.personal.mobileNumber);
    _aadhaarController = TextEditingController(text: _voter.personal.aadhaarNumber);
    _voterIdController = TextEditingController(text: _voter.personal.voterIdNumber);
    _casteCertNumberController = TextEditingController(text: _voter.personal.casteCertificateNumber);
    _dobController = TextEditingController(text: _voter.personal.dob);
    _ageController = TextEditingController(text: _voter.personal.age);
    _placeOfBirthController = TextEditingController(text: _voter.personal.placeOfBirth);
    _ancestorBirthPlaceController = TextEditingController(text: _voter.personal.ancestorBirthPlace);
    _religionController = TextEditingController(text: _voter.personal.religion);
    _casteSubcasteController = TextEditingController(text: _voter.personal.casteSubcaste);

    // Step 2
    _totalMembersController = TextEditingController(text: _voter.family.totalMembers);
    _spouseNameController = TextEditingController(text: _voter.family.spouseName);
    _spouseOccupationController = TextEditingController(text: _voter.family.spouseOccupation);
    _fatherOccupationController = TextEditingController(text: _voter.family.fatherOccupation);
    _motherOccupationController = TextEditingController(text: _voter.family.motherOccupation);
    _siblingsController = TextEditingController(text: _voter.family.numberOfSiblings);
    _childrenBelow6Controller = TextEditingController(text: _voter.family.childrenBelow6);
    _youthsController = TextEditingController(text: _voter.family.youths18to35);
    _monthlyIncomeController = TextEditingController(text: _voter.family.monthlyIncome);

    // Step 3
    _highSchoolController = TextEditingController(text: _voter.education.highSchoolName);
    _collegeController = TextEditingController(text: _voter.education.collegeUniversity);
    _majorController = TextEditingController(text: _voter.education.undergraduateMajor);
    _literateCountController = TextEditingController(text: _voter.education.literateMembersCount);
    _extracurricularController = TextEditingController(text: _voter.education.extracurricularActivities);
    _certificationsController = TextEditingController(text: _voter.education.professionalCertifications);

    // Step 4
    _permAddressController = TextEditingController(text: _voter.geographic.permanentAddress);
    _presentAddressController = TextEditingController(text: _voter.geographic.presentAddress);
    _districtController = TextEditingController(text: _voter.geographic.district);
    _talukController = TextEditingController(text: _voter.geographic.talukMunicipality);
    _constituencyController = TextEditingController(text: _voter.geographic.constituency);
    _wardController = TextEditingController(text: _voter.geographic.wardNumber);
    _landAreaController = TextEditingController(text: _voter.geographic.landOwnedArea);
    _nearestCityController = TextEditingController(text: _voter.geographic.nearestMajorCity);
    _waterSourceController = TextEditingController(text: _voter.geographic.drinkingWaterSource);
    _vehicleDetailsController = TextEditingController(text: _voter.geographic.vehicleDetails);
    _hospitalDistController = TextEditingController(text: _voter.geographic.distanceToHospital);
    _schoolDistController = TextEditingController(text: _voter.geographic.distanceToSchoolCollege);

    // Step 5
    _handlesController = TextEditingController(text: _voter.socialMedia.handlesUsernames);
    _followersController = TextEditingController(text: _voter.socialMedia.followersCount);
    _onlineCommunitiesController = TextEditingController(text: _voter.socialMedia.onlineCommunities);
    _personalWebsiteController = TextEditingController(text: _voter.socialMedia.personalWebsite);

    // Step 6
    _mainOccupationController = TextEditingController(text: _voter.professional.mainOccupation);
    _orgNameController = TextEditingController(text: _voter.professional.organisationName);
    _businessNatureController = TextEditingController(text: _voter.professional.natureOfBusiness);
    _employeesCountController = TextEditingController(text: _voter.professional.employeesCount);

    // Step 7
    _registeredVotersInHouseController = TextEditingController(text: _voter.political.registeredVotersInHouse);
    _preferredPartyController = TextEditingController(text: _voter.political.preferredParty);
    _expectedSurveyBenefitController = TextEditingController(text: _voter.political.expectedSurveyBenefit);

    // Step 8
    _altMobileController = TextEditingController(text: _voter.contact.alternateMobile);
    _emailController = TextEditingController(text: _voter.contact.emailId);
    _whatsAppController = TextEditingController(text: _voter.contact.whatsAppNumber);

    // Step 9
    _avgDonationAmountController = TextEditingController(text: _voter.donation.averageDonationAmount);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // Step 1
    _nameController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _familySurnameController.dispose();
    _homeAddressController.dispose();
    _mobileController.dispose();
    _aadhaarController.dispose();
    _voterIdController.dispose();
    _casteCertNumberController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    _placeOfBirthController.dispose();
    _ancestorBirthPlaceController.dispose();
    _religionController.dispose();
    _casteSubcasteController.dispose();
    // Step 2
    _totalMembersController.dispose();
    _spouseNameController.dispose();
    _spouseOccupationController.dispose();
    _fatherOccupationController.dispose();
    _motherOccupationController.dispose();
    _siblingsController.dispose();
    _childrenBelow6Controller.dispose();
    _youthsController.dispose();
    _monthlyIncomeController.dispose();
    // Step 3
    _highSchoolController.dispose();
    _collegeController.dispose();
    _majorController.dispose();
    _literateCountController.dispose();
    _extracurricularController.dispose();
    _certificationsController.dispose();
    // Step 4
    _permAddressController.dispose();
    _presentAddressController.dispose();
    _districtController.dispose();
    _talukController.dispose();
    _constituencyController.dispose();
    _wardController.dispose();
    _landAreaController.dispose();
    _nearestCityController.dispose();
    _waterSourceController.dispose();
    _vehicleDetailsController.dispose();
    _hospitalDistController.dispose();
    _schoolDistController.dispose();
    // Step 5
    _handlesController.dispose();
    _followersController.dispose();
    _onlineCommunitiesController.dispose();
    _personalWebsiteController.dispose();
    // Step 6
    _mainOccupationController.dispose();
    _orgNameController.dispose();
    _businessNatureController.dispose();
    _employeesCountController.dispose();
    // Step 7
    _registeredVotersInHouseController.dispose();
    _preferredPartyController.dispose();
    _expectedSurveyBenefitController.dispose();
    // Step 8
    _altMobileController.dispose();
    _emailController.dispose();
    _whatsAppController.dispose();
    // Step 9
    _avgDonationAmountController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _loadDemoData() {
    setState(() {
      _voter = CirclepacMockRepository().generateDemoVoter(name: 'Chandrashekar Patil (Demo)');
      _initControllers();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Populated demo responses for all 9 survey sections!'),
        backgroundColor: CirclepacColors.primaryGreen,
      ),
    );
  }

  void _syncCurrentControllers() {
    // Sync Step 1
    _voter.personal.name = _nameController.text.trim();
    _voter.personal.fatherName = _fatherNameController.text.trim();
    _voter.personal.motherName = _motherNameController.text.trim();
    _voter.personal.familySurname = _familySurnameController.text.trim();
    _voter.personal.homeAddress = _homeAddressController.text.trim();
    _voter.personal.mobileNumber = _mobileController.text.trim();
    _voter.personal.aadhaarNumber = _aadhaarController.text.trim();
    _voter.personal.voterIdNumber = _voterIdController.text.trim();
    _voter.personal.casteCertificateNumber = _casteCertNumberController.text.trim();
    _voter.personal.dob = _dobController.text.trim();
    _voter.personal.age = _ageController.text.trim();
    _voter.personal.placeOfBirth = _placeOfBirthController.text.trim();
    _voter.personal.ancestorBirthPlace = _ancestorBirthPlaceController.text.trim();
    _voter.personal.religion = _religionController.text.trim();
    _voter.personal.casteSubcaste = _casteSubcasteController.text.trim();

    // Sync Step 2
    _voter.family.totalMembers = _totalMembersController.text.trim();
    _voter.family.spouseName = _spouseNameController.text.trim();
    _voter.family.spouseOccupation = _spouseOccupationController.text.trim();
    _voter.family.fatherOccupation = _fatherOccupationController.text.trim();
    _voter.family.motherOccupation = _motherOccupationController.text.trim();
    _voter.family.numberOfSiblings = _siblingsController.text.trim();
    _voter.family.childrenBelow6 = _childrenBelow6Controller.text.trim();
    _voter.family.youths18to35 = _youthsController.text.trim();
    _voter.family.monthlyIncome = _monthlyIncomeController.text.trim();

    // Sync Step 3
    _voter.education.highSchoolName = _highSchoolController.text.trim();
    _voter.education.collegeUniversity = _collegeController.text.trim();
    _voter.education.undergraduateMajor = _majorController.text.trim();
    _voter.education.literateMembersCount = _literateCountController.text.trim();
    _voter.education.extracurricularActivities = _extracurricularController.text.trim();
    _voter.education.professionalCertifications = _certificationsController.text.trim();

    // Sync Step 4
    _voter.geographic.permanentAddress = _permAddressController.text.trim();
    _voter.geographic.presentAddress = _presentAddressController.text.trim();
    _voter.geographic.district = _districtController.text.trim();
    _voter.geographic.talukMunicipality = _talukController.text.trim();
    _voter.geographic.constituency = _constituencyController.text.trim();
    _voter.geographic.wardNumber = _wardController.text.trim();
    _voter.geographic.landOwnedArea = _landAreaController.text.trim();
    _voter.geographic.nearestMajorCity = _nearestCityController.text.trim();
    _voter.geographic.drinkingWaterSource = _waterSourceController.text.trim();
    _voter.geographic.vehicleDetails = _vehicleDetailsController.text.trim();
    _voter.geographic.distanceToHospital = _hospitalDistController.text.trim();
    _voter.geographic.distanceToSchoolCollege = _schoolDistController.text.trim();

    // Sync Step 5
    _voter.socialMedia.handlesUsernames = _handlesController.text.trim();
    _voter.socialMedia.followersCount = _followersController.text.trim();
    _voter.socialMedia.onlineCommunities = _onlineCommunitiesController.text.trim();
    _voter.socialMedia.personalWebsite = _personalWebsiteController.text.trim();

    // Sync Step 6
    _voter.professional.mainOccupation = _mainOccupationController.text.trim();
    _voter.professional.organisationName = _orgNameController.text.trim();
    _voter.professional.natureOfBusiness = _businessNatureController.text.trim();
    _voter.professional.employeesCount = _employeesCountController.text.trim();

    // Sync Step 7
    _voter.political.registeredVotersInHouse = _registeredVotersInHouseController.text.trim();
    _voter.political.preferredParty = _preferredPartyController.text.trim();
    _voter.political.expectedSurveyBenefit = _expectedSurveyBenefitController.text.trim();

    // Sync Step 8
    _voter.contact.primaryMobile = _mobileController.text.trim();
    _voter.contact.alternateMobile = _altMobileController.text.trim();
    _voter.contact.emailId = _emailController.text.trim();
    _voter.contact.whatsAppNumber = _whatsAppController.text.trim().isNotEmpty
        ? _whatsAppController.text.trim()
        : _mobileController.text.trim();

    // Sync Step 9
    _voter.donation.averageDonationAmount = _avgDonationAmountController.text.trim();
  }

  bool _validateCurrentStep() {
    _validationErrors.clear();
    _syncCurrentControllers();

    if (_currentStep == 0) {
      if (_nameController.text.trim().isEmpty) {
        _validationErrors.add('Name is required');
      }
      if (_mobileController.text.trim().isEmpty) {
        _validationErrors.add('Mobile number is required');
      }
      if (_voterIdController.text.trim().isEmpty) {
        _validationErrors.add('Voter ID number is required');
      }
    }

    if (_validationErrors.isNotEmpty) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_validationErrors.first),
          backgroundColor: CirclepacColors.errorRed,
        ),
      );
      return false;
    }
    return true;
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < 8) {
        setState(() {
          _currentStep++;
        });
        _scrollToTop();
      } else {
        _submitSurvey();
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _syncCurrentControllers();
      setState(() {
        _currentStep--;
      });
      _scrollToTop();
    }
  }

  void _saveDraft() {
    _syncCurrentControllers();
    CirclepacMockRepository().updateVoter(_voter);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Survey draft saved to local database.'),
        backgroundColor: CirclepacColors.primaryGreen,
      ),
    );
  }

  void _submitSurvey() {
    _syncCurrentControllers();
    CirclepacMockRepository().addVoter(_voter);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: CirclepacColors.activeGreenBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: CirclepacColors.primaryGreen, size: 44),
            ),
            const SizedBox(height: 12),
            const Text(
              'Survey Submitted!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CirclepacColors.primaryDark),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Voter record for ${_voter.name} has been successfully recorded and tagged as ${_voter.category.label}.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13.5, color: CirclepacColors.textBody, height: 1.4),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _voter.category.bgColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _voter.category.borderColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.label, color: _voter.category.color, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Category: ${_voter.category.label}',
                    style: TextStyle(fontWeight: FontWeight.bold, color: _voter.category.color, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // dismiss dialog
              // Reset for another entry
              setState(() {
                _voter = CirclepacMockRepository().generateDemoVoter(name: '');
                _currentStep = 0;
                _initControllers();
              });
              _scrollToTop();
            },
            child: const Text('Add Another', style: TextStyle(color: CirclepacColors.primaryDark)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // dismiss dialog
              Navigator.pop(context); // back to voter database
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CirclepacColors.primaryGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Go to Voter List', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pct = ((_currentStep + 1) / 9);

    return Scaffold(
      backgroundColor: CirclepacColors.pageBg,
      appBar: AppBar(
        backgroundColor: CirclepacColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CIRCLEPAC',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.5),
            ),
            Text(
              'Add Voter Details · Survey Form',
              style: TextStyle(fontSize: 11, color: Color(0xFFD1FAE5)),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: _loadDemoData,
            icon: const Icon(Icons.flash_on, color: Color(0xFFFEF08A), size: 16),
            label: const Text(
              'Fill Sample',
              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Step Progress Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'STEP ${_currentStep + 1}/9 · ${_stepTitles[_currentStep].toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: CirclepacColors.primaryGreen,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      '${(pct * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: CirclepacColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: CirclepacColors.borderLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(CirclepacColors.primaryGreen),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 10),
                // Horizontal Step Navigator Pills
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(9, (index) {
                      final isActive = index == _currentStep;
                      final isPast = index < _currentStep;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: InkWell(
                          onTap: () {
                            if (_validateCurrentStep()) {
                              setState(() => _currentStep = index);
                              _scrollToTop();
                            }
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? CirclepacColors.primaryGreen
                                  : isPast
                                      ? CirclepacColors.activeGreenBg
                                      : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isActive
                                    ? CirclepacColors.primaryGreen
                                    : isPast
                                        ? CirclepacColors.activeGreenBorder
                                        : CirclepacColors.borderLight,
                              ),
                            ),
                            child: Row(
                              children: [
                                if (isPast)
                                  const Icon(Icons.check, size: 12, color: CirclepacColors.primaryGreen)
                                else
                                  Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isActive ? Colors.white : CirclepacColors.textMuted,
                                    ),
                                  ),
                                const SizedBox(width: 4),
                                Text(
                                  _stepTitles[index],
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                                    color: isActive
                                        ? Colors.white
                                        : isPast
                                            ? CirclepacColors.primaryGreen
                                            : CirclepacColors.textBody,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          // Main Step Form Content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: _buildCurrentStepContent(),
            ),
          ),

          // Bottom Navigation Controls
          _buildFooterButtons(),
        ],
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1Personal();
      case 1:
        return _buildStep2Family();
      case 2:
        return _buildStep3Education();
      case 3:
        return _buildStep4Geographic();
      case 4:
        return _buildStep5SocialMedia();
      case 5:
        return _buildStep6Professional();
      case 6:
        return _buildStep7Political();
      case 7:
        return _buildStep8Contact();
      case 8:
        return _buildStep9Donation();
      default:
        return const SizedBox.shrink();
    }
  }

  // -------------------------------------------------------------
  // STEP 1: PERSONAL INFORMATION (22 Questions)
  // -------------------------------------------------------------
  Widget _buildStep1Personal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CirclepacSectionHeader(
          stepNumber: '1 of 9',
          title: 'Personal Information',
          subtitle: 'Basic demographic and identity details of the voter.',
        ),
        CirclepacTextField(label: '1. Full Name', hint: 'Enter full name', controller: _nameController, isRequired: true, prefixIcon: Icons.person_outline),
        CirclepacTextField(label: '2. Father\'s Name', hint: 'Enter father\'s name', controller: _fatherNameController),
        CirclepacTextField(label: '3. Mother\'s Name', hint: 'Enter mother\'s name', controller: _motherNameController),
        CirclepacTextField(label: '4. Family Surname', hint: 'Enter surname / family title', controller: _familySurnameController),
        CirclepacTextField(label: '5. Home Address', hint: 'Door no, street, locality', controller: _homeAddressController, maxLines: 2),
        CirclepacTextField(label: '6. Mobile Number', hint: '10 digit mobile number', controller: _mobileController, keyboardType: TextInputType.phone, isRequired: true, prefixIcon: Icons.phone_outlined),
        CirclepacTextField(label: '7. Aadhaar Number', hint: 'XXXX-XXXX-XXXX', controller: _aadhaarController, keyboardType: TextInputType.number),
        CirclepacTextField(label: '8. Voter ID Number (EPIC)', hint: 'e.g. ABC1234567', controller: _voterIdController, isRequired: true, prefixIcon: Icons.badge_outlined),
        CirclepacSwitchField(
          title: '9. Do you possess a Caste Certificate?',
          subtitle: 'Government issued caste verification document',
          value: _voter.personal.hasCasteCertificate,
          onChanged: (val) => setState(() => _voter.personal.hasCasteCertificate = val),
        ),
        if (_voter.personal.hasCasteCertificate)
          CirclepacTextField(label: '10. Caste Certificate Number', hint: 'e.g. RD001234567', controller: _casteCertNumberController),
        CirclepacTextField(label: '11. Date of Birth (YYYY-MM-DD)', hint: '1990-05-15', controller: _dobController),
        CirclepacTextField(label: '12. Age (in years)', hint: 'e.g. 34', controller: _ageController, keyboardType: TextInputType.number),
        CirclepacRadioCards<String>(
          label: '13. Gender',
          isRequired: true,
          options: const ['Male', 'Female', 'Other'],
          selectedValue: _voter.personal.gender,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.personal.gender = val),
        ),
        CirclepacRadioCards<String>(
          label: '14. Marital Status',
          options: const ['Married', 'Unmarried', 'Divorced', 'Separated'],
          selectedValue: _voter.personal.maritalStatus,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.personal.maritalStatus = val),
        ),
        CirclepacTextField(label: '15. Place of Birth', hint: 'Village / City / Taluk', controller: _placeOfBirthController),
        CirclepacTextField(label: '16. Ancestor Birth Place', hint: 'Ancestral roots location', controller: _ancestorBirthPlaceController),
        CirclepacTextField(label: '17. What is your nationality?', hint: 'Indian', controller: TextEditingController(text: _voter.personal.nationality), onChanged: (v) => _voter.personal.nationality = v),
        CirclepacTextField(label: '18. Religion', hint: 'e.g. Hindu, Muslim, Christian, Jain', controller: _religionController),
        CirclepacTextField(label: '19. Caste / Sub-caste', hint: 'Specific caste or community identity', controller: _casteSubcasteController),
        CirclepacRadioCards<String>(
          label: '20. Caste Category',
          options: const ['SC', 'ST', 'OBC', 'General', 'Other'],
          selectedValue: _voter.personal.casteCategory,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.personal.casteCategory = val),
        ),
        CirclepacDropdownField<String>(
          label: '21. Blood Group',
          items: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', 'Unknown'],
          value: _voter.personal.bloodGroup,
          itemLabel: (s) => s,
          onChanged: (val) => setState(() => _voter.personal.bloodGroup = val ?? 'O+'),
        ),
        CirclepacSwitchField(
          title: '22. Do you have a disability certificate?',
          subtitle: 'Certified by medical board',
          value: _voter.personal.hasDisabilityCertificate,
          onChanged: (val) => setState(() => _voter.personal.hasDisabilityCertificate = val),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // STEP 2: FAMILY INFORMATION (21 Questions)
  // -------------------------------------------------------------
  Widget _buildStep2Family() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CirclepacSectionHeader(
          stepNumber: '2 of 9',
          title: 'Family Information',
          subtitle: 'Household composition, livelihoods, and socioeconomic status.',
        ),
        CirclepacTextField(label: '1. Total Family Members', hint: 'e.g. 5', controller: _totalMembersController, keyboardType: TextInputType.number),
        CirclepacTextField(label: '2. Spouse\'s Name', hint: 'Full name of spouse', controller: _spouseNameController),
        CirclepacTextField(label: '3. Spouse\'s Occupation', hint: 'e.g. Homemaker, Teacher, Business', controller: _spouseOccupationController),
        CirclepacTextField(label: '4. Father\'s Occupation', hint: 'e.g. Farmer, Retired Govt Servant', controller: _fatherOccupationController),
        CirclepacTextField(label: '5. Mother\'s Occupation', hint: 'e.g. Homemaker, Anganwadi worker', controller: _motherOccupationController),
        CirclepacTextField(label: '6. Number of Siblings', hint: 'e.g. 2', controller: _siblingsController, keyboardType: TextInputType.number),
        CirclepacRadioCards<String>(
          label: '7. Nuclear or Joint Family?',
          options: const ['Nuclear', 'Joint'],
          selectedValue: _voter.family.familyType,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.family.familyType = val),
        ),
        CirclepacSwitchField(
          title: '8. Any widow in the household?',
          value: _voter.family.hasWidow,
          onChanged: (val) => setState(() => _voter.family.hasWidow = val),
        ),
        CirclepacSwitchField(
          title: '9. Any unemployed members?',
          value: _voter.family.hasUnemployed,
          onChanged: (val) => setState(() => _voter.family.hasUnemployed = val),
        ),
        CirclepacSwitchField(
          title: '10. Any person with disability in household?',
          value: _voter.family.hasDisabledMember,
          onChanged: (val) => setState(() => _voter.family.hasDisabledMember = val),
        ),
        CirclepacSwitchField(
          title: '11. Any senior citizens (60+)?',
          value: _voter.family.hasSeniorCitizens,
          onChanged: (val) => setState(() => _voter.family.hasSeniorCitizens = val),
        ),
        CirclepacTextField(label: '12. Number of children below 6 years', hint: 'e.g. 1', controller: _childrenBelow6Controller, keyboardType: TextInputType.number),
        CirclepacTextField(label: '13. Number of youths (18–35 years)', hint: 'e.g. 2', controller: _youthsController, keyboardType: TextInputType.number),
        CirclepacDropdownField<String>(
          label: '14. Family Monthly Income',
          items: const [
            'Below ₹10,000',
            '₹10,000 - ₹25,000',
            '₹25,000 - ₹50,000',
            '₹50,000 - ₹1,00,000',
            'Above ₹1,00,000',
          ],
          value: _voter.family.monthlyIncome,
          itemLabel: (s) => s,
          onChanged: (val) => setState(() => _voter.family.monthlyIncome = val ?? ''),
        ),
        CirclepacRadioCards<String>(
          label: '15. Does your family have a ration card?',
          options: const ['APL', 'BPL', 'Antyodaya', 'None'],
          selectedValue: _voter.family.rationCardType,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.family.rationCardType = val),
        ),
        CirclepacSwitchField(
          title: '16. Does your family own ancestral property?',
          value: _voter.family.ownsAncestralProperty,
          onChanged: (val) => setState(() => _voter.family.ownsAncestralProperty = val),
        ),
        CirclepacSwitchField(
          title: '17. Do you own agricultural land?',
          value: _voter.family.ownsAgriculturalLand,
          onChanged: (val) => setState(() => _voter.family.ownsAgriculturalLand = val),
        ),
        CirclepacMultiSelectChips(
          label: '18. Family Vehicle Ownership',
          allOptions: const ['Cycle', 'Bike', 'Car', 'Tractor', 'Auto', 'Commercial Vehicle'],
          selectedOptions: _voter.family.vehicleOwnership,
          onChanged: (val) => setState(() => _voter.family.vehicleOwnership = val),
        ),
        CirclepacSwitchField(
          title: '19. Livestock or farming as income source?',
          value: _voter.family.hasFarmingIncome,
          onChanged: (val) => setState(() => _voter.family.hasFarmingIncome = val),
        ),
        CirclepacSwitchField(
          title: '20. Family member in politics/social service?',
          value: _voter.family.hasFamilyInPolitics,
          onChanged: (val) => setState(() => _voter.family.hasFamilyInPolitics = val),
        ),
        CirclepacSwitchField(
          title: '21. Benefits from government pensions/subsidies?',
          value: _voter.family.receivesGovtPension,
          onChanged: (val) => setState(() => _voter.family.receivesGovtPension = val),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // STEP 3: EDUCATION (13 Questions)
  // -------------------------------------------------------------
  Widget _buildStep3Education() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CirclepacSectionHeader(
          stepNumber: '3 of 9',
          title: 'Education',
          subtitle: 'Educational background, literacy, and school participation.',
        ),
        CirclepacDropdownField<String>(
          label: '1. Highest Level of Education Completed',
          items: const [
            'No Formal Education',
            'Primary School (1-5)',
            'High School (SSLC / 10th)',
            'Pre-University (PUC / 12th)',
            'Diploma / ITI',
            'Bachelor\'s Degree',
            'Master\'s Degree',
            'Doctorate / Ph.D.',
            'Professional Degree (Law/CA/Med/Engg)',
          ],
          value: _voter.education.highestEducation,
          itemLabel: (s) => s,
          onChanged: (val) => setState(() => _voter.education.highestEducation = val ?? ''),
        ),
        CirclepacTextField(label: '2. Name of High School', hint: 'School name & town', controller: _highSchoolController),
        CirclepacTextField(label: '3. College / University Attended', hint: 'e.g. Mysore University', controller: _collegeController),
        CirclepacTextField(label: '4. Undergraduate Major / Field of Study', hint: 'e.g. B.A. History, B.Com, B.Sc, B.E.', controller: _majorController),
        CirclepacDropdownField<String>(
          label: '5. Degree(s) Earned',
          items: const ['Associate', 'Bachelor\'s', 'Master\'s', 'Doctorate', 'Professional degree', 'None'],
          value: _voter.education.degreeEarned,
          itemLabel: (s) => s,
          onChanged: (val) => setState(() => _voter.education.degreeEarned = val ?? ''),
        ),
        CirclepacTextField(label: '6. How many in household can read/write?', hint: 'e.g. 4', controller: _literateCountController, keyboardType: TextInputType.number),
        CirclepacSwitchField(
          title: '7. Are children attending school?',
          value: _voter.education.childrenAttendingSchool,
          onChanged: (val) => setState(() => _voter.education.childrenAttendingSchool = val),
        ),
        CirclepacRadioCards<String>(
          label: '8. Type of School',
          options: const ['Government', 'Private', 'Aided', 'Not Applicable'],
          selectedValue: _voter.education.schoolType,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.education.schoolType = val),
        ),
        CirclepacSwitchField(
          title: '9. Are there school dropouts in the family?',
          value: _voter.education.hasSchoolDropouts,
          onChanged: (val) => setState(() => _voter.education.hasSchoolDropouts = val),
        ),
        CirclepacSwitchField(
          title: '10. Academic honours, awards, or distinctions?',
          value: _voter.education.hasAcademicHonours,
          onChanged: (val) => setState(() => _voter.education.hasAcademicHonours = val),
        ),
        CirclepacSwitchField(
          title: '11. Have you received a scholarship?',
          value: _voter.education.hasReceivedScholarship,
          onChanged: (val) => setState(() => _voter.education.hasReceivedScholarship = val),
        ),
        CirclepacTextField(label: '12. Extracurricular activities or student orgs', hint: 'e.g. NCC, NSS, Sports, Union', controller: _extracurricularController),
        CirclepacTextField(label: '13. Professional certifications or licenses', hint: 'e.g. Tally, Electrician License', controller: _certificationsController),
      ],
    );
  }

  // -------------------------------------------------------------
  // STEP 4: GEOGRAPHIC INFORMATION (20 Questions)
  // -------------------------------------------------------------
  Widget _buildStep4Geographic() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CirclepacSectionHeader(
          stepNumber: '4 of 9',
          title: 'Geographic Information',
          subtitle: 'Location, habitat, public utilities, and living environment.',
        ),
        CirclepacTextField(label: '1. Permanent Address', hint: 'As in native record', controller: _permAddressController, maxLines: 2),
        CirclepacTextField(label: '2. Present Residential Address', hint: 'Current residence', controller: _presentAddressController, maxLines: 2),
        CirclepacTextField(label: '3. District', hint: 'e.g. Mandya', controller: _districtController),
        CirclepacTextField(label: '4. Taluk / Municipality', hint: 'e.g. Pandavapura', controller: _talukController),
        CirclepacTextField(label: '5. Constituency (Assembly / Parliament)', hint: 'e.g. Pandavapura Assembly', controller: _constituencyController),
        CirclepacTextField(label: '6. Ward Number (if urban)', hint: 'e.g. Ward 7', controller: _wardController),
        CirclepacRadioCards<String>(
          label: '7. Area Type',
          options: const ['Urban', 'Semi-urban', 'Rural'],
          selectedValue: _voter.geographic.areaType,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.geographic.areaType = val),
        ),
        CirclepacRadioCards<String>(
          label: '8. House Ownership',
          options: const ['Owned', 'Rented', 'Leased', 'Family'],
          selectedValue: _voter.geographic.houseOwnership,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.geographic.houseOwnership = val),
        ),
        CirclepacRadioCards<String>(
          label: '9. Type of House',
          options: const ['Pucca', 'Kutcha', 'Semi-pucca'],
          selectedValue: _voter.geographic.typeOfHouse,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.geographic.typeOfHouse = val),
        ),
        CirclepacTextField(label: '10. Land Owned (Total Area)', hint: 'e.g. 2.5 Acres / 1200 sqft', controller: _landAreaController),
        CirclepacRadioCards<String>(
          label: '11. Land Classification',
          options: const ['Agricultural', 'Residential', 'Commercial', 'None'],
          selectedValue: _voter.geographic.landType,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.geographic.landType = val),
        ),
        CirclepacTextField(label: '12. Nearest Major City or Metro Area', hint: 'e.g. Mysuru / Bengaluru', controller: _nearestCityController),
        CirclepacTextField(label: '13. Source of Drinking Water', hint: 'e.g. Tap / Borewell / RO plant', controller: _waterSourceController),
        CirclepacSwitchField(
          title: '14. Toilet facility available inside house?',
          value: _voter.geographic.hasToiletFacility,
          onChanged: (val) => setState(() => _voter.geographic.hasToiletFacility = val),
        ),
        CirclepacSwitchField(
          title: '15. Electricity connection available?',
          value: _voter.geographic.hasElectricityConnection,
          onChanged: (val) => setState(() => _voter.geographic.hasElectricityConnection = val),
        ),
        CirclepacSwitchField(
          title: '16. Internet / Mobile data facility available?',
          value: _voter.geographic.hasInternetMobileFacility,
          onChanged: (val) => setState(() => _voter.geographic.hasInternetMobileFacility = val),
        ),
        CirclepacTextField(label: '17. Vehicle Ownership Details', hint: 'Specific models/types', controller: _vehicleDetailsController),
        CirclepacTextField(label: '18. Distance to Nearest Hospital', hint: 'e.g. 2.5 km', controller: _hospitalDistController),
        CirclepacTextField(label: '19. Distance to Nearest School / College', hint: 'e.g. 1 km', controller: _schoolDistController),
        CirclepacSwitchField(
          title: '20. Is the area flood-prone or drought-prone?',
          value: _voter.geographic.isDisasterProne,
          onChanged: (val) => setState(() => _voter.geographic.isDisasterProne = val),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // STEP 5: SOCIAL MEDIA & COMMUNICATION (20 Questions)
  // -------------------------------------------------------------
  Widget _buildStep5SocialMedia() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CirclepacSectionHeader(
          stepNumber: '5 of 9',
          title: 'Social Media & Communication',
          subtitle: 'Digital footprint, connectivity, online awareness, and channels.',
        ),
        CirclepacMultiSelectChips(
          label: '1. Which social media platforms do you actively use?',
          allOptions: const [
            'WhatsApp', 'Facebook', 'Instagram', 'Twitter/X', 'YouTube',
            'LinkedIn', 'Snapchat', 'Telegram', 'Reddit', 'Pinterest',
          ],
          selectedOptions: _voter.socialMedia.activePlatforms,
          onChanged: (val) => setState(() => _voter.socialMedia.activePlatforms = val),
        ),
        CirclepacDropdownField<String>(
          label: '2. Primary Social Media Platform',
          items: const ['WhatsApp', 'Facebook', 'Instagram', 'YouTube', 'Twitter/X', 'LinkedIn', 'None'],
          value: _voter.socialMedia.primaryPlatform,
          itemLabel: (s) => s,
          onChanged: (val) => setState(() => _voter.socialMedia.primaryPlatform = val ?? 'WhatsApp'),
        ),
        CirclepacDropdownField<String>(
          label: '3. Hours spent per day on social media',
          items: const ['Less than 1 hour', '1-2 hours', '2-4 hours', 'More than 4 hours'],
          value: _voter.socialMedia.dailyHoursSpent,
          itemLabel: (s) => s,
          onChanged: (val) => setState(() => _voter.socialMedia.dailyHoursSpent = val ?? '1-2 hours'),
        ),
        CirclepacTextField(label: '4. Social media usernames / handles', hint: 'e.g. @handle_name', controller: _handlesController),
        CirclepacTextField(label: '5. Followers / friends count on primary platform', hint: 'e.g. 500+', controller: _followersController),
        CirclepacRadioCards<String>(
          label: '6. How often do you post content?',
          options: const ['Multiple times daily', 'Daily', 'Weekly', 'Monthly', 'Rarely'],
          selectedValue: _voter.socialMedia.postingFrequency,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.socialMedia.postingFrequency = val),
        ),
        CirclepacTextField(label: '7. What type of content do you primarily share?', hint: 'News, personal updates, agriculture, memes', controller: TextEditingController(text: _voter.socialMedia.primaryContentType), onChanged: (v) => _voter.socialMedia.primaryContentType = v),
        CirclepacRadioCards<String>(
          label: '8. Profile Privacy',
          options: const ['Public', 'Private'],
          selectedValue: _voter.socialMedia.profileVisibility,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.socialMedia.profileVisibility = val),
        ),
        CirclepacSwitchField(
          title: '9. Experienced cyberbullying or online harassment?',
          value: _voter.socialMedia.experiencedCyberbullying,
          onChanged: (val) => setState(() => _voter.socialMedia.experiencedCyberbullying = val),
        ),
        CirclepacSwitchField(
          title: '10. Use LinkedIn for professional networking?',
          value: _voter.socialMedia.usesLinkedInNetworking,
          onChanged: (val) => setState(() => _voter.socialMedia.usesLinkedInNetworking = val),
        ),
        CirclepacSwitchField(
          title: '11. Do you have a YouTube channel / blog / page?',
          value: _voter.socialMedia.hasYoutubeOrBlog,
          onChanged: (val) => setState(() => _voter.socialMedia.hasYoutubeOrBlog = val),
        ),
        CirclepacTextField(label: '12. Online communities or forums engaged in', hint: 'Community groups, welfare forums', controller: _onlineCommunitiesController),
        CirclepacSwitchField(
          title: '13. Use apps for online payments (UPI, GPay, Paytm)?',
          value: _voter.socialMedia.usesPaymentApps,
          onChanged: (val) => setState(() => _voter.socialMedia.usesPaymentApps = val),
        ),
        CirclepacSwitchField(
          title: '14. Do you shop online regularly?',
          value: _voter.socialMedia.shopsOnline,
          onChanged: (val) => setState(() => _voter.socialMedia.shopsOnline = val),
        ),
        CirclepacSwitchField(
          title: '15. Participate in online surveys or polls?',
          value: _voter.socialMedia.participatesInSurveys,
          onChanged: (val) => setState(() => _voter.socialMedia.participatesInSurveys = val),
        ),
        CirclepacSwitchField(
          title: '16. Use social media ads/promotions for work?',
          value: _voter.socialMedia.usesAdsForWork,
          onChanged: (val) => setState(() => _voter.socialMedia.usesAdsForWork = val),
        ),
        CirclepacSwitchField(
          title: '17. Use social media for political awareness?',
          value: _voter.socialMedia.usesSocialMediaForPolitics,
          onChanged: (val) => setState(() => _voter.socialMedia.usesSocialMediaForPolitics = val),
        ),
        CirclepacSwitchField(
          title: '18. Use social media for news updates?',
          value: _voter.socialMedia.usesSocialMediaForNews,
          onChanged: (val) => setState(() => _voter.socialMedia.usesSocialMediaForNews = val),
        ),
        CirclepacSwitchField(
          title: '19. Belong to online citizen / voter communities?',
          value: _voter.socialMedia.belongsToOnlineForums,
          onChanged: (val) => setState(() => _voter.socialMedia.belongsToOnlineForums = val),
        ),
        CirclepacTextField(label: '20. Personal Website / Portfolio URL', hint: 'e.g. https://profile.com', controller: _personalWebsiteController),
      ],
    );
  }

  // -------------------------------------------------------------
  // STEP 6: PROFESSIONAL INFORMATION (16 Questions)
  // -------------------------------------------------------------
  Widget _buildStep6Professional() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CirclepacSectionHeader(
          stepNumber: '6 of 9',
          title: 'Professional Information',
          subtitle: 'Employment, sector, taxation, and occupational standing.',
        ),
        CirclepacTextField(label: '1. Main Occupation of Household', hint: 'e.g. Agriculture, Business, Service', controller: _mainOccupationController),
        CirclepacRadioCards<String>(
          label: '2. Type of Employment',
          options: const ['Government', 'Private', 'Self-employed', 'Unemployed'],
          selectedValue: _voter.professional.employmentType,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.professional.employmentType = val),
        ),
        CirclepacRadioCards<String>(
          label: '3. Employment Status',
          options: const ['Salaried', 'Self-employed', 'Daily Wage', 'Contract'],
          selectedValue: _voter.professional.employmentStatus,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.professional.employmentStatus = val),
        ),
        CirclepacTextField(label: '4. Name of the Organisation / Employer', hint: 'e.g. Self / Firm Name', controller: _orgNameController),
        CirclepacTextField(label: '5. Nature of Business / Work', hint: 'e.g. Retail, Agro Processing', controller: _businessNatureController),
        CirclepacRadioCards<String>(
          label: '6. Work Schedule',
          options: const ['Full-time', 'Part-time', 'Seasonal'],
          selectedValue: _voter.professional.workSchedule,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.professional.workSchedule = val),
        ),
        CirclepacSwitchField(
          title: '7. Do you pay income tax?',
          value: _voter.professional.paysIncomeTax,
          onChanged: (val) => setState(() => _voter.professional.paysIncomeTax = val),
        ),
        CirclepacSwitchField(
          title: '8. Do you own a business or start-up?',
          value: _voter.professional.ownsBusinessOrStartup,
          onChanged: (val) => setState(() => _voter.professional.ownsBusinessOrStartup = val),
        ),
        CirclepacTextField(label: '9. If yes, how many people do you employ?', hint: 'e.g. 3', controller: _employeesCountController, keyboardType: TextInputType.number),
        CirclepacSwitchField(
          title: '10. Do you travel frequently for work?',
          value: _voter.professional.travelsForWork,
          onChanged: (val) => setState(() => _voter.professional.travelsForWork = val),
        ),
        CirclepacRadioCards<String>(
          label: '11. Work Location',
          options: const ['India', 'Abroad', 'Both'],
          selectedValue: _voter.professional.workLocation,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.professional.workLocation = val),
        ),
        CirclepacSwitchField(
          title: '12. Belong to a professional or trade association?',
          value: _voter.professional.belongsToAssociation,
          onChanged: (val) => setState(() => _voter.professional.belongsToAssociation = val),
        ),
        CirclepacSwitchField(
          title: '13. Attend skill workshops or conferences?',
          value: _voter.professional.attendsWorkshops,
          onChanged: (val) => setState(() => _voter.professional.attendsWorkshops = val),
        ),
        CirclepacSwitchField(
          title: '14. Received occupational awards or recognitions?',
          value: _voter.professional.receivedAwards,
          onChanged: (val) => setState(() => _voter.professional.receivedAwards = val),
        ),
        CirclepacRadioCards<String>(
          label: '15. Satisfaction with current profession',
          options: const ['Satisfied', 'Neutral', 'Dissatisfied'],
          selectedValue: _voter.professional.jobSatisfaction,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.professional.jobSatisfaction = val),
        ),
        CirclepacSwitchField(
          title: '16. Plan to change career in future?',
          value: _voter.professional.plansCareerChange,
          onChanged: (val) => setState(() => _voter.professional.plansCareerChange = val),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // STEP 7: POLITICAL INFORMATION (20 Questions)
  // -------------------------------------------------------------
  Widget _buildStep7Political() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CirclepacSectionHeader(
          stepNumber: '7 of 9',
          title: 'Political Information',
          subtitle: 'Civic participation, political engagement, and public affairs.',
        ),
        CirclepacSwitchField(
          title: '1. Are you a registered voter?',
          value: _voter.political.isRegisteredVoter,
          onChanged: (val) => setState(() => _voter.political.isRegisteredVoter = val),
        ),
        CirclepacTextField(label: '2. Registered voters in household', hint: 'e.g. 4', controller: _registeredVotersInHouseController, keyboardType: TextInputType.number),
        CirclepacSwitchField(
          title: '3. Do you regularly vote in elections?',
          value: _voter.political.regularVoter,
          onChanged: (val) => setState(() => _voter.political.regularVoter = val),
        ),
        CirclepacSwitchField(
          title: '4. Did you vote in the last election?',
          value: _voter.political.votedInLastElection,
          onChanged: (val) => setState(() => _voter.political.votedInLastElection = val),
        ),
        CirclepacTextField(label: '5. Which party / platform do you generally support?', hint: 'e.g. Progressive Coalition', controller: _preferredPartyController),
        CirclepacSwitchField(
          title: '6. Do you attend political rallies?',
          value: _voter.political.attendsPoliticalRallies,
          onChanged: (val) => setState(() => _voter.political.attendsPoliticalRallies = val),
        ),
        CirclepacSwitchField(
          title: '7. Have you been a member of a political party?',
          value: _voter.political.hasPartyMembership,
          onChanged: (val) => setState(() => _voter.political.hasPartyMembership = val),
        ),
        CirclepacSwitchField(
          title: '8. Do you follow political news regularly?',
          value: _voter.political.followsPoliticalNews,
          onChanged: (val) => setState(() => _voter.political.followsPoliticalNews = val),
        ),
        CirclepacSwitchField(
          title: '9. Do you know your MLA personally?',
          value: _voter.political.knowsMlaPersonally,
          onChanged: (val) => setState(() => _voter.political.knowsMlaPersonally = val),
        ),
        CirclepacSwitchField(
          title: '10. Do you know your MP personally?',
          value: _voter.political.knowsMpPersonally,
          onChanged: (val) => setState(() => _voter.political.knowsMpPersonally = val),
        ),
        CirclepacSwitchField(
          title: '11. Volunteered as polling agent / booth worker?',
          value: _voter.political.volunteeredAsBoothWorker,
          onChanged: (val) => setState(() => _voter.political.volunteeredAsBoothWorker = val),
        ),
        CirclepacSwitchField(
          title: '12. Discuss politics socially or at home?',
          value: _voter.political.discussesPolitics,
          onChanged: (val) => setState(() => _voter.political.discussesPolitics = val),
        ),
        CirclepacSwitchField(
          title: '13. Contested any election (Panchayat / Student)?',
          value: _voter.political.hasContestedElections,
          onChanged: (val) => setState(() => _voter.political.hasContestedElections = val),
        ),
        CirclepacSwitchField(
          title: '14. Do you support a leader over a party?',
          value: _voter.political.supportsLeaderOverParty,
          onChanged: (val) => setState(() => _voter.political.supportsLeaderOverParty = val),
        ),
        CirclepacSwitchField(
          title: '15. Have you donated to a political party?',
          value: _voter.political.hasDonatedToParty,
          onChanged: (val) => setState(() => _voter.political.hasDonatedToParty = val),
        ),
        CirclepacSwitchField(
          title: '16. Plan to participate actively in politics?',
          value: _voter.political.plansActivePolitics,
          onChanged: (val) => setState(() => _voter.political.plansActivePolitics = val),
        ),
        CirclepacSwitchField(
          title: '17. Use social media for political expression?',
          value: _voter.political.usesSocialMediaForPolitics,
          onChanged: (val) => setState(() => _voter.political.usesSocialMediaForPolitics = val),
        ),
        CirclepacSwitchField(
          title: '18. Have you experienced discrimination?',
          value: _voter.political.experiencedCasteDiscrimination,
          onChanged: (val) => setState(() => _voter.political.experiencedCasteDiscrimination = val),
        ),
        CirclepacTextField(label: '19. What benefit do you expect from survey?', hint: 'Better roads, welfare transparency, jobs', controller: _expectedSurveyBenefitController),
        CirclepacSwitchField(
          title: '20. Part of a social or community organisation?',
          value: _voter.political.belongsToSocialOrPoliticalOrg,
          onChanged: (val) => setState(() => _voter.political.belongsToSocialOrPoliticalOrg = val),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // STEP 8: CONTACT HISTORY (10 Questions)
  // -------------------------------------------------------------
  Widget _buildStep8Contact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CirclepacSectionHeader(
          stepNumber: '8 of 9',
          title: 'Contact History',
          subtitle: 'Reachability, communication preferences, and contact hygiene.',
        ),
        CirclepacTextField(label: '1. Primary Mobile Number', hint: '10 digit number', controller: _mobileController, keyboardType: TextInputType.phone, isRequired: true),
        CirclepacTextField(label: '2. Alternate Contact Number', hint: 'Secondary phone number', controller: _altMobileController, keyboardType: TextInputType.phone),
        CirclepacTextField(label: '3. Email Address', hint: 'name@domain.com', controller: _emailController, keyboardType: TextInputType.emailAddress),
        CirclepacTextField(label: '4. WhatsApp Number', hint: 'Active WhatsApp number', controller: _whatsAppController, keyboardType: TextInputType.phone),
        CirclepacSwitchField(
          title: '5. Do you use Telegram or Signal?',
          value: _voter.contact.usesTelegramOrSignal,
          onChanged: (val) => setState(() => _voter.contact.usesTelegramOrSignal = val),
        ),
        CirclepacRadioCards<String>(
          label: '6. Preferred Communication Mode',
          options: const ['WhatsApp', 'Phone Call', 'SMS', 'In Person'],
          selectedValue: _voter.contact.preferredCommMode,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.contact.preferredCommMode = val),
        ),
        CirclepacSwitchField(
          title: '7. Registered on DND (Do Not Disturb)?',
          value: _voter.contact.isDndRegistered,
          onChanged: (val) => setState(() => _voter.contact.isDndRegistered = val),
        ),
        CirclepacSwitchField(
          title: '8. Do you answer survey calls?',
          value: _voter.contact.answersSurveyCalls,
          onChanged: (val) => setState(() => _voter.contact.answersSurveyCalls = val),
        ),
        CirclepacSwitchField(
          title: '9. Share contact with social orgs freely?',
          value: _voter.contact.sharesContactFreely,
          onChanged: (val) => setState(() => _voter.contact.sharesContactFreely = val),
        ),
        CirclepacSwitchField(
          title: '10. Update contact on voter list and Aadhaar?',
          value: _voter.contact.updatesContactOnAadhaarVoterList,
          onChanged: (val) => setState(() => _voter.contact.updatesContactOnAadhaarVoterList = val),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // STEP 9: DONATION & CONTRIBUTION + CATEGORY TAG (20 Questions)
  // -------------------------------------------------------------
  Widget _buildStep9Donation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CirclepacSectionHeader(
          stepNumber: '9 of 9',
          title: 'Donation & Final Tagging',
          subtitle: 'Philanthropic habits and final voter categorization assignment.',
        ),

        // VOTER CATEGORY SELECTOR CARD (Prominent)
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CirclepacColors.primaryGreen, width: 1.8),
            boxShadow: [
              BoxShadow(
                color: CirclepacColors.primaryGreen.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.how_to_reg, color: CirclepacColors.primaryGreen, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Assign Voter Category *',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: CirclepacColors.primaryDark),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Classify this voter based on survey sentiment and interactions:',
                style: TextStyle(fontSize: 12.5, color: CirclepacColors.textBody),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: VoterCategory.values.map((cat) {
                  final isSelected = cat == _voter.category;
                  return InkWell(
                    onTap: () => setState(() => _voter.category = cat),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? cat.bgColor : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? cat.color : CirclepacColors.borderCol,
                          width: isSelected ? 2.0 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSelected ? Icons.check_circle : Icons.circle_outlined,
                            size: 16,
                            color: isSelected ? cat.color : CirclepacColors.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            cat.label,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? cat.color : CirclepacColors.primaryDark,
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
        ),

        CirclepacSwitchField(
          title: '1. Have you ever donated to charity?',
          value: _voter.donation.everDonated,
          onChanged: (val) => setState(() => _voter.donation.everDonated = val),
        ),
        CirclepacRadioCards<String>(
          label: '2. How often do you donate?',
          options: const ['Monthly', 'Yearly', 'Occasionally', 'Never'],
          selectedValue: _voter.donation.donationFrequency,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.donation.donationFrequency = val),
        ),
        CirclepacTextField(label: '3. Average donation amount (per occasion)', hint: 'e.g. ₹1,000 - ₹5,000', controller: _avgDonationAmountController),
        CirclepacSwitchField(
          title: '4. Do you donate to religious institutions?',
          value: _voter.donation.donatesToReligious,
          onChanged: (val) => setState(() => _voter.donation.donatesToReligious = val),
        ),
        CirclepacSwitchField(
          title: '5. Do you donate to political parties?',
          value: _voter.donation.donatesToPoliticalParties,
          onChanged: (val) => setState(() => _voter.donation.donatesToPoliticalParties = val),
        ),
        CirclepacSwitchField(
          title: '6. Do you donate to NGOs?',
          value: _voter.donation.donatesToNgos,
          onChanged: (val) => setState(() => _voter.donation.donatesToNgos = val),
        ),
        CirclepacSwitchField(
          title: '7. Do you donate blood?',
          value: _voter.donation.donatesBlood,
          onChanged: (val) => setState(() => _voter.donation.donatesBlood = val),
        ),
        CirclepacSwitchField(
          title: '8. Have you registered as an organ donor?',
          value: _voter.donation.isOrganDonor,
          onChanged: (val) => setState(() => _voter.donation.isOrganDonor = val),
        ),
        CirclepacSwitchField(
          title: '9. Contribute to crowdfunding campaigns?',
          value: _voter.donation.contributesToCrowdfunding,
          onChanged: (val) => setState(() => _voter.donation.contributesToCrowdfunding = val),
        ),
        CirclepacSwitchField(
          title: '10. Do you donate during disaster relief?',
          value: _voter.donation.donatesDuringDisasters,
          onChanged: (val) => setState(() => _voter.donation.donatesDuringDisasters = val),
        ),
        CirclepacSwitchField(
          title: '11. Do you donate old clothes and items?',
          value: _voter.donation.donatesClothesItems,
          onChanged: (val) => setState(() => _voter.donation.donatesClothesItems = val),
        ),
        CirclepacSwitchField(
          title: '12. Do you sponsor poor students?',
          value: _voter.donation.sponsorsPoorStudents,
          onChanged: (val) => setState(() => _voter.donation.sponsorsPoorStudents = val),
        ),
        CirclepacSwitchField(
          title: '13. Donate to government relief funds?',
          value: _voter.donation.donatesToGovtFunds,
          onChanged: (val) => setState(() => _voter.donation.donatesToGovtFunds = val),
        ),
        CirclepacSwitchField(
          title: '14. Support local community events financially?',
          value: _voter.donation.supportsLocalEvents,
          onChanged: (val) => setState(() => _voter.donation.supportsLocalEvents = val),
        ),
        CirclepacRadioCards<String>(
          label: '15. Donation Visibility',
          options: const ['Anonymous', 'Public', 'Both'],
          selectedValue: _voter.donation.donationVisibility,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.donation.donationVisibility = val),
        ),
        CirclepacSwitchField(
          title: '16. Do you get receipts for donations?',
          value: _voter.donation.getsReceipts,
          onChanged: (val) => setState(() => _voter.donation.getsReceipts = val),
        ),
        CirclepacRadioCards<String>(
          label: '17. Donation Mode',
          options: const ['Online (UPI/Card)', 'Offline (Cash)', 'Both'],
          selectedValue: _voter.donation.donationMode,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.donation.donationMode = val),
        ),
        CirclepacRadioCards<String>(
          label: '18. Donation Scope',
          options: const ['Within Community', 'Outside Community', 'Both'],
          selectedValue: _voter.donation.donationScope,
          optionLabel: (s) => s,
          onSelected: (val) => setState(() => _voter.donation.donationScope = val),
        ),
        CirclepacSwitchField(
          title: '19. Regular donations for educational causes?',
          value: _voter.donation.donatesToEducation,
          onChanged: (val) => setState(() => _voter.donation.donatesToEducation = val),
        ),
        CirclepacSwitchField(
          title: '20. Willing to increase donations in future?',
          value: _voter.donation.willingToIncreaseDonations,
          onChanged: (val) => setState(() => _voter.donation.willingToIncreaseDonations = val),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // FOOTER BUTTONS
  // -------------------------------------------------------------
  Widget _buildFooterButtons() {
    final isLast = _currentStep == 8;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: _prevStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    side: const BorderSide(color: CirclepacColors.borderCol),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Previous', style: TextStyle(color: CirclepacColors.primaryDark, fontWeight: FontWeight.bold)),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: _saveDraft,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  side: const BorderSide(color: CirclepacColors.primaryGreen),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Save Draft', style: TextStyle(color: CirclepacColors.primaryGreen, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CirclepacColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  isLast ? 'Submit Voter Survey' : 'Next Section →',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
