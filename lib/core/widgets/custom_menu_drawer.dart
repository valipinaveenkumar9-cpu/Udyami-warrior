import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/utils/session_manager.dart';
import 'package:uk_circle_partners/features/profile/presentation/profile_screen.dart';
import 'package:uk_circle_partners/features/profile/presentation/leaderboard_screen.dart';
import 'package:uk_circle_partners/features/profile/presentation/bank_account_screen.dart';
import 'package:uk_circle_partners/features/auth/presentation/login_screen.dart';
import 'package:uk_circle_partners/features/path/boundary_view_screen.dart';

class CustomMenuDrawer extends StatefulWidget {
  const CustomMenuDrawer({super.key});

  @override
  State<CustomMenuDrawer> createState() => _CustomMenuDrawerState();
}

class _CustomMenuDrawerState extends State<CustomMenuDrawer> {
  void _showBoundaryMap(BuildContext context, String ward) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BoundaryViewScreen(wardName: ward),
      ),
    );
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

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.description_outlined, color: context.colors.greenDark),
              const SizedBox(width: 8),
              Text(
                'Terms & Conditions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.colors.greenDark,
                ),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: Text(
              'Udyami Warrior Partner Program - Terms & Conditions (v1.2)\n\n'
              '1. Acceptance: By accessing and using this application, you agree to comply with all terms and conditions.\n\n'
              '2. Channel Partner Code: Partner activities, field surveys, and referrals must adhere to verified authenticity guidelines.\n\n'
              '3. Payouts & Rewards: Rewards are generated at ₹0.20 per point and paid out upon reaching the minimum threshold of 2,500 points.\n\n'
              '4. Privacy & Compliance: Field survey data collected is strictly confidential and protected.',
              style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF2C4470)),
            ),
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

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.privacy_tip_outlined, color: context.colors.greenDark),
              const SizedBox(width: 8),
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.colors.greenDark,
                ),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: Text(
              'Privacy Policy (Updated 2026)\n\n'
              '1. Data Collection: We collect location data during active path tracking solely for route verification.\n\n'
              '2. Data Usage: Personal profile details and account information are encrypted and strictly used for authentication and reward payouts.\n\n'
              '3. Third-party Sharing: Your data is never sold or shared with unauthorized third parties.\n\n'
              '4. Security: All data transmissions are encrypted using standard SSL/TLS protocol.',
              style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF2C4470)),
            ),
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
    final name = SessionManager.userName;
    final memberId = SessionManager.memberId;
    final ward = SessionManager.userWard;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width * 0.85,
      child: Material(
        color: Colors.white,
        child: SafeArea(
          top: true,
          bottom: true,
          child: Column(
            children: [
              // 100px gap from top + Fixed App Logo Bar
              const SizedBox(height: 56),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.white,
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/logo/uk_logo_white_bg_1584x672.png',
                  height: 36,
                  fit: BoxFit.contain,
                ),
              ),
              Divider(color: context.colors.lightGreyBlue, height: 1),

              // Scrollable Details Below (Logo bar remains fixed and unmoveable)
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding + 40),
                  children: [
                    // --- SHORT PROFILE BOX (ONE BELOW THE OTHER) ---
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfileScreen()),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.colors.greenLight,
                          border: Border.all(color: context.colors.greenSuccess.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: context.colors.greenDark,
                                  child: Text(
                                    initial,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Icon(Icons.chevron_right, color: context.colors.greenDark),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: context.colors.greenDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID: $memberId',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w600,
                                color: context.colors.greenDark.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.location_on_rounded, size: 14, color: context.colors.greenDark),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    ward,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: context.colors.greenDark.withValues(alpha: 0.8),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // --- BOUNDARY CARD (CLICKABLE) ---
                    InkWell(
                      onTap: () => _showBoundaryMap(context, ward),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: context.colors.lightGreyBlue),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.map_outlined, size: 16, color: context.colors.greenDark),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Selected Boundary',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: context.colors.greenDark,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '$ward • Hobli Zone 04',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: context.colors.greenDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, color: context.colors.greenDark),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // --- WARD RANK CARD ---
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.colors.greenLight,
                          border: Border.all(color: context.colors.greenSuccess.withValues(alpha: 0.4)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: context.colors.greenDark,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.emoji_events, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ward Rank #4',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: context.colors.greenDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '$ward • Click to see leaderboard',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: context.colors.greenDark.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, color: context.colors.greenDark),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    Divider(color: context.colors.lightGreyBlue, height: 1),
                    const SizedBox(height: 12),

                    // --- BANK ACCOUNT ---
                    _buildDrawerTile(
                      icon: Icons.account_balance_outlined,
                      title: 'Bank Account',
                      subtitle: 'View & add payout bank accounts',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BankAccountScreen()),
                        );
                      },
                    ),

                    // --- HELP & SUPPORT ---
                    _buildDrawerTile(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle: 'Helpline and FAQ',
                      onTap: () => _showHelpSupportDialog(context),
                    ),

                    // --- TERMS & CONDITIONS ---
                    _buildDrawerTile(
                      icon: Icons.description_outlined,
                      title: 'Terms & Conditions',
                      subtitle: 'Partner agreement rules',
                      onTap: () => _showTermsDialog(context),
                    ),

                    // --- PRIVACY POLICY ---
                    _buildDrawerTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      subtitle: 'Data protection and usage',
                      onTap: () => _showPrivacyDialog(context),
                    ),

                    const SizedBox(height: 24),

                    // --- LOGOUT BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogCtx) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                title: Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, color: context.colors.greenDark)),
                                content: const Text('Are you sure you want to log out?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(dialogCtx),
                                    child: Text('Cancel', style: TextStyle(color: context.colors.greenDark)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pop(dialogCtx);
                                      if (Navigator.canPop(context)) Navigator.pop(context);
                                      await SessionManager.clearSession();
                                      if (context.mounted) {
                                        Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                                          (route) => false,
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: context.colors.greenDark,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Logout'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.logout, color: context.colors.greenDark, size: 18),
                        label: Text('Logout', style: TextStyle(color: context.colors.greenDark, fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: context.colors.greenDark),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
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
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.colors.greenLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: context.colors.greenDark, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: context.colors.greenDark,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 11,
            color: context.colors.greenDark.withValues(alpha: 0.7),
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: context.colors.greenDark),
        onTap: onTap,
      ),
    );
  }
}
