import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

/// Intercepts outgoing requests to attach JWT Authorization header.
class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await TokenStorage.instance.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // If 401 Unauthorized occurs, handle token refresh or bubble error
    handler.next(err);
  }
}
