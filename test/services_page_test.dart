import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myslt_app_2026/features/services/presentation/pages/services_page.dart';

void main() {
  testWidgets('ServicesPage renders all 8 Account Services options',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const MaterialApp(
        home: ServicesPage(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Subtitle
    expect(find.text('Account Services'), findsOneWidget);
    expect(
      find.text('Manage your connection and account services in one place.'),
      findsOneWidget,
    );

    // Verify all 8 services exist
    expect(find.text('Reconnection'), findsOneWidget);
    expect(find.text('Relocation'), findsOneWidget);
    expect(find.text('Transfer Ownership'), findsOneWidget);
    expect(find.text('Package Migration'), findsOneWidget);
    expect(find.text('Service Vacation'), findsOneWidget);
    expect(find.text('Termination'), findsOneWidget);
    expect(find.text('Refund Request'), findsOneWidget);
    expect(find.text('General Request'), findsOneWidget);

    // Tap Reconnection and verify SnackBar
    await tester.tap(find.text('Reconnection'));
    await tester.pump();

    expect(find.text('Reconnection selected'), findsOneWidget);
  });
}
