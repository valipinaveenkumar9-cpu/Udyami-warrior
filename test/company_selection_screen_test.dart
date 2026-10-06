import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uk_circle_partners/core/utils/session_manager.dart';
import 'package:uk_circle_partners/features/onboarding/presentation/company_selection_screen.dart';

void main() {
  testWidgets('CompanySelectionScreen displays CloudPatra, Ownify, CirclePAC, and BhoomiVault', (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    SharedPreferences.setMockInitialValues({});
    await SessionManager.init();

    await tester.pumpWidget(const MaterialApp(
      home: CompanySelectionScreen(),
    ));

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify header text
    expect(find.text('Choose to Be Warrior'), findsOneWidget);
    expect(
      find.textContaining('Choose a company below to begin your Warrior application'),
      findsOneWidget,
    );

    // Verify the required companies are present
    expect(find.text('CloudPatra'), findsOneWidget);
    expect(find.text('Ownify'), findsOneWidget);
    expect(find.text('CirclePAC'), findsOneWidget);
    expect(find.text('BhoomiVault'), findsOneWidget);
    expect(find.text('Build AI Homes'), findsOneWidget);
    expect(find.text('FIRST GO STAY'), findsOneWidget);

    // Verify list cards exist
    expect(find.byType(GestureDetector), findsWidgets);

    // Verify the excluded companies are NOT present
    expect(find.text('Udyami Queens'), findsNothing);
    expect(find.text('Build Mall Logistics'), findsNothing);
    expect(find.text('FD and Loan'), findsNothing);
    expect(find.text('E3 (Yuva)'), findsNothing);
    expect(find.text('First Choice Stay'), findsNothing);
    expect(find.text('Lands and Homes'), findsNothing);
  });
}
