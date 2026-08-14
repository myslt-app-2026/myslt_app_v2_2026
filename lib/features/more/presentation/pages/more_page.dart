import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_router.dart';

class _MoreItem {
  const _MoreItem({required this.label, required this.icon, required this.color, required this.route});
  final String label;
  final IconData icon;
  final Color color;
  final String route;
}

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  static const _items = [
    _MoreItem(label: 'Loyalty Points', icon: Icons.stars_rounded, color: Color(0xFFD97706), route: AppRoutes.loyaltyPoints),
    _MoreItem(label: 'Redeem Data', icon: Icons.redeem_rounded, color: Color(0xFF059669), route: AppRoutes.redeemData),
    _MoreItem(label: 'Gift Data', icon: Icons.card_giftcard_rounded, color: Color(0xFF7C3AED), route: AppRoutes.giftData),
    _MoreItem(label: 'Data Loan', icon: Icons.account_balance_rounded, color: Color(0xFF0066CC), route: AppRoutes.dataLoan),
    _MoreItem(label: 'Happy Day', icon: Icons.sentiment_very_satisfied_rounded, color: Color(0xFFF59E0B), route: AppRoutes.happyDay),
    _MoreItem(label: 'PeoTV', icon: Icons.tv_rounded, color: Color(0xFF003087), route: AppRoutes.peotv),
    _MoreItem(label: 'Report Fault', icon: Icons.report_problem_outlined, color: Color(0xFFDC2626), route: AppRoutes.reportFault),
    _MoreItem(label: 'IDD Services', icon: Icons.public_rounded, color: Color(0xFF6B7280), route: AppRoutes.iddServices),
    _MoreItem(label: 'Location Svcs', icon: Icons.location_on_rounded, color: Color(0xFF10B981), route: AppRoutes.locationServices),
    _MoreItem(label: 'Profile', icon: Icons.person_rounded, color: Color(0xFF003087), route: AppRoutes.profile),
    _MoreItem(label: 'Connections', icon: Icons.device_hub_rounded, color: Color(0xFF0066CC), route: AppRoutes.connections),
    _MoreItem(label: 'Settings', icon: Icons.settings_rounded, color: Color(0xFF6B7280), route: AppRoutes.settings),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primary,
            title: Text(
              'More',
              style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = _items[index];
                  return _MoreTile(item: item, index: index);
                },
                childCount: _items.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.95,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl4)),
        ],
      ),
    );
  }
}

class _MoreTile extends StatefulWidget {
  const _MoreTile({required this.item, required this.index});

  final _MoreItem item;
  final int index;

  @override
  State<_MoreTile> createState() => _MoreTileState();
}

class _MoreTileState extends State<_MoreTile> with SingleTickerProviderStateMixin {
  late AnimationController _bounceCtrl;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.92,
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
        if (context.mounted) context.push(widget.item.route);
      },
      onTapCancel: () => _bounceCtrl.forward(),
      child: ScaleTransition(
        scale: _bounceCtrl,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: widget.item.color.withAlpha(26),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(widget.item.icon, color: widget.item.color, size: 24),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                widget.item.label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: widget.index * 40))
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack);
  }
}
