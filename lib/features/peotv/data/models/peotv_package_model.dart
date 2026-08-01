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
}
