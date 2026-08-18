import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/data/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

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
final authStateProvider = Provider<AuthStateModel>((ref) {
  final authNotifier = ref.watch(authNotifierProvider);
  return AuthStateModel(
    isLoggedIn: authNotifier.user != null,
    isLoading: authNotifier.isLoading,
  );
});

/// Holds the mutable auth state.
class AuthState {
  const AuthState({
    this.user,
    this.registrationId,
    this.isLoading = false,
    this.error,
  });

  final String? user;
  final String? registrationId;
  final bool isLoading;
  final String? error;

  AuthState copyWith({
    String? user,
    String? registrationId,
    bool? isLoading,
    String? error,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      registrationId: registrationId ?? this.registrationId,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Auth notifier — manages login, logout, registration, and OTP verification with real backend endpoints.
class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _authRepository;

  @override
  AuthState build() {
    _authRepository = ref.watch(authRepositoryProvider);
    _checkInitialSession();
    return const AuthState();
  }

  Future<void> _checkInitialSession() async {
    final hasSession = await _authRepository.checkSession();
    if (hasSession) {
      state = state.copyWith(user: 'Logged User');
    }
  }

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _authRepository.login(
      username: username,
      password: password,
    );

    if (result.isSuccess) {
      state = AuthState(
        user: result.name ?? username,
        isLoading: false,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.message ?? 'Invalid username or password',
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

    final result = await _authRepository.register(
      name: name,
      mobile: mobile,
      email: email,
      password: password,
      nic: nic,
      accountNumber: accountNumber,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        isLoading: false,
        registrationId: result.registrationId,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.message ?? 'Registration failed',
      );
      return false;
    }
  }

  Future<bool> verifyOtp(String otp, {String? registrationId}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final regId = registrationId ?? state.registrationId;

    if (regId == null || regId.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Missing registration session ID. Please try registering again.',
      );
      return false;
    }

    final result = await _authRepository.verifyOtp(
      registrationId: regId,
      otp: otp,
    );

    if (result.isSuccess) {
      state = AuthState(
        user: 'Logged User',
        isLoading: false,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.message ?? 'Invalid OTP',
      );
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _authRepository.logout();
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

