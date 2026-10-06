import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uk_circle_partners/features/circlepac/data/circlepac_mock_repository.dart';
import 'package:uk_circle_partners/features/circlepac/models/circlepac_survey_models.dart';
import 'package:uk_circle_partners/features/circlepac/presentation/forms/circlepac_survey_form.dart';
import 'package:uk_circle_partners/features/circlepac/presentation/screens/circlepac_main_shell.dart';
import 'package:uk_circle_partners/features/circlepac/presentation/screens/voter_database_screen.dart';

void main() {
  setUp(() {
    // Reset repository data if needed
  });

  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('CirclepacMainShell renders with CloudPatra brand and Voter Data Base', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const CirclepacMainShell()));
    await tester.pumpAndSettle();

    // Brand header
    expect(find.text('CIRCLEPAC'), findsOneWidget);
    expect(find.text('Voter Data Base'), findsWidgets);

    // Summary metrics in VoterDatabaseScreen
    expect(find.text('Voter Summary'), findsOneWidget);
    expect(find.text('Supporters'), findsOneWidget);
    expect(find.text('Opponents'), findsOneWidget);
    expect(find.text('Volunteer'), findsOneWidget);
    expect(find.text('Undecided'), findsOneWidget);
    expect(find.text('Booth Worker'), findsOneWidget);

    // Operations
    expect(find.text('Add Voter Details'), findsOneWidget);
    expect(find.text('Import'), findsOneWidget);
    expect(find.text('Export'), findsOneWidget);
  });

  testWidgets('VoterDatabaseScreen search and category filters work properly', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const VoterDatabaseScreen()));
    await tester.pumpAndSettle();

    // Should find initial seeded voter Ramesh Gowda
    expect(find.text('Ramesh Gowda'), findsOneWidget);

    // Search for "Ramesh"
    await tester.enterText(find.byType(TextField).first, 'Ramesh');
    await tester.pumpAndSettle();
    expect(find.text('Ramesh Gowda'), findsOneWidget);

    // Search for non-existing voter
    await tester.enterText(find.byType(TextField).first, 'NonExistingVoter123');
    await tester.pumpAndSettle();
    expect(find.text('No voters match your search or filter'), findsOneWidget);

    // Clear search
    await tester.enterText(find.byType(TextField).first, '');
    await tester.pumpAndSettle();
    expect(find.text('Ramesh Gowda'), findsOneWidget);
  });

  testWidgets('CirclepacSurveyForm 9-step wizard loads and completes with Fill Sample', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const CirclepacSurveyForm()));
    await tester.pumpAndSettle();

    // Step 1: Personal Info
    expect(find.text('Personal Info'), findsWidgets);
    expect(find.text('Personal Information'), findsOneWidget);

    // Tap "Fill Sample" in AppBar to populate mock data for all 162 questions
    final fillSampleBtn = find.widgetWithText(TextButton, 'Fill Sample');
    expect(fillSampleBtn, findsOneWidget);
    await tester.tap(fillSampleBtn);
    await tester.pumpAndSettle();

    // Verify name has been pre-filled
    expect(find.text('Chandrashekar Patil (Demo)'), findsOneWidget);

    // Advance through steps to Step 9
    for (int step = 1; step <= 8; step++) {
      final nextFinder = find.widgetWithText(ElevatedButton, 'Next Section →');
      expect(nextFinder, findsOneWidget);
      tester.widget<ElevatedButton>(nextFinder).onPressed!();
      await tester.pumpAndSettle();
    }

    // Now on Step 9: Donation & Tagging
    expect(find.text('Donation & Final Tagging'), findsOneWidget);
    expect(find.text('Assign Voter Category *'), findsOneWidget);
    expect(find.text('Submit Voter Survey'), findsOneWidget);

    // Submit Survey
    final submitFinder = find.widgetWithText(ElevatedButton, 'Submit Voter Survey');
    tester.widget<ElevatedButton>(submitFinder).onPressed!();
    await tester.pumpAndSettle();

    // Verify Success Dialog
    expect(find.text('Survey Submitted!'), findsOneWidget);
    expect(find.text('Go to Voter List'), findsOneWidget);

    // Dismiss dialog
    final goListFinder = find.widgetWithText(ElevatedButton, 'Go to Voter List');
    tester.widget<ElevatedButton>(goListFinder).onPressed!();
    await tester.pumpAndSettle();

    // Ensure newly submitted voter is in repository
    final repoVoters = CirclepacMockRepository().getVoters(searchQuery: 'Chandrashekar Patil');
    expect(repoVoters.isNotEmpty, isTrue);
    expect(repoVoters.first.category, VoterCategory.supporters);
  });
}
