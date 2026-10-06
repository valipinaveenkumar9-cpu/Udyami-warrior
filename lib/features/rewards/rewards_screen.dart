import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/services/api_service.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/utils/session_manager.dart';
import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';
import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'redeem_screen.dart';
import 'statement_screen.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  Map<String, dynamic>? _rewardData;

  @override
  void initState() {
    super.initState();
    _fetchRewardPoints();
  }

  Future<void> _fetchRewardPoints() async {
    final userId = SessionManager.user?['id'] ?? SessionManager.user?['userId'] ?? SessionManager.user?['_id'] ?? '';
    if (userId.isNotEmpty) {
      final rewardData = await _apiService.getAllMyRewardPoints(userId);
      if (mounted) {
        setState(() {
          _rewardData = rewardData;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPoints = _rewardData?['data']?['totalPoints'] ?? 0;
    final pendingPoints = _rewardData?['data']?['pendingPoints'] ?? 0;
    final paidPoints = _rewardData?['data']?['paidPoints'] ?? 0;
    final lifetimePoints = _rewardData?['data']?['lifetimePoints'] ?? totalPoints;
    
    final num totalVal = (totalPoints is num) ? totalPoints : (num.tryParse(totalPoints.toString()) ?? 0);
    final num pendingVal = (pendingPoints is num) ? pendingPoints : (num.tryParse(pendingPoints.toString()) ?? 0);
    final num paidVal = (paidPoints is num) ? paidPoints : (num.tryParse(paidPoints.toString()) ?? 0);
    final num lifetimeVal = (lifetimePoints is num) ? lifetimePoints : (num.tryParse(lifetimePoints.toString()) ?? totalVal);

    final rupeeAmount = (totalVal * 0.20).toStringAsFixed(2);
    final memberTag = '${SessionManager.memberId} · ${SessionManager.userTier}';
    final wardName = SessionManager.userWard;

    final now = DateTime.now();
    final timeString = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      appBar: const CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: Column(
        children: [
          // Up-to-date Status Banner
          Container(
            color: context.colors.greenLight,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.cloud_done_outlined, size: 16, color: context.colors.greenDark),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Up to date',
                    style: TextStyle(
                      fontSize: 13,
                      color: context.colors.greenDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  timeString,
                  style: TextStyle(
                    fontSize: 11,
                    color: context.colors.greenDark,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _fetchRewardPoints,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Header Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: context.colors.cardBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: context.colors.lightGreyBlue),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Rewards',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: context.colors.greenDark,
                                      ),
                                    ),
                                    Text(
                                      memberTag,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: context.colors.greenDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => StatementScreen()),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: context.colors.greenLight,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.receipt_long_outlined,
                                        size: 18,
                                        color: context.colors.greenDark,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Statement',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: context.colors.greenDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Main Balance Card (Green)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                          decoration: BoxDecoration(
                            color: context.colors.greenDark,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'You can redeem',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                totalVal.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 44,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Barlow Condensed',
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'about ₹$rupeeAmount (1 pt = ₹0.20)',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Three Metric Cards
                        Row(
                          children: [
                            _buildSmallStatCard(
                              'Waiting to clear',
                              pendingVal.toString(),
                              'clears soon',
                              valueColor: context.colors.greenDark,
                            ),
                            const SizedBox(width: 8),
                            _buildSmallStatCard(
                              'Being paid',
                              paidVal.toString(),
                              'approved',
                              valueColor: context.colors.greenSuccess,
                            ),
                            const SizedBox(width: 8),
                            _buildSmallStatCard(
                              'Lifetime',
                              lifetimeVal.toString(),
                              'total points',
                              valueColor: context.colors.greenDark,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Info Banner (Green theme)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: context.colors.greenLight,
                            border: Border.all(color: context.colors.greenSuccess.withValues(alpha: 0.3)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 20,
                                color: context.colors.greenDark,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Points Distribution Rules & Minimum Withdrawal',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: context.colors.greenDark,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Minimum withdrawal is 2,500 points (₹500.00). Points are credited after verification. 1 point = ₹0.20.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: context.colors.greenDark.withValues(alpha: 0.8),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Multipliers Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: context.colors.cardBackground,
                            border: Border.all(color: context.colors.lightGreyBlue),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Why you earn more in $wardName',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.1,
                                  color: context.colors.greenDark,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'High priority area multiplier',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: context.colors.secondaryText,
                                    ),
                                  ),
                                  Text(
                                    '× 1.50',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: context.colors.greenSuccess,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(color: context.colors.lightGreyBlue, height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    SessionManager.userTier,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: context.colors.secondaryText,
                                    ),
                                  ),
                                  Text(
                                    '× 1.05',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: context.colors.greenSuccess,
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
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.colors.cardBackground,
            border: Border(top: BorderSide(color: context.colors.lightGreyBlue)),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RedeemScreen(availablePoints: totalVal.toInt())),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.greenSuccess,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Redeem points',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallStatCard(
    String label,
    String value,
    String subtitle, {
    Color? valueColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.colors.cardBackground,
          border: Border.all(color: context.colors.lightGreyBlue),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: context.colors.greenDark,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Barlow Condensed',
                color: valueColor ?? context.colors.greenDark,
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 9,
                color: context.colors.greenDark.withValues(alpha: 0.7),
                fontFamily: 'monospace',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
