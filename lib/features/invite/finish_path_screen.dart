import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'package:flutter/material.dart';
import '../../core/thems/app_colors.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../home/presentation/main_screen.dart';

class FinishPathScreen extends StatelessWidget {
  final String routeName;
  final double traveledDistanceMeters;
  final double totalDistanceMeters;

  const FinishPathScreen({
    super.key,
    required this.routeName,
    required this.traveledDistanceMeters,
    required this.totalDistanceMeters,
  });

  @override
  Widget build(BuildContext context) {
    double traveledKm = traveledDistanceMeters / 1000;
    double totalKm = totalDistanceMeters / 1000;
    
    String traveledText = traveledKm < 1.0 ? '${traveledDistanceMeters.toInt()} m' : '${traveledKm.toStringAsFixed(1)} km';
    String totalText = totalKm < 1.0 ? '${totalDistanceMeters.toInt()} m' : '${totalKm.toStringAsFixed(1)} km';
    String percentage = totalDistanceMeters > 0 
        ? '${((traveledDistanceMeters / totalDistanceMeters) * 100).clamp(0, 100).toInt()}%' 
        : '0%';

    return Scaffold(
      backgroundColor: context.colors.cardBackground,
      appBar: CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: Column(
        children: [
          // Sync state bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: context.colors.greenLight,
            child: Row(
              children: [
                Icon(Icons.cloud_done_outlined, size: 16, color: context.colors.greenDark),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'All 19 invites sent',
                    style: TextStyle(fontSize: 12, color: context.colors.greenDark, fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  '17:47',
                  style: TextStyle(fontSize: 12, color: context.colors.greenDark, fontFamily: 'monospace'),
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
                          'Finish path',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: context.colors.primaryDarkBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          routeName,
                          style: TextStyle(
                            fontSize: 16,
                            color: context.colors.secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Card 1: Your day
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.colors.cardBackground,
                      border: Border.all(color: context.colors.disabledBorder),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your day',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.colors.secondaryText),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            // Ring chart
                            SizedBox(
                              width: 74,
                              height: 74,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 74,
                                    height: 74,
                                    child: CircularProgressIndicator(
                                      value: 1.0,
                                      strokeWidth: 8,
                                      color: context.colors.lightGreyBlue,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 74,
                                    height: 74,
                                    child: CircularProgressIndicator(
                                      value: 19 / 20,
                                      strokeWidth: 8,
                                      color: context.colors.greenSuccess,
                                      strokeCap: StrokeCap.round,
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '19',
                                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.0, color: context.colors.primaryDarkBlue),
                                      ),
                                      Text(
                                        'of 20',
                                        style: TextStyle(fontSize: 10, color: context.colors.subtitleText),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            // Stats
                            Expanded(
                              child: Column(
                                children: [
                                  _buildStatRow('Distance covered', traveledText),
                                  SizedBox(height: 8),
                                  _buildStatRow('Total route length', totalText),
                                  SizedBox(height: 8),
                                  _buildStatRow('Completion', percentage),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),

                  // Banner 2: OK
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
                                'You reached $percentage of target route length',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.colors.greenDark),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Completion bonus of 200 points applies once the Ward Leader verifies your invites.',
                                style: TextStyle(fontSize: 13, height: 1.4, color: context.colors.greenDark),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),

                  // Card 3: What happens next
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.colors.cardBackground,
                      border: Border.all(color: context.colors.disabledBorder),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What happens next',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.colors.secondaryText),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Ravi Kumar checks each invite. You will see approved and rejected counts here, usually within 48 hours. Points appear as waiting to clear first.',
                          style: TextStyle(fontSize: 13, height: 1.5, color: context.colors.primaryDarkBlue),
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
                child: Text('Send for verification', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: AppColors.light.subtitleText),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.light.primaryDarkBlue),
        ),
      ],
    );
  }
}
