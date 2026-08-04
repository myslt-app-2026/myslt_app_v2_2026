import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/widgets/app_button.dart';

class PackageUpgradePage extends StatefulWidget {
  const PackageUpgradePage({super.key});

  @override
  State<PackageUpgradePage> createState() => _PackageUpgradePageState();
}

class _PackageUpgradePageState extends State<PackageUpgradePage> {
  int _selectedIndex = 2; // Pro 200

  @override
  Widget build(BuildContext context) {
    final packages = MockData.postpaidPackages;
    final current = packages[1]; // Fiber Max 100
    final selected = packages[_selectedIndex];

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Upgrade Plan', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose a New Plan', style: AppTextStyles.titleMedium)
                .animate().fadeIn(),
            const SizedBox(height: AppSpacing.md),

            ...packages.asMap().entries.map((e) {
              final p = e.value;
              final isSelected = _selectedIndex == e.key;
              final isCurrent = e.key == 1;

              return GestureDetector(
                onTap: isCurrent ? null : () => setState(() => _selectedIndex = e.key),
                child: Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.borderLight,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio<int>(
                        value: e.key,
                        groupValue: _selectedIndex,
                        onChanged: isCurrent ? null : (v) => setState(() => _selectedIndex = v!),
                        activeColor: AppColors.primary,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(p.name, style: AppTextStyles.titleSmall),
                                if (isCurrent) ...[
                                  const SizedBox(width: AppSpacing.xs),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.successLight,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text('Current', style: AppTextStyles.caption.copyWith(color: AppColors.success)),
                                  ),
                                ],
                              ],
                            ),
                            Text(p.dataLabel, style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      Text(p.priceLabel, style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ).animate(delay: Duration(milliseconds: e.key * 100)).fadeIn(duration: 300.ms),
              );
            }),
            const SizedBox(height: AppSpacing.xl),

            // Comparison
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(13),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(color: AppColors.primary.withAlpha(51)),
              ),
              child: Column(
                children: [
                  Text('Plan Comparison', style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary)),
                  const SizedBox(height: AppSpacing.md),
                  _CompareRow('Data', current.dataLabel, selected.dataLabel),
                  _CompareRow('Speed', current.speed ?? 'N/A', selected.speed ?? 'N/A'),
                  _CompareRow('Price/mo', current.priceLabel, selected.priceLabel),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 350.ms),
            const SizedBox(height: AppSpacing.xl),

            AppButton(
              label: 'Upgrade to ${selected.name}',
              onPressed: _selectedIndex == 1 ? null : () => _confirmUpgrade(context, selected.name, selected.priceLabel),
              isDisabled: _selectedIndex == 1,
            ).animate().fadeIn(duration: 300.ms, delay: 400.ms),
          ],
        ),
      ),
    );
  }

  void _confirmUpgrade(BuildContext context, String plan, String price) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.cardRadius)),
        title: Text('Confirm Upgrade', style: AppTextStyles.headlineSmall),
        content: Text('Upgrade to "$plan" for $price/month?', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Plan upgraded!'), backgroundColor: AppColors.success),
              );
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }
}

class _CompareRow extends StatelessWidget {
  const _CompareRow(this.label, this.current, this.next);

  final String label;
  final String current;
  final String next;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary))),
          Expanded(child: Text(current, style: AppTextStyles.labelMedium, textAlign: TextAlign.center)),
          Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.teal),
          Expanded(child: Text(next, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary), textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
