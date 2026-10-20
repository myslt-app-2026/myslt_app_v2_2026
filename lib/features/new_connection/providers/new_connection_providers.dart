import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/connection_package.dart';
import '../data/new_connection_repository.dart';

final newConnectionRepositoryProvider =
    Provider<NewConnectionRepository>((ref) => NewConnectionRepository());

final packagesProvider = FutureProvider<List<ConnectionPackage>>(
  (ref) => ref.watch(newConnectionRepositoryProvider).fetchPackages(),
);

final addOnsProvider = FutureProvider<List<AddOn>>(
  (ref) => ref.watch(newConnectionRepositoryProvider).fetchAddOns(),
);

/// Everything the user has chosen so far. Later steps (NIC, address,
/// appointment...) can add their fields here or in their own providers.
class OrderState {
  const OrderState({this.package, this.addOnIds = const {}});

  final ConnectionPackage? package;
  final Set<String> addOnIds;

  OrderState copyWith({ConnectionPackage? package, Set<String>? addOnIds}) =>
      OrderState(
        package: package ?? this.package,
        addOnIds: addOnIds ?? this.addOnIds,
      );
}

class OrderNotifier extends Notifier<OrderState> {
  @override
  OrderState build() => const OrderState();

  void selectPackage(ConnectionPackage package) =>
      state = state.copyWith(package: package);

  void toggleAddOn(String id) {
    final next = {...state.addOnIds};
    next.contains(id) ? next.remove(id) : next.add(id);
    state = state.copyWith(addOnIds: next);
  }

  void reset() => state = const OrderState();
}

final orderProvider =
    NotifierProvider<OrderNotifier, OrderState>(OrderNotifier.new);

/// Monthly rental = package + selected add-ons.
final monthlyTotalProvider = Provider<int>((ref) {
  final order = ref.watch(orderProvider);
  final addOns = ref.watch(addOnsProvider).valueOrNull ?? const <AddOn>[];
  final base = order.package?.monthlyRental ?? 0;
  final extras = addOns
      .where((a) => order.addOnIds.contains(a.id))
      .fold<int>(0, (sum, a) => sum + a.monthlyPrice);
  return base + extras;
});
