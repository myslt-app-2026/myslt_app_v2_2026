/// All API endpoint constants for the mySLT backend.
/// Base URL is loaded from the DioClient via environment variables.
abstract final class ApiEndpoints {
  // ─── Auth ──────────────────────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String otpSend = '/auth/otp/send';
  static const String otpVerify = '/auth/otp/verify';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // ─── Account / Home ────────────────────────────────────────────────────────
  static const String accountSummary = '/account/summary';
  static const String promotions = '/promotions';

  // ─── Billing ───────────────────────────────────────────────────────────────
  static const String currentBill = '/billing/current';
  static const String billHistory = '/billing/history';
  static const String billDownload = '/billing/download'; // + /{billId}

  // ─── Usage ─────────────────────────────────────────────────────────────────
  static const String dailyUsage = '/usage/daily';   // ?date=YYYY-MM-DD
  static const String monthlyReport = '/usage/report'; // ?month=YYYY-MM

  // ─── Packages ──────────────────────────────────────────────────────────────
  static const String packages = '/packages';         // ?type=prepaid|postpaid
  static const String activatePackage = '/packages/activate';
  static const String upgradePackage = '/packages/upgrade';

  // ─── Profile ───────────────────────────────────────────────────────────────
  static const String profile = '/profile';
  static const String updateContact = '/profile/contact';
  static const String callForwarding = '/profile/call-forwarding';

  // ─── Connections ───────────────────────────────────────────────────────────
  static const String connections = '/connections';
  static const String addConnection = '/connections/add';
  static const String removeConnection = '/connections'; // DELETE /{id}

  // ─── PeoTV ─────────────────────────────────────────────────────────────────
  static const String peoTVPackages = '/peotv/packages';
  static const String activatePeoTV = '/peotv/activate';

  // ─── Loyalty & More ────────────────────────────────────────────────────────
  static const String loyaltyPoints = '/loyalty/points';
  static const String redeemData = '/loyalty/redeem';
  static const String faultReport = '/support/fault';
}
