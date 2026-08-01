class HourlyUsageModel {
  const HourlyUsageModel({
    required this.hour,
    required this.usedMB,
    required this.downloadMB,
    required this.uploadMB,
  });

  final int hour;
  final double usedMB;
  final double downloadMB;
  final double uploadMB;

  String get hourLabel {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
  }
}

class DailyUsageModel {
  const DailyUsageModel({
    required this.date,
    required this.usedMB,
    required this.streamingMB,
    required this.browsingMB,
    required this.socialMB,
    required this.gamingMB,
    required this.otherMB,
  });

  final DateTime date;
  final double usedMB;
  final double streamingMB;
  final double browsingMB;
  final double socialMB;
  final double gamingMB;
  final double otherMB;
}
