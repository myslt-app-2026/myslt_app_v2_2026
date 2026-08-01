import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_router.dart';

class _QuickAction {
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.route,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String route;
}

/// 2×4 animated quick action grid for the home dashboard.
class QuickActionGrid extends StatelessWidget {
  QuickActionGrid({super.key});

  final List<_QuickAction> _actions = [
    _QuickAction(
      label: 'Pay Bill',
      icon: Icons.receipt_long_rounded,
      color: const Color(0xFF003087),
      bgColor: const Color(0xFFE8EFFA),
      route: AppRoutes.bill,
    ),
    _QuickAction(
      label: 'Data Usage',
      icon: Icons.bar_chart_rounded,
      color: const Color(0xFF0066CC),
      bgColor: const Color(0xFFE0EEFF),
      route: AppRoutes.usage,
    ),
    _QuickAction(
      label: 'Buy Package',
      icon: Icons.widgets_rounded,
      color: const Color(0xFF00AEEF),
      bgColor: const Color(0xFFE0F5FD),
      route: AppRoutes.packages,
    ),
    _QuickAction(
      label: 'PeoTV',
      icon: Icons.tv_rounded,
      color: const Color(0xFF7C3AED),
      bgColor: const Color(0xFFF3EEFF),
      route: AppRoutes.peotv,
    ),
    _QuickAction(
      label: 'Connections',
      icon: Icons.device_hub_rounded,
      color: const Color(0xFF059669),
      bgColor: const Color(0xFFD1FAE5),
      route: AppRoutes.connections,
    ),
    _QuickAction(
      label: 'Loyalty',
      icon: Icons.stars_rounded,
      color: const Color(0xFFD97706),
      bgColor: const Color(0xFFFEF3C7),
      route: AppRoutes.more,
    ),
    _QuickAction(
      label: 'Report',
      icon: Icons.report_problem_outlined,
      color: const Color(0xFFDC2626),
      bgColor: const Color(0xFFFEE2E2),
      route: AppRoutes.more,
    ),
    _QuickAction(
      label: 'More',
      icon: Icons.grid_view_rounded,
      color: const Color(0xFF6B7280),
      bgColor: const Color(0xFFF3F4F6),
      route: AppRoutes.more,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.xs,
        childAspectRatio: 0.85,
      ),
      itemCount: _actions.length,
      itemBuilder: (context, index) {
        final action = _actions[index];
        return _QuickActionTile(
          action: action,
          animationDelay: Duration(milliseconds: index * 60),
          onTap: () => context.go(action.route),
        );
      },
    );
  }
}

class _QuickActionTile extends StatefulWidget {
  const _QuickActionTile({
    required this.action,
    required this.animationDelay,
    required this.onTap,
  });

  final _QuickAction action;
  final Duration animationDelay;
  final VoidCallback onTap;

  @override
  State<_QuickActionTile> createState() => _QuickActionTileState();
}

class _QuickActionTileState extends State<_QuickActionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceCtrl;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.9,
      upperBound: 1.0,
    )..value = 1.0;
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _bounceCtrl.reverse(),
      onTapUp: (_) async {
        await _bounceCtrl.forward();
        widget.onTap();
      },
      onTapCancel: () => _bounceCtrl.forward(),
      child: ScaleTransition(
        scale: _bounceCtrl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: widget.action.bgColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: widget.action.color.withAlpha(38),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                widget.action.icon,
                color: widget.action.color,
                size: 24,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.action.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textPrimary,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ).animate(delay: widget.animationDelay)
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.7, 0.7), curve: Curves.elasticOut);
  }
}
