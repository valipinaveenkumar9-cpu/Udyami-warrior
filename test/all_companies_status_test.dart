import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uk_circle_partners/features/onboarding/presentation/forms/cloud_patra_form.dart';
import 'package:uk_circle_partners/features/onboarding/presentation/forms/ownify_form.dart';
import 'package:uk_circle_partners/features/onboarding/presentation/forms/bhoomi_vault_form.dart';
import 'package:uk_circle_partners/features/onboarding/presentation/forms/build_ai_homes_form.dart';
import 'package:uk_circle_partners/features/onboarding/presentation/forms/yuva_udyami_form.dart';
import 'package:uk_circle_partners/features/onboarding/presentation/forms/first_choice_bank_form.dart';
import 'package:uk_circle_partners/features/onboarding/presentation/forms/first_go_stay_form.dart';

void main() {
  testWidgets('CloudPatraForm renders Application Status with CloudPatra branding', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CloudPatraForm(initialApplicationData: {'appStage': 'status', 'statusStage': 'submitted'}),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Subtitle
    expect(find.text('Application Status'), findsOneWidget);
    expect(find.text('Track Your Application Progress'), findsOneWidget);

    // Verify Brand Header
    expect(find.text('CLOUDPATRA'), findsOneWidget);

    // Verify 6 Stages
    expect(find.text('Submitted'), findsWidgets);
    expect(find.text('Under Review'), findsWidgets);
    expect(find.text('Interrogation'), findsWidgets);
    expect(find.text('Training'), findsWidgets);
    expect(find.text('Completed'), findsWidgets);
    expect(find.text('Active'), findsWidgets);
  });

  testWidgets('OwnifyForm renders Application Status with Ownify branding', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OwnifyForm(initialApplicationData: {'appStage': 'status', 'statusStage': 'submitted'}),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Subtitle
    expect(find.text('Application Status'), findsOneWidget);
    expect(find.text('Track Your Application Progress'), findsOneWidget);

    // Verify Brand Header
    expect(find.text('OWNIFY'), findsOneWidget);

    // Verify 6 Stages
    expect(find.text('Submitted'), findsWidgets);
    expect(find.text('Under Review'), findsWidgets);
    expect(find.text('Interrogation'), findsWidgets);
    expect(find.text('Training'), findsWidgets);
    expect(find.text('Completed'), findsWidgets);
    expect(find.text('Active'), findsWidgets);
  });

  testWidgets('BhoomiVaultForm renders Application Status with BhoomiVault branding', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BhoomiVaultForm(initialApplicationData: {'appStage': 'status', 'statusStage': 'submitted'}),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Subtitle
    expect(find.text('Application Status'), findsOneWidget);
    expect(find.text('Track Your Application Progress'), findsOneWidget);

    // Verify Brand Header
    expect(find.text('BHOOMIVAULT'), findsOneWidget);

    // Verify 6 Stages
    expect(find.text('Submitted'), findsWidgets);
    expect(find.text('Under Review'), findsWidgets);
    expect(find.text('Interrogation'), findsWidgets);
    expect(find.text('Training'), findsWidgets);
    expect(find.text('Completed'), findsWidgets);
    expect(find.text('Active'), findsWidgets);
  });

  testWidgets('BuildAiHomesForm renders Application Status with Build AI Homes branding', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BuildAiHomesForm(initialApplicationData: {'appStage': 'status', 'statusStage': 'submitted'}),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Subtitle
    expect(find.text('Application Status'), findsOneWidget);
    expect(find.text('Track Your Application Progress'), findsOneWidget);

    // Verify Brand Header
    expect(find.text('BUILD AI HOMES'), findsOneWidget);

    // Verify 6 Stages
    expect(find.text('Submitted'), findsWidgets);
    expect(find.text('Under Review'), findsWidgets);
    expect(find.text('Interrogation'), findsWidgets);
    expect(find.text('Training'), findsWidgets);
    expect(find.text('Completed'), findsWidgets);
    expect(find.text('Active'), findsWidgets);
  });

  testWidgets('YuvaUdyamiForm renders Application Status with Yuva Udyami branding', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: YuvaUdyamiForm(initialApplicationData: {'appStage': 'status', 'statusStage': 'submitted'}),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Subtitle
    expect(find.text('Application Status'), findsOneWidget);
    expect(find.text('Track Your Application Progress'), findsOneWidget);

    // Verify Brand Header
    expect(find.text('YUVA UDYAMI'), findsOneWidget);

    // Verify 6 Stages
    expect(find.text('Submitted'), findsWidgets);
    expect(find.text('Under Review'), findsWidgets);
    expect(find.text('Interrogation'), findsWidgets);
    expect(find.text('Training'), findsWidgets);
    expect(find.text('Completed'), findsWidgets);
    expect(find.text('Active'), findsWidgets);
  });

  testWidgets('FirstChoiceBankForm renders Application Status with First Choice Bank branding', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FirstChoiceBankForm(initialApplicationData: {'appStage': 'status', 'statusStage': 'submitted'}),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Subtitle
    expect(find.text('Application Status'), findsOneWidget);
    expect(find.text('Track Your Application Progress'), findsOneWidget);

    // Verify Brand Header
    expect(find.text('FIRST CHOICE BANK'), findsOneWidget);

    // Verify 6 Stages
    expect(find.text('Submitted'), findsWidgets);
    expect(find.text('Under Review'), findsWidgets);
    expect(find.text('Interrogation'), findsWidgets);
    expect(find.text('Training'), findsWidgets);
    expect(find.text('Completed'), findsWidgets);
    expect(find.text('Active'), findsWidgets);
  });

  testWidgets('FirstGoStayForm renders Application Status with First Go Stay branding', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FirstGoStayForm(initialApplicationData: {'appStage': 'status', 'statusStage': 'submitted'}),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Subtitle
    expect(find.text('Application Status'), findsOneWidget);
    expect(find.text('Track Your Application Progress'), findsOneWidget);

    // Verify Brand Header
    expect(find.text('FIRST GO STAY'), findsOneWidget);

    // Verify 6 Stages
    expect(find.text('Submitted'), findsWidgets);
    expect(find.text('Under Review'), findsWidgets);
    expect(find.text('Interrogation'), findsWidgets);
    expect(find.text('Training'), findsWidgets);
    expect(find.text('Completed'), findsWidgets);
    expect(find.text('Active'), findsWidgets);
  });
}
