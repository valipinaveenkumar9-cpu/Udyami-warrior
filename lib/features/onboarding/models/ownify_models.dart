// Ownify Channel Partner Models and Data Schemas

class OwnifyQuestionCategory {
  final String name;
  final int startNum;
  final List<String> questions;

  const OwnifyQuestionCategory({
    required this.name,
    required this.startNum,
    required this.questions,
  });
}

class OwnifyQuestionnaireData {
  final String id;
  final String title;
  final String subtitle;
  final List<OwnifyQuestionCategory> categories;

  const OwnifyQuestionnaireData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categories,
  });
}

class OwnifyQuestionnaires {
  static const Map<String, OwnifyQuestionnaireData> all = {
    'q_farmland_individual': OwnifyQuestionnaireData(
      id: 'q_farmland_individual',
      title: 'Farmland — Individual Applicant Verification',
      subtitle: 'Answer these 15 questions to show you can responsibly refer members into Farmland.',
      categories: [
        OwnifyQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 1,
          questions: [
            'Explain your understanding of fractional ownership as it applies to Farmland, and how members participate through it.',
            'How would you explain the ₹10/day saver entry point and 5–10 year tenure to a first-time client?',
            'What factors most affect value or returns for Farmland in India?',
            'What would you check regarding agricultural land classification, conversion status and title chain before referring a client?',
            'What questions would you ask a client to see if Farmland suits their goals?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Risk, Trust & Positioning',
          startNum: 6,
          questions: [
            'What concerns might a client raise about Farmland, and how would you address them?',
            'How would you differentiate Farmland from a fixed deposit or a gold savings scheme?',
            'What is your existing network or client base relevant to Farmland?',
            'Would you ever promise assured returns to a client interested in Farmland? Why or why not?',
            'What is your plan to start referring clients into Farmland within your first 30 days as a partner?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Process & Ongoing Support',
          startNum: 11,
          questions: [
            'What is the minimum entry amount, and how would you explain the lock-in period for Farmland to a budget-conscious client?',
            'What documents or disclosures would you make sure a client has reviewed before they commit to Farmland?',
            'How would you support a client who wants to exit or transfer their Farmland fraction?',
            'What would make you decline to refer a particular client into Farmland?',
            'How would you keep a client updated on their Farmland investment after onboarding?',
          ],
        ),
      ],
    ),
    'q_farmland_institutional': OwnifyQuestionnaireData(
      id: 'q_farmland_institutional',
      title: 'Farmland — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into Farmland.',
      categories: [
        OwnifyQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 16,
          questions: [
            'Rate your institution\'s expertise (1–5) in Farmland, with brief justification.',
            'Describe your institution\'s process for verifying agricultural land classification, conversion status and title chain before referring a Farmland opportunity.',
            'What legal and compliance framework does your institution maintain specific to agricultural land classification, conversion status and title chain?',
            'What is your institution\'s existing client base or network relevant to Farmland?',
            'What is your institution\'s estimated monthly capacity to refer qualified Farmland clients?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Systems & Operations',
          startNum: 21,
          questions: [
            'What technology or systems does your institution use to manage Farmland referrals and records?',
            'How would your institution integrate Farmland referrals into its existing workflows?',
            'What training or resources would your institution need to represent Farmland effectively?',
            'How does your institution ensure compliance with Ownify\'s Code of Conduct when referring Farmland clients?',
            'What risks specific to Farmland does your institution watch for, and how are they mitigated?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Diligence & Accountability',
          startNum: 26,
          questions: [
            'What due-diligence checklist does your institution apply before approving a Farmland opportunity for referral?',
            'How does your institution track referral outcomes and client satisfaction for Farmland?',
            'What escalation process does your institution follow for a Farmland-related client complaint?',
            'How does your institution vet the developer or operator behind a Farmland opportunity?',
            'What internal sign-off or approval is required before your institution refers a Farmland client?',
          ],
        ),
      ],
    ),
    'q_plots_individual': OwnifyQuestionnaireData(
      id: 'q_plots_individual',
      title: 'Plots — Individual Applicant Verification',
      subtitle: 'Answer these 15 questions to show you can responsibly refer members into Plots.',
      categories: [
        OwnifyQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 31,
          questions: [
            'Explain your understanding of fractional ownership as it applies to Plots, and how members participate through it.',
            'How would you explain the 1 fraction = 1 sq ft structure and the consolidation path to 100% ownership to a first-time client?',
            'What factors most affect value or returns for Plots in India?',
            'What would you check regarding RERA registration and layout-approval status for the plotted development before referring a client?',
            'What questions would you ask a client to see if Plots suits their goals?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Risk, Trust & Positioning',
          startNum: 36,
          questions: [
            'What concerns might a client raise about Plots, and how would you address them?',
            'How would you differentiate Plots from buying a plot directly from a private developer?',
            'What is your existing network or client base relevant to Plots?',
            'Would you ever promise assured returns to a client interested in Plots? Why or why not?',
            'What is your plan to start referring clients into Plots within your first 30 days as a partner?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Process & Ongoing Support',
          startNum: 41,
          questions: [
            'What is the minimum entry amount, and how would you explain the lock-in period for Plots to a budget-conscious client?',
            'What documents or disclosures would you make sure a client has reviewed before they commit to Plots?',
            'How would you support a client who wants to exit or transfer their Plots fraction?',
            'What would make you decline to refer a particular client into Plots?',
            'How would you keep a client updated on their Plots investment after onboarding?',
          ],
        ),
      ],
    ),
    'q_plots_institutional': OwnifyQuestionnaireData(
      id: 'q_plots_institutional',
      title: 'Plots — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into Plots.',
      categories: [
        OwnifyQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 46,
          questions: [
            'Rate your institution\'s expertise (1–5) in Plots, with brief justification.',
            'Describe your institution\'s process for verifying RERA registration, layout approvals and clear title for the development before referring a Plots opportunity.',
            'What legal and compliance framework does your institution maintain specific to RERA registration and layout-approval status for the plotted development?',
            'What is your institution\'s existing client base or network relevant to Plots?',
            'What is your institution\'s estimated monthly capacity to refer qualified Plots clients?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Systems & Operations',
          startNum: 51,
          questions: [
            'What technology or systems does your institution use to manage Plots referrals and records?',
            'How would your institution integrate Plots referrals into its existing workflows?',
            'What training or resources would your institution need to represent Plots effectively?',
            'How does your institution ensure compliance with Ownify\'s Code of Conduct when referring Plots clients?',
            'What risks specific to Plots does your institution watch for, and how are they mitigated?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Diligence & Accountability',
          startNum: 56,
          questions: [
            'What due-diligence checklist does your institution apply before approving a Plots opportunity for referral?',
            'How does your institution track referral outcomes and client satisfaction for Plots?',
            'What escalation process does your institution follow for a Plots-related client complaint?',
            'How does your institution vet the developer or operator behind a Plots opportunity?',
            'What internal sign-off or approval is required before your institution refers a Plots client?',
          ],
        ),
      ],
    ),
    'q_residence_individual': OwnifyQuestionnaireData(
      id: 'q_residence_individual',
      title: 'Residence — Individual Applicant Verification',
      subtitle: 'Answer these 15 questions to show you can responsibly refer members into Residence.',
      categories: [
        OwnifyQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 61,
          questions: [
            'Explain your understanding of fractional ownership as it applies to Residence, and how members participate through it.',
            'How would you explain the path from a fractional site to full construction via Build AI Homes to a first-time client?',
            'What factors most affect value or returns for Residence in India?',
            'What would you check regarding RERA compliance and construction-linked approvals for residential projects before referring a client?',
            'What questions would you ask a client to see if Residence suits their goals?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Risk, Trust & Positioning',
          startNum: 66,
          questions: [
            'What concerns might a client raise about Residence, and how would you address them?',
            'How would you differentiate Residence from taking a home loan to buy a house outright?',
            'What is your existing network or client base relevant to Residence?',
            'Would you ever promise assured returns to a client interested in Residence? Why or why not?',
            'What is your plan to start referring clients into Residence within your first 30 days as a partner?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Process & Ongoing Support',
          startNum: 71,
          questions: [
            'What is the minimum entry amount, and how would you explain the lock-in period for Residence to a budget-conscious client?',
            'What documents or disclosures would you make sure a client has reviewed before they commit to Residence?',
            'How would you support a client who wants to exit or transfer their Residence fraction?',
            'What would make you decline to refer a particular client into Residence?',
            'How would you keep a client updated on their Residence investment after onboarding?',
          ],
        ),
      ],
    ),
    'q_residence_institutional': OwnifyQuestionnaireData(
      id: 'q_residence_institutional',
      title: 'Residence — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into Residence.',
      categories: [
        OwnifyQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 76,
          questions: [
            'Rate your institution\'s expertise (1–5) in Residence, with brief justification.',
            'Describe your institution\'s process for verifying RERA compliance, builder track record and construction-linked approvals before referring a Residence opportunity.',
            'What legal and compliance framework does your institution maintain specific to RERA compliance and construction-linked approvals for residential projects?',
            'What is your institution\'s existing client base or network relevant to Residence?',
            'What is your institution\'s estimated monthly capacity to refer qualified Residence clients?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Systems & Operations',
          startNum: 81,
          questions: [
            'What technology or systems does your institution use to manage Residence referrals and records?',
            'How would your institution integrate Residence referrals into its existing workflows?',
            'What training or resources would your institution need to represent Residence effectively?',
            'How does your institution ensure compliance with Ownify\'s Code of Conduct when referring Residence clients?',
            'What risks specific to Residence does your institution watch for, and how are they mitigated?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Diligence & Accountability',
          startNum: 86,
          questions: [
            'What due-diligence checklist does your institution apply before approving a Residence opportunity for referral?',
            'How does your institution track referral outcomes and client satisfaction for Residence?',
            'What escalation process does your institution follow for a Residence-related client complaint?',
            'How does your institution vet the developer or operator behind a Residence opportunity?',
            'What internal sign-off or approval is required before your institution refers a Residence client?',
          ],
        ),
      ],
    ),
    'q_holiday_individual': OwnifyQuestionnaireData(
      id: 'q_holiday_individual',
      title: 'Holiday Homes — Individual Applicant Verification',
      subtitle: 'Answer these 15 questions to show you can responsibly refer members into Holiday Homes.',
      categories: [
        OwnifyQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 91,
          questions: [
            'Explain your understanding of fractional ownership as it applies to Holiday Homes, and how members participate through it.',
            'How would you explain the rental-income-plus-appreciation model with optional usage days to a first-time client?',
            'What factors most affect value or returns for Holiday Homes in India?',
            'What would you check regarding hospitality and short-stay rental regulations for managed leisure assets before referring a client?',
            'What questions would you ask a client to see if Holiday Homes suits their goals?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Risk, Trust & Positioning',
          startNum: 96,
          questions: [
            'What concerns might a client raise about Holiday Homes, and how would you address them?',
            'How would you differentiate Holiday Homes from a timeshare or a vacation-booking membership?',
            'What is your existing network or client base relevant to Holiday Homes?',
            'Would you ever promise assured returns to a client interested in Holiday Homes? Why or why not?',
            'What is your plan to start referring clients into Holiday Homes within your first 30 days as a partner?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Process & Ongoing Support',
          startNum: 101,
          questions: [
            'What is the minimum entry amount, and how would you explain the lock-in period for Holiday Homes to a budget-conscious client?',
            'What documents or disclosures would you make sure a client has reviewed before they commit to Holiday Homes?',
            'How would you support a client who wants to exit or transfer their Holiday Homes fraction?',
            'What would make you decline to refer a particular client into Holiday Homes?',
            'How would you keep a client updated on their Holiday Homes investment after onboarding?',
          ],
        ),
      ],
    ),
    'q_holiday_institutional': OwnifyQuestionnaireData(
      id: 'q_holiday_institutional',
      title: 'Holiday Homes — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into Holiday Homes.',
      categories: [
        OwnifyQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 106,
          questions: [
            'Rate your institution\'s expertise (1–5) in Holiday Homes, with brief justification.',
            'Describe your institution\'s process for assessing the hospitality operator\'s management capability and licensing before referring a Holiday Homes opportunity.',
            'What legal and compliance framework does your institution maintain specific to hospitality and short-stay rental regulations for managed leisure assets?',
            'What is your institution\'s existing client base or network relevant to Holiday Homes?',
            'What is your institution\'s estimated monthly capacity to refer qualified Holiday Homes clients?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Systems & Operations',
          startNum: 111,
          questions: [
            'What technology or systems does your institution use to manage Holiday Homes referrals and records?',
            'How would your institution integrate Holiday Homes referrals into its existing workflows?',
            'What training or resources would your institution need to represent Holiday Homes effectively?',
            'How does your institution ensure compliance with Ownify\'s Code of Conduct when referring Holiday Homes clients?',
            'What risks specific to Holiday Homes does your institution watch for, and how are they mitigated?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Diligence & Accountability',
          startNum: 116,
          questions: [
            'What due-diligence checklist does your institution apply before approving a Holiday Homes opportunity for referral?',
            'How does your institution track referral outcomes and client satisfaction for Holiday Homes?',
            'What escalation process does your institution follow for a Holiday Homes-related client complaint?',
            'How does your institution vet the developer or operator behind a Holiday Homes opportunity?',
            'What internal sign-off or approval is required before your institution refers a Holiday Homes client?',
          ],
        ),
      ],
    ),
    'q_commercial_individual': OwnifyQuestionnaireData(
      id: 'q_commercial_individual',
      title: 'Commercial — Individual Applicant Verification',
      subtitle: 'Answer these 15 questions to show you can responsibly refer members into Commercial.',
      categories: [
        OwnifyQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 121,
          questions: [
            'Explain your understanding of fractional ownership as it applies to Commercial, and how members participate through it.',
            'How would you explain the pre-leased rental yield credited monthly to the UB Wallet to a first-time client?',
            'What factors most affect value or returns for Commercial in India?',
            'What would you check regarding zoning rules and tenancy/lease compliance for commercial property before referring a client?',
            'What questions would you ask a client to see if Commercial suits their goals?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Risk, Trust & Positioning',
          startNum: 126,
          questions: [
            'What concerns might a client raise about Commercial, and how would you address them?',
            'How would you differentiate Commercial from investing in a listed REIT?',
            'What is your existing network or client base relevant to Commercial?',
            'Would you ever promise assured returns to a client interested in Commercial? Why or why not?',
            'What is your plan to start referring clients into Commercial within your first 30 days as a partner?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Process & Ongoing Support',
          startNum: 131,
          questions: [
            'What is the minimum entry amount, and how would you explain the lock-in period for Commercial to a budget-conscious client?',
            'What documents or disclosures would you make sure a client has reviewed before they commit to Commercial?',
            'How would you support a client who wants to exit or transfer their Commercial fraction?',
            'What would make you decline to refer a particular client into Commercial?',
            'How would you keep a client updated on their Commercial investment after onboarding?',
          ],
        ),
      ],
    ),
    'q_commercial_institutional': OwnifyQuestionnaireData(
      id: 'q_commercial_institutional',
      title: 'Commercial — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into Commercial.',
      categories: [
        OwnifyQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 136,
          questions: [
            'Rate your institution\'s expertise (1–5) in Commercial, with brief justification.',
            'Describe your institution\'s process for verifying tenant credentials, lease terms and zoning compliance before referring a Commercial opportunity.',
            'What legal and compliance framework does your institution maintain specific to zoning rules and tenancy/lease compliance for commercial property?',
            'What is your institution\'s existing client base or network relevant to Commercial?',
            'What is your institution\'s estimated monthly capacity to refer qualified Commercial clients?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Systems & Operations',
          startNum: 141,
          questions: [
            'What technology or systems does your institution use to manage Commercial referrals and records?',
            'How would your institution integrate Commercial referrals into its existing workflows?',
            'What training or resources would your institution need to represent Commercial effectively?',
            'How does your institution ensure compliance with Ownify\'s Code of Conduct when referring Commercial clients?',
            'What risks specific to Commercial does your institution watch for, and how are they mitigated?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Diligence & Accountability',
          startNum: 146,
          questions: [
            'What due-diligence checklist does your institution apply before approving a Commercial opportunity for referral?',
            'How does your institution track referral outcomes and client satisfaction for Commercial?',
            'What escalation process does your institution follow for a Commercial-related client complaint?',
            'How does your institution vet the developer or operator behind a Commercial opportunity?',
            'What internal sign-off or approval is required before your institution refers a Commercial client?',
          ],
        ),
      ],
    ),
    'q_senior_individual': OwnifyQuestionnaireData(
      id: 'q_senior_individual',
      title: 'Senior Citizen Stay — Individual Applicant Verification',
      subtitle: 'Answer these 15 questions to show you can responsibly refer members into Senior Citizen Stay.',
      categories: [
        OwnifyQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 151,
          questions: [
            'Explain your understanding of fractional ownership as it applies to Senior Citizen Stay, and how members participate through it.',
            'How would you explain the care-linked rental income model to a first-time client?',
            'What factors most affect value or returns for Senior Citizen Stay in India?',
            'What would you check regarding care-facility licensing and labour compliance for senior-living operators before referring a client?',
            'What questions would you ask a client to see if Senior Citizen Stay suits their goals?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Risk, Trust & Positioning',
          startNum: 156,
          questions: [
            'What concerns might a client raise about Senior Citizen Stay, and how would you address them?',
            'How would you differentiate Senior Citizen Stay from a traditional old-age home or nursing facility?',
            'What is your existing network or client base relevant to Senior Citizen Stay?',
            'Would you ever promise assured returns to a client interested in Senior Citizen Stay? Why or why not?',
            'What is your plan to start referring clients into Senior Citizen Stay within your first 30 days as a partner?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Process & Ongoing Support',
          startNum: 161,
          questions: [
            'What is the minimum entry amount, and how would you explain the lock-in period for Senior Citizen Stay to a budget-conscious client?',
            'What documents or disclosures would you make sure a client has reviewed before they commit to Senior Citizen Stay?',
            'How would you support a client who wants to exit or transfer their Senior Citizen Stay fraction?',
            'What would make you decline to refer a particular client into Senior Citizen Stay?',
            'How would you keep a client updated on their Senior Citizen Stay investment after onboarding?',
          ],
        ),
      ],
    ),
    'q_senior_institutional': OwnifyQuestionnaireData(
      id: 'q_senior_institutional',
      title: 'Senior Citizen Stay — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into Senior Citizen Stay.',
      categories: [
        OwnifyQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 166,
          questions: [
            'Rate your institution\'s expertise (1–5) in Senior Citizen Stay, with brief justification.',
            'Describe your institution\'s process for assessing the care-facility partner\'s licensing, staffing and service standards before referring a Senior Citizen Stay opportunity.',
            'What legal and compliance framework does your institution maintain specific to care-facility licensing and labour compliance for senior-living operators?',
            'What is your institution\'s existing client base or network relevant to Senior Citizen Stay?',
            'What is your institution\'s estimated monthly capacity to refer qualified Senior Citizen Stay clients?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Systems & Operations',
          startNum: 171,
          questions: [
            'What technology or systems does your institution use to manage Senior Citizen Stay referrals and records?',
            'How would your institution integrate Senior Citizen Stay referrals into its existing workflows?',
            'What training or resources would your institution need to represent Senior Citizen Stay effectively?',
            'How does your institution ensure compliance with Ownify\'s Code of Conduct when referring Senior Citizen Stay clients?',
            'What risks specific to Senior Citizen Stay does your institution watch for, and how are they mitigated?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Diligence & Accountability',
          startNum: 176,
          questions: [
            'What due-diligence checklist does your institution apply before approving a Senior Citizen Stay opportunity for referral?',
            'How does your institution track referral outcomes and client satisfaction for Senior Citizen Stay?',
            'What escalation process does your institution follow for a Senior Citizen Stay-related client complaint?',
            'How does your institution vet the developer or operator behind a Senior Citizen Stay opportunity?',
            'What internal sign-off or approval is required before your institution refers a Senior Citizen Stay client?',
          ],
        ),
      ],
    ),
    'q_warehouse_individual': OwnifyQuestionnaireData(
      id: 'q_warehouse_individual',
      title: 'Warehouse / Logistics — Individual Applicant Verification',
      subtitle: 'Answer these 15 questions to show you can responsibly refer members into Warehouse / Logistics.',
      categories: [
        OwnifyQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 181,
          questions: [
            'Explain your understanding of fractional ownership as it applies to Warehouse / Logistics, and how members participate through it.',
            'How would you explain the long institutional-lease, rental-yield-led structure to a first-time client?',
            'What factors most affect value or returns for Warehouse / Logistics in India?',
            'What would you check regarding environmental clearances and long-lease compliance for logistics parks before referring a client?',
            'What questions would you ask a client to see if Warehouse / Logistics suits their goals?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Risk, Trust & Positioning',
          startNum: 186,
          questions: [
            'What concerns might a client raise about Warehouse / Logistics, and how would you address them?',
            'How would you differentiate Warehouse / Logistics from direct industrial real-estate leasing?',
            'What is your existing network or client base relevant to Warehouse / Logistics?',
            'Would you ever promise assured returns to a client interested in Warehouse / Logistics? Why or why not?',
            'What is your plan to start referring clients into Warehouse / Logistics within your first 30 days as a partner?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Process & Ongoing Support',
          startNum: 191,
          questions: [
            'What is the minimum entry amount, and how would you explain the lock-in period for Warehouse / Logistics to a budget-conscious client?',
            'What documents or disclosures would you make sure a client has reviewed before they commit to Warehouse / Logistics?',
            'How would you support a client who wants to exit or transfer their Warehouse / Logistics fraction?',
            'What would make you decline to refer a particular client into Warehouse / Logistics?',
            'How would you keep a client updated on their Warehouse / Logistics investment after onboarding?',
          ],
        ),
      ],
    ),
    'q_warehouse_institutional': OwnifyQuestionnaireData(
      id: 'q_warehouse_institutional',
      title: 'Warehouse / Logistics — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into Warehouse / Logistics.',
      categories: [
        OwnifyQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 196,
          questions: [
            'Rate your institution\'s expertise (1–5) in Warehouse / Logistics, with brief justification.',
            'Describe your institution\'s process for reviewing lease terms, tenant credentials and environmental clearances before referring a Warehouse / Logistics opportunity.',
            'What legal and compliance framework does your institution maintain specific to environmental clearances and long-lease compliance for logistics parks?',
            'What is your institution\'s existing client base or network relevant to Warehouse / Logistics?',
            'What is your institution\'s estimated monthly capacity to refer qualified Warehouse / Logistics clients?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Systems & Operations',
          startNum: 201,
          questions: [
            'What technology or systems does your institution use to manage Warehouse / Logistics referrals and records?',
            'How would your institution integrate Warehouse / Logistics referrals into its existing workflows?',
            'What training or resources would your institution need to represent Warehouse / Logistics effectively?',
            'How does your institution ensure compliance with Ownify\'s Code of Conduct when referring Warehouse / Logistics clients?',
            'What risks specific to Warehouse / Logistics does your institution watch for, and how are they mitigated?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Diligence & Accountability',
          startNum: 206,
          questions: [
            'What due-diligence checklist does your institution apply before approving a Warehouse / Logistics opportunity for referral?',
            'How does your institution track referral outcomes and client satisfaction for Warehouse / Logistics?',
            'What escalation process does your institution follow for a Warehouse / Logistics-related client complaint?',
            'How does your institution vet the developer or operator behind a Warehouse / Logistics opportunity?',
            'What internal sign-off or approval is required before your institution refers a Warehouse / Logistics client?',
          ],
        ),
      ],
    ),
    'q_prime_individual': OwnifyQuestionnaireData(
      id: 'q_prime_individual',
      title: 'Prime Land — Individual Applicant Verification',
      subtitle: 'Answer these 15 questions to show you can responsibly refer members into Prime Land.',
      categories: [
        OwnifyQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 211,
          questions: [
            'Explain your understanding of fractional ownership as it applies to Prime Land, and how members participate through it.',
            'How would you explain the appreciation-focused positioning in prime growth corridors to a first-time client?',
            'What factors most affect value or returns for Prime Land in India?',
            'What would you check regarding title verification and infrastructure/master-plan checks in growth corridors before referring a client?',
            'What questions would you ask a client to see if Prime Land suits their goals?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Risk, Trust & Positioning',
          startNum: 216,
          questions: [
            'What concerns might a client raise about Prime Land, and how would you address them?',
            'How would you differentiate Prime Land from a direct outright land purchase?',
            'What is your existing network or client base relevant to Prime Land?',
            'Would you ever promise assured returns to a client interested in Prime Land? Why or why not?',
            'What is your plan to start referring clients into Prime Land within your first 30 days as a partner?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Process & Ongoing Support',
          startNum: 221,
          questions: [
            'What is the minimum entry amount, and how would you explain the lock-in period for Prime Land to a budget-conscious client?',
            'What documents or disclosures would you make sure a client has reviewed before they commit to Prime Land?',
            'How would you support a client who wants to exit or transfer their Prime Land fraction?',
            'What would make you decline to refer a particular client into Prime Land?',
            'How would you keep a client updated on their Prime Land investment after onboarding?',
          ],
        ),
      ],
    ),
    'q_prime_institutional': OwnifyQuestionnaireData(
      id: 'q_prime_institutional',
      title: 'Prime Land — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into Prime Land.',
      categories: [
        OwnifyQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 226,
          questions: [
            'Rate your institution\'s expertise (1–5) in Prime Land, with brief justification.',
            'Describe your institution\'s process for verifying title history and assessing infrastructure and master-plan growth potential before referring a Prime Land opportunity.',
            'What legal and compliance framework does your institution maintain specific to title verification and infrastructure/master-plan checks in growth corridors?',
            'What is your institution\'s existing client base or network relevant to Prime Land?',
            'What is your institution\'s estimated monthly capacity to refer qualified Prime Land clients?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Systems & Operations',
          startNum: 231,
          questions: [
            'What technology or systems does your institution use to manage Prime Land referrals and records?',
            'How would your institution integrate Prime Land referrals into its existing workflows?',
            'What training or resources would your institution need to represent Prime Land effectively?',
            'How does your institution ensure compliance with Ownify\'s Code of Conduct when referring Prime Land clients?',
            'What risks specific to Prime Land does your institution watch for, and how are they mitigated?',
          ],
        ),
        OwnifyQuestionCategory(
          name: 'Diligence & Accountability',
          startNum: 236,
          questions: [
            'What due-diligence checklist does your institution apply before approving a Prime Land opportunity for referral?',
            'How does your institution track referral outcomes and client satisfaction for Prime Land?',
            'What escalation process does your institution follow for a Prime Land-related client complaint?',
            'How does your institution vet the developer or operator behind a Prime Land opportunity?',
            'What internal sign-off or approval is required before your institution refers a Prime Land client?',
          ],
        ),
      ],
    ),
  };
}

class OwnifyServiceCard {
  final String id;
  final String icon;
  final String name;
  final String desc;

  const OwnifyServiceCard({
    required this.id,
    required this.icon,
    required this.name,
    required this.desc,
  });
}

class OwnifyServiceCards {
  static const List<OwnifyServiceCard> all = [
    OwnifyServiceCard(
      id: 'farmland',
      icon: '🌾',
      name: 'Farmland',
      desc: 'Refer members into appreciation-led farm-land fractions — entry point for ₹10/day savers, 5–10 year tenure.',
    ),
    OwnifyServiceCard(
      id: 'plots',
      icon: '📐',
      name: 'Plots',
      desc: 'Refer members into plot-development fractions (1 fraction = 1 sq ft), with a consolidation path to 100% ownership.',
    ),
    OwnifyServiceCard(
      id: 'residence',
      icon: '🏠',
      name: 'Residence',
      desc: 'Refer members into residential site & housing fractions, with a path to construction via Build AI Homes.',
    ),
    OwnifyServiceCard(
      id: 'holiday',
      icon: '🏖️',
      name: 'Holiday Homes',
      desc: 'Refer members into managed leisure-asset fractions — rental income plus appreciation, with optional usage days.',
    ),
    OwnifyServiceCard(
      id: 'commercial',
      icon: '🏢',
      name: 'Commercial',
      desc: 'Refer members into pre-leased office/retail fractions — steady rental yield, credited monthly to the UB Wallet.',
    ),
    OwnifyServiceCard(
      id: 'senior',
      icon: '🧓',
      name: 'Senior Citizen Stay',
      desc: 'Refer members into fractional ownership of senior-living residences, with care-linked rental income.',
    ),
    OwnifyServiceCard(
      id: 'warehouse',
      icon: '🚚',
      name: 'Warehouse / Logistics',
      desc: 'Refer members into logistics & warehousing fractions — long institutional leases, rental-yield-led.',
    ),
    OwnifyServiceCard(
      id: 'prime',
      icon: '💎',
      name: 'Prime Land',
      desc: 'Refer members into high-value, appreciation-focused land parcels in prime growth corridors.',
    ),
  ];
}

class OwnifyDepositCalculation {
  static const int depositPerCategory = 500000;

  static Map<String, dynamic> compute(List<String> services) {
    final Map<String, String> names = {
      for (var c in OwnifyServiceCards.all) c.id: c.name,
    };
    final rows = services.map((id) => {
      'label': names[id] ?? id,
      'amount': depositPerCategory,
    }).toList();
    final total = services.length * depositPerCategory;
    return {'rows': rows, 'total': total};
  }
}

class OwnifyDemoApplicantData {
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
    'businessType': 'individual',
    'hasExperience': true,
    'whereWorked': 'Rao Investment Services',
    'role': 'Client Relationship Associate',
    'howLong': '2019–2026',
    'whatYouDid': 'Helped clients set up SIPs, explained UPI Autopay mandates and coordinated KYC paperwork.',
    'yearsExperience': '7',
    'highestQualification': 'B.Com',
    'toolsKnown': 'UPI Autopay, mutual fund portals, DigiLocker',
    'familiarityChecklist': [
      'I know my way around KYC / AML basics',
      'I\'m familiar with SIP / mutual-fund style savings plans',
    ],
    'workAddress': '24, 5th Cross, Jayanagar, Bengaluru',
    'ownership': 'Owned',
    'workLandmark': 'Jayanagar 4th Block',
    'wardAreaServe': 'Jayanagar Ward',
    'villagesCovered': 'Jayanagar, Basavanagudi, JP Nagar',
    'workFacilities': [
      'Private area for clients to discuss their investments',
      'Secure, lockable place to store paperwork',
      'CCTV or other document security',
      'Internet access to log leads and savers',
      'Computer, scanner and printer on site',
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
    'services': ['farmland', 'plots'],
    'wardArea': 'Jayanagar Ward',
    'newSaversPerMonth': '12',
    'hireSupportStaff': 'No',
    'bestTimeTraining': 'Weekends',
    'smartphone': 'Android',
    'comfortApps': 'Very Comfortable',
    'usedAppsForInvestments': 'Yes, Regularly',
    'comfortPayments': 'Very Comfortable',
    'langComm': [
      'I\'m comfortable using the Partner app already',
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

class StepMeta {
  final String title;
  final String subtitle;
  const StepMeta({required this.title, required this.subtitle});
}

class OwnifyStepMeta {
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
      subtitle: 'Your business, real estate & finance experience',
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
      subtitle: 'Choose property categories to apply for',
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

