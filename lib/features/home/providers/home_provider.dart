import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/account_summary_model.dart';
import '../data/models/promotion_model.dart';
import '../../../core/mock/mock_data.dart';

// ─── Account Summary ──────────────────────────────────────────────────────────

class HomeNotifier extends AsyncNotifier<AccountSummaryModel> {
  @override
  Future<AccountSummaryModel> build() => _fetchSummary();

  Future<AccountSummaryModel> _fetchSummary() async {
    // Simulate network delay — replace with real Dio call
    await Future.delayed(const Duration(milliseconds: 1200));
    return MockData.accountSummary;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchSummary);
  }
}

final homeProvider =
    AsyncNotifierProvider<HomeNotifier, AccountSummaryModel>(HomeNotifier.new);

// ─── Promotions ───────────────────────────────────────────────────────────────

class PromotionsNotifier extends AsyncNotifier<List<PromotionModel>> {
  @override
  Future<List<PromotionModel>> build() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return MockData.promotions;
  }
}

final promotionsProvider =
    AsyncNotifierProvider<PromotionsNotifier, List<PromotionModel>>(
        PromotionsNotifier.new);
