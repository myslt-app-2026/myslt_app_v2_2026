import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myslt_app_2026/features/services/presentation/pages/services_page.dart';

void main() {
  testWidgets('ServicesPage renders and filters services correctly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ServicesPage(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify Title & Search bar
    expect(find.text('Services'), findsOneWidget);
    expect(find.byType(SearchBar), findsOneWidget);

    // Verify Categories exist
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Broadband'), findsOneWidget);
    expect(find.text('TV'), findsOneWidget);

    // Verify initial services are present
    expect(find.text('Fiber Broadband'), findsOneWidget);
    expect(find.text('New Connection'), findsOneWidget);

    // Filter by TV category
    await tester.tap(find.text('TV'));
    await tester.pumpAndSettle();

    expect(find.text('PEO TV'), findsOneWidget);
    expect(find.text('PEO TV GO'), findsOneWidget);
    expect(find.text('Fiber Broadband'), findsNothing);

    // Search for a non-existent item
    final searchBar = find.byType(SearchBar);
    await tester.enterText(searchBar, 'xyznonexistent');
    await tester.pumpAndSettle();

    expect(find.text('No matching services found'), findsOneWidget);

    // Reset filters
    await tester.tap(find.text('Reset Filters'));
    await tester.pumpAndSettle();

    expect(find.text('Fiber Broadband'), findsOneWidget);
  });
}

