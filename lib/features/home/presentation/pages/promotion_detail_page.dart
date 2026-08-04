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
          
          // Content placeholder
          SliverToBoxAdapter(child: Container()),
        ],
      ),
    );
  }
