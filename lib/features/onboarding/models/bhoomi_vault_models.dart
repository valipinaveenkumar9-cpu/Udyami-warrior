class BhoomiQuestionCategory {
  final String name;
  final int startNum;
  final List<String> questions;

  const BhoomiQuestionCategory({
    required this.name,
    required this.startNum,
    required this.questions,
  });
}

class BhoomiQuestionnaireData {
  final String id;
  final String title;
  final String subtitle;
  final List<BhoomiQuestionCategory> categories;

  const BhoomiQuestionnaireData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categories,
  });
}

class BhoomiVaultQuestionnaires {
  static const Map<String, BhoomiQuestionnaireData> all = {
    'q_setuconnect_individual': BhoomiQuestionnaireData(
      id: 'q_setuconnect_individual',
      title: 'SetuConnect — Individual Applicant Verification Questionnaire',
      subtitle: 'Establish basic, entry-level fitness for identifying and referring genuine Liaisoning & Procurement leads responsibly.',
      categories: [
        BhoomiQuestionCategory(
          name: 'Background & Local Network',
          startNum: 1,
          questions: [
            'Do you have an existing network of contacts in your taluk/hobli who own land or are dealing with land-related paperwork?',
            'Have you ever helped a friend, relative, or neighbour who needed help with land records or a government office visit?',
            'What is your current occupation, and does it bring you into regular contact with landowners or property buyers?',
            'Have you ever referred someone to a lawyer, surveyor, document writer, or government office for help?',
            'Are you familiar with the villages, wards, or localities in your area where land transactions are common?',
            'Do you have any prior experience working with real estate agents, brokers, or property dealers?',
            'How do people in your area typically find out about someone who needs help with mutation, khata, or conversion work?',
          ],
        ),
        BhoomiQuestionCategory(
          name: 'Lead Identification & Qualification',
          startNum: 8,
          questions: [
            'How would you identify whether someone genuinely needs a Liaisoning & Procurement service versus casual curiosity?',
            'What basic details would you collect from a person before referring them to BhoomiVault?',
            'How would you explain the difference between "clearing a title" and "buying land" to someone unfamiliar with the process?',
            'Would you be comfortable asking someone for their parcel/survey number before referring them?',
            "How would you avoid referring the same lead twice or duplicating another partner's referral?",
            'What would you do if a person asked you to handle their documents yourself, even though your role is only to refer?',
            "How would you track leads you've referred, so you know which ones were followed up on?",
          ],
        ),
        BhoomiQuestionCategory(
          name: 'Land & Liaison Domain Awareness',
          startNum: 15,
          questions: [
            'Are you aware of what "mutation" or "khata transfer" means in the context of land records?',
            'Have you heard of an Encumbrance Certificate (EC)? What is it generally used for?',
            'Do you know what a "conversion order" (NA order) is, in relation to agricultural land?',
            'What is a survey sketch, and why might a landowner need one?',
            "Are you aware that BhoomiVault's title-clearance status is required before certain other applications (like Build My Home or Ownify) can proceed?",
            'Do you know the difference between a Liaisoning task (e.g. a government visit) and a Procurement task (e.g. fetching a missing document)?',
            'Would you know who to direct a lead to if they had a legal dispute rather than a straightforward liaison need?',
          ],
        ),
        BhoomiQuestionCategory(
          name: 'Operational Readiness',
          startNum: 22,
          questions: [
            'How many hours a week can you realistically dedicate to spotting and referring leads?',
            'Do you have a smartphone with internet access to log leads through the Partner app?',
            'Is your work location or usual movement area easily accessible to people in your taluk/hobli?',
            'Would you be comfortable following up with a lead a few days after the initial referral, to check they were contacted?',
            'How would you handle referring multiple leads in the same week without losing track of any of them?',
            'Are you willing to undergo basic training on what qualifies as a valid, referable lead?',
            "Would you be able to coordinate with a SetuField partner if a client asked follow-up questions you couldn't answer?",
          ],
        ),
        BhoomiQuestionCategory(
          name: 'Ethics, Compliance & Client Trust',
          startNum: 29,
          questions: [
            'What would you do if a client offered to pay you directly, outside the One Core commission system, for a faster referral?',
            "How would you handle a situation where you weren't sure if a piece of land had any encumbrance or dispute?",
            'Would you be willing to disclose to a client that you are a lead referrer and not the person who will execute the work?',
            'What would you do if you suspected a lead was providing false information about land ownership?',
            'How would you explain a delay in someone following up on a lead you referred?',
            'Are you willing to be transparent with BhoomiVault about how and where you sourced a lead?',
            'Why should BhoomiVault trust you specifically to bring genuine, well-qualified leads?',
          ],
        ),
      ],
    ),
    'q_setuconnect_institutional': BhoomiQuestionnaireData(
      id: 'q_setuconnect_institutional',
      title: 'SetuConnect — Institutional Applicant Verification Questionnaire',
      subtitle: "Rigorous scrutiny of the organization's referral network, scale and accountability.",
      categories: [
        BhoomiQuestionCategory(
          name: 'Organizational Background & Referral Track Record',
          startNum: 36,
          questions: [
            'How many years has your organization been operating in real estate referrals, property broking, or related fields?',
            "How many field agents, brokers, or associates currently generate leads on your organization's behalf?",
            "Provide details of your firm's registration (e.g., partnership deed, LLP agreement, trade licence).",
            'What is the total volume of land/property-related referrals your organization has generated in the last 3 years?',
            'Can you list three reference clients or partner organizations your firm has previously worked with in this domain?',
            'Has your organization ever been involved in any dispute, complaint, or regulatory action related to property referrals? Provide details.',
            "What is your organization's monthly lead-generation capacity across its network?",
          ],
        ),
        BhoomiQuestionCategory(
          name: 'Network & Lead-Generation Infrastructure',
          startNum: 43,
          questions: [
            "Describe your organization's network of field agents or sub-referrers across talukas/hoblis.",
            "Do you maintain a CRM or lead-tracking system? Which one, and how does it prevent duplicate referrals?",
            "What is your process for verifying a lead's basic details before submission?",
            'How does your organization prevent unauthorized agents from misrepresenting themselves as BhoomiVault partners?',
            'Do you carry any liability cover for disputes arising from referrals made by your network?',
            'What is your average time from lead capture to submission into the Partner app?',
            'How do you ensure a consistent standard of information is captured across all your field agents?',
          ],
        ),
        BhoomiQuestionCategory(
          name: 'Domain Expertise & Screening Process',
          startNum: 50,
          questions: [
            "Describe your organization's process for screening whether a lead is genuinely liaison/procurement-related versus a legal-opinion or asset-management need better suited elsewhere.",
            'What quality-control process do you follow before a lead is marked ready for referral?',
            'How does your organization stay current with changes in mutation, khata, and conversion procedures in this state?',
            'Describe a case where your organization identified and correctly routed a complex land-liaison lead.',
            "What is your organization's track record on leads that turned out to be invalid or misrepresented?",
            'Do you have in-house familiarity with revenue department and sub-registrar processes across multiple talukas?',
            "How do you verify that a person referring a lead actually has the landowner's consent to share their details?",
          ],
        ),
        BhoomiQuestionCategory(
          name: 'Operations, Scale & Staffing',
          startNum: 57,
          questions: [
            'How many talukas/hoblis can your organization realistically generate qualified leads for simultaneously?',
            'What is your agent-to-lead ratio, and how do you plan to scale it under this partnership?',
            'Describe your standard operating procedure for onboarding a new field agent into your referral network.',
            'What escalation matrix do you follow when a lead-level dispute or complaint cannot be resolved by your front-line agents?',
            'How do you train and certify new field agents before they begin generating leads?',
            'What is your average field-agent attrition rate, and how do you manage continuity of ongoing referrals when agents leave?',
            "Describe your organization's technology stack for lead tracking and communication with BhoomiVault.",
          ],
        ),
        BhoomiQuestionCategory(
          name: 'Compliance, Financial Standing & Accountability',
          startNum: 64,
          questions: [
            'Is your organization GST-registered and compliant with applicable tax filings? Please share registration details.',
            "What is your organization's audited annual turnover for the last two financial years?",
            'Do you have a documented code of conduct covering conflict of interest and data privacy for the leads you handle?',
            'How does your organization handle a situation where a field agent is found submitting fabricated leads?',
            'What indemnity or liability clauses are you willing to accept in a partnership agreement with BhoomiVault?',
            'Provide details of any professional indemnity insurance or bond your organization holds.',
            'Why should BhoomiVault select your organization over other referral networks operating in this region?',
          ],
        ),
      ],
    ),
    'q_setufield_individual': BhoomiQuestionnaireData(
      id: 'q_setufield_individual',
      title: 'SetuField — Individual Applicant Verification Questionnaire',
      subtitle: 'Establish basic, hands-on fitness for executing government-office visits and document procurement.',
      categories: [
        BhoomiQuestionCategory(
          name: 'Background & Government Office Exposure',
          startNum: 71,
          questions: [
            "Have you ever visited a revenue office, sub-registrar's office, or taluk office on behalf of yourself or someone else?",
            'Do you have experience handling mutation, khata transfer, or conversion applications?',
            'What is your current occupation, and does it involve regular interaction with government offices?',
            'Have you ever accompanied a family member or client to a survey office or panchayat office for land-related work?',
            'Do you have any prior experience as a village accountant, revenue official, surveyor, or document writer?',
            'Are you familiar with common land-record terms (e.g., RTC/Pahani, mutation, encumbrance, survey number)?',
            "Have you ever procured a missing document (like an EC or tax receipt) on someone else's behalf?",
          ],
        ),
        BhoomiQuestionCategory(
          name: 'Task Execution & Procurement Practices',
          startNum: 78,
          questions: [
            'How would you go about tracking down a missing RTC, EC, or tax receipt for a parcel?',
            'What would you do if a government office official asked for an unofficial payment to process a task faster?',
            'How would you keep a client updated on the status of a mutation or khata transfer application?',
            'Have you used any digital tool (Bhoomi portal, DigiLocker, or similar) to check or download land records?',
            'What would you do if a document you procured turned out to be incomplete or incorrect?',
            'How would you record and report your expenses for a government-office visit?',
            'Would you be comfortable maintaining a task log of visits made, outcomes, and pending follow-ups?',
          ],
        ),
        BhoomiQuestionCategory(
          name: 'Land Records & Liaison Process Knowledge',
          startNum: 85,
          questions: [
            'Can you explain, in your own words, what "mutation" means?',
            'What documents would you typically need before applying for a khata transfer?',
            'Have you heard of an Encumbrance Certificate (EC)? What is it used for?',
            'What is the difference between an RTC/Pahani and a survey sketch?',
            'Are you aware of what a "conversion order" (NA order) means for agricultural land?',
            'Do you know the typical steps and timelines involved in a mutation or khata-transfer application in your taluk?',
            "Would you know who to escalate a stuck or delayed task to if you couldn't resolve it yourself?",
          ],
        ),
        BhoomiQuestionCategory(
          name: 'Operational Readiness',
          startNum: 92,
          questions: [
            'How many hours a week can you realistically dedicate to government-office visits and procurement work?',
            'Do you have your own transport to reach taluk offices, sub-registrar offices, or survey departments?',
            "Is your work location easily accessible to clients and to the government offices you'll be visiting?",
            'Would you be able to travel outside your immediate ward/taluk if a task required it?',
            "How would you handle multiple clients' tasks at the same time without mixing up documents or deadlines?",
            "Are you willing to undergo training on BhoomiVault's liaison task tracker and SLA process before starting?",
            'Would you be able to coordinate with a Land/Title Officer if a verification query came up during your task?',
          ],
        ),
        BhoomiQuestionCategory(
          name: 'Ethics, Compliance & Accountability',
          startNum: 99,
          questions: [
            'What would you do if a client asked you to backdate or misrepresent a document?',
            "How would you handle a situation where a document you're procuring contains sensitive personal information?",
            'Would you be willing to sign a confidentiality undertaking for the land documents and records you handle?',
            'What would you do if you suspected a document presented to you was forged?',
            'How would you explain a delay in completing a mutation, khata, or conversion task?',
            'Are you willing to be held accountable for expenses you report, including providing receipts where required?',
            "Why should BhoomiVault trust you specifically to execute government-office liaison work on a client's behalf?",
          ],
        ),
      ],
    ),
    'q_setufield_institutional': BhoomiQuestionnaireData(
      id: 'q_setufield_institutional',
      title: 'SetuField — Institutional Applicant Verification Questionnaire',
      subtitle: "Rigorous scrutiny of the organization's liaison-execution track record, scale, and accountability.",
      categories: [
        BhoomiQuestionCategory(
          name: 'Organizational Background & Liaison Track Record',
          startNum: 106,
          questions: [
            'How many years has your organization been operating in land-liaison, document procurement, or related government-facing services?',
            'How many liaison officers, field staff, or associates are currently on your payroll or retainer?',
            "Provide details of your firm's registration (e.g., partnership deed, LLP agreement, trade licence).",
            'What is the total volume of liaison/procurement tasks (mutation, khata, conversion, EC procurement) your organization has completed in the last 3 years?',
            'Can you list three reference clients or institutions your firm has previously served in this domain?',
            'Has your organization ever been involved in any dispute, complaint, or regulatory action related to government-office liaison work? Provide details.',
            "What is your organization's monthly task-completion capacity across all offices you cover?",
          ],
        ),
        BhoomiQuestionCategory(
          name: 'Infrastructure & Task/Expense Management Systems',
          startNum: 113,
          questions: [
            "Describe your organization's system for tracking liaison tasks, SLAs, and outcomes across staff.",
            'Do you maintain a digital task-management or field-service system? Which one, and how does it log expenses?',
            'What is your process for maker-checker approval on expenses above a certain threshold?',
            "How does your organization prevent unauthorized staff from acting on a client's behalf without proper mandate?",
            "Do you carry insurance or a bond against loss, delay, or mishandling of a client's task or documents?",
            'What is your average turnaround time for a standard mutation or khata-transfer task?',
            'How do you ensure a clean handover when a task moves between staff members?',
          ],
        ),
        BhoomiQuestionCategory(
          name: 'Land & Liaison Domain Expertise',
          startNum: 120,
          questions: [
            "Describe your organization's process for executing a mutation or khata-transfer task from start to finish.",
            'What quality-control or review process do you follow before marking a liaison task complete?',
            'How does your organization stay current with changes in mutation, conversion, and registration rules across the talukas you serve?',
            'Describe a complex or delayed liaison case your organization has successfully resolved.',
            "What is your organization's track record on SLA breaches for liaison tasks, and how are they escalated?",
            'Do you have in-house expertise across survey/boundary work, conversion orders, and encumbrance procurement?',
            "How do you verify the authenticity of documents your staff procure on a client's behalf?",
          ],
        ),
        BhoomiQuestionCategory(
          name: 'Operations, Scale & Staffing',
          startNum: 127,
          questions: [
            'How many talukas/offices can your organization realistically service simultaneously?',
            'What is your staff-to-task ratio, and how do you plan to scale it under this partnership?',
            "Describe your standard operating procedure for onboarding a new client's liaison task.",
            'What escalation matrix do you follow when a field-level issue or SLA breach cannot be resolved by front-line staff?',
            'How do you train and certify new staff before they represent your organization at a government office?',
            'What is your average staff attrition rate, and how do you manage continuity of ongoing tasks when staff leave?',
            "Describe your organization's technology stack for task tracking and client communication.",
          ],
        ),
        BhoomiQuestionCategory(
          name: 'Compliance, Financial Standing & Accountability',
          startNum: 134,
          questions: [
            'Is your organization GST-registered and compliant with applicable tax filings? Please share registration details.',
            "What is your organization's audited annual turnover for the last two financial years?",
            'Do you have a documented code of conduct or compliance policy covering conflict of interest and confidentiality of land records?',
            "How does your organization handle a situation where a staff member is found misrepresenting a task's status or expenses?",
            'What indemnity or liability clauses are you willing to accept in a partnership agreement with BhoomiVault?',
            'Provide details of any professional indemnity insurance or bond your organization holds.',
            'Why should BhoomiVault select your organization over other liaison-service providers operating in this region?',
          ],
        ),
      ],
    ),
  };
}

class BhoomiVaultDemoApplicantData {
  static Map<String, dynamic> get sample => {
        'udyamiMember': 'Yes',
        'memberId': '123123',
        'fullName': 'Ananya Rao',
        'dob': '18-04-1992',
        'gender': 'Female',
        'fatherHusbandName': 'Suresh Rao',
        'maritalStatus': 'Married',
        'bloodGroup': 'B+',
        'nationality': 'Indian',
        'languages': 'Kannada, English, Hindi',
        'mobile': '9876543210',
        'altMobile': '',
        'email': 'ananya.rao@example.test',
        'occupation': 'other',
        'occupationSpecify': 'Property consultant',
        'houseStreetVillage': '24, 5th Cross, Jayanagar',
        'taluk': 'Bengaluru South',
        'district': 'Bengaluru Urban',
        'stateName': 'Karnataka',
        'pin': '560041',
        'ward': 'Jayanagar Ward',
        'yearsLivedHere': '8',
        'homeType': 'Own',
        'landmark': 'Near Jayanagar 4th Block',
        'aadhaarNumber': '123456789012',
        'aadhaarMobile': '9876543210',
        'aadhaarName': 'Ananya Rao',
        'aadhaarConsent': true,
        'aadhaarOtpVerified': true,
        'businessType': 'individual',
        'hasLegalExperience': true,
        'whereWorked': 'Rao Property Services',
        'role': 'Property Consultant',
        'howLong': '2019–2026',
        'whatYouDid':
            'Coordinated property document collection, revenue-office visits and client follow-ups.',
        'yearsExperience': '7',
        'highestQualification': 'B.Com',
        'toolsKnown': 'DigiLocker, Google Drive',
        'familiarityChecklist': [
          'I know my way around revenue / land records offices',
          "I'm familiar with the sub-registrar's process",
          "I've prepared or reviewed liaison paperwork before"
        ],
        'workAddress': '24, 5th Cross, Jayanagar, Bengaluru',
        'ownership': 'Owned',
        'workLandmark': 'Jayanagar 4th Block',
        'wardAreaServe': 'Jayanagar Ward',
        'villagesCovered': 'Jayanagar, Basavanagudi, JP Nagar',
        'workFacilities': [
          'Private area for clients to hand over documents',
          'Secure, lockable place to store originals',
          'CCTV or other document security',
          'Internet access to scan and upload',
          'Computer, scanner and printer on site',
          'Familiar with revenue office / sub-registrar process'
        ],
        'accountHolderName': 'Ananya Rao',
        'accountType': 'Savings',
        'accountNumber': 'XXXXXX4821',
        'ifsc': 'HDFC0001234',
        'bankBranch': 'Jayanagar Branch',
        'nomineeName': 'Arjun Rao',
        'relationship': 'Spouse',
        'nomineeMobile': '9876501234',
        'nomineeAccountNumber': 'XXXXXX7312',
        'nomineeIfsc': 'HDFC0001234',
        'nomineeBankBranch': 'Jayanagar Branch',
        'services': ['setuconnect'],
        'wardArea': 'Jayanagar Ward',
        'casesPerMonth': '12',
        'hireSupportStaff': 'No',
        'bestTimeTraining': 'Weekends',
        'smartphone': 'Android',
        'comfortApps': 'Very Comfortable',
        'usedAppsForDocs': 'Yes, Regularly',
        'comfortGPS': 'Very Comfortable',
        'langComm': [
          "I'm comfortable using the Partner app already",
          'I can talk to clients in Kannada',
          'I can talk to clients in English'
        ],
        'c1': true,
        'c2': true,
        'c3': true,
        'c4': true,
        'c8': true,
        'c5': true,
        'c6': true,
        'c7': true,
        'place': 'Bengaluru',
        'date8': '2026-08-31',
        'signed': true,
        'signedAt': '2026-08-31T10:00:00.000Z',
      };
}
