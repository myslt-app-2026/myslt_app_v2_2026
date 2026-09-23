import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myslt_app_2026/core/network/api_constants.dart';
import 'package:myslt_app_2026/features/auth/data/repositories/auth_repository.dart';

class MockInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == ApiConstants.changePassword && options.method == 'POST') {
      final data = options.data as Map<String, dynamic>;
      if (data['oldPassword'] == 'WrongOldPassword!') {
        handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 401,
              data: {
                'code': 'CHANGE_PASSWORD_FAILED',
                'message': 'Invalid current password',
              },
            ),
          ),
        );
        return;
      }

      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'code': 'PASSWORD_CHANGED',
            'status': 'SUCCESS',
            'success': true,
            'message': 'Password changed successfully',
          },
        ),
      );
      return;
    }

    super.onRequest(options, handler);
  }
}

void main() {
  group('Endpoint 6: Change Account Password Tests', () {
    late Dio dio;
    late AuthRepository authRepository;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));
      dio.interceptors.add(MockInterceptor());
      authRepository = AuthRepository(dio: dio);
    });

    test('successfully changes password with valid current password', () async {
      final result = await authRepository.changePassword(
        username: 'user@slt.lk',
        oldPassword: 'OldPassword123!',
        newPassword: 'NewPassword123!',
      );

      expect(result.isSuccess, isTrue);
      expect(result.message, 'Password changed successfully');
    });

    test('returns failure when server rejects wrong old password', () async {
      final result = await authRepository.changePassword(
        username: 'user@slt.lk',
        oldPassword: 'WrongOldPassword!',
        newPassword: 'NewPassword123!',
      );

      expect(result.isSuccess, isFalse);
      expect(result.message, contains('Invalid current password'));
    });
  });
}
