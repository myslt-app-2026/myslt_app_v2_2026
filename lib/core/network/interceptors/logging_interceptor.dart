import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Debug-only request/response logger interceptor.
/// Only active in debug mode — no output in release builds.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────');
      debugPrint('│ 🌐 REQUEST: ${options.method} ${options.uri}');
      if (options.queryParameters.isNotEmpty) {
        debugPrint('│ QUERY: ${options.queryParameters}');
      }
      if (options.data != null) {
        debugPrint('│ BODY: ${options.data}');
      }
      debugPrint('└─────────────────────────────────────────────');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────');
      debugPrint(
          '│ ✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
      debugPrint('└─────────────────────────────────────────────');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────');
      debugPrint(
          '│ ❌ ERROR: ${err.response?.statusCode} ${err.requestOptions.uri}');
      debugPrint('│ MESSAGE: ${err.message}');
      debugPrint('└─────────────────────────────────────────────');
    }
    super.onError(err, handler);
  }
}
