/// Represents broadband usage data conforming to TMF635 Usage Management standard.
class BroadbandUsageModel {
  const BroadbandUsageModel({
    required this.id,
    required this.subscriberId,
    required this.volume,
    this.unit = 'MB',
    this.category = 'Broadband',
    this.channel = 'MYSLT_APP',
    this.status = 'active',
    this.usageDate,
    this.description,
    this.remainingAmount,
    this.maxAmount,
  });

  final String id;
  final String subscriberId;
  final double volume;
  final String unit;
  final String category;
  final String channel;
  final String status;
  final DateTime? usageDate;
  final String? description;
  final double? remainingAmount;
  final double? maxAmount;

  factory BroadbandUsageModel.fromJson(Map<String, dynamic> json) {
    // Check for volume in characteristic array or top-level field
    double parsedVolume = 0.0;
    if (json['volume'] is num) {
      parsedVolume = (json['volume'] as num).toDouble();
    } else if (json['usageCharacteristic'] is List) {
      for (final char in json['usageCharacteristic']) {
        if (char is Map && char['name'] == 'volume' && char['value'] is num) {
          parsedVolume = (char['value'] as num).toDouble();
          break;
        }
      }
    }

    DateTime? parsedDate;
    if (json['usageDate'] != null) {
      parsedDate = DateTime.tryParse(json['usageDate'].toString());
    }

    return BroadbandUsageModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      subscriberId: json['subscriberID']?.toString() ?? json['subscriberId']?.toString() ?? '',
      volume: parsedVolume,
      unit: json['unit']?.toString() ?? 'MB',
      category: json['category']?.toString() ?? json['usageType']?.toString() ?? 'Broadband',
      channel: json['channel']?.toString() ?? 'MYSLT_APP',
      status: json['status']?.toString() ?? 'active',
      usageDate: parsedDate,
      description: json['description']?.toString(),
      remainingAmount: (json['remainingAmount'] as num?)?.toDouble(),
      maxAmount: (json['maxAmount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subscriberID': subscriberId,
        'volume': volume,
        'unit': unit,
        'category': category,
        'channel': channel,
        'status': status,
        if (usageDate != null) 'usageDate': usageDate!.toIso8601String(),
        if (description != null) 'description': description,
        if (remainingAmount != null) 'remainingAmount': remainingAmount,
        if (maxAmount != null) 'maxAmount': maxAmount,
      };
}
