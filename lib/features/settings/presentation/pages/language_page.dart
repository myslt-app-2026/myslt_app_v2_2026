import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../providers/settings_provider.dart';

class LanguagePage extends ConsumerWidget {
  const LanguagePage({super.key});

  static const _languages = [
    ('en', 'English', '🇬🇧'),
    ('si', 'සිංහල (Sinhala)', '🇱🇰'),
    ('ta', 'தமிழ் (Tamil)', '🇱🇰'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Language', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(color: AppColors.dividerLight),
            ),
            child: RadioGroup<String>(
              groupValue: settings.languageCode,
              onChanged: (v) {
                if (v != null) {
                  ref.read(settingsProvider.notifier).setLanguage(v);
                  final selected = _languages.firstWhere((l) => l.$1 == v);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Language changed to ${selected.$2}'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              child: Column(
                children: _languages.map((lang) {
                  final (code, label, flag) = lang;
                  final isSelected = settings.languageCode == code;
                  return RadioListTile<String>(
                    value: code,
                    activeColor: AppColors.primary,
                    title: Row(
                      children: [
                        Text(flag, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: AppSpacing.md),
                        Text(
                          label,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.info, size: 18),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Sinhala and Tamil translations will be available in production.',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.info),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
