class AccountSummaryModel {
  const AccountSummaryModel({
    required this.accountNumber,
    required this.planName,
    required this.totalDataMB,
    required this.usedDataMB,
    required this.bonusDataMB,
    required this.nightDataMB,
    required this.nightDataUsedMB,
    required this.freeMinutes,
    required this.usedMinutes,
    required this.expiryDate,
    required this.accountType,
    required this.isActive,
  });

  final String accountNumber;
  final String planName;
  final double totalDataMB;
  final double usedDataMB;
  final double bonusDataMB;
  final double nightDataMB;
  final double nightDataUsedMB;
  final int freeMinutes;
  final int usedMinutes;
  final DateTime expiryDate;
  final String accountType;
  final bool isActive;

  double get remainingDataMB => totalDataMB - usedDataMB;
  double get usagePercentage => totalDataMB > 0 ? (usedDataMB / totalDataMB).clamp(0.0, 1.0) : 0.0;
  double get remainingMinutes => (freeMinutes - usedMinutes).toDouble().clamp(0, double.infinity);
  bool get isExpiringSoon => expiryDate.difference(DateTime.now()).inDays <= 5;
}
