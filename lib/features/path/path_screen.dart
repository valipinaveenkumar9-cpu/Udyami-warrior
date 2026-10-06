import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';
import 'package:uk_circle_partners/core/services/api_service.dart';
import 'package:uk_circle_partners/core/services/background_location_service.dart';
import 'package:uk_circle_partners/core/utils/session_manager.dart';
import '../expo/presentation/ub_expo_brochure_screen.dart';
import '../expo/presentation/distribute_invitation_dialog.dart';
import '../expo/presentation/download_app_dialog.dart';
import '../expo/data/app_download_api.dart';
import '../expo/presentation/referred_downloads_screen.dart';
import '../expo/presentation/my_performance_screen.dart';
import 'active_path_screen.dart';
import 'my_paths_screen.dart';

class PathScreen extends StatefulWidget {
  const PathScreen({super.key});

  @override
  State<PathScreen> createState() => _PathScreenState();
}

class _PathScreenState extends State<PathScreen> {
  final ApiService _apiService = ApiService();
  final String _channelPartnerId = "7fd4a155-6934-4e8a-9b65-d3f1e8c7f123";
  Map<String, dynamic>? _reportData;
  Map<String, dynamic>? _rewardData;
  Map<String, dynamic>? _assignedRoute;
  int _todaySurveysCount = 0;
  int _todayDownloads = 0;

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  Future<void> _fetchReport() async {
    final userId = SessionManager.user?['id'] ?? SessionManager.user?['userId'] ?? SessionManager.user?['_id'] ?? _channelPartnerId;
    final data = await _apiService.getJourneyReports(
      'channel_partner',
      userId,
    );
    final rewardData = await _apiService.getAllMyRewardPoints(userId);
    
    // Fetch Assigned Route for Today
    Map<String, dynamic>? routeObj;
    try {
      final routeRes = await _apiService.getAssignedRoute(userId);
      if (routeRes != null && routeRes['data'] is List && (routeRes['data'] as List).isNotEmpty) {
        routeObj = (routeRes['data'] as List).first as Map<String, dynamic>;
      }
    } catch (_) {}

    // Fetch Today's Submitted Surveys
    int surveysCount = 0;
    try {
      final surveys = await _apiService.getCPSubmittedData(userId);
      surveysCount = surveys.length;
    } catch (_) {}

    // Today's app downloads through this Warrior's QR / link
    final dl = await AppDownloadApi.getStats();

    if (mounted) {
      setState(() {
        _reportData = data;
        _rewardData = rewardData;
        _assignedRoute = routeObj;
        _todaySurveysCount = surveysCount;
        if (dl != null) _todayDownloads = dl.today;
      });
    }
  }

  void _openExpoBrochure() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const UbExpoBrochureScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeName = _assignedRoute?['routeName'] ?? 'Nelamangala Ward Route 04';
    final distance = _assignedRoute?['plannedDistance']?.toString() ?? '4.2 km';
    final duration = _assignedRoute?['estimatedDuration']?.toString() ?? '2.5 hrs';
    final status = _assignedRoute?['status'] ?? 'Assigned';

    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      appBar: CustomAppBar(showBackArrow: false),
      endDrawer: const CustomMenuDrawer(),
      body: RefreshIndicator(
        onRefresh: _fetchReport,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Online / Offline Status Banner & Toggle
            ValueListenableBuilder<int>(
              valueListenable: SessionManager.profileUpdateNotifier,
              builder: (context, _, __) {
                final isOnline = SessionManager.isOnlineTracking;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isOnline ? context.colors.greenLight : context.colors.lightGreyBlue,
                    border: Border.all(
                      color: isOnline ? context.colors.greenSuccess : context.colors.disabledBorder,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isOnline ? context.colors.greenDark : Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Make sure you are online',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: context.colors.greenDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    isOnline ? 'Live tracking active & updating' : 'Live tracking paused (You are offline)',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: context.colors.greenDark.withValues(alpha: 0.8),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: isOnline,
                        activeColor: Colors.white,
                        activeTrackColor: context.colors.greenDark,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey.shade400,
                        onChanged: (value) async {
                          await SessionManager.setIsOnlineTracking(value);
                          if (!value) {
                            try {
                              await BackgroundLocationService().stopTracking();
                            } catch (_) {}
                          } else {
                            if (_assignedRoute != null) {
                              final routeId = _assignedRoute!['routeId'] ?? _assignedRoute!['id'] ?? _assignedRoute!['_id'];
                              final userId = SessionManager.user?['id'] ?? SessionManager.user?['userId'] ?? SessionManager.user?['_id'] ?? 'CP-USER';
                              if (routeId != null) {
                                try {
                                  await BackgroundLocationService().startTracking(
                                    routeId.toString(),
                                    userId.toString(),
                                    [],
                                  );
                                } catch (_) {}
                              }
                            }
                          }
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  value
                                      ? 'You are ONLINE. Live tracking active & notification restored.'
                                      : 'You are OFFLINE. Live tracking stopped & notification removed.',
                                ),
                                backgroundColor: value ? context.colors.greenSuccess : context.colors.greenDark,
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            // Points Card (Green matching other cards: 0xFF0E5C4A)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0E5C4A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Points you can redeem',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _rewardData?['data']?['totalPoints']?.toString() ?? '0',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Barlow Condensed',
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Waiting to clear',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _rewardData?['data']?['pendingPoints']?.toString() ?? '0',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Barlow Condensed',
                        ),
                      ),
                      const Text(
                        'clears soon',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // UB EXPO 2026 Dashboard Card (Venue Image Only - No Black Ground)
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: _openExpoBrochure,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 28,
                  ),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/biec_venue.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        '🎪 UB EXPO 2026',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Serif',
                          letterSpacing: 0.8,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                            Shadow(
                              color: Colors.black,
                              blurRadius: 16,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 15,
                            color: Color(0xFFF1E7CC),
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Dec 4–6, 2026 | BIEC Bengaluru',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 10,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '50K+ Visitors • 500+ Exhibitors • 16 Sectors',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFF8FAFC),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 10,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 3 Dashboard Blocks Side by Side
            Row(
              children: [
                // 1. Distribute Invitation
                Expanded(
                  child: Material(
                    color: const Color(0xFF0E5C4A),
                    borderRadius: BorderRadius.circular(14),
                    elevation: 3,
                    child: InkWell(
                      onTap: () => DistributeInvitationDialog.show(context),
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 4,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.mark_email_unread_outlined,
                              color: Colors.white,
                              size: 26,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Distribute\nInvitation',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // 2. Download App
                Expanded(
                  child: Material(
                    color: const Color(0xFF0E5C4A),
                    borderRadius: BorderRadius.circular(14),
                    elevation: 3,
                    child: InkWell(
                      onTap: () async {
                        await DownloadAppDialog.show(context);
                        _fetchReport();
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 4,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.file_download_outlined,
                              color: Colors.white,
                              size: 26,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Download\nApp',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // 3. Track Performance
                Expanded(
                  child: Material(
                    color: const Color(0xFF0E5C4A),
                    borderRadius: BorderRadius.circular(14),
                    elevation: 3,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MyPerformanceScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 4,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.insert_chart_outlined_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Track\nPerformance',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Combined Block: Today's Activities & Assigned Route for Today
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Block Header
                    Row(
                      children: const [
                        Icon(Icons.today_rounded, color: Color(0xFF0F52BA), size: 22),
                        SizedBox(width: 8),
                        Text(
                          "Today's Overview",
                          style: TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Section 1: Assigned Route for Today
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.alt_route_rounded, color: Color(0xFF0E5C4A), size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    'Assigned Route for Today',
                                    style: TextStyle(
                                      color: Color(0xFF0E5C4A),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  status,
                                  style: const TextStyle(
                                    color: Color(0xFF16A34A),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            routeName,
                            style: const TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Distance: $distance • Est. Duration: $duration hrs',
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (_assignedRoute != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ActivePathScreen(routeData: _assignedRoute!),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MyPathsScreen(),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0E5C4A),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.navigation_outlined, size: 16),
                              label: const Text(
                                'View / Start Route',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Section 2: Today's Activities
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.bolt_rounded, color: Color(0xFFE86A23), size: 18),
                              SizedBox(width: 6),
                              Text(
                                "Today's Activities",
                                style: TextStyle(
                                  color: Color(0xFFE86A23),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildActivityMetric(
                                'Surveys',
                                _todaySurveysCount.toString(),
                                Icons.assignment_outlined,
                                const Color(0xFF16A34A),
                              ),
                              _buildActivityMetric(
                                'Invites',
                                '14',
                                Icons.send_rounded,
                                const Color(0xFF2563EB),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ReferredDownloadsScreen(),
                                    ),
                                  );
                                  _fetchReport();
                                },
                                child: _buildActivityMetric(
                                  'Downloads',
                                  _todayDownloads.toString(),
                                  Icons.download_rounded,
                                  const Color(0xD9D97706),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityMetric(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Barlow Condensed',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
