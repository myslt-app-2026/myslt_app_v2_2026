/// Input validation utilities for the mySLT app.
abstract final class AppValidators {
  // ─── Required ─────────────────────────────────────────────────────────────
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  // ─── Email ────────────────────────────────────────────────────────────────
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!regex.hasMatch(value.trim())) return 'Enter a valid email address';
    return null;
  }

  // ─── Mobile (Sri Lanka) ───────────────────────────────────────────────────
  static String? mobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-]'), '');
    final regex = RegExp(r'^(?:\+94|0)?[17]\d{8}$');
    if (!regex.hasMatch(cleaned)) {
      return 'Enter a valid Sri Lankan mobile number';
    }
    return null;
  }

  // ─── NIC (Sri Lanka) ──────────────────────────────────────────────────────
  static String? nic(String? value) {
    if (value == null || value.trim().isEmpty) return 'NIC number is required';
    final regex = RegExp(r'^(\d{9}[VvXx]|\d{12})$');
    if (!regex.hasMatch(value.trim())) {
      return 'Enter a valid NIC (9 digits + V/X, or 12 digits)';
    }
    return null;
  }

  // ─── Password ─────────────────────────────────────────────────────────────
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Include at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Include at least one number';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  // ─── Account Number ───────────────────────────────────────────────────────
  static String? accountNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Account number is required';
    }
    if (value.trim().length < 6) {
      return 'Enter a valid account number';
    }
    return null;
  }

  // ─── Full Name ────────────────────────────────────────────────────────────
  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Full name is required';
    if (value.trim().length < 3) return 'Name must be at least 3 characters';
    return null;
  }

  // ─── OTP ──────────────────────────────────────────────────────────────────
  static String? otp(String? value) {
    if (value == null || value.isEmpty) return 'OTP is required';
    if (value.length != 6) return 'Enter the 6-digit OTP';
    if (!RegExp(r'^\d{6}$').hasMatch(value)) return 'OTP must contain only digits';
    return null;
  }

  // ─── Compose validators ───────────────────────────────────────────────────
  /// Runs multiple validators and returns the first error found.
  static String? compose(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) return result;
    }
    return null;
  }
}
