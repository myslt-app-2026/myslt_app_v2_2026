class IDDRateModel {
  const IDDRateModel({
    required this.countryCode,
    required this.countryName,
    required this.flag,
    required this.ratePerMin,
    this.peakRate,
    this.offPeakRate,
  });

  final String countryCode;
  final String countryName;
  final String flag;
  final double ratePerMin;
  final double? peakRate;
  final double? offPeakRate;

  String get rateLabel => 'Rs. ${ratePerMin.toStringAsFixed(2)}/min';
}

class IDDPackageModel {
  const IDDPackageModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.minutes,
    required this.countries,
    required this.validityDays,
    this.isActive = false,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final int minutes;
  final List<String> countries;
  final int validityDays;
  final bool isActive;

  String get priceLabel => 'Rs. ${price.toStringAsFixed(2)}';
}
