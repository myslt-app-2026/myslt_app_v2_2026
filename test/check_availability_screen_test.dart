import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:myslt_app_2026/core/router/app_router.dart';
import 'package:myslt_app_2026/features/new_connection/data/models/connection_package.dart';
import 'package:myslt_app_2026/features/new_connection/data/new_connection_repository.dart';
import 'package:myslt_app_2026/features/new_connection/presentation/screens/check_availability_screen.dart';
import 'package:myslt_app_2026/features/new_connection/presentation/screens/nic_upload_screen.dart';
import 'package:myslt_app_2026/features/new_connection/presentation/screens/package_selection_screen.dart';
import 'package:myslt_app_2026/features/new_connection/presentation/screens/selfie_verification_screen.dart';
import 'package:myslt_app_2026/features/new_connection/providers/new_connection_providers.dart';

class _MockNewConnectionRepository extends NewConnectionRepository {
  @override
  Future<CoverageResult> checkCoverage({
    required String street,
    String? landmark,
    required String city,
    required String district,
  }) async {
    return const CoverageResult(
      available: true,
      title: 'Fibre available',
      subtitle: 'Continue to choose an installation time.',
    );
  }
}

void main() {
  testWidgets('PackageSelectionScreen renders Step 1 of 7',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: PackageSelectionScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Step 1 of 7'), findsOneWidget);
    expect(find.text('Choose your package'), findsOneWidget);
  });

  testWidgets('NicUploadScreen renders Step 2 of 7',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: NicUploadScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Step 2 of 7'), findsOneWidget);
    expect(find.text('Verify your identity'), findsOneWidget);
  });

  testWidgets(
      'CheckAvailabilityScreen starts with empty fields and displays coverage result upon checking',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    const selectedPkg = ConnectionPackage(
      id: 'fibre_basic',
      name: 'Fibre Starter',
      type: 'Fibre',
      speedLabel: '50 Mbps',
      monthlyRental: 2990,
      features: ['Free Wi-Fi router'],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          newConnectionRepositoryProvider
              .overrideWithValue(_MockNewConnectionRepository()),
          orderProvider.overrideWith(
            () => _TestOrderNotifier(const OrderState(package: selectedPkg)),
          ),
        ],
        child: const MaterialApp(
          home: CheckAvailabilityScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify AppBar title & Step 4 of 7
    expect(find.text('New connection'), findsOneWidget);
    expect(find.text('Step 4 of 7'), findsOneWidget);

    // Verify headings
    expect(find.text('Check availability'), findsOneWidget);
    expect(
      find.text('Enter the address where you want your new connection.'),
      findsOneWidget,
    );
    expect(find.text('Installation address'), findsOneWidget);

    // Verify fields are empty initially (no hardcoded sample data)
    expect(find.text('No. 55, Main Street'), findsNothing);
    expect(find.text('Negombo'), findsNothing);
    expect(find.text('Select district'), findsOneWidget);

    // Result banner should NOT be visible initially
    expect(find.text('Fibre available'), findsNothing);
    expect(find.text('Sample result: fibre available'), findsNothing);

    // Order summary bar displays the selected package rental (Rs. 2,990 / month)
    expect(find.text('Rs. 2,990 / month'), findsOneWidget);
    expect(
      find.text('+ Rs. 4,500 one-time connection charge'),
      findsOneWidget,
    );

    // Enter address details
    final streetFinder =
        find.widgetWithText(TextFormField, 'House number and street');
    await tester.enterText(streetFinder, '123 Temple Road');

    final cityFinder = find.widgetWithText(TextFormField, 'City / town');
    await tester.enterText(cityFinder, 'Colombo');

    // Select district via dropdown
    final dropdownFinder = find.byType(DropdownButtonFormField<String>);
    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Colombo').last);
    await tester.pumpAndSettle();

    // Tap Check fibre availability
    final checkButton = find.text('Check fibre availability');
    expect(checkButton, findsOneWidget);
    await tester.tap(checkButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Result banner should now be visible with API returned result
    expect(find.text('Fibre available'), findsOneWidget);
    expect(
      find.text('Continue to choose an installation time.'),
      findsOneWidget,
    );
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
    expect(find.text('Step 3 of 7'), findsOneWidget);

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

class _TestOrderNotifier extends OrderNotifier {
  _TestOrderNotifier(this._initial);
  final OrderState _initial;

  @override
  OrderState build() => _initial;
}
