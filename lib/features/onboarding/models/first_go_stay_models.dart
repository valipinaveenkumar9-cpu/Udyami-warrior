// FIRST GO STAY Channel Partner Models and Data Schemas

class FirstGoQuestionCategory {
  final String name;
  final int startNum;
  final List<String> questions;

  const FirstGoQuestionCategory({
    required this.name,
    required this.startNum,
    required this.questions,
  });
}

class FirstGoQuestionnaireData {
  final String id;
  final String title;
  final String subtitle;
  final List<FirstGoQuestionCategory> categories;

  const FirstGoQuestionnaireData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categories,
  });
}

class FirstGoStayServiceCard {
  final String id;
  final String icon;
  final String name;
  final String desc;

  const FirstGoStayServiceCard({
    required this.id,
    required this.icon,
    required this.name,
    required this.desc,
  });
}

class FirstGoStayConstants {
  static const int depositPerModule = 500000;
  static const String commissionRate = '4%';

  static const List<FirstGoStayServiceCard> serviceCards = [
    FirstGoStayServiceCard(
      id: 'nestfirst',
      icon: '🏨',
      name: 'NestFirst™',
      desc: 'Refer members into hotel bookings — domestic & international, standard and hourly stay, with FirstGo Pass member pricing.',
    ),
    FirstGoStayServiceCard(
      id: 'rootstay',
      icon: '🏡',
      name: 'RootStay™',
      desc: "Refer members into RootStay's verified homestay network — authentic hosts, safety-rated, with local experience add-ons.",
    ),
    FirstGoStayServiceCard(
      id: 'skyfirst',
      icon: '✈️',
      name: 'SkyFirst™',
      desc: 'Refer members into domestic & international flight bookings — no hidden fees, AI price prediction, SkyCoins on every trip.',
    ),
    FirstGoStayServiceCard(
      id: 'wandercraft',
      icon: '🧭',
      name: 'WanderCraft™',
      desc: 'Refer members into curated domestic & international travel packages — pilgrimage, eco, adventure, and niche trip experiences.',
    ),
    FirstGoStayServiceCard(
      id: 'safevoyage',
      icon: '🛡️',
      name: 'SafeVoyage™',
      desc: 'Refer members into travel insurance — trip cancellation, medical, baggage, and adventure sports cover.',
    ),
    FirstGoStayServiceCard(
      id: 'ridefirst',
      icon: '🚗',
      name: 'RideFirst™',
      desc: 'Refer members into airport transfers, intercity cabs, and local sightseeing — fixed fares, live tracking.',
    ),
    FirstGoStayServiceCard(
      id: 'visago',
      icon: '🛂',
      name: 'VisaGo™',
      desc: 'Refer members into visa documentation, assistance and tracking for 50+ countries.',
    ),
    FirstGoStayServiceCard(
      id: 'govault',
      icon: '💰',
      name: 'GoVault™',
      desc: 'Refer members into the FirstGo Pass, SkyCoins referral system, and the Save-to-Travel micro-savings scheme.',
    ),
    FirstGoStayServiceCard(
      id: 'stayhour',
      icon: '⏱️',
      name: 'StayHour™',
      desc: 'Refer members into hourly hotel stays — from 2 to 12 hours, for business, layover, wellness and day-use needs.',
    ),
    FirstGoStayServiceCard(
      id: 'villagefirst',
      icon: '🏘️',
      name: 'VillageFirst™',
      desc: 'Refer international and NRI clients into curated village immersion experiences across India.',
    ),
    FirstGoStayServiceCard(
      id: 'harvestpath',
      icon: '🌾',
      name: 'HarvestPath™',
      desc: 'Refer members into agro-tourism experiences — farm stays, harvest participation, and farm-to-table dining.',
    ),
    FirstGoStayServiceCard(
      id: 'craftlegacy',
      icon: '🎨',
      name: 'CraftLegacy™',
      desc: "Refer members into India's GI-tagged art and craft heritage tours, with certified artisan purchases.",
    ),
  ];
}

class FirstGoStayQuestionnaires {
  static const Map<String, FirstGoQuestionnaireData> all = {
    // 1. NestFirst - Individual
    'q_nestfirst_individual': FirstGoQuestionnaireData(
      id: 'q_nestfirst_individual',
      title: 'NestFirst™ — Individual Applicant Verification',
      subtitle: 'Answer these 20 questions to show you can responsibly refer members into NestFirst™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 1,
          questions: [
            'Explain your understanding of how NestFirst™ works on FirstGo, and how a member benefits by using it.',
            'How would you explain NestFirst\'s hourly stay booking option and FirstGo Pass member pricing alongside the public price to a first-time client?',
            'What factors most affect the price and quality of a hotel stay for a member using NestFirst™?',
            'What would you check regarding the property\'s cancellation policy, star rating and verified review status before referring a client into NestFirst™?',
            'What questions would you ask a client to see if NestFirst™ suits their travel needs?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 6,
          questions: [
            'What concerns might a client raise about NestFirst™, and how would you address them?',
            'How would you differentiate FirstGo\'s NestFirst™ from booking directly through a hotel\'s own website or a generic OTA without FirstGo Pass member pricing?',
            'What is your existing network or client base relevant to NestFirst™?',
            'Would you ever promise a client a discount, upgrade or outcome from NestFirst™ that FirstGo hasn\'t confirmed? Why or why not?',
            'What is your plan to start referring clients into NestFirst™ within your first 30 days as a partner?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Process & Documentation',
          startNum: 11,
          questions: [
            'What is the price range difference between a Budget, Mid-Range, Premium and Luxury hotel booking on NestFirst, and how would you help a client choose?',
            'How would you explain NestFirst\'s Smart Price Calendar to help a client find the cheapest available dates?',
            'What would you check regarding a hotel\'s cancellation policy (free, partial refund, non-refundable) before referring a booking?',
            'How would you support a corporate client who needs GST invoicing and travel-policy compliance settings?',
            'What would make you decline to refer a particular client into a NestFirst booking?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 16,
          questions: [
            'How would you explain the Verified Review System to a client concerned about fake reviews?',
            'How would you keep a client updated on their booking status after referral?',
            'What would you tell a client about the Room Comparison feature when they\'re deciding between hotels?',
            'How would you handle a client\'s complaint about a hotel booking, and who would you escalate it to?',
            'What is your plan to help a client understand FirstGo Pass member pricing on their first NestFirst booking?',
          ],
        ),
      ],
    ),

    // 2. NestFirst - Institutional
    'q_nestfirst_institutional': FirstGoQuestionnaireData(
      id: 'q_nestfirst_institutional',
      title: 'NestFirst™ — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into NestFirst™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 21,
          questions: [
            'Rate your institution\'s expertise (1–5) in NestFirst™, with brief justification.',
            'Describe your institution\'s process for verifying a client\'s travel dates and preferences before referring a NestFirst hotel booking opportunity.',
            'What legal and compliance framework does your institution maintain specific to hotel booking policies, cancellation terms and corporate GST invoicing requirements?',
            'What is your institution\'s existing client base or network relevant to NestFirst™?',
            'What is your institution\'s estimated monthly capacity to refer qualified NestFirst™ clients?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Systems & Operations',
          startNum: 26,
          questions: [
            'What technology or systems does your institution use to manage NestFirst™ referrals and records?',
            'How would your institution integrate NestFirst™ referrals into its existing workflows?',
            'What training or resources would your institution need to represent NestFirst™ effectively?',
            'How does your institution ensure compliance with FirstGo\'s Code of Conduct when referring NestFirst™ clients?',
            'What risks specific to NestFirst™ does your institution watch for, and how are they mitigated?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 31,
          questions: [
            'What internal criteria does your institution apply before referring a client into a NestFirst booking?',
            'How does your institution verify a client\'s travel dates and budget before submitting a referral?',
            'What role does your institution play in explaining cancellation policies to referred clients?',
            'How does your institution handle a client\'s request for corporate GST invoicing on a NestFirst booking?',
            'What process does your institution follow if a referred client wants to modify or cancel a booking?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 36,
          questions: [
            'How does your institution verify hotel star ratings and review authenticity before recommending a property?',
            'What reporting does your institution require from FirstGo on referred NestFirst bookings?',
            'How does your institution handle a dispute raised by a referred client about a hotel stay?',
            'What service-level expectations does your institution set for NestFirst referrals?',
            'How does your institution measure the success of clients referred into NestFirst?',
          ],
        ),
      ],
    ),

    // 3. RootStay - Individual
    'q_rootstay_individual': FirstGoQuestionnaireData(
      id: 'q_rootstay_individual',
      title: 'RootStay™ — Individual Applicant Verification',
      subtitle: 'Answer these 20 questions to show you can responsibly refer members into RootStay™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 41,
          questions: [
            'Explain your understanding of how RootStay™ works on FirstGo, and how a member benefits by using it.',
            'How would you explain RootStay\'s physical host verification process and safety ratings to a first-time client?',
            'What factors most affect the authenticity and safety of a homestay experience for a member using RootStay™?',
            'What would you check regarding the host\'s verification status, safety ratings and cancellation policy before referring a client into RootStay™?',
            'What questions would you ask a client to see if RootStay™ suits their travel needs?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 46,
          questions: [
            'What concerns might a client raise about RootStay™, and how would you address them?',
            'How would you differentiate FirstGo\'s RootStay™ from booking through an unverified homestay listing on a generic platform?',
            'What is your existing network or client base relevant to RootStay™?',
            'Would you ever promise a client a discount, upgrade or outcome from RootStay™ that FirstGo hasn\'t confirmed? Why or why not?',
            'What is your plan to start referring clients into RootStay™ within your first 30 days as a partner?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Process & Documentation',
          startNum: 51,
          questions: [
            'What is the minimum stay requirement for a RootStay booking, and how would you explain long-stay discounts to a client?',
            'How would you explain the Experience Add-ons (cooking classes, farm tours, craft workshops) to a client?',
            'What would you check regarding a host\'s safety ratings (property, locality, responsiveness, cleanliness) before referring?',
            'How would you support a client interested in Rural & Heritage Homestays (Kerala homes, Himachali houses, havelis)?',
            'What would make you decline to refer a particular client into a RootStay booking?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 56,
          questions: [
            'How would you explain the physical host-verification process to a safety-conscious client?',
            'How would you keep a client updated on their homestay booking after referral?',
            'What would you tell a client about Host Profile Cards when they\'re choosing between hosts?',
            'How would you handle a client\'s complaint about a RootStay experience, and who would you escalate it to?',
            'What is your plan to help a client discover the right RootStay property for their travel style?',
          ],
        ),
      ],
    ),

    // 4. RootStay - Institutional
    'q_rootstay_institutional': FirstGoQuestionnaireData(
      id: 'q_rootstay_institutional',
      title: 'RootStay™ — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into RootStay™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 61,
          questions: [
            'Rate your institution\'s expertise (1–5) in RootStay™, with brief justification.',
            'Describe your institution\'s process for reviewing a client\'s homestay preferences and verifying the destination host\'s verification status before referring.',
            'What legal and compliance framework does your institution maintain specific to host verification standards, safety ratings and long-stay pricing policies?',
            'What is your institution\'s existing client base or network relevant to RootStay™?',
            'What is your institution\'s estimated monthly capacity to refer qualified RootStay™ clients?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Systems & Operations',
          startNum: 26 + 40,
          questions: [
            'What technology or systems does your institution use to manage RootStay™ referrals and records?',
            'How would your institution integrate RootStay™ referrals into its existing workflows?',
            'What training or resources would your institution need to represent RootStay™ effectively?',
            'How does your institution ensure compliance with FirstGo\'s Code of Conduct when referring RootStay™ clients?',
            'What risks specific to RootStay™ does your institution watch for, and how are they mitigated?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 71,
          questions: [
            'What internal criteria does your institution apply before referring a client into a RootStay booking?',
            'How does your institution verify a host\'s verification and safety-rating status before submitting a referral?',
            'What role does your institution play in matching clients to Rural & Heritage Homestays that suit them?',
            'How does your institution handle a client\'s request for a long-stay discount on a RootStay booking?',
            'What process does your institution follow if a referred client raises a safety concern about a host?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 76,
          questions: [
            'How does your institution verify Experience Add-ons are accurately described before recommending them?',
            'What reporting does your institution require from FirstGo on referred RootStay bookings?',
            'How does your institution handle a dispute raised by a referred client about a homestay experience?',
            'What service-level expectations does your institution set for RootStay referrals?',
            'How does your institution measure the success of clients referred into RootStay?',
          ],
        ),
      ],
    ),

    // 5. SkyFirst - Individual
    'q_skyfirst_individual': FirstGoQuestionnaireData(
      id: 'q_skyfirst_individual',
      title: 'SkyFirst™ — Individual Applicant Verification',
      subtitle: 'Answer these 20 questions to show you can responsibly refer members into SkyFirst™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 81,
          questions: [
            'Explain your understanding of how SkyFirst™ works on FirstGo, and how a member benefits by using it.',
            'How would you explain SkyFirst\'s no-hidden-fee pricing and AI-powered price prediction (Buy Now / Wait signal) to a first-time client?',
            'What factors most affect the fare and value of a flight booking for a member using SkyFirst™?',
            'What would you check regarding the client\'s travel dates, flexible date options and baggage requirements before referring a client into SkyFirst™?',
            'What questions would you ask a client to see if SkyFirst™ suits their travel needs?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 86,
          questions: [
            'What concerns might a client raise about SkyFirst™, and how would you address them?',
            'How would you differentiate FirstGo\'s SkyFirst™ from booking directly through an airline\'s website or a generic OTA with hidden convenience fees?',
            'What is your existing network or client base relevant to SkyFirst™?',
            'Would you ever promise a client a discount, upgrade or outcome from SkyFirst™ that FirstGo hasn\'t confirmed? Why or why not?',
            'What is your plan to start referring clients into SkyFirst™ within your first 30 days as a partner?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Process & Documentation',
          startNum: 91,
          questions: [
            'What is the passenger limit for a Group Booking on SkyFirst, and how would you explain the seat-map selection?',
            'How would you explain the AI-powered 7-day price prediction (Buy Now / Wait) to a client deciding when to book?',
            'What would you check regarding a client\'s baggage needs and fare class before referring a flight booking?',
            'How would you support a client who wants to use the ±3-day Flexible Date Search to find a lower fare?',
            'What would make you decline to refer a particular client into a SkyFirst booking?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 96,
          questions: [
            'How would you explain the No Hidden Fees policy to a client who has been burned by surprise charges before?',
            'How would you keep a client updated on their flight booking status after referral?',
            'What would you tell a client about entering their frequent-flyer number to earn airline miles?',
            'How would you handle a client\'s complaint about a SkyFirst booking, and who would you escalate it to?',
            'What is your plan to help a client earn and track SkyCoins on their first SkyFirst booking?',
          ],
        ),
      ],
    ),

    // 6. SkyFirst - Institutional
    'q_skyfirst_institutional': FirstGoQuestionnaireData(
      id: 'q_skyfirst_institutional',
      title: 'SkyFirst™ — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into SkyFirst™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 101,
          questions: [
            'Rate your institution\'s expertise (1–5) in SkyFirst™, with brief justification.',
            'Describe your institution\'s process for verifying a client\'s travel dates and fare preferences before referring a SkyFirst flight booking opportunity.',
            'What legal and compliance framework does your institution maintain specific to fare transparency, group booking rules and frequent-flyer integration?',
            'What is your institution\'s existing client base or network relevant to SkyFirst™?',
            'What is your institution\'s estimated monthly capacity to refer qualified SkyFirst™ clients?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Systems & Operations',
          startNum: 106,
          questions: [
            'What technology or systems does your institution use to manage SkyFirst™ referrals and records?',
            'How would your institution integrate SkyFirst™ referrals into its existing workflows?',
            'What training or resources would your institution need to represent SkyFirst™ effectively?',
            'How does your institution ensure compliance with FirstGo\'s Code of Conduct when referring SkyFirst™ clients?',
            'What risks specific to SkyFirst™ does your institution watch for, and how are they mitigated?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 111,
          questions: [
            'What internal criteria does your institution apply before referring a client into a SkyFirst booking?',
            'How does your institution verify a client\'s travel dates and fare-class preferences before submitting a referral?',
            'What role does your institution play in explaining the price-prediction signal to referred clients?',
            'How does your institution handle a Group Booking referral of up to 9 passengers?',
            'What process does your institution follow if a referred client\'s flight is delayed or cancelled?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 116,
          questions: [
            'How does your institution verify baggage and fee disclosures are accurate before recommending a fare?',
            'What reporting does your institution require from FirstGo on referred SkyFirst bookings?',
            'How does your institution handle a dispute raised by a referred client about a flight booking?',
            'What service-level expectations does your institution set for SkyFirst referrals?',
            'How does your institution measure the success of clients referred into SkyFirst?',
          ],
        ),
      ],
    ),

    // 7. WanderCraft - Individual
    'q_wandercraft_individual': FirstGoQuestionnaireData(
      id: 'q_wandercraft_individual',
      title: 'WanderCraft™ — Individual Applicant Verification',
      subtitle: 'Answer these 20 questions to show you can responsibly refer members into WanderCraft™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 121,
          questions: [
            'Explain your understanding of how WanderCraft™ works on FirstGo, and how a member benefits by using it.',
            'How would you explain the trip experience catalogue (pilgrimage, eco, adventure, cultural) and the Package Builder customisation option to a first-time client?',
            'What factors most affect the value and fit of a travel package for a member using WanderCraft™?',
            'What would you check regarding the package\'s inclusions, exclusions and cancellation policy before referring a client into WanderCraft™?',
            'What questions would you ask a client to see if WanderCraft™ suits their travel needs?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 126,
          questions: [
            'What concerns might a client raise about WanderCraft™, and how would you address them?',
            'How would you differentiate FirstGo\'s WanderCraft™ from booking a generic tour package from an unaccountable local agent?',
            'What is your existing network or client base relevant to WanderCraft™?',
            'Would you ever promise a client a discount, upgrade or outcome from WanderCraft™ that FirstGo hasn\'t confirmed? Why or why not?',
            'What is your plan to start referring clients into WanderCraft™ within your first 30 days as a partner?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Process & Documentation',
          startNum: 131,
          questions: [
            'What is the minimum group size for Group & Family Package pricing on WanderCraft, and how would you explain it?',
            'How would you explain the Package Builder (build-your-own-package) option to a client with specific preferences?',
            'What would you check regarding a package\'s day-by-day itinerary and inclusions/exclusions before referring a client?',
            'How would you support a corporate client interested in a MICE (Meetings, Incentives, Conferences & Exhibitions) package?',
            'What would make you decline to refer a particular client into a WanderCraft package?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 136,
          questions: [
            'How would you explain Flash Deals and FirstGo Pass early access to a deal-conscious client?',
            'How would you keep a client updated on their package booking after referral?',
            'What would you tell a client about the Customisation Engine when they want to personalise their trip dates or room type?',
            'How would you handle a client\'s complaint about a WanderCraft package, and who would you escalate it to?',
            'What is your plan to help a client choose the right trip experience category (pilgrimage, eco, adventure, cultural) for their goals?',
          ],
        ),
      ],
    ),

    // 8. WanderCraft - Institutional
    'q_wandercraft_institutional': FirstGoQuestionnaireData(
      id: 'q_wandercraft_institutional',
      title: 'WanderCraft™ — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into WanderCraft™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 141,
          questions: [
            'Rate your institution\'s expertise (1–5) in WanderCraft™, with brief justification.',
            'Describe your institution\'s process for reviewing a client\'s trip preferences and matching them to the right WanderCraft package category before referring.',
            'What legal and compliance framework does your institution maintain specific to package transparency, group/family pricing and corporate MICE requirements?',
            'What is your institution\'s existing client base or network relevant to WanderCraft™?',
            'What is your institution\'s estimated monthly capacity to refer qualified WanderCraft™ clients?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Systems & Operations',
          startNum: 146,
          questions: [
            'What technology or systems does your institution use to manage WanderCraft™ referrals and records?',
            'How would your institution integrate WanderCraft™ referrals into its existing workflows?',
            'What training or resources would your institution need to represent WanderCraft™ effectively?',
            'How does your institution ensure compliance with FirstGo\'s Code of Conduct when referring WanderCraft™ clients?',
            'What risks specific to WanderCraft™ does your institution watch for, and how are they mitigated?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 151,
          questions: [
            'What internal criteria does your institution apply before referring a client into a WanderCraft package?',
            'How does your institution verify a package\'s inclusions and cancellation policy before submitting a referral?',
            'What role does your institution play in matching a client to the right trip experience category?',
            'How does your institution handle a Corporate MICE package referral for a business client?',
            'What process does your institution follow if a referred client wants to customise or modify a package?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 156,
          questions: [
            'How does your institution verify Flash Deal pricing and early-access terms before recommending them?',
            'What reporting does your institution require from FirstGo on referred WanderCraft bookings?',
            'How does your institution handle a dispute raised by a referred client about a package experience?',
            'What service-level expectations does your institution set for WanderCraft referrals?',
            'How does your institution measure the success of clients referred into WanderCraft?',
          ],
        ),
      ],
    ),

    // 9. SafeVoyage - Individual
    'q_safevoyage_individual': FirstGoQuestionnaireData(
      id: 'q_safevoyage_individual',
      title: 'SafeVoyage™ — Individual Applicant Verification',
      subtitle: 'Answer these 20 questions to show you can responsibly refer members into SafeVoyage™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 161,
          questions: [
            'Explain your understanding of how SafeVoyage™ works on FirstGo, and how a member benefits by using it.',
            'How would you explain SafeVoyage\'s coverage types — trip cancellation, medical emergency abroad, baggage loss, and adventure sports add-on to a first-time client?',
            'What factors most affect the coverage adequacy and cost of a travel insurance plan for a member using SafeVoyage™?',
            'What would you check regarding the client\'s destination, trip type and any pre-existing conditions relevant to coverage before referring a client into SafeVoyage™?',
            'What questions would you ask a client to see if SafeVoyage™ suits their travel needs?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 166,
          questions: [
            'What concerns might a client raise about SafeVoyage™, and how would you address them?',
            'How would you differentiate FirstGo\'s SafeVoyage™ from travelling without insurance, or buying a generic policy unrelated to the specific trip?',
            'What is your existing network or client base relevant to SafeVoyage™?',
            'Would you ever promise a client a discount, upgrade or outcome from SafeVoyage™ that FirstGo hasn\'t confirmed? Why or why not?',
            'What is your plan to start referring clients into SafeVoyage™ within your first 30 days as a partner?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Process & Documentation',
          startNum: 171,
          questions: [
            'What is the difference between a Domestic Trip Basic and Comprehensive insurance plan, and how would you explain it to a client?',
            'How would you explain the Annual Multi-Trip Policy to a client who travels frequently within 12 months?',
            'What would you check regarding a client\'s destination and trip type before referring a SafeVoyage plan?',
            'How would you support a client interested in the optional Adventure Sports Cover add-on?',
            'What would make you decline to refer a particular client into a SafeVoyage plan?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 176,
          questions: [
            'How would you explain the flight delay and missed connection compensation terms to a client?',
            'How would you keep a client updated on their policy status after referral?',
            'What would you tell a client about the Instant Digital Policy issuance process?',
            'How would you handle a client\'s complaint about a SafeVoyage claim, and who would you escalate it to?',
            'What is your plan to help a client choose the right coverage level for pilgrimage or high-altitude travel?',
          ],
        ),
      ],
    ),

    // 10. SafeVoyage - Institutional
    'q_safevoyage_institutional': FirstGoQuestionnaireData(
      id: 'q_safevoyage_institutional',
      title: 'SafeVoyage™ — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into SafeVoyage™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 181,
          questions: [
            'Rate your institution\'s expertise (1–5) in SafeVoyage™, with brief justification.',
            'Describe your institution\'s process for assessing a client\'s trip type and coverage needs before referring a SafeVoyage opportunity.',
            'What legal and compliance framework does your institution maintain specific to insurance disclosure requirements and coverage-exclusion communication?',
            'What is your institution\'s existing client base or network relevant to SafeVoyage™?',
            'What is your institution\'s estimated monthly capacity to refer qualified SafeVoyage™ clients?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Systems & Operations',
          startNum: 186,
          questions: [
            'What technology or systems does your institution use to manage SafeVoyage™ referrals and records?',
            'How would your institution integrate SafeVoyage™ referrals into its existing workflows?',
            'What training or resources would your institution need to represent SafeVoyage™ effectively?',
            'How does your institution ensure compliance with FirstGo\'s Code of Conduct when referring SafeVoyage™ clients?',
            'What risks specific to SafeVoyage™ does your institution watch for, and how are they mitigated?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 191,
          questions: [
            'What internal criteria does your institution apply before referring a client into a SafeVoyage plan?',
            'How does your institution verify a client\'s destination and trip type before submitting a referral?',
            'What role does your institution play in explaining coverage exclusions to referred clients?',
            'How does your institution handle a referral for the Annual Multi-Trip Policy?',
            'What process does your institution follow if a referred client needs to file a claim?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 196,
          questions: [
            'How does your institution verify Adventure Sports Cover eligibility before recommending the add-on?',
            'What reporting does your institution require from FirstGo on referred SafeVoyage policies?',
            'How does your institution handle a dispute raised by a referred client about a claim outcome?',
            'What service-level expectations does your institution set for SafeVoyage referrals?',
            'How does your institution measure the success of clients referred into SafeVoyage?',
          ],
        ),
      ],
    ),

    // 11. RideFirst - Individual
    'q_ridefirst_individual': FirstGoQuestionnaireData(
      id: 'q_ridefirst_individual',
      title: 'RideFirst™ — Individual Applicant Verification',
      subtitle: 'Answer these 20 questions to show you can responsibly refer members into RideFirst™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 201,
          questions: [
            'Explain your understanding of how RideFirst™ works on FirstGo, and how a member benefits by using it.',
            'How would you explain RideFirst\'s fixed-fare airport transfers and live GPS tracking to a first-time client?',
            'What factors most affect the reliability and cost of ground transportation for a member using RideFirst™?',
            'What would you check regarding the vehicle category, pickup timing and any female-driver preference before referring a client into RideFirst™?',
            'What questions would you ask a client to see if RideFirst™ suits their travel needs?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 206,
          questions: [
            'What concerns might a client raise about RideFirst™, and how would you address them?',
            'How would you differentiate FirstGo\'s RideFirst™ from booking an unverified local taxi or ride-hailing app without fixed fares?',
            'What is your existing network or client base relevant to RideFirst™?',
            'Would you ever promise a client a discount, upgrade or outcome from RideFirst™ that FirstGo hasn\'t confirmed? Why or why not?',
            'What is your plan to start referring clients into RideFirst™ within your first 30 days as a partner?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Process & Documentation',
          startNum: 211,
          questions: [
            'What is the difference between Hourly Rental and Full Day cab booking pricing, and how would you explain it to a client?',
            'How would you explain the Live Tracking feature (shared with up to 2 emergency contacts) to a safety-conscious client?',
            'What would you check regarding a client\'s vehicle category needs (Hatchback, Sedan, SUV, Tempo Traveller) before referring?',
            'How would you support a client requesting the Female Traveller driver-preference option?',
            'What would make you decline to refer a particular client into a RideFirst booking?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 216,
          questions: [
            'How would you explain how cabs auto-include in WanderCraft packages with pre-populated traveller details?',
            'How would you keep a client updated on their ride booking after referral?',
            'What would you tell a client about driver details being shared 2 hours before an airport pickup?',
            'How would you handle a client\'s complaint about a RideFirst booking, and who would you escalate it to?',
            'What is your plan to help a client choose between airport transfer, intercity, and local sightseeing options?',
          ],
        ),
      ],
    ),

    // 12. RideFirst - Institutional
    'q_ridefirst_institutional': FirstGoQuestionnaireData(
      id: 'q_ridefirst_institutional',
      title: 'RideFirst™ — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into RideFirst™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 221,
          questions: [
            'Rate your institution\'s expertise (1–5) in RideFirst™, with brief justification.',
            'Describe your institution\'s process for verifying a client\'s transfer or intercity travel needs before referring a RideFirst opportunity.',
            'What legal and compliance framework does your institution maintain specific to fixed-fare policies and live-tracking safety protocols?',
            'What is your institution\'s existing client base or network relevant to RideFirst™?',
            'What is your institution\'s estimated monthly capacity to refer qualified RideFirst™ clients?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Systems & Operations',
          startNum: 226,
          questions: [
            'What technology or systems does your institution use to manage RideFirst™ referrals and records?',
            'How would your institution integrate RideFirst™ referrals into its existing workflows?',
            'What training or resources would your institution need to represent RideFirst™ effectively?',
            'How does your institution ensure compliance with FirstGo\'s Code of Conduct when referring RideFirst™ clients?',
            'What risks specific to RideFirst™ does your institution watch for, and how are they mitigated?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 231,
          questions: [
            'What internal criteria does your institution apply before referring a client into a RideFirst booking?',
            'How does your institution verify a client\'s vehicle-category and route needs before submitting a referral?',
            'What role does your institution play in explaining fixed-fare, no-surge pricing to referred clients?',
            'How does your institution handle a Tempo Traveller group booking referral?',
            'What process does your institution follow if a referred client\'s ride is delayed or a driver issue arises?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 236,
          questions: [
            'How does your institution verify the Female Traveller driver-preference option is honoured?',
            'What reporting does your institution require from FirstGo on referred RideFirst bookings?',
            'How does your institution handle a dispute raised by a referred client about a ride?',
            'What service-level expectations does your institution set for RideFirst referrals?',
            'How does your institution measure the success of clients referred into RideFirst?',
          ],
        ),
      ],
    ),

    // 13. VisaGo - Individual
    'q_visago_individual': FirstGoQuestionnaireData(
      id: 'q_visago_individual',
      title: 'VisaGo™ — Individual Applicant Verification',
      subtitle: 'Answer these 20 questions to show you can responsibly refer members into VisaGo™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 241,
          questions: [
            'Explain your understanding of how VisaGo™ works on FirstGo, and how a member benefits by using it.',
            'How would you explain VisaGo\'s dynamic, country-specific document checklist and real-time application tracking to a first-time client?',
            'What factors most affect the turnaround time and success of a visa application for a member using VisaGo™?',
            'What would you check regarding the client\'s destination country, visa type and document readiness before referring a client into VisaGo™?',
            'What questions would you ask a client to see if VisaGo™ suits their travel needs?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 246,
          questions: [
            'What concerns might a client raise about VisaGo™, and how would you address them?',
            'How would you differentiate FirstGo\'s VisaGo™ from using an unaccountable visa agent or applying without expert guidance?',
            'What is your existing network or client base relevant to VisaGo™?',
            'Would you ever promise a client a discount, upgrade or outcome from VisaGo™ that FirstGo hasn\'t confirmed? Why or why not?',
            'What is your plan to start referring clients into VisaGo™ within your first 30 days as a partner?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Process & Documentation',
          startNum: 251,
          questions: [
            'What is the difference between Standard Visa Application Support and Express Visa processing, and how would you explain it to a client?',
            'How would you explain the real-time visa Status Tracking dashboard to an anxious first-time applicant?',
            'What would you check regarding a client\'s destination country and visa type before referring a VisaGo opportunity?',
            'How would you support a client who needs VFS or embassy Appointment Booking assistance?',
            'What would make you decline to refer a particular client into a VisaGo service?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 256,
          questions: [
            'How would you explain the Visa Denial Support and re-application process to a client who was previously refused?',
            'How would you keep a client updated on their visa application status after referral?',
            'What would you tell a client about the VisaGo + Package Bundle auto-triggered checklist for international trips?',
            'How would you handle a client\'s complaint about a VisaGo application delay, and who would you escalate it to?',
            'What is your plan to help a client assemble a complete document checklist for their destination country?',
          ],
        ),
      ],
    ),

    // 14. VisaGo - Institutional
    'q_visago_institutional': FirstGoQuestionnaireData(
      id: 'q_visago_institutional',
      title: 'VisaGo™ — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into VisaGo™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 261,
          questions: [
            'Rate your institution\'s expertise (1–5) in VisaGo™, with brief justification.',
            'Describe your institution\'s process for reviewing a client\'s destination and document readiness before referring a VisaGo opportunity.',
            'What legal and compliance framework does your institution maintain specific to embassy requirement monitoring and visa denial re-application guidance?',
            'What is your institution\'s existing client base or network relevant to VisaGo™?',
            'What is your institution\'s estimated monthly capacity to refer qualified VisaGo™ clients?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Systems & Operations',
          startNum: 266,
          questions: [
            'What technology or systems does your institution use to manage VisaGo™ referrals and records?',
            'How would your institution integrate VisaGo™ referrals into its existing workflows?',
            'What training or resources would your institution need to represent VisaGo™ effectively?',
            'How does your institution ensure compliance with FirstGo\'s Code of Conduct when referring VisaGo™ clients?',
            'What risks specific to VisaGo™ does your institution watch for, and how are they mitigated?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 271,
          questions: [
            'What internal criteria does your institution apply before referring a client into a VisaGo service?',
            'How does your institution verify a client\'s destination country and document readiness before submitting a referral?',
            'What role does your institution play in tracking embassy requirement changes for referred clients?',
            'How does your institution handle a referral requiring Express Visa priority processing?',
            'What process does your institution follow if a referred client\'s visa application is denied?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 276,
          questions: [
            'How does your institution verify document checklists are current before recommending them to a client?',
            'What reporting does your institution require from FirstGo on referred VisaGo applications?',
            'How does your institution handle a dispute raised by a referred client about a visa delay?',
            'What service-level expectations does your institution set for VisaGo referrals?',
            'How does your institution measure the success of clients referred into VisaGo?',
          ],
        ),
      ],
    ),

    // 15. GoVault - Individual
    'q_govault_individual': FirstGoQuestionnaireData(
      id: 'q_govault_individual',
      title: 'GoVault™ — Individual Applicant Verification',
      subtitle: 'Answer these 20 questions to show you can responsibly refer members into GoVault™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 281,
          questions: [
            'Explain your understanding of how GoVault™ works on FirstGo, and how a member benefits by using it.',
            'How would you explain the FirstGo Pass tiers, SkyCoins earning system, and the Save-to-Travel micro-savings scheme to a first-time client?',
            'What factors most affect how quickly a member reaches their savings goal or earns meaningful rewards for a member using GoVault™?',
            'What would you check regarding the client\'s savings capacity and whether Save-to-Travel or a direct Pass purchase suits them better before referring a client into GoVault™?',
            'What questions would you ask a client to see if GoVault™ suits their travel needs?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 286,
          questions: [
            'What concerns might a client raise about GoVault™, and how would you address them?',
            'How would you differentiate FirstGo\'s GoVault™ from an informal savings scheme or no structured travel fund at all?',
            'What is your existing network or client base relevant to GoVault™?',
            'Would you ever promise a client a discount, upgrade or outcome from GoVault™ that FirstGo hasn\'t confirmed? Why or why not?',
            'What is your plan to start referring clients into GoVault™ within your first 30 days as a partner?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Process & Documentation',
          startNum: 291,
          questions: [
            'What is the difference between the Explorer, Pioneer, and Voyager FirstGo Pass tiers, and how would you explain it to a client?',
            'How would you explain the SkyCoins scratch card reward system to a client considering a referral?',
            'What would you check regarding a client\'s saving capacity before setting up a Save-to-Travel goal?',
            'How would you support a client who wants to pause their Save-to-Travel contributions for up to 3 months?',
            'What would make you decline to refer a particular client into GoVault?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 296,
          questions: [
            'How would you explain the 4% per annum interest credited on GoVault savings to a client?',
            'How would you keep a client updated on their Save-to-Travel goal progress after referral?',
            'What would you tell a client about SkyCoins expiry (18 months) and the reminder alerts sent before expiry?',
            'How would you handle a client\'s complaint about their GoVault balance or a scratch card issue, and who would you escalate it to?',
            'What is your plan to help a client pick a realistic trip goal and daily/monthly saving amount?',
          ],
        ),
      ],
    ),

    // 16. GoVault - Institutional
    'q_govault_institutional': FirstGoQuestionnaireData(
      id: 'q_govault_institutional',
      title: 'GoVault™ — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into GoVault™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 301,
          questions: [
            'Rate your institution\'s expertise (1–5) in GoVault™, with brief justification.',
            'Describe your institution\'s process for assessing a client\'s savings goals and membership tier fit before referring a GoVault opportunity.',
            'What legal and compliance framework does your institution maintain specific to GoVault fund ring-fencing, interest crediting and membership tier disclosure?',
            'What is your institution\'s existing client base or network relevant to GoVault™?',
            'What is your institution\'s estimated monthly capacity to refer qualified GoVault™ clients?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Systems & Operations',
          startNum: 306,
          questions: [
            'What technology or systems does your institution use to manage GoVault™ referrals and records?',
            'How would your institution integrate GoVault™ referrals into its existing workflows?',
            'What training or resources would your institution need to represent GoVault™ effectively?',
            'How does your institution ensure compliance with FirstGo\'s Code of Conduct when referring GoVault™ clients?',
            'What risks specific to GoVault™ does your institution watch for, and how are they mitigated?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 311,
          questions: [
            'What internal criteria does your institution apply before referring a client into GoVault?',
            'How does your institution verify a client\'s savings capacity before recommending a Save-to-Travel goal?',
            'What role does your institution play in explaining FirstGo Pass tier benefits to referred clients?',
            'How does your institution handle a referral for a family account linking multiple sub-accounts?',
            'What process does your institution follow if a referred client wants to pause or exit Save-to-Travel?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 316,
          questions: [
            'How does your institution verify GoVault fund ring-fencing and interest-crediting terms before recommending them?',
            'What reporting does your institution require from FirstGo on referred GoVault accounts?',
            'How does your institution handle a dispute raised by a referred client about their GoVault balance?',
            'What service-level expectations does your institution set for GoVault referrals?',
            'How does your institution measure the success of clients referred into GoVault?',
          ],
        ),
      ],
    ),

    // 17. StayHour - Individual
    'q_stayhour_individual': FirstGoQuestionnaireData(
      id: 'q_stayhour_individual',
      title: 'StayHour™ — Individual Applicant Verification',
      subtitle: 'Answer these 20 questions to show you can responsibly refer members into StayHour™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 321,
          questions: [
            'Explain your understanding of how StayHour™ works on FirstGo, and how a member benefits by using it.',
            'How would you explain StayHour\'s flexible 2–12 hour duration booking and transparent per-hour pricing to a first-time client?',
            'What factors most affect the price and property quality of an hourly stay for a member using StayHour™?',
            'What would you check regarding the minimum stay duration, amenity access and hotel StayHour badge status before referring a client into StayHour™?',
            'What questions would you ask a client to see if StayHour™ suits their travel needs?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 326,
          questions: [
            'What concerns might a client raise about StayHour™, and how would you address them?',
            'How would you differentiate FirstGo\'s StayHour™ from a full overnight hotel booking when the client only needs a few hours?',
            'What is your existing network or client base relevant to StayHour™?',
            'Would you ever promise a client a discount, upgrade or outcome from StayHour™ that FirstGo hasn\'t confirmed? Why or why not?',
            'What is your plan to start referring clients into StayHour™ within your first 30 days as a partner?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Process & Documentation',
          startNum: 331,
          questions: [
            'What is the minimum booking duration for a StayHour stay, and how would you explain it to a client?',
            'How would you explain the Corporate Day-Office Package (room + WiFi + F&B) to a business client?',
            'What would you check regarding a hotel\'s StayHour badge and amenity access before referring a client?',
            'How would you support a client who wants a Couple Day-Use Package at a boutique property?',
            'What would make you decline to refer a particular client into a StayHour booking?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 336,
          questions: [
            'How would you explain the Self Check-In option at smart-lock properties versus front-desk check-in?',
            'How would you keep a client updated on their StayHour booking after referral?',
            'What would you tell a client about add-on packages like breakfast tray, wellness treatment, or business setup?',
            'How would you handle a client\'s complaint about a StayHour booking, and who would you escalate it to?',
            'What is your plan to help a client find the right property near an airport, station, or business district?',
          ],
        ),
      ],
    ),

    // 18. StayHour - Institutional
    'q_stayhour_institutional': FirstGoQuestionnaireData(
      id: 'q_stayhour_institutional',
      title: 'StayHour™ — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into StayHour™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 341,
          questions: [
            'Rate your institution\'s expertise (1–5) in StayHour™, with brief justification.',
            'Describe your institution\'s process for assessing a client\'s short-stay or layover needs before referring a StayHour opportunity.',
            'What legal and compliance framework does your institution maintain specific to hourly inventory ring-fencing and the 70–80% hotel revenue-share model?',
            'What is your institution\'s existing client base or network relevant to StayHour™?',
            'What is your institution\'s estimated monthly capacity to refer qualified StayHour™ clients?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Systems & Operations',
          startNum: 346,
          questions: [
            'What technology or systems does your institution use to manage StayHour™ referrals and records?',
            'How would your institution integrate StayHour™ referrals into its existing workflows?',
            'What training or resources would your institution need to represent StayHour™ effectively?',
            'How does your institution ensure compliance with FirstGo\'s Code of Conduct when referring StayHour™ clients?',
            'What risks specific to StayHour™ does your institution watch for, and how are they mitigated?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 351,
          questions: [
            'What internal criteria does your institution apply before referring a client into a StayHour booking?',
            'How does your institution verify a hotel\'s StayHour badge and quality standards before submitting a referral?',
            'What role does your institution play in explaining the hourly pricing structure to referred clients?',
            'How does your institution handle a Corporate Team Day group referral?',
            'What process does your institution follow if a referred client\'s hourly booking has a check-in issue?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 356,
          questions: [
            'How does your institution verify amenity-access details are accurate before recommending a property?',
            'What reporting does your institution require from FirstGo on referred StayHour bookings?',
            'How does your institution handle a dispute raised by a referred client about a StayHour stay?',
            'What service-level expectations does your institution set for StayHour referrals?',
            'How does your institution measure the success of clients referred into StayHour?',
          ],
        ),
      ],
    ),

    // 19. VillageFirst - Individual
    'q_villagefirst_individual': FirstGoQuestionnaireData(
      id: 'q_villagefirst_individual',
      title: 'VillageFirst™ — Individual Applicant Verification',
      subtitle: 'Answer these 20 questions to show you can responsibly refer members into VillageFirst™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 361,
          questions: [
            'Explain your understanding of how VillageFirst™ works on FirstGo, and how a member benefits by using it.',
            'How would you explain VillageFirst\'s cultural interpreter services and Responsible Rural Tourism certification to a first-time client?',
            'What factors most affect the authenticity and safety of a village immersion experience for a member using VillageFirst™?',
            'What would you check regarding the client\'s language needs, safety protocols and photography-etiquette briefing before referring a client into VillageFirst™?',
            'What questions would you ask a client to see if VillageFirst™ suits their travel needs?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 366,
          questions: [
            'What concerns might a client raise about VillageFirst™, and how would you address them?',
            'How would you differentiate FirstGo\'s VillageFirst™ from an unstructured village visit with no vetted host, interpreter or safety protocol?',
            'What is your existing network or client base relevant to VillageFirst™?',
            'Would you ever promise a client a discount, upgrade or outcome from VillageFirst™ that FirstGo hasn\'t confirmed? Why or why not?',
            'What is your plan to start referring clients into VillageFirst™ within your first 30 days as a partner?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Process & Documentation',
          startNum: 371,
          questions: [
            'What is the difference between a Village Day Experience and a Village Week Discovery package, and how would you explain it to a client?',
            'How would you explain the Pre-Arrival Cultural Orientation guide to an international client before travel?',
            'What would you check regarding a client\'s language needs and any health/safety considerations before referring?',
            'How would you support a corporate client interested in a CSR team-building village immersion programme?',
            'What would make you decline to refer a particular client into a VillageFirst experience?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 376,
          questions: [
            'How would you explain the Photography Etiquette and consent protocols to a client planning to document their trip?',
            'How would you keep an international client updated on their VillageFirst booking after referral?',
            'What would you tell a client about the Responsible Tourism Certification behind every VillageFirst destination?',
            'How would you handle a client\'s complaint about a VillageFirst experience, and who would you escalate it to?',
            'What is your plan to help an international client choose between the Rajasthan, Kerala, Nagaland, or Punjab village circuits?',
          ],
        ),
      ],
    ),

    // 20. VillageFirst - Institutional
    'q_villagefirst_institutional': FirstGoQuestionnaireData(
      id: 'q_villagefirst_institutional',
      title: 'VillageFirst™ — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into VillageFirst™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 381,
          questions: [
            'Rate your institution\'s expertise (1–5) in VillageFirst™, with brief justification.',
            'Describe your institution\'s process for verifying an international client\'s language needs and safety requirements before referring a VillageFirst opportunity.',
            'What legal and compliance framework does your institution maintain specific to Responsible Rural Tourism certification and community benefit-sharing protocols?',
            'What is your institution\'s existing client base or network relevant to VillageFirst™?',
            'What is your institution\'s estimated monthly capacity to refer qualified VillageFirst™ clients?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Systems & Operations',
          startNum: 386,
          questions: [
            'What technology or systems does your institution use to manage VillageFirst™ referrals and records?',
            'How would your institution integrate VillageFirst™ referrals into its existing workflows?',
            'What training or resources would your institution need to represent VillageFirst™ effectively?',
            'How does your institution ensure compliance with FirstGo\'s Code of Conduct when referring VillageFirst™ clients?',
            'What risks specific to VillageFirst™ does your institution watch for, and how are they mitigated?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 391,
          questions: [
            'What internal criteria does your institution apply before referring a client into a VillageFirst experience?',
            'How does your institution verify a village host community\'s safety and cultural-sensitivity vetting before submitting a referral?',
            'What role does your institution play in briefing international clients on cultural orientation and etiquette?',
            'How does your institution handle a referral for an international school or university group?',
            'What process does your institution follow if a referred client raises a safety concern in a remote village location?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 396,
          questions: [
            'How does your institution verify Responsible Rural Tourism certification before recommending a destination?',
            'What reporting does your institution require from FirstGo on referred VillageFirst bookings?',
            'How does your institution handle a dispute raised by a referred client about a village experience?',
            'What service-level expectations does your institution set for VillageFirst referrals?',
            'How does your institution measure the success of clients referred into VillageFirst?',
          ],
        ),
      ],
    ),

    // 21. HarvestPath - Individual
    'q_harvestpath_individual': FirstGoQuestionnaireData(
      id: 'q_harvestpath_individual',
      title: 'HarvestPath™ — Individual Applicant Verification',
      subtitle: 'Answer these 20 questions to show you can responsibly refer members into HarvestPath™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 401,
          questions: [
            'Explain your understanding of how HarvestPath™ works on FirstGo, and how a member benefits by using it.',
            'How would you explain HarvestPath\'s seasonal activity calendar and hands-on farm participation model to a first-time client?',
            'What factors most affect the seasonal fit and activity level of an agro-tourism experience for a member using HarvestPath™?',
            'What would you check regarding the farm\'s organic/biodynamic certification and the season\'s activity calendar before referring a client into HarvestPath™?',
            'What questions would you ask a client to see if HarvestPath™ suits their travel needs?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 406,
          questions: [
            'What concerns might a client raise about HarvestPath™, and how would you address them?',
            'How would you differentiate FirstGo\'s HarvestPath™ from an unverified rural farm visit with no certified host or seasonal planning?',
            'What is your existing network or client base relevant to HarvestPath™?',
            'Would you ever promise a client a discount, upgrade or outcome from HarvestPath™ that FirstGo hasn\'t confirmed? Why or why not?',
            'What is your plan to start referring clients into HarvestPath™ within your first 30 days as a partner?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Process & Documentation',
          startNum: 411,
          questions: [
            'What is the difference between an Agro Day Tour and a Tea/Coffee Plantation Week package, and how would you explain it to a client?',
            'How would you explain the Seasonal Activity Calendar (harvests, sowings, festivals) to a client planning their trip timing?',
            'What would you check regarding a farm\'s organic/biodynamic certification before referring a client?',
            'How would you support a school or educational group interested in the curriculum-aligned HarvestPath module?',
            'What would make you decline to refer a particular client into a HarvestPath tour?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 416,
          questions: [
            'How would you explain the Farm-to-Table dining inclusion to a client curious about the experience?',
            'How would you keep a client updated on their HarvestPath booking after referral?',
            'What would you tell a client about purchasing farm products (spices, oils, teas) directly through the app?',
            'How would you handle a client\'s complaint about a HarvestPath tour, and who would you escalate it to?',
            'What is your plan to help a client pick the right season and region for their agro-tourism interest?',
          ],
        ),
      ],
    ),

    // 22. HarvestPath - Institutional
    'q_harvestpath_institutional': FirstGoQuestionnaireData(
      id: 'q_harvestpath_institutional',
      title: 'HarvestPath™ — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into HarvestPath™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 421,
          questions: [
            'Rate your institution\'s expertise (1–5) in HarvestPath™, with brief justification.',
            'Describe your institution\'s process for checking a client\'s preferred season and activity level before referring a HarvestPath opportunity.',
            'What legal and compliance framework does your institution maintain specific to farm/host certification standards and seasonal activity calendar accuracy?',
            'What is your institution\'s existing client base or network relevant to HarvestPath™?',
            'What is your institution\'s estimated monthly capacity to refer qualified HarvestPath™ clients?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Systems & Operations',
          startNum: 426,
          questions: [
            'What technology or systems does your institution use to manage HarvestPath™ referrals and records?',
            'How would your institution integrate HarvestPath™ referrals into its existing workflows?',
            'What training or resources would your institution need to represent HarvestPath™ effectively?',
            'How does your institution ensure compliance with FirstGo\'s Code of Conduct when referring HarvestPath™ clients?',
            'What risks specific to HarvestPath™ does your institution watch for, and how are they mitigated?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 431,
          questions: [
            'What internal criteria does your institution apply before referring a client into a HarvestPath tour?',
            'How does your institution verify a farm host\'s certification and seasonal availability before submitting a referral?',
            'What role does your institution play in matching a client\'s activity-level preference to the right farm experience?',
            'How does your institution handle a referral for a school or agricultural-education group?',
            'What process does your institution follow if a referred client\'s seasonal activity is unavailable on arrival?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 436,
          questions: [
            'How does your institution verify organic/biodynamic certification claims before recommending a farm?',
            'What reporting does your institution require from FirstGo on referred HarvestPath bookings?',
            'How does your institution handle a dispute raised by a referred client about a HarvestPath experience?',
            'What service-level expectations does your institution set for HarvestPath referrals?',
            'How does your institution measure the success of clients referred into HarvestPath?',
          ],
        ),
      ],
    ),

    // 23. CraftLegacy - Individual
    'q_craftlegacy_individual': FirstGoQuestionnaireData(
      id: 'q_craftlegacy_individual',
      title: 'CraftLegacy™ — Individual Applicant Verification',
      subtitle: 'Answer these 20 questions to show you can responsibly refer members into CraftLegacy™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Understanding & Client Fit',
          startNum: 441,
          questions: [
            'Explain your understanding of how CraftLegacy™ works on FirstGo, and how a member benefits by using it.',
            'How would you explain CraftLegacy\'s GI product directory and purchase authentication certificate process to a first-time client?',
            'What factors most affect the authenticity and value of a GI craft tour or purchase for a member using CraftLegacy™?',
            'What would you check regarding the artisan\'s GI certification status and the tour\'s purchase authentication process before referring a client into CraftLegacy™?',
            'What questions would you ask a client to see if CraftLegacy™ suits their travel needs?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Eligibility & Positioning',
          startNum: 446,
          questions: [
            'What concerns might a client raise about CraftLegacy™, and how would you address them?',
            'How would you differentiate FirstGo\'s CraftLegacy™ from buying craft souvenirs from an unverified market stall with no GI authentication?',
            'What is your existing network or client base relevant to CraftLegacy™?',
            'Would you ever promise a client a discount, upgrade or outcome from CraftLegacy™ that FirstGo hasn\'t confirmed? Why or why not?',
            'What is your plan to start referring clients into CraftLegacy™ within your first 30 days as a partner?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Process & Documentation',
          startNum: 451,
          questions: [
            'What is the difference between a Craft Day Workshop and the GI Grand Circuit — National package, and how would you explain it to a client?',
            'How would you explain the Certificate of Authenticity that comes with every GI craft purchase?',
            'What would you check regarding an artisan\'s GI certification and workshop availability before referring a client?',
            'How would you support a design professional or fashion buyer interested in the Design Professional Programme?',
            'What would make you decline to refer a particular client into a CraftLegacy tour?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Support & Ongoing Care',
          startNum: 456,
          questions: [
            'How would you explain the difference between an authentic GI-certified product and an uncertified souvenir to a client?',
            'How would you keep a client updated on their CraftLegacy booking after referral?',
            'What would you tell a client about the Customisation Studio option for commissioning personalised pieces?',
            'How would you handle a client\'s complaint about a CraftLegacy purchase or tour, and who would you escalate it to?',
            'What is your plan to help a client choose the right GI craft circuit (Varanasi silk, Madhubani art, Blue Pottery, Pashmina) for their interest?',
          ],
        ),
      ],
    ),

    // 24. CraftLegacy - Institutional
    'q_craftlegacy_institutional': FirstGoQuestionnaireData(
      id: 'q_craftlegacy_institutional',
      title: 'CraftLegacy™ — Institutional Applicant Verification',
      subtitle: 'Establish your organization\'s expertise, systems and accountability for referring members into CraftLegacy™.',
      categories: [
        FirstGoQuestionCategory(
          name: 'Expertise & Compliance Framework',
          startNum: 461,
          questions: [
            'Rate your institution\'s expertise (1–5) in CraftLegacy™, with brief justification.',
            'Describe your institution\'s process for verifying a client\'s craft interests and matching them to GI-certified artisan experiences before referring.',
            'What legal and compliance framework does your institution maintain specific to GI certification standards and purchase authentication documentation?',
            'What is your institution\'s existing client base or network relevant to CraftLegacy™?',
            'What is your institution\'s estimated monthly capacity to refer qualified CraftLegacy™ clients?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Systems & Operations',
          startNum: 466,
          questions: [
            'What technology or systems does your institution use to manage CraftLegacy™ referrals and records?',
            'How would your institution integrate CraftLegacy™ referrals into its existing workflows?',
            'What training or resources would your institution need to represent CraftLegacy™ effectively?',
            'How does your institution ensure compliance with FirstGo\'s Code of Conduct when referring CraftLegacy™ clients?',
            'What risks specific to CraftLegacy™ does your institution watch for, and how are they mitigated?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Diligence & Risk',
          startNum: 471,
          questions: [
            'What internal criteria does your institution apply before referring a client into a CraftLegacy tour?',
            'How does your institution verify an artisan\'s GI certification and workshop availability before submitting a referral?',
            'What role does your institution play in explaining purchase authentication to referred clients?',
            'How does your institution handle a referral for a design professional or museum curator?',
            'What process does your institution follow if a referred client questions the authenticity of a purchased craft item?',
          ],
        ),
        FirstGoQuestionCategory(
          name: 'Reporting & Accountability',
          startNum: 476,
          questions: [
            'How does your institution verify GI Registry partnership standards before recommending an artisan experience?',
            'What reporting does your institution require from FirstGo on referred CraftLegacy bookings?',
            'How does your institution handle a dispute raised by a referred client about a CraftLegacy purchase?',
            'What service-level expectations does your institution set for CraftLegacy referrals?',
            'How does your institution measure the success of clients referred into CraftLegacy?',
          ],
        ),
      ],
    ),
  };
}

class FirstGoStayDemoApplicantData {
  static const Map<String, dynamic> sample = {
    'udyamiMember': 'Yes',
    'memberId': '123123',
    'fullName': 'Rohan Mehta',
    'dob': '1990-09-14',
    'gender': 'Male',
    'fatherHusbandName': 'Ashok Mehta',
    'maritalStatus': 'Married',
    'bloodGroup': 'B+',
    'nationality': 'Indian',
    'languages': 'Hindi, English, Marathi',
    'mobile': '9822334455',
    'altMobile': '',
    'email': 'rohan.mehta@example.test',
    'occupation': 'Travel agent',
    'houseStreetVillage': '15, Church Road, Bandra West',
    'taluk': 'Mumbai Suburban',
    'district': 'Mumbai',
    'stateName': 'Maharashtra',
    'pin': '400050',
    'ward': 'Bandra Ward',
    'yearsLivedHere': '9',
    'homeType': 'Own',
    'landmark': 'Near Bandra Bandstand',
    'aadhaarNumber': '456789012345',
    'aadhaarMobile': '9822334455',
    'aadhaarName': 'Rohan Mehta',
    'aadhaarConsent': true,
    'businessType': 'institutional',
    'businessName': 'Mehta Travels & Tours',
    'typeOfBusiness': 'Proprietorship',
    'startedOn': '2014-03-01',
    'businessPan': '',
    'tan': '',
    'gstNumber': '27ABCDE1234F1Z5',
    'udyamNumber': 'UDYAM-MH-01-1234567',
    'tradeLicence': '',
    'hasExperience': true,
    'whereWorked': 'Mehta Travels & Tours',
    'role': 'Founder / Travel Consultant',
    'howLong': '2014–2026',
    'whatYouDid': 'Booked domestic and international holiday packages, coordinated visa documentation and managed a small team of travel counsellors.',
    'yearsExperience': '12',
    'highestQualification': 'B.Com',
    'toolsKnown': 'GDS booking systems, visa portals, UPI Autopay',
    'familiarityChecklist': [
      'I know my way around KYC / AML basics',
      "I've explained investment products to clients before"
    ],
    'fieldSector': '',
    'businessOrEmployer': '',
    'otherHowLong': '',
    'otherWhatYouDid': '',
    'workAddress': '15, Church Road, Bandra West, Mumbai',
    'ownership': 'Owned',
    'workLandmark': 'Bandra Bandstand',
    'wardAreaServe': 'Bandra Ward',
    'villagesCovered': 'Bandra, Khar, Santacruz',
    'workFacilities': [
      'Private area for clients to discuss their investments',
      'Secure, lockable place to store paperwork',
      'Internet access to log leads and savers',
      'Computer, scanner and printer on site',
      'Familiar with One Core KYC / onboarding process'
    ],
    'accountHolderName': 'Rohan Mehta',
    'accountType': 'Current',
    'accountNumber': 'XXXXXX7788',
    'ifsc': 'HDFC0002233',
    'bankBranch': 'Bandra Branch',
    'nomineeName': 'Anjali Mehta',
    'relationship': 'Spouse',
    'nomineeMobile': '9822011223',
    'nomineeAccountNumber': 'XXXXXX4499',
    'nomineeIfsc': 'HDFC0002233',
    'nomineeBankBranch': 'Bandra Branch',
    'services': ['nestfirst', 'skyfirst', 'govault'],
    'wardArea': 'Bandra Ward',
    'newSaversPerMonth': '25',
    'hireSupportStaff': 'Yes',
    'bestTimeTraining': 'Weekdays',
    'smartphone': 'Both',
    'comfortApps': 'Very Comfortable',
    'usedAppsForInvestments': 'Yes, Regularly',
    'comfortPayments': 'Very Comfortable',
    'langComm': [
      "I'm comfortable using the Partner app already",
      'I can talk to clients in English'
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
    'place': 'Mumbai',
    'date8': '2026-08-31',
    'depositAck1': true,
    'depositAck2': true,
    'signed': true,
    'thumbImpression': false,
  };
}
