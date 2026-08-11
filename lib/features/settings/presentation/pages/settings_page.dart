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
