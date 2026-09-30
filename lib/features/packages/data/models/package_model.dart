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

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    double parsedPrice = 0.0;
    if (json['price'] != null) {
      if (json['price'] is num) {
        parsedPrice = (json['price'] as num).toDouble();
      } else if (json['price'] is Map) {
        final p = json['price'];
        parsedPrice = (p['amount'] ?? p['value'] ?? 0.0).toDouble();
      }
    } else if (json['productOfferingPrice'] is List && (json['productOfferingPrice'] as List).isNotEmpty) {
      final pop = (json['productOfferingPrice'] as List).first;
      if (pop is Map && pop['price'] != null) {
        final p = pop['price'];
        if (p['taxIncludedAmount'] is Map) {
          parsedPrice = (p['taxIncludedAmount']['value'] ?? 0.0).toDouble();
        } else if (p['taxIncludedAmount'] is num) {
          parsedPrice = (p['taxIncludedAmount'] as num).toDouble();
        } else if (p['amount'] is num) {
          parsedPrice = (p['amount'] as num).toDouble();
        }
      }
    }

    double volumeMB = 0.0;
    if (json['volume'] != null) {
      final volStr = json['volume'].toString().toLowerCase();
      final numVal = double.tryParse(volStr.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      if (volStr.contains('gb')) {
        volumeMB = numVal * 1024;
      } else {
        volumeMB = numVal;
      }
    } else if (json['dataMB'] != null) {
      volumeMB = (json['dataMB'] as num).toDouble();
    }

    return PackageModel(
      id: json['id']?.toString() ?? json['packageId']?.toString() ?? '',
      name: json['name']?.toString() ?? json['bundleName']?.toString() ?? 'VAS Package',
      description: json['description']?.toString() ?? '',
      price: parsedPrice > 0 ? parsedPrice : 299.0,
      type: PackageType.addon,
      dataMB: volumeMB > 0 ? volumeMB : 1024.0,
      validityDays: json['validityDays'] is int ? json['validityDays'] : 30,
      isActive: json['isActive'] == true,
      tag: json['tag']?.toString(),
    );
  }
}
