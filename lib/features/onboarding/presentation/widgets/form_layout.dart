import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';

class FormLayout extends StatelessWidget {
  final String brandName;
  final int currentStep;
  final int totalSteps;
  final String stepTitle;
  final String stepSubtitle;
  final Widget body;
  final VoidCallback onBack;
  final VoidCallback onContinue;
  final String continueText;

  const FormLayout({
    super.key,
    required this.brandName,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitle,
    required this.stepSubtitle,
    required this.body,
    required this.onBack,
    required this.onContinue,
    this.continueText = 'Continue',
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return PopScope(
      canPop: currentStep == 0,
      onPopInvoked: (didPop) {
        if (!didPop) {
          onBack();
        }
      },
      // Fallback for older Flutter if needed, but PopScope is standard now
      child: Scaffold(
        backgroundColor: colors.pageBackground,
        body: SafeArea(
          child: Column(
            children: [
              // Header
            Container(
              color: colors.primaryDarkBlue,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        brandName.toUpperCase(),
                        style: TextStyle(
                          color: colors.orangeWarning,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          border: Border.all(color: colors.orangeWarning.withValues(alpha: 0.5)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'STEP ${currentStep + 1} / $totalSteps',
                          style: TextStyle(
                            color: colors.orangeWarning,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    stepTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stepSubtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Progress Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(totalSteps, (index) {
                      bool isDone = index < currentStep;
                      bool isActive = index == currentStep;
                      
                      Color dotColor = colors.disabledBorder;
                      if (isActive) dotColor = colors.orangeWarning;
                      if (isDone) dotColor = colors.greenSuccess;

                      return Container(
                        width: isActive ? 16 : 12,
                        height: isActive ? 16 : 12,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                          border: isActive ? Border.all(color: Colors.white, width: 2) : null,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            // Body
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(22),
                child: SingleChildScrollView(child: body),
              ),
            ),
            // Bottom Nav
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: colors.cardBackground,
                border: Border(top: BorderSide(color: colors.disabledBorder)),
              ),
              child: Row(
                children: [
                  if (currentStep > 0) ...[
                    OutlinedButton(
                      onPressed: onBack,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                        side: BorderSide(color: colors.disabledBorder),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: Text('Back', style: TextStyle(color: colors.primaryDarkBlue, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.orangeWarning,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: Text(
                        continueText, 
                        style: TextStyle(color: colors.primaryDarkBlue, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
