import 'package:flutter/material.dart';

enum PackageType { prepaidData, prepaidVoice, prepaidCombo, postpaidFiber, addon }

class PackageModel {
  const PackageModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    this.dataMB = 0,
    this.bonusDataMB = 0,
    this.freeMinutes = 0,
    this.validityDays = 30,
    this.isActive = false,
    this.tag,
    this.tagColor,
    this.speed,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final PackageType type;
  final double dataMB;
  final double bonusDataMB;
  final int freeMinutes;
  final int validityDays;
  final bool isActive;
  final String? tag;
  final int? tagColor;
  final String? speed;

  Color? get tagColorValue => tagColor != null ? Color(tagColor!) : null;

  bool get isUnlimited => dataMB < 0;

  String get dataLabel {
    if (isUnlimited) return 'Unlimited';
    if (dataMB >= 1024) {
      return '${(dataMB / 1024).toStringAsFixed(0)} GB';
    }
    return '${dataMB.toStringAsFixed(0)} MB';
  }

  String get priceLabel => 'Rs. ${price.toStringAsFixed(2)}';
}
