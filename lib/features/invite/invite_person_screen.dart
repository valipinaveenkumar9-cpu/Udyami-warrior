import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';
import 'invite_business_screen.dart';


class InvitePersonScreen extends StatefulWidget {
  final Map<String, dynamic>? routeData;
  final double traveledDistanceMeters;
  final double totalDistanceMeters;

  const InvitePersonScreen({
    super.key,
    this.routeData,
    this.traveledDistanceMeters = 0,
    this.totalDistanceMeters = 0,
  });

  @override
  State<InvitePersonScreen> createState() => _InvitePersonScreenState();
}

class _InvitePersonScreenState extends State<InvitePersonScreen> {
  String _selectedGender = 'Woman';
  String _runsBusiness = 'Yes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.cardBackground,
      appBar: CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: Column(
        children: [
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: context.colors.lightGreyBlue,
            child: Row(
              children: [
                Icon(Icons.wifi_off, size: 16, color: context.colors.primaryDarkBlue),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Offline — this will save on your phone',
                    style: TextStyle(fontSize: 13, color: context.colors.primaryDarkBlue),
                  ),
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
                          'New invite',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: context.colors.primaryDarkBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gandhi Bazaar · stop 13',
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
                          color: context.colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(color: context.colors.disabledBorder, width: 1.5),
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
                  SizedBox(height: 12),
                  Text(
                    '1 of 3 · About the person',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: context.colors.secondaryText,
                    ),
                  ),
                  SizedBox(height: 24),

                  // Full name
                  RichText(
                    text: TextSpan(
                      text: 'Full name ',
                      style: TextStyle(fontSize: 14, color: context.colors.primaryDarkBlue, fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(text: '*', style: TextStyle(color: context.colors.redWarningDark)),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    initialValue: 'Lakshmi Devi',
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: context.colors.pageBackground,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: context.colors.disabledBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: context.colors.disabledBorder),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Mobile number
                  RichText(
                    text: TextSpan(
                      text: 'Mobile number ',
                      style: TextStyle(fontSize: 14, color: context.colors.primaryDarkBlue, fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(text: '*', style: TextStyle(color: context.colors.redWarningDark)),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    initialValue: '+91 99001 27384',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 15),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: context.colors.pageBackground,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: context.colors.disabledBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: context.colors.disabledBorder),
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '✓ New number — not registered before',
                    style: TextStyle(fontSize: 12, color: context.colors.greenDark),
                  ),
                  SizedBox(height: 20),

                  // Gender
                  RichText(
                    text: TextSpan(
                      text: 'Gender ',
                      style: TextStyle(fontSize: 14, color: context.colors.primaryDarkBlue, fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(text: '*', style: TextStyle(color: context.colors.redWarningDark)),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSegment('Woman', _selectedGender == 'Woman', (val) {
                        setState(() => _selectedGender = val);
                      }),
                      SizedBox(width: 8),
                      _buildSegment('Man', _selectedGender == 'Man', (val) {
                        setState(() => _selectedGender = val);
                      }),
                      SizedBox(width: 8),
                      _buildSegment('Other', _selectedGender == 'Other', (val) {
                        setState(() => _selectedGender = val);
                      }),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Do they run a business?
                  Text(
                    'Do they run a business?',
                    style: TextStyle(fontSize: 14, color: context.colors.primaryDarkBlue, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSegment('Yes', _runsBusiness == 'Yes', (val) {
                        setState(() => _runsBusiness = val);
                      }),
                      SizedBox(width: 8),
                      _buildSegment('No', _runsBusiness == 'No', (val) {
                        setState(() => _runsBusiness = val);
                      }),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Business details add 25 points when verified.',
                    style: TextStyle(fontSize: 12, color: context.colors.subtitleText),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InviteBusinessScreen(
                      routeData: widget.routeData,
                      traveledDistanceMeters: widget.traveledDistanceMeters,
                      totalDistanceMeters: widget.totalDistanceMeters,
                    )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.secondaryText,
                  foregroundColor: context.colors.cardBackground,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Next — business', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegment(String label, bool isSelected, Function(String) onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(label),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? context.colors.primaryDarkBlue : context.colors.cardBackground,
            border: Border.all(color: isSelected ? context.colors.primaryDarkBlue : context.colors.disabledBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? context.colors.cardBackground : context.colors.primaryDarkBlue,
            ),
          ),
        ),
      ),
    );
  }
}
