import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Manages secure persistence of access & refresh tokens and session data.
class TokenStorage {
  TokenStorage._();
  static final TokenStorage instance = TokenStorage._();

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUserId = 'user_id';
  static const _keyUsername = 'username';
  static const _keyRegId = 'registration_id';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String? userId,
    String? username,
  }) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
    if (userId != null) await _storage.write(key: _keyUserId, value: userId);
    if (username != null) await _storage.write(key: _keyUsername, value: username);
  }

  Future<void> saveRegistrationId(String regId) async {
    await _storage.write(key: _keyRegId, value: regId);
  }

  Future<String?> getRegistrationId() async {
    return await _storage.read(key: _keyRegId);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  Future<String?> getUsername() async {
    return await _storage.read(key: _keyUsername);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
