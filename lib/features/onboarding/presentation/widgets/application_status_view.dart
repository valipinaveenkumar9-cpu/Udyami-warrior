import 'package:flutter/material.dart';

/// Company-specific brand themes for the Application Status screen.
class CompanyStatusTheme {
  final String companyName;
  final String companySubtitle;
  final Color primaryColor;
  final Color primaryDarkColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color cardColor;
  final Color textColor;
  final Color subtitleColor;
  final Color lineColor;
  final IconData companyIcon;
  final String? logoEmoji;

  const CompanyStatusTheme({
    required this.companyName,
    this.companySubtitle = 'Warrior Channel Partner',
    required this.primaryColor,
    required this.primaryDarkColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.cardColor,
    this.textColor = const Color(0xFF1E2A44),
    this.subtitleColor = const Color(0xFF64748B),
    this.lineColor = const Color(0xFFCBD5E1),
    required this.companyIcon,
    this.logoEmoji,
  });

  /// CloudPatra: Cerulean Sky Blue & Deep Teal
  factory CompanyStatusTheme.cloudPatra() {
    return const CompanyStatusTheme(
      companyName: 'CloudPatra',
      companySubtitle: 'Cloud Infrastructure Channel Partner',
      primaryColor: Color(0xFF0284C7), // Sky Blue
      primaryDarkColor: Color(0xFF0369A1),
      accentColor: Color(0xFFA9791F), // Gold
      backgroundColor: Color(0xFFF0F9FF),
      cardColor: Color(0xFFFFFFFF),
      textColor: Color(0xFF0F172A),
      subtitleColor: Color(0xFF64748B),
      lineColor: Color(0xFFBAE6FD),
      companyIcon: Icons.cloud_done_rounded,
      logoEmoji: '☁️',
    );
  }

  /// Ownify: Harvest Green & Warm Amber
  factory CompanyStatusTheme.ownify() {
    return const CompanyStatusTheme(
      companyName: 'Ownify',
      companySubtitle: 'Agri & Land Channel Partner',
      primaryColor: Color(0xFF15803D), // Forest / Harvest Green
      primaryDarkColor: Color(0xFF166534),
      accentColor: Color(0xFFD97706), // Amber
      backgroundColor: Color(0xFFFDFBF7),
      cardColor: Color(0xFFFFFFFF),
      textColor: Color(0xFF1C1917),
      subtitleColor: Color(0xFF78716C),
      lineColor: Color(0xFFE7E5E4),
      companyIcon: Icons.agriculture_rounded,
      logoEmoji: '🌾',
    );
  }

  /// BhoomiVault: Terracotta Rust & Earth Gold
  factory CompanyStatusTheme.bhoomiVault() {
    return const CompanyStatusTheme(
      companyName: 'BhoomiVault',
      companySubtitle: 'Liaisoning & Procurement Channel Partner',
      primaryColor: Color(0xFF9A3412), // Terracotta Rust
      primaryDarkColor: Color(0xFF7C2D12),
      accentColor: Color(0xFFD97706), // Gold Ochre
      backgroundColor: Color(0xFFFFFBEB),
      cardColor: Color(0xFFFFFFFF),
      textColor: Color(0xFF1C1917),
      subtitleColor: Color(0xFF78716C),
      lineColor: Color(0xFFFED7AA),
      companyIcon: Icons.apartment_rounded,
      logoEmoji: '🏢',
    );
  }

  /// Build AI Homes: Modern Tech Indigo & Cyan
  factory CompanyStatusTheme.buildAiHomes() {
    return const CompanyStatusTheme(
      companyName: 'Build AI Homes',
      companySubtitle: 'AI Construction & Architecture Partner',
      primaryColor: Color(0xFF4F46E5), // Indigo
      primaryDarkColor: Color(0xFF3730A3),
      accentColor: Color(0xFF06B6D4), // Cyan
      backgroundColor: Color(0xFFEEF2FF),
      cardColor: Color(0xFFFFFFFF),
      textColor: Color(0xFF1E1B4B),
      subtitleColor: Color(0xFF6B7280),
      lineColor: Color(0xFFC7D2FE),
      companyIcon: Icons.home_work_rounded,
      logoEmoji: '🏡',
    );
  }

  /// Yuva Udyami: Vibrant Royal Purple & Sunset Coral
  factory CompanyStatusTheme.yuvaUdyami() {
    return const CompanyStatusTheme(
      companyName: 'Yuva Udyami',
      companySubtitle: 'Youth Entrepreneurship Channel Partner',
      primaryColor: Color(0xFF7C3AED), // Royal Purple
      primaryDarkColor: Color(0xFF5B21B6),
      accentColor: Color(0xFFF43F5E), // Coral
      backgroundColor: Color(0xFFFAF5FF),
      cardColor: Color(0xFFFFFFFF),
      textColor: Color(0xFF2E1065),
      subtitleColor: Color(0xFF6B7280),
      lineColor: Color(0xFFDDD6FE),
      companyIcon: Icons.school_rounded,
      logoEmoji: '🎓',
    );
  }

  /// First Choice Bank: Executive Navy Blue & Gold
  factory CompanyStatusTheme.firstChoiceBank() {
    return const CompanyStatusTheme(
      companyName: 'First Choice Bank',
      companySubtitle: 'Banking & Finance Channel Partner',
      primaryColor: Color(0xFF1E3A8A), // Navy Blue
      primaryDarkColor: Color(0xFF172554),
      accentColor: Color(0xFFCA8A04), // Gold
      backgroundColor: Color(0xFFF8FAFC),
      cardColor: Color(0xFFFFFFFF),
      textColor: Color(0xFF0F172A),
      subtitleColor: Color(0xFF64748B),
      lineColor: Color(0xFFCBD5E1),
      companyIcon: Icons.account_balance_rounded,
      logoEmoji: '🏦',
    );
  }

  /// First Go Stay: Seal Heritage Green & Antique Gold
  factory CompanyStatusTheme.firstGoStay() {
    return const CompanyStatusTheme(
      companyName: 'First Go Stay',
      companySubtitle: 'Hospitality & Stay Channel Partner',
      primaryColor: Color(0xFF0E5C4A), // Seal Green
      primaryDarkColor: Color(0xFF0A4438),
      accentColor: Color(0xFFA9791F), // Gold
      backgroundColor: Color(0xFFF3EEDD), // Paper
      cardColor: Color(0xFFFBF8EE), // Paper Alt
      textColor: Color(0xFF1E2A44), // Ink
      subtitleColor: Color(0xFF7A7360), // Muted
      lineColor: Color(0xFFD9D0B8), // Line
      companyIcon: Icons.hotel_rounded,
      logoEmoji: '🏨',
    );
  }

  /// Factory helper that automatically detects the company theme by name.
  factory CompanyStatusTheme.fromCompanyName(String? name) {
    final lower = (name ?? '').toLowerCase().trim();
    if (lower.contains('cloud') || lower.contains('patra')) {
      return CompanyStatusTheme.cloudPatra();
    } else if (lower.contains('ownify')) {
      return CompanyStatusTheme.ownify();
    } else if (lower.contains('bhoomi') || lower.contains('vault')) {
      return CompanyStatusTheme.bhoomiVault();
    } else if (lower.contains('build ai') || lower.contains('build_ai') || lower.contains('buildai')) {
      return CompanyStatusTheme.buildAiHomes();
    } else if (lower.contains('yuva') || lower.contains('udyami')) {
      return CompanyStatusTheme.yuvaUdyami();
    } else if (lower.contains('first choice') || lower.contains('firstchoice') || lower.contains('bank')) {
      return CompanyStatusTheme.firstChoiceBank();
    } else if (lower.contains('first go') || lower.contains('firstgo') || lower.contains('stay')) {
      return CompanyStatusTheme.firstGoStay();
    }
    return CompanyStatusTheme.cloudPatra();
  }
}

/// A stage item in the vertical application progress timeline.
class ApplicationStageItem {
  final String key;
  final String name;
  final String shortDescription;
  final String completedComment;
  final String currentComment;
  final String pendingComment;
  final IconData icon;

  const ApplicationStageItem({
    required this.key,
    required this.name,
    required this.shortDescription,
    required this.completedComment,
    required this.currentComment,
    required this.pendingComment,
    required this.icon,
  });
}

/// The 6 sequential stages required for all Warrior applications:
/// Submitted -> Under Review -> Interrogation -> Training -> Completed -> Active
const List<ApplicationStageItem> kApplicationStages = [
  ApplicationStageItem(
    key: 'submitted',
    name: 'Submitted',
    shortDescription: 'Application submitted successfully',
    completedComment: 'Completed – Application submitted successfully',
    currentComment: 'Completed – Application submitted successfully',
    pendingComment: 'Pending – Please submit your application',
    icon: Icons.send_rounded,
  ),
  ApplicationStageItem(
    key: 'review',
    name: 'Under Review',
    shortDescription: 'Application is being reviewed',
    completedComment: 'Completed – Application review passed',
    currentComment: 'Pending – Application is under review',
    pendingComment: 'Pending – Awaiting application review',
    icon: Icons.search_rounded,
  ),
  ApplicationStageItem(
    key: 'interrogation',
    name: 'Interrogation',
    shortDescription: 'Interview scheduled',
    completedComment: 'Completed – Interrogation & verification cleared',
    currentComment: 'Pending – Please complete the interrogation',
    pendingComment: 'Pending – Interrogation pending',
    icon: Icons.record_voice_over_rounded,
  ),
  ApplicationStageItem(
    key: 'training',
    name: 'Training',
    shortDescription: 'Training is in progress',
    completedComment: 'Completed – Training modules finished',
    currentComment: 'Pending – Please complete your training.',
    pendingComment: 'Pending – Training pending',
    icon: Icons.model_training_rounded,
  ),
  ApplicationStageItem(
    key: 'completed',
    name: 'Completed',
    shortDescription: 'Training completed',
    completedComment: 'Completed – All certification criteria verified',
    currentComment: 'Pending – Training completion pending',
    pendingComment: 'Pending – Training completion pending',
    icon: Icons.verified_rounded,
  ),
  ApplicationStageItem(
    key: 'active',
    name: 'Active',
    shortDescription: 'Application is active',
    completedComment: 'Active – You are an active Warrior partner!',
    currentComment: 'Pending – Awaiting final account activation',
    pendingComment: 'Pending – Awaiting final account activation',
    icon: Icons.check_circle_rounded,
  ),
];

/// Unified Application Status Screen Component
class ApplicationStatusView extends StatefulWidget {
  final CompanyStatusTheme theme;
  final int initialStageIndex;
  final String? applicantName;
  final String? applicationId;
  final String? wardLocality;
  final VoidCallback? onRestart;
  final ValueChanged<int>? onStageChanged;

  const ApplicationStatusView({
    super.key,
    required this.theme,
    this.initialStageIndex = 1, // Default is "Under Review" right after submission
    this.applicantName,
    this.applicationId,
    this.wardLocality,
    this.onRestart,
    this.onStageChanged,
  });

  @override
  State<ApplicationStatusView> createState() => _ApplicationStatusViewState();
}

class _ApplicationStatusViewState extends State<ApplicationStatusView> {
  late int _currentStageIndex;

  @override
  void initState() {
    super.initState();
    _currentStageIndex = widget.initialStageIndex.clamp(0, kApplicationStages.length - 1);
  }

  @override
  void didUpdateWidget(covariant ApplicationStatusView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialStageIndex != widget.initialStageIndex) {
      _currentStageIndex = widget.initialStageIndex.clamp(0, kApplicationStages.length - 1);
    }
  }

  void _setStage(int index) {
    setState(() {
      _currentStageIndex = index.clamp(0, kApplicationStages.length - 1);
    });
    widget.onStageChanged?.call(_currentStageIndex);
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final activeStage = kApplicationStages[_currentStageIndex];

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            _buildTopBar(theme),

            // Main Scrollable Timeline Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Subtitle & Header Card
                    _buildHeaderCard(theme, activeStage),

                    const SizedBox(height: 20),

                    // Vertical Timeline Column UI
                    _buildVerticalTimeline(theme),

                    const SizedBox(height: 24),

                    // Dynamic Context / Action Card
                    _buildStageActionCard(theme, activeStage),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Demo / Simulator Controls
            _buildDemoBar(theme),
          ],
        ),
      ),
    );
  }

  // --- Top Bar ---
  Widget _buildTopBar(CompanyStatusTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: theme.primaryDarkColor.withValues(alpha: 0.15),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(theme.companyIcon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    theme.companyName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    theme.companySubtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (widget.onRestart != null)
            TextButton.icon(
              onPressed: widget.onRestart,
              icon: const Icon(Icons.restart_alt_rounded, size: 16, color: Colors.white),
              label: const Text(
                'Restart',
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
        ],
      ),
    );
  }

  // --- Header Card with exact Title & Subtitle ---
  Widget _buildHeaderCard(CompanyStatusTheme theme, ApplicationStageItem activeStage) {
    final name = widget.applicantName ?? 'Applicant';
    final appId = widget.applicationId ?? '#WR-${theme.companyName.substring(0, 2).toUpperCase()}-2026';
    final ward = widget.wardLocality ?? 'Registered Ward';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.lineColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title: Application Status
                  Text(
                    'Application Status',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: theme.textColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Subtitle: Track Your Application Progress (Exact requirement)
                  Text(
                    'Track Your Application Progress',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.primaryColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      activeStage.name,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetaItem('Applicant', name, theme),
              _buildMetaItem('Application ID', appId, theme),
              _buildMetaItem('Ward / Area', ward, theme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem(String label, String value, CompanyStatusTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10.5, color: theme.subtitleColor, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: theme.textColor),
        ),
      ],
    );
  }

  // --- Vertical Timeline Column UI ---
  Widget _buildVerticalTimeline(CompanyStatusTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.lineColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: List.generate(kApplicationStages.length, (index) {
          final stage = kApplicationStages[index];
          final isDone = index < _currentStageIndex;
          final isCurrent = index == _currentStageIndex;
          final isPending = index > _currentStageIndex;
          final isLast = index == kApplicationStages.length - 1;

          // Dynamic Comment / Action Message
          final dynamicComment = isDone
              ? stage.completedComment
              : (isCurrent ? stage.currentComment : stage.pendingComment);

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column for Circle Icon + Vertical Line
              Column(
                children: [
                  _buildStatusCircle(theme, isDone: isDone, isCurrent: isCurrent, isPending: isPending),
                  if (!isLast)
                    Container(
                      width: 2.5,
                      height: isCurrent ? 80 : 64,
                      color: isDone ? theme.primaryColor : theme.lineColor,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                ],
              ),
              const SizedBox(width: 14),

              // Column for Stage Details
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
                  padding: isCurrent ? const EdgeInsets.all(12) : const EdgeInsets.symmetric(vertical: 4),
                  decoration: isCurrent
                      ? BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.primaryColor.withValues(alpha: 0.35), width: 1.2),
                        )
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Name and Current / Done Badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              stage.name,
                              style: TextStyle(
                                fontSize: isCurrent ? 15 : 14,
                                fontWeight: (isCurrent || isDone) ? FontWeight.w800 : FontWeight.w600,
                                color: isCurrent
                                    ? theme.primaryColor
                                    : (isDone ? theme.textColor : theme.subtitleColor),
                              ),
                            ),
                          ),
                          if (isCurrent)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'CURRENT',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            )
                          else if (isDone)
                            Text(
                              'Done',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),

                      // Short Description
                      Text(
                        stage.shortDescription,
                        style: TextStyle(
                          fontSize: 12,
                          color: isCurrent ? theme.textColor : theme.subtitleColor,
                          fontWeight: isCurrent ? FontWeight.w500 : FontWeight.normal,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Dynamic Comment / Action Message Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? theme.primaryColor.withValues(alpha: 0.12)
                              : (isDone
                                  ? Colors.green.withValues(alpha: 0.08)
                                  : Colors.grey.withValues(alpha: 0.08)),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isCurrent
                                ? theme.primaryColor.withValues(alpha: 0.3)
                                : (isDone
                                    ? Colors.green.withValues(alpha: 0.25)
                                    : Colors.grey.withValues(alpha: 0.2)),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isDone
                                  ? Icons.check_circle_outline
                                  : (isCurrent ? Icons.info_outline_rounded : Icons.hourglass_empty_rounded),
                              size: 13,
                              color: isCurrent
                                  ? theme.primaryColor
                                  : (isDone ? Colors.green[700] : theme.subtitleColor),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                dynamicComment,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                                  color: isCurrent
                                      ? theme.primaryColor
                                      : (isDone ? Colors.green[800] : theme.subtitleColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // --- Status Circle Indicator ---
  Widget _buildStatusCircle(
    CompanyStatusTheme theme, {
    required bool isDone,
    required bool isCurrent,
    required bool isPending,
  }) {
    if (isDone) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.primaryColor,
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.check, size: 15, color: Colors.white),
        ),
      );
    }

    if (isCurrent) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.primaryColor.withValues(alpha: 0.2),
          border: Border.all(color: theme.primaryColor, width: 2.2),
        ),
        child: Center(
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.primaryColor,
            ),
          ),
        ),
      );
    }

    // Pending
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(color: theme.lineColor, width: 2),
      ),
    );
  }

  // --- Stage-specific Action / Detail Card ---
  Widget _buildStageActionCard(CompanyStatusTheme theme, ApplicationStageItem activeStage) {
    String title;
    String description;
    IconData icon;
    Color iconBg;

    switch (activeStage.key) {
      case 'submitted':
        title = 'Application Received';
        description = 'Your application has been received and forwarded to your Ward Head for document review.';
        icon = Icons.mark_email_read_rounded;
        iconBg = theme.primaryColor;
        break;
      case 'review':
        title = 'Review Underway';
        description = 'Your credentials and business experience are currently being evaluated by the committee.';
        icon = Icons.manage_search_rounded;
        iconBg = theme.primaryColor;
        break;
      case 'interrogation':
        title = 'Ward Meeting & Interrogation';
        description = 'Please visit the Ward Office with your Aadhaar, PAN card, and 2 passport photos for verification.';
        icon = Icons.calendar_month_rounded;
        iconBg = theme.accentColor;
        break;
      case 'training':
        title = 'Warrior Training Modules';
        description = 'Complete the orientation video modules and partner code-of-conduct assessment.';
        icon = Icons.play_lesson_rounded;
        iconBg = theme.primaryColor;
        break;
      case 'completed':
        title = 'Training Completed';
        description = 'All evaluations cleared. Confirm your security deposit to initiate final partner activation.';
        icon = Icons.credit_score_rounded;
        iconBg = Colors.teal;
        break;
      case 'active':
        title = 'Warrior Partner Live!';
        description = 'Congratulations! Your partner account is active. You can now start onboarding customers.';
        icon = Icons.verified_user_rounded;
        iconBg = Colors.green;
        break;
      default:
        title = activeStage.name;
        description = activeStage.shortDescription;
        icon = Icons.info_outline_rounded;
        iconBg = theme.primaryColor;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.lineColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconBg, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: theme.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: theme.subtitleColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Demo Controls at Bottom for Quick Simulation ---
  Widget _buildDemoBar(CompanyStatusTheme theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(top: BorderSide(color: theme.lineColor, width: 1.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'DEMO SIMULATOR · CLICK STAGE TO PREVIEW',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
              color: theme.subtitleColor,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(kApplicationStages.length, (i) {
                final isSelected = _currentStageIndex == i;
                final stage = kApplicationStages[i];
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    onTap: () => _setStage(i),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? theme.primaryColor : theme.backgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? theme.primaryColor : theme.lineColor,
                        ),
                      ),
                      child: Text(
                        stage.name,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.white : theme.textColor,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
