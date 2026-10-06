import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'dart:io';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'pending_screen.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.lightGreyBlue,
      appBar: CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step indicator
                    Row(
                      children: [
                        _buildStepIndicator(true, true),
                        _buildStepIndicator(true, true),
                        _buildStepIndicator(true, false),
                        _buildStepIndicator(false, false),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Card 1: Identity proof
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Identity proof', style: TextStyle(color: context.colors.primaryDarkBlue, fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(Icons.check, color: context.colors.greenSuccess, size: 18),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('aadhaar_front.jpg', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    Text('412 KB · uploaded', style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFF6B7B96))),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text('Added', style: TextStyle(color: context.colors.greenSuccess, fontSize: 12, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            'We store only the last 4 digits. The full number is never saved.',
                            style: TextStyle(color: Color(0xFF6B7B96), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Card 2: Payout account
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Payout account', style: TextStyle(color: context.colors.primaryDarkBlue, fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 12),
                          Text('UPI ID or bank account', style: TextStyle(color: Color(0xFF6B7B96), fontSize: 13)),
                          SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: context.colors.lightGreyBlue,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: context.colors.disabledBorder),
                            ),
                            child: Text('nikhil@okaxis', style: TextStyle(fontFamily: 'monospace', fontSize: 15, color: context.colors.primaryDarkBlue)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Card 3: Photograph
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Photograph', style: TextStyle(color: context.colors.primaryDarkBlue, fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 12),
                          InkWell(
                            onTap: () => _showImageSourceActionSheet(context),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: context.colors.pageBackground,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: context.colors.disabledBorder),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _image != null ? Icons.image : Icons.camera_alt_outlined, 
                                    color: context.colors.primaryDarkBlue, 
                                    size: 20
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    _image != null ? 'Photo selected' : 'Take photo',
                                    style: TextStyle(color: context.colors.primaryDarkBlue, fontSize: 15, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colors.cardBackground,
                border: Border(top: BorderSide(color: context.colors.disabledBorder)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PendingScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primaryDarkBlue,
                    foregroundColor: context.colors.cardBackground,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(bool isCompleted, bool isCurrentOrPast) {
    return Expanded(
      child: Container(
        height: 4,
        margin: EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isCompleted
              ? context.colors.greenSuccess
              : (isCurrentOrPast ? context.colors.greenSuccess.withValues(alpha: 0.4) : context.colors.disabledBorder),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.disabledBorder),
      ),
      child: child,
    );
  }
}
