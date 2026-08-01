import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/account_summary_model.dart';

/// Premium glassmorphism account summary card with animated data usage gauge.
class AccountSummaryCard extends StatelessWidget {
  const AccountSummaryCard({super.key, required this.summary});

  final AccountSummaryModel summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.cardGradient,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(77),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withAlpha(20),
                    width: 2,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: 60,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withAlpha(13),
                    width: 1,
                  ),
                ),
              ),
            ),
            // Card content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plan + Status row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              summary.planName,
                              style: AppTextStyles.titleMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              summary.accountType,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white.withAlpha(179),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _StatusBadge(isActive: summary.isActive),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Data gauge + stats
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Circular gauge
                      _DataGauge(
                        used: summary.usedDataMB,
                        total: summary.totalDataMB,
                        percentage: summary.usagePercentage,
                      ),
                      const SizedBox(width: AppSpacing.xl),

                      // Stats column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _StatRow(
                              icon: Icons.data_usage_rounded,
                              label: 'Used',
                              value: AppFormatters.formatDataSizeCompact(
                                  summary.usedDataMB),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            _StatRow(
                              icon: Icons.download_rounded,
                              label: 'Remaining',
                              value: AppFormatters.formatDataSizeCompact(
                                  summary.remainingDataMB),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            _StatRow(
                              icon: Icons.stars_rounded,
                              label: 'Bonus',
                              value: AppFormatters.formatDataSizeCompact(
                                  summary.bonusDataMB),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            _StatRow(
                              icon: Icons.phone_in_talk_rounded,
                              label: 'Minutes',
                              value:
                                  '${summary.freeMinutes - summary.usedMinutes} min',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Divider
                  Divider(
                    color: Colors.white.withAlpha(51),
                    thickness: 1,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Expiry
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                            color: Colors.white.withAlpha(179),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'Expires ${AppFormatters.formatDate(summary.expiryDate)}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white.withAlpha(179),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: summary.isExpiringSoon
                              ? AppColors.warning.withAlpha(51)
                              : Colors.white.withAlpha(38),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: summary.isExpiringSoon
                                ? AppColors.warning.withAlpha(128)
                                : Colors.white.withAlpha(51),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          AppFormatters.formatDaysRemaining(summary.expiryDate),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: summary.isExpiringSoon
                                ? AppColors.warning
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataGauge extends StatefulWidget {
  const _DataGauge({
    required this.used,
    required this.total,
    required this.percentage,
  });

  final double used;
  final double total;
  final double percentage;

  @override
  State<_DataGauge> createState() => _DataGaugeState();
}

class _DataGaugeState extends State<_DataGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0, end: widget.percentage).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 110,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return CustomPaint(
            painter: _GaugePainter(progress: _animation.value),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(_animation.value * 100).toStringAsFixed(0)}%',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'used',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withAlpha(179),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const startAngle = math.pi * 0.7;
    const sweepAngle = math.pi * 1.6;

    // Background track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = Colors.white.withAlpha(38)
        ..strokeWidth = 10
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Progress arc
    final progressColor = progress > 0.8
        ? AppColors.error
        : (progress > 0.6 ? AppColors.warning : AppColors.teal);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * progress,
      false,
      Paint()
        ..color = progressColor
        ..strokeWidth = 10
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.teal),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '$label  ',
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withAlpha(153),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.success.withAlpha(51)
            : AppColors.error.withAlpha(51),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? AppColors.success.withAlpha(128)
              : AppColors.error.withAlpha(128),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.success : AppColors.error,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: AppTextStyles.caption.copyWith(
              color: isActive ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat(period: 2.seconds)).shimmer(
          duration: 2.seconds,
          color: Colors.white.withAlpha(26),
        );
  }
}
