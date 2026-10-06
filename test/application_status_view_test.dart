import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uk_circle_partners/features/onboarding/presentation/widgets/application_status_view.dart';

void main() {
  Widget createTestWidget({
    CompanyStatusTheme? theme,
    int initialStageIndex = 1,
  }) {
    return MaterialApp(
      home: ApplicationStatusView(
        theme: theme ?? CompanyStatusTheme.cloudPatra(),
        initialStageIndex: initialStageIndex,
        applicantName: 'Test Applicant',
        applicationId: '#TEST-2026-001',
        wardLocality: 'Ward 10, Indiranagar',
      ),
    );
  }

  testWidgets('ApplicationStatusView renders Title, Subtitle, and 6 Stages', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Required Title and Subtitle
    expect(find.text('Application Status'), findsOneWidget);
    expect(find.text('Track Your Application Progress'), findsOneWidget);

    // Verify all 6 stages are present
    expect(find.text('Submitted'), findsWidgets);
    expect(find.text('Under Review'), findsWidgets);
    expect(find.text('Interrogation'), findsWidgets);
    expect(find.text('Training'), findsWidgets);
    expect(find.text('Completed'), findsWidgets);
    expect(find.text('Active'), findsWidgets);

    // Initial stage is Under Review (index 1)
    // Stage 1 Submitted should show completed comment
    expect(find.text('Completed – Application submitted successfully'), findsOneWidget);
    // Stage 2 Under Review should show pending review comment
    expect(find.text('Pending – Application is under review'), findsOneWidget);
    // Stage 3 Interrogation should show pending interrogation comment
    expect(find.text('Pending – Interrogation pending'), findsOneWidget);
    // Stage 4 Training should show pending training comment
    expect(find.text('Pending – Training pending'), findsOneWidget);

    // Subtitle card details
    expect(find.text('Test Applicant'), findsOneWidget);
    expect(find.text('#TEST-2026-001'), findsOneWidget);
    expect(find.text('Ward 10, Indiranagar'), findsOneWidget);
  });

  testWidgets('Dynamic comments update when transitioning to Interrogation stage', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(initialStageIndex: 2));
    await tester.pumpAndSettle();

    // Now on Interrogation (index 2)
    expect(find.text('Pending – Please complete the interrogation'), findsOneWidget);
    expect(find.text('Completed – Application review passed'), findsOneWidget);
  });

  testWidgets('Dynamic comments update when transitioning to Training stage', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(initialStageIndex: 3));
    await tester.pumpAndSettle();

    // Now on Training (index 3)
    expect(find.text('Pending – Please complete your training.'), findsOneWidget);
    expect(find.text('Completed – Interrogation & verification cleared'), findsOneWidget);
  });

  testWidgets('Dynamic comments update when transitioning to Completed stage', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(initialStageIndex: 4));
    await tester.pumpAndSettle();

    // Now on Completed (index 4)
    expect(find.text('Pending – Training completion pending'), findsOneWidget);
    expect(find.text('Completed – Training modules finished'), findsOneWidget);
  });

  testWidgets('Dynamic comments update when transitioning to Active stage', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(initialStageIndex: 5));
    await tester.pumpAndSettle();

    // Now on Active (index 5)
    expect(find.text('Pending – Awaiting final account activation'), findsOneWidget);
  });

  testWidgets('Simulator taps switch stages dynamically', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(initialStageIndex: 1));
    await tester.pumpAndSettle();

    expect(find.text('Pending – Application is under review'), findsOneWidget);

    // Tap "Training" in demo bar
    final trainingBtn = find.widgetWithText(InkWell, 'Training');
    expect(trainingBtn, findsOneWidget);
    await tester.tap(trainingBtn);
    await tester.pumpAndSettle();

    // Now stage is Training: comment must update dynamically
    expect(find.text('Pending – Please complete your training.'), findsOneWidget);

    // Tap "Interrogation" in demo bar
    final interrogationBtn = find.widgetWithText(InkWell, 'Interrogation');
    expect(interrogationBtn, findsOneWidget);
    await tester.tap(interrogationBtn);
    await tester.pumpAndSettle();

    // Now stage is Interrogation
    expect(find.text('Pending – Please complete the interrogation'), findsOneWidget);
  });

  testWidgets('Distinct company brand themes load correctly', (WidgetTester tester) async {
    final themes = [
      CompanyStatusTheme.cloudPatra(),
      CompanyStatusTheme.ownify(),
      CompanyStatusTheme.bhoomiVault(),
      CompanyStatusTheme.buildAiHomes(),
      CompanyStatusTheme.yuvaUdyami(),
      CompanyStatusTheme.firstChoiceBank(),
      CompanyStatusTheme.firstGoStay(),
    ];

    for (final theme in themes) {
      await tester.pumpWidget(createTestWidget(theme: theme));
      await tester.pumpAndSettle();

      expect(find.text(theme.companyName.toUpperCase()), findsOneWidget);
      expect(find.text('Application Status'), findsOneWidget);
      expect(find.text('Track Your Application Progress'), findsOneWidget);
    }
  });
}
