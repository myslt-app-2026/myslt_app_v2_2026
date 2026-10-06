import 'package:flutter/material.dart';

class PeoTVPackageModel {
  const PeoTVPackageModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.channelCount,
    required this.isActive,
    required this.imageUrl,
    required this.channels,
    this.tag,
    this.tagColor,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final int channelCount;
  final bool isActive;
  final String imageUrl;
  final List<String> channels;
  final String? tag;
  final int? tagColor;

  Color? get tagColorValue => tagColor != null ? Color(tagColor!) : null;
  String get priceLabel => 'Rs. ${price.toStringAsFixed(2)}/mo';

  PeoTVPackageModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? channelCount,
    bool? isActive,
    String? imageUrl,
    List<String>? channels,
    String? tag,
    int? tagColor,
  }) {
    return PeoTVPackageModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      channelCount: channelCount ?? this.channelCount,
      isActive: isActive ?? this.isActive,
      imageUrl: imageUrl ?? this.imageUrl,
      channels: channels ?? this.channels,
      tag: tag ?? this.tag,
      tagColor: tagColor ?? this.tagColor,
    );
  }

  factory PeoTVPackageModel.fromJson(Map<String, dynamic> json) {
    final rawChannels = json['channels'] ?? json['productOffering']?['channels'];
    List<String> parsedChannels = [];
    if (rawChannels is List) {
      parsedChannels = rawChannels.map((e) => e.toString()).toList();
    } else {
      parsedChannels = ['Sirasa TV', 'Rupavahini', 'ITN', 'Swarnavahini'];
    }

    final priceVal = (json['price'] is num)
        ? (json['price'] as num).toDouble()
        : (json['productPrice'] is num)
            ? (json['productPrice'] as num).toDouble()
            : 350.0;

    return PeoTVPackageModel(
      id: json['id']?.toString() ?? json['productSerialNumber']?.toString() ?? 'PEO-01',
      name: json['name']?.toString() ?? json['productOfferingName']?.toString() ?? 'Basic Pack',
      description: json['description']?.toString() ?? 'Subscribed PEO TV Package',
      price: priceVal,
      channelCount: (json['channelCount'] is num) ? (json['channelCount'] as num).toInt() : 52,
      isActive: json['status']?.toString().toLowerCase() == 'active' || json['isActive'] == true || json['isSubscribed'] == true,
      imageUrl: json['imageUrl']?.toString() ?? 'https://picsum.photos/800/400?random=1',
      channels: parsedChannels,
      tag: json['tag']?.toString() ?? (json['status']?.toString().toUpperCase() == 'ACTIVE' ? 'Active' : null),
      tagColor: json['tagColor'] is int ? json['tagColor'] as int : 0xFF4CAF50,
    );
  }
}

