

import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';
import '../../home/presentation/main_screen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      appBar: CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(12),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: context.colors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.colors.disabledBorder),
                ),
                child: Column(
                  children: [
                    _buildMessageRow(
                      iconWidget: Icon(Icons.report_problem_outlined, color: context.colors.redWarning, size: 18),
                      iconBgColor: Color(0xFFFCE8E6),
                      title: 'One invite needs a second look',
                      subtitle: 'Kumar M · under review by Taluka office',
                      onTap: () {},
                    ),
                    _buildMessageRow(
                      iconWidget: Icon(Icons.check, color: context.colors.greenDark, size: 18),
                      iconBgColor: context.colors.greenLight,
                      title: '17 invites approved',
                      subtitle: 'Shankarapuram Beat 1 · +1,462 points',
                    ),
                    _buildMessageRow(
                      iconWidget: Icon(Icons.map_outlined, color: context.colors.secondaryText, size: 18),
                      iconBgColor: Color(0xFFE5EAF3),
                      title: 'New path for you',
                      subtitle: 'Basavanagudi · accept by 6:00 pm',
                    ),
                    _buildMessageRow(
                      iconWidget: Text(
                        '₹',
                        style: TextStyle(
                          color: context.colors.orangeDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      iconBgColor: context.colors.orangeLight,
                      title: '₹1,900 sent to your UPI',
                      subtitle: 'UTR 5288301947 · 29 Jul',
                      isMonoSubtitle: true,
                    ),
                    _buildMessageRow(
                      iconWidget: Icon(Icons.card_giftcard, color: context.colors.secondaryText, size: 18),
                      iconBgColor: Color(0xFFE5EAF3),
                      title: '1,275 points cleared',
                      subtitle: 'You can redeem them now',
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildPersistentSheet(context),
        ],
      ),
    );
  }

  Widget _buildMessageRow({
    required Widget iconWidget,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    bool isMonoSubtitle = false,
    bool isLast = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: isLast ? null : Border(bottom: BorderSide(color: AppColors.light.lightGreyBlue)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: iconWidget,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.light.primaryDarkBlue,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: isMonoSubtitle ? 11 : 13,
                      color: AppColors.light.subtitleText,
                      fontFamily: isMonoSubtitle ? 'monospace' : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersistentSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: context.colors.disabledBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xFFFCE8E6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Under review',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.colors.redWarning,
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Kumar M · Gandhi Bazaar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.colors.primaryDarkBlue,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'The location on this invite did not match your path. The Taluka office is checking it. Nothing is needed from you yet — you can add a note if you want.',
            style: TextStyle(
              fontSize: 14,
              color: context.colors.secondaryText,
              height: 1.5,
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.lightGreyBlue,
                    foregroundColor: context.colors.primaryDarkBlue,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Add a note', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primaryDarkBlue,
                    foregroundColor: context.colors.cardBackground,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Got it', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
