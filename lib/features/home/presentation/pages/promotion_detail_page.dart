import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/models/promotion_model.dart';

class PromotionDetailPage extends StatelessWidget {
  const PromotionDetailPage({
    super.key,
    this.promotion,
    required this.promotionId,
  });

  final PromotionModel? promotion;
  final String promotionId;

  PromotionModel get _promo {
    if (promotion != null) return promotion!;
    return MockData.promotions.firstWhere(
      (p) => p.id == promotionId,
      orElse: () => MockData.promotions.first,
    );
  }
}
@override
  Widget build(BuildContext context) {
    final promo = _promo;
    final isExpired = promo.expiryDate.isBefore(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // ── Silver AppBar with Image ──
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: CircleAvatar(
              backgroundColor: Colors.black.withAlpha(76),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18),
                onPressed: () => context.pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    promo.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                        ),
                      ),
                    ),
                  ),
                  // Bottom shadow overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(127),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Content 
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge + Expiry
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (promo.badgeLabel != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: promo.badgeColorValue ?? AppColors.warning,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            promo.badgeLabel!,
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Text(
                        isExpired
                            ? 'Offer Expired'
                            : 'Valid until: ${_formatDate(promo.expiryDate)}',
                        style: AppTextStyles.caption.copyWith(
                          color: isExpired ? AppColors.error : AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms),
                  const SizedBox(height: AppSpacing.md),

                  // Title
                  Text(
                    promo.title,
                    style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.bold),
                  ).animate().fadeIn(duration: 300.ms, delay: 100.ms).slideY(begin: 0.1),
                  const SizedBox(height: AppSpacing.xs),

                  // Subtitle
                  Text(
                    promo.subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ).animate().fadeIn(duration: 300.ms, delay: 150.ms),
                ],
              ),
            ),
          ),
