import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Configuration for backend API endpoints and environment settings.
class ApiConstants {
  ApiConstants._();

  static String? _customBaseUrl;

  /// Default Base URL:
  /// - Android Emulator: http://10.0.2.2:3000
  /// - Web / iOS Simulator / Desktop: http://localhost:3000
  /// - Override via [setCustomBaseUrl] if testing on physical devices over Wi-Fi.
  static String get baseUrl {
    if (_customBaseUrl != null && _customBaseUrl!.isNotEmpty) {
      return _customBaseUrl!;
    }
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  static void setCustomBaseUrl(String newUrl) {
    _customBaseUrl = newUrl;
  }

  // ── Authentication Endpoints ──
  static const String login = '/tmf-api/login';
  static const String register = '/tmf-api/RegisterV2';
  static const String verifyOtp = '/tmf-api/register/otp/verify';
  static const String resendOtp = '/tmf-api/resend-otp';
  static const String refreshToken = '/tmf-api/refreshToken';
  static const String changePassword = '/tmf-api/change-password';
  static const String getUserInfo = '/api/Account/GetUserInfo';

  // ── Usage & Dashboard Endpoints ──
  static const String dashboardSummary = '/api/ISP_SOA/dashboard/summary';
  static const String currentUsage = '/tmf-api/usageManagement/v4/usage';
  static const String dailyUsage = '/tmf-api/usageManagement/v4/daily/usage';
  static const String enhancedDailyUsage = '/tmf-api/usageManagement/v4/usage/EnhancedCurrentDailyUsage';
  static const String previousMonthUsage = '/tmf-api/usageManagement/v4/PreviousMonth/usage';
  static const String freeData = '/api/ISP_SOA/dashboard/free_data';
  static const String bonusData = '/api/ISP_SOA/dashboard/bonus_data';
  static const String myPackage = '/api/ISP_SOA/dashboard/mypackage';
}
