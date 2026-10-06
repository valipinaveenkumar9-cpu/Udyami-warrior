import 'package:flutter/material.dart';
import '../models/circlepac_survey_models.dart';

class VoterSummaryMetrics {
  final int totalVoters;
  final int supportersCount;
  final int opponentsCount;
  final int volunteerCount;
  final int undecidedCount;
  final int boothWorkerCount;
  final int missingPhoneEmailCount;
  final int inactiveCount;
  final int untaggedCount;

  const VoterSummaryMetrics({
    required this.totalVoters,
    required this.supportersCount,
    required this.opponentsCount,
    required this.volunteerCount,
    required this.undecidedCount,
    required this.boothWorkerCount,
    required this.missingPhoneEmailCount,
    required this.inactiveCount,
    required this.untaggedCount,
  });
}

class CirclepacMockRepository {
  static final CirclepacMockRepository _instance = CirclepacMockRepository._internal();
  factory CirclepacMockRepository() => _instance;

  final List<VoterRecord> _voters = [];
  final ValueNotifier<int> changeNotifier = ValueNotifier<int>(0);

  CirclepacMockRepository._internal() {
    _seedInitialVoters();
  }

  void _notify() {
    changeNotifier.value++;
  }

  void _seedInitialVoters() {
    _voters.addAll([
      VoterRecord(
        id: 'CP-VTR-1001',
        category: VoterCategory.supporters,
        isTagged: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        personal: PersonalInfoData(
          name: 'Ramesh Gowda',
          fatherName: 'Kempegowda',
          motherName: 'Ningamma',
          familySurname: 'Gowda',
          homeAddress: '#42, Temple Road, Pandavapura',
          mobileNumber: '9845012345',
          aadhaarNumber: 'XXXX-XXXX-8921',
          voterIdNumber: 'KA/04/082/019283',
          hasCasteCertificate: true,
          casteCertificateNumber: 'RD00382918',
          dob: '1984-06-12',
          age: '40',
          gender: 'Male',
          maritalStatus: 'Married',
          placeOfBirth: 'Mandya',
          ancestorBirthPlace: 'Mandya',
          nationality: 'Indian',
          religion: 'Hindu',
          casteSubcaste: 'Vokkaliga',
          casteCategory: 'OBC',
          bloodGroup: 'O+',
        ),
        family: FamilyInfoData(
          totalMembers: '5',
          spouseName: 'Lakshmi Gowda',
          spouseOccupation: 'Homemaker',
          fatherOccupation: 'Retired Farmer',
          motherOccupation: 'Homemaker',
          numberOfSiblings: '2',
          familyType: 'Nuclear',
          monthlyIncome: '₹40,000 - ₹60,000',
          rationCardType: 'BPL',
          ownsAgriculturalLand: true,
          hasFarmingIncome: true,
        ),
        geographic: GeographicInfoData(
          district: 'Mandya',
          talukMunicipality: 'Pandavapura',
          constituency: 'Pandavapura Assembly',
          wardNumber: 'Ward 4',
          areaType: 'Rural',
          houseOwnership: 'Owned',
          typeOfHouse: 'Pucca',
        ),
        contact: ContactHistoryData(
          primaryMobile: '9845012345',
          emailId: 'ramesh.gowda@gmail.com',
          whatsAppNumber: '9845012345',
          preferredCommMode: 'WhatsApp',
        ),
      ),
      VoterRecord(
        id: 'CP-VTR-1002',
        category: VoterCategory.volunteer,
        isTagged: true,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        personal: PersonalInfoData(
          name: 'Priya Sharma',
          fatherName: 'Anil Sharma',
          motherName: 'Sunita Sharma',
          familySurname: 'Sharma',
          homeAddress: 'Flat 302, Green Meadows, Ward 8',
          mobileNumber: '9880098765',
          aadhaarNumber: 'XXXX-XXXX-4532',
          voterIdNumber: 'KA/04/082/048291',
          dob: '1998-03-24',
          age: '26',
          gender: 'Female',
          maritalStatus: 'Unmarried',
          placeOfBirth: 'Bengaluru',
          nationality: 'Indian',
          religion: 'Hindu',
          casteCategory: 'General',
          bloodGroup: 'B+',
        ),
        education: EducationInfoData(
          highestEducation: 'Master\'s Degree',
          collegeUniversity: 'Mysore University',
          undergraduateMajor: 'Computer Applications',
          degreeEarned: 'MCA',
        ),
        geographic: GeographicInfoData(
          district: 'Mandya',
          wardNumber: 'Ward 8',
          areaType: 'Urban',
          houseOwnership: 'Owned',
          typeOfHouse: 'Pucca',
        ),
        contact: ContactHistoryData(
          primaryMobile: '9880098765',
          emailId: 'priya.sharma98@gmail.com',
          whatsAppNumber: '9880098765',
        ),
      ),
      VoterRecord(
        id: 'CP-VTR-1003',
        category: VoterCategory.boothWorker,
        isTagged: true,
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        personal: PersonalInfoData(
          name: 'Manjunath K',
          fatherName: 'Krishnappa',
          motherName: 'Kamalamma',
          homeAddress: 'Near Bus Stand, Ward 12',
          mobileNumber: '9740112233',
          aadhaarNumber: 'XXXX-XXXX-9912',
          voterIdNumber: 'KA/04/082/091823',
          dob: '1989-11-05',
          age: '35',
          gender: 'Male',
          maritalStatus: 'Married',
          placeOfBirth: 'Mandya',
          nationality: 'Indian',
          casteCategory: 'OBC',
          bloodGroup: 'A+',
        ),
        geographic: GeographicInfoData(
          district: 'Mandya',
          wardNumber: 'Ward 12',
          areaType: 'Semi-urban',
          houseOwnership: 'Owned',
        ),
        contact: ContactHistoryData(
          primaryMobile: '9740112233',
          emailId: 'manju.k@outlook.com',
          whatsAppNumber: '9740112233',
        ),
      ),
      VoterRecord(
        id: 'CP-VTR-1004',
        category: VoterCategory.undecided,
        isTagged: true,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        personal: PersonalInfoData(
          name: 'Syed Imran',
          fatherName: 'Syed Usman',
          motherName: 'Zainab Begum',
          homeAddress: 'Main Bazaar Road, Ward 2',
          mobileNumber: '9632055443',
          voterIdNumber: 'KA/04/082/038472',
          dob: '1992-08-19',
          age: '32',
          gender: 'Male',
          maritalStatus: 'Married',
          nationality: 'Indian',
          religion: 'Muslim',
          bloodGroup: 'AB+',
        ),
        geographic: GeographicInfoData(
          district: 'Mandya',
          wardNumber: 'Ward 2',
          areaType: 'Urban',
          houseOwnership: 'Rented',
        ),
        contact: ContactHistoryData(
          primaryMobile: '9632055443',
          emailId: 'syed.imran@yahoo.com',
          whatsAppNumber: '9632055443',
        ),
      ),
      VoterRecord(
        id: 'CP-VTR-1005',
        category: VoterCategory.opponents,
        isTagged: true,
        createdAt: DateTime.now().subtract(const Duration(days: 9)),
        personal: PersonalInfoData(
          name: 'Anand Murthy',
          fatherName: 'Narasimha Murthy',
          motherName: 'Girija',
          homeAddress: '#18, 4th Cross, Ward 6',
          mobileNumber: '9448066778',
          voterIdNumber: 'KA/04/082/011928',
          dob: '1975-01-14',
          age: '49',
          gender: 'Male',
          maritalStatus: 'Married',
          nationality: 'Indian',
          religion: 'Hindu',
          casteCategory: 'General',
          bloodGroup: 'O-',
        ),
        geographic: GeographicInfoData(
          district: 'Mandya',
          wardNumber: 'Ward 6',
          areaType: 'Urban',
          houseOwnership: 'Owned',
        ),
        contact: ContactHistoryData(
          primaryMobile: '9448066778',
          emailId: 'anand.murthy@gmail.com',
          whatsAppNumber: '9448066778',
        ),
      ),
      VoterRecord(
        id: 'CP-VTR-1006',
        category: VoterCategory.undecided,
        isTagged: false, // Untagged
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        personal: PersonalInfoData(
          name: 'Geetha Bai',
          fatherName: 'Shankar Nayak',
          homeAddress: 'Tanda Colony, Ward 15',
          mobileNumber: '', // Missing Phone
          voterIdNumber: 'KA/04/082/083726',
          dob: '1987-04-10',
          age: '37',
          gender: 'Female',
          casteCategory: 'ST',
        ),
        geographic: GeographicInfoData(
          district: 'Mandya',
          wardNumber: 'Ward 15',
          areaType: 'Rural',
        ),
        contact: ContactHistoryData(
          primaryMobile: '', // Missing
          emailId: '',       // Missing
        ),
      ),
    ]);
  }

  List<VoterRecord> getVoters({
    String? searchQuery,
    VoterCategory? categoryFilter,
    String? qualityFilter,
  }) {
    return _voters.where((v) {
      // Search filter
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.toLowerCase().trim();
        final matchesName = v.name.toLowerCase().contains(q);
        final matchesPhone = v.mobile.contains(q);
        final matchesVoterId = v.voterId.toLowerCase().contains(q);
        final matchesWard = v.ward.toLowerCase().contains(q);
        if (!matchesName && !matchesPhone && !matchesVoterId && !matchesWard) {
          return false;
        }
      }

      // Category filter
      if (categoryFilter != null && v.category != categoryFilter) {
        return false;
      }

      // Data quality filter
      if (qualityFilter != null && qualityFilter.isNotEmpty && qualityFilter != 'All') {
        if (qualityFilter == 'Missing Contact' && !v.hasMissingPhone && !v.hasMissingEmail) {
          return false;
        }
        if (qualityFilter == 'Untagged' && v.isTagged) {
          return false;
        }
        if (qualityFilter == 'Inactive' && !v.isInactive) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  VoterSummaryMetrics getSummaryMetrics() {
    int supporters = 0;
    int opponents = 0;
    int volunteer = 0;
    int undecided = 0;
    int boothWorker = 0;
    int missingPhoneEmail = 0;
    int inactive = 0;
    int untagged = 0;

    for (final v in _voters) {
      switch (v.category) {
        case VoterCategory.supporters:
          supporters++;
          break;
        case VoterCategory.opponents:
          opponents++;
          break;
        case VoterCategory.volunteer:
          volunteer++;
          break;
        case VoterCategory.undecided:
          undecided++;
          break;
        case VoterCategory.boothWorker:
          boothWorker++;
          break;
      }

      if (v.hasMissingPhone || v.hasMissingEmail) {
        missingPhoneEmail++;
      }
      if (v.isInactive) {
        inactive++;
      }
      if (!v.isTagged) {
        untagged++;
      }
    }

    return VoterSummaryMetrics(
      totalVoters: _voters.length,
      supportersCount: supporters,
      opponentsCount: opponents,
      volunteerCount: volunteer,
      undecidedCount: undecided,
      boothWorkerCount: boothWorker,
      missingPhoneEmailCount: missingPhoneEmail,
      inactiveCount: inactive,
      untaggedCount: untagged,
    );
  }

  VoterRecord? getVoterById(String id) {
    try {
      return _voters.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  void addVoter(VoterRecord voter) {
    _voters.insert(0, voter);
    _notify();
  }

  void updateVoter(VoterRecord updated) {
    final idx = _voters.indexWhere((v) => v.id == updated.id);
    if (idx != -1) {
      _voters[idx] = updated;
      _notify();
    }
  }

  void deleteVoter(String id) {
    _voters.removeWhere((v) => v.id == id);
    _notify();
  }

  /// Generates a realistic mock voter sample data for quick testing/filling all 162 questions
  VoterRecord generateDemoVoter({String? name}) {
    final sampleName = name ?? 'Chandrashekar Patil';
    return VoterRecord(
      id: 'CP-VTR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      category: VoterCategory.supporters,
      isTagged: true,
      personal: PersonalInfoData(
        name: sampleName,
        fatherName: 'Basavaraj Patil',
        motherName: 'Shantamma Patil',
        familySurname: 'Patil',
        homeAddress: '#108, Kuvempu Nagar, 2nd Main Road',
        mobileNumber: '9900112233',
        aadhaarNumber: '8921-4321-7788',
        voterIdNumber: 'KA/04/082/054321',
        hasCasteCertificate: true,
        casteCertificateNumber: 'RD00482910',
        dob: '1986-08-15',
        age: '38',
        gender: 'Male',
        maritalStatus: 'Married',
        placeOfBirth: 'Mandya',
        ancestorBirthPlace: 'Mandya District',
        nationality: 'Indian',
        religion: 'Hindu',
        casteSubcaste: 'Lingayat / Banajiga',
        casteCategory: 'OBC',
        bloodGroup: 'B+',
        hasDisabilityCertificate: false,
      ),
      family: FamilyInfoData(
        totalMembers: '4',
        spouseName: 'Sunita Patil',
        spouseOccupation: 'Teacher',
        fatherOccupation: 'Agriculturist',
        motherOccupation: 'Homemaker',
        numberOfSiblings: '1',
        familyType: 'Nuclear',
        hasWidow: false,
        hasUnemployed: false,
        hasDisabledMember: false,
        hasSeniorCitizens: true,
        childrenBelow6: '1',
        youths18to35: '1',
        monthlyIncome: '₹25,000 - ₹50,000',
        rationCardType: 'APL',
        ownsAncestralProperty: true,
        ownsAgriculturalLand: true,
        vehicleOwnership: const ['Bike', 'Car'],
        hasFarmingIncome: true,
        hasFamilyInPolitics: false,
        receivesGovtPension: false,
      ),
      education: EducationInfoData(
        highestEducation: 'Bachelor\'s Degree',
        highSchoolName: 'Govt High School, Pandavapura',
        collegeUniversity: 'PES College of Science & Arts',
        undergraduateMajor: 'Commerce (B.Com)',
        degreeEarned: 'Bachelor\'s Degree',
        literateMembersCount: '4',
        childrenAttendingSchool: true,
        schoolType: 'Private',
        hasSchoolDropouts: false,
        hasAcademicHonours: true,
        hasReceivedScholarship: true,
        extracurricularActivities: 'NSS & Sports Captain',
        professionalCertifications: 'Tally & GST Certified',
      ),
      geographic: GeographicInfoData(
        permanentAddress: '#108, Kuvempu Nagar, Pandavapura',
        presentAddress: '#108, Kuvempu Nagar, Pandavapura',
        district: 'Mandya',
        talukMunicipality: 'Pandavapura',
        constituency: 'Pandavapura Assembly (AC-82)',
        wardNumber: 'Ward 7',
        areaType: 'Semi-urban',
        houseOwnership: 'Owned',
        typeOfHouse: 'Pucca',
        landOwnedArea: '3.5 Acres',
        landType: 'Agricultural & Residential',
        nearestMajorCity: 'Mysuru (28 km)',
        drinkingWaterSource: 'Municipal Piped Water',
        hasToiletFacility: true,
        hasElectricityConnection: true,
        hasInternetMobileFacility: true,
        vehicleDetails: 'Honda Activa & Swift Dzire',
        distanceToHospital: '1.2 km',
        distanceToSchoolCollege: '800 m',
        isDisasterProne: false,
      ),
      socialMedia: SocialMediaInfoData(
        activePlatforms: const ['WhatsApp', 'Facebook', 'YouTube', 'Instagram'],
        primaryPlatform: 'WhatsApp',
        dailyHoursSpent: '1-2 hours',
        handlesUsernames: '@chandru_patil',
        followersCount: '1200',
        postingFrequency: 'Weekly',
        primaryContentType: 'Community news & family updates',
        profileVisibility: 'Private',
        experiencedCyberbullying: false,
        usesLinkedInNetworking: true,
        hasYoutubeOrBlog: false,
        onlineCommunities: 'Farmers Union, Ward Residents Forum',
        usesPaymentApps: true,
        shopsOnline: true,
        participatesInSurveys: true,
        usesAdsForWork: false,
        usesSocialMediaForPolitics: true,
        usesSocialMediaForNews: true,
        belongsToOnlineForums: true,
        personalWebsite: '',
      ),
      professional: ProfessionalInfoData(
        mainOccupation: 'Business & Agriculture',
        employmentType: 'Self-employed',
        employmentStatus: 'Self-employed',
        organisationName: 'Patil Agro Supplies & Logistics',
        natureOfBusiness: 'Fertilizers and Farm Equipment Trading',
        workSchedule: 'Full-time',
        paysIncomeTax: true,
        ownsBusinessOrStartup: true,
        employeesCount: '3',
        travelsForWork: true,
        workLocation: 'India',
        belongsToAssociation: true,
        attendsWorkshops: true,
        receivedAwards: true,
        jobSatisfaction: 'Satisfied',
        plansCareerChange: false,
      ),
      political: PoliticalInfoData(
        isRegisteredVoter: true,
        registeredVotersInHouse: '3',
        regularVoter: true,
        votedInLastElection: true,
        preferredParty: 'Progressive Development Party',
        attendsPoliticalRallies: true,
        hasPartyMembership: false,
        followsPoliticalNews: true,
        knowsMlaPersonally: true,
        knowsMpPersonally: false,
        volunteeredAsBoothWorker: true,
        discussesPolitics: true,
        hasContestedElections: false,
        supportsLeaderOverParty: true,
        hasDonatedToParty: false,
        plansActivePolitics: true,
        usesSocialMediaForPolitics: true,
        experiencedCasteDiscrimination: false,
        expectedSurveyBenefit: 'Transparent government welfare delivery & canal water assurance',
        belongsToSocialOrPoliticalOrg: true,
      ),
      contact: ContactHistoryData(
        primaryMobile: '9900112233',
        alternateMobile: '9844223344',
        emailId: 'chandrashekar.patil@gmail.com',
        whatsAppNumber: '9900112233',
        usesTelegramOrSignal: true,
        preferredCommMode: 'WhatsApp',
        isDndRegistered: false,
        answersSurveyCalls: true,
        sharesContactFreely: true,
        updatesContactOnAadhaarVoterList: true,
      ),
      donation: DonationContributionData(
        everDonated: true,
        donationFrequency: 'Yearly',
        averageDonationAmount: '₹5,000 - ₹10,000',
        donatesToReligious: true,
        donatesToPoliticalParties: false,
        donatesToNgos: true,
        donatesBlood: true,
        isOrganDonor: true,
        contributesToCrowdfunding: true,
        donatesDuringDisasters: true,
        donatesClothesItems: true,
        sponsorsPoorStudents: true,
        donatesToGovtFunds: true,
        supportsLocalEvents: true,
        donationVisibility: 'Public',
        getsReceipts: true,
        donationMode: 'Online (UPI)',
        donationScope: 'Within Community',
        donatesToEducation: true,
        willingToIncreaseDonations: true,
      ),
    );
  }
}
