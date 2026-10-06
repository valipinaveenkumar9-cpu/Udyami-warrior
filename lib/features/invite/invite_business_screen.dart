import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'consent_&_otp_screen.dart';

class InviteBusinessScreen extends StatefulWidget {
  final Map<String, dynamic>? routeData;
  final double traveledDistanceMeters;
  final double totalDistanceMeters;

  const InviteBusinessScreen({
    super.key,
    this.routeData,
    this.traveledDistanceMeters = 0,
    this.totalDistanceMeters = 0,
  });

  @override
  State<InviteBusinessScreen> createState() => _InviteBusinessScreenState();
}

class _InviteBusinessScreenState extends State<InviteBusinessScreen> {
  String? _photoPath;

  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _photoPath = image.path;
      });
    }
  }

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
                          'Lakshmi Devi',
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
                  SizedBox(height: 12),
                  Text(
                    '2 of 3 · The business',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: context.colors.secondaryText,
                    ),
                  ),
                  SizedBox(height: 24),

                  // Business name
                  Text(
                    'Business name',
                    style: TextStyle(fontSize: 14, color: context.colors.primaryDarkBlue, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  _buildTextField('Sri Lakshmi Tailors'),
                  SizedBox(height: 16),

                  // Sector
                  Text(
                    'Sector',
                    style: TextStyle(fontSize: 14, color: context.colors.primaryDarkBlue, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  _buildTextField('Textiles & Apparel'),
                  SizedBox(height: 16),

                  // Sub-sector
                  Text(
                    'Sub-sector',
                    style: TextStyle(fontSize: 14, color: context.colors.primaryDarkBlue, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  _buildTextField('Tailoring & stitching'),
                  SizedBox(height: 16),

                  // Tags
                  Text(
                    'Tags',
                    style: TextStyle(fontSize: 14, color: context.colors.primaryDarkBlue, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 8,
                    children: [
                      _buildTag('Blouse work', isFilled: true),
                      _buildTag('Alterations', isFilled: true),
                      _buildAddTag(),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Row: Years running, People working
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Years running',
                              style: TextStyle(fontSize: 14, color: context.colors.primaryDarkBlue, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 8),
                            _buildTextField('8'),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'People working',
                              style: TextStyle(fontSize: 14, color: context.colors.primaryDarkBlue, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 8),
                            _buildTextField('2–5'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Photo of shop front
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _takePhoto,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _photoPath != null ? context.colors.greenSuccess : context.colors.lightGreyBlue,
                        foregroundColor: _photoPath != null ? context.colors.cardBackground : context.colors.primaryDarkBlue,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: Icon(_photoPath != null ? Icons.check : Icons.camera_alt_outlined, size: 20),
                      label: Text(_photoPath != null ? 'Photo added' : 'Photo of shop front', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Optional. Ask before taking a photo.',
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
                    MaterialPageRoute(builder: (context) => ConsentAndOtpScreen(
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
                child: Text('Next — consent', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String value) {
    return TextFormField(
      initialValue: value,
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
    );
  }

  Widget _buildTag(String label, {bool isFilled = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.primaryDarkBlue,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: context.colors.cardBackground,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAddTag() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        border: Border.all(color: context.colors.disabledBorder, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(4),
      ),
      child: RichText(
        text: TextSpan(
          text: '+ ',
          style: TextStyle(color: context.colors.primaryDarkBlue, fontWeight: FontWeight.bold, fontSize: 12),
          children: [
            TextSpan(
              text: 'Add',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
