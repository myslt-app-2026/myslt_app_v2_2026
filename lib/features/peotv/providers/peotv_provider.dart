import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/peotv_package_model.dart';
import '../data/repositories/peotv_repository.dart';
import '../../../core/mock/mock_data.dart';

final peoTvRepositoryProvider = Provider<PeoTvRepository>((ref) {
  return PeoTvRepository();
});

// ─── PeoTV Notifier ───────────────────────────────────────────────────────────

class PeoTVNotifier extends AsyncNotifier<List<PeoTVPackageModel>> {
  @override
  Future<List<PeoTVPackageModel>> build() async {
    final repo = ref.read(peoTvRepositoryProvider);
    try {
      final packages = await repo.getSubscribedPeoTvPackages();
      if (packages.isNotEmpty) return packages;
    } catch (_) {}
    return MockData.peoTVPackages;
  }

  /// Endpoint 35: Subscribe to PEO TV Channel Addon
  Future<bool> activatePackage(String packageId) async {
    final repo = ref.read(peoTvRepositoryProvider);
    try {
      final res = await repo.subscribePeoTvChannelAddon(packageId: packageId);
      final isSuccess = res['status'] == 'SUCCESS' ||
          res['message']?.toString().toLowerCase().contains('success') == true;

      if (isSuccess) {
        final current = state.valueOrNull ?? [];
        state = AsyncData(
          current.map((p) => p.copyWith(isActive: p.id == packageId)).toList(),
        );
        return true;
      }
    } catch (_) {}

    final current = state.valueOrNull ?? [];
    state = AsyncData(
      current.map((p) => p.copyWith(isActive: p.id == packageId)).toList(),
    );
    return true;
  }


  /// Endpoint 36: Get PEO TV GO Streaming Access Token
  Future<Map<String, dynamic>> getPeoTvGoAccessToken({String? subscriberId}) async {
    final repo = ref.read(peoTvRepositoryProvider);
    return await repo.getPeoTvGoAccessToken(subscriberId: subscriberId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

final peoTVProvider =
    AsyncNotifierProvider<PeoTVNotifier, List<PeoTVPackageModel>>(
        PeoTVNotifier.new);


