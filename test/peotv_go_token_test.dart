import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myslt_app_2026/features/peotv/data/repositories/peotv_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = null;
  FlutterSecureStorage.setMockInitialValues({});


  group('Endpoint 36: Get PEO TV GO Streaming Access Token', () {


    test('getPeoTvGoAccessToken returns valid token structure', () async {
      final repository = PeoTvRepository();

      try {
        final result = await repository.getPeoTvGoAccessToken(
          subscriberId: '0312241780',
          channel: 'MYSLT_APP',
        );

        expect(result, isNotNull);
        expect(result['status'], equals('SUCCESS'));
        expect(result['accessToken'], startsWith('PEOTVGO-'));
        expect(result['tokenType'], equals('Bearer'));
        expect(result['subscriberId'], equals('0312241780'));
        expect(result['channel'], equals('MYSLT_APP'));
      } catch (e) {
        expect(e, isNotNull);
      }
    });

  });
}
