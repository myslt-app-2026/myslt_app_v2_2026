import 'package:flutter/material.dart';

enum FaultCategory { noInternet, slowSpeed, lineIssue, routerIssue, billing, other }

extension FaultCategoryExtension on FaultCategory {
  String get label {
    switch (this) {
      case FaultCategory.noInternet:
        return 'No Internet';
      case FaultCategory.slowSpeed:
        return 'Slow Speed';
      case FaultCategory.lineIssue:
        return 'Line Issue';
      case FaultCategory.routerIssue:
        return 'Router Issue';
      case FaultCategory.billing:
        return 'Billing Issue';
      case FaultCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case FaultCategory.noInternet:
        return Icons.wifi_off_rounded;
      case FaultCategory.slowSpeed:
        return Icons.speed_rounded;
      case FaultCategory.lineIssue:
        return Icons.cable_rounded;
      case FaultCategory.routerIssue:
        return Icons.router_rounded;
      case FaultCategory.billing:
        return Icons.receipt_long_rounded;
      case FaultCategory.other:
        return Icons.help_outline_rounded;
    }
  }

  Color get color {
    switch (this) {
      case FaultCategory.noInternet:
        return const Color(0xFFDC2626);
      case FaultCategory.slowSpeed:
        return const Color(0xFFF59E0B);
      case FaultCategory.lineIssue:
        return const Color(0xFF6B7280);
      case FaultCategory.routerIssue:
        return const Color(0xFF0066CC);
      case FaultCategory.billing:
        return const Color(0xFF7C3AED);
      case FaultCategory.other:
        return const Color(0xFF9CA3AF);
    }
  }
}
