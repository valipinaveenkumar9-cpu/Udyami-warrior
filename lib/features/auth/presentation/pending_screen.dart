import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';
import 'success_screen.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.lightGreyBlue,
      appBar: CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info Banner
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.colors.primaryDarkBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.schedule, color: context.colors.cardBackground, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('With the Ward Leader', style: TextStyle(color: context.colors.cardBackground, fontWeight: FontWeight.bold, fontSize: 15)),
                          SizedBox(height: 4),
                          Text(
                            'Ravi Kumar is reviewing your application. You will get a message when it moves forward.',
                            style: TextStyle(color: Color(0xFF9FB2CE), fontSize: 13, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),

              // Progress Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.colors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.colors.disabledBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Progress', style: TextStyle(color: context.colors.primaryDarkBlue, fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    _buildTimelineRow(
                      icon: Icon(Icons.check, color: context.colors.greenSuccess, size: 16),
                      iconBg: Color(0xFFE8F5E9),
                      title: 'Details & documents',
                      subtitle: 'Submitted 31 Jul, 9:51 am',
                      isCompleted: true,
                    ),
                    SizedBox(height: 16),
                    _buildTimelineRow(
                      icon: Text('2', style: TextStyle(color: context.colors.orangeDark, fontWeight: FontWeight.bold)),
                      iconBg: context.colors.orangeLight,
                      title: 'Ward Leader recommendation',
                      subtitle: 'In progress',
                      trailing: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: context.colors.orangeLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('Now', style: TextStyle(color: context.colors.orangeDark, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildTimelineRow(
                      icon: Text('3', style: TextStyle(color: context.colors.primaryDarkBlue, fontWeight: FontWeight.bold)),
                      iconBg: context.colors.lightGreyBlue,
                      title: 'Taluka Head appointment',
                      subtitle: 'Not started',
                      isFaded: true,
                    ),
                    SizedBox(height: 16),
                    _buildTimelineRow(
                      icon: Text('4', style: TextStyle(color: context.colors.primaryDarkBlue, fontWeight: FontWeight.bold)),
                      iconBg: context.colors.lightGreyBlue,
                      title: 'Training & assessment',
                      subtitle: 'Required before your first path',
                      isFaded: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),

              // Action Card
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
                    Text('Start training now', style: TextStyle(color: context.colors.primaryDarkBlue, fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(
                      '4 short modules, about 20 minutes. Finishing early means you can accept a path the day you are appointed.',
                      style: TextStyle(color: Color(0xFF6B7B96), fontSize: 14, height: 1.4),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: context.colors.disabledBorder),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SuccessScreen()),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: context.colors.cardBackground,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Open training', style: TextStyle(color: context.colors.primaryDarkBlue, fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineRow({
    required Widget icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    Widget? trailing,
    bool isCompleted = false,
    bool isFaded = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: icon,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Opacity(
            opacity: isFaded ? 0.55 : 1.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.light.primaryDarkBlue)),
                SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Color(0xFF6B7B96))),
              ],
            ),
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }
}
