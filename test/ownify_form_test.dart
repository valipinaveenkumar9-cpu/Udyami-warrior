import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uk_circle_partners/features/onboarding/presentation/forms/ownify_form.dart';

void main() {
  testWidgets('OwnifyForm mounts and renders Step 1/9 About You', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OwnifyForm(),
      ),
    );

    // Verify topbar
    expect(find.text('OWNIFY'), findsOneWidget);
    expect(find.text('Channel Partner Registration'), findsOneWidget);
    expect(find.text('↺ Restart'), findsOneWidget);

    // Verify step 1 header
    expect(find.text('STEP 1/9'), findsOneWidget);
    expect(find.text('About You'), findsOneWidget);

    // Verify demo applicant banner
    expect(find.text('Prototype Demo'), findsOneWidget);
    expect(find.text('Load Demo'), findsOneWidget);

    // Verify continue button
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('OwnifyForm Step 1 loads demo applicant and navigates to Step 2', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OwnifyForm(),
      ),
    );

    // Tap Load Demo
    await tester.tap(find.text('Load Demo'));
    await tester.pumpAndSettle();

    // Verify filled name
    expect(find.text('Ananya Rao'), findsOneWidget);

    // Tap Continue to Step 2
    final btn = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Continue'));
    btn.onPressed!();
    await tester.pumpAndSettle();

    // Verify Step 2
    expect(find.text('STEP 2/9'), findsOneWidget);
    expect(find.text('Verify Your Aadhaar'), findsOneWidget);
  });
}
