import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// Shimmer skeleton loading placeholder for the mySLT app.
class AppShimmer extends StatelessWidget {
  const AppShimmer({
    super.key,
    required this.child,
    this.isLoading = true,
  });

  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!isLoading) return child;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
      highlightColor:
          isDark ? AppColors.shimmerHighlightDark : AppColors.shimmerHighlight,
      child: child,
    );
  }

  /// Creates a rectangular shimmer placeholder.
  static Widget rectangular({
    double? width,
    double height = 16,
    double radius = AppSpacing.cardRadiusSm,
    EdgeInsetsGeometry? margin,
  }) {
    return AppShimmer(
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  /// Creates a circular shimmer placeholder.
  static Widget circular({double size = 48}) {
    return AppShimmer(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// Creates a card-shaped shimmer placeholder.
  static Widget card({
    double? width,
    double height = 120,
    EdgeInsetsGeometry? margin,
  }) {
    return AppShimmer(
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
      ),
    );
  }

  /// Creates a list-item shimmer placeholder.
  static Widget listItem({int count = 4}) {
    return Column(
      children: List.generate(
        count,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(
            children: [
              AppShimmer.circular(size: 48),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmer.rectangular(height: 14, width: double.infinity),
                    const SizedBox(height: AppSpacing.xs),
                    AppShimmer.rectangular(height: 12, width: 160),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Creates a home dashboard shimmer layout.
  static Widget dashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Column(
        children: [
          AppShimmer.card(height: 200),
          const SizedBox(height: AppSpacing.lg),
          AppShimmer.card(height: 160),
          const SizedBox(height: AppSpacing.lg),
          AppShimmer.rectangular(height: 18, width: 140),
          const SizedBox(height: AppSpacing.md),
          AppShimmer.card(height: 180),
        ],
      ),
    );
  }
}
