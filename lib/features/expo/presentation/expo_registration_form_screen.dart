import 'package:flutter/material.dart';

class ExpoRegistrationFormScreen extends StatefulWidget {
  final String? referralCode;
  const ExpoRegistrationFormScreen({super.key, this.referralCode});

  @override
  State<ExpoRegistrationFormScreen> createState() => _ExpoRegistrationFormScreenState();
}

class _ExpoRegistrationFormScreenState extends State<ExpoRegistrationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();

  String _category = 'Visitor'; // Visitor, Stall, Sponsor
  String _sector = 'Agro'; // Agro, MSME, Healthcare

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _businessNameController.dispose();
    super.dispose();
  }

  void _submitRegistration() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 28),
              SizedBox(width: 8),
              Text('Registration Successful!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Thank you, ${_nameController.text.trim()}!'),
              const SizedBox(height: 6),
              Text('You are registered for UDYAMI BHARAT EXPO 2026 as a $_category.'),
              if (_category == 'Stall') Text('Sector: $_sector'),
              if (_category == 'Sponsor') ...[
                Text('Business: ${_businessNameController.text.trim()}'),
                Text('Sector: $_sector'),
              ],
              if (widget.referralCode != null) ...[
                const SizedBox(height: 6),
                Text('Referral Code: ${widget.referralCode}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0E5C4A)),
              child: const Text('Done', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E5C4A),
        title: const Text(
          'Expo 2026 Registration Form',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'UDYAMI BHARAT EXPO 2026',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E2A44),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Dec 4–6, 2026 | BIEC Bengaluru',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                    ),
                    if (widget.referralCode != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Referral Code: ${widget.referralCode}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF0E5C4A), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name *',
                  prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF0E5C4A)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF0E5C4A), width: 2),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),

              // Number
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Mobile Number *',
                  prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF0E5C4A)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF0E5C4A), width: 2),
                  ),
                ),
                validator: (val) => val == null || val.trim().length < 10 ? 'Please enter a valid mobile number' : null,
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address *',
                  prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF0E5C4A)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF0E5C4A), width: 2),
                  ),
                ),
                validator: (val) => val == null || !val.contains('@') ? 'Please enter a valid email' : null,
              ),
              const SizedBox(height: 16),

              // Coming in as Dropdown
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(
                  labelText: 'Coming in as *',
                  prefixIcon: const Icon(Icons.category_outlined, color: Color(0xFF0E5C4A)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF0E5C4A), width: 2),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'Visitor', child: Text('Visitor')),
                  DropdownMenuItem(value: 'Stall', child: Text('Stall / Exhibitor')),
                  DropdownMenuItem(value: 'Sponsor', child: Text('Sponsor')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _category = val;
                    });
                  }
                },
              ),

              // Conditional fields based on Category
              if (_category == 'Stall' || _category == 'Sponsor') ...[
                const SizedBox(height: 16),
                if (_category == 'Sponsor') ...[
                  TextFormField(
                    controller: _businessNameController,
                    decoration: InputDecoration(
                      labelText: 'Business Name *',
                      prefixIcon: const Icon(Icons.business_outlined, color: Color(0xFF0E5C4A)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF0E5C4A), width: 2),
                      ),
                    ),
                    validator: (val) => _category == 'Sponsor' && (val == null || val.trim().isEmpty)
                        ? 'Please enter your business name'
                        : null,
                  ),
                  const SizedBox(height: 16),
                ],
                DropdownButtonFormField<String>(
                  value: _sector,
                  decoration: InputDecoration(
                    labelText: 'Select Sector *',
                    prefixIcon: const Icon(Icons.work_outline, color: Color(0xFF0E5C4A)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF0E5C4A), width: 2),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Agro', child: Text('Agro & Food Processing')),
                    DropdownMenuItem(value: 'MSME', child: Text('MSME & Manufacturing')),
                    DropdownMenuItem(value: 'Healthcare', child: Text('Healthcare & Pharma')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _sector = val;
                      });
                    }
                  },
                ),
              ],

              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _submitRegistration,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E5C4A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text(
                  'Submit Expo Registration',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
