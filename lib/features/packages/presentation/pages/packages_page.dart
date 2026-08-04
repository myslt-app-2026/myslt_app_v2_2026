import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../data/models/package_model.dart';

class PackagesPage extends StatefulWidget {
  const PackagesPage({super.key});

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primary,
            title: Text(
              'Packages',
              style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
            ),
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withAlpha(153),
              indicatorColor: AppColors.teal,
              indicatorWeight: 3,
              labelStyle: AppTextStyles.labelLarge,
              tabs: const [
                Tab(text: 'Prepaid'),
                Tab(text: 'Postpaid'),
              ],
            ),
          ),
        ],
        body: _isLoading
            ? Padding(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                child: AppShimmer.listItem(count: 4),
              )
            : TabBarView(
                controller: _tabController,
                children: [
                  _PrepaidTab(),
                  _PostpaidTab(),
                ],
              ),
      ),
    );
  }
}

class _PrepaidTab extends StatefulWidget {
  @override
  State<_PrepaidTab> createState() => _PrepaidTabState();
}

class _PrepaidTabState extends State<_PrepaidTab>
    with SingleTickerProviderStateMixin {
  late TabController _innerTab;

  @override
  void initState() {
    super.initState();
    _innerTab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _innerTab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _innerTab,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [Tab(text: 'Data'), Tab(text: 'Voice'), Tab(text: 'Combo')],
        ),
        Expanded(
          child: TabBarView(
            controller: _innerTab,
            children: [
              _PackageList(packages: MockData.prepaidDataPackages),
              _PackageList(packages: MockData.prepaidVoicePackages),
              const Center(child: Text('Combo packages coming soon')),
            ],
          ),
        ),
      ],
    );
  }
}

class _PostpaidTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _PackageList(packages: MockData.postpaidPackages)),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: AppButton(
            label: 'Upgrade Plan',
            onPressed: () => context.push(AppRoutes.packageUpgrade),
            variant: AppButtonVariant.outline,
            icon: Icons.upgrade_rounded,
          ),
        ),
      ],
    );
  }
}

class _PackageList extends StatelessWidget {
  const _PackageList({required this.packages});

  final List<PackageModel> packages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      itemCount: packages.length,
      itemBuilder: (context, index) {
        return _PackageCard(
          package: packages[index],
          animDelay: Duration(milliseconds: index * 80),
        );
      },
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package, required this.animDelay});

  final PackageModel package;
  final Duration animDelay;

  @override
  Widget build(BuildContext context) {
    final isActive = package.isActive;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.borderLight,
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primary.withAlpha(26),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(package.name, style: AppTextStyles.titleSmall),
                      Text(package.description, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                if (package.tag != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (package.tagColorValue ?? AppColors.primary).withAlpha(26),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      package.tag!,
                      style: AppTextStyles.caption.copyWith(
                        color: package.tagColorValue ?? AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _FeatureChip(
                  icon: Icons.data_usage_rounded,
                  label: package.dataLabel,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                if (package.freeMinutes > 0)
                  _FeatureChip(
                    icon: Icons.phone_rounded,
                    label: '${package.freeMinutes} min',
                    color: AppColors.teal,
                  ),
                if (package.speed != null)
                  _FeatureChip(
                    icon: Icons.speed_rounded,
                    label: package.speed!,
                    color: AppColors.teal,
                  ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(package.priceLabel, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.primary)),
                    Text(
                      '${package.validityDays} days',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ],
            ),
            if (!isActive) ...[
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: 'Activate',
                onPressed: () => _confirmActivation(context),
                height: 40,
              ),
            ],
          ],
        ),
      ),
    ).animate(delay: animDelay).fadeIn(duration: 300.ms).slideY(begin: 0.1);
  }

  void _confirmActivation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        title: Text('Confirm Activation', style: AppTextStyles.headlineSmall),
        content: Text(
          'Activate "${package.name}" for ${package.priceLabel}?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${package.name} activated!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Activate'),
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
