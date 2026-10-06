// FIRST CHOICE BANK Channel Partner Models and Data Schemas

class FirstChoiceBankQuestionCategory {
  final String name;
  final int startNum;
  final List<String> questions;

  const FirstChoiceBankQuestionCategory({
    required this.name,
    required this.startNum,
    required this.questions,
  });
}

class FirstChoiceBankQuestionnaireData {
  final String id;
  final String title;
  final String subtitle;
  final List<FirstChoiceBankQuestionCategory> categories;

  const FirstChoiceBankQuestionnaireData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categories,
  });
}

class FirstChoiceBankServiceCard {
  final String id;
  final String icon;
  final String name;
  final String desc;
  final String badge;
  final int deposit;

  const FirstChoiceBankServiceCard({
    required this.id,
    required this.icon,
    required this.name,
    required this.desc,
    this.badge = '4% COMMISSION',
    this.deposit = 500000,
  });
}

class FirstChoiceBankServiceCards {
  static const int depositPerModule = 500000;

  static const List<FirstChoiceBankServiceCard> all = [
    FirstChoiceBankServiceCard(
      id: 'loans',
      icon: '💰',
      name: 'Loans',
      desc:
          "Refer members into One Core's closed-loop, supplier-direct credit and loan-against-FD facilities — funds settle directly to a verified vendor, never as cash to the borrower.",
    ),
    FirstChoiceBankServiceCard(
      id: 'goldsilver',
      icon: '🪙',
      name: 'Gold & Silver (Savings)',
      desc:
          'Refer members into structured Gold & Silver savings goals — small recurring contributions building toward a tangible asset over time.',
    ),
    FirstChoiceBankServiceCard(
      id: 'piggy',
      icon: '🐷',
      name: 'Piggy',
      desc:
          'Refer members into the Piggy micro-savings ladder — daily ₹10 savings with a life-stage path from School to Prince/Princess to Queens to Senior.',
    ),
    FirstChoiceBankServiceCard(
      id: 'fdrd',
      icon: '🏦',
      name: 'FD & RD',
      desc:
          'Refer members into tiered Fixed Deposits and Recurring Deposits — with the automatic rate-enhancement engine for seniors, super-seniors, Queens and NRI members.',
    ),
  ];
}

class FirstChoiceBankQuestionnaires {
  static const Map<String, FirstChoiceBankQuestionnaireData> all = {
    'q_loans_individual': FirstChoiceBankQuestionnaireData(
      id: 'q_loans_individual',
      title: 'Loans — Individual Applicant Verification',
      subtitle:
          'Answer these 20 questions to show you can responsibly refer members into Loans.',
      categories: [
        FirstChoiceBankQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 1,
          questions: [
            'Explain your understanding of how Loans works within One Core, and how a member participates through it.',
            "How would you explain One Core's closed-loop, supplier-direct credit model — funds settle directly to a verified vendor, never as cash to the borrower to a first-time client?",
            'What factors most affect the eligibility or approval outcome for a member using Loans?',
            "What would you check regarding the member's KYC status, wallet activation and existing loan-against-FD eligibility before referring a client into Loans?",
            'What questions would you ask a client to see if Loans suits their goals?',
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 6,
          questions: [
            'What concerns might a client raise about Loans, and how would you address them?',
            "How would you differentiate One Core's Loans from a cash loan from an informal lender, or a direct bank personal loan without supplier-direct settlement?",
            'What is your existing network or client base relevant to Loans?',
            'Would you ever promise assured returns or a guaranteed outcome to a client interested in Loans? Why or why not?',
            'What is your plan to start referring clients into Loans within your first 30 days as a partner?',
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Process & Documentation',
          startNum: 11,
          questions: [
            'What is the minimum KYC and wallet-activation status a client needs before they can be considered for a loan facility?',
            'How would you explain to a client that loan funds are paid directly to the vendor/supplier, never to them as cash?',
            "What would you check regarding a client's existing FD holdings if they're interested in a loan-against-FD facility?",
            'How would you support a client through the maker-checker approval stage of a loan disbursal?',
            'What would make you decline to refer a particular client for a loan?',
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 16,
          questions: [
            'How would you explain the deposits-not-insured / credit-risk disclosure to a loan applicant?',
            'How would you keep a client updated on their loan application status after referral?',
            'What would you tell a client about how repayments are tracked and reflected in their passbook?',
            "How would you handle a client's complaint about a rejected loan application, and who would you escalate it to?",
            'What documentation would you help a client assemble to speed up their loan referral?',
          ],
        ),
      ],
    ),
    'q_loans_institutional': FirstChoiceBankQuestionnaireData(
      id: 'q_loans_institutional',
      title: 'Loans — Institutional Applicant Verification',
      subtitle:
          "Establish your organization's expertise, systems and accountability for referring members into Loans.",
      categories: [
        FirstChoiceBankQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 21,
          questions: [
            "Rate your institution's expertise (1–5) in Loans, with brief justification.",
            "Describe your institution's process for verifying a client's KYC status, wallet activation and repayment capacity before referring a loan opportunity.",
            'What legal and compliance framework does your institution maintain specific to closed-loop, supplier-direct credit disbursal and Board-approved credit policy limits?',
            "What is your institution's existing client base or network relevant to Loans?",
            "What is your institution's estimated monthly capacity to refer qualified Loans clients?",
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Systems & Operations',
          startNum: 26,
          questions: [
            'What technology or systems does your institution use to manage Loans referrals and records?',
            'How would your institution integrate Loans referrals into its existing workflows?',
            'What training or resources would your institution need to represent Loans effectively?',
            "How does your institution ensure compliance with One Core's Code of Conduct when referring Loans clients?",
            'What risks specific to Loans does your institution watch for, and how are they mitigated?',
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 31,
          questions: [
            'What internal underwriting or eligibility checks does your institution apply before referring a loan client?',
            "How does your institution verify a client's KYC and wallet-activation status before submitting a loan referral?",
            'What role does your institution play in verifying vendor/supplier details for supplier-direct disbursal?',
            "How does your institution track a referred client's loan application through the maker-checker approval stage?",
            "What process does your institution follow if a referred client's loan application is rejected?",
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 36,
          questions: [
            'How does your institution ensure compliance with Board-approved credit policy limits on referred loans?',
            'What reporting does your institution require from One Core on the status of referred loan applications?',
            'How does your institution handle repayment-related disputes raised by a referred loan client?',
            'What service-level expectations does your institution set for loan referrals — response time or turnaround?',
            'How does your institution measure the success or repayment performance of clients referred into Loans?',
          ],
        ),
      ],
    ),
    'q_goldsilver_individual': FirstChoiceBankQuestionnaireData(
      id: 'q_goldsilver_individual',
      title: 'Gold & Silver (Savings) — Individual Applicant Verification',
      subtitle:
          'Answer these 20 questions to show you can responsibly refer members into Gold & Silver (Savings).',
      categories: [
        FirstChoiceBankQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 41,
          questions: [
            'Explain your understanding of how Gold & Silver (Savings) works within One Core, and how a member participates through it.',
            'How would you explain the Gold & Silver savings goal structure — small recurring contributions building toward a tangible asset over time to a first-time client?',
            'What factors most affect the value or growth for a member using Gold & Silver (Savings)?',
            "What would you check regarding the member's savings goal setup, recurring contribution readiness and wallet KYC status before referring a client into Gold & Silver (Savings)?",
            'What questions would you ask a client to see if Gold & Silver (Savings) suits their goals?',
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 46,
          questions: [
            'What concerns might a client raise about Gold & Silver (Savings), and how would you address them?',
            "How would you differentiate One Core's Gold & Silver (Savings) from buying physical gold or silver outright from a jeweller, or an unregulated chit or savings scheme?",
            'What is your existing network or client base relevant to Gold & Silver (Savings)?',
            'Would you ever promise assured returns or a guaranteed outcome to a client interested in Gold & Silver (Savings)? Why or why not?',
            'What is your plan to start referring clients into Gold & Silver (Savings) within your first 30 days as a partner?',
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Process & Documentation',
          startNum: 51,
          questions: [
            'What is the minimum recurring contribution a client can start a Gold & Silver savings goal with?',
            'How would you explain that Gold & Silver savings value can fluctuate with market price, unlike a fixed deposit?',
            "What would you check regarding a client's wallet KYC status before setting up a Gold & Silver goal?",
            'How would you support a client who wants to change or pause their recurring Gold & Silver contribution?',
            'What would make you decline to refer a particular client into Gold & Silver Savings?',
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 56,
          questions: [
            'How would you explain the deposits-not-insured disclosure to a client considering Gold & Silver Savings?',
            'How would you keep a client updated on their Gold & Silver savings goal progress?',
            'What would you tell a client about how their contributions and balance appear in the One Core passbook?',
            "How would you handle a client's complaint about their Gold & Silver savings goal, and who would you escalate it to?",
            'What is your plan to help a client set realistic milestones for their Gold & Silver savings goal?',
          ],
        ),
      ],
    ),
    'q_goldsilver_institutional': FirstChoiceBankQuestionnaireData(
      id: 'q_goldsilver_institutional',
      title: 'Gold & Silver (Savings) — Institutional Applicant Verification',
      subtitle:
          "Establish your organization's expertise, systems and accountability for referring members into Gold & Silver (Savings).",
      categories: [
        FirstChoiceBankQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 61,
          questions: [
            "Rate your institution's expertise (1–5) in Gold & Silver (Savings), with brief justification.",
            "Describe your institution's process for reviewing a client's savings goal setup and KYC/wallet status before referring a Gold & Silver Savings opportunity.",
            'What legal and compliance framework does your institution maintain specific to savings goal structuring, recurring deposit readiness and deposits-not-insured disclosure requirements?',
            "What is your institution's existing client base or network relevant to Gold & Silver (Savings)?",
            "What is your institution's estimated monthly capacity to refer qualified Gold & Silver (Savings) clients?",
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Systems & Operations',
          startNum: 66,
          questions: [
            'What technology or systems does your institution use to manage Gold & Silver (Savings) referrals and records?',
            'How would your institution integrate Gold & Silver (Savings) referrals into its existing workflows?',
            'What training or resources would your institution need to represent Gold & Silver (Savings) effectively?',
            "How does your institution ensure compliance with One Core's Code of Conduct when referring Gold & Silver (Savings) clients?",
            'What risks specific to Gold & Silver (Savings) does your institution watch for, and how are they mitigated?',
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 71,
          questions: [
            'What internal criteria does your institution apply before referring a client into Gold & Silver Savings?',
            "How does your institution verify a client's KYC and wallet status before submitting a Gold & Silver referral?",
            'What role does your institution play in explaining market-price fluctuation risk to referred clients?',
            "How does your institution track a referred client's Gold & Silver goal progress over time?",
            'What process does your institution follow if a referred client wants to pause or exit their Gold & Silver goal?',
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 76,
          questions: [
            'How does your institution ensure the deposits-not-insured disclosure is communicated to every referred client?',
            'What reporting does your institution require from One Core on referred Gold & Silver accounts?',
            'How does your institution handle a dispute raised by a referred client about their Gold & Silver balance?',
            'What service-level expectations does your institution set for Gold & Silver referrals?',
            'How does your institution measure the success of clients referred into Gold & Silver Savings?',
          ],
        ),
      ],
    ),
    'q_piggy_individual': FirstChoiceBankQuestionnaireData(
      id: 'q_piggy_individual',
      title: 'Piggy — Individual Applicant Verification',
      subtitle:
          'Answer these 20 questions to show you can responsibly refer members into Piggy.',
      categories: [
        FirstChoiceBankQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 81,
          questions: [
            'Explain your understanding of how Piggy works within One Core, and how a member participates through it.',
            'How would you explain the Piggy micro-savings ladder — daily ₹10 savings with a life-stage path from School to Prince/Princess to Queens to Senior to a first-time client?',
            'What factors most affect consistency and growth for a member using Piggy?',
            "What would you check regarding the member's age/life-stage, daily saving capacity and wallet KYC status before referring a client into Piggy?",
            'What questions would you ask a client to see if Piggy suits their goals?',
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 86,
          questions: [
            'What concerns might a client raise about Piggy, and how would you address them?',
            "How would you differentiate One Core's Piggy from an informal daily-collection savings scheme (chit fund) with no ledger or audit trail?",
            'What is your existing network or client base relevant to Piggy?',
            'Would you ever promise assured returns or a guaranteed outcome to a client interested in Piggy? Why or why not?',
            'What is your plan to start referring clients into Piggy within your first 30 days as a partner?',
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Process & Documentation',
          startNum: 91,
          questions: [
            'What is the minimum daily saving amount for a Piggy goal, and how would you explain it to a budget-conscious client?',
            'How would you explain the Piggy life-stage ladder (School → Prince/Princess → Queens → Senior) to a client and their family?',
            "What would you check regarding a client's age and life-stage before setting up their Piggy goal?",
            'How would you support a client who wants to increase or pause their daily Piggy contribution?',
            'What would make you decline to refer a particular client into Piggy?',
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 96,
          questions: [
            'How would you explain the deposits-not-insured disclosure to a client or parent considering Piggy?',
            'How would you keep a client updated on their Piggy savings progress?',
            'What would you tell a client about how their daily deposits appear in the One Core passbook?',
            "How would you handle a client's complaint about a missed or delayed Piggy deposit, and who would you escalate it to?",
            'What is your plan to help a client build a consistent daily-saving habit through Piggy?',
          ],
        ),
      ],
    ),
    'q_piggy_institutional': FirstChoiceBankQuestionnaireData(
      id: 'q_piggy_institutional',
      title: 'Piggy — Institutional Applicant Verification',
      subtitle:
          "Establish your organization's expertise, systems and accountability for referring members into Piggy.",
      categories: [
        FirstChoiceBankQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 101,
          questions: [
            "Rate your institution's expertise (1–5) in Piggy, with brief justification.",
            "Describe your institution's process for assessing a client's life-stage and daily saving capacity before referring a Piggy opportunity.",
            'What legal and compliance framework does your institution maintain specific to micro-savings collection, life-stage ladder eligibility and deposits-not-insured disclosure?',
            "What is your institution's existing client base or network relevant to Piggy?",
            "What is your institution's estimated monthly capacity to refer qualified Piggy clients?",
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Systems & Operations',
          startNum: 106,
          questions: [
            'What technology or systems does your institution use to manage Piggy referrals and records?',
            'How would your institution integrate Piggy referrals into its existing workflows?',
            'What training or resources would your institution need to represent Piggy effectively?',
            "How does your institution ensure compliance with One Core's Code of Conduct when referring Piggy clients?",
            'What risks specific to Piggy does your institution watch for, and how are they mitigated?',
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 111,
          questions: [
            'What internal criteria does your institution apply before referring a client or family into Piggy?',
            "How does your institution verify a client's age/life-stage eligibility before submitting a Piggy referral?",
            'What role does your institution play in explaining the life-stage ladder to referred clients and their families?',
            "How does your institution track a referred client's daily-saving consistency over time?",
            'What process does your institution follow if a referred client wants to pause their Piggy contributions?',
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 116,
          questions: [
            'How does your institution ensure the deposits-not-insured disclosure is communicated to every referred Piggy client?',
            'What reporting does your institution require from One Core on referred Piggy accounts?',
            'How does your institution handle a dispute raised about a missed or delayed Piggy deposit?',
            'What service-level expectations does your institution set for Piggy referrals?',
            'How does your institution measure the success of clients referred into Piggy?',
          ],
        ),
      ],
    ),
    'q_fdrd_individual': FirstChoiceBankQuestionnaireData(
      id: 'q_fdrd_individual',
      title: 'FD & RD — Individual Applicant Verification',
      subtitle:
          'Answer these 20 questions to show you can responsibly refer members into FD & RD.',
      categories: [
        FirstChoiceBankQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 121,
          questions: [
            'Explain your understanding of how FD & RD works within One Core, and how a member participates through it.',
            'How would you explain the tiered Fixed Deposit rate card and the automatic rate-enhancement engine — senior +0.50%, super-senior +0.75%, Queens +0.25%, NRI +0.25%, capped at +1.00% over card rate to a first-time client?',
            'What factors most affect the maturity value for a member using FD & RD?',
            "What would you check regarding the member's tenure choice, eligibility slab (senior / super-senior / Queens / NRI) and KYC status before referring a client into FD & RD?",
            'What questions would you ask a client to see if FD & RD suits their goals?',
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 126,
          questions: [
            'What concerns might a client raise about FD & RD, and how would you address them?',
            "How would you differentiate One Core's FD & RD from a bank fixed deposit or post-office scheme without the ecosystem's rate-enhancement slabs?",
            'What is your existing network or client base relevant to FD & RD?',
            'Would you ever promise assured returns or a guaranteed outcome to a client interested in FD & RD? Why or why not?',
            'What is your plan to start referring clients into FD & RD within your first 30 days as a partner?',
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Process & Documentation',
          startNum: 131,
          questions: [
            'What is the minimum tenure and amount for an FD or RD booking, and how would you explain it to a first-time client?',
            'How would you explain the automatic rate-enhancement engine and its +1.00% cap to a client who may qualify for multiple slabs?',
            "What would you check regarding a client's eligibility documents (age proof for senior/super-senior, NRI status) before booking?",
            'How would you support a client through the maker-checker approval stage of an FD/RD booking?',
            'What would make you decline to refer a particular client into FD & RD?',
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 136,
          questions: [
            'How would you explain the deposits-not-insured disclosure to a client booking an FD or RD?',
            'How would you keep a client updated on their FD/RD status as it approaches maturity?',
            'What would you tell a client about renewal options and loan-against-FD readiness at or before maturity?',
            "How would you handle a client's complaint about an FD/RD booking or maturity payout, and who would you escalate it to?",
            'What is your plan to help a client choose the right tenure and slab for their FD/RD goal?',
          ],
        ),
      ],
    ),
    'q_fdrd_institutional': FirstChoiceBankQuestionnaireData(
      id: 'q_fdrd_institutional',
      title: 'FD & RD — Institutional Applicant Verification',
      subtitle:
          "Establish your organization's expertise, systems and accountability for referring members into FD & RD.",
      categories: [
        FirstChoiceBankQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 141,
          questions: [
            "Rate your institution's expertise (1–5) in FD & RD, with brief justification.",
            "Describe your institution's process for verifying a client's eligibility slab and tenure choice against the tiered rate card before referring an FD & RD opportunity.",
            'What legal and compliance framework does your institution maintain specific to the tiered rate-card configuration, rate-enhancement caps and maturity/renewal processing?',
            "What is your institution's existing client base or network relevant to FD & RD?",
            "What is your institution's estimated monthly capacity to refer qualified FD & RD clients?",
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Systems & Operations',
          startNum: 146,
          questions: [
            'What technology or systems does your institution use to manage FD & RD referrals and records?',
            'How would your institution integrate FD & RD referrals into its existing workflows?',
            'What training or resources would your institution need to represent FD & RD effectively?',
            "How does your institution ensure compliance with One Core's Code of Conduct when referring FD & RD clients?",
            'What risks specific to FD & RD does your institution watch for, and how are they mitigated?',
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 151,
          questions: [
            'What internal criteria does your institution apply before referring a client into FD & RD?',
            "How does your institution verify a client's eligibility slab (senior / super-senior / Queens / NRI) before submitting a referral?",
            'What role does your institution play in explaining the rate-enhancement cap to referred clients?',
            "How does your institution track a referred client's FD/RD booking through maker-checker approval?",
            'What process does your institution follow if a referred client wants to break or prematurely close an FD/RD?',
          ],
        ),
        FirstChoiceBankQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 156,
          questions: [
            'How does your institution ensure the deposits-not-insured disclosure is communicated to every referred client?',
            'What reporting does your institution require from One Core on referred FD/RD bookings and maturities?',
            'How does your institution handle a dispute raised about an FD/RD maturity payout?',
            'What service-level expectations does your institution set for FD & RD referrals?',
            'How does your institution measure the success of clients referred into FD & RD?',
          ],
        ),
      ],
    ),
  };
}

class FirstChoiceBankDemoApplicantData {
  static const Map<String, dynamic> sample = {
    'udyamiMember': 'Yes',
    'memberId': '123123',
    'fullName': 'Manjunath Gowda',
    'dob': '1988-11-02',
    'gender': 'Male',
    'fatherHusbandName': 'Siddappa Gowda',
    'maritalStatus': 'Married',
    'bloodGroup': 'O+',
    'nationality': 'Indian',
    'languages': 'Kannada, English, Hindi',
    'mobile': '9845098450',
    'altMobile': '',
    'email': 'manjunath.gowda@example.test',
    'occupation': 'Cooperative society staff',
    'houseStreetVillage': '12, Temple Street, Malleshwaram',
    'taluk': 'Bengaluru North',
    'district': 'Bengaluru Urban',
    'stateName': 'Karnataka',
    'pin': '560003',
    'ward': 'Malleshwaram Ward',
    'yearsLivedHere': '11',
    'homeType': 'Own',
    'landmark': 'Near Malleshwaram Circle',
    'aadhaarNumber': '234567890123',
    'aadhaarMobile': '9845098450',
    'aadhaarName': 'Manjunath Gowda',
    'aadhaarConsent': true,
    'businessType': 'individual',
    'hasExperience': true,
    'whereWorked': 'Malleshwaram Cooperative Credit Society',
    'role': 'Savings Officer',
    'howLong': '2016–2026',
    'whatYouDid':
        'Managed member savings passbooks, set up recurring deposits and helped members apply for loan-against-FD facilities.',
    'yearsExperience': '10',
    'highestQualification': 'B.Com',
    'toolsKnown':
        'UPI Autopay, mutual fund portals, core banking software',
    'familiarityChecklist': [
      'I know my way around KYC / AML basics',
      "I'm familiar with SIP / mutual-fund style savings plans",
      "I've explained investment products to clients before",
    ],
    'workAddress': '12, Temple Street, Malleshwaram, Bengaluru',
    'ownership': 'Owned',
    'workLandmark': 'Malleshwaram Circle',
    'wardAreaServe': 'Malleshwaram Ward',
    'villagesCovered': 'Malleshwaram, Rajajinagar, Sadashivanagar',
    'workFacilities': [
      'Private area for clients to discuss their investments',
      'Secure, lockable place to store paperwork',
      'CCTV or other document security',
      'Internet access to log leads and savers',
      'Computer, scanner and printer on site',
      'Familiar with One Core KYC / onboarding process',
    ],
    'accountHolderName': 'Manjunath Gowda',
    'accountType': 'Savings',
    'accountNumber': 'XXXXXX5590',
    'ifsc': 'SBIN0009876',
    'bankBranch': 'Malleshwaram Branch',
    'nomineeName': 'Lakshmi Gowda',
    'relationship': 'Spouse',
    'nomineeMobile': '9845011223',
    'nomineeAccountNumber': 'XXXXXX3345',
    'nomineeIfsc': 'SBIN0009876',
    'nomineeBankBranch': 'Malleshwaram Branch',
    'services': ['loans', 'piggy'],
    'wardArea': 'Malleshwaram Ward',
    'newSaversPerMonth': '15',
    'hireSupportStaff': 'No',
    'bestTimeTraining': 'Weekends',
    'smartphone': 'Android',
    'comfortApps': 'Very Comfortable',
    'usedAppsForInvestments': 'Yes, Regularly',
    'comfortPayments': 'Very Comfortable',
    'langComm': [
      "I'm comfortable using the Partner app already",
      'I can talk to clients in Kannada',
      'I can talk to clients in English',
    ],
    'c1': true,
    'c2': true,
    'c3': true,
    'c4': true,
    'c5': true,
    'c6': true,
    'c7': true,
    'c8': true,
    'c9': true,
    'place': 'Bengaluru',
    'date8': '2026-08-31',
    'depositAck1': true,
    'depositAck2': true,
    'signed': true,
  };
}
