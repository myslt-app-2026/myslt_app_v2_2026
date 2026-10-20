import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../data/models/connection_package.dart';
import '../../providers/new_connection_providers.dart';
import '../widgets/order_summary_bar.dart';

/// Step 1 of the new-connection flow: choose a package and optional add-ons.
class PackageSelectionScreen extends ConsumerWidget {
  const PackageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final packages = ref.watch(packagesProvider);
    final addOns = ref.watch(addOnsProvider);
    final order = ref.watch(orderProvider);
    final notifier = ref.read(orderProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('New connection')),
      body: packages.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Could not load packages'),
              TextButton(
                onPressed: () => ref.invalidate(packagesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (list) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Choose your package',
                style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            for (final p in list)
              _PackageCard(
                package: p,
                selected: order.package?.id == p.id,
                onTap: () => notifier.selectPackage(p),
              ),
            const SizedBox(height: 12),
            Text('Add-ons (optional)',
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            addOns.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => const Text('Could not load add-ons'),
              data: (items) => Column(
                children: [
                  for (final a in items)
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      value: order.addOnIds.contains(a.id),
                      onChanged: (_) => notifier.toggleAddOn(a.id),
                      title: Text(a.name),
                      subtitle: Text(a.description),
                      secondary: Text('+${formatRs(a.monthlyPrice)}'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: OrderSummaryBar(
        onContinue: () => context.push(AppRoutes.newConnectionNic),
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({
    required this.package,
    required this.selected,
    required this.onTap,
  });

  final ConnectionPackage package;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? cs.primaryContainer : cs.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? cs.primary : cs.outlineVariant,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(package.type,
                        style: tt.labelMedium
                            ?.copyWith(color: cs.onSurfaceVariant)),
                  ),
                  if (package.recommended)
                    Chip(
                      label: const Text('Popular'),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: cs.secondaryContainer,
                    ),
                ],
              ),
              Text(
                '${package.name} · ${package.speedLabel}',
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              for (final f in package.features)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check, size: 16, color: cs.primary),
                      const SizedBox(width: 8),
                      Expanded(child: Text(f, style: tt.bodyMedium)),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                '${formatRs(package.monthlyRental)} / month',
                style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}