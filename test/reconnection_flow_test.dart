import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myslt_app_2026/features/services/presentation/pages/reconnection_step1_page.dart';
import 'package:myslt_app_2026/features/services/presentation/pages/reconnection_step2_page.dart';
import 'package:myslt_app_2026/features/services/presentation/pages/reconnection_step3_page.dart';

void main() {
  testWidgets('ReconnectionStep1Page renders and navigates to Step 2 and Step 3',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ReconnectionStep1Page(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reconnection'), findsOneWidget);
    expect(find.text('Customer Information Verified'), findsOneWidget);
    expect(find.text('Select Services to Reactivate'), findsOneWidget);
    expect(find.text('Voice (Telephone)'), findsOneWidget);
    expect(find.text('PeoTV'), findsOneWidget);
    expect(find.text('SLT Broadband Internet (ADSL/Wi-Max)'), findsOneWidget);

    final nextBtn = find.widgetWithText(ElevatedButton, 'Next: Details & Documents');
    expect(tester.widget<ElevatedButton>(nextBtn).enabled, isTrue);

    // Tap Next to navigate to Step 2
    await tester.tap(nextBtn);
    await tester.pumpAndSettle();

    // Step 2 assertions
    expect(find.text('Details & Documents'), findsWidgets);
    expect(find.text('Pending Balance Settlement'), findsOneWidget);
    expect(find.text('Digital Signature *'), findsOneWidget);
    expect(find.text('Customer Agreement'), findsOneWidget);
    expect(find.text('Signature Method'), findsOneWidget);

    // Accept agreement and draw signature
    await tester.tap(find.text('Terms and Conditions'));
    await tester.pumpAndSettle();

    final sigPad = find.byType(GestureDetector).last;
    await tester.drag(sigPad, const Offset(60, 60));
    await tester.pumpAndSettle();

    // Tap Next Step to advance to Step 3
    final nextStepBtn = find.widgetWithText(ElevatedButton, 'Next Step');
    await tester.tap(nextStepBtn);
    await tester.pumpAndSettle();

    // Step 3 assertions
    expect(find.text('Checkout & Auth'), findsWidgets);
    expect(find.text('Mobile Verified!'), findsOneWidget);
    expect(find.text('Payment Summary'), findsOneWidget);
    expect(find.text('Declaration'), findsOneWidget);
    expect(find.text('Customer Information Verified'), findsNothing);
  });

  testWidgets('ReconnectionStep2Page validates agreement & signature and navigates to Step 3',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ReconnectionStep2Page(
            selectedServices: ['Voice (Telephone)', 'PeoTV'],
            pendingBalance: 0.0,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Details & Documents'), findsOneWidget);
    expect(find.text('Customer Information Verified'), findsOneWidget);

    final nextStepBtn = find.widgetWithText(ElevatedButton, 'Next Step');

    // Tap Next without agreement or signature
    await tester.tap(nextStepBtn);
    await tester.pump();
    expect(find.text('Accept the agreement and provide a signature.'), findsOneWidget);

    // Check agreement
    await tester.tap(find.text('I accept the Terms and Conditions'));
    await tester.pumpAndSettle();

    // Draw signature
    final sigPad = find.byType(GestureDetector).last;
    await tester.drag(sigPad, const Offset(50, 50));
    await tester.pumpAndSettle();

    // Tap Next
    await tester.tap(nextStepBtn);
    await tester.pumpAndSettle();

    // Step 3
    expect(find.text('Checkout & Auth'), findsOneWidget);
    expect(find.text('Digital Receipt'), findsOneWidget);
    expect(find.text('Customer Information Verified'), findsNothing);
    expect(find.text('Voice (Telephone)'), findsOneWidget);
    expect(find.text('PeoTV'), findsOneWidget);
  });
}
