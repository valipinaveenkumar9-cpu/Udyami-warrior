import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';

class FixedDepositScreen extends StatefulWidget {
  final double amount;
  final int multiplierCount;
  final String multiplierType;

  const FixedDepositScreen({
    super.key,
    this.amount = 100000,
    this.multiplierCount = 1,
    this.multiplierType = 'service',
  });

  @override
  State<FixedDepositScreen> createState() => _FixedDepositScreenState();
}

class _FixedDepositScreenState extends State<FixedDepositScreen> {
  final _settlementController = TextEditingController();

  void _onPayNow() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment Gateway Integration Pending...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.pageBackground,
      appBar: AppBar(
        title: const Text('Fixed Deposit', style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: context.colors.primaryDarkBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Complete your Fixed Deposit',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colors.orangeWarning.withValues(alpha: 0.1),
                border: Border.all(color: context.colors.orangeWarning),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Your CP account activates only once this Fixed Deposit is received. Payment must be completed within 7 days of approval.',
                style: TextStyle(color: context.colors.orangeDark, fontSize: 13, height: 1.4),
              ),
            ),
            const SizedBox(height: 32),
            // The Moved Gradient Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [context.colors.primaryDarkBlue, context.colors.primaryDarkBlue.withValues(alpha: 0.8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(color: context.colors.primaryDarkBlue.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5)),
                ]
              ),
              child: Column(
                children: [
                  Text(
                    'TOTAL FIXED DEPOSIT PAYABLE',
                    style: TextStyle(color: context.colors.orangeLight, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '₹${widget.amount.toInt()}',
                    style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${(widget.amount / (widget.multiplierCount > 0 ? widget.multiplierCount : 1)).toInt()} × ${widget.multiplierCount} ${widget.multiplierType}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: 200,
                    height: 1.5,
                    color: context.colors.orangeWarning.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),

            // Bank Details Field
            TextField(
              controller: _settlementController,
              decoration: InputDecoration(
                labelText: 'Bank Details (For FD Settlement)',
                hintText: 'Enter Account No. / IFSC',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.colors.disabledBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.colors.disabledBorder)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: context.colors.primaryDarkBlue)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            
            const SizedBox(height: 32),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _onPayNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primaryDarkBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: const Text('Pay Now', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
