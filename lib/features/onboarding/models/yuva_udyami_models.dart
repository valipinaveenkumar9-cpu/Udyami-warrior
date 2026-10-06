// Yuva Udyami Channel Partner Models and Data Schemas

class YuvaUdyamiQuestionCategory {
  final String name;
  final int startNum;
  final List<String> questions;

  const YuvaUdyamiQuestionCategory({
    required this.name,
    required this.startNum,
    required this.questions,
  });
}

class YuvaUdyamiQuestionnaireData {
  final String id;
  final String title;
  final String subtitle;
  final List<YuvaUdyamiQuestionCategory> categories;

  const YuvaUdyamiQuestionnaireData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categories,
  });
}

class YuvaUdyamiServiceCard {
  final String id;
  final String icon;
  final String name;
  final String desc;
  final String commission;
  final int deposit;

  const YuvaUdyamiServiceCard({
    required this.id,
    required this.icon,
    required this.name,
    required this.desc,
    this.commission = '4% COMMISSION',
    this.deposit = 500000,
  });
}

class YuvaUdyamiServiceCards {
  static const int depositPerModule = 500000;

  static const List<YuvaUdyamiServiceCard> all = [
    YuvaUdyamiServiceCard(
      id: 'expert',
      icon: '🎓',
      name: 'Expert Coach',
      desc:
          'Mentor youth members through advanced entrepreneurship tracks, credit-readiness milestones, and Udyami Circle sessions — for experienced professionals and established entrepreneurs.',
    ),
    YuvaUdyamiServiceCard(
      id: 'intermediate',
      icon: '📘',
      name: 'Intermediate Coach',
      desc:
          'Guide youth members through skilling modules, cohort progress, and pathway completion — for professionals with hands-on training or coaching experience.',
    ),
    YuvaUdyamiServiceCard(
      id: 'skillmatch',
      icon: '🎯',
      name: 'Skill Matching Coach',
      desc:
          'Help youth members find the right pathway — Employment, Entrepreneurship or Education — through aptitude profiling and the cross-pathway recommendation engine.',
    ),
  ];
}

class YuvaUdyamiQuestionnaires {
  static const Map<String, YuvaUdyamiQuestionnaireData> all = {
    // 1. Expert Coach — Individual
    'q_expert_individual': YuvaUdyamiQuestionnaireData(
      id: 'q_expert_individual',
      title: 'Expert Coach — Individual Applicant Verification',
      subtitle:
          'Answer these 20 questions to show you can responsibly support youth members through Expert Coach.',
      categories: [
        YuvaUdyamiQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 1,
          questions: [
            'Explain your understanding of how Expert Coach works within Yuva Udyami, and how a youth member benefits from it.',
            "How would you explain the Udyami Circle mentorship layer and the entrepreneurship track's milestone plan and credit-readiness scoring to a first-time youth member?",
            "What factors most affect the quality and pace of a youth member's entrepreneurship progress for a youth member working with an Expert Coach?",
            "What would you check regarding the youth member's business idea, milestone evidence (customer discovery, unit economics, first sales) and credit-readiness score before referring or mentoring a youth member as an Expert Coach?",
            'What questions would you ask a youth member to see if Expert Coach guidance suits their stage and goals?',
          ],
        ),
        YuvaUdyamiQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 6,
          questions: [
            'What concerns might a youth member raise about working with an Expert Coach, and how would you address them?',
            "How would you differentiate Yuva Udyami's Expert Coach role from informal, unstructured business advice with no milestone tracking or credit-readiness assessment?",
            'What is your existing network or youth community relevant to Expert Coach?',
            'Would you ever promise a youth member a guaranteed job, loan or outcome as an Expert Coach? Why or why not?',
            'What is your plan to start mentoring or matching youth members as an Expert Coach within your first 30 days as a partner?',
          ],
        ),
        YuvaUdyamiQuestionCategory(
          name: 'Process & Documentation',
          startNum: 11,
          questions: [
            'What is the indicative micro-loan ceiling for Hustler-tier vs Founder-tier Prince/Princess members, and how would you explain this range to a mentee?',
            'How would you explain that credit decisions belong exclusively to the FCMCSL credit committee, not to you as a coach?',
            "What would you check regarding a youth member's evidenced milestones (customer discovery, unit economics, first sales) before advancing them toward a credit-readiness packet?",
            'How would you support a mentee who is not yet ready for the credit-readiness threshold?',
            'What would make you decline to mentor a particular youth member as an Expert Coach?',
          ],
        ),
        YuvaUdyamiQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 16,
          questions: [
            'How would you explain the Udyami Circle mentor-matching process to a new mentee?',
            'How would you keep a mentee updated on their entrepreneurship milestone progress?',
            'What would you tell a mentee about how their first sales through Udyami Queens (where applicable) count toward milestones?',
            "How would you handle a mentee's complaint about mentorship quality or availability, and who would you escalate it to?",
            'What is your plan to help a mentee assemble a strong recommendation packet for the credit committee?',
          ],
        ),
      ],
    ),

    // 2. Expert Coach — Institutional
    'q_expert_institutional': YuvaUdyamiQuestionnaireData(
      id: 'q_expert_institutional',
      title: 'Expert Coach — Institutional Applicant Verification',
      subtitle:
          "Establish your organization's expertise, systems and accountability for supporting youth members through Expert Coach.",
      categories: [
        YuvaUdyamiQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 21,
          questions: [
            "Rate your institution's expertise (1–5) in Expert Coach, with brief justification.",
            "Describe your institution's process for verifying a mentor's entrepreneurship or credit-readiness expertise before assigning them as an Expert Coach.",
            'What legal and compliance framework does your institution maintain specific to credit-readiness assessment standards and the boundary between coaching and formal credit decisions, which remain with the FCMCSL credit committee?',
            "What is your institution's existing youth network or client base relevant to Expert Coach?",
            "What is your institution's estimated monthly capacity to support youth members as Expert Coaches?",
          ],
        ),
        YuvaUdyamiQuestionCategory(
          name: 'Systems & Operations',
          startNum: 26,
          questions: [
            'What technology or systems does your institution use to manage Expert Coach sessions and outcome logging?',
            'How would your institution integrate Expert Coach activities into its existing workflows?',
            'What training or resources would your institution need to represent Expert Coach effectively?',
            "How does your institution ensure compliance with Yuva Udyami's Code of Conduct when mentoring youth as an Expert Coach?",
            'What risks specific to Expert Coach does your institution watch for, and how are they mitigated?',
          ],
        ),
        YuvaUdyamiQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 31,
          questions: [
            'What internal criteria does your institution apply before assigning a staff member as an Expert Coach?',
            "How does your institution verify a mentor's expertise in entrepreneurship, unit economics or credit-readiness assessment?",
            'What role does your institution play in reviewing milestone evidence before a credit-readiness packet is submitted?',
            'How does your institution ensure staff never present coaching guidance as a credit approval or guarantee?',
            "What process does your institution follow if a mentee's entrepreneurship track stalls or milestones aren't met?",
          ],
        ),
        YuvaUdyamiQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 36,
          questions: [
            'How does your institution track mentor-session outcomes and mentee progress over time?',
            'What reporting does your institution require from Yuva Udyami on referred Expert Coach engagements?',
            'How does your institution handle a dispute raised by a mentee about coaching quality or credit-readiness assessment?',
            'What service-level expectations does your institution set for Expert Coach engagements?',
            'How does your institution measure the success of youth members coached through Expert Coach engagements?',
          ],
        ),
      ],
    ),

    // 3. Intermediate Coach — Individual
    'q_intermediate_individual': YuvaUdyamiQuestionnaireData(
      id: 'q_intermediate_individual',
      title: 'Intermediate Coach — Individual Applicant Verification',
      subtitle:
          'Answer these 20 questions to show you can responsibly support youth members through Intermediate Coach.',
      categories: [
        YuvaUdyamiQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 41,
          questions: [
            'Explain your understanding of how Intermediate Coach works within Yuva Udyami, and how a youth member benefits from it.',
            'How would you explain the skilling module structure, cohort attendance tracking, and the verifiable programme certificate on completion to a first-time youth member?',
            "What factors most affect a youth member's completion rate and skill-assessment outcomes for a youth member working with an Intermediate Coach?",
            "What would you check regarding the youth member's skill profile, cohort progress and any location/hours/device constraints before referring or mentoring a youth member as an Intermediate Coach?",
            'What questions would you ask a youth member to see if Intermediate Coach guidance suits their stage and goals?',
          ],
        ),
        YuvaUdyamiQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 46,
          questions: [
            'What concerns might a youth member raise about working with an Intermediate Coach, and how would you address them?',
            "How would you differentiate Yuva Udyami's Intermediate Coach role from an unstructured training session with no attendance evidence or certificate?",
            'What is your existing network or youth community relevant to Intermediate Coach?',
            'Would you ever promise a youth member a guaranteed job, loan or outcome as an Intermediate Coach? Why or why not?',
            'What is your plan to start mentoring or matching youth members as an Intermediate Coach within your first 30 days as a partner?',
          ],
        ),
        YuvaUdyamiQuestionCategory(
          name: 'Process & Documentation',
          startNum: 51,
          questions: [
            'What is the minimum attendance or completion evidence required before a skilling module issues a verifiable certificate?',
            'How would you explain the guardian-consent flow to a Prince/Princess (minor) member and their guardian?',
            "What would you check regarding a youth member's device, location and hours constraints before recommending a skilling track?",
            'How would you support a youth member who falls behind in cohort attendance or progress?',
            'What would make you decline to coach a particular youth member as an Intermediate Coach?',
          ],
        ),
        YuvaUdyamiQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 56,
          questions: [
            "How would you explain the difference between Yuva Udyami's curated skilling modules and external course signposting?",
            'How would you keep a youth member updated on their cohort progress and upcoming assessments?',
            'What would you tell a youth member about how their programme certificate is used for pathway provisioning into ecosystem roles?',
            "How would you handle a youth member's complaint about a skilling module or cohort experience, and who would you escalate it to?",
            'What is your plan to help a youth member complete their skilling track and move toward provisioning?',
          ],
        ),
      ],
    ),

    // 4. Intermediate Coach — Institutional
    'q_intermediate_institutional': YuvaUdyamiQuestionnaireData(
      id: 'q_intermediate_institutional',
      title: 'Intermediate Coach — Institutional Applicant Verification',
      subtitle:
          "Establish your organization's expertise, systems and accountability for supporting youth members through Intermediate Coach.",
      categories: [
        YuvaUdyamiQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 61,
          questions: [
            "Rate your institution's expertise (1–5) in Intermediate Coach, with brief justification.",
            "Describe your institution's process for verifying a youth member's cohort progress and skill profile before assigning coaching support.",
            'What legal and compliance framework does your institution maintain specific to skilling module quality standards and assessment/attendance evidence requirements?',
            "What is your institution's existing youth network or client base relevant to Intermediate Coach?",
            "What is your institution's estimated monthly capacity to support youth members as Intermediate Coaches?",
          ],
        ),
        YuvaUdyamiQuestionCategory(
          name: 'Systems & Operations',
          startNum: 66,
          questions: [
            'What technology or systems does your institution use to manage Intermediate Coach sessions and outcome logging?',
            'How would your institution integrate Intermediate Coach activities into its existing workflows?',
            'What training or resources would your institution need to represent Intermediate Coach effectively?',
            "How does your institution ensure compliance with Yuva Udyami's Code of Conduct when mentoring youth as an Intermediate Coach?",
            'What risks specific to Intermediate Coach does your institution watch for, and how are they mitigated?',
          ],
        ),
        YuvaUdyamiQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 71,
          questions: [
            'What internal criteria does your institution apply before assigning a staff member as an Intermediate Coach?',
            "How does your institution verify a coach's training or subject-matter expertise for a given skilling track?",
            'What role does your institution play in tracking cohort attendance and assessment evidence for coached youth members?',
            'How does your institution handle guardian-linked coaching for Prince/Princess (minor) members?',
            'What process does your institution follow if a coached youth member falls behind in their skilling track?',
          ],
        ),
        YuvaUdyamiQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 76,
          questions: [
            "How does your institution verify a youth member's certificate is issued only on qualifying, evidenced completion?",
            'What reporting does your institution require from Yuva Udyami on referred Intermediate Coach engagements?',
            'How does your institution handle a dispute raised by a youth member about a skilling module or coaching session?',
            'What service-level expectations does your institution set for Intermediate Coach engagements?',
            'How does your institution measure the success of youth members coached through Intermediate Coach engagements?',
          ],
        ),
      ],
    ),

    // 5. Skill Matching Coach — Individual
    'q_skillmatch_individual': YuvaUdyamiQuestionnaireData(
      id: 'q_skillmatch_individual',
      title: 'Skill Matching Coach — Individual Applicant Verification',
      subtitle:
          'Answer these 20 questions to show you can responsibly support youth members through Skill Matching Coach.',
      categories: [
        YuvaUdyamiQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 81,
          questions: [
            'Explain your understanding of how Skill Matching Coach works within Yuva Udyami, and how a youth member benefits from it.',
            'How would you explain the aptitude and skill profiling intake and the cross-pathway recommendation engine that suggests Employment, Entrepreneurship or Education to a first-time youth member?',
            "What factors most affect how well a youth member's pathway match fits their interests and constraints for a youth member working with a Skill Matching Coach?",
            "What would you check regarding the youth member's intake questionnaire responses, assessment results, and stated constraints (location, hours, device) before referring or mentoring a youth member as a Skill Matching Coach?",
            'What questions would you ask a youth member to see if Skill Matching Coach guidance suits their stage and goals?',
          ],
        ),
        YuvaUdyamiQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 86,
          questions: [
            'What concerns might a youth member raise about working with a Skill Matching Coach, and how would you address them?',
            "How would you differentiate Yuva Udyami's Skill Matching Coach role from guessing a youth member's best pathway without any structured profiling or assessment?",
            'What is your existing network or youth community relevant to Skill Matching Coach?',
            'Would you ever promise a youth member a guaranteed job, loan or outcome as a Skill Matching Coach? Why or why not?',
            'What is your plan to start mentoring or matching youth members as a Skill Matching Coach within your first 30 days as a partner?',
          ],
        ),
        YuvaUdyamiQuestionCategory(
          name: 'Process & Documentation',
          startNum: 91,
          questions: [
            'What is the intake questionnaire designed to capture, and how would you walk a youth member through it?',
            'How would you explain that every automated recommendation must display its reason, and recommendations are advisory only?',
            "What would you check regarding a youth member's interests, constraints and assessment results before finalising a pathway match?",
            'How would you support a youth member who wants to switch pathways after starting (e.g., from Employment to Entrepreneurship)?',
            'What would make you decline to match a particular youth member into a specific pathway?',
          ],
        ),
        YuvaUdyamiQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 96,
          questions: [
            'How would you explain pathway provisioning (Queens seller/assistant, Build Hive worker, rider, CP apprentice) to a youth member nearing completion?',
            'How would you keep a youth member updated as their profile moves through profiling, cohort enrolment and provisioning?',
            'What would you tell a youth member about how their KYC and profile carry over automatically into a receiving app without re-KYC?',
            "How practical is your plan to handle a youth member's complaint about being matched to the wrong pathway, and who would you escalate it to?",
            'What is your plan to help a youth member confirm their primary pathway and enrol in a first track within 30 days?',
          ],
        ),
      ],
    ),

    // 6. Skill Matching Coach — Institutional
    'q_skillmatch_institutional': YuvaUdyamiQuestionnaireData(
      id: 'q_skillmatch_institutional',
      title: 'Skill Matching Coach — Institutional Applicant Verification',
      subtitle:
          "Establish your organization's expertise, systems and accountability for supporting youth members through Skill Matching Coach.",
      categories: [
        YuvaUdyamiQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 101,
          questions: [
            "Rate your institution's expertise (1–5) in Skill Matching Coach, with brief justification.",
            "Describe your institution's process for reviewing a youth member's intake profile and constraints before recommending a pathway match.",
            'What legal and compliance framework does your institution maintain specific to pathway-matching transparency (every recommendation must display its reason) and guardian-consent rules for minors under Prince/Princess?',
            "What is your institution's existing youth network or client base relevant to Skill Matching Coach?",
            "What is your institution's estimated monthly capacity to support youth members as Skill Matching Coaches?",
          ],
        ),
        YuvaUdyamiQuestionCategory(
          name: 'Systems & Operations',
          startNum: 106,
          questions: [
            'What technology or systems does your institution use to manage Skill Matching Coach sessions and outcome logging?',
            'How would your institution integrate Skill Matching Coach activities into its existing workflows?',
            'What training or resources would your institution need to represent Skill Matching Coach effectively?',
            "How does your institution ensure compliance with Yuva Udyami's Code of Conduct when mentoring youth as a Skill Matching Coach?",
            'What risks specific to Skill Matching Coach does your institution watch for, and how are they mitigated?',
          ],
        ),
        YuvaUdyamiQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 111,
          questions: [
            'What internal criteria does your institution apply before assigning a staff member as a Skill Matching Coach?',
            "How does your institution verify a youth member's intake profile and constraints before recommending a pathway?",
            'What role does your institution play in ensuring every pathway recommendation displays its reasoning to the youth member?',
            'How does your institution handle a referral involving a Prince/Princess (minor) member requiring guardian consent?',
            'What process does your institution follow if a youth member disagrees with their recommended pathway match?',
          ],
        ),
        YuvaUdyamiQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 116,
          questions: [
            'How does your institution verify pathway-provisioning hand-offs (KYC, certificate, CP attribution) are accurately carried over to receiving apps?',
            'What reporting does your institution require from Yuva Udyami on referred Skill Matching Coach engagements?',
            'How does your institution handle a dispute raised by a youth member about a pathway mismatch?',
            'What service-level expectations does your institution set for Skill Matching Coach engagements?',
            'How does your institution measure the success of youth members matched through Skill Matching Coach engagements?',
          ],
        ),
      ],
    ),
  };
}
