import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myslt_app_2026/main.dart';

class MockAssetLoader extends AssetLoader {
  const MockAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return <String, dynamic>{};
  }
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('mySLT app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        assetLoader: const MockAssetLoader(),
        child: const ProviderScope(
          child: MySLTApp(),
        ),
      ),
    );

    // Build the widget tree
    await tester.pump();

    // Advance virtual time by 2 seconds to allow all initial animations
    // and delayed timers (like flutter_animate) to fire and complete.
    await tester.pump(const Duration(seconds: 2));

    // App should render without throwing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
