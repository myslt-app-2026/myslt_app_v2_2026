class ShopLocationModel {
  const ShopLocationModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.phone,
    required this.hours,
    required this.latitude,
    required this.longitude,
    this.isOpen = true,
    this.distanceKm,
  });

  final String id;
  final String name;
  final String address;
  final String city;
  final String phone;
  final String hours;
  final double latitude;
  final double longitude;
  final bool isOpen;
  final double? distanceKm;

  String get distanceLabel {
    if (distanceKm == null) return '';
    if (distanceKm! < 1) return '${(distanceKm! * 1000).toStringAsFixed(0)} m';
    return '${distanceKm!.toStringAsFixed(1)} km';
  }
}
