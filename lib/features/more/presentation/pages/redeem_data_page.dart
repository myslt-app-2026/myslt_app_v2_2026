import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/mock/mock_data.dart';
import '../../data/models/loyalty_model.dart';

class RedeemDataPage extends StatefulWidget {
  const RedeemDataPage({super.key});
  @override
  State<RedeemDataPage> createState() => _RedeemDataPageState();
}

class _RedeemDataPageState extends State<RedeemDataPage> {
  final loyalty = MockData.loyaltyPoints;
  final packages = MockData.redeemablePackages;

  Future<void> _handleRedeem(RedeemablePackage pkg) async {
    if (loyalty.redeemablePoints < pkg.pointsCost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough points'), backgroundColor: AppColors.error),
      );
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.cardRadius)),
        title: Text('Redeem ${pkg.name}?', style: AppTextStyles.headlineSmall),
        content: Text('Spend ${pkg.pointsCost} points for ${pkg.dataLabel} data (${pkg.validityDays} days).'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Redeem')),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${pkg.dataLabel} added!'), backgroundColor: AppColors.success),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded), onPressed: () => context.pop()),
        title: Text('Redeem Data', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.white, elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF059669), Color(0xFF10B981)]),
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            child: Row(children: [
              Icon(Icons.stars_rounded, color: Colors.white, size: 32),
              const SizedBox(width: AppSpacing.md),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Available Points', style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                Text('${loyalty.redeemablePoints}', style: AppTextStyles.amount.copyWith(color: Colors.white)),
              ]),
            ]),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: AppSpacing.xl),
          Text('Choose Package', style: AppTextStyles.titleMedium),
          const SizedBox(height: AppSpacing.md),
          ...packages.asMap().entries.map((e) {
            final pkg = e.value;
            final ok = loyalty.redeemablePoints >= pkg.pointsCost;
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: ok ? const Color(0xFF059669).withAlpha(20) : AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(child: Text(pkg.dataLabel, style: AppTextStyles.labelLarge.copyWith(color: ok ? const Color(0xFF059669) : AppColors.textTertiary, fontSize: 13), textAlign: TextAlign.center)),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(pkg.name, style: AppTextStyles.titleSmall),
                  Text(pkg.description, style: AppTextStyles.caption),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.stars_rounded, size: 14, color: ok ? const Color(0xFFD97706) : AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text('${pkg.pointsCost} pts', style: AppTextStyles.labelMedium.copyWith(color: ok ? const Color(0xFFD97706) : AppColors.textTertiary, fontWeight: FontWeight.w700)),
                  ]),
                ])),
                ElevatedButton(
                  onPressed: ok ? () => _handleRedeem(pkg) : null,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text('Redeem'),
                ),
              ]),
            ).animate().fadeIn(duration: 300.ms, delay: Duration(milliseconds: 100 + e.key * 80)).slideY(begin: 0.1);
          }),
        ],
      ),
    );
  }
}
