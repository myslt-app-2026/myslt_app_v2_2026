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

  Future<bool> activatePackage(String packageId) async {
    final current = state.valueOrNull ?? [];
    state = AsyncData(
      current.map((p) => p.copyWith(isActive: p.id == packageId)).toList(),
    );
    return true;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

final peoTVProvider =
    AsyncNotifierProvider<PeoTVNotifier, List<PeoTVPackageModel>>(
        PeoTVNotifier.new);

