import 'package:flutter/material.dart';

enum LoyaltyTier { bronze, silver, gold, platinum }

extension LoyaltyTierExtension on LoyaltyTier {
  String get label {
    switch (this) {
      case LoyaltyTier.bronze:
        return 'Bronze';
      case LoyaltyTier.silver:
        return 'Silver';
      case LoyaltyTier.gold:
        return 'Gold';
      case LoyaltyTier.platinum:
        return 'Platinum';
    }
  }

  Color get color {
    switch (this) {
      case LoyaltyTier.bronze:
        return const Color(0xFFCD7F32);
      case LoyaltyTier.silver:
        return const Color(0xFFC0C0C0);
      case LoyaltyTier.gold:
        return const Color(0xFFFFD700);
      case LoyaltyTier.platinum:
        return const Color(0xFF7C3AED);
    }
  }

  IconData get icon {
    switch (this) {
      case LoyaltyTier.bronze:
        return Icons.stars_rounded;
      case LoyaltyTier.silver:
        return Icons.workspace_premium_rounded;
      case LoyaltyTier.gold:
        return Icons.emoji_events_rounded;
      case LoyaltyTier.platinum:
        return Icons.diamond_rounded;
    }
  }
}

class LoyaltyPointsModel {
  const LoyaltyPointsModel({
    required this.totalPoints,
    required this.redeemablePoints,
    required this.tier,
    required this.history,
    required this.nextTierPoints,
  });

  final int totalPoints;
  final int redeemablePoints;
  final LoyaltyTier tier;
  final List<LoyaltyHistoryEntry> history;
  final int nextTierPoints;

  double get tierProgress =>
      nextTierPoints > 0 ? (totalPoints / nextTierPoints).clamp(0.0, 1.0) : 1.0;
}

class LoyaltyHistoryEntry {
  const LoyaltyHistoryEntry({
    required this.id,
    required this.description,
    required this.points,
    required this.date,
    required this.isEarned,
  });

  final String id;
  final String description;
  final int points;
  final DateTime date;
  final bool isEarned; // true = earned, false = redeemed
}

class RedeemablePackage {
  const RedeemablePackage({
    required this.id,
    required this.name,
    required this.description,
    required this.pointsCost,
    required this.dataMB,
    this.validityDays = 7,
  });

  final String id;
  final String name;
  final String description;
  final int pointsCost;
  final double dataMB;
  final int validityDays;

  String get dataLabel {
    if (dataMB >= 1024) {
      return '${(dataMB / 1024).toStringAsFixed(0)} GB';
    }
    return '${dataMB.toStringAsFixed(0)} MB';
  }
}
