import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';

class ServiceSection extends StatelessWidget {
  const ServiceSection({super.key});

  static const _services = [
    ('All Services', Icons.apps_rounded, AppColors.primary),
    ('Internet', Icons.wifi_rounded, Color(0xFF0066CC)),
    ('Voice', Icons.call_rounded, Color(0xFF059669)),
    ('Mobile', Icons.smartphone_rounded, Color(0xFF7C3AED)),
    ('TV', Icons.tv_rounded, Color(0xFFD97706)),
    ('Business', Icons.business_rounded, Color(0xFF6B7280)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Services', style: AppTextStyles.titleMedium),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _services.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final (label, icon, color) = _services[index];
              final isFirst = index == 0;
              return _ServiceChip(
                label: label,
                icon: icon,
                color: color,
                isSelected: isFirst,
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Service cards
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.6,
          children: const [
            _ServiceCard(
              title: 'Fiber Broadband',
              subtitle: 'Up to 200 Mbps',
              icon: Icons.router_rounded,
              color: AppColors.primary,
            ),
            _ServiceCard(
              title: 'Mobitel 4G',
              subtitle: 'Nationwide coverage',
              icon: Icons.signal_cellular_alt_rounded,
              color: AppColors.teal,
            ),
            _ServiceCard(
              title: 'PeoTV GO',
              subtitle: '200+ channels',
              icon: Icons.play_circle_rounded,
              color: Color(0xFF7C3AED),
            ),
            _ServiceCard(
              title: 'Digital Life',
              subtitle: 'Smart services',
              icon: Icons.devices_rounded,
              color: Color(0xFFD97706),
            ),
          ],
        ),
      ],
    );
  }
}

class _ServiceChip extends StatelessWidget {
  const _ServiceChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isSelected ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isSelected ? color : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
