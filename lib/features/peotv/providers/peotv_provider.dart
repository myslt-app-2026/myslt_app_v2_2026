import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/peotv_package_model.dart';
import '../../../core/mock/mock_data.dart';

// ─── PeoTV Notifier ───────────────────────────────────────────────────────────

class PeoTVNotifier extends AsyncNotifier<List<PeoTVPackageModel>> {
  @override
  Future<List<PeoTVPackageModel>> build() async {
    await Future.delayed(const Duration(milliseconds: 900));
    return MockData.peoTVPackages;
  }

  Future<bool> activatePackage(String packageId) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final current = state.valueOrNull ?? [];
    state = AsyncData(
      current.map((p) => p.copyWith(isActive: p.id == packageId)).toList(),
    );
    return true;
  }
}

final peoTVProvider =
    AsyncNotifierProvider<PeoTVNotifier, List<PeoTVPackageModel>>(
        PeoTVNotifier.new);
