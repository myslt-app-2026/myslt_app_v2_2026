import 'package:dio/dio.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/user_entity.dart';

class AuthResult {
  const AuthResult({
    required this.isSuccess,
    this.message,
    this.accessToken,
    this.refreshToken,
    this.userId,
    this.name,
    this.registrationId,
  });

  final bool isSuccess;
  final String? message;
  final String? accessToken;
  final String? refreshToken;
  final String? userId;
  final String? name;
  final String? registrationId;
}

class AuthRepository {
  AuthRepository({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  final Dio _dio;

  /// Perform user login against POST /tmf-api/login
  Future<AuthResult> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'username': username,
          'password': password,
          'channelID': 'MYSLT_APP',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final accessToken = data['accessToken'] as String?;
        final refreshToken = data['refreshToken'] as String?;
        final userId = data['user_id']?.toString();
        final name = data['name'] as String?;

        if (accessToken != null && refreshToken != null) {
          await TokenStorage.instance.saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
            userId: userId,
            username: username,
          );

          return AuthResult(
            isSuccess: true,
            accessToken: accessToken,
            refreshToken: refreshToken,
            userId: userId,
            name: name,
          );
        }
      }

      return AuthResult(
        isSuccess: false,
        message: response.data?['message'] ?? 'Login failed. Please try again.',
      );
    } on DioException catch (e) {
      return AuthResult(
        isSuccess: false,
        message: _parseDioError(e),
      );
    } catch (e) {
      return AuthResult(
        isSuccess: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  /// Register a new user against POST /tmf-api/RegisterV2
  Future<AuthResult> register({
    required String name,
    required String mobile,
    required String email,
    required String password,
    String? nic,
    String? accountNumber,
  }) async {
    try {
      final nameParts = name.trim().split(' ');
      final firstName = nameParts.first;
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final response = await _dio.post(
        ApiConstants.register,
        data: {
          'username': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'mobile': mobile,
        },
      );

      if ((response.statusCode == 200 || response.statusCode == 201) && response.data != null) {
        final resData = response.data;
        if (resData['status'] == 'SUCCESS' && resData['data'] != null) {
          final regId = resData['data']['registrationId']?.toString();
          if (regId != null) {
            await TokenStorage.instance.saveRegistrationId(regId);
            return AuthResult(
              isSuccess: true,
              registrationId: regId,
            );
          }
        }
      }

      return AuthResult(
        isSuccess: false,
        message: response.data?['message'] ?? 'Registration failed',
      );
    } on DioException catch (e) {
      return AuthResult(
        isSuccess: false,
        message: _parseDioError(e),
      );
    } catch (e) {
      return AuthResult(
        isSuccess: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  /// Verify OTP against POST /tmf-api/register/otp/verify
  Future<AuthResult> verifyOtp({
    required String registrationId,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.verifyOtp,
        data: {
          'registrationId': registrationId,
          'otp': otp,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final resData = response.data;
        if (resData['status'] == 'SUCCESS' && resData['data'] != null) {
          final tokens = resData['data'];
          final accessToken = tokens['accessToken'] as String?;
          final refreshToken = tokens['refreshToken'] as String?;

          if (accessToken != null && refreshToken != null) {
            await TokenStorage.instance.saveTokens(
              accessToken: accessToken,
              refreshToken: refreshToken,
            );

            return AuthResult(
              isSuccess: true,
              accessToken: accessToken,
              refreshToken: refreshToken,
            );
          }
        }
      }

      return AuthResult(
        isSuccess: false,
        message: response.data?['error'] ?? 'OTP verification failed',
      );
    } on DioException catch (e) {
      return AuthResult(
        isSuccess: false,
        message: _parseDioError(e),
      );
    } catch (e) {
      return AuthResult(
        isSuccess: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }
  /// Endpoint 7: Get User Profile Information
  /// GET /api/Account/GetUserInfo?userName=...
  Future<UserEntity> getUserInfo({String? userName}) async {
    final effectiveUser = userName ??
        await TokenStorage.instance.getUsername() ??
        'user@slt.lk';

    try {
      final response = await _dio.get(
        ApiConstants.getUserInfo,
        queryParameters: {'userName': effectiveUser},
      );

      if (response.statusCode == 200 && response.data != null) {
        final resData = response.data;
        final payload = resData is Map && resData.containsKey('data')
            ? resData['data']
            : resData;

        if (payload is Map<String, dynamic>) {
          final first = payload['firstName']?.toString() ?? '';
          final last = payload['lastName']?.toString() ?? '';
          final fullName = payload['name']?.toString() ??
              payload['fullName']?.toString() ??
              '$first $last'.trim();

          return UserEntity(
            id: payload['id']?.toString() ?? payload['nic']?.toString() ?? 'USR-001',
            name: fullName.isNotEmpty ? fullName : 'Kasun Perera',
            nic: payload['nic']?.toString() ?? '199512345678',
            mobile: payload['mobile']?.toString() ?? payload['phoneNumber']?.toString() ?? '0771234567',
            email: payload['email']?.toString() ?? effectiveUser,
            accountNumber: payload['accountNumber']?.toString() ?? 'ACC-0094-7821',
          );
        }
      }
    } catch (e) {
      // Graceful fallback on network/server errors
    }

    return MockData.currentUser;
  }

  /// Endpoint 4: Resend Registration OTP
  /// POST /tmf-api/resend-otp
  Future<AuthResult> resendOtp({required String mobile}) async {
    try {
      final response = await _dio.post(
        ApiConstants.resendOtp,
        data: {'mobile': mobile},
      );

      if (response.statusCode == 200 && response.data != null) {
        final resData = response.data;
        if (resData['status'] == 'SUCCESS' || resData['success'] == true) {
          return const AuthResult(isSuccess: true, message: 'OTP resent successfully');
        }
      }

      return AuthResult(
        isSuccess: false,
        message: response.data?['message'] ?? 'Failed to resend OTP',
      );
    } on DioException catch (e) {
      return AuthResult(isSuccess: false, message: _parseDioError(e));
    } catch (e) {
      return AuthResult(isSuccess: false, message: 'An unexpected error occurred: $e');
    }
  }

  /// Endpoint 5: Refresh Access Token
  /// POST /tmf-api/refreshToken
  Future<AuthResult> refreshToken({String? refreshToken}) async {
    final token = refreshToken ?? await TokenStorage.instance.getRefreshToken();
    if (token == null || token.isEmpty) {
      return const AuthResult(isSuccess: false, message: 'No refresh token available');
    }

    try {
      final response = await _dio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': token},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final newAccess = data['accessToken'] as String?;
        final newRefresh = data['refreshToken'] as String?;

        if (newAccess != null && newRefresh != null) {
          await TokenStorage.instance.saveTokens(
            accessToken: newAccess,
            refreshToken: newRefresh,
          );
          return AuthResult(
            isSuccess: true,
            accessToken: newAccess,
            refreshToken: newRefresh,
          );
        }
      }

      return AuthResult(
        isSuccess: false,
        message: response.data?['message'] ?? 'Failed to refresh token',
      );
    } on DioException catch (e) {
      return AuthResult(isSuccess: false, message: _parseDioError(e));
    } catch (e) {
      return AuthResult(isSuccess: false, message: 'An unexpected error occurred: $e');
    }
  }

  /// Endpoint 6: Change Account Password
  /// POST /tmf-api/change-password
  Future<AuthResult> changePassword({
    required String username,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.changePassword,
        data: {
          'username': username,
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final resData = response.data;
        if (resData['status'] == 'SUCCESS' || resData['success'] == true) {
          return const AuthResult(isSuccess: true, message: 'Password changed successfully');
        }
      }

      return AuthResult(
        isSuccess: false,
        message: response.data?['message'] ?? response.data?['error'] ?? 'Password change failed',
      );
    } on DioException catch (e) {
      return AuthResult(isSuccess: false, message: _parseDioError(e));
    } catch (e) {
      return AuthResult(isSuccess: false, message: 'An unexpected error occurred: $e');
    }
  }

  /// Endpoint 8: Update User Profile Information
  /// POST /api/Account/UpdateUserInfo
  Future<AuthResult> updateUserInfo({
    required String userName,
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.updateUserInfo,
        data: {
          'userName': userName,
          if (firstName != null) 'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
          if (email != null) 'email': email,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final resData = response.data;
        if (resData['status'] == 'SUCCESS' || resData['success'] == true || response.statusCode == 200) {
          return const AuthResult(isSuccess: true, message: 'User info updated successfully');
        }
      }

      return AuthResult(
        isSuccess: false,
        message: response.data?['message'] ?? 'Failed to update user profile',
      );
    } on DioException catch (e) {
      return AuthResult(isSuccess: false, message: _parseDioError(e));
    } catch (e) {
      return AuthResult(isSuccess: false, message: 'An unexpected error occurred: $e');
    }
  }

  String _parseDioError(DioException e) {
    if (e.response?.data != null && e.response?.data is Map) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(e.response!.data);
      if (data.containsKey('message') && data['message'] != null && data['message'].toString().isNotEmpty) {
        return data['message'].toString();
      }
      if (data.containsKey('error') && data['error'] != null && data['error'].toString().isNotEmpty) {
        return data['error'].toString();
      }
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Connection timeout. Please check if the Node backend is running on http://10.0.2.2:3000';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'Server unreachable. Please start your backend server (node server.js).';
    }
    return e.message ?? 'Network error occurred. Please try again.';
  }

  /// Check saved session
  Future<bool> checkSession() async {
    final token = await TokenStorage.instance.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Logout
  Future<void> logout() async {
    await TokenStorage.instance.clearAll();
  }
}

