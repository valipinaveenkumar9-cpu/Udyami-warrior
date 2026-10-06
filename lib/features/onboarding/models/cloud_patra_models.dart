class QuestionCategory {
  final String name;
  final int startNum;
  final List<String> questions;

  const QuestionCategory({
    required this.name,
    required this.startNum,
    required this.questions,
  });
}

class QuestionnaireData {
  final String id;
  final String title;
  final String subtitle;
  final List<QuestionCategory> categories;

  const QuestionnaireData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categories,
  });
}

class CloudPatraQuestionnaires {
  static const Map<String, QuestionnaireData> all = {
    'q_patra_individual': QuestionnaireData(
      id: 'q_patra_individual',
      title: 'Patra Trust — Individual Applicant Verification Questionnaire',
      subtitle: 'Establish basic, entry-level fitness for handling legal opinions and safe document custody.',
      categories: [
        QuestionCategory(
          name: 'Background & Legal Exposure',
          startNum: 1,
          questions: [
            'Have you ever worked with a lawyer, advocate, or law office, even informally? Please describe.',
            'Do you have any experience handling legal or property-related documents for others?',
            'Have you assisted anyone in applying for or renewing legal documents (e.g., sale deeds, khata, encumbrance certificates)?',
            'What is your current occupation, and does it involve regular interaction with legal or government offices?',
            "Have you ever accompanied a family member or client to a sub-registrar's office, revenue office, or court?",
            'Do you have any prior experience as a document writer, paralegal, or clerk?',
            'Are you familiar with common legal terms used in property transactions (e.g., mutation, encumbrance, stamp duty)?',
          ],
        ),
        QuestionCategory(
          name: 'Document Handling & Security Practices',
          startNum: 8,
          questions: [
            'How would you securely store original legal documents entrusted to you by clients?',
            'Do you have a lockable cupboard, safe, or secure room at your work location?',
            'How would you keep track of which documents belong to which client?',
            "What would you do if a client's document went missing?",
            'Have you used any digital tool (scanner, app, cloud storage) to store or organize documents?',
            "How would you protect a client's document from fire, water damage, or theft?",
            'Would you be comfortable maintaining a logbook or register of documents received and returned?',
          ],
        ),
        QuestionCategory(
          name: 'Legal Opinions & Property Document Knowledge',
          startNum: 15,
          questions: [
            'Can you explain, in your own words, what a "legal opinion" on a property means?',
            'What documents would you check before advising someone that a property is safe to buy?',
            'Have you heard of an Encumbrance Certificate (EC)? What is it used for?',
            'What is the difference between a sale deed and a general power of attorney?',
            'Are you aware of what "khata transfer" means?',
            'Do you know what a title search or chain-of-title verification involves?',
            "Would you know who to escalate a case to if you found a legal issue you couldn't resolve yourself?",
          ],
        ),
        QuestionCategory(
          name: 'Operational Readiness',
          startNum: 22,
          questions: [
            'How many hours a week can you realistically dedicate to this work?',
            'Do you have access to a computer, printer, and scanner?',
            'Is your work location easily accessible to clients in your ward/area?',
            "Would you be able to visit a client's property or the sub-registrar's office if required?",
            "How would you handle multiple clients' documents at the same time without mixing them up?",
            'Are you willing to undergo training on legal-document handling procedures before starting?',
            'Would you be able to coordinate with an advocate for legal opinions when required?',
          ],
        ),
        QuestionCategory(
          name: 'Ethics, Compliance & Client Trust',
          startNum: 29,
          questions: [
            'What would you do if a client asked you to backdate or alter a document?',
            'How would you handle a situation where a document contains sensitive personal information?',
            'Would you be willing to sign a confidentiality undertaking for client documents?',
            'What would you do if you suspected a document presented to you was forged?',
            "How would you explain a delay in returning a client's document?",
            'Are you willing to be held accountable (financially or otherwise) for a document lost due to negligence?',
            'Why should a client trust you specifically with their original property documents?',
          ],
        ),
      ],
    ),
    'q_patra_institutional': QuestionnaireData(
      id: 'q_patra_institutional',
      title: 'Patra Trust — Institutional Applicant Verification Questionnaire',
      subtitle: "Rigorous scrutiny of the organization's legal-services track record, scale, and accountability.",
      categories: [
        QuestionCategory(
          name: 'Organizational Background & Legal Track Record',
          startNum: 36,
          questions: [
            'How many years has your organization/firm been operating in legal services, document management, or related fields?',
            'How many advocates, legal associates, or paralegals are currently on your payroll or retainer?',
            "Provide details of your firm's registration (e.g., partnership deed, LLP agreement, Bar Council enrolment of partners).",
            'What is the total volume of legal opinions or document-verification cases your organization has handled in the last 3 years?',
            "Can you list three reference clients or institutions your firm has previously served in this domain?",
            'Has your organization ever been involved in any litigation, disciplinary proceeding, or regulatory action? Provide details.',
            "What is your organization's annual case/document-throughput capacity?",
          ],
        ),
        QuestionCategory(
          name: 'Infrastructure & Document Security Systems',
          startNum: 43,
          questions: [
            "Describe your organization's physical infrastructure for secure document storage (vaults, fireproof cabinets, CCTV, access control).",
            'Do you maintain a digital document management system (DMS)? Which one, and what security certifications does it hold?',
            'What is your document backup and disaster-recovery policy?',
            "How does your organization prevent unauthorized internal access to client documents?",
            'Do you carry insurance against loss, theft, or damage of client-held documents? What is the coverage amount?',
            'What is your average document retrieval time for an active client request?',
            'How do you ensure chain-of-custody is maintained when a document moves between staff members?',
          ],
        ),
        QuestionCategory(
          name: 'Legal & Domain Expertise',
          startNum: 50,
          questions: [
            "Describe your organization's process for issuing a formal legal opinion on a property.",
            'What quality-control or peer-review process do you follow before a legal opinion is finalized?',
            'How does your organization stay current with changes in property law, stamp duty, and registration rules in this state?',
            "Describe a complex or disputed title case your organization has successfully resolved.",
            "What is your organization's error/liability track record on legal opinions issued (any claims, corrections, or disputes)?",
            'Do you have in-house expertise in agricultural land conversion, inheritance law, and encumbrance verification?',
            'How do you verify the authenticity of documents submitted by clients (e.g., against forged sale deeds)?',
          ],
        ),
        QuestionCategory(
          name: 'Operations, Scale & Staffing',
          startNum: 57,
          questions: [
            'How many wards/locations can your organization realistically service simultaneously?',
            'What is your staff-to-client ratio, and how do you plan to scale it under this partnership?',
            "Describe your standard operating procedure (SOP) for onboarding a new client's documents.",
            'What escalation matrix do you follow when a field-level issue cannot be resolved by front-line staff?',
            'How do you train and certify new staff before they handle client-sensitive legal documents?',
            'What is your average staff attrition rate, and how do you manage continuity of client files when staff leave?',
            "Describe your organization's technology stack for case tracking and client communication.",
          ],
        ),
        QuestionCategory(
          name: 'Compliance, Financial Standing & Accountability',
          startNum: 64,
          questions: [
            'Is your organization GST-registered and compliant with applicable tax filings? Please share registration details.',
            "What is your organization's audited annual turnover for the last two financial years?",
            'Do you have a documented code of conduct or compliance policy covering conflict of interest and confidentiality?',
            'How does your organization handle a data breach or document leak, should one occur?',
            'What indemnity or liability clauses are you willing to accept in a partnership agreement with CloudPatra?',
            'Provide details of any professional indemnity insurance or bond your organization holds.',
            'Why should CloudPatra select your organization over other established legal/document-service providers in this ward?',
          ],
        ),
      ],
    ),
    'q_samada_individual': QuestionnaireData(
      id: 'q_samada_individual',
      title: 'SamadaCare — Individual Applicant Verification Questionnaire',
      subtitle: 'Establish basic, entry-level fitness for property/asset upkeep and caretaking.',
      categories: [
        QuestionCategory(
          name: 'Background & Experience',
          startNum: 71,
          questions: [
            'Have you ever managed or looked after a property (your own or someone else\'s) on a regular basis?',
            'Do you have experience coordinating repair or maintenance work (plumbing, electrical, painting, etc.)?',
            'Have you worked as a caretaker, watchman, property manager, or in a similar role before?',
            'What is your current occupation, and how much time can you spare for property visits?',
            'Do you own or have you rented property yourself? What did that teach you about upkeep?',
            'Have you ever hired or supervised local workers (electrician, plumber, gardener, etc.)?',
            "Are you familiar with the neighbourhood/ward where you'd be providing this service?",
          ],
        ),
        QuestionCategory(
          name: 'Property & Asset Care Knowledge',
          startNum: 78,
          questions: [
            'What would you check during a routine visit to an unoccupied property?',
            'How would you identify early signs of water leakage, dampness, or structural issues?',
            'What steps would you take if you found the property had been broken into?',
            'How would you handle overgrown vegetation, pest issues, or general neglect on a property?',
            "Would you know how to arrange for property-tax payment or utility-bill payment on behalf of an owner?",
            "What would you do if you noticed unauthorized occupation or encroachment on a client's property?",
            "How would you keep an owner updated about the condition of their property while they're away?",
          ],
        ),
        QuestionCategory(
          name: 'Operational Capability',
          startNum: 85,
          questions: [
            'How often would you be able to visit and inspect a property under your care?',
            'Do you have your own transport (bike/car) to travel between properties?',
            'Would you be able to take photos/videos during inspections to share as proof of visit?',
            "How would you maintain records of expenses incurred on a client's behalf (repairs, bills, etc.)?",
            "What would you do in an emergency, like a fire or major water leak, at a property you're managing?",
            'Are you comfortable using a smartphone app to log visits, updates, and expenses?',
            'How would you handle a situation where a client is unreachable during an emergency?',
          ],
        ),
        QuestionCategory(
          name: 'Vendor & Local Coordination',
          startNum: 92,
          questions: [
            'Do you have contacts for local plumbers, electricians, painters, or security services?',
            "How would you make sure a hired worker doesn't overcharge the client?",
            'Would you get multiple quotes before approving a repair expense?',
            'How would you verify that repair work was actually completed properly?',
            "Would you be comfortable negotiating rates with local vendors on the client's behalf?",
            'How would you handle a dispute between a hired worker and the client?',
            'What would you do if a vendor demanded advance payment before starting work?',
          ],
        ),
        QuestionCategory(
          name: 'Ethics, Trust & Accountability',
          startNum: 99,
          questions: [
            'Why should an owner trust you to manage their property while they are away?',
            'What would you do if you were offered money by someone to "look the other way" on encroachment?',
            'How would you handle client funds given to you for repairs or bill payments?',
            "Would you be willing to submit receipts and proof for every expense you incur on a client's behalf?",
            'What would you do if you made a mistake that cost the client money?',
            "How would you maintain confidentiality about a client's absence or property details for their safety?",
            'Are you willing to be held accountable for negligence resulting in property damage or loss?',
          ],
        ),
      ],
    ),
    'q_samada_institutional': QuestionnaireData(
      id: 'q_samada_institutional',
      title: 'SamadaCare — Institutional Applicant Verification Questionnaire',
      subtitle: "Rigorous scrutiny of the organization's property/facility-management track record, scale, and accountability.",
      categories: [
        QuestionCategory(
          name: 'Organizational Background & Track Record',
          startNum: 106,
          questions: [
            'How many years has your organization been in the property/facility-management or asset-care business?',
            'How many properties does your organization currently manage, and across how many wards/localities?',
            'What is the legal structure of your organization (proprietorship, partnership, Pvt Ltd, etc.)? Provide registration details.',
            'Can you provide three verifiable references of clients whose properties you currently manage or have managed?',
            'Has your organization ever faced a client complaint, legal dispute, or contract termination? Provide details.',
            "What is your organization's approximate annual portfolio value of assets under care?",
            "Describe your organization's experience managing unoccupied or NRI-owned properties specifically.",
          ],
        ),
        QuestionCategory(
          name: 'Infrastructure & Staffing',
          startNum: 113,
          questions: [
            'How many field staff/caretakers does your organization employ, and what is their average tenure?',
            "Describe your organization's staff-vetting process (background checks, police verification, etc.).",
            'What vehicles, tools, and equipment does your organization maintain for property upkeep?',
            'Do you have a 24/7 emergency-response mechanism? Describe it.',
            'What is your staff-to-property ratio, and how do you ensure adequate visit frequency?',
            "Describe your organization's technology platform for tracking visits, expenses, and property condition.",
            'How does your organization ensure continuity of service if a staff member leaves or is unavailable?',
          ],
        ),
        QuestionCategory(
          name: 'Operational Processes',
          startNum: 120,
          questions: [
            "Describe your organization's standard operating procedure for a routine property inspection.",
            'What documentation or reporting do you provide clients after each visit (photos, condition reports, etc.)?',
            'Describe your vendor-empanelment process for repairs (plumbers, electricians, contractors).',
            'How does your organization handle competitive quoting and cost control on repair work?',
            'What is your average response time to a property emergency (break-in, fire, flooding)?',
            "Describe a case where your organization successfully prevented or resolved encroachment on a client's property.",
            'How do you manage recurring obligations like property tax, utility bills, and society dues on behalf of clients?',
          ],
        ),
        QuestionCategory(
          name: 'Financial Controls & Accountability',
          startNum: 127,
          questions: [
            'What financial controls does your organization have to prevent misuse of client funds?',
            'Do you maintain a separate escrow or client account for funds meant for repairs/bills?',
            "What is your organization's audited annual turnover for the last two financial years?",
            'Are you GST-registered and compliant with applicable statutory filings?',
            "Do you carry liability insurance covering property damage or loss caused by your staff's negligence? What is the coverage amount?",
            'What is your policy on reimbursing a client for loss caused by staff negligence or fraud?',
            'Describe your internal audit process for expenses billed to clients.',
          ],
        ),
        QuestionCategory(
          name: 'Compliance, Ethics & Scale-Readiness',
          startNum: 134,
          questions: [
            'Do you have a documented code of conduct covering conflict of interest, bribery, and client confidentiality?',
            'How does your organization handle a staff member found demanding bribes from vendors or misusing client funds?',
            "What data-privacy safeguards protect information about a client's property and absence?",
            'How many additional properties/wards can your organization take on under this partnership without compromising service quality?',
            "Describe your organization's training program for new field staff before they're assigned properties.",
            'What indemnity or liability clauses are you willing to accept in a partnership agreement with CloudPatra?',
            'Why should CloudPatra select your organization over other established facility/asset-management providers in this region?',
          ],
        ),
      ],
    ),
    'q_leadsetu_individual': QuestionnaireData(
      id: 'q_leadsetu_individual',
      title: 'LeadSetu — Individual Applicant Verification Questionnaire',
      subtitle: 'Verify your ability to source, qualify and hand off genuine leads responsibly.',
      categories: [
        QuestionCategory(
          name: 'Lead Generation Experience',
          startNum: 141,
          questions: [
            'Have you previously generated leads for property, legal, financial, real-estate or professional services? Please describe.',
            'How do you normally identify potential customers who may need a service?',
            'How many qualified leads can you realistically generate per month?',
            'Which local areas, communities or customer groups can you reach effectively?',
            'Have you worked with referral commissions or channel-partner programs before?',
            'How do you distinguish a genuine prospect from a casual enquiry?',
            'What experience do you have communicating with customers before referring them to a service provider?',
          ],
        ),
        QuestionCategory(
          name: 'Lead Qualification & Handoff',
          startNum: 148,
          questions: [
            'What information would you collect before sending a lead to CloudPatra?',
            'How would you confirm that a lead has a genuine requirement?',
            'How would you avoid sending duplicate, false or low-quality leads?',
            'How quickly can you hand off a qualified lead after receiving the enquiry?',
            'How would you explain the service without making promises that only the service provider can make?',
            'What would you do if a prospect asks you for a legal opinion or property-care commitment that you are not authorized to provide?',
            'How would you maintain a record of leads referred and their status?',
          ],
        ),
        QuestionCategory(
          name: 'Ethics, Privacy & Accountability',
          startNum: 155,
          questions: [
            'How would you obtain permission before sharing a prospect’s contact details?',
            'What would you do if someone offered you money to send an unqualified lead?',
            'How would you protect customer phone numbers and other personal information?',
            'What would you do if you discovered that a lead was based on false information?',
            'Would you disclose any personal relationship or conflict of interest involving a prospect?',
            'How would you handle a customer complaint about your referral?',
            'Why should CloudPatra trust you with customer introductions?',
          ],
        ),
      ],
    ),
    'q_leadsetu_institutional': QuestionnaireData(
      id: 'q_leadsetu_institutional',
      title: 'LeadSetu — Institutional Applicant Verification Questionnaire',
      subtitle: 'Review the organization’s lead-generation scale, sourcing controls, data practices and accountability.',
      categories: [
        QuestionCategory(
          name: 'Organization & Lead Track Record',
          startNum: 162,
          questions: [
            'How many years has your organization been involved in lead generation, sales, referrals or channel partnerships?',
            'How many qualified leads does your organization generate per month?',
            'Which customer segments and geographic areas can your organization reach?',
            'Provide examples of similar referral or channel-partner programs handled previously.',
            'What is your organization’s lead-to-conversion performance for comparable services?',
            'How many employees or field representatives are involved in lead generation?',
            'Describe your organization’s process for preventing duplicate or fraudulent leads.',
          ],
        ),
        QuestionCategory(
          name: 'Lead Qualification, Technology & Handoff',
          startNum: 169,
          questions: [
            'Describe your standard operating procedure for capturing and qualifying a new lead.',
            'What minimum information is collected before a lead is submitted?',
            'What CRM or lead-management system do you use?',
            'How do you track lead ownership, status, follow-up and conversion?',
            'What is your average turnaround time from enquiry to qualified handoff?',
            'How do you prevent unauthorized staff from altering or exporting lead data?',
            'How do you manage rejected, duplicate or unqualified leads?',
          ],
        ),
        QuestionCategory(
          name: 'Compliance, Privacy & Commercial Accountability',
          startNum: 176,
          questions: [
            'How does your organization obtain consent before sharing customer contact information?',
            'What safeguards protect customer personal data?',
            'How do you handle a customer complaint caused by inaccurate information supplied by your organization?',
            'What controls prevent staff from accepting side payments for referrals?',
            'How do you reconcile commissions against successfully converted leads?',
            'What conflict-of-interest policy applies to your referral staff?',
            'Why should CloudPatra select your organization as a LeadSetu partner?',
          ],
        ),
      ],
    ),
  };
}

class StepMeta {
  final String title;
  final String subtitle;
  const StepMeta({required this.title, required this.subtitle});
}

class CloudPatraStepMeta {
  static const Map<String, StepMeta> meta = {
    's1': StepMeta(
      title: 'About You',
      subtitle: 'As it appears on your Aadhaar / PAN card',
    ),
    's2': StepMeta(
      title: 'Verify Your Aadhaar',
      subtitle: 'One secure government check',
    ),
    's3': StepMeta(
      title: 'Business & Experience',
      subtitle: 'Your business, legal & property experience',
    ),
    's4': StepMeta(
      title: "Where You'll Work From",
      subtitle: "We'll visit before approving",
    ),
    's5': StepMeta(
      title: 'Your Bank Details',
      subtitle: 'For commission payments & FD refund',
    ),
    's6': StepMeta(
      title: "What You'd Like to Do",
      subtitle: 'Choose one service to apply for',
    ),
    's7': StepMeta(
      title: 'Availability & Comfort',
      subtitle: 'With the Partner app',
    ),
    's8': StepMeta(
      title: 'Consent',
      subtitle: 'Your promises, and your signature',
    ),
    's9': StepMeta(
      title: 'Review Application',
      subtitle: 'Check everything before you submit',
    ),
  };
}

class DemoApplicantData {
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
          "I'm familiar with the sub-registrar's process"
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
          'Computer, scanner and printer on site'
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
        'services': ['patra'],
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
        'c5': true,
        'c6': true,
        'c7': true,
        'place': 'Bengaluru',
        'date8': '2026-08-31',
        'depositAck1': true,
        'depositAck2': true,
        'signed': true,
        'signedAt': '2026-08-31T10:00:00.000Z',
      };
}
