import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/session_manager.dart';
import 'expo_registration_form_screen.dart';

class DistributeInvitationDialog extends StatelessWidget {
  const DistributeInvitationDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const DistributeInvitationDialog(),
    );
  }

  String get _referralCode {
    final cpId = SessionManager.user?['cpId']?.toString() ?? 
                SessionManager.user?['channelPartnerId']?.toString() ?? 
                SessionManager.user?['userId']?.toString() ?? 
                SessionManager.user?['id']?.toString();
    if (cpId != null && cpId.isNotEmpty && cpId.toLowerCase() != 'null') {
      return cpId.startsWith('UBEXPO-') ? cpId : 'UBEXPO-${cpId.replaceAll('UDY', '')}';
    }
    final memberId = SessionManager.user?['memberId']?.toString();
    if (memberId != null && memberId.isNotEmpty && memberId.toLowerCase() != 'null') {
      return 'UBEXPO-$memberId';
    }
    return '';
  }

  String get _referralUrl => _referralCode.isNotEmpty
      ? 'https://udyamibharat.org/expo/register?ref=$_referralCode'
      : 'https://udyamibharat.org/expo/register';

  void _copyToClipboard(BuildContext context, String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF0F52BA),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _shareInvitation(BuildContext context) async {
    final code = _referralCode;
    final shareText =
        'Join us at UDYAMI BHARAT EXPO 2026 (Dec 4–6, BIEC Bengaluru)!\n'
        'Register as a Visitor, Stall/Exhibitor, or Sponsor${code.isNotEmpty ? ' using my Referral Code: $code' : ''}\n'
        'Expo Registration Form: $_referralUrl';
    
    final uri = Uri.parse('whatsapp://send?text=${Uri.encodeComponent(shareText)}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _copyToClipboard(context, shareText, 'Expo registration link copied to clipboard!');
      }
    } catch (_) {
      _copyToClipboard(context, shareText, 'Expo registration link copied to clipboard!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final refCode = _referralCode;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 6,
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close Button
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.close, color: Colors.grey, size: 22),
                ),
              ),
            ),

            // Header Title
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'UDYAMI BHARAT\n',
                    style: TextStyle(
                      color: Color(0xFF1E2A44),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                      height: 1.2,
                    ),
                  ),
                  TextSpan(
                    text: 'EXPO 2026 REGISTRATION',
                    style: TextStyle(
                      color: Color(0xFFE86A23),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'Scan QR code to open the Expo Registration form.\nChoose to register as Visitor, Stall Partner, or Sponsor.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF556070),
                fontSize: 12,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 16),

            // QR Code Box with Tap to Open Registration Form (Testing for Android/iPhone)
            InkWell(
              onTap: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ExpoRegistrationFormScreen(referralCode: refCode),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF0F52BA), width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x10000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    QrImageView(
                      data: _referralUrl,
                      version: QrVersions.auto,
                      size: 160.0,
                      backgroundColor: Colors.white,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Color(0xFF1E2A44),
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Color(0xFF1E2A44),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Tap QR Code to Test Registration Form',
                      style: TextStyle(
                        color: Color(0xFF0F52BA),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Your Referral Code Section
            const Text(
              'Your Referral Code',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 6),

            // Code Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    refCode.isNotEmpty ? refCode : 'CP ID Pending',
                    style: TextStyle(
                      color: refCode.isNotEmpty ? const Color(0xFF0F172A) : Colors.orange.shade800,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (refCode.isNotEmpty)
                    InkWell(
                      onTap: () => _copyToClipboard(
                        context,
                        refCode,
                        'Referral Code copied to clipboard!',
                      ),
                      child: const Icon(
                        Icons.copy_rounded,
                        size: 18,
                        color: Color(0xFF0F52BA),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Test Scan QR / Open Registration Form Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ExpoRegistrationFormScreen(referralCode: refCode),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
                icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
                label: const Text(
                  'Test QR: Open Registration Form',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Share Invitation Button (Primary Filled)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _shareInvitation(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F52BA),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
                icon: const Icon(Icons.share_rounded, size: 18),
                label: const Text(
                  'Share Registration Link',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Copy Link Button (Outlined)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _copyToClipboard(
                  context,
                  _referralUrl,
                  'Expo registration link copied to clipboard!',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F52BA),
                  side: const BorderSide(color: Color(0xFF0F52BA), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.copy_outlined, size: 18),
                label: const Text(
                  'Copy Registration Link',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
