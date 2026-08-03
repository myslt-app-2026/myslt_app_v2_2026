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
