import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/models/peotv_package_model.dart';

class PeoTVPage extends StatefulWidget {
  const PeoTVPage({super.key});

  @override
  State<PeoTVPage> createState() => _PeoTVPageState();
}

class _PeoTVPageState extends State<PeoTVPage> {
  @override
  Widget build(BuildContext context) {
    final packages = MockData.peoTVPackages;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
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
          SliverPadding(
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
    );
  }
}

class _PeoTVPackageCard extends StatelessWidget {
  const _PeoTVPackageCard({required this.package, required this.animDelay});

  final PeoTVPackageModel package;
  final Duration animDelay;

  @override
  Widget build(BuildContext context) {
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
                            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${package.name} activated!'),
                                backgroundColor: AppColors.success,
                              ),
                            ),
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
