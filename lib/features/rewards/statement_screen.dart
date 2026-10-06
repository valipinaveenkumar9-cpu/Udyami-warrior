import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/services/api_service.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/utils/session_manager.dart';
import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';
import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';

class StatementScreen extends StatefulWidget {
  const StatementScreen({super.key});

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
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
      try {
        final rewardData = await _apiService.getAllMyRewardPoints(userId);
        if (mounted) {
          setState(() {
            _rewardData = rewardData;
            _isLoading = false;
          });
        }
      } catch (_) {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showHelpSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.help_outline, color: context.colors.greenDark),
              const SizedBox(width: 8),
              Text(
                'Help & Support',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.colors.greenDark,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.phone, color: context.colors.greenSuccess),
                title: Text('Support Helpline', style: TextStyle(fontWeight: FontWeight.bold, color: context.colors.greenDark)),
                subtitle: const Text('+91 1800-123-4567'),
              ),
              ListTile(
                leading: Icon(Icons.email_outlined, color: context.colors.greenSuccess),
                title: Text('Email Support', style: TextStyle(fontWeight: FontWeight.bold, color: context.colors.greenDark)),
                subtitle: const Text('support@udyamiwarrior.com'),
              ),
              ListTile(
                leading: Icon(Icons.access_time_rounded, color: context.colors.greenSuccess),
                title: Text('Operating Hours', style: TextStyle(fontWeight: FontWeight.bold, color: context.colors.greenDark)),
                subtitle: const Text('Mon – Sat: 9:00 AM – 6:00 PM'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.greenSuccess,
                foregroundColor: Colors.white,
              ),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _rewardData?['data'];
    final totalPoints = data?['totalPoints'] ?? 0;
    final pendingPoints = data?['pendingPoints'] ?? 0;
    final paidPoints = data?['paidPoints'] ?? 0;
    final lifetimePoints = data?['lifetimePoints'] ?? totalPoints;
    final transactions = (data?['transactions'] ?? data?['history']) as List<dynamic>?;

    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      appBar: const CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Statement Summary Card
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
                        'Real Account Statement',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: context.colors.greenDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Member ID: ${SessionManager.memberId} · Verified Ledger',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.colors.greenDark.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Statement Entries Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colors.cardBackground,
                    border: Border.all(color: context.colors.lightGreyBlue),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: transactions != null && transactions.isNotEmpty
                      ? Column(
                          children: transactions.map((tx) {
                            final title = tx['title'] ?? tx['type'] ?? 'Reward Credited';
                            final subtitle = tx['subtitle'] ?? tx['date'] ?? 'Verified Activity';
                            final amount = tx['amount']?.toString() ?? '+0';
                            final isPositive = !amount.startsWith('-');
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                children: [
                                  _buildStatementRow(
                                    title: title.toString(),
                                    subtitle: subtitle.toString(),
                                    meta: 'ID: ${tx['id'] ?? 'TXN'}',
                                    amount: isPositive ? '+$amount' : amount,
                                    amountColor: isPositive ? context.colors.greenSuccess : context.colors.redWarningDark,
                                  ),
                                  if (transactions.last != tx)
                                    Divider(color: context.colors.lightGreyBlue, height: 24),
                                ],
                              ),
                            );
                          }).toList(),
                        )
                      : Column(
                          children: [
                            _buildStatementRow(
                              title: 'Total Redeemable Balance',
                              subtitle: 'Available for immediate withdrawal',
                              meta: '1 pt = ₹0.20',
                              amount: '+$totalPoints',
                              amountColor: context.colors.greenSuccess,
                            ),
                            Divider(color: context.colors.lightGreyBlue, height: 24),
                            _buildStatementRow(
                              title: 'Pending Verification',
                              subtitle: 'Waiting to clear from recent surveys & invites',
                              meta: 'clears soon',
                              amount: '$pendingPoints',
                              amountColor: context.colors.greenDark,
                            ),
                            Divider(color: context.colors.lightGreyBlue, height: 24),
                            _buildStatementRow(
                              title: 'Approved / Paid Out',
                              subtitle: 'Successfully disbursed to payout account',
                              meta: 'disbursed',
                              amount: '$paidPoints',
                              amountColor: context.colors.greenSuccess,
                            ),
                            Divider(color: context.colors.lightGreyBlue, height: 24),
                            _buildStatementRow(
                              title: 'Lifetime Earned Points',
                              subtitle: 'Total accumulated platform rewards',
                              meta: 'lifetime total',
                              amount: '$lifetimePoints',
                              amountColor: context.colors.greenDark,
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 12),

                // Raise a question Card (Now goes to Help & Support)
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
                        'Something look wrong on a line?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: context.colors.greenDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton(
                          onPressed: () => _showHelpSupportDialog(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: context.colors.greenDark,
                            side: BorderSide(color: context.colors.greenSuccess),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Raise a question',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: context.colors.lightGreyBlue)),
            color: context.colors.cardBackground,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.map_outlined, 'Paths', false),
                _buildNavItem(Icons.add_circle_outline, 'Invite', false),
                _buildNavItem(Icons.card_giftcard, 'Rewards', true),
                _buildNavItem(Icons.share_outlined, 'Refer', false),
                _buildNavItem(Icons.person_outline, 'Profile', false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatementRow({
    required String title,
    required String subtitle,
    required String meta,
    required String amount,
    required Color amountColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: context.colors.greenDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: context.colors.greenDark.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                meta,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  color: context.colors.greenDark.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          amount,
          style: TextStyle(
            fontFamily: 'Barlow Condensed',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: amountColor,
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    final color = isSelected ? context.colors.greenDark : const Color(0xFF5A6B87);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }
}
