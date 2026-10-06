import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';
import 'invites_on_path_screen.dart';

class ConsentAndOtpScreen extends StatefulWidget {
  final Map<String, dynamic>? routeData;
  final double traveledDistanceMeters;
  final double totalDistanceMeters;

  const ConsentAndOtpScreen({
    super.key,
    this.routeData,
    this.traveledDistanceMeters = 0,
    this.totalDistanceMeters = 0,
  });

  @override
  State<ConsentAndOtpScreen> createState() => _ConsentAndOtpScreenState();
}

class _ConsentAndOtpScreenState extends State<ConsentAndOtpScreen> {
  bool _agreed = true;
  bool _otpConfirmed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.cardBackground,
      appBar: CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
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
                          'Consent & OTP',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: context.colors.primaryDarkBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Show this to Lakshmi Devi',
                          style: TextStyle(
                            fontSize: 14,
                            color: context.colors.secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Steps indicator
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: context.colors.primaryDarkBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: context.colors.primaryDarkBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: context.colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(color: context.colors.disabledBorder, width: 1.5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Consent Card
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
                          'Please read this aloud',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.colors.secondaryText),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'FC Bizztech Pvt Ltd will use your name, mobile number and business details to register you as an Udyami Kutumba member and to send you member services.',
                          style: TextStyle(fontSize: 13, height: 1.5, color: context.colors.primaryDarkBlue),
                        ),
                        SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 80,
                              child: Text('Kept for', style: TextStyle(fontSize: 13, color: context.colors.subtitleText)),
                            ),
                            Expanded(
                              child: Text('As long as you are a member', style: TextStyle(fontSize: 13, color: context.colors.primaryDarkBlue)),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 80,
                              child: Text('You can', style: TextStyle(fontSize: 13, color: context.colors.subtitleText)),
                            ),
                            Expanded(
                              child: Text('See, correct or delete it anytime', style: TextStyle(fontSize: 13, color: context.colors.primaryDarkBlue)),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => setState(() => _agreed = !_agreed),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: context.colors.pageBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: _agreed,
                                    activeColor: context.colors.greenSuccess,
                                    onChanged: (val) {
                                      if (val != null) setState(() => _agreed = val);
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Lakshmi Devi agrees to register',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.colors.primaryDarkBlue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'notice v2.1 · kn · 31-07-2026 13:26 · 12.9512,77.5730',
                          style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: context.colors.subtitleText),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // OTP Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.colors.pageBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.colors.disabledBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Confirm with OTP',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.colors.secondaryText),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _otpConfirmed = true;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildOtpBox('4', isFilled: true),
                              _buildOtpBox('9', isFilled: true),
                              _buildOtpBox('1', isFilled: true),
                              _buildOtpBox(_otpConfirmed ? '8' : '', isFilled: _otpConfirmed, isCurrent: !_otpConfirmed),
                              _buildOtpBox(_otpConfirmed ? '2' : '', isFilled: _otpConfirmed),
                              _buildOtpBox(_otpConfirmed ? '5' : '', isFilled: _otpConfirmed),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Sent to +91 99001 27384. Ask her to read it out. (Tap boxes to type)',
                          style: TextStyle(fontSize: 12, color: context.colors.subtitleText),
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
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _otpConfirmed
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => InvitesOnPathScreen(
                                routeData: widget.routeData,
                                traveledDistanceMeters: widget.traveledDistanceMeters,
                                totalDistanceMeters: widget.totalDistanceMeters,
                              )),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primaryDarkBlue,
                      foregroundColor: context.colors.cardBackground,
                      disabledBackgroundColor: context.colors.lightGreyBlue,
                      disabledForegroundColor: context.colors.subtitleText,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Save invite', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'No signal? Save now and confirm OTP within 3 days.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: context.colors.subtitleText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpBox(String digit, {bool isFilled = false, bool isCurrent = false}) {
    return Container(
      width: 44,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        border: Border.all(
          color: isCurrent ? context.colors.secondaryText : context.colors.disabledBorder,
          width: isCurrent ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        digit,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: context.colors.primaryDarkBlue,
        ),
      ),
    );
  }
}
