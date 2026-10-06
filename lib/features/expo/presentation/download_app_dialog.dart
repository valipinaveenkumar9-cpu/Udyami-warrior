import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/app_download_api.dart';

class DownloadAppDialog extends StatefulWidget {
  const DownloadAppDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const DownloadAppDialog(),
    );
  }

  @override
  State<DownloadAppDialog> createState() => _DownloadAppDialogState();
}

class _DownloadAppDialogState extends State<DownloadAppDialog> {
  AppDownloadInfo? _info;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final info = await AppDownloadApi.getQr();
    if (!mounted) return;
    setState(() {
      _info = info;
      _loading = false;
    });
  }

  String get _downloadUrl => _info?.playStoreUrl ?? '';
  String? get _referralCode => _info?.referralCode;

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

  Future<void> _shareApp(BuildContext context) async {
    if (_downloadUrl.isEmpty) return;
    final code = _referralCode;
    final shareText =
        'Download the UB Kutumba App to register for UDYAMI BHARAT EXPO 2026 (Dec 4–6, BIEC Bengaluru)!\n'
        'Download here: $_downloadUrl'
        '${code != null ? '\nUse my Referral Code while registering: $code' : ''}';

    final uri = Uri.parse('whatsapp://send?text=${Uri.encodeComponent(shareText)}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _copyToClipboard(context, shareText, 'App download link copied to clipboard!');
      }
    } catch (_) {
      _copyToClipboard(context, shareText, 'App download link copied to clipboard!');
    }
  }

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'UB WARRIORS APP',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF1E2A44),
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Download & Track',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF0F52BA),
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'Scan the QR code to open the UB Kutumba app on the Play Store.\nDownloads are counted when someone registers with your referral code.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF556070),
                fontSize: 12,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 16),

            // QR Code Box with Logo Accent
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SizedBox(
                width: 170,
                height: 170,
                child: _loading
                    ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                    : _info == null
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Could not load QR',
                                  style: TextStyle(color: Color(0xFF556070), fontSize: 12),
                                ),
                                TextButton(onPressed: _load, child: const Text('Retry')),
                              ],
                            ),
                          )
                        : Image.memory(_info!.qrPng, fit: BoxFit.contain, gaplessPlayback: true),
              ),
            ),

            const SizedBox(height: 16),

            // Referral code (the Warrior's unique cpId, created on approval)
            if (!_loading && _info != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: _referralCode == null
                    ? const Text(
                        'Your referral code will be generated once your Ward Chairman approves you.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF556070), fontSize: 12),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Your Referral Code',
                                style: TextStyle(color: Color(0xFF556070), fontSize: 11),
                              ),
                              Text(
                                _referralCode!,
                                style: const TextStyle(
                                  color: Color(0xFF0F172A),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            tooltip: 'Copy code',
                            icon: const Icon(Icons.copy_outlined, color: Color(0xFF0F52BA)),
                            onPressed: () => _copyToClipboard(
                              context,
                              _referralCode!,
                              'Referral code copied!',
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 12),
            ],

            // Track Downloads Generated
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF93C5FD), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.file_download_rounded, color: Color(0xFF1D4ED8), size: 22),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Registered with your referral code',
                        style: TextStyle(
                          color: Color(0xFF1E40AF),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_info?.totalDownloads ?? 0} Downloads'
                        '${_info != null ? '  •  ${_info!.todayDownloads} today' : ''}',
                        style: const TextStyle(
                          color: Color(0xFF1E3A8A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Barlow Condensed',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Share App Link Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _shareApp(context),
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
                  'Share Download Link',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Copy Link Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _downloadUrl.isEmpty
                    ? null
                    : () => _copyToClipboard(
                          context,
                          _downloadUrl,
                          'App download link copied to clipboard!',
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
                  'Copy Download Link',
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
