import 'package:flutter/material.dart';

/// Utility extension methods on common types.

// ─── DateTime Extensions ──────────────────────────────────────────────────────

extension DateTimeExtensions on DateTime {
  /// Format as "DD MMM YYYY" e.g. "12 Jul 2026"
  String get formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '$day ${months[month - 1]} $year';
  }

  /// Number of days remaining from now
  int get daysFromNow => difference(DateTime.now()).inDays;

  /// "X days left" or "Overdue" label
  String get daysLeftLabel {
    final days = daysFromNow;
    if (days < 0) return 'Overdue';
    if (days == 0) return 'Due today';
    if (days == 1) return '1 day left';
    return '$days days left';
  }
}

// ─── double / int Extensions ──────────────────────────────────────────────────

extension DataSizeExtensions on double {
  /// Convert MB to a human-readable string: "1.5 GB" or "512 MB"
  String get dataLabel {
    if (this >= 1024) {
      return '${(this / 1024).toStringAsFixed(1)} GB';
    }
    return '${toStringAsFixed(0)} MB';
  }

  /// Format as Sri Lankan Rupees: "Rs. 4,850.00"
  String get rupeesLabel {
    final formatted = toStringAsFixed(2);
    final parts = formatted.split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    final buffer = StringBuffer();
    int count = 0;
    for (int i = intPart.length - 1; i >= 0; i--) {
      buffer.write(intPart[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write(',');
        count = 0;
      }
    }
    return 'Rs. ${buffer.toString().split('').reversed.join()}.$decPart';
  }
}

extension DataSizeIntExtensions on int {
  String get dataLabel => toDouble().dataLabel;
}

// ─── String Extensions ────────────────────────────────────────────────────────

extension StringExtensions on String {
  /// Capitalize first letter of each word
  String get titleCase {
    return split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  /// Mask middle of phone number: "077****567"
  String get maskedMobile {
    if (length < 7) return this;
    return '${substring(0, 3)}****${substring(length - 3)}';
  }
}

// ─── BuildContext Extensions ──────────────────────────────────────────────────

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? colors.error : const Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
