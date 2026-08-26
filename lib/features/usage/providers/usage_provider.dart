import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/broadband_usage_model.dart';
import '../data/models/usage_model.dart';
import '../data/repositories/usage_repository.dart';

// ─── Repository Provider ──────────────────────────────────────────────────────

final usageRepositoryProvider = Provider<UsageRepository>((ref) {
  return UsageRepository();
});

// ─── Current Broadband Usage (Endpoint 10) ────────────────────────────────────

class CurrentBroadbandUsageNotifier extends AsyncNotifier<BroadbandUsageModel> {
  @override
  Future<BroadbandUsageModel> build() => _fetch();

  Future<BroadbandUsageModel> _fetch() async {
    final repo = ref.read(usageRepositoryProvider);
    return repo.getCurrentBroadbandUsage();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

final currentBroadbandUsageProvider =
    AsyncNotifierProvider<CurrentBroadbandUsageNotifier, BroadbandUsageModel>(
        CurrentBroadbandUsageNotifier.new);

// ─── Selected Date ────────────────────────────────────────────────────────────

final selectedUsageDateProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

// ─── Daily (Hourly) Usage ─────────────────────────────────────────────────────

class DailyUsageNotifier extends AsyncNotifier<List<HourlyUsageModel>> {
  @override
  Future<List<HourlyUsageModel>> build() => _fetch();

  Future<List<HourlyUsageModel>> _fetch({DateTime? date}) async {
    final repo = ref.read(usageRepositoryProvider);
    final targetDate = date ?? ref.read(selectedUsageDateProvider);
    return repo.getDailyHourlyUsage(date: targetDate);
  }

  Future<void> fetchForDate(DateTime date) async {
    ref.read(selectedUsageDateProvider.notifier).state = date;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(date: date));
  }
}

final dailyUsageProvider =
    AsyncNotifierProvider<DailyUsageNotifier, List<HourlyUsageModel>>(
        DailyUsageNotifier.new);

// ─── Monthly Report ───────────────────────────────────────────────────────────

class MonthlyUsageNotifier extends AsyncNotifier<List<DailyUsageModel>> {
  @override
  Future<List<DailyUsageModel>> build() async {
    final repo = ref.read(usageRepositoryProvider);
    return repo.getMonthlyUsage();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

final monthlyUsageProvider =
    AsyncNotifierProvider<MonthlyUsageNotifier, List<DailyUsageModel>>(
        MonthlyUsageNotifier.new);

