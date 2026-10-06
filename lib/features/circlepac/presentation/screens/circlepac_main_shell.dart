import 'package:flutter/material.dart';
import '../../theme/circlepac_colors.dart';
import 'voter_database_screen.dart';

class CirclepacMainShell extends StatefulWidget {
  final String? companyName;
  const CirclepacMainShell({super.key, this.companyName});

  @override
  State<CirclepacMainShell> createState() => _CirclepacMainShellState();
}

class _CirclepacMainShellState extends State<CirclepacMainShell> {
  int _selectedMenuIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'Voter Data Base',
      'icon': Icons.people_alt_outlined,
      'subtitle': 'Bulk import, export, voter categories & survey',
    },
    {
      'title': 'Roles',
      'icon': Icons.admin_panel_settings_outlined,
      'subtitle': 'Add root roles for constituency from grass level',
    },
    {
      'title': 'User',
      'icon': Icons.person_add_alt_1_outlined,
      'subtitle': 'User management across constituencies',
    },
    {
      'title': 'Campaign Management',
      'icon': Icons.campaign_outlined,
      'subtitle': 'Volunteers, canvassing app, booth management',
    },
    {
      'title': 'Communication',
      'icon': Icons.mark_chat_read_outlined,
      'subtitle': 'Bulk SMS/Email, auto dialer, WhatsApp panel',
    },
    {
      'title': 'Data Analytics',
      'icon': Icons.analytics_outlined,
      'subtitle': 'Live dashboard, voter sentiment heatmap, booth analytics',
    },
    {
      'title': 'Digital & Media',
      'icon': Icons.public_outlined,
      'subtitle': 'Website builder, social listening, ad manager',
    },
    {
      'title': 'Fundraising',
      'icon': Icons.volunteer_activism_outlined,
      'subtitle': 'Donor management, donation tracking & compliance',
    },
    {
      'title': 'Ground Intelligence',
      'icon': Icons.travel_explore_outlined,
      'subtitle': 'Survey creator, live geo-tracking, field reporting',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CirclepacColors.pageBg,
      appBar: AppBar(
        backgroundColor: CirclepacColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CIRCLEPAC',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              _menuItems[_selectedMenuIndex]['title'],
              style: const TextStyle(fontSize: 11, color: Color(0xFFD1FAE5)),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              color: CirclepacColors.primaryDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: CirclepacColors.primaryGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.how_to_vote, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CIRCLEPAC',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            'Campaign & Political PAC Suite',
                            style: TextStyle(color: CirclepacColors.activeGreenBorder, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: _menuItems.length,
                separatorBuilder: (ctx, i) => const Divider(height: 1, color: CirclepacColors.dividerCol),
                itemBuilder: (ctx, i) {
                  final item = _menuItems[i];
                  final isSelected = _selectedMenuIndex == i;

                  return ListTile(
                    dense: true,
                    selected: isSelected,
                    selectedTileColor: CirclepacColors.activeGreenBg,
                    leading: Icon(
                      item['icon'] as IconData,
                      color: isSelected ? CirclepacColors.primaryGreen : CirclepacColors.textMuted,
                      size: 22,
                    ),
                    title: Text(
                      item['title'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? CirclepacColors.primaryGreen : CirclepacColors.primaryDark,
                      ),
                    ),
                    trailing: i == 0
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: CirclepacColors.activeGreenBg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: CirclepacColors.activeGreenBorder),
                            ),
                            child: const Text(
                              'Active',
                              style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: CirclepacColors.primaryGreen),
                            ),
                          )
                        : null,
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() => _selectedMenuIndex = i);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: _selectedMenuIndex == 0
          ? const VoterDatabaseScreen()
          : _buildPlaceholderModule(_menuItems[_selectedMenuIndex]),
    );
  }

  Widget _buildPlaceholderModule(Map<String, dynamic> item) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: CirclepacColors.activeGreenBg,
                shape: BoxShape.circle,
              ),
              child: Icon(item['icon'] as IconData, size: 48, color: CirclepacColors.primaryGreen),
            ),
            const SizedBox(height: 16),
            Text(
              item['title'] as String,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CirclepacColors.primaryDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item['subtitle'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: CirclepacColors.textBody, height: 1.4),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() => _selectedMenuIndex = 0);
              },
              icon: const Icon(Icons.people, size: 18, color: Colors.white),
              label: const Text('Go to Voter Data Base', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: CirclepacColors.primaryGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
