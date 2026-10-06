import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uk_circle_partners/features/onboarding/presentation/forms/bhoomi_vault_form.dart';

void main() {
  testWidgets('BhoomiVaultForm mounts and renders Step 1/9 About You',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BhoomiVaultForm(),
      ),
    );

    // Verify topbar
    expect(find.text('BHOOMIVAULT'), findsOneWidget);
    expect(find.text('Channel Partner Registration'), findsOneWidget);
    expect(find.text('↺ Restart'), findsOneWidget);

    // Verify step 1 header
    expect(find.text('STEP 1/9'), findsOneWidget);
    expect(find.text('About You'), findsOneWidget);

    // Verify demo applicant banner
    expect(find.text('Prototype demo'), findsOneWidget);
    expect(find.text('Load Demo Applicant'), findsOneWidget);

    // Verify continue button
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets(
      'BhoomiVaultForm loads demo applicant and navigates through steps',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BhoomiVaultForm(),
      ),
    );

    // Tap Load Demo Applicant
    await tester.tap(find.text('Load Demo Applicant'));
    await tester.pumpAndSettle();

    // Verify filled name
    expect(find.text('Ananya Rao'), findsOneWidget);

    // Navigate to Step 2
    tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Continue')).onPressed!();
    await tester.pumpAndSettle();
    expect(find.text('STEP 2/9'), findsOneWidget);
    expect(find.text('Verify Your Aadhaar'), findsOneWidget);

    // Navigate to Step 3
    tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Continue')).onPressed!();
    await tester.pumpAndSettle();
    expect(find.text('STEP 3/9'), findsOneWidget);
    expect(find.text('Business & Experience'), findsOneWidget);

    // Navigate to Step 4
    tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Continue')).onPressed!();
    await tester.pumpAndSettle();
    expect(find.text('STEP 4/9'), findsOneWidget);
    expect(find.text("Where You'll Work From"), findsOneWidget);

    // Navigate to Step 5
    tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Continue')).onPressed!();
    await tester.pumpAndSettle();
    expect(find.text('STEP 5/9'), findsOneWidget);
    expect(find.text('Your Bank Details'), findsOneWidget);

    // Navigate to Step 6
    tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Continue')).onPressed!();
    await tester.pumpAndSettle();
    expect(find.text('STEP 6/9'), findsOneWidget);
    expect(find.text("What You'd Like to Do"), findsOneWidget);
    expect(find.text('SetuConnect'), findsOneWidget);
    expect(find.text('SetuField'), findsOneWidget);

    // Navigate to Questionnaire
    tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Continue')).onPressed!();
    await tester.pumpAndSettle();
    expect(find.text('VERIFICATION QUESTIONNAIRE · INSERTED AFTER STEP 6'), findsOneWidget);
  });

  testWidgets('BhoomiVaultForm renders status screen with demo outcomes',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: BhoomiVaultForm(
          initialApplicationData: {'status': 'submitted'},
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Submitted'), findsWidgets);
    expect(find.text('DEMO · PREVIEW OTHER OUTCOMES'), findsOneWidget);

    // Tap Meeting Scheduled
    await tester.tap(find.text('Meeting Scheduled'));
    await tester.pumpAndSettle();
    expect(find.text('Meeting Scheduled'), findsOneWidget);
    expect(find.text('Bring'), findsOneWidget);

    // Tap Payment
    await tester.tap(find.text('Payment'));
    await tester.pumpAndSettle();
    expect(find.text('Security Deposit'), findsOneWidget);
    expect(find.text('₹2,00,000'), findsOneWidget);

    // Tap Onboarded
    await tester.tap(find.text('Pay ₹2,00,000 Now'));
    await tester.pumpAndSettle();
    expect(find.text("You're Onboarded!"), findsOneWidget);
  });
}
