/// Configuration for backend API endpoints and environment settings.
class ApiConstants {
  ApiConstants._();

  /// Default Base URL:
  /// - Web / Desktop: http://localhost:3000
  /// - Android Emulator: http://10.0.2.2:3000
  /// - Override via [setCustomBaseUrl] if testing on physical devices over Wi-Fi.
  static String _baseUrl = 'http://192.168.1.2:3000';

  static String get baseUrl => _baseUrl;

  static void setCustomBaseUrl(String newUrl) {
    _baseUrl = newUrl;
  }

  // ── Authentication Endpoints ──
  static const String login = '/tmf-api/login';
  static const String register = '/tmf-api/RegisterV2';
  static const String verifyOtp = '/tmf-api/register/otp/verify';
  static const String resendOtp = '/tmf-api/resend-otp';
  static const String refreshToken = '/tmf-api/refreshToken';
  static const String changePassword = '/tmf-api/change-password';
  static const String getUserInfo = '/api/Account/GetUserInfo';
}
