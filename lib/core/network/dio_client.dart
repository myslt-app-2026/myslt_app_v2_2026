import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// The base URL for the mySLT API.
/// Override this with your environment variable in production.
const _kBaseUrl = 'https://api.myslt.lk/v1';

/// Configured Dio HTTP client with auth + logging interceptors.
///
/// Usage:
/// ```dart
/// final dio = ref.read(dioClientProvider);
/// final response = await dio.get('/account/summary');
/// ```
Dio createDioClient({String baseUrl = _kBaseUrl}) {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(storage),
    LoggingInterceptor(),
  ]);

  return dio;
}

/// Riverpod provider for the Dio HTTP client singleton.
final dioClientProvider = Provider<Dio>((ref) {
  final dio = createDioClient();
  ref.onDispose(dio.close);
  return dio;
});
