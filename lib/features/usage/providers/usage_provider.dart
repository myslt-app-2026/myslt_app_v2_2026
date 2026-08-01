import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/usage_model.dart';
import '../../../core/mock/mock_data.dart';

// ─── Selected Date ────────────────────────────────────────────────────────────

final selectedUsageDateProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

// ─── Daily (Hourly) Usage ─────────────────────────────────────────────────────

class DailyUsageNotifier extends AsyncNotifier<List<HourlyUsageModel>> {
  @override
  Future<List<HourlyUsageModel>> build() => _fetch();

  Future<List<HourlyUsageModel>> _fetch() async {
    await Future.delayed(const Duration(milliseconds: 900));
    return MockData.todayHourlyUsage;
  }

  Future<void> fetchForDate(DateTime date) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

final dailyUsageProvider =
    AsyncNotifierProvider<DailyUsageNotifier, List<HourlyUsageModel>>(
        DailyUsageNotifier.new);

// ─── Monthly Report ───────────────────────────────────────────────────────────

class MonthlyUsageNotifier extends AsyncNotifier<List<DailyUsageModel>> {
  @override
  Future<List<DailyUsageModel>> build() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return MockData.monthlyUsage;
  }
}

final monthlyUsageProvider =
    AsyncNotifierProvider<MonthlyUsageNotifier, List<DailyUsageModel>>(
        MonthlyUsageNotifier.new);
