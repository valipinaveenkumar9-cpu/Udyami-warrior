import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:flutter/material.dart';
import '../../leads/leads_screen.dart';
import '../../path/path_screen.dart';
import '../../path/my_paths_screen.dart';
import '../../rewards/rewards_screen.dart';
import '../../expo/presentation/activities_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Default to Home

  final List<Widget> _screens = [
    PathScreen(),
    InvitesScreen(),
    MyPathsScreen(),
    RewardsScreen(),
    ActivitiesScreen(),
  ];

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? context.colors.primaryDarkBlue : Color(0xFF9FB2CE),
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? context.colors.primaryDarkBlue : Color(0xFF9FB2CE),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.colors.cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Color(0x0D000000), // 5% black
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home_outlined, 'Home'),
                  _buildNavItem(1, Icons.person_add_outlined, 'Invite'),
                  _buildNavItem(2, Icons.alt_route_rounded, 'Routes'),
                  _buildNavItem(3, Icons.card_giftcard, 'Rewards'),
                  _buildNavItem(4, Icons.assessment_outlined, 'Activities'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
