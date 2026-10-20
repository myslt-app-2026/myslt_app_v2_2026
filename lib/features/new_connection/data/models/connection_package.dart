import 'package:intl/intl.dart';

/// Formats a whole-rupee amount, e.g. 5490 -> "Rs. 5,490".
String formatRs(int amount) => 'Rs. ${NumberFormat('#,##0').format(amount)}';

class ConnectionPackage {
  const ConnectionPackage({
    required this.id,
    required this.name,
    required this.type,
    required this.speedLabel,
    required this.monthlyRental,
    this.features = const [],
    this.recommended = false,
  });

  final String id;
  final String name; // e.g. Fibre Unlimited
  final String type; // e.g. Fibre, Fibre Triple Play
  final String speedLabel; // e.g. 100 Mbps
  final int monthlyRental;
  final List<String> features;
  final bool recommended;

  // Ready for the real API later. Adjust keys to match the backend response.
  factory ConnectionPackage.fromJson(Map<String, dynamic> json) =>
      ConnectionPackage(
        id: json['id'].toString(),
        name: json['name'] as String,
        type: json['type'] as String,
        speedLabel: json['speedLabel'] as String,
        monthlyRental: (json['monthlyRental'] as num).toInt(),
        features: List<String>.from(json['features'] ?? const []),
        recommended: json['recommended'] as bool? ?? false,
      );
}

class AddOn {
  const AddOn({
    required this.id,
    required this.name,
    required this.description,
    required this.monthlyPrice,
  });

  final String id;
  final String name;
  final String description;
  final int monthlyPrice;

  factory AddOn.fromJson(Map<String, dynamic> json) => AddOn(
        id: json['id'].toString(),
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        monthlyPrice: (json['monthlyPrice'] as num).toInt(),
      );
}
