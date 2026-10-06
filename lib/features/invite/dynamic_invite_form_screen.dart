import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/services/api_service.dart';
import '../../core/utils/session_manager.dart';
import 'consent_&_otp_screen.dart';

class DynamicInviteFormScreen extends StatefulWidget {
  final Map<String, dynamic>? routeData;
  final double traveledDistanceMeters;
  final double totalDistanceMeters;

  const DynamicInviteFormScreen({
    super.key,
    this.routeData,
    this.traveledDistanceMeters = 0,
    this.totalDistanceMeters = 0,
  });

  @override
  State<DynamicInviteFormScreen> createState() => _DynamicInviteFormScreenState();
}

class _DynamicInviteFormScreenState extends State<DynamicInviteFormScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  String? _errorMessage;
  
  // Form Schema details
  String? _formId;
  String _formTitle = 'Loading Form...';
  String _formDescription = '';
  List<dynamic> _formSchema = [];
  
  // Controllers for the dynamic fields
  final Map<String, TextEditingController> _controllers = {};

  // Get real ID from session
  final String _dummyUserId = SessionManager.user?['id'] ?? SessionManager.user?['userId'] ?? SessionManager.user?['_id'] ?? '';

  @override
  void initState() {
    super.initState();
    _fetchForm();
  }

  Future<void> _fetchForm() async {
    try {
      final data = await _apiService.getCpOnboardingForm(_dummyUserId);
      
      // Map JSON to our schema
      if (data.containsKey('data')) {
        var formData = data['data'];
        if (formData is List && formData.isNotEmpty) {
          formData = formData.first['form'];
        }

        if (formData != null && formData is Map) {
          _formId = formData['formId'] ?? formData['_id'] ?? formData['id'] ?? 'dummy-form-id';
          _formTitle = formData['title'] ?? 'Invite Form';
          _formDescription = formData['description'] ?? '';
          _formSchema = formData['formSchema'] ?? [];
          
          // Initialize controllers
          for (var field in _formSchema) {
            final fieldName = field['fieldName'] ?? field['id'] ?? field['label'];
            if (fieldName != null) {
              _controllers[fieldName] = TextEditingController();
            }
          }
        }
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formId == null) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> answers = {};
      _controllers.forEach((key, controller) {
        answers[key] = controller.text.trim();
      });

      await _apiService.submitCpOnboardingForm(
        formId: _formId!,
        userId: _dummyUserId,
        answers: answers,
      );

      if (mounted) {
        // Navigate to next screen with data passed through
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConsentAndOtpScreen(
              routeData: widget.routeData,
              traveledDistanceMeters: widget.traveledDistanceMeters,
              totalDistanceMeters: widget.totalDistanceMeters,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light.cardBackground,
      appBar: AppBar(
        backgroundColor: AppColors.light.cardBackground,
        foregroundColor: AppColors.light.primaryDarkBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_formTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text(_errorMessage!, style: const TextStyle(color: Colors.red))))
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          if (_formDescription.isNotEmpty) ...[
                            Text(_formDescription, style: TextStyle(color: AppColors.light.secondaryText, fontSize: 14)),
                            const SizedBox(height: 24),
                          ],
                          
                          ..._formSchema.map((field) {
                            final fieldName = field['fieldName'] ?? field['id'] ?? field['label'] ?? 'Unknown Field';
                            final fieldType = field['type'] as String? ?? 'text';
                            final label = field['label'] ?? fieldName;
                            final controller = _controllers[fieldName];
                            
                            if (controller == null) return const SizedBox.shrink();

                            TextInputType inputType = TextInputType.text;
                            if (fieldType == 'number' || fieldType == 'tel') {
                              inputType = TextInputType.number;
                            } else if (fieldType == 'email') {
                              inputType = TextInputType.emailAddress;
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: controller,
                                    keyboardType: inputType,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.light.pageBackground,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: AppColors.light.disabledBorder),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: AppColors.light.disabledBorder),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.light.cardBackground,
                        border: Border(top: BorderSide(color: AppColors.light.lightGreyBlue)),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.light.greenSuccess,
                            foregroundColor: AppColors.light.cardBackground,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Submit Invitation', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
