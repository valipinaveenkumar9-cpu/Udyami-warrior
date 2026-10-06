import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uk_circle_partners/features/onboarding/presentation/forms/first_go_stay_form.dart';

void main() {
  testWidgets('FirstGoStayForm renders, loads demo applicant, and navigates through steps', (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(
      home: FirstGoStayForm(),
    ));

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Brand & Topbar
    expect(find.text('FIRSTGO'), findsOneWidget);
    expect(find.text('Channel Partner Registration'), findsOneWidget);
    expect(find.text('↺ Restart'), findsOneWidget);

    // Verify Step 1: About You
    expect(find.text('About You'), findsOneWidget);
    expect(find.text('As it appears on your Aadhaar / PAN card'), findsOneWidget);
    expect(find.text('STEP 1/9'), findsOneWidget);

    // Verify Prototype Demo Banner
    expect(find.text('Load Demo Applicant'), findsOneWidget);

    // Click Load Demo Applicant
    await tester.tap(find.text('Load Demo Applicant'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Check that Demo Applicant fields are filled
    expect(find.text('Rohan Mehta'), findsWidgets);
    expect(find.text('123123'), findsOneWidget);
    expect(find.text('9822334455'), findsWidgets);

    // Step 1 -> Step 2
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('STEP 2/9'), findsOneWidget);
    expect(find.text('Verify Your Aadhaar'), findsOneWidget);
    expect(find.text('Aadhaar verified successfully'), findsOneWidget);

    // Step 2 -> Step 3
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('STEP 3/9'), findsOneWidget);
    expect(find.text('Business & Experience'), findsOneWidget);

    // Step 3 -> Step 4
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('STEP 4/9'), findsOneWidget);
    expect(find.text("Where You'll Work From"), findsOneWidget);

    // Step 4 -> Step 5
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('STEP 5/9'), findsOneWidget);
    expect(find.text('Your Bank Details'), findsOneWidget);

    // Step 5 -> Step 6
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('STEP 6/9'), findsOneWidget);
    expect(find.text("What You'd Like to Do"), findsOneWidget);
    expect(find.text('NestFirst™'), findsOneWidget);
    expect(find.text('SkyFirst™'), findsOneWidget);
    expect(find.text('GoVault™'), findsOneWidget);
  });

  testWidgets('FirstGoStayForm renders unified Application Status timeline with dynamic comments', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(
      home: FirstGoStayForm(
        initialApplicationData: {'status': 'submitted', 'applicationId': 'FGS-TEST-123'},
      ),
    ));

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Application Status Header & Subtitle
    expect(find.text('APPLICATION STATUS'), findsOneWidget);
    expect(find.text('Track Your Application Progress'), findsOneWidget);
    expect(find.text('FIRST GO STAY'), findsWidgets);

    // Verify all 6 stages
    expect(find.text('SUBMITTED'), findsWidgets);
    expect(find.text('UNDER REVIEW'), findsWidgets);
    expect(find.text('INTERROGATION'), findsWidgets);
    expect(find.text('TRAINING'), findsWidgets);
    expect(find.text('COMPLETED'), findsWidgets);
    expect(find.text('ACTIVE'), findsWidgets);

    // Verify dynamic comments/action messages
    expect(find.text('Completed – Application submitted successfully'), findsOneWidget);
    expect(find.text('Pending – Application is under review'), findsOneWidget);
    expect(find.text('Pending – Please complete the interrogation'), findsOneWidget);
    expect(find.text('Pending – Please complete your training.'), findsOneWidget);

    // Verify simulation pills switch status
    final interrogationBtn = find.widgetWithText(InkWell, 'INTERROGATION');
    expect(interrogationBtn, findsOneWidget);
    await tester.tap(interrogationBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Completed – Documents verified & approved'), findsOneWidget);
  });
}
