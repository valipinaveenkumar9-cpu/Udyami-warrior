import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_menu_drawer.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  int _selectedTab = 0; // 0 for Invitations, 1 for Downloads

  // Mock data for invitations/registrations
  final List<Map<String, dynamic>> _invitationsList = [
    {
      'name': 'Suresh Kumar',
      'phone': '+91 98765 43210',
      'category': 'Visitor',
      'sector': 'N/A',
      'time': 'Today, 02:30 PM',
      'status': 'Verified',
    },
    {
      'name': 'Kavitha M',
      'phone': '+91 91234 56789',
      'category': 'Stall',
      'sector': 'Agro & Food Processing',
      'time': 'Yesterday, 04:45 PM',
      'status': 'Approved',
    },
    {
      'name': 'Anand Raj',
      'phone': '+91 99887 76655',
      'category': 'Sponsor',
      'sector': 'Healthcare & Pharma',
      'time': '28 Sep, 11:15 AM',
      'status': 'Confirmed',
    },
    {
      'name': 'Priya Nair',
      'phone': '+91 94433 22110',
      'category': 'Visitor',
      'sector': 'N/A',
      'time': '27 Sep, 01:20 PM',
      'status': 'Verified',
    },
  ];

  // Mock data for app downloads
  final List<Map<String, dynamic>> _downloadsList = [
    {
      'name': 'K. Selvam',
      'phone': '+91 97766 55443',
      'profileStatus': '100% Complete (KYC Verified)',
      'statusColor': const Color(0xFF16A34A),
      'time': 'Today, 02:15 PM',
    },
    {
      'name': 'Suresh G',
      'phone': '+91 96655 44332',
      'profileStatus': '85% Complete (Bank Details Added)',
      'statusColor': const Color(0xFF2563EB),
      'time': '29 Sep, 03:30 PM',
    },
    {
      'name': 'Ramesh Kumar',
      'phone': '+91 95544 33221',
      'profileStatus': '50% Complete (Basic Info Only)',
      'statusColor': const Color(0xFFD97706),
      'time': '25 Sep, 05:10 PM',
    },
    {
      'name': 'Deepak S',
      'phone': '+91 94433 22119',
      'profileStatus': '100% Complete (KYC Verified)',
      'statusColor': const Color(0xFF16A34A),
      'time': '27 Sep, 09:20 AM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: const CustomAppBar(showBackArrow: false),
      endDrawer: const CustomMenuDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            const Text(
              'CP Activities & Referrals',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),

            // Top Summary Card (Total Numbers)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0E5C4A),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryMetric(
                    title: 'Total Downloads',
                    value: '96',
                    icon: Icons.file_download_outlined,
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.white24,
                  ),
                  _buildSummaryMetric(
                    title: 'Total Registrations',
                    value: '320',
                    icon: Icons.how_to_reg_rounded,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Two Slider-wise Toggle Buttons (Tabs)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedTab == 0 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _selectedTab == 0
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          'Invitations (${_invitationsList.length})',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _selectedTab == 0 ? const Color(0xFF0E5C4A) : const Color(0xFF64748B),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedTab == 1 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _selectedTab == 1
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          'App Downloads (${_downloadsList.length})',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _selectedTab == 1 ? const Color(0xFF0E5C4A) : const Color(0xFF64748B),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // List Content based on Selected Tab
            if (_selectedTab == 0) ...[
              const Text(
                'Expo Registrations under your QR Code',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E2A44)),
              ),
              const SizedBox(height: 12),
              ..._invitationsList.map((item) => _buildInvitationCard(item)),
            ] else ...[
              const Text(
                'App Downloads under your QR Code',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E2A44)),
              ),
              const SizedBox(height: 12),
              ..._downloadsList.map((item) => _buildDownloadCard(item)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryMetric({required String title, required String value, required IconData icon}) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 18),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: 'Barlow Condensed',
          ),
        ),
      ],
    );
  }

  Widget _buildInvitationCard(Map<String, dynamic> item) {
    final category = item['category'] as String;
    Color badgeColor;
    if (category == 'Visitor') {
      badgeColor = const Color(0xFF16A34A);
    } else if (category == 'Stall') {
      badgeColor = const Color(0xFF2563EB);
    } else {
      badgeColor = const Color(0xFFE86A23);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: badgeColor.withOpacity(0.12),
            child: Icon(Icons.person, color: badgeColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['name'],
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(color: badgeColor, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item['phone'],
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                if (category != 'Visitor') ...[
                  const SizedBox(height: 4),
                  Text(
                    'Sector: ${item['sector']}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF334155)),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['time'],
                      style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                    ),
                    Text(
                      item['status'],
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadCard(Map<String, dynamic> item) {
    final statusColor = item['statusColor'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFDBEAFE),
            child: const Icon(Icons.file_download_outlined, color: Color(0xFF2563EB), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['name'],
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    Text(
                      item['time'],
                      style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item['phone'],
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline, size: 14, color: statusColor),
                      const SizedBox(width: 6),
                      Text(
                        'Profile Status: ${item['profileStatus']}',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
