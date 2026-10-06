import 'package:flutter/material.dart';
import '../theme/circlepac_colors.dart';

/// Voter categories for classification and segmentation
enum VoterCategory {
  supporters,
  opponents,
  volunteer,
  undecided,
  boothWorker;

  String get label {
    switch (this) {
      case VoterCategory.supporters:
        return 'Supporter';
      case VoterCategory.opponents:
        return 'Opponent';
      case VoterCategory.volunteer:
        return 'Volunteer';
      case VoterCategory.undecided:
        return 'Undecided';
      case VoterCategory.boothWorker:
        return 'Booth Worker';
    }
  }

  String get pluralLabel {
    switch (this) {
      case VoterCategory.supporters:
        return 'Supporters';
      case VoterCategory.opponents:
        return 'Opponents';
      case VoterCategory.volunteer:
        return 'Volunteers';
      case VoterCategory.undecided:
        return 'Undecided';
      case VoterCategory.boothWorker:
        return 'Booth Workers';
    }
  }

  Color get color {
    switch (this) {
      case VoterCategory.supporters:
        return CirclepacColors.supporterGreen;
      case VoterCategory.opponents:
        return CirclepacColors.opponentRed;
      case VoterCategory.volunteer:
        return CirclepacColors.volunteerBlue;
      case VoterCategory.undecided:
        return CirclepacColors.undecidedAmber;
      case VoterCategory.boothWorker:
        return CirclepacColors.boothWorkerPurple;
    }
  }

  Color get bgColor {
    switch (this) {
      case VoterCategory.supporters:
        return CirclepacColors.supporterBg;
      case VoterCategory.opponents:
        return CirclepacColors.opponentBg;
      case VoterCategory.volunteer:
        return CirclepacColors.volunteerBg;
      case VoterCategory.undecided:
        return CirclepacColors.undecidedBg;
      case VoterCategory.boothWorker:
        return CirclepacColors.boothWorkerBg;
    }
  }

  Color get borderColor {
    switch (this) {
      case VoterCategory.supporters:
        return CirclepacColors.supporterBorder;
      case VoterCategory.opponents:
        return CirclepacColors.opponentBorder;
      case VoterCategory.volunteer:
        return CirclepacColors.volunteerBorder;
      case VoterCategory.undecided:
        return CirclepacColors.undecidedBorder;
      case VoterCategory.boothWorker:
        return CirclepacColors.boothWorkerBorder;
    }
  }
}

/// 1. Personal Information (22 questions)
class PersonalInfoData {
  String name;
  String fatherName;
  String motherName;
  String familySurname;
  String homeAddress;
  String mobileNumber;
  String aadhaarNumber;
  String voterIdNumber;
  bool hasCasteCertificate;
  String casteCertificateNumber;
  String dob;
  String age;
  String gender; // Male / Female / Other
  String maritalStatus; // Married / Unmarried / Divorced / Separated
  String placeOfBirth;
  String ancestorBirthPlace;
  String nationality;
  String religion;
  String casteSubcaste;
  String casteCategory; // SC / ST / OBC / General / Other
  String bloodGroup;
  bool hasDisabilityCertificate;

  PersonalInfoData({
    this.name = '',
    this.fatherName = '',
    this.motherName = '',
    this.familySurname = '',
    this.homeAddress = '',
    this.mobileNumber = '',
    this.aadhaarNumber = '',
    this.voterIdNumber = '',
    this.hasCasteCertificate = false,
    this.casteCertificateNumber = '',
    this.dob = '',
    this.age = '',
    this.gender = 'Male',
    this.maritalStatus = 'Married',
    this.placeOfBirth = '',
    this.ancestorBirthPlace = '',
    this.nationality = 'Indian',
    this.religion = 'Hindu',
    this.casteSubcaste = '',
    this.casteCategory = 'OBC',
    this.bloodGroup = 'O+',
    this.hasDisabilityCertificate = false,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'fatherName': fatherName,
    'motherName': motherName,
    'familySurname': familySurname,
    'homeAddress': homeAddress,
    'mobileNumber': mobileNumber,
    'aadhaarNumber': aadhaarNumber,
    'voterIdNumber': voterIdNumber,
    'hasCasteCertificate': hasCasteCertificate,
    'casteCertificateNumber': casteCertificateNumber,
    'dob': dob,
    'age': age,
    'gender': gender,
    'maritalStatus': maritalStatus,
    'placeOfBirth': placeOfBirth,
    'ancestorBirthPlace': ancestorBirthPlace,
    'nationality': nationality,
    'religion': religion,
    'casteSubcaste': casteSubcaste,
    'casteCategory': casteCategory,
    'bloodGroup': bloodGroup,
    'hasDisabilityCertificate': hasDisabilityCertificate,
  };
}

/// 2. Family Information (21 questions)
class FamilyInfoData {
  String totalMembers;
  String spouseName;
  String spouseOccupation;
  String fatherOccupation;
  String motherOccupation;
  String numberOfSiblings;
  String familyType; // Nuclear / Joint
  bool hasWidow;
  bool hasUnemployed;
  bool hasDisabledMember;
  bool hasSeniorCitizens;
  String childrenBelow6;
  String youths18to35;
  String monthlyIncome;
  String rationCardType; // APL / BPL / Antyodaya / None
  bool ownsAncestralProperty;
  bool ownsAgriculturalLand;
  List<String> vehicleOwnership; // Cycle / Bike / Car / Tractor / Other
  bool hasFarmingIncome;
  bool hasFamilyInPolitics;
  bool receivesGovtPension;

  FamilyInfoData({
    this.totalMembers = '4',
    this.spouseName = '',
    this.spouseOccupation = '',
    this.fatherOccupation = '',
    this.motherOccupation = '',
    this.numberOfSiblings = '2',
    this.familyType = 'Nuclear',
    this.hasWidow = false,
    this.hasUnemployed = false,
    this.hasDisabledMember = false,
    this.hasSeniorCitizens = false,
    this.childrenBelow6 = '0',
    this.youths18to35 = '2',
    this.monthlyIncome = '₹25,000 - ₹50,000',
    this.rationCardType = 'BPL',
    this.ownsAncestralProperty = true,
    this.ownsAgriculturalLand = true,
    this.vehicleOwnership = const ['Bike'],
    this.hasFarmingIncome = true,
    this.hasFamilyInPolitics = false,
    this.receivesGovtPension = false,
  });

  Map<String, dynamic> toMap() => {
    'totalMembers': totalMembers,
    'spouseName': spouseName,
    'spouseOccupation': spouseOccupation,
    'fatherOccupation': fatherOccupation,
    'motherOccupation': motherOccupation,
    'numberOfSiblings': numberOfSiblings,
    'familyType': familyType,
    'hasWidow': hasWidow,
    'hasUnemployed': hasUnemployed,
    'hasDisabledMember': hasDisabledMember,
    'hasSeniorCitizens': hasSeniorCitizens,
    'childrenBelow6': childrenBelow6,
    'youths18to35': youths18to35,
    'monthlyIncome': monthlyIncome,
    'rationCardType': rationCardType,
    'ownsAncestralProperty': ownsAncestralProperty,
    'ownsAgriculturalLand': ownsAgriculturalLand,
    'vehicleOwnership': vehicleOwnership,
    'hasFarmingIncome': hasFarmingIncome,
    'hasFamilyInPolitics': hasFamilyInPolitics,
    'receivesGovtPension': receivesGovtPension,
  };
}

/// 3. Education (13 questions)
class EducationInfoData {
  String highestEducation;
  String highSchoolName;
  String collegeUniversity;
  String undergraduateMajor;
  String degreeEarned;
  String literateMembersCount;
  bool childrenAttendingSchool;
  String schoolType; // Government / Private
  bool hasSchoolDropouts;
  bool hasAcademicHonours;
  bool hasReceivedScholarship;
  String extracurricularActivities;
  String professionalCertifications;

  EducationInfoData({
    this.highestEducation = 'Bachelor\'s Degree',
    this.highSchoolName = '',
    this.collegeUniversity = '',
    this.undergraduateMajor = '',
    this.degreeEarned = 'Bachelor\'s',
    this.literateMembersCount = '4',
    this.childrenAttendingSchool = true,
    this.schoolType = 'Government',
    this.hasSchoolDropouts = false,
    this.hasAcademicHonours = false,
    this.hasReceivedScholarship = true,
    this.extracurricularActivities = 'Sports / NCC',
    this.professionalCertifications = '',
  });

  Map<String, dynamic> toMap() => {
    'highestEducation': highestEducation,
    'highSchoolName': highSchoolName,
    'collegeUniversity': collegeUniversity,
    'undergraduateMajor': undergraduateMajor,
    'degreeEarned': degreeEarned,
    'literateMembersCount': literateMembersCount,
    'childrenAttendingSchool': childrenAttendingSchool,
    'schoolType': schoolType,
    'hasSchoolDropouts': hasSchoolDropouts,
    'hasAcademicHonours': hasAcademicHonours,
    'hasReceivedScholarship': hasReceivedScholarship,
    'extracurricularActivities': extracurricularActivities,
    'professionalCertifications': professionalCertifications,
  };
}

/// 4. Geographic Information (20 questions)
class GeographicInfoData {
  String permanentAddress;
  String presentAddress;
  String district;
  String talukMunicipality;
  String constituency;
  String wardNumber;
  String areaType; // Urban / Semi-urban / Rural
  String houseOwnership; // Owned / Rented
  String typeOfHouse; // Pucca / Kutcha
  String landOwnedArea;
  String landType; // Agricultural / Residential
  String nearestMajorCity;
  String drinkingWaterSource;
  bool hasToiletFacility;
  bool hasElectricityConnection;
  bool hasInternetMobileFacility;
  String vehicleDetails;
  String distanceToHospital;
  String distanceToSchoolCollege;
  bool isDisasterProne; // Flood/drought prone

  GeographicInfoData({
    this.permanentAddress = '',
    this.presentAddress = '',
    this.district = 'Mandya',
    this.talukMunicipality = 'Pandavapura',
    this.constituency = 'Pandavapura Assembly',
    this.wardNumber = 'Ward 12',
    this.areaType = 'Semi-urban',
    this.houseOwnership = 'Owned',
    this.typeOfHouse = 'Pucca',
    this.landOwnedArea = '2.5 Acres',
    this.landType = 'Agricultural',
    this.nearestMajorCity = 'Mysuru',
    this.drinkingWaterSource = 'Piped water / Borewell',
    this.hasToiletFacility = true,
    this.hasElectricityConnection = true,
    this.hasInternetMobileFacility = true,
    this.vehicleDetails = 'Two wheeler & Tractor',
    this.distanceToHospital = '3 km',
    this.distanceToSchoolCollege = '1.5 km',
    this.isDisasterProne = false,
  });

  Map<String, dynamic> toMap() => {
    'permanentAddress': permanentAddress,
    'presentAddress': presentAddress,
    'district': district,
    'talukMunicipality': talukMunicipality,
    'constituency': constituency,
    'wardNumber': wardNumber,
    'areaType': areaType,
    'houseOwnership': houseOwnership,
    'typeOfHouse': typeOfHouse,
    'landOwnedArea': landOwnedArea,
    'landType': landType,
    'nearestMajorCity': nearestMajorCity,
    'drinkingWaterSource': drinkingWaterSource,
    'hasToiletFacility': hasToiletFacility,
    'hasElectricityConnection': hasElectricityConnection,
    'hasInternetMobileFacility': hasInternetMobileFacility,
    'vehicleDetails': vehicleDetails,
    'distanceToHospital': distanceToHospital,
    'distanceToSchoolCollege': distanceToSchoolCollege,
    'isDisasterProne': isDisasterProne,
  };
}

/// 5. Social Media & Communication (20 questions)
class SocialMediaInfoData {
  List<String> activePlatforms; // Facebook, Instagram, Twitter/X, LinkedIn, etc.
  String primaryPlatform;
  String dailyHoursSpent;
  String handlesUsernames;
  String followersCount;
  String postingFrequency; // Daily, Weekly, Monthly, Rarely
  String primaryContentType; // Photos, News, Memes, Updates
  String profileVisibility; // Public / Private
  bool experiencedCyberbullying;
  bool usesLinkedInNetworking;
  bool hasYoutubeOrBlog;
  String onlineCommunities;
  bool usesPaymentApps; // UPI, Paytm, GPay
  bool shopsOnline;
  bool participatesInSurveys;
  bool usesAdsForWork;
  bool usesSocialMediaForPolitics;
  bool usesSocialMediaForNews;
  bool belongsToOnlineForums;
  String personalWebsite;

  SocialMediaInfoData({
    this.activePlatforms = const ['Facebook', 'WhatsApp', 'YouTube'],
    this.primaryPlatform = 'WhatsApp',
    this.dailyHoursSpent = '2-3 hours',
    this.handlesUsernames = '@voter_citizen',
    this.followersCount = '500+',
    this.postingFrequency = 'Weekly',
    this.primaryContentType = 'News articles & Personal updates',
    this.profileVisibility = 'Private',
    this.experiencedCyberbullying = false,
    this.usesLinkedInNetworking = false,
    this.hasYoutubeOrBlog = false,
    this.onlineCommunities = 'Local farmers community group',
    this.usesPaymentApps = true,
    this.shopsOnline = true,
    this.participatesInSurveys = true,
    this.usesAdsForWork = false,
    this.usesSocialMediaForPolitics = true,
    this.usesSocialMediaForNews = true,
    this.belongsToOnlineForums = true,
    this.personalWebsite = '',
  });

  Map<String, dynamic> toMap() => {
    'activePlatforms': activePlatforms,
    'primaryPlatform': primaryPlatform,
    'dailyHoursSpent': dailyHoursSpent,
    'handlesUsernames': handlesUsernames,
    'followersCount': followersCount,
    'postingFrequency': postingFrequency,
    'primaryContentType': primaryContentType,
    'profileVisibility': profileVisibility,
    'experiencedCyberbullying': experiencedCyberbullying,
    'usesLinkedInNetworking': usesLinkedInNetworking,
    'hasYoutubeOrBlog': hasYoutubeOrBlog,
    'onlineCommunities': onlineCommunities,
    'usesPaymentApps': usesPaymentApps,
    'shopsOnline': shopsOnline,
    'participatesInSurveys': participatesInSurveys,
    'usesAdsForWork': usesAdsForWork,
    'usesSocialMediaForPolitics': usesSocialMediaForPolitics,
    'usesSocialMediaForNews': usesSocialMediaForNews,
    'belongsToOnlineForums': belongsToOnlineForums,
    'personalWebsite': personalWebsite,
  };
}

/// 6. Professional Information (16 questions)
class ProfessionalInfoData {
  String mainOccupation;
  String employmentType; // Government / Private / Self-employed
  String employmentStatus; // Salaried / Self-employed
  String organisationName;
  String natureOfBusiness;
  String workSchedule; // Full-time / Part-time
  bool paysIncomeTax;
  bool ownsBusinessOrStartup;
  String employeesCount;
  bool travelsForWork;
  String workLocation; // India / Abroad
  bool belongsToAssociation;
  bool attendsWorkshops;
  bool receivedAwards;
  String jobSatisfaction; // Satisfied / Neutral / Dissatisfied
  bool plansCareerChange;

  ProfessionalInfoData({
    this.mainOccupation = 'Agriculture & Small Enterprise',
    this.employmentType = 'Self-employed',
    this.employmentStatus = 'Self-employed',
    this.organisationName = 'Self Owned Farm & Agro Services',
    this.natureOfBusiness = 'Agri-Trading',
    this.workSchedule = 'Full-time',
    this.paysIncomeTax = false,
    this.ownsBusinessOrStartup = true,
    this.employeesCount = '2',
    this.travelsForWork = true,
    this.workLocation = 'India',
    this.belongsToAssociation = true,
    this.attendsWorkshops = true,
    this.receivedAwards = false,
    this.jobSatisfaction = 'Satisfied',
    this.plansCareerChange = false,
  });

  Map<String, dynamic> toMap() => {
    'mainOccupation': mainOccupation,
    'employmentType': employmentType,
    'employmentStatus': employmentStatus,
    'organisationName': organisationName,
    'natureOfBusiness': natureOfBusiness,
    'workSchedule': workSchedule,
    'paysIncomeTax': paysIncomeTax,
    'ownsBusinessOrStartup': ownsBusinessOrStartup,
    'employeesCount': employeesCount,
    'travelsForWork': travelsForWork,
    'workLocation': workLocation,
    'belongsToAssociation': belongsToAssociation,
    'attendsWorkshops': attendsWorkshops,
    'receivedAwards': receivedAwards,
    'jobSatisfaction': jobSatisfaction,
    'plansCareerChange': plansCareerChange,
  };
}

/// 7. Political Information (20 questions)
class PoliticalInfoData {
  bool isRegisteredVoter;
  String registeredVotersInHouse;
  bool regularVoter;
  bool votedInLastElection;
  String preferredParty;
  bool attendsPoliticalRallies;
  bool hasPartyMembership;
  bool followsPoliticalNews;
  bool knowsMlaPersonally;
  bool knowsMpPersonally;
  bool volunteeredAsBoothWorker;
  bool discussesPolitics;
  bool hasContestedElections;
  bool supportsLeaderOverParty;
  bool hasDonatedToParty;
  bool plansActivePolitics;
  bool usesSocialMediaForPolitics;
  bool experiencedCasteDiscrimination;
  String expectedSurveyBenefit;
  bool belongsToSocialOrPoliticalOrg;

  PoliticalInfoData({
    this.isRegisteredVoter = true,
    this.registeredVotersInHouse = '4',
    this.regularVoter = true,
    this.votedInLastElection = true,
    this.preferredParty = 'Regional Democratic Coalition',
    this.attendsPoliticalRallies = true,
    this.hasPartyMembership = false,
    this.followsPoliticalNews = true,
    this.knowsMlaPersonally = true,
    this.knowsMpPersonally = false,
    this.volunteeredAsBoothWorker = true,
    this.discussesPolitics = true,
    this.hasContestedElections = false,
    this.supportsLeaderOverParty = true,
    this.hasDonatedToParty = false,
    this.plansActivePolitics = true,
    this.usesSocialMediaForPolitics = true,
    this.experiencedCasteDiscrimination = false,
    this.expectedSurveyBenefit = 'Better welfare access and road infrastructure',
    this.belongsToSocialOrPoliticalOrg = true,
  });

  Map<String, dynamic> toMap() => {
    'isRegisteredVoter': isRegisteredVoter,
    'registeredVotersInHouse': registeredVotersInHouse,
    'regularVoter': regularVoter,
    'votedInLastElection': votedInLastElection,
    'preferredParty': preferredParty,
    'attendsPoliticalRallies': attendsPoliticalRallies,
    'hasPartyMembership': hasPartyMembership,
    'followsPoliticalNews': followsPoliticalNews,
    'knowsMlaPersonally': knowsMlaPersonally,
    'knowsMpPersonally': knowsMpPersonally,
    'volunteeredAsBoothWorker': volunteeredAsBoothWorker,
    'discussesPolitics': discussesPolitics,
    'hasContestedElections': hasContestedElections,
    'supportsLeaderOverParty': supportsLeaderOverParty,
    'hasDonatedToParty': hasDonatedToParty,
    'plansActivePolitics': plansActivePolitics,
    'usesSocialMediaForPolitics': usesSocialMediaForPolitics,
    'experiencedCasteDiscrimination': experiencedCasteDiscrimination,
    'expectedSurveyBenefit': expectedSurveyBenefit,
    'belongsToSocialOrPoliticalOrg': belongsToSocialOrPoliticalOrg,
  };
}

/// 8. Contact History (10 questions)
class ContactHistoryData {
  String primaryMobile;
  String alternateMobile;
  String emailId;
  String whatsAppNumber;
  bool usesTelegramOrSignal;
  String preferredCommMode; // Call / SMS / WhatsApp
  bool isDndRegistered;
  bool answersSurveyCalls;
  bool sharesContactFreely;
  bool updatesContactOnAadhaarVoterList;

  ContactHistoryData({
    this.primaryMobile = '',
    this.alternateMobile = '',
    this.emailId = '',
    this.whatsAppNumber = '',
    this.usesTelegramOrSignal = true,
    this.preferredCommMode = 'WhatsApp',
    this.isDndRegistered = false,
    this.answersSurveyCalls = true,
    this.sharesContactFreely = true,
    this.updatesContactOnAadhaarVoterList = true,
  });

  Map<String, dynamic> toMap() => {
    'primaryMobile': primaryMobile,
    'alternateMobile': alternateMobile,
    'emailId': emailId,
    'whatsAppNumber': whatsAppNumber,
    'usesTelegramOrSignal': usesTelegramOrSignal,
    'preferredCommMode': preferredCommMode,
    'isDndRegistered': isDndRegistered,
    'answersSurveyCalls': answersSurveyCalls,
    'sharesContactFreely': sharesContactFreely,
    'updatesContactOnAadhaarVoterList': updatesContactOnAadhaarVoterList,
  };
}

/// 9. Donation & Contribution (20 questions)
class DonationContributionData {
  bool everDonated;
  String donationFrequency; // Monthly / Yearly / Occasionally
  String averageDonationAmount;
  bool donatesToReligious;
  bool donatesToPoliticalParties;
  bool donatesToNgos;
  bool donatesBlood;
  bool isOrganDonor;
  bool contributesToCrowdfunding;
  bool donatesDuringDisasters;
  bool donatesClothesItems;
  bool sponsorsPoorStudents;
  bool donatesToGovtFunds;
  bool supportsLocalEvents;
  String donationVisibility; // Anonymous / Public
  bool getsReceipts;
  String donationMode; // Online / Offline
  String donationScope; // Within Community / Outside
  bool donatesToEducation;
  bool willingToIncreaseDonations;

  DonationContributionData({
    this.everDonated = true,
    this.donationFrequency = 'Occasionally',
    this.averageDonationAmount = '₹1,000 - ₹5,000',
    this.donatesToReligious = true,
    this.donatesToPoliticalParties = false,
    this.donatesToNgos = true,
    this.donatesBlood = true,
    this.isOrganDonor = false,
    this.contributesToCrowdfunding = true,
    this.donatesDuringDisasters = true,
    this.donatesClothesItems = true,
    this.sponsorsPoorStudents = true,
    this.donatesToGovtFunds = false,
    this.supportsLocalEvents = true,
    this.donationVisibility = 'Public',
    this.getsReceipts = true,
    this.donationMode = 'Online',
    this.donationScope = 'Within Community',
    this.donatesToEducation = true,
    this.willingToIncreaseDonations = true,
  });

  Map<String, dynamic> toMap() => {
    'everDonated': everDonated,
    'donationFrequency': donationFrequency,
    'averageDonationAmount': averageDonationAmount,
    'donatesToReligious': donatesToReligious,
    'donatesToPoliticalParties': donatesToPoliticalParties,
    'donatesToNgos': donatesToNgos,
    'donatesBlood': donatesBlood,
    'isOrganDonor': isOrganDonor,
    'contributesToCrowdfunding': contributesToCrowdfunding,
    'donatesDuringDisasters': donatesDuringDisasters,
    'donatesClothesItems': donatesClothesItems,
    'sponsorsPoorStudents': sponsorsPoorStudents,
    'donatesToGovtFunds': donatesToGovtFunds,
    'supportsLocalEvents': supportsLocalEvents,
    'donationVisibility': donationVisibility,
    'getsReceipts': getsReceipts,
    'donationMode': donationMode,
    'donationScope': donationScope,
    'donatesToEducation': donatesToEducation,
    'willingToIncreaseDonations': willingToIncreaseDonations,
  };
}

/// Aggregate Voter Record combining all 9 sections
class VoterRecord {
  final String id;
  VoterCategory category;
  DateTime createdAt;
  bool isTagged;
  bool isInactive;

  PersonalInfoData personal;
  FamilyInfoData family;
  EducationInfoData education;
  GeographicInfoData geographic;
  SocialMediaInfoData socialMedia;
  ProfessionalInfoData professional;
  PoliticalInfoData political;
  ContactHistoryData contact;
  DonationContributionData donation;

  VoterRecord({
    required this.id,
    this.category = VoterCategory.undecided,
    DateTime? createdAt,
    this.isTagged = true,
    this.isInactive = false,
    PersonalInfoData? personal,
    FamilyInfoData? family,
    EducationInfoData? education,
    GeographicInfoData? geographic,
    SocialMediaInfoData? socialMedia,
    ProfessionalInfoData? professional,
    PoliticalInfoData? political,
    ContactHistoryData? contact,
    DonationContributionData? donation,
  })  : createdAt = createdAt ?? DateTime.now(),
        personal = personal ?? PersonalInfoData(),
        family = family ?? FamilyInfoData(),
        education = education ?? EducationInfoData(),
        geographic = geographic ?? GeographicInfoData(),
        socialMedia = socialMedia ?? SocialMediaInfoData(),
        professional = professional ?? ProfessionalInfoData(),
        political = political ?? PoliticalInfoData(),
        contact = contact ?? ContactHistoryData(),
        donation = donation ?? DonationContributionData();

  String get name => personal.name.isNotEmpty ? personal.name : 'Unknown Voter';
  String get mobile => contact.primaryMobile.isNotEmpty ? contact.primaryMobile : personal.mobileNumber;
  String get voterId => personal.voterIdNumber.isNotEmpty ? personal.voterIdNumber : 'N/A';
  String get ward => geographic.wardNumber.isNotEmpty ? geographic.wardNumber : 'Ward 1';
  String get constituency => geographic.constituency.isNotEmpty ? geographic.constituency : 'District 1';
  String get age => personal.age.isNotEmpty ? personal.age : '32';
  String get gender => personal.gender.isNotEmpty ? personal.gender : 'Male';

  bool get hasMissingPhone => mobile.trim().isEmpty || mobile.trim() == 'N/A';
  bool get hasMissingEmail => contact.emailId.trim().isEmpty;

  double get completionPercentage {
    int filled = 0;
    int total = 18; // sample check across key fields
    if (personal.name.isNotEmpty) filled++;
    if (personal.mobileNumber.isNotEmpty) filled++;
    if (personal.voterIdNumber.isNotEmpty) filled++;
    if (personal.dob.isNotEmpty || personal.age.isNotEmpty) filled++;
    if (personal.gender.isNotEmpty) filled++;
    if (family.totalMembers.isNotEmpty) filled++;
    if (family.monthlyIncome.isNotEmpty) filled++;
    if (education.highestEducation.isNotEmpty) filled++;
    if (geographic.district.isNotEmpty) filled++;
    if (geographic.wardNumber.isNotEmpty) filled++;
    if (geographic.houseOwnership.isNotEmpty) filled++;
    if (socialMedia.primaryPlatform.isNotEmpty) filled++;
    if (professional.mainOccupation.isNotEmpty) filled++;
    if (political.registeredVotersInHouse.isNotEmpty) filled++;
    if (political.preferredParty.isNotEmpty) filled++;
    if (contact.preferredCommMode.isNotEmpty) filled++;
    if (donation.donationFrequency.isNotEmpty) filled++;
    if (donation.averageDonationAmount.isNotEmpty) filled++;
    return (filled / total).clamp(0.1, 1.0);
  }
}
