import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'package:flutter/material.dart';
import '../../core/thems/app_colors.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../path/path_screen.dart';
import 'referrals_screen.dart';

class ReferScreen extends StatelessWidget {
  const ReferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      appBar: CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.colors.lightGreyBlue),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Refer & earn',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: context.colors.primaryDarkBlue,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('You have earned 500 bonus points this week!'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: context.colors.greenSuccess,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.colors.lightGreyBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.notifications_none_outlined, size: 24, color: context.colors.primaryDarkBlue),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // QR Code Card
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.cardBackground,
              border: Border.all(color: context.colors.lightGreyBlue),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Your code',
                  style: TextStyle(
                    color: Color(0xFF5A6B87),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'CP12345',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Mono',
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2.1,
                    color: context.colors.primaryDarkBlue,
                  ),
                ),
                SizedBox(height: 16),
                Icon(
                  Icons.qr_code_2,
                  size: 150,
                  color: context.colors.primaryDarkBlue,
                ),
                SizedBox(height: 16),
                Text(
                  'Let them scan this. It opens the Udyami Kutumba app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Color(0xFF5A6B87)),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReferralsScreen(),
                        ),
                      );
                    },
                    icon: Icon(Icons.share_outlined, size: 20),
                    label: Text('Share on WhatsApp'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.lightGreyBlue,
                      foregroundColor: context.colors.secondaryText,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),

          // How you get paid Card
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
                // Text(
                //   'How you get paid',
                //   style: TextStyle(
                //     fontSize: 14,
                //     fontWeight: FontWeight.w600,
                //     color: context.colors.secondaryText,
                //   ),
                // ),
                SizedBox(height: 16),
                _buildPayoutRow(
                  context,
                  number: '1',
                  bgColor: context.colors.orangeLight,
                  fgColor: context.colors.orangeDark,
                  title: 'They install and sign up',
                  subtitle: 'with OTP',
                  points: '+10',
                  pointsColor: Color(0xFFB87A0E), // turmeric-d
                ),
                Divider(color: context.colors.lightGreyBlue, height: 24),
                _buildPayoutRow(
                  context,
                  number: '2',
                  bgColor: Color(0xFFE4F1EA),
                  fgColor: context.colors.greenDark,
                  title: 'They fill their profile and come back',
                  subtitle: 'within 7 days',
                  points: '+40',
                  pointsColor: context.colors.greenSuccess, // stamp / pos
                ),
                Divider(color: context.colors.lightGreyBlue, height: 24),
                _buildPayoutRow(
                  context,
                  number: '3',
                  bgColor: context.colors.primaryDarkBlue,
                  fgColor: context.colors.cardBackground,
                  title: 'They take paid membership',
                  subtitle: 'within 90 days',
                  points: '+300',
                  pointsColor: context.colors.greenSuccess, // pos
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutRow(
    BuildContext context, {
    required String number,
    required Color bgColor,
    required Color fgColor,
    required String title,
    required String subtitle,
    required String points,
    required Color pointsColor,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReferralsScreen()),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(
            number,
            style: TextStyle(
              color: fgColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
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
                  color: context.colors.primaryDarkBlue,
                ),
              ),
              SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Color(0xFF5A6B87)),
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
