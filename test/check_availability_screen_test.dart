import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:myslt_app_2026/core/router/app_router.dart';
import 'package:myslt_app_2026/features/new_connection/presentation/screens/check_availability_screen.dart';
import 'package:myslt_app_2026/features/new_connection/presentation/screens/selfie_verification_screen.dart';

void main() {
  testWidgets('CheckAvailabilityScreen renders all UI elements accurately',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CheckAvailabilityScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify AppBar title
    expect(find.text('New connection'), findsOneWidget);

    // Verify Step progress
    expect(find.text('Step 4 of 7'), findsOneWidget);

    // Verify headings
    expect(find.text('Check availability'), findsOneWidget);
    expect(
      find.text('Enter the address where you want your new connection.'),
      findsOneWidget,
    );
    expect(find.text('Installation address'), findsOneWidget);

    // Verify prefilled form fields
    expect(find.text('No. 55, Main Street'), findsOneWidget);
    expect(find.text('Negombo'), findsOneWidget);
    expect(find.text('Gampaha'), findsOneWidget);

    // Verify check fibre availability button
    expect(find.text('Check fibre availability'), findsOneWidget);

    // Verify sample result banner
    expect(find.text('Sample result: fibre available'), findsOneWidget);
    expect(
      find.text('Continue to choose an installation time.'),
      findsOneWidget,
    );

    // Verify Order summary bar & Continue button
    expect(find.textContaining('/ month'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('Continue in Selfie screen navigates to CheckAvailabilityScreen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final router = GoRouter(
      initialLocation: AppRoutes.newConnectionSelfie,
      routes: [
        GoRoute(
          path: AppRoutes.newConnectionSelfie,
          builder: (context, state) => const SelfieVerificationScreen(),
        ),
        GoRoute(
          path: AppRoutes.newConnectionAvailability,
          builder: (context, state) => const CheckAvailabilityScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Initially on Selfie Verification page
    expect(find.text('Verify your selfie'), findsOneWidget);

    // Tap Continue button on OrderSummaryBar
    final continueFinder = find.widgetWithText(FilledButton, 'Continue');
    expect(continueFinder, findsOneWidget);
    await tester.tap(continueFinder);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Successfully transitioned to Check Availability page
    expect(find.text('Check availability'), findsOneWidget);
    expect(find.text('Step 4 of 7'), findsOneWidget);
  });
}
