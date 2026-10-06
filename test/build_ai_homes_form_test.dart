import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uk_circle_partners/features/onboarding/presentation/forms/build_ai_homes_form.dart';
import 'package:uk_circle_partners/features/onboarding/presentation/company_selection_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('BuildAiHomesForm mounts and renders Step 1/9 About You', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BuildAiHomesForm(),
      ),
    );

    // Verify topbar
    expect(find.text('BUILD AI HOMES'), findsOneWidget);
    expect(find.text('Channel Partner Registration'), findsOneWidget);
    expect(find.text('↺ Restart'), findsOneWidget);

    // Verify step 1 header
    expect(find.text('STEP 1/9'), findsOneWidget);
    expect(find.text('About You'), findsOneWidget);

    // Verify demo applicant banner
    expect(find.text('Prototype Demo'), findsOneWidget);
    expect(find.text('Load Demo Applicant'), findsOneWidget);

    // Verify continue button
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('BuildAiHomesForm Step 1 loads demo applicant and navigates to Step 2', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BuildAiHomesForm(),
      ),
    );

    // Tap Load Demo Applicant
    await tester.tap(find.text('Load Demo Applicant'));
    await tester.pumpAndSettle();

    // Verify filled name
    expect(find.text('Suresh Naik'), findsOneWidget);

    // Tap Continue to Step 2
    final btn = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Continue'));
    btn.onPressed!();
    await tester.pumpAndSettle();

    // Verify Step 2
    expect(find.text('STEP 2/9'), findsOneWidget);
    expect(find.text('Verify Your Aadhaar'), findsOneWidget);
    expect(find.text('Aadhaar verified successfully'), findsOneWidget);
  });

  testWidgets('BuildAiHomesForm displays 5 service modules in Step 6 with deposit calculation', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BuildAiHomesForm(),
      ),
    );

    // Load demo
    await tester.tap(find.text('Load Demo Applicant'));
    await tester.pumpAndSettle();

    // Move step by step
    for (int i = 0; i < 5; i++) {
      final btn = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Continue'));
      btn.onPressed!();
      await tester.pumpAndSettle();
    }

    // Now in Step 6
    expect(find.text('STEP 6/9'), findsOneWidget);
    expect(find.text("What You'd Like to Do"), findsOneWidget);

    // Verify all 5 module names
    expect(find.text('Lands / JD-JV'), findsOneWidget);
    expect(find.text('Turnkey Construction'), findsOneWidget);
    expect(find.text('Interiors'), findsOneWidget);
    expect(find.text('Exterior'), findsOneWidget);
    expect(find.text('Landscape'), findsOneWidget);
  });

  testWidgets('CompanySelectionScreen lists Build AI Homes and navigates to BuildAiHomesForm', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CompanySelectionScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Find Build AI Homes card
    final buildAiTile = find.text('Build AI Homes');
    expect(buildAiTile, findsOneWidget);

    // Tap Build AI Homes
    await tester.tap(buildAiTile);
    await tester.pumpAndSettle();

    // Verify BuildAiHomesForm is pushed
    expect(find.byType(BuildAiHomesForm), findsOneWidget);
    expect(find.text('BUILD AI HOMES'), findsOneWidget);
  });
}
