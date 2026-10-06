import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/utils/session_manager.dart';
import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';
import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';

class BankAccountScreen extends StatefulWidget {
  const BankAccountScreen({super.key});

  @override
  State<BankAccountScreen> createState() => _BankAccountScreenState();
}

class _BankAccountScreenState extends State<BankAccountScreen> {
  final _holderNameController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountNoController = TextEditingController();
  final _confirmAccNoController = TextEditingController();
  final _ifscController = TextEditingController();

  bool _isAddingAccount = false;

  @override
  void initState() {
    super.initState();
    _holderNameController.text = SessionManager.userName;
  }

  @override
  void dispose() {
    _holderNameController.dispose();
    _bankNameController.dispose();
    _accountNoController.dispose();
    _confirmAccNoController.dispose();
    _ifscController.dispose();
    super.dispose();
  }

  void _saveBankAccount() async {
    final holderName = _holderNameController.text.trim();
    final bankName = _bankNameController.text.trim();
    final accountNo = _accountNoController.text.trim();
    final confirmAccNo = _confirmAccNoController.text.trim();
    final ifsc = _ifscController.text.trim().toUpperCase();

    if (holderName.isEmpty || bankName.isEmpty || accountNo.isEmpty || ifsc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all required fields'),
          backgroundColor: context.colors.greenDark,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (accountNo != confirmAccNo) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Account numbers do not match'),
          backgroundColor: context.colors.greenDark,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final newAccount = {
      'id': 'acc_${DateTime.now().millisecondsSinceEpoch}',
      'bankName': bankName,
      'accountNumber': accountNo.length > 4 ? '**** ${accountNo.substring(accountNo.length - 4)}' : accountNo,
      'fullAccountNumber': accountNo,
      'ifscCode': ifsc,
      'holderName': holderName,
      'type': 'Bank Account',
    };

    await SessionManager.addBankAccount(newAccount);

    if (mounted) {
      setState(() {
        _isAddingAccount = false;
        _bankNameController.clear();
        _accountNoController.clear();
        _confirmAccNoController.clear();
        _ifscController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('New bank account added and reflected across the app!'),
          backgroundColor: context.colors.greenSuccess,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      appBar: const CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: ValueListenableBuilder<int>(
        valueListenable: SessionManager.bankAccountsNotifier,
        builder: (context, _, __) {
          final accounts = SessionManager.bankAccounts;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.colors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.colors.lightGreyBlue),
                ),
                child: Row(
                  children: [
                    Icon(Icons.account_balance, color: context.colors.greenDark, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bank Accounts',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: context.colors.greenDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Manage your payout bank accounts',
                            style: TextStyle(
                              fontSize: 12,
                              color: context.colors.greenDark.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Existing Accounts Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'EXISTING BANK ACCOUNTS (${accounts.length})',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: context.colors.greenDark,
                    ),
                  ),
                  if (!_isAddingAccount)
                    TextButton.icon(
                      onPressed: () => setState(() => _isAddingAccount = true),
                      icon: Icon(Icons.add_circle_outline, color: context.colors.greenSuccess, size: 18),
                      label: Text(
                        'Add Account',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: context.colors.greenSuccess,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              ...accounts.map((acc) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colors.cardBackground,
                    border: Border.all(color: context.colors.greenSuccess.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: context.colors.greenLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.account_balance_outlined, color: context.colors.greenDark, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    acc['bankName'] ?? 'Bank Account',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: context.colors.greenDark,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: context.colors.greenLight,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Verified',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: context.colors.greenDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'A/C: ${acc['accountNumber']}',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w600,
                                color: context.colors.greenDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'IFSC: ${acc['ifscCode']} • Holder: ${acc['holderName']}',
                              style: TextStyle(
                                fontSize: 11,
                                color: context.colors.greenDark.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 12),

              // Add Account Form Card (Togglable or Always Visible)
              if (_isAddingAccount)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colors.cardBackground,
                    border: Border.all(color: context.colors.greenSuccess),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add New Bank Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: context.colors.greenDark,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () => setState(() => _isAddingAccount = false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _holderNameController,
                        decoration: InputDecoration(
                          labelText: 'Account Holder Name *',
                          labelStyle: TextStyle(color: context.colors.greenDark),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _bankNameController,
                        decoration: InputDecoration(
                          labelText: 'Bank Name * (e.g. FCMCSLC / HDFC / SBI)',
                          labelStyle: TextStyle(color: context.colors.greenDark),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _accountNoController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Account Number *',
                          labelStyle: TextStyle(color: context.colors.greenDark),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _confirmAccNoController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Confirm Account Number *',
                          labelStyle: TextStyle(color: context.colors.greenDark),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _ifscController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          labelText: 'IFSC Code *',
                          labelStyle: TextStyle(color: context.colors.greenDark),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _saveBankAccount,
                          icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                          label: const Text(
                            'Save Bank Account',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.greenSuccess,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _isAddingAccount = true),
                    icon: Icon(Icons.add, color: context.colors.greenDark),
                    label: Text(
                      '+ Add Another Bank Account',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.colors.greenDark),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: context.colors.greenDark),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
