// Build AI Homes Channel Partner Models and Data Schemas

class BuildAiHomesQuestionCategory {
  final String name;
  final int startNum;
  final List<String> questions;

  const BuildAiHomesQuestionCategory({
    required this.name,
    required this.startNum,
    required this.questions,
  });
}

class BuildAiHomesQuestionnaireData {
  final String id;
  final String title;
  final String subtitle;
  final List<BuildAiHomesQuestionCategory> categories;

  const BuildAiHomesQuestionnaireData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categories,
  });
}

class BuildAiHomesServiceCard {
  final String id;
  final String icon;
  final String name;
  final String desc;

  const BuildAiHomesServiceCard({
    required this.id,
    required this.icon,
    required this.name,
    required this.desc,
  });
}

class BuildAiHomesServiceCards {
  static const List<BuildAiHomesServiceCard> all = [
    BuildAiHomesServiceCard(
      id: 'lands',
      icon: '🗺️',
      name: 'Lands / JD-JV',
      desc: 'Refer landowners and members into structured Joint Development / Joint Venture partnerships — land contributed, value shared through the built asset.',
    ),
    BuildAiHomesServiceCard(
      id: 'turnkey',
      icon: '🏗️',
      name: 'Turnkey Construction',
      desc: 'Refer members into fully-managed residential, commercial and layout construction — delivered through the 7-stage, QA-verified build process.',
    ),
    BuildAiHomesServiceCard(
      id: 'interiors',
      icon: '🛋️',
      name: 'Interiors',
      desc: 'Refer members into complete interior fit-out projects — built to the same documented specification and QA standard as construction.',
    ),
    BuildAiHomesServiceCard(
      id: 'exterior',
      icon: '🧱',
      name: 'Exterior',
      desc: 'Refer members into exterior finishing, facade and elevation work — documented specifications with milestone photo-proof QA.',
    ),
    BuildAiHomesServiceCard(
      id: 'landscape',
      icon: '🌳',
      name: 'Landscape',
      desc: 'Refer members into landscape design and execution — site-adaptive planning informed by the Panchabhūta framework.',
    ),
  ];
}

class BuildAiHomesDepositCalculation {
  static const int depositPerModule = 500000;

  static Map<String, dynamic> compute(List<String> services) {
    final names = {
      for (var c in BuildAiHomesServiceCards.all) c.id: c.name,
    };
    final rows = services.map((id) => {
      'label': names[id] ?? id,
      'amount': depositPerModule,
    }).toList();
    final total = services.length * depositPerModule;
    return {
      'rows': rows,
      'total': total,
    };
  }

  static String formatINR(num n) {
    final str = n.toInt().toString();
    if (str.length <= 3) return '₹$str';
    final last3 = str.substring(str.length - 3);
    final rest = str.substring(0, str.length - 3);
    final formattedRest = rest.replaceAllMapped(
      RegExp(r'\B(?=(\d{2})+(?!\d))'),
      (match) => ',',
    );
    return '₹$formattedRest,$last3';
  }
}

class BuildAiHomesQuestionnaires {
  static const Map<String, BuildAiHomesQuestionnaireData> all = {
    'q_lands_individual': BuildAiHomesQuestionnaireData(
      id: 'q_lands_individual',
      title: 'Lands / JD-JV — Individual Applicant Verification',
      subtitle: 'Answer these 20 questions to show you can responsibly refer members into Lands / JD-JV.',
      categories: [
        BuildAiHomesQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 1,
          questions: [
            'Explain your understanding of how Build AI Homes delivers Lands / JD-JV, and how a client engages with it from first enquiry to handover.',
            'How would you explain the Joint Development / Joint Venture (JD/JV) model — land contributed against a share of built value, with title gates cleared at each stage to a first-time client?',
            'What factors most affect the cost, quality or value outcome of a Lands / JD-JV project in India?',
            'What would you check regarding land title chain, encumbrance status and BhoomiVault verification before referring a client?',
            'What questions would you ask a client to see if Lands / JD-JV suits their needs and budget?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 6,
          questions: [
            'What concerns might a client raise about Lands / JD-JV, and how would you address them?',
            'How would you differentiate Build AI Homes\' Lands / JD-JV from an outright land sale, or an informal JD/JV arrangement without CloudPatra-backed agreements?',
            'What is your existing network or client base relevant to Lands / JD-JV?',
            'Would you ever promise a fixed timeline or guaranteed outcome to a client interested in Lands / JD-JV without it being confirmed through the stage-gated process? Why or why not?',
            'What is your plan to start referring clients into Lands / JD-JV within your first 30 days as a partner?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Process & Documentation',
          startNum: 11,
          questions: [
            'What is the typical project size or budget range for Lands / JD-JV, and how would you set expectations with a smaller-budget client?',
            'What documents or disclosures would you make sure a client has reviewed before committing to Lands / JD-JV?',
            'How would you explain the milestone-based, photo-proof QA process to a client who wants to track their Lands / JD-JV project\'s progress?',
            'What role does site intelligence (survey, soil, drainage) play before a Lands / JD-JV project begins, and how would you explain this to a client?',
            'How would you support a client who wants to raise a change order after design sign-off on a Lands / JD-JV project?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 16,
          questions: [
            'What would make you decline to refer a particular client into Lands / JD-JV?',
            'How would you explain the geotagged, timestamped photo evidence used to verify Lands / JD-JV work, and why it matters to the client?',
            'How would you keep a client updated on their Lands / JD-JV project after onboarding, given construction sites can have poor connectivity?',
            'What would you tell a client about the defect-liability and warranty coverage they receive at Lands / JD-JV handover?',
            'How would you handle a client\'s complaint about Lands / JD-JV quality or delay, and who would you escalate it to?',
          ],
        ),
      ],
    ),
    'q_lands_institutional': BuildAiHomesQuestionnaireData(
      id: 'q_lands_institutional',
      title: 'Lands / JD-JV — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into Lands / JD-JV.',
      categories: [
        BuildAiHomesQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 21,
          questions: [
            'Rate your institution\'s expertise (1–5) in Lands / JD-JV, with brief justification.',
            'Describe your institution\'s process for verifying land title, encumbrance and ownership documentation through BhoomiVault before referring a JD/JV opportunity.',
            'What legal and compliance framework does your institution maintain specific to land title verification, RERA applicability and JD/JV agreement documentation?',
            'What is your institution\'s existing client base or network relevant to Lands / JD-JV?',
            'What is your institution\'s estimated monthly capacity to refer qualified Lands / JD-JV clients?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Systems & Operations',
          startNum: 26,
          questions: [
            'What technology or systems does your institution use to manage Lands / JD-JV referrals and records?',
            'How would your institution integrate Lands / JD-JV referrals into its existing workflows?',
            'What training or resources would your institution need to represent Lands / JD-JV effectively?',
            'How does your institution ensure compliance with Build AI Homes\' Code of Conduct when referring Lands / JD-JV clients?',
            'What risks specific to Lands / JD-JV does your institution watch for, and how are they mitigated?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 31,
          questions: [
            'What internal budget or project-size threshold does your institution apply when evaluating a Lands / JD-JV referral?',
            'How does your institution verify a client\'s documentation is complete before a Lands / JD-JV project can be handed to Build AI Homes\' site intelligence team?',
            'What role does your institution play in reviewing milestone QA evidence and photo proof for Lands / JD-JV projects it has referred?',
            'How does your institution handle a client-requested change order after design sign-off on a Lands / JD-JV project?',
            'What process does your institution follow if a referred Lands / JD-JV client wants to pause or exit a project mid-stage?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 36,
          questions: [
            'How does your institution verify supplier-direct, One Core-routed payments are being made correctly on Lands / JD-JV projects?',
            'What reporting does your institution require from Build AI Homes on the status of referred Lands / JD-JV projects?',
            'How does your institution handle defect-liability or warranty claims raised by a referred Lands / JD-JV client after handover?',
            'What service-level expectations does your institution set for Lands / JD-JV referrals — for response time, site visits or reporting?',
            'How does your institution measure the success or satisfaction of clients referred into Lands / JD-JV?',
          ],
        ),
      ],
    ),
    'q_turnkey_individual': BuildAiHomesQuestionnaireData(
      id: 'q_turnkey_individual',
      title: 'Turnkey Construction — Individual Applicant Verification',
      subtitle: 'Answer these 20 questions to show you can responsibly refer members into Turnkey Construction.',
      categories: [
        BuildAiHomesQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 41,
          questions: [
            'Explain your understanding of how Build AI Homes delivers Turnkey Construction, and how a client engages with it from first enquiry to handover.',
            'How would you explain the 7-stage milestone and QA engine — from site intelligence and design approvals through to handover — and the eco construction types (Type 01 Eco-Based, Type 02 Semi-Eco, Type 03 Advanced) to a first-time client?',
            'What factors most affect the cost, quality or timeline outcome of a Turnkey Construction project in India?',
            'What would you check regarding RERA applicability, approved drawings and stage-gated QA sign-off before referring a client?',
            'What questions would you ask a client to see if Turnkey Construction suits their needs and budget?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 46,
          questions: [
            'What concerns might a client raise about Turnkey Construction, and how would you address them?',
            'How would you differentiate Build AI Homes\' Turnkey Construction from hiring an independent contractor directly, without stage-gated QA, photo-proof evidence or CloudPatra-backed documentation?',
            'What is your existing network or client base relevant to Turnkey Construction?',
            'Would you ever promise a fixed timeline or guaranteed outcome to a client interested in Turnkey Construction without it being confirmed through the stage-gated process? Why or why not?',
            'What is your plan to start referring clients into Turnkey Construction within your first 30 days as a partner?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Process & Documentation',
          startNum: 51,
          questions: [
            'What is the typical project size or budget range for Turnkey Construction, and how would you set expectations with a smaller-budget client?',
            'What documents or disclosures would you make sure a client has reviewed before committing to Turnkey Construction?',
            'How would you explain the milestone-based, photo-proof QA process to a client who wants to track their Turnkey Construction project\'s progress?',
            'What role does site intelligence (survey, soil, drainage) play before a Turnkey Construction project begins, and how would you explain this to a client?',
            'How would you support a client who wants to raise a change order after design sign-off on a Turnkey Construction project?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 56,
          questions: [
            'What would make you decline to refer a particular client into Turnkey Construction?',
            'How would you explain the geotagged, timestamped photo evidence used to verify Turnkey Construction work, and why it matters to the client?',
            'How would you keep a client updated on their Turnkey Construction project after onboarding, given construction sites can have poor connectivity?',
            'What would you tell a client about the defect-liability and warranty coverage they receive at Turnkey Construction handover?',
            'How would you handle a client\'s complaint about Turnkey Construction quality or delay, and who would you escalate it to?',
          ],
        ),
      ],
    ),
    'q_turnkey_institutional': BuildAiHomesQuestionnaireData(
      id: 'q_turnkey_institutional',
      title: 'Turnkey Construction — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into Turnkey Construction.',
      categories: [
        BuildAiHomesQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 61,
          questions: [
            'Rate your institution\'s expertise (1–5) in Turnkey Construction, with brief justification.',
            'Describe your institution\'s process for reviewing project design approvals, RERA status and the 7-stage QA plan before referring a Turnkey Construction opportunity.',
            'What legal and compliance framework does your institution maintain specific to RERA controls, statutory approvals and stage-gated QA documentation for construction projects?',
            'What is your institution\'s existing client base or network relevant to Turnkey Construction?',
            'What is your institution\'s estimated monthly capacity to refer qualified Turnkey Construction clients?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Systems & Operations',
          startNum: 66,
          questions: [
            'What technology or systems does your institution use to manage Turnkey Construction referrals and records?',
            'How would your institution integrate Turnkey Construction referrals into its existing workflows?',
            'What training or resources would your institution need to represent Turnkey Construction effectively?',
            'How does your institution ensure compliance with Build AI Homes\' Code of Conduct when referring Turnkey Construction clients?',
            'What risks specific to Turnkey Construction does your institution watch for, and how are they mitigated?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 71,
          questions: [
            'What internal budget or project-size threshold does your institution apply when evaluating a Turnkey Construction referral?',
            'How does your institution verify a client\'s documentation is complete before a Turnkey Construction project can be handed to Build AI Homes\' site intelligence team?',
            'What role does your institution play in reviewing milestone QA evidence and photo proof for Turnkey Construction projects it has referred?',
            'How does your institution handle a client-requested change order after design sign-off on a Turnkey Construction project?',
            'What process does your institution follow if a referred Turnkey Construction client wants to pause or exit a project mid-stage?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 76,
          questions: [
            'How does your institution verify supplier-direct, One Core-routed payments are being made correctly on Turnkey Construction projects?',
            'What reporting does your institution require from Build AI Homes on the status of referred Turnkey Construction projects?',
            'How does your institution handle defect-liability or warranty claims raised by a referred Turnkey Construction client after handover?',
            'What service-level expectations does your institution set for Turnkey Construction referrals — for response time, site visits or reporting?',
            'How does your institution measure the success or satisfaction of clients referred into Turnkey Construction?',
          ],
        ),
      ],
    ),
    'q_interiors_individual': BuildAiHomesQuestionnaireData(
      id: 'q_interiors_individual',
      title: 'Interiors — Individual Applicant Verification',
      subtitle: 'Answer these 20 questions to show you can responsibly refer members into Interiors.',
      categories: [
        BuildAiHomesQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 81,
          questions: [
            'Explain your understanding of how Build AI Homes delivers Interiors, and how a client engages with it from first enquiry to handover.',
            'How would you explain how interior fit-out projects follow the same disciplined stage/QA standard as construction, with specification and photo-proof evidence to a first-time client?',
            'What factors most affect the cost or quality outcome of an Interiors project in India?',
            'What would you check regarding the specification registry and QA checklist for materials and finishes before referring a client?',
            'What questions would you ask a client to see if Interiors suits their needs and budget?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 86,
          questions: [
            'What concerns might a client raise about Interiors, and how would you address them?',
            'How would you differentiate Build AI Homes\' Interiors from hiring an independent interior designer or contractor without documented specifications or QA evidence?',
            'What is your existing network or client base relevant to Interiors?',
            'Would you ever promise a fixed timeline or guaranteed outcome to a client interested in Interiors without it being confirmed through the stage-gated process? Why or why not?',
            'What is your plan to start referring clients into Interiors within your first 30 days as a partner?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Process & Documentation',
          startNum: 91,
          questions: [
            'What is the typical project size or budget range for Interiors, and how would you set expectations with a smaller-budget client?',
            'What documents or disclosures would you make sure a client has reviewed before committing to Interiors?',
            'How would you explain the milestone-based, photo-proof QA process to a client who wants to track their Interiors project\'s progress?',
            'What role does site intelligence (survey, soil, drainage) play before a Interiors project begins, and how would you explain this to a client?',
            'How would you support a client who wants to raise a change order after design sign-off on a Interiors project?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 96,
          questions: [
            'What would make you decline to refer a particular client into Interiors?',
            'How would you explain the geotagged, timestamped photo evidence used to verify Interiors work, and why it matters to the client?',
            'How would you keep a client updated on their Interiors project after onboarding, given construction sites can have poor connectivity?',
            'What would you tell a client about the defect-liability and warranty coverage they receive at Interiors handover?',
            'How would you handle a client\'s complaint about Interiors quality or delay, and who would you escalate it to?',
          ],
        ),
      ],
    ),
    'q_interiors_institutional': BuildAiHomesQuestionnaireData(
      id: 'q_interiors_institutional',
      title: 'Interiors — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into Interiors.',
      categories: [
        BuildAiHomesQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 101,
          questions: [
            'Rate your institution\'s expertise (1–5) in Interiors, with brief justification.',
            'Describe your institution\'s process for reviewing the specification registry and QA checklist before referring an Interiors opportunity.',
            'What legal and compliance framework does your institution maintain specific to material and finish specification standards and QA evidence for interior fit-out projects?',
            'What is your institution\'s existing client base or network relevant to Interiors?',
            'What is your institution\'s estimated monthly capacity to refer qualified Interiors clients?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Systems & Operations',
          startNum: 106,
          questions: [
            'What technology or systems does your institution use to manage Interiors referrals and records?',
            'How would your institution integrate Interiors referrals into its existing workflows?',
            'What training or resources would your institution need to represent Interiors effectively?',
            'How does your institution ensure compliance with Build AI Homes\' Code of Conduct when referring Interiors clients?',
            'What risks specific to Interiors does your institution watch for, and how are they mitigated?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 111,
          questions: [
            'What internal budget or project-size threshold does your institution apply when evaluating a Interiors referral?',
            'How does your institution verify a client\'s documentation is complete before a Interiors project can be handed to Build AI Homes\' site intelligence team?',
            'What role does your institution play in reviewing milestone QA evidence and photo proof for Interiors projects it has referred?',
            'How does your institution handle a client-requested change order after design sign-off on a Interiors project?',
            'What process does your institution follow if a referred Interiors client wants to pause or exit a project mid-stage?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 116,
          questions: [
            'How does your institution verify supplier-direct, One Core-routed payments are being made correctly on Interiors projects?',
            'What reporting does your institution require from Build AI Homes on the status of referred Interiors projects?',
            'How does your institution handle defect-liability or warranty claims raised by a referred Interiors client after handover?',
            'What service-level expectations does your institution set for Interiors referrals — for response time, site visits or reporting?',
            'How does your institution measure the success or satisfaction of clients referred into Interiors?',
          ],
        ),
      ],
    ),
    'q_exterior_individual': BuildAiHomesQuestionnaireData(
      id: 'q_exterior_individual',
      title: 'Exterior — Individual Applicant Verification',
      subtitle: 'Answer these 20 questions to show you can responsibly refer members into Exterior.',
      categories: [
        BuildAiHomesQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 121,
          questions: [
            'Explain your understanding of how Build AI Homes delivers Exterior, and how a client engages with it from first enquiry to handover.',
            'How would you explain how exterior finishing, facade and elevation work is built to documented specification with milestone photo-proof QA to a first-time client?',
            'What factors most affect the cost or quality outcome of an Exterior project in India?',
            'What would you check regarding the specification registry for exterior materials, waterproofing and finishes before referring a client?',
            'What questions would you ask a client to see if Exterior suits their needs and budget?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 126,
          questions: [
            'What concerns might a client raise about Exterior, and how would you address them?',
            'How would you differentiate Build AI Homes\' Exterior from hiring an independent exterior contractor without documented specifications or verifiable QA evidence?',
            'What is your existing network or client base relevant to Exterior?',
            'Would you ever promise a fixed timeline or guaranteed outcome to a client interested in Exterior without it being confirmed through the stage-gated process? Why or why not?',
            'What is your plan to start referring clients into Exterior within your first 30 days as a partner?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Process & Documentation',
          startNum: 131,
          questions: [
            'What is the typical project size or budget range for Exterior, and how would you set expectations with a smaller-budget client?',
            'What documents or disclosures would you make sure a client has reviewed before committing to Exterior?',
            'How would you explain the milestone-based, photo-proof QA process to a client who wants to track their Exterior project\'s progress?',
            'What role does site intelligence (survey, soil, drainage) play before a Exterior project begins, and how would you explain this to a client?',
            'How would you support a client who wants to raise a change order after design sign-off on a Exterior project?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 136,
          questions: [
            'What would make you decline to refer a particular client into Exterior?',
            'How would you explain the geotagged, timestamped photo evidence used to verify Exterior work, and why it matters to the client?',
            'How would you keep a client updated on their Exterior project after onboarding, given construction sites can have poor connectivity?',
            'What would you tell a client about the defect-liability and warranty coverage they receive at Exterior handover?',
            'How would you handle a client\'s complaint about Exterior quality or delay, and who would you escalate it to?',
          ],
        ),
      ],
    ),
    'q_exterior_institutional': BuildAiHomesQuestionnaireData(
      id: 'q_exterior_institutional',
      title: 'Exterior — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into Exterior.',
      categories: [
        BuildAiHomesQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 141,
          questions: [
            'Rate your institution\'s expertise (1–5) in Exterior, with brief justification.',
            'Describe your institution\'s process for reviewing exterior specification standards and QA evidence before referring an Exterior opportunity.',
            'What legal and compliance framework does your institution maintain specific to waterproofing, material standards and QA evidence for exterior finishing work?',
            'What is your institution\'s existing client base or network relevant to Exterior?',
            'What is your institution\'s estimated monthly capacity to refer qualified Exterior clients?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Systems & Operations',
          startNum: 146,
          questions: [
            'What technology or systems does your institution use to manage Exterior referrals and records?',
            'How would your institution integrate Exterior referrals into its existing workflows?',
            'What training or resources would your institution need to represent Exterior effectively?',
            'How does your institution ensure compliance with Build AI Homes\' Code of Conduct when referring Exterior clients?',
            'What risks specific to Exterior does your institution watch for, and how are they mitigated?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 151,
          questions: [
            'What internal budget or project-size threshold does your institution apply when evaluating a Exterior referral?',
            'How does your institution verify a client\'s documentation is complete before a Exterior project can be handed to Build AI Homes\' site intelligence team?',
            'What role does your institution play in reviewing milestone QA evidence and photo proof for Exterior projects it has referred?',
            'How does your institution handle a client-requested change order after design sign-off on a Exterior project?',
            'What process does your institution follow if a referred Exterior client wants to pause or exit a project mid-stage?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 156,
          questions: [
            'How does your institution verify supplier-direct, One Core-routed payments are being made correctly on Exterior projects?',
            'What reporting does your institution require from Build AI Homes on the status of referred Exterior projects?',
            'How does your institution handle defect-liability or warranty claims raised by a referred Exterior client after handover?',
            'What service-level expectations does your institution set for Exterior referrals — for response time, site visits or reporting?',
            'How does your institution measure the success or satisfaction of clients referred into Exterior?',
          ],
        ),
      ],
    ),
    'q_landscape_individual': BuildAiHomesQuestionnaireData(
      id: 'q_landscape_individual',
      title: 'Landscape — Individual Applicant Verification',
      subtitle: 'Answer these 20 questions to show you can responsibly refer members into Landscape.',
      categories: [
        BuildAiHomesQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 161,
          questions: [
            'Explain your understanding of how Build AI Homes delivers Landscape, and how a client engages with it from first enquiry to handover.',
            'How would you explain how landscape design blends the Panchabhūta framework (earth, water, fire, air, space) with site-adaptive planning to a first-time client?',
            'What factors most affect the cost or quality outcome of a Landscape project in India?',
            'What would you check regarding site soil, drainage and irrigation requirements against the design brief before referring a client?',
            'What questions would you ask a client to see if Landscape suits their needs and budget?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 166,
          questions: [
            'What concerns might a client raise about Landscape, and how would you address them?',
            'How would you differentiate Build AI Homes\' Landscape from hiring an independent landscaper without a documented design brief or stage-gated QA?',
            'What is your existing network or client base relevant to Landscape?',
            'Would you ever promise a fixed timeline or guaranteed outcome to a client interested in Landscape without it being confirmed through the stage-gated process? Why or why not?',
            'What is your plan to start referring clients into Landscape within your first 30 days as a partner?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Process & Documentation',
          startNum: 171,
          questions: [
            'What is the typical project size or budget range for Landscape, and how would you set expectations with a smaller-budget client?',
            'What documents or disclosures would you make sure a client has reviewed before committing to Landscape?',
            'How would you explain the milestone-based, photo-proof QA process to a client who wants to track their Landscape project\'s progress?',
            'What role does site intelligence (survey, soil, drainage) play before a Landscape project begins, and how would you explain this to a client?',
            'How would you support a client who wants to raise a change order after design sign-off on a Landscape project?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 176,
          questions: [
            'What would make you decline to refer a particular client into Landscape?',
            'How would you explain the geotagged, timestamped photo evidence used to verify Landscape work, and why it matters to the client?',
            'How would you keep a client updated on their Landscape project after onboarding, given construction sites can have poor connectivity?',
            'What would you tell a client about the defect-liability and warranty coverage they receive at Landscape handover?',
            'How would you handle a client\'s complaint about Landscape quality or delay, and who would you escalate it to?',
          ],
        ),
      ],
    ),
    'q_landscape_institutional': BuildAiHomesQuestionnaireData(
      id: 'q_landscape_institutional',
      title: 'Landscape — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into Landscape.',
      categories: [
        BuildAiHomesQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 181,
          questions: [
            'Rate your institution\'s expertise (1–5) in Landscape, with brief justification.',
            'Describe your institution\'s process for reviewing the site design brief and adaptive-design parameters before referring a Landscape opportunity.',
            'What legal and compliance framework does your institution maintain specific to site-adaptive design parameters and QA evidence for landscape execution?',
            'What is your institution\'s existing client base or network relevant to Landscape?',
            'What is your institution\'s estimated monthly capacity to refer qualified Landscape clients?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Systems & Operations',
          startNum: 186,
          questions: [
            'What technology or systems does your institution use to manage Landscape referrals and records?',
            'How would your institution integrate Landscape referrals into its existing workflows?',
            'What training or resources would your institution need to represent Landscape effectively?',
            'How does your institution ensure compliance with Build AI Homes\' Code of Conduct when referring Landscape clients?',
            'What risks specific to Landscape does your institution watch for, and how are they mitigated?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 191,
          questions: [
            'What internal budget or project-size threshold does your institution apply when evaluating a Landscape referral?',
            'How does your institution verify a client\'s documentation is complete before a Landscape project can be handed to Build AI Homes\' site intelligence team?',
            'What role does your institution play in reviewing milestone QA evidence and photo proof for Landscape projects it has referred?',
            'How does your institution handle a client-requested change order after design sign-off on a Landscape project?',
            'What process does your institution follow if a referred Landscape client wants to pause or exit a project mid-stage?',
          ],
        ),
        BuildAiHomesQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 196,
          questions: [
            'How does your institution verify supplier-direct, One Core-routed payments are being made correctly on Landscape projects?',
            'What reporting does your institution require from Build AI Homes on the status of referred Landscape projects?',
            'How does your institution handle defect-liability or warranty claims raised by a referred Landscape client after handover?',
            'What service-level expectations does your institution set for Landscape referrals — for response time, site visits or reporting?',
            'How does your institution measure the success or satisfaction of clients referred into Landscape?',
          ],
        ),
      ],
    ),
  };
}
