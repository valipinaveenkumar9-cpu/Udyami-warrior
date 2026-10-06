import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';
import 'show_me_the_way_back_screen.dart';

class InvitesOnPathScreen extends StatelessWidget {
  final Map<String, dynamic>? routeData;
  final double traveledDistanceMeters;
  final double totalDistanceMeters;

  const InvitesOnPathScreen({
    super.key,
    this.routeData,
    this.traveledDistanceMeters = 0,
    this.totalDistanceMeters = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.cardBackground,
      appBar: CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: Column(
        children: [
          // Offline Status Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: context.colors.lightGreyBlue,
            child: Row(
              children: [
                Icon(Icons.wifi_off, size: 16, color: context.colors.primaryDarkBlue),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '7 waiting to send',
                    style: TextStyle(fontSize: 13, color: context.colors.primaryDarkBlue),
                  ),
                ),
                Text(
                  'retry 2m',
                  style: TextStyle(fontSize: 13, color: context.colors.subtitleText),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.colors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.colors.lightGreyBlue),
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invites on this path',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: context.colors.primaryDarkBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gandhi Bazaar · 12',
                          style: TextStyle(
                            fontSize: 14,
                            color: context.colors.secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Success Banner
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.colors.greenLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check, color: context.colors.greenDark, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Saved on your phone',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.colors.greenDark),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Lakshmi Devi · will send automatically when you get signal. Nothing is lost.',
                                style: TextStyle(fontSize: 13, height: 1.4, color: context.colors.greenDark),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Invites List Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.colors.cardBackground,
                      border: Border.all(color: context.colors.disabledBorder),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildInviteRow(
                          initials: 'LD',
                          avatarBgColor: context.colors.orangeLight,
                          avatarTextColor: context.colors.orangeDark,
                          title: 'Lakshmi Devi',
                          subtitle: 'Sri Lakshmi Tailors · just now',
                          chipText: 'On phone',
                          chipBgColor: context.colors.orangeLight,
                          chipTextColor: context.colors.orangeDark,
                        ),
                        _buildDivider(),
                        _buildInviteRow(
                          initials: 'MR',
                          avatarBgColor: context.colors.orangeLight,
                          avatarTextColor: context.colors.orangeDark,
                          title: 'Manjunath R',
                          subtitle: 'Sagar Provisions · 12:58',
                          chipText: 'On phone',
                          chipBgColor: context.colors.orangeLight,
                          chipTextColor: context.colors.orangeDark,
                        ),
                        _buildDivider(),
                        _buildInviteRow(
                          initials: 'SB',
                          avatarBgColor: context.colors.greenLight,
                          avatarTextColor: context.colors.greenDark,
                          title: 'Sunita B',
                          subtitle: 'Approved · +75 points',
                          chipText: 'Verified',
                          chipBgColor: context.colors.greenSuccess,
                          chipTextColor: context.colors.cardBackground,
                        ),
                        _buildDivider(),
                        _buildInviteRow(
                          initials: 'PK',
                          avatarBgColor: context.colors.redWarningLight,
                          avatarTextColor: context.colors.redWarning,
                          title: 'Prakash K',
                          subtitle: 'Already a member since 2024',
                          chipText: 'Duplicate',
                          chipBgColor: context.colors.redWarningDark,
                          chipTextColor: context.colors.cardBackground,
                        ),
                        _buildDivider(),
                        _buildInviteRow(
                          initials: 'RS',
                          avatarBgColor: Color(0xFFE5EAF3),
                          avatarTextColor: context.colors.primaryDarkBlue,
                          title: 'Ramesh S',
                          subtitle: 'OTP not confirmed · 2 days left',
                          chipText: 'Waiting',
                          chipBgColor: context.colors.lightGreyBlue,
                          chipTextColor: context.colors.primaryDarkBlue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom action
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.cardBackground,
              border: Border(top: BorderSide(color: context.colors.lightGreyBlue)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InviteOutsidePathScreen(
                      routeData: routeData,
                      traveledDistanceMeters: traveledDistanceMeters,
                      totalDistanceMeters: totalDistanceMeters,
                    )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.lightGreyBlue,
                  foregroundColor: context.colors.primaryDarkBlue,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: Icon(Icons.add, size: 20),
                label: Text('Invite next shop', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: AppColors.light.lightGreyBlue,
      margin: EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildInviteRow({
    required String initials,
    required Color avatarBgColor,
    required Color avatarTextColor,
    required String title,
    required String subtitle,
    required String chipText,
    required Color chipBgColor,
    required Color chipTextColor,
  }) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: avatarBgColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              initials,
              style: TextStyle(
                color: avatarTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
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
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.light.primaryDarkBlue,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.light.subtitleText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: chipBgColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              chipText,
              style: TextStyle(
                color: chipTextColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
