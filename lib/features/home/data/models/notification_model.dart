import 'package:flutter/material.dart';

enum NotificationType { bill, usage, promo, system, reward }

extension NotificationTypeExtension on NotificationType {
  String get label {
    switch (this) {
      case NotificationType.bill:
        return 'Bill';
      case NotificationType.usage:
        return 'Usage';
      case NotificationType.promo:
        return 'Promotion';
      case NotificationType.system:
        return 'System';
      case NotificationType.reward:
        return 'Reward';
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.bill:
        return const Color(0xFFD97706);
      case NotificationType.usage:
        return const Color(0xFF0066CC);
      case NotificationType.promo:
        return const Color(0xFF7C3AED);
      case NotificationType.system:
        return const Color(0xFF6B7280);
      case NotificationType.reward:
        return const Color(0xFF059669);
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.bill:
        return Icons.receipt_long_rounded;
      case NotificationType.usage:
        return Icons.data_usage_rounded;
      case NotificationType.promo:
        return Icons.local_offer_rounded;
      case NotificationType.system:
        return Icons.info_outline_rounded;
      case NotificationType.reward:
        return Icons.card_giftcard_rounded;
    }
  }
}

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      timestamp: timestamp,
      type: type,
      isRead: isRead ?? this.isRead,
    );
  }
}
