import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/services/api_service.dart';
import '../../core/utils/session_manager.dart';

class CreateInviteFormScreen extends StatefulWidget {
  const CreateInviteFormScreen({super.key});

  @override
  State<CreateInviteFormScreen> createState() => _CreateInviteFormScreenState();
}

class _CreateInviteFormScreenState extends State<CreateInviteFormScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _titleController = TextEditingController(text: 'Channel Partner Registration');
  final TextEditingController _descController = TextEditingController();
  
  final List<Map<String, dynamic>> _formSchema = [];
  bool _isLoading = false;

  void _showAddFieldDialog() {
    String newFieldName = '';
    String newFieldType = 'text';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Add Custom Field', style: TextStyle(color: AppColors.light.primaryDarkBlue)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Field Name'),
                    onChanged: (val) => newFieldName = val,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: newFieldType,
                    decoration: const InputDecoration(labelText: 'Field Type'),
                    items: const [
                      DropdownMenuItem(value: 'text', child: Text('Text')),
                      DropdownMenuItem(value: 'number', child: Text('Number')),
                      DropdownMenuItem(value: 'dropdown', child: Text('Dropdown (Select)')),
                    ],
                    onChanged: (val) {
                      if (val != null) setDialogState(() => newFieldType = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (newFieldName.trim().isNotEmpty) {
                      setState(() {
                        _formSchema.add({
                          'id': DateTime.now().millisecondsSinceEpoch.toString(),
                          'fieldName': newFieldName.trim(),
                          'type': newFieldType,
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.light.secondaryText),
                  child: Text('Add', style: TextStyle(color: AppColors.light.cardBackground)),
                ),
              ],
            );
          }
        );
      }
    );
  }

  Future<void> _submitForm() async {
    if (_titleController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Get real ID from session
      final String dummyUserId = SessionManager.user?['id'] ?? SessionManager.user?['userId'] ?? SessionManager.user?['_id'] ?? '';

      await _apiService.createCpOnboardingForm(
        userId: dummyUserId,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        formSchema: _formSchema,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form schema created successfully!')),
        );
        Navigator.pop(context);
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
        title: const Text('Create Custom Form', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Text('Form Title', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _titleController,
                        decoration: _inputDecoration(),
                      ),
                      const SizedBox(height: 16),
                      const Text('Description (Optional)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descController,
                        decoration: _inputDecoration(),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Custom Fields', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.light.primaryDarkBlue)),
                          TextButton.icon(
                            onPressed: _showAddFieldDialog,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Add Field'),
                          ),
                        ],
                      ),
                      const Divider(),
                      if (_formSchema.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text('No custom fields added yet.', style: TextStyle(color: Colors.grey)),
                        ),
                      ..._formSchema.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final field = entry.value;
                        return Card(
                          elevation: 0,
                          color: AppColors.light.pageBackground,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(field['fieldName'], style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text('Type: ${field['type']}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _formSchema.removeAt(idx);
                                });
                              },
                            ),
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
                        backgroundColor: AppColors.light.secondaryText,
                        foregroundColor: AppColors.light.cardBackground,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Save Form Schema', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
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
    );
  }
}
