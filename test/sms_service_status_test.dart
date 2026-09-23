import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myslt_app_2026/core/network/api_constants.dart';
import 'package:myslt_app_2026/features/bill/data/repositories/bill_repository.dart';

class MockSmsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == ApiConstants.smsServiceStatusRequest && options.method == 'GET') {
      final accountNo = options.queryParameters['accountNo'];
      final tpNo = options.queryParameters['tpNo'];

      if (accountNo == '0049816073' && tpNo == '0112322656') {
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'isSuccess': true,
              'statusCode': 200,
              'accountNo': '0049816073',
              'tpNo': '0112322656',
              'smsServiceStatus': 'ACTIVE',
              'status': 'active',
            },
          ),
        );
        return;
      }

      if (accountNo == 'INACTIVE_ACC') {
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'isSuccess': true,
              'statusCode': 200,
              'accountNo': 'INACTIVE_ACC',
              'tpNo': '0779999999',
              'smsServiceStatus': 'INACTIVE',
              'status': 'inactive',
            },
          ),
        );
        return;
      }

      handler.reject(
        DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: 404,
            data: {
              'isSuccess': false,
              'statusCode': 404,
              'errorMessage': 'SMS service status record not found',
            },
          ),
        ),
      );
      return;
    }

    super.onRequest(options, handler);
  }
}

void main() {
  group('Endpoint 20: GET SMSServiceStatusRequest Tests', () {
    late Dio dio;
    late BillRepository billRepository;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));
      dio.interceptors.add(MockSmsInterceptor());
      billRepository = BillRepository(dio: dio);
    });

    test('successfully fetches active SMS Service status with query params', () async {
      final result = await billRepository.getSmsServiceStatus(
        accountNo: '0049816073',
        tpNo: '0112322656',
      );

      expect(result.isSuccess, isTrue);
      expect(result.accountNo, '0049816073');
      expect(result.tpNo, '0112322656');
      expect(result.smsServiceStatus, 'ACTIVE');
      expect(result.isActive, isTrue);
    });

    test('correctly handles inactive SMS Service status', () async {
      final result = await billRepository.getSmsServiceStatus(
        accountNo: 'INACTIVE_ACC',
        tpNo: '0779999999',
      );

      expect(result.isSuccess, isTrue);
      expect(result.accountNo, 'INACTIVE_ACC');
      expect(result.smsServiceStatus, 'INACTIVE');
      expect(result.isActive, isFalse);
    });

    test('gracefully falls back when endpoint returns 404 or fails', () async {
      final result = await billRepository.getSmsServiceStatus(
        accountNo: 'UNKNOWN_ACC',
        tpNo: '0770000000',
      );

      expect(result.isSuccess, isTrue);
      expect(result.accountNo, 'UNKNOWN_ACC');
      expect(result.tpNo, '0770000000');
    });
  });
}
