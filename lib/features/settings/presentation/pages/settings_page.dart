import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Settings', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          _SettingsSection(
            title: 'Appearance',
            children: [
              _SettingsTile(
                icon: Icons.dark_mode_outlined,
                label: 'Dark Mode',
                trailing: Switch(
                  value: settings.isDarkMode,
                  onChanged: (v) => ref.read(settingsProvider.notifier).toggleDarkMode(),
                  activeColor: AppColors.primary,
                ),
              ),
              _SettingsTile(
                icon: Icons.language_rounded,
                label: 'Language',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(settings.languageLabel, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
                  ],
                ),
                onTap: () => context.push(AppRoutes.language),
              ),
            ],
          ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
          const SizedBox(height: AppSpacing.lg),

          _SettingsSection(
            title: 'Notifications',
            children: [
              _SettingsTile(
                icon: Icons.notifications_outlined,
                label: 'Push Notifications',
                trailing: Switch(
                  value: settings.pushNotifications,
                  onChanged: (v) => ref.read(settingsProvider.notifier).togglePushNotifications(),
                  activeColor: AppColors.primary,
                ),
              ),
              _SettingsTile(
                icon: Icons.email_outlined,
                label: 'Email Alerts',
                trailing: Switch(
                  value: settings.emailAlerts,
                  onChanged: (v) => ref.read(settingsProvider.notifier).toggleEmailAlerts(),
                  activeColor: AppColors.primary,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
          const SizedBox(height: AppSpacing.lg),

          _SettingsSection(
            title: 'About',
            children: [
              _SettingsTile(
                icon: Icons.info_outline,
                label: 'App Version',
                trailing: Text('2.0.0 (Demo)', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              ),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                label: 'Privacy Policy',
                trailing: const Icon(Icons.open_in_new, size: 16, color: AppColors.textTertiary),
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.description_outlined,
                label: 'Terms of Service',
                trailing: const Icon(Icons.open_in_new, size: 16, color: AppColors.textTertiary),
                onTap: () {},
              ),
            ],
          ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.sm),
          child: Text(
            title.toUpperCase(),
            style: AppTextStyles.overline.copyWith(letterSpacing: 1.5),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: AppColors.dividerLight),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
            trailing,
          ],
        ),
      ),
    );
  }
}
