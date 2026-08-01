import 'package:intl/intl.dart';

/// Utility formatters used across the mySLT app.
abstract final class AppFormatters {
  // ─── Currency ─────────────────────────────────────────────────────────────
  static String formatLKR(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_LK',
      symbol: 'Rs. ',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String formatLKRCompact(double amount) {
    if (amount >= 1000) {
      return 'Rs. ${(amount / 1000).toStringAsFixed(1)}K';
    }
    return 'Rs. ${amount.toStringAsFixed(2)}';
  }

  // ─── Data Size ────────────────────────────────────────────────────────────
  static String formatDataSize(double mb) {
    if (mb >= 1024) {
      return '${(mb / 1024).toStringAsFixed(2)} GB';
    }
    return '${mb.toStringAsFixed(0)} MB';
  }

  static String formatDataSizeCompact(double mb) {
    if (mb >= 1024) {
      final gb = mb / 1024;
      return gb >= 10
          ? '${gb.toStringAsFixed(0)} GB'
          : '${gb.toStringAsFixed(1)} GB';
    }
    return '${mb.toStringAsFixed(0)} MB';
  }

  // ─── Date & Time ──────────────────────────────────────────────────────────
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatDateShort(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  static String formatMonth(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  static String formatMonthShort(DateTime date) {
    return DateFormat('MMM yyyy').format(date);
  }

  static String formatDaysRemaining(DateTime expiryDate) {
    final now = DateTime.now();
    final diff = expiryDate.difference(now).inDays;
    if (diff <= 0) return 'Expired';
    if (diff == 1) return '1 day left';
    return '$diff days left';
  }

  static String formatDueDateCountdown(DateTime dueDate) {
    final now = DateTime.now();
    final diff = dueDate.difference(now).inDays;
    if (diff < 0) return 'Overdue by ${-diff} days';
    if (diff == 0) return 'Due today';
    if (diff == 1) return 'Due tomorrow';
    return 'Due in $diff days';
  }

  // ─── Phone Number ─────────────────────────────────────────────────────────
  static String maskPhoneNumber(String phone) {
    if (phone.length < 6) return phone;
    final prefix = phone.substring(0, 3);
    final suffix = phone.substring(phone.length - 3);
    final masked = '*' * (phone.length - 6);
    return '$prefix$masked$suffix';
  }

  // ─── Percentage ───────────────────────────────────────────────────────────
  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  // ─── Account Number ───────────────────────────────────────────────────────
  static String maskAccountNumber(String account) {
    if (account.length < 6) return account;
    return '****${account.substring(account.length - 4)}';
  }

  // ─── Greeting ─────────────────────────────────────────────────────────────
  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
