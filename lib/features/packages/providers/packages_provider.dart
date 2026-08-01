import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/package_model.dart';
import '../../../core/mock/mock_data.dart';

// ─── Active Package Tab ────────────────────────────────────────────────────────

enum PackageTab { prepaidData, prepaidVoice, postpaid }

final activePackageTabProvider = StateProvider<PackageTab>(
  (ref) => PackageTab.prepaidData,
);

// ─── Packages Notifier ────────────────────────────────────────────────────────

class PackagesNotifier extends AsyncNotifier<List<PackageModel>> {
  @override
  Future<List<PackageModel>> build() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return MockData.prepaidDataPackages;
  }

  Future<void> loadForTab(PackageTab tab) async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(milliseconds: 600));
    final packages = switch (tab) {
      PackageTab.prepaidData => MockData.prepaidDataPackages,
      PackageTab.prepaidVoice => MockData.prepaidVoicePackages,
      PackageTab.postpaid => MockData.postpaidPackages,
    };
    state = AsyncData(packages);
  }

  Future<bool> activatePackage(String packageId) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    // Demo: always succeeds
    return true;
  }
}

final packagesProvider =
    AsyncNotifierProvider<PackagesNotifier, List<PackageModel>>(
        PackagesNotifier.new);
