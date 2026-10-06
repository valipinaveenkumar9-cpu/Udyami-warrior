import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uk_circle_partners/features/onboarding/presentation/forms/cloud_patra_form.dart';

void main() {
  testWidgets('CloudPatraForm mounts and renders Step 1/9 About You', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CloudPatraForm(),
      ),
    );

    // Verify topbar
    expect(find.text('CLOUDPATRA'), findsOneWidget);
    expect(find.text('Channel Partner Registration'), findsOneWidget);
    expect(find.text('↺ Restart'), findsOneWidget);

    // Verify step 1 header & progress
    expect(find.text('STEP 1/9'), findsOneWidget);
    expect(find.text('About You'), findsOneWidget);
    expect(find.text('As it appears on your Aadhaar / PAN card'), findsOneWidget);

    // Verify demo applicant banner
    expect(find.text('Prototype Demo'), findsOneWidget);
    expect(find.text('Load Demo'), findsOneWidget);

    // Verify continue button
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('CloudPatraForm Step 1 validation blocks when Member is No or missing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CloudPatraForm(),
      ),
    );

    // Tap Continue without answering
    final btn = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Continue'));
    btn.onPressed!();
    await tester.pumpAndSettle();

    // Still on Step 1
    expect(find.text('STEP 1/9'), findsOneWidget);

    // Clear any error snackbar so No is clickable
    ScaffoldMessenger.of(tester.element(find.byType(CloudPatraForm))).clearSnackBars();
    await tester.pumpAndSettle();

    // Select 'No' for Member
    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();

    // Warning banner should show
    expect(find.textContaining('Membership required'), findsOneWidget);

    btn.onPressed!();
    await tester.pumpAndSettle();
    // Still on Step 1
    expect(find.text('STEP 1/9'), findsOneWidget);
  });

  testWidgets('CloudPatraForm Step 2 Aadhaar OTP verification with demo 1234', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CloudPatraForm(),
      ),
    );

    // Load demo to populate Step 1
    tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Load Demo')).onPressed!();
    await tester.pumpAndSettle();

    // Continue to Step 2
    tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Continue')).onPressed!();
    await tester.pumpAndSettle();
    expect(find.text('STEP 2/9'), findsOneWidget);

    // Aadhaar is verified via Demo
    expect(find.text('Aadhaar verified successfully'), findsOneWidget);
  });

  testWidgets('CloudPatraForm full journey from Step 1 to Step 9 and Submission', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CloudPatraForm(),
      ),
    );

    void tapContinue() {
      final btn = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Continue'));
      btn.onPressed!();
    }

    // 1. Load Demo Applicant on Step 1
    tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Load Demo')).onPressed!();
    await tester.pumpAndSettle();

    // Verify Step 1 fields
    expect(find.text('Ananya Rao'), findsWidgets);

    // Continue to Step 2
    tapContinue();
    await tester.pumpAndSettle();
    expect(find.text('STEP 2/9'), findsOneWidget);
    expect(find.text('Verify Your Aadhaar'), findsOneWidget);

    // Continue to Step 3
    tapContinue();
    await tester.pumpAndSettle();
    expect(find.text('STEP 3/9'), findsOneWidget);
    expect(find.text('Business & Experience'), findsOneWidget);

    // Continue to Step 4
    tapContinue();
    await tester.pumpAndSettle();
    expect(find.text('STEP 4/9'), findsOneWidget);
    expect(find.text("Where You'll Work From"), findsOneWidget);

    // Continue to Step 5
    tapContinue();
    await tester.pumpAndSettle();
    expect(find.text('STEP 5/9'), findsOneWidget);
    expect(find.text('Your Bank Details'), findsOneWidget);

    // Continue to Step 6
    tapContinue();
    await tester.pumpAndSettle();
    expect(find.text('STEP 6/9'), findsOneWidget);
    expect(find.text("What You'd Like to Do"), findsOneWidget);

    // Continue to Verification Questionnaire (inserted after Step 6)
    tapContinue();
    await tester.pumpAndSettle();
    expect(find.text('VERIFICATION QUESTIONNAIRE · INSERTED AFTER STEP 6'), findsOneWidget);

    // Advance through questionnaire sections
    for (int i = 0; i < 4; i++) {
      final nextFinder = find.widgetWithText(ElevatedButton, 'Next Section');
      if (nextFinder.evaluate().isNotEmpty) {
        tester.widget<ElevatedButton>(nextFinder).onPressed!();
        await tester.pumpAndSettle();
      }
    }
    // Final questionnaire section has 'Continue'
    tapContinue();
    await tester.pumpAndSettle();

    // Now on Step 7
    expect(find.text('STEP 7/9'), findsOneWidget);
    expect(find.text('Availability & Comfort'), findsOneWidget);

    // Continue to Step 8
    tapContinue();
    await tester.pumpAndSettle();
    expect(find.text('STEP 8/9'), findsOneWidget);
    expect(find.text('Consent'), findsOneWidget);

    // Continue to Step 9 (Review)
    tapContinue();
    await tester.pumpAndSettle();
    expect(find.text('STEP 9/9'), findsOneWidget);
    expect(find.text('Review Application'), findsOneWidget);
    expect(find.text('Submit Application'), findsOneWidget);

    // Tap Submit Application -> Status screen
    final submitBtn = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Submit Application'));
    submitBtn.onPressed!();
    await tester.pumpAndSettle();

    // Verify Status screen with the requested vertical timeline UI
    expect(find.text('Application Status'), findsOneWidget);
    expect(find.text('Track Your Application Progress'), findsOneWidget);
    expect(find.text('Submitted'), findsWidgets);
    expect(find.text('Under Review'), findsWidgets);
    expect(find.text('Interrogation'), findsWidgets);
    expect(find.text('Training'), findsWidgets);
    expect(find.text('Completed'), findsWidgets);
    expect(find.text('Active'), findsWidgets);
    expect(find.text('Completed – Application submitted successfully'), findsOneWidget);
    expect(find.text('Pending – Application is under review'), findsOneWidget);
  });
}
