import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/connection_package.dart';
import '../../data/new_connection_repository.dart';
import '../../providers/new_connection_providers.dart';

/// Sticky bottom bar: live totals + Continue button.
/// Reuse this on every step of the flow.
class OrderSummaryBar extends ConsumerWidget {
  const OrderSummaryBar({
    super.key,
    required this.onContinue,
    this.continueLabel = 'Continue',
  });

  final VoidCallback onContinue;
  final String continueLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final package = ref.watch(orderProvider).package;
    final monthly = ref.watch(monthlyTotalProvider);
    final displayMonthly = package != null ? monthly : 8740;

    return Material(
      elevation: 8,
      color: cs.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${formatRs(displayMonthly)} / month',
                      style:
                          tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '+ ${formatRs(NewConnectionRepository.connectionCharge)} one-time connection charge',
                      style: tt.bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: onContinue,
                child: Text(continueLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
