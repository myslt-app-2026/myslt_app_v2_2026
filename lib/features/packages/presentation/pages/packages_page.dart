import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/packages_provider.dart';
import '../../data/models/package_model.dart';
import 'package_upgrade_page.dart';

class PackagesPage extends ConsumerWidget {
  const PackagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(activePackageTabProvider);
    final packagesAsync = ref.watch(packagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Packages'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildTabs(context, ref, tab),
          Expanded(
            child: packagesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (err, _) => Center(
                child: Text('Error: \$err'),
              ),
              data: (packages) {
                if (packages.isEmpty) {
                  return const Center(
                    child: Text('No packages available'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: packages.length,
                  itemBuilder: (context, index) {
                    final package = packages[index];
                    return _PackageCard(package: package);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(
      BuildContext context, WidgetRef ref, PackageTab currentTab) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SegmentedButton<PackageTab>(
        segments: const [
          ButtonSegment(
            value: PackageTab.prepaidData,
            label: Text('Data'),
            icon: Icon(Icons.data_usage),
          ),
          ButtonSegment(
            value: PackageTab.prepaidVoice,
            label: Text('Voice'),
            icon: Icon(Icons.call),
          ),
          ButtonSegment(
            value: PackageTab.postpaid,
            label: Text('Postpaid'),
            icon: Icon(Icons.home_work),
          ),
        ],
        selected: {currentTab},
        onSelectionChanged: (selection) {
          final selected = selection.first;
          ref.read(activePackageTabProvider.notifier).state = selected;
          ref.read(packagesProvider.notifier).loadForTab(selected);
        },
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package});

  final PackageModel package;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PackageUpgradePage(package: package),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      package.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (package.tag != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: package.tagColorValue ?? Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        package.tag!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(package.description),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.data_usage, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    package.dataLabel,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const Icon(Icons.schedule, size: 20),
                  const SizedBox(width: 6),
                  Text('\${package.validityDays} days'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    package.priceLabel,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PackageUpgradePage(package: package),
                        ),
                      );
                    },
                    child: const Text('View'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}