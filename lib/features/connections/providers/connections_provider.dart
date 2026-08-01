import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/connection_model.dart';
import '../../../core/mock/mock_data.dart';

// ─── Connections Notifier ─────────────────────────────────────────────────────

class ConnectionsNotifier extends AsyncNotifier<List<ConnectionModel>> {
  @override
  Future<List<ConnectionModel>> build() => _fetch();

  Future<List<ConnectionModel>> _fetch() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return MockData.connections;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<bool> addConnection(String accountNumber, String nickname) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final current = state.valueOrNull ?? [];
    final newConn = ConnectionModel(
      id: 'conn_${DateTime.now().millisecondsSinceEpoch}',
      accountNumber: accountNumber,
      name: nickname,
      type: ConnectionType.fiber,
      isActive: false,
      planName: 'SLT Fiber',
    );
    state = AsyncData([...current, newConn]);
    return true;
  }

  Future<bool> removeConnection(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final current = state.valueOrNull ?? [];
    state = AsyncData(current.where((c) => c.id != id).toList());
    return true;
  }

  Future<void> setActive(String id) async {
    final current = state.valueOrNull ?? [];
    state = AsyncData(
      current.map((c) => c.copyWith(isActive: c.id == id)).toList(),
    );
  }
}

final connectionsProvider =
    AsyncNotifierProvider<ConnectionsNotifier, List<ConnectionModel>>(
        ConnectionsNotifier.new);
