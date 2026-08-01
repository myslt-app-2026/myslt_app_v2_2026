import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_state_provider.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/notifications_page.dart';
import '../../features/home/presentation/pages/promotion_detail_page.dart';
import '../../features/bill/presentation/pages/bill_page.dart';
import '../../features/bill/presentation/pages/bill_payment_page.dart';
import '../../features/usage/presentation/pages/daily_usage_page.dart';
import '../../features/usage/presentation/pages/detailed_report_page.dart';
import '../../features/packages/presentation/pages/packages_page.dart';
import '../../features/packages/presentation/pages/package_upgrade_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/change_contact_page.dart';
import '../../features/connections/presentation/pages/manage_connections_page.dart';
import '../../features/connections/presentation/pages/add_connection_page.dart';
import '../../features/peotv/presentation/pages/peotv_page.dart';
import '../../features/more/presentation/pages/more_page.dart';
import '../../features/more/presentation/pages/loyalty_points_page.dart';
import '../../features/more/presentation/pages/redeem_data_page.dart';
import '../../features/more/presentation/pages/gift_data_page.dart';
import '../../features/more/presentation/pages/data_loan_page.dart';
import '../../features/more/presentation/pages/happy_day_page.dart';
import '../../features/more/presentation/pages/report_fault_page.dart';
import '../../features/more/presentation/pages/idd_services_page.dart';
import '../../features/more/presentation/pages/location_services_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/language_page.dart';
import '../widgets/main_shell.dart';
import '../../features/home/data/models/promotion_model.dart';

/// All named routes in the mySLT application.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';

  // Shell (bottom nav) routes
  static const String home = '/home';
  static const String bill = '/bill';
  static const String usage = '/usage';
  static const String packages = '/packages';
  static const String more = '/more';

  // Sub-routes
  static const String billPayment = '/bill/pay';
  static const String usageReport = '/usage/report';
  static const String packageUpgrade = '/packages/upgrade';
  static const String peotv = '/peotv';
  static const String profile = '/profile';
  static const String changeContact = '/profile/contact';
  static const String connections = '/connections';
  static const String addConnection = '/connections/add';
  static const String settings = '/settings';
  static const String language = '/settings/language';

  // More sub-routes
  static const String loyaltyPoints = '/loyalty-points';
  static const String redeemData = '/redeem-data';
  static const String giftData = '/gift-data';
  static const String dataLoan = '/data-loan';
  static const String happyDay = '/happy-day';
  static const String reportFault = '/report-fault';
  static const String iddServices = '/idd-services';
  static const String locationServices = '/locations';
  static const String notifications = '/notifications';
  static const String promotionDetail = '/promotion/:id';
}

/// The main [GoRouter] provider for the mySLT app.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;
      final isSplash = state.matchedLocation == AppRoutes.splash;
      final isAuthRoute = [
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.otp,
        AppRoutes.forgotPassword,
      ].contains(state.matchedLocation);

      // Still loading auth state — let splash handle it
      if (authState.isLoading) return null;

      // Redirect to login if not authenticated and not already on an auth screen
      if (!isLoggedIn && !isAuthRoute && !isSplash) {
        return AppRoutes.login;
      }

      // Redirect to home if authenticated and trying to access auth screens
      if (isLoggedIn && isAuthRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      // ─── Splash ────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => _fadePage(
          state: state,
          child: const SplashPage(),
        ),
      ),

      // ─── Auth Routes ───────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.otp,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: OtpVerificationPage(
            phoneOrEmail: state.extra as String? ?? '',
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const ForgotPasswordPage(),
        ),
      ),

      // ─── Main Shell (Bottom Nav) ────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => _fadePage(
              state: state,
              child: const HomePage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.bill,
            pageBuilder: (context, state) => _fadePage(
              state: state,
              child: const BillPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.usage,
            pageBuilder: (context, state) => _fadePage(
              state: state,
              child: const DailyUsagePage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.packages,
            pageBuilder: (context, state) => _fadePage(
              state: state,
              child: const PackagesPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.more,
            pageBuilder: (context, state) => _fadePage(
              state: state,
              child: const MorePage(),
            ),
          ),
        ],
      ),

      // ─── Sub-Routes (outside shell) ────────────────────────────────────
      GoRoute(
        path: AppRoutes.billPayment,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const BillPaymentPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.usageReport,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const DetailedReportPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.packageUpgrade,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const PackageUpgradePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.peotv,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const PeoTVPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.profile,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const ProfilePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.changeContact,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const ChangeContactPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.connections,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const ManageConnectionsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.addConnection,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const AddConnectionPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const SettingsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.language,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const LanguagePage(),
        ),
      ),

      // ─── More Sub-Routes ──────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.loyaltyPoints,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const LoyaltyPointsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.redeemData,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const RedeemDataPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.giftData,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const GiftDataPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.dataLoan,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const DataLoanPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.happyDay,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const HappyDayPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.reportFault,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const ReportFaultPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.iddServices,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const IDDServicesPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.locationServices,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const LocationServicesPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const NotificationsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.promotionDetail,
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: PromotionDetailPage(
            promotion: state.extra as PromotionModel?,
            promotionId: state.pathParameters['id'] ?? '',
          ),
        ),
      ),
    ],
  );
});

// ─── Page Transition Helpers ──────────────────────────────────────────────────

CustomTransitionPage<void> _fadePage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        child: child,
      );
    },
  );
}

CustomTransitionPage<void> _slidePage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        ),
        child: child,
      );
    },
  );
}
