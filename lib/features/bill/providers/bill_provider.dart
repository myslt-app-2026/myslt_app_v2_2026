import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/bill_model.dart';
import '../data/repositories/bill_repository.dart';

// ─── Repository Provider ──────────────────────────────────────────────────────

final billRepositoryProvider = Provider<BillRepository>((ref) {
  return BillRepository();
});

// ─── Current Bill (Endpoints 16, 19) ──────────────────────────────────────────

class BillNotifier extends AsyncNotifier<BillModel> {
  @override
  Future<BillModel> build() => _fetchBill();

  Future<BillModel> _fetchBill() async {
    final repo = ref.read(billRepositoryProvider);
    return repo.getCurrentBill();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchBill);
  }
}

final billProvider =
    AsyncNotifierProvider<BillNotifier, BillModel>(BillNotifier.new);

// ─── Bill History (Endpoint 19) ───────────────────────────────────────────────

class BillHistoryNotifier extends AsyncNotifier<List<BillModel>> {
  @override
  Future<List<BillModel>> build() async {
    final repo = ref.read(billRepositoryProvider);
    return repo.getPaymentHistoryAndBillStatus();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

final billHistoryProvider =
    AsyncNotifierProvider<BillHistoryNotifier, List<BillModel>>(
        BillHistoryNotifier.new);

// ─── E-Bill Status (Endpoint 16) ──────────────────────────────────────────────

class EBillStatusNotifier extends AsyncNotifier<Map<String, dynamic>> {
  @override
  Future<Map<String, dynamic>> build() async {
    final repo = ref.read(billRepositoryProvider);
    return repo.checkEBillStatus();
  }
}

final eBillStatusProvider =
    AsyncNotifierProvider<EBillStatusNotifier, Map<String, dynamic>>(
        EBillStatusNotifier.new);

