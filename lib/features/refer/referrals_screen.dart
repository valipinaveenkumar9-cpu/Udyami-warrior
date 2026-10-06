import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';

class ReferralsScreen extends StatelessWidget {
  const ReferralsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      appBar: CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Funnel Card
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.cardBackground,
              border: Border.all(color: context.colors.lightGreyBlue),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What happened to your 18 shares',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5A6B87),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12),
                _buildFunnelRow('Opened', 1.0, context.colors.secondaryText, '14'),
                SizedBox(height: 8),
                _buildFunnelRow(
                  'Installed',
                  0.64,
                  context.colors.secondaryText,
                  '9',
                ),
                SizedBox(height: 8),
                _buildFunnelRow(
                  'Signed up',
                  0.50,
                  context.colors.orangeWarning,
                  '7',
                ),
                SizedBox(height: 8),
                _buildFunnelRow('Active', 0.29, context.colors.greenSuccess, '4'),
              ],
            ),
          ),
          SizedBox(height: 12),

          // Referrals List Card
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.cardBackground,
              border: Border.all(color: context.colors.lightGreyBlue),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildReferralRow(
                  iconStr: '✓',
                  bgColor: Color(0xFFE4F1EA),
                  fgColor: context.colors.greenDark,
                  title: '+91 90XXX 41',
                  subtitle: 'Active · profile filled',
                  points: '+50',
                  pointsColor: context.colors.greenSuccess,
                ),
                Divider(color: context.colors.lightGreyBlue, height: 24),
                _buildReferralRow(
                  iconStr: '⏱',
                  bgColor: context.colors.orangeLight,
                  fgColor: context.colors.orangeDark,
                  title: '+91 87XXX 09',
                  subtitle: 'Signed up · 4 days left to become active',
                  points: '+10',
                  pointsColor: Color(0xFFB87A0E),
                ),
                Divider(color: context.colors.lightGreyBlue, height: 24),
                _buildReferralRow(
                  iconStr: '—',
                  bgColor: Color(0xFFE5EAF3),
                  fgColor: context.colors.secondaryText,
                  title: '+91 99XXX 22',
                  subtitle: 'Did not become active in 7 days',
                  points: '+10',
                  pointsColor: Color(0xFF9FB2CE),
                  dimmed: true,
                ),
                Divider(color: context.colors.lightGreyBlue, height: 24),
                _buildReferralRow(
                  iconStr: '!',
                  bgColor: Color(0xFFFDE3E1),
                  fgColor: context.colors.redWarning,
                  title: '+91 80XXX 77',
                  subtitle: 'Not counted — same phone as your login',
                  points: '0',
                  pointsColor: Color(0xFF9FB2CE),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Referrals must be real people on their own phone. Sign-ups on your own device are not counted.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF5A6B87),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunnelRow(
    String label,
    double fraction,
    Color color,
    String count,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 58,
          child: Text(
            label,
            style: TextStyle(fontSize: 11, color: Color(0xFF5A6B87)),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 19,
            decoration: BoxDecoration(
              color: AppColors.light.lightGreyBlue,
              borderRadius: BorderRadius.circular(3),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: fraction,
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        SizedBox(
          width: 20,
          child: Text(
            count,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'IBM Plex Mono',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.light.primaryDarkBlue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReferralRow({
    required String iconStr,
    required Color bgColor,
    required Color fgColor,
    required String title,
    required String subtitle,
    required String points,
    required Color pointsColor,
    bool dimmed = false,
  }) {
    return Opacity(
      opacity: dimmed ? 0.7 : 1.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              iconStr,
              style: TextStyle(
                color: fgColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.light.primaryDarkBlue,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5A6B87),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Text(
            points,
            style: TextStyle(
              color: pointsColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
