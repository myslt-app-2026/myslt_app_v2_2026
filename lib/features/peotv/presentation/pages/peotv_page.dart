import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../data/models/peotv_package_model.dart';
import '../../providers/peotv_provider.dart';
import '../widgets/peotv_go_dialog.dart';


class PeoTVPage extends ConsumerWidget {
  const PeoTVPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peoTvAsync = ref.watch(peoTVProvider);
    final packages = peoTvAsync.valueOrNull ?? MockData.peoTVPackages;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: RefreshIndicator(
        onRefresh: () => ref.read(peoTVProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 120,
              backgroundColor: const Color(0xFF1E1B4B),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                onPressed: () => context.pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4338CA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      child: Row(
                        children: [
                          const Icon(Icons.tv_rounded, color: Colors.white, size: 28),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('PeoTV', style: AppTextStyles.headlineMedium.copyWith(color: Colors.white)),
                              Text('Choose your package', style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // PeoTV GO Streaming Access Token Action Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.pagePadding, AppSpacing.pagePadding, AppSpacing.pagePadding, 0),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4C1D95), Color(0xFF7C3AED)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7C3AED).withAlpha(60),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(51),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PeoTV GO Web Streaming',
                              style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Stream 200+ channels on any browser',
                              style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF7C3AED),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                        onPressed: () => launchPeoTvGoTokenFlow(context, ref),
                        child: const Text('Stream Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            peoTvAsync.isLoading
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.pagePadding),
                      child: Column(
                        children: List.generate(
                          3,
                          (_) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                            child: AppShimmer.card(height: 180),
                          ),
                        ),
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.pagePadding),
                    sliver: SliverList.builder(
                      itemCount: packages.length,
                      itemBuilder: (context, index) {
                        return _PeoTVPackageCard(
                          package: packages[index],
                          animDelay: Duration(milliseconds: index * 100),
                        );
                      },
                    ),
                  ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl4)),
          ],
        ),
      ),
    );
  }
}



class _PeoTVPackageCard extends ConsumerWidget {
  const _PeoTVPackageCard({required this.package, required this.animDelay});

  final PeoTVPackageModel package;
  final Duration animDelay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg),
        border: Border.all(
          color: package.isActive ? const Color(0xFF4338CA) : AppColors.borderLight,
          width: package.isActive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E1B4B), Color(0xFF4338CA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.cardRadiusLg - 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(package.name, style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
                      Text(
                        '${package.channelCount} Channels',
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                if (package.tag != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (package.tagColorValue ?? Colors.amber).withAlpha(51),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: package.tagColorValue ?? Colors.amber),
                    ),
                    child: Text(
                      package.tag!,
                      style: AppTextStyles.caption.copyWith(
                        color: package.tagColorValue ?? Colors.amber,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(package.description, style: AppTextStyles.bodySmall),
                const SizedBox(height: AppSpacing.md),
                // Sample channels
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: package.channels.take(4).map((ch) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(ch, style: AppTextStyles.caption),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(package.priceLabel, style: AppTextStyles.amount),
                    package.isActive
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                                const SizedBox(width: 6),
                                Text('Active', style: AppTextStyles.labelMedium.copyWith(color: AppColors.success)),
                              ],
                            ),
                          )
                        : AppButton(
                            label: 'Activate',
                            onPressed: () async {
                              final success = await ref
                                  .read(peoTVProvider.notifier)
                                  .activatePackage(package.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? '${package.name} activated successfully!'
                                          : 'Failed to activate ${package.name}',
                                    ),
                                    backgroundColor: success
                                        ? AppColors.success
                                        : AppColors.error,
                                  ),
                                );
                              }
                            },
                            width: 120,
                            height: 40,
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: animDelay).fadeIn(duration: 400.ms).slideY(begin: 0.2, curve: Curves.easeOut);
  }
}
