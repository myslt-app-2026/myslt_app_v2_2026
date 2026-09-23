import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/account_summary_model.dart';
import '../data/models/popup_banner_model.dart';
import '../data/models/promotion_model.dart';
import '../data/repositories/banner_notification_repository.dart';
import '../../usage/providers/usage_provider.dart';

// ─── Banner & Notification Repository Provider ────────────────────────────────
final bannerNotificationRepositoryProvider =
    Provider<BannerNotificationRepository>((ref) {
  return BannerNotificationRepository();
});

// ─── Account Summary ──────────────────────────────────────────────────────────

class HomeNotifier extends AsyncNotifier<AccountSummaryModel> {
  @override
  Future<AccountSummaryModel> build() => _fetchSummary();

  Future<AccountSummaryModel> _fetchSummary() async {
    final repo = ref.read(usageRepositoryProvider);
    return repo.getAccountSummary();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchSummary);
  }
}

final homeProvider =
    AsyncNotifierProvider<HomeNotifier, AccountSummaryModel>(HomeNotifier.new);

// ─── Promotional Banners (Endpoint 31: TMF681) ────────────────────────────────

class PromotionsNotifier extends AsyncNotifier<List<PromotionModel>> {
  @override
  Future<List<PromotionModel>> build() async {
    final repo = ref.read(bannerNotificationRepositoryProvider);
    return repo.getPromotionalBanners();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(bannerNotificationRepositoryProvider);
      return repo.getPromotionalBanners();
    });
  }
}

final promotionsProvider =
    AsyncNotifierProvider<PromotionsNotifier, List<PromotionModel>>(
        PromotionsNotifier.new);

// ─── Home Screen Popup Banners (Endpoint 32) ──────────────────────────────────

class PopupBannersNotifier extends AsyncNotifier<List<PopupBannerModel>> {
  @override
  Future<List<PopupBannerModel>> build() async {
    final repo = ref.read(bannerNotificationRepositoryProvider);
    return repo.getPopupBanners();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(bannerNotificationRepositoryProvider);
      return repo.getPopupBanners();
    });
  }
}

final popupBannersProvider =
    AsyncNotifierProvider<PopupBannersNotifier, List<PopupBannerModel>>(
        PopupBannersNotifier.new);
