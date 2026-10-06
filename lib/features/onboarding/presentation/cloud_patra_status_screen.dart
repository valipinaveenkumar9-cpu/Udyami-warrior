import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:uk_circle_partners/core/utils/session_manager.dart';
import '../data/cloud_patra_api.dart';
import 'fixed_deposit_screen.dart';

class CloudPatraStatusScreen extends StatefulWidget {
  final Map<String, dynamic> applicationData;
  const CloudPatraStatusScreen({super.key, required this.applicationData});

  @override
  State<CloudPatraStatusScreen> createState() => _CloudPatraStatusScreenState();
}

class _CloudPatraStatusScreenState extends State<CloudPatraStatusScreen> {
  late Map<String, dynamic> _appData;
  List<dynamic> _interviews = [];
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _appData = widget.applicationData;
    _fetchInterviews();
  }

  Future<void> _fetchInterviews() async {
    final applicationId = _appData['applicationId'];
    if (applicationId == null) return;
    final interviews = await CloudPatraApi.getInterviewDetails(applicationId);
    if (interviews != null && mounted) {
      setState(() {
        _interviews = interviews;
      });
    }
  }

  Future<void> _refreshStatus() async {
    final userId = SessionManager.userId;
    if (userId == null) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      final apps = await CloudPatraApi.getMyApplications(userId);
      if (apps != null && apps.isNotEmpty) {
        setState(() {
          _appData = apps.first;
        });
        await _fetchInterviews();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _appData['status'] as String? ?? 'UNKNOWN';
    final appliedTerritory = _appData['appliedTerritory'] ?? 'Unknown Ward';
    final subVerticalName = _appData['subBusinessVertical']?['subVerticalName'] ?? 'Service';
    final dateString = _appData['submittedAt'] ?? _appData['createdAt'];
    String formattedDate = '';
    if (dateString != null) {
      try {
        final parsed = DateTime.parse(dateString).toLocal();
        formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(parsed);
      } catch (e) {
        formattedDate = dateString;
      }
    }

    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      appBar: AppBar(
        title: const Text('Application Status', style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: context.colors.primaryDarkBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_isRefreshing)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshStatus,
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshStatus,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Application Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: context.colors.orangeLight.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.description, color: context.colors.orangeDark),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Cloud Patra Application', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                            const SizedBox(height: 2),
                            Text(subVerticalName, style: TextStyle(color: context.colors.secondaryText, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Territory', style: TextStyle(color: context.colors.secondaryText, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(appliedTerritory, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Submitted On', style: TextStyle(color: context.colors.secondaryText, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (_interviews.isNotEmpty) ...[
              const Text(
                'Interview Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildInterviewCard(context, _interviews.first),
              const SizedBox(height: 32),
            ],
            const Text(
              'Application Tracker',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatusTimeline(context, status),
            if (status == 'ACTIVE') ...[
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FixedDepositScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.greenSuccess,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Continue to Fixed Deposit', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildInterviewCard(BuildContext context, Map<String, dynamic> interview) {
    final mode = interview['interviewMode'] ?? 'UNKNOWN';
    final dateString = interview['scheduledAt'];
    String formattedDate = 'TBD';
    if (dateString != null) {
      try {
        final parsed = DateTime.parse(dateString).toLocal();
        formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(parsed);
      } catch (_) {}
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.disabledBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_available, color: context.colors.primaryDarkBlue),
              const SizedBox(width: 8),
              Text(
                'Status: ${interview['status'] ?? 'SCHEDULED'}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Date & Time: $formattedDate', style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 4),
          Text('Mode: $mode', style: const TextStyle(fontSize: 13)),
          if (mode == 'IN_PERSON' && interview['locationAddress'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text('Location: ${interview['locationAddress']}', style: const TextStyle(fontSize: 13)),
            ),
          if (mode == 'ONLINE' && interview['meetingLink'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text('Meeting Link: ${interview['meetingLink']}', style: const TextStyle(fontSize: 13, color: Colors.blue)),
            ),
          if (interview['interviewInstructions'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                'Instructions:\n${interview['interviewInstructions']}',
                style: TextStyle(fontSize: 12, color: context.colors.secondaryText, fontStyle: FontStyle.italic),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(BuildContext context, String currentStatus) {
    int currentStepIndex = 0;
    bool isRejected = currentStatus == 'REJECTED';
    bool isWithdrawn = currentStatus == 'WITHDRAWN';
    
    switch (currentStatus) {
      case 'DRAFT':
      case 'SUBMITTED':
        currentStepIndex = 0;
        break;
      case 'UNDER_REVIEW':
        currentStepIndex = 1;
        break;
      case 'INTERVIEW_SCHEDULED':
      case 'APPROVED':
      case 'REJECTED':
        currentStepIndex = 2; // In this UI flow, Approved/Rejected are decisions following review/interview. We'll map them logically below.
        break;
      case 'TRAINING_PENDING':
        currentStepIndex = 3;
        break;
      case 'TRAINING_COMPLETED':
        currentStepIndex = 4;
        break;
      case 'ACTIVE':
      case 'WITHDRAWN':
        currentStepIndex = 5;
        break;
    }

    // Creating exactly the list of statuses the user asked for:
    // SUBMITTED, UNDER REVIEW, APPROVED, REJECTED, TRAINING PENDING, TRAINING COMPLETED, ACTIVE, WITHDRAWN
    
    // We will build a dynamic list based on the path taken
    final List<Map<String, String>> steps = [
      {'title': 'SUBMITTED', 'subtitle': 'Your application has been received.'},
      {'title': 'UNDER REVIEW', 'subtitle': 'Our team is reviewing your details.'},
    ];

    if (isRejected) {
      steps.add({'title': 'REJECTED', 'subtitle': 'Application was rejected.'});
    } else if (isWithdrawn) {
      steps.add({'title': 'APPROVED', 'subtitle': 'Application was approved.'});
      steps.add({'title': 'TRAINING PENDING', 'subtitle': 'Awaiting training.'});
      steps.add({'title': 'TRAINING COMPLETED', 'subtitle': 'Training finished.'});
      steps.add({'title': 'WITHDRAWN', 'subtitle': 'Application was withdrawn.'});
    } else {
      steps.add({'title': 'APPROVED', 'subtitle': 'Application was approved.'});
      steps.add({'title': 'TRAINING PENDING', 'subtitle': 'Awaiting training.'});
      steps.add({'title': 'TRAINING COMPLETED', 'subtitle': 'Training finished.'});
      steps.add({'title': 'ACTIVE', 'subtitle': 'You are now an active CP.'});
    }

    // Remap index dynamically
    if (currentStatus == 'DRAFT' || currentStatus == 'SUBMITTED') currentStepIndex = 0;
    else if (currentStatus == 'UNDER_REVIEW' || currentStatus == 'INTERVIEW_SCHEDULED') currentStepIndex = 1;
    else if (currentStatus == 'REJECTED') currentStepIndex = 2;
    else if (currentStatus == 'APPROVED') currentStepIndex = 2;
    else if (currentStatus == 'TRAINING_PENDING') currentStepIndex = 3;
    else if (currentStatus == 'TRAINING_COMPLETED') currentStepIndex = 4;
    else if (currentStatus == 'ACTIVE' || currentStatus == 'WITHDRAWN') currentStepIndex = 5;

    return Column(
      children: List.generate(steps.length, (index) {
        bool isCompleted = index < currentStepIndex || (index == currentStepIndex && currentStatus != 'REJECTED' && currentStatus != 'WITHDRAWN');
        bool isCurrent = index == currentStepIndex;
        
        // If rejected, mark current step as error
        bool isError = isRejected && isCurrent;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline line & node
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isError 
                      ? Colors.red 
                      : (isCompleted || isCurrent ? context.colors.primaryDarkBlue : Colors.grey.shade300),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isError ? Icons.close : (isCompleted && !isCurrent ? Icons.check : Icons.circle),
                    size: 14,
                    color: Colors.white,
                  ),
                ),
                if (index < steps.length - 1)
                  Container(
                    width: 2,
                    height: 50,
                    color: (isCompleted && !isCurrent) ? context.colors.primaryDarkBlue : Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Text content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      steps[index]['title']!,
                      style: TextStyle(
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                        fontSize: 15,
                        color: isError ? Colors.red : (isCompleted || isCurrent ? context.colors.defaultText : Colors.grey.shade500),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      steps[index]['subtitle']!,
                      style: TextStyle(
                        fontSize: 13,
                        color: isError ? Colors.red.shade300 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
