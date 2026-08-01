import 'package:flutter/material.dart';

class PromotionModel {
  const PromotionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.ctaLabel,
    required this.ctaUrl,
    required this.expiryDate,
    this.badgeLabel,
    this.badgeColor,
  });

  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String ctaLabel;
  final String ctaUrl;
  final DateTime expiryDate;
  final String? badgeLabel;
  final int? badgeColor;

  Color? get badgeColorValue =>
      badgeColor != null ? Color(badgeColor!) : null;
}
