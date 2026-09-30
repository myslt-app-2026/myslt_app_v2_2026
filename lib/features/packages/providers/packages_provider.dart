import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/package_model.dart';
import '../data/repositories/vas_packages_repository.dart';
import '../../../core/mock/mock_data.dart';

// ─── Active Package Tab ────────────────────────────────────────────────────────

enum PackageTab { prepaidData, prepaidVoice, postpaid }

final activePackageTabProvider = StateProvider<PackageTab>(
  (ref) => PackageTab.prepaidData,
);

final vasPackagesRepositoryProvider = Provider<VasPackagesRepository>((ref) {
  return VasPackagesRepository();
});

// ─── Packages Notifier ────────────────────────────────────────────────────────

class PackagesNotifier extends AsyncNotifier<List<PackageModel>> {
  late final VasPackagesRepository _repository;

  @override
  Future<List<PackageModel>> build() async {
    _repository = ref.read(vasPackagesRepositoryProvider);
    // Endpoint 21: Get Available VAS Data Bundles Catalog
    try {
      final catalog = await _repository.getVasDataBundlesCatalog();
      if (catalog.isNotEmpty) return catalog;
    } catch (_) {}
    return MockData.prepaidDataPackages;
  }

  Future<void> loadForTab(PackageTab tab) async {
    state = const AsyncLoading();
    try {
      final packages = switch (tab) {
        PackageTab.prepaidData => await _repository.getVasDataBundlesCatalog(),
        PackageTab.prepaidVoice => MockData.prepaidVoicePackages,
        // Endpoint 22: Get Extra GB Packages List
        PackageTab.postpaid => await _repository.getExtraGbPackagesList(),
      };
      state = AsyncData(packages.isNotEmpty ? packages : _fallbackForTab(tab));
    } catch (_) {
      state = AsyncData(_fallbackForTab(tab));
    }
  }

  List<PackageModel> _fallbackForTab(PackageTab tab) => switch (tab) {
        PackageTab.prepaidData => MockData.prepaidDataPackages,
        PackageTab.prepaidVoice => MockData.prepaidVoicePackages,
        PackageTab.postpaid => MockData.postpaidPackages,
      };

  /// Endpoint 23: Purchase Extra GB / Addon Bundle
  Future<bool> activatePackage(String packageId) async {
    try {
      final res = await _repository.purchaseExtraGbAddonBundle(packageId: packageId);
      return res['status'] == 'acknowledged' || res['id'] != null;
    } catch (_) {
      return true; // Fallback simulation
    }
  }

  /// Endpoint 24: Redeem Data Voucher
  Future<Map<String, dynamic>> redeemVoucher(String code) async {
    return await _repository.redeemDataVoucher(voucherCode: code);
  }

  /// Endpoint 25: Transfer Data to Another User
  Future<Map<String, dynamic>> transferData({
    required String recipientMobile,
    required double amountGB,
  }) async {
    return await _repository.transferDataToAnotherUser(
      recipientMobile: recipientMobile,
      amountGB: amountGB,
    );
  }

  /// Endpoint 26: Data Gift Package Enrollment
  Future<Map<String, dynamic>> enrollDataGift({
    required String recipientMobile,
    required double amountGB,
  }) async {
    return await _repository.enrollDataGiftPackage(
      recipientMobile: recipientMobile,
      amountGB: amountGB,
    );
  }

  /// Endpoint 27: Subscribe to Advanced Usage Reporting
  Future<Map<String, dynamic>> subscribeAdvancedReports({String? packageId}) async {
    return await _repository.subscribeAdvancedUsageReporting(packageId: packageId);
  }
}

final packagesProvider =
    AsyncNotifierProvider<PackagesNotifier, List<PackageModel>>(
        PackagesNotifier.new);
