import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/package_model.dart';
import '../../providers/packages_provider.dart';

class PackageUpgradePage extends ConsumerWidget {
  const PackageUpgradePage({
    super.key,
    required this.package,
  });

  final PackageModel package;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(package.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      package.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      package.priceLabel,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      package.description,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Package Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            _InfoTile(
              icon: Icons.data_usage,
              title: 'Data',
              value: package.dataLabel,
            ),

            if (package.bonusDataMB > 0)
              _InfoTile(
                icon: Icons.card_giftcard,
                title: 'Bonus Data',
                value: '\${package.bonusDataMB.toStringAsFixed(0)} MB',
              ),

            if (package.freeMinutes > 0)
              _InfoTile(
                icon: Icons.call,
                title: 'Free Minutes',
                value: '\${package.freeMinutes} minutes',
              ),

            _InfoTile(
              icon: Icons.schedule,
              title: 'Validity',
              value: '\${package.validityDays} days',
            ),

            if (package.speed != null)
              _InfoTile(
                icon: Icons.speed,
                title: 'Speed',
                value: package.speed!,
              ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final success = await ref
                      .read(packagesProvider.notifier)
                      .activatePackage(package.id);

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? '\${package.name} activated successfully!'
                            : 'Activation failed',
                      ),
                      backgroundColor:
                          success ? Colors.green : Colors.red,
                    ),
                  );

                  if (success) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  package.isActive
                      ? 'Current Package'
                      : 'Activate / Upgrade',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}