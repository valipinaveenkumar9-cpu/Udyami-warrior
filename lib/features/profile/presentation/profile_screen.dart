import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'messages_screen.dart';
import 'qr_scanner_screen.dart';
import 'bank_account_screen.dart';

import 'leaderboard_screen.dart';
import '../../auth/presentation/login_screen.dart';
import '../../../core/utils/session_manager.dart';
import '../../../core/api/profile_api.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _language = 'ಕನ್ನಡ';
  final ProfileAPI _profileApi = ProfileAPI();
  bool _isLoadingProfile = true;
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final userId = SessionManager.user?['userId'] ?? SessionManager.user?['id'] ?? SessionManager.user?['_id'];
      if (userId == null) {
        if (mounted) setState(() => _isLoadingProfile = false);
        return;
      }
      
      final res = await _profileApi.getUserProfileById(userId.toString());
      if (res != null && res['success'] == true) {
        if (mounted) {
          setState(() {
            _profileData = res['data']?['profile'] ?? res['data'];
            if (_profileData != null) {
              final w = _profileData?['ward'] ?? _profileData?['assembly'] ?? _profileData?['district'];
              if (w != null) {
                SessionManager.setUserWard(w.toString());
              }
            }
          });
        }
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      if (mounted) setState(() => _isLoadingProfile = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String firstName = _profileData?['firstName'] ?? _profileData?['name'] ?? '';
    final String lastName = _profileData?['lastName'] ?? '';
    String fullName = '$firstName $lastName'.trim();
    if (fullName.isEmpty) fullName = SessionManager.userName;
    if (fullName.isEmpty) fullName = 'User';

    final String ward = _profileData?['ward'] ?? _profileData?['assembly'] ?? _profileData?['district'] ?? 'Ward N/A';
    final String cpId = _profileData?['cpId']?.toString() ?? 
                        _profileData?['channelPartnerId']?.toString() ?? 
                        SessionManager.user?['cpId']?.toString() ?? 
                        SessionManager.user?['channelPartnerId']?.toString() ?? 
                        SessionManager.user?['userId']?.toString() ?? 
                        SessionManager.user?['id']?.toString() ?? 
                        SessionManager.user?['_id']?.toString() ?? 
                        'N/A';
    final String initials = fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      appBar: CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: _isLoadingProfile 
        ? const Center(child: CircularProgressIndicator())
        : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.colors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.colors.disabledBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: context.colors.primaryDarkBlue,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MessagesScreen()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: context.colors.lightGreyBlue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.message_outlined, size: 18, color: context.colors.primaryDarkBlue),
                                const SizedBox(width: 4),
                             
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ID Card
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.colors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.colors.disabledBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Color(0xFF33456B),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                initials,
                                style: TextStyle(
                                  color: context.colors.cardBackground,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fullName,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.colors.primaryDarkBlue),
                                  ),
                                  Text(
                                    'ID: $cpId',
                                    style: TextStyle(fontSize: 13, color: context.colors.secondaryText, fontFamily: 'monospace'),
                                  ),
                                  Text(
                                    '$ward · ${_profileData?['tier'] ?? 'Standard tier'}',
                                    style: TextStyle(fontSize: 13, color: context.colors.subtitleText),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const QRScannerScreen()),
                                );
                              },
                              child: Icon(
                                Icons.qr_code_scanner,
                                color: context.colors.orangeWarning,
                                size: 34,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Show this when you introduce yourself.',
                          style: TextStyle(fontSize: 11, color: context.colors.subtitleText),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),

                  // Your record card
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.colors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.colors.disabledBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your record',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.colors.secondaryText),
                        ),
                        SizedBox(height: 12),
                        _buildRecordRow('Verified registrations', _profileData?['verifiedRegistrations']?.toString() ?? '0'),
                        _buildRecordRow('Quality score', '${_profileData?['qualityScore'] ?? '0'}%', valueColor: context.colors.greenDark),
                        _buildRecordRow('Paths completed', _profileData?['pathsCompleted']?.toString() ?? '0'),
                        _buildRecordRow('Partner since', _profileData?['partnerSince']?.toString() ?? 'N/A', isLast: true),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),



                  // Settings list card
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: context.colors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.colors.disabledBorder),
                    ),
                    child: Column(
                      children: [
                        _buildSettingsRow(
                          'Language',
                          onTap: () {
                            _showLanguagePicker(context);
                          },
                          trailing: Text(
                            _language,
                            style: TextStyle(fontSize: 13, color: context.colors.subtitleText),
                          ),
                        ),
                        _buildSettingsRow(
                          'Payout account',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const BankAccountScreen()),
                            );
                          },
                          trailing: _buildStatusChip('Verified', context.colors.greenDark, context.colors.greenLight),
                        ),
                        _buildSettingsRow(
                          'Partner agreement',
                          onTap: () => _showPartnerAgreement(context),
                          trailing: Text(
                            'v1.2 · 12 Feb 2026',
                            style: TextStyle(fontSize: 11, color: context.colors.subtitleText, fontFamily: 'monospace'),
                          ),
                        ),
                        _buildSettingsRow(
                          'Training',
                          onTap: () => _showTraining(context),
                          trailing: _buildStatusChip('4 / 4', context.colors.greenDark, context.colors.greenLight),
                        ),
                        _buildSettingsRow(
                          'Help & grievance',
                        ),
                        _buildSettingsRow(
                          'Log out',
                          onTap: () async {
                            await SessionManager.clearSession();
                            if (!context.mounted) return;
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          isLast: true,
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
    );
  }

  Widget _buildRecordRow(String label, String value, {Color? valueColor, bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: context.colors.primaryDarkBlue),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? context.colors.primaryDarkBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow(String label, {Widget? trailing, bool isLast = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: isLast ? null : Border(bottom: BorderSide(color: context.colors.lightGreyBlue)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.colors.primaryDarkBlue),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String text, Color textColor, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildTabItem(IconData icon, String label, bool isSelected) {
    final color = isSelected ? context.colors.secondaryText : context.colors.chartAxis;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 4),
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

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('English'),
                onTap: () {
                  setState(() => _language = 'English');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('ಕನ್ನಡ'),
                onTap: () {
                  setState(() => _language = 'ಕನ್ನಡ');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void _showPayoutAccount(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payout Account Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.colors.primaryDarkBlue)),
                const SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.account_balance, color: context.colors.orangeWarning),
                  title: const Text('First Choice Multipurpose \n Co-operative Limited \n- FCMCSLC', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Account ending in **** 4321\nIFSC: KSCB0002001'),
                  isThreeLine: true,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  void _showPartnerAgreement(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Partner Agreement', style: TextStyle(color: context.colors.primaryDarkBlue)),
          content: SingleChildScrollView(
            child: Text(
              'Version 1.2 (Effective Feb 12, 2026)\n\nBy continuing to act as a Channel Partner, you agree to the terms of service outlined in this agreement.\n\n1. Responsibilities...\n2. Payouts...\n3. Termination...',
              style: TextStyle(color: context.colors.secondaryText),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      }
    );
  }

  void _showTraining(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Training Modules', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.colors.primaryDarkBlue)),
                const SizedBox(height: 16),
                const ListTile(leading: Icon(Icons.check_circle, color: Colors.green), title: Text('Module 1: Introduction')),
                const ListTile(leading: Icon(Icons.check_circle, color: Colors.green), title: Text('Module 2: App Navigation')),
                const ListTile(leading: Icon(Icons.check_circle, color: Colors.green), title: Text('Module 3: Registration Process')),
                const ListTile(leading: Icon(Icons.check_circle, color: Colors.green), title: Text('Module 4: Quality Guidelines')),
              ],
            ),
          ),
        );
      }
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Help & Grievance', style: TextStyle(color: context.colors.primaryDarkBlue)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.phone, color: context.colors.orangeWarning),
                title: const Text('Call Support'),
                subtitle: const Text('+91 1800-123-4567'),
                onTap: () async {
                  final Uri url = Uri.parse('tel:+9118001234567');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.email, color: context.colors.orangeWarning),
                title: const Text('Email Support'),
                subtitle: const Text('support@example.com'),
                onTap: () async {
                  final Uri url = Uri.parse('mailto:support@example.com');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      }
    );
  }
}
