import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../providers/peotv_provider.dart';

/// Triggers Endpoint 36: Get PEO TV GO Streaming Access Token
/// - Displays a loading indicator while performing the network call
/// - Shows error message if the call fails
/// - Presents the token and launch options on success
Future<void> launchPeoTvGoTokenFlow(BuildContext context, WidgetRef ref) async {
  // 1. Show Loading Dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFF7C3AED)),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Connecting to PeoTV GO...',
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                'Fetching streaming access token',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  try {
    // 2. Call API (Endpoint 36)
    final tokenData = await ref.read(peoTVProvider.notifier).getPeoTvGoAccessToken();

    // Close Loading Dialog
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();

    if (!context.mounted) return;

    if (tokenData['accessToken'] != null && tokenData['accessToken'].toString().isNotEmpty) {
      // 3. Show Success & Launch/Login Flow Dialog
      _showPeoTvGoSuccessSheet(context, tokenData);
    } else {
      _showPeoTvGoErrorDialog(
        context,
        tokenData['message'] ?? 'Failed to acquire streaming token.',
      );
    }
  } catch (e) {
    // Close Loading Dialog
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();

    if (context.mounted) {
      _showPeoTvGoErrorDialog(
        context,
        'Unable to connect to PeoTV GO server: $e',
      );
    }
  }
}

void _showPeoTvGoSuccessSheet(BuildContext context, Map<String, dynamic> tokenData) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      final token = tokenData['accessToken']?.toString() ?? '';
      final channel = tokenData['channel']?.toString() ?? 'MYSLT_APP';
      final expiresIn = tokenData['expiresIn']?.toString() ?? '3600';
      final expiresAt = tokenData['expiresAt']?.toString() ?? '';

      return Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED).withAlpha(26),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.play_circle_fill_rounded,
                    color: Color(0xFF7C3AED),
                    size: 32,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PeoTV GO Streaming Token',
                        style: AppTextStyles.titleMedium,
                      ),
                      Text(
                        'Authorized for subscriber ${tokenData['subscriberId'] ?? '0312241780'}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'CONNECTED',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EEFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD8B4FE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STREAMING ACCESS TOKEN',
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFF6B21A8),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SelectableText(
                    token,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF581C87),
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _infoItem('Channel', channel),
                ),
                Expanded(
                  child: _infoItem('Expires In', '$expiresIn sec (1 Hr)'),
                ),
              ],
            ),
            if (expiresAt.isNotEmpty) ...[
              const SizedBox(height: 8),
              _infoItem('Valid Until', expiresAt),
            ],
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Launch PeoTV GO Web Player',
              icon: Icons.open_in_new_rounded,
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Launching PeoTV GO with authorized token...'),
                    backgroundColor: Color(0xFF7C3AED),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      );
    },
  );
}

Widget _infoItem(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: AppTextStyles.caption),
      const SizedBox(height: 2),
      Text(
        value,
        style: AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    ],
  );
}

void _showPeoTvGoErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.error),
          const SizedBox(width: 8),
          const Text('Connection Failed'),
        ],
      ),
      content: Text(
        errorMessage,
        style: AppTextStyles.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
