import 'package:flutter/material.dart';
import '../../../../core/utils/session_manager.dart';

class ExpoRegistrationDialog extends StatelessWidget {
  const ExpoRegistrationDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const ExpoRegistrationDialog(),
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
    return 'Pending';
  }

  @override
  Widget build(BuildContext context) {
    final userName = SessionManager.userName;
    final userWard = SessionManager.userWard;
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEF3C7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.how_to_reg_rounded, color: Color(0xFFD97706), size: 32),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'EXPO REGISTRATION',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1E2A44),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Ambassador & Event Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFE86A23),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Ambassador Name', userName.isEmpty ? 'UB Warrior' : userName),
                  const Divider(height: 16),
                  _buildInfoRow('Registration ID', refCode),
                  const Divider(height: 16),
                  _buildInfoRow('Assigned Ward', userWard),
                  const Divider(height: 16),
                  _buildInfoRow('Event Status', 'Approved & Active (Ward Chairman Verified)'),
                  const Divider(height: 16),
                  _buildInfoRow('Event Dates', 'Dec 4–6, 2026 | BIEC Bengaluru'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE86A23),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
                child: const Text(
                  'Done',
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
