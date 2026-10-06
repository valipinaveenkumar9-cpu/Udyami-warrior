import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      appBar: CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Podium Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.colors.disabledBorder),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildPodiumBar('2', 'Shruthi H', 80, context.colors.disabledBorder, context.colors.secondaryText),
                        SizedBox(width: 8),
                        _buildPodiumBar('1', 'Nikhil', 100, context.colors.orangeWarning, Color(0xFF3A2A05)),
                        SizedBox(width: 8),
                        _buildPodiumBar('3', 'Imran S', 60, context.colors.disabledBorder, context.colors.secondaryText),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Ranked on verified registrations, not invites sent.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: context.colors.subtitleText),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            // Ranks List Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.colors.disabledBorder),
              ),
              child: Column(
                children: [
                  _buildRankRow(
                    rank: '1',
                    name: 'You',
                    subtitle: '41 verified · 96% clean',
                    amount: '41',
                    isHighlight: true,
                  ),
                  _buildRankRow(
                    rank: '2',
                    name: 'Shruthi H',
                    subtitle: '38 verified',
                    amount: '38',
                  ),
                  _buildRankRow(
                    rank: '3',
                    name: 'Imran S',
                    subtitle: '31 verified',
                    amount: '31',
                  ),
                  _buildRankRow(
                    rank: '4',
                    name: 'Geetha M',
                    subtitle: '24 verified',
                    amount: '24',
                    isLast: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            // Next Tier Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colors.pageBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.colors.disabledBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next tier',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.colors.secondaryText),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'Platinum',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.colors.primaryDarkBlue),
                      ),
                      Text(
                        '122 / 150',
                        style: TextStyle(fontSize: 11, color: context.colors.subtitleText, fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 7,
                    decoration: BoxDecoration(
                      color: context.colors.lightGreyBlue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 122 / 150,
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.colors.primaryDarkBlue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '28 more verified registrations for × 1.10 on every point.',
                    style: TextStyle(fontSize: 11, color: context.colors.subtitleText),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodiumBar(String rank, String name, double height, Color color, Color textColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 48,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
          ),
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 8),
          child: Text(
            rank,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
          ),
        ),
        SizedBox(height: 6),
        Text(
          name,
          style: TextStyle(fontSize: 11, color: AppColors.light.subtitleText),
        ),
      ],
    );
  }

  Widget _buildRankRow({
    required String rank,
    required String name,
    required String subtitle,
    required String amount,
    bool isHighlight = false,
    bool isLast = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: isHighlight ? 8 : 0),
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isHighlight ? Color(0xFFFFF8EC) : Colors.transparent,
        borderRadius: isHighlight ? BorderRadius.circular(7) : null,
        border: (isLast || isHighlight) ? null : Border(bottom: BorderSide(color: AppColors.light.lightGreyBlue)),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isHighlight ? AppColors.light.orangeWarning : AppColors.light.pageBackground,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              rank,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isHighlight ? Color(0xFF3A2A05) : AppColors.light.secondaryText,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.light.primaryDarkBlue),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: AppColors.light.subtitleText),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.light.primaryDarkBlue),
          ),
        ],
      ),
    );
  }
}
