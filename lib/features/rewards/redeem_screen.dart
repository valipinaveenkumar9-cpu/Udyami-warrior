import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:uk_circle_partners/core/utils/session_manager.dart';
import 'package:uk_circle_partners/core/widgets/custom_app_bar.dart';
import 'package:uk_circle_partners/core/widgets/custom_menu_drawer.dart';
import 'package:uk_circle_partners/features/profile/presentation/bank_account_screen.dart';
import '../home/presentation/main_screen.dart';

class RedeemScreen extends StatefulWidget {
  final int availablePoints;
  const RedeemScreen({super.key, this.availablePoints = 4000});

  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  late int _selectedAmount;
  String _selectedDestinationId = 'upi_1';

  final List<Map<String, String>> _accounts = [
    {
      'id': 'upi_1',
      'type': 'upi',
      'title': 'UPI — nikhil@okaxis',
      'subtitle': '2–3 working days',
      'icon': '₹',
    },
    {
      'id': 'wallet_1',
      'type': 'wallet',
      'title': 'Udyami coin wallet',
      'subtitle': 'Instant · use for membership',
      'icon': '◈',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Default amount: 2500 if available >= 2500, else availablePoints
    if (widget.availablePoints >= 2500) {
      _selectedAmount = 2500;
    } else {
      _selectedAmount = widget.availablePoints > 0 ? widget.availablePoints : 2500;
    }
  }

  void _showAddAccountDialog() {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController(text: '2–3 working days');
    String accountType = 'UPI';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Add New Account',
            style: TextStyle(color: context.colors.greenDark, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: accountType,
                dropdownColor: Colors.white,
                items: ['UPI', 'Bank Account', 'Wallet']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t, style: TextStyle(color: context.colors.greenDark))))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setDialogState(() {
                      accountType = val;
                      if (val == 'UPI') {
                        subtitleController.text = '2–3 working days';
                      } else if (val == 'Bank Account') {
                        subtitleController.text = '3–5 working days (NEFT/IMPS)';
                      } else {
                        subtitleController.text = 'Instant · use for membership';
                      }
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Account Type',
                  labelStyle: TextStyle(color: context.colors.greenDark),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: accountType == 'UPI'
                      ? 'UPI ID (e.g. name@okaxis)'
                      : (accountType == 'Bank Account' ? 'A/C Number & IFSC' : 'Wallet Name/Number'),
                  labelStyle: TextStyle(color: context.colors.greenDark),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: context.colors.greenDark)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  final newId = 'acc_${DateTime.now().millisecondsSinceEpoch}';
                  final icon = accountType == 'UPI' ? '₹' : (accountType == 'Bank Account' ? '🏦' : '◈');
                  setState(() {
                    _accounts.add({
                      'id': newId,
                      'type': accountType.toLowerCase(),
                      'title': '$accountType — ${titleController.text.trim()}',
                      'subtitle': subtitleController.text,
                      'icon': icon,
                    });
                    _selectedDestinationId = newId;
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.greenSuccess,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Account'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isBelowMinimum = widget.availablePoints < 2500;
    final double rupees = _selectedAmount * 0.20;

    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      appBar: const CustomAppBar(),
      endDrawer: const CustomMenuDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Top Available Points Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colors.greenLight,
                    border: Border.all(color: context.colors.greenSuccess.withValues(alpha: 0.4)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AVAILABLE POINTS',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: context.colors.greenDark,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.availablePoints} points',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Barlow Condensed',
                              color: context.colors.greenDark,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Value (1 pt = ₹0.20)',
                            style: TextStyle(
                              fontSize: 10,
                              color: context.colors.greenDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${(widget.availablePoints * 0.20).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: context.colors.greenSuccess,
                              fontFamily: 'Barlow Condensed',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Minimum Requirement Warning if below 2500
                if (isBelowMinimum)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.colors.greenLight,
                      border: Border.all(color: context.colors.greenSuccess),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: context.colors.greenDark, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Minimum 2,500 points required to withdraw. You currently have ${widget.availablePoints} points.',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.colors.greenDark),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Amount Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colors.cardBackground,
                    border: Border.all(color: context.colors.lightGreyBlue),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How many points to redeem',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                          color: context.colors.greenDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: context.colors.pageBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: context.colors.lightGreyBlue),
                        ),
                        child: Text(
                          '$_selectedAmount',
                          style: TextStyle(
                            fontFamily: 'Barlow Condensed',
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                            color: context.colors.greenDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildAmountChip(2500, '2,500 Min'),
                          const SizedBox(width: 8),
                          _buildAmountChip(5000, '5,000'),
                          const SizedBox(width: 8),
                          _buildAmountChip(widget.availablePoints > 0 ? widget.availablePoints : 2500, 'All ${widget.availablePoints}'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Minimum withdrawal is 2,500 points',
                        style: TextStyle(
                          fontSize: 11,
                          color: context.colors.greenDark.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Destination Card (Multiple Accounts Supported + Add Account)
                ValueListenableBuilder<int>(
                  valueListenable: SessionManager.bankAccountsNotifier,
                  builder: (context, _, __) {
                    final savedBankAccounts = SessionManager.bankAccounts;
                    final allAccounts = <Map<String, String>>[
                      ..._accounts,
                      ...savedBankAccounts.map((b) => {
                        'id': b['id'] ?? 'acc_${b['accountNumber']}',
                        'type': 'bank',
                        'title': '${b['bankName']} — ${b['accountNumber']}',
                        'subtitle': 'IFSC: ${b['ifscCode']} • 3–5 working days',
                        'icon': '🏦',
                      }),
                    ];

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.colors.cardBackground,
                        border: Border.all(color: context.colors.lightGreyBlue),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Where should it go (Multiple Accounts)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.1,
                                  color: context.colors.greenDark,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const BankAccountScreen()),
                                  );
                                },
                                icon: Icon(Icons.add_circle_outline, size: 16, color: context.colors.greenSuccess),
                                label: Text(
                                  'Add Account',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.colors.greenSuccess),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...allAccounts.map((acc) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Column(
                                children: [
                                  _buildDestinationOption(
                                    id: acc['id']!,
                                    icon: acc['icon']!,
                                    iconBg: acc['type'] == 'upi' || acc['type'] == 'bank' ? context.colors.greenDark : context.colors.greenLight,
                                    iconColor: acc['type'] == 'upi' || acc['type'] == 'bank' ? Colors.white : context.colors.greenDark,
                                    title: acc['title']!,
                                    subtitle: acc['subtitle']!,
                                  ),
                                  if (allAccounts.last != acc)
                                    Divider(color: context.colors.lightGreyBlue, height: 20),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Calculation Card (1 Point = 0.20 Rs)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colors.cardBackground,
                    border: Border.all(color: context.colors.lightGreyBlue),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$_selectedAmount points at ₹0.20 per point', style: TextStyle(fontSize: 13, color: context.colors.greenDark)),
                          Text('₹${(_selectedAmount * 0.20).toStringAsFixed(2)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.colors.greenDark)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tax / Processing Fee', style: TextStyle(fontSize: 13, color: context.colors.greenDark)),
                          Text('₹0.00', style: TextStyle(fontSize: 13, color: context.colors.greenDark)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: context.colors.lightGreyBlue, height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('You will receive', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.colors.greenDark)),
                          Text(
                            '₹${rupees.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Barlow Condensed', color: context.colors.greenSuccess),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.colors.cardBackground,
            border: Border(top: BorderSide(color: context.colors.lightGreyBlue)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isBelowMinimum && widget.availablePoints < _selectedAmount
                      ? null
                      : () {
                          if (_selectedAmount < 2500) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Minimum withdrawal is 2,500 points'),
                                backgroundColor: context.colors.greenDark,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Payout of ₹${rupees.toStringAsFixed(2)} requested successfully!'),
                              backgroundColor: context.colors.greenSuccess,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const MainScreen()),
                            (route) => false,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.greenSuccess,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Request payout',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '1 point = ₹0.20. Minimum withdrawal: 2,500 points. Finance team approves.',
                style: TextStyle(fontSize: 11, color: context.colors.greenDark.withValues(alpha: 0.7)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountChip(int amount, String label) {
    final isSelected = _selectedAmount == amount;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedAmount = amount),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? context.colors.greenSuccess : context.colors.pageBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? context.colors.greenSuccess : context.colors.lightGreyBlue),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : context.colors.greenDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationOption({
    required String id,
    required String icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedDestinationId == id;
    return InkWell(
      onTap: () => setState(() => _selectedDestinationId = id),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              icon,
              style: TextStyle(color: iconColor, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.colors.greenDark),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: context.colors.greenDark.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
          if (isSelected)
            Icon(Icons.check_circle, color: context.colors.greenSuccess, size: 20)
          else
            const SizedBox(width: 20),
        ],
      ),
    );
  }
}
