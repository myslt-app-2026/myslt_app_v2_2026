import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents the authentication state used by the router guard.
class AuthStateModel {
  const AuthStateModel({
    required this.isLoggedIn,
    required this.isLoading,
  });

  final bool isLoggedIn;
  final bool isLoading;
}

/// Provider that exposes the current auth state to GoRouter.
/// In the demo, this is driven by [authNotifierProvider].
final authStateProvider = Provider<AuthStateModel>((ref) {
  final authNotifier = ref.watch(authNotifierProvider);
  return AuthStateModel(
    isLoggedIn: authNotifier.user != null,
    isLoading: authNotifier.isLoading,
  );
});

/// Holds the mutable auth state (user + loading flag).
class AuthState {
  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  final String? user; // Demo: just store username string
  final bool isLoading;
  final String? error;

  AuthState copyWith({
    String? user,
    bool? isLoading,
    String? error,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Auth notifier — manages login, logout, and registration state.
/// Demo: simulates a 1.5-second network delay then succeeds.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Demo: accept any non-empty credentials
    if (username.isNotEmpty && password.isNotEmpty) {
      state = AuthState(user: username);
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Invalid username or password',
      );
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String nic,
    required String mobile,
    required String email,
    required String accountNumber,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(milliseconds: 1500));
    state = AuthState(user: email);
    return true;
  }

  Future<bool> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(milliseconds: 1000));
    // Demo: OTP 123456 is always valid
    if (otp == '123456') {
      state = state.copyWith(isLoading: false, clearError: true);
      return true;
    }
    state = state.copyWith(isLoading: false, error: 'Invalid OTP');
    return false;
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
