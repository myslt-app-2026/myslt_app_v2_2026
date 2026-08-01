import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/bill_model.dart';
import '../../../core/mock/mock_data.dart';

// ─── Current Bill ─────────────────────────────────────────────────────────────

class BillNotifier extends AsyncNotifier<BillModel> {
  @override
  Future<BillModel> build() => _fetchBill();

  Future<BillModel> _fetchBill() async {
    await Future.delayed(const Duration(milliseconds: 900));
    return MockData.currentBill;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchBill);
  }
}

final billProvider =
    AsyncNotifierProvider<BillNotifier, BillModel>(BillNotifier.new);

// ─── Bill History ─────────────────────────────────────────────────────────────

class BillHistoryNotifier extends AsyncNotifier<List<BillModel>> {
  @override
  Future<List<BillModel>> build() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return MockData.billHistory;
  }
}

final billHistoryProvider =
    AsyncNotifierProvider<BillHistoryNotifier, List<BillModel>>(
        BillHistoryNotifier.new);
