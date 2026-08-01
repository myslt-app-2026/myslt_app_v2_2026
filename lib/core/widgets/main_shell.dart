import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../router/app_router.dart';

/// The main shell widget providing the bottom navigation bar.
/// Wraps the shell route children for the tabbed navigation experience.
class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _SltBottomNav(),
    );
  }
}

class _SltBottomNav extends ConsumerStatefulWidget {
  @override
  ConsumerState<_SltBottomNav> createState() => _SltBottomNavState();
}

class _SltBottomNavState extends ConsumerState<_SltBottomNav> {
  int _currentIndex = 0;

  static const _tabs = [
    _NavTab(
      route: AppRoutes.home,
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavTab(
      route: AppRoutes.bill,
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long_rounded,
      label: 'Bill',
    ),
    _NavTab(
      route: AppRoutes.usage,
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart_rounded,
      label: 'Usage',
    ),
    _NavTab(
      route: AppRoutes.packages,
      icon: Icons.widgets_outlined,
      activeIcon: Icons.widgets_rounded,
      label: 'Packages',
    ),
    _NavTab(
      route: AppRoutes.more,
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view_rounded,
      label: 'More',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.dividerLight,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: _tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isActive = _currentIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _currentIndex = index);
                    context.go(tab.route);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary.withAlpha(20)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            isActive ? tab.activeIcon : tab.icon,
                            size: 22,
                            color: isActive
                                ? AppColors.primary
                                : (isDark
                                    ? AppColors.textDarkSecondary
                                    : AppColors.textTertiary),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tab.label,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isActive
                                ? AppColors.primary
                                : (isDark
                                    ? AppColors.textDarkSecondary
                                    : AppColors.textTertiary),
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavTab {
  const _NavTab({
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final String route;
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
