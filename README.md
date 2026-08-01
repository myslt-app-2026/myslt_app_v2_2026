# MySLT — Modern Frontend Rebuild Documentation

---

## 1. Rebuild Goals

| Goal | Detail |
|---|---|
| Modern UI | Material 3, dark/light mode, glassmorphism cards, micro-animations |
| Clean Architecture | Feature-first folder structure, separation of concerns |
| Scalable State | Riverpod (replacing Provider) |
| Type-Safe Navigation | go_router with named routes |
| Robust API Layer | Dio with interceptors, retry, logging |
| Full Localization | EN / SI / TA via easy_localization |
| Security | AES-GCM encrypted storage retained, biometric auth added |
| Testing | Unit + widget tests per feature |

---

## 2. Recommended Tech Stack

| Concern | Old | New |
|---|---|---|
| State Management | Provider | **Riverpod 2.x** (`flutter_riverpod`) |
| HTTP Client | `http` package | **Dio** with interceptors |
| Navigation | Imperative Navigator | **go_router** (named routes) |
| Local Storage | Custom AES file service | **flutter_secure_storage** + `hive` for cache |
| UI Tokens | Hardcoded hex values | **Material 3 ColorScheme** + custom theme |
| Charts | fl_chart | fl_chart (keep) |
| Localization | easy_localization | easy_localization (keep) |
| Fonts | Poppins (Google Fonts) | **Inter** + Poppins (keep) |
| Animations | None | **flutter_animate** |
| Image Loading | Image.network() | **cached_network_image** |
| Env Config | flutter_dotenv | flutter_dotenv (keep) |
| Auth | Firebase + Google + Facebook | Firebase + Google + Facebook (keep) |
| OTP | flutter_otp_text_field | **pinput** |
| Biometric | None | **local_auth** |
| Linting | flutter_lints | **very_good_analysis** |

---

## 3. Modern Architecture — Feature-First Clean Architecture

```
lib/
├── core/
│   ├── api/                   # Dio client, interceptors, error handler
│   ├── auth/                  # Token manager, auth state
│   ├── router/                # go_router configuration
│   ├── theme/                 # Material 3 theme, colors, typography
│   ├── storage/               # Secure storage service
│   ├── utils/                 # Currency formatter, validators, helpers
│   └── widgets/               # Globally reused widgets
│
├── features/
│   ├── splash/                # Splash screen
│   ├── auth/                  # Login, Register, Forgot Password
│   │   ├── data/              # AuthRepository, AuthRemoteDataSource
│   │   ├── domain/            # AuthUseCase, AuthEntity
│   │   └── presentation/      # SignInPage, RegisterPage, ForgotPassPage
│   ├── home/                  # Dashboard / home
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── account/               # Manage accounts/connections
│   ├── broadband/             # BB usage, packages, add-ons
│   ├── prepaid/               # Prepaid plans, recharge
│   ├── bill/                  # Billing, payment history
│   ├── profile/               # User profile management
│   ├── promotions/            # Offers and promotions
│   ├── peotv/                 # PEO TV features
│   ├── support/               # Complaints, contact us, FAQ
│   ├── more/                  # VAS, Digital Life, IDD, Data Loan
│   └── settings/              # Language, theme, notifications
│
├── l10n/                      # Translation files (en/si/ta)
└── main.dart
```

### Layer Responsibilities

| Layer | Responsibility |
|---|---|
| `data/` | API calls, local cache, DTOs, repository implementations |
| `domain/` | Entities, use-cases, repository interfaces (no Flutter imports) |
| `presentation/` | Pages, widgets, Riverpod notifiers/providers |

---

## 4. Design System

### 4.1 Color Palette (Material 3)

```dart
// Primary brand
primary:        Color(0xFF1A5EBF)   // SLT Blue
onPrimary:      Color(0xFFFFFFFF)
primaryContainer: Color(0xFFD6E4FF)

// Secondary
secondary:      Color(0xFF4FD745)   // SLT Green (pay/action)
onSecondary:    Color(0xFFFFFFFF)

// Surface (cards)
surface:        Color(0xFFF5F8FF)   // Light mode
surfaceDark:    Color(0xFF1A1F2E)   // Dark mode

// Error
error:          Color(0xFFE53935)

// Neutral
neutral100:     Color(0xFFFFFFFF)
neutral800:     Color(0xFF2C2C2C)
neutral400:     Color(0xFF9E9E9E)
```

### 4.2 Typography Scale

```dart
// Use Inter for UI, Poppins for headings
displayLarge:   Inter 32px  Bold
headlineMedium: Poppins 24px SemiBold
titleLarge:     Inter 20px  SemiBold
bodyLarge:      Inter 16px  Regular
bodyMedium:     Inter 14px  Regular
labelMedium:    Inter 12px  Medium
```

### 4.3 Spacing & Radius System

```dart
// Spacing (multiples of 4)
xs:  4.0,  sm: 8.0,  md: 16.0,  lg: 24.0,  xl: 32.0,  xxl: 48.0

// Border radius
radiusSm:   8.0
radiusMd:   12.0
radiusLg:   20.0
radiusXl:   32.0
radiusFull: 999.0   // pill buttons
```

### 4.4 Elevation & Shadow

```dart
shadowSm:  BoxShadow(color: Color(0x141A5EBF), blurRadius: 8, offset: Offset(0,2))
shadowMd:  BoxShadow(color: Color(0x201A5EBF), blurRadius: 16, offset: Offset(0,4))
shadowLg:  BoxShadow(color: Color(0x281A5EBF), blurRadius: 32, offset: Offset(0,8))
```

### 4.5 UI Component Patterns

- **Cards:** Glassmorphism with `BackdropFilter` blur + subtle border
- **Buttons:** Rounded pill (radiusFull), gradient fill for primary actions
- **Bottom Nav:** Floating pill-shaped nav bar with icon+label animation
- **App Bar:** Transparent with blur background on scroll
- **Loaders:** Shimmer skeleton placeholders (not spinners)
- **Inputs:** Filled style with floating label, error state highlight

---

## 5. Navigation — go_router

```dart
// Route names (constants)
class AppRoutes {
  static const splash    = '/';
  static const signIn    = '/sign-in';
  static const register  = '/register';
  static const forgotPwd = '/forgot-password';
  static const home      = '/home';
  static const account   = '/home/account';
  static const broadband = '/home/broadband';
  static const bill      = '/home/bill';
  static const payment   = '/home/payment';
  static const profile   = '/home/profile';
  static const promotions= '/home/promotions';
  static const peoTV     = '/home/peo-tv';
  static const support   = '/home/support';
  static const complaint = '/home/support/complaint';
  static const settings  = '/settings';
  static const language  = '/settings/language';
  static const prepaid   = '/home/prepaid';
  static const digitalLife = '/home/digital-life';
}
```

**Auth guard:** `GoRouter.redirect` checks `AuthStateNotifier` before routing.

---

## 6. State Management — Riverpod 2.x

### Provider Map

```dart
// Auth
authStateProvider          // AsyncNotifierProvider<AuthState>
tokenProvider              // Provider<String?> (from secure storage)

// Account
accountListProvider        // FutureProvider<List<Account>>
selectedAccountProvider    // StateProvider<int>  (current index)

// Home / Service Data
serviceDataProvider(telephoneNo) // FutureProvider.family<ServiceData, String>
bannerUrlsProvider         // FutureProvider<List<String>>

// Promotions
promotionProvider(tel)     // AsyncNotifierProvider.family

// Profile
userProfileProvider        // AsyncNotifierProvider<UserProfile>

// Navigation
bottomNavIndexProvider     // StateProvider<int>

// Theme
themeProvider              // StateProvider<ThemeMode>
```

### Key Advantage over Provider

- No `BuildContext` needed to read state
- `ref.invalidate()` for explicit refresh
- Family providers for per-account data isolation
- `AsyncValue` pattern eliminates manual loading/error state booleans

---

## 7. API Layer — Dio

### Dio Client Setup

```dart
class ApiClient {
  late final Dio _dio;

  ApiClient(String baseUrl, SecureStorageService storage) {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
    _dio.interceptors.addAll([
      AuthInterceptor(storage),     // injects Bearer token
      RetryInterceptor(_dio),       // retries on 401 with refresh
      LoggingInterceptor(),         // prints in debug mode
      ErrorInterceptor(),           // maps errors to AppException
    ]);
  }
}
```

### AuthInterceptor

```
onRequest:
  1. Read accessToken from SecureStorageService
  2. Add 'Authorization: Bearer $token' header

onError (401):
  1. POST /Account/RefreshToken
  2. Save new tokens
  3. Retry original request once
  4. On refresh failure → emit AuthState.unauthenticated
```

### API Response Contract

```dart
class ApiResponse<T> {
  final bool isSuccess;
  final T? dataBundle;
  final String? errorShow;
  final String? errorMessage;
}
```

---

## 8. Feature Screen Mapping (Old → New)

| Old Screen | New Screen | Changes |
|---|---|---|
| `SignIn` | `SignInPage` | Modern card UI, biometric login option, social login redesign |
| `Register` | `RegisterPage` | Multi-step form with progress indicator |
| `AppMainPage` | `AppShell` | Floating pill bottom nav, blur app bar, smooth transitions |
| `HomePage` | `DashboardPage` | Animated usage rings, glassmorphism cards, shimmer loading |
| `ProfilePage` | `ProfilePage` | Avatar upload, editable inline fields |
| `BillPage` | `BillPage` | Timeline bill history, status chips |
| `BillPayment` | `PaymentPage` | Redesigned payment WebView wrapper |
| `MainMenu` (Drawer) | `SideDrawer` | Gradient header, avatar, account type badge |
| `PromotionPage` | `OffersPage` | Card carousel, countdown timers |
| `Support_Page` | `SupportPage` | Searchable FAQ, quick-action tiles |
| `ComplaintPage` | `ComplaintPage` | Form stepper, photo attachment |
| `ManageConnection` | `AccountsPage` | Account cards with status indicators |
| `Digital_Life` | `DigitalLifePage` | Grid of services with icons |
| `PackageUpgrade` | `UpgradePage` | Plan comparison cards |
| `PrepaidBroadband` | `PrepaidDashboard` | Usage donuts, quick-recharge button |
| `PeoTVPages` | `PeoTVPage` | Channel grid, VOD card carousel |
| `LanguagePage` | `LanguagePage` | Flag icons, live preview |
| `SplashScreen` | `SplashPage` | Animated SLT logo, lottie animation |
| `AddConnection` | `AddAccountPage` | Guided flow with validation |

---

## 9. Key UI Components to Build

### 9.1 `UsageRingCard`
Animated circular progress ring showing data used vs total. Used on broadband and prepaid dashboards.

### 9.2 `GlassCard`
```dart
BackdropFilter(
  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.3)),
    ),
  ),
)
```

### 9.3 `AppShell` (replaces AppMainPage)
- `StatefulShellRoute` from go_router for nested navigation
- Floating `NavigationBar` with Material 3 pill indicator
- Per-tab scroll restoration

### 9.4 `ShimmerLoader`
Skeleton cards shown during data fetch instead of `CircularProgressIndicator`.

### 9.5 `AccountSwitcher`
Horizontal scrollable account pill selector in the app bar. Tapping opens `AccountsBottomSheet`.

### 9.6 `AnimatedTabBar`
For broadband/PEO/Voice tab switching — slide animation with custom indicator.

---

## 10. Authentication Rebuild

### Flow (unchanged contract, new implementation)

```
SplashPage
  └── authStateProvider (AsyncNotifier)
        ├── reads SecureStorage for token + timestamp
        ├── age < 15d  → router.go('/home')
        ├── age 15-60d → silent refresh → router.go('/home') or '/sign-in'
        └── no token   → router.go('/sign-in')

SignInPage
  ├── Username + Password form  → POST /Account/Login
  ├── Google Sign-In button     → Firebase → POST /Account/LoginExternal
  ├── Facebook Sign-In button   → Facebook SDK → POST /Account/LoginExternal
  └── Biometric (if enrolled)   → local_auth → reads saved credentials
```

### Token Storage (unchanged mechanism, new interface)

```dart
abstract class ISecureStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
}
// Implementation: AES-256-GCM file storage (same as current)
```

---

## 11. Responsive & Adaptive Design

| Breakpoint | Layout |
|---|---|
| < 360px | Compact: smaller fonts, reduced padding |
| 360–480px | Default mobile layout |
| 480–600px | Comfortable: larger tap targets |
| > 600px (tablet) | Two-column dashboard |

Use `LayoutBuilder` or `AdaptiveLayout` from `adaptive_breakpoints`.

All dimensions expressed as fractions of `MediaQuery.size` — same pattern as current app, but extracted to a `ScreenSize` helper class.

---

## 12. Data Caching Strategy

| Data | Cache | TTL |
|---|---|---|
| Account list | Hive Box | 5 minutes |
| Service data (BB/PEO/Voice) | Hive Box | 2 minutes |
| Banner URLs | Hive Box | 30 minutes |
| Promotions | Riverpod state | Session |
| Bill data | No cache (always fresh) | — |
| Profile | Riverpod state | Session |
| Translation files | Asset bundle | Build |

---

## 13. Error Handling Strategy

```dart
sealed class AppException {
  NetworkException      // No internet / timeout
  UnauthorizedException // 401 after refresh failed
  ApiException          // 4xx/5xx from server
  ParseException        // JSON decode failure
  StorageException      // Secure storage read/write failure
}

// In UI — use AsyncValue pattern:
ref.watch(serviceDataProvider(tel)).when(
  data: (data) => DashboardContent(data),
  loading: () => ShimmerLoader(),
  error: (e, _) => ErrorCard(exception: e, onRetry: () => ref.invalidate(...)),
)
```

---

## 14. Implementation Phases

### Phase 1 — Foundation (Week 1)
- [ ] New Flutter project setup with all dependencies
- [ ] `core/theme/` — Material 3 ColorScheme, typography, spacing tokens
- [ ] `core/api/` — Dio client + interceptors
- [ ] `core/storage/` — SecureStorageService (port from current)
- [ ] `core/router/` — go_router config with auth redirect
- [ ] `core/widgets/` — GlassCard, ShimmerLoader, PrimaryButton, AppTextField

### Phase 2 — Auth Module (Week 1–2)
- [ ] `SplashPage` with animated logo
- [ ] `SignInPage` — username/password + social login
- [ ] `RegisterPage` — multi-step form
- [ ] `ForgotPasswordPage` — OTP flow (pinput)
- [ ] Auth Riverpod notifier + token management

### Phase 3 — Home & Account Shell (Week 2)
- [ ] `AppShell` — floating bottom nav (5 tabs)
- [ ] `AccountSwitcher` widget
- [ ] `AccountService` data layer
- [ ] `SideDrawer` with localized menu items
- [ ] `DashboardPage` — shimmer → animated cards

### Phase 4 — Broadband & Prepaid (Week 2–3)
- [ ] `UsageRingCard` component
- [ ] Postpaid broadband tab (data/PEO/voice)
- [ ] Prepaid dashboard
- [ ] Package listing + activation flow
- [ ] Data add-on + Extra GB flows
- [ ] Package upgrade flow

### Phase 5 — Billing & Payments (Week 3)
- [ ] Bill page with timeline history
- [ ] Payment WebView wrapper
- [ ] Transaction history page
- [ ] Prepaid transaction page

### Phase 6 — Profile & Settings (Week 3–4)
- [ ] Profile page with edit flow
- [ ] Change contact info
- [ ] Call forwarding page
- [ ] Language settings page
- [ ] Theme toggle (light/dark)

### Phase 7 — Support & More (Week 4)
- [ ] Support page (FAQ, contact)
- [ ] Complaint page (stepper form)
- [ ] Digital Life services
- [ ] VAS bottom sheet
- [ ] PEO TV features
- [ ] Promotions/Offers page

### Phase 8 — Polish & QA (Week 4–5)
- [ ] Animations with `flutter_animate`
- [ ] Dark mode testing
- [ ] Tablet layout testing
- [ ] Localization (SI/TA) review
- [ ] Unit tests for all use-cases
- [ ] Widget tests for key screens
- [ ] Performance profiling

---

## 15. pubspec.yaml (New)

```yaml
name: myslt
description: MySLT — SLT-Mobitel Self-Care App
version: 1.0.0+1
environment:
  sdk: '>=3.3.4 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # State
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Navigation
  go_router: ^14.0.1

  # HTTP
  dio: ^5.4.3
  pretty_dio_logger: ^1.4.0

  # Storage
  flutter_secure_storage: ^9.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.1.5

  # Auth
  firebase_auth: ^5.0.3
  firebase_core: ^3.8.0
  google_sign_in: ^6.2.2
  flutter_facebook_auth: ^7.1.1
  local_auth: ^2.3.0

  # UI
  flutter_animate: ^4.5.0
  cached_network_image: ^3.3.1
  carousel_slider: ^5.0.0
  fl_chart: ^0.69.0
  shimmer: ^3.0.0
  pinput: ^3.1.1
  google_fonts: ^6.2.0
  modal_bottom_sheet: ^3.0.0
  badges: ^3.1.2

  # Localization
  easy_localization: ^3.0.8

  # Utilities
  flutter_dotenv: ^5.2.1
  intl: ^0.20.2
  encrypt: ^5.0.3
  permission_handler: ^11.3.1
  webview_flutter: ^4.10.0
  flutter_pdfview: ^1.3.4
  marquee: ^2.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  very_good_analysis: ^6.0.0
  build_runner: ^2.4.11
  riverpod_generator: ^2.4.0
  hive_generator: ^2.0.1
  flutter_launcher_icons: ^0.14.1
  mocktail: ^1.0.3
```

---

## 16. Folder Naming Conventions

| Rule | Example |
|---|---|
| Feature folders: `snake_case` | `broadband/`, `bill_payment/` |
| Files: `snake_case.dart` | `sign_in_page.dart` |
| Classes: `PascalCase` | `SignInPage`, `AuthNotifier` |
| Providers: `camelCaseProvider` | `authStateProvider` |
| Constants: `kCamelCase` | `kPrimaryColor` |
| Private: `_prefix` | `_buildUsageCard()` |

---

## 17. Security Checklist for Rebuild

- [ ] No plain-text credentials in memory longer than needed
- [ ] Remove saving raw `password` to storage (current bug)
- [ ] Move `X-IBM-Client-Id` to `.env` (not hardcoded)
- [ ] Add certificate pinning for production API
- [ ] Add biometric authentication before sensitive actions (bill pay, package upgrade)
- [ ] Use `flutter_secure_storage` platform-native keystore for encryption key
- [ ] Disable screenshot capture on sensitive screens
- [ ] Add jailbreak/root detection (`flutter_jailbreak_detection`)
- [ ] Obfuscate release builds: `flutter build apk --obfuscate --split-debug-info=...`

---

## 18. Testing Strategy

```
test/
├── unit/
│   ├── auth/
│   │   ├── sign_in_use_case_test.dart
│   │   └── token_manager_test.dart
│   ├── broadband/
│   │   └── service_data_test.dart
│   └── billing/
│       └── bill_service_test.dart
│
├── widget/
│   ├── sign_in_page_test.dart
│   ├── usage_ring_card_test.dart
│   └── app_shell_test.dart
│
└── integration/
    └── auth_flow_test.dart
```

**Coverage target:** 70%+ for domain and data layers.

---

*Rebuild Documentation v1.0 — MySLT Flutter App — 2026-07-10*
