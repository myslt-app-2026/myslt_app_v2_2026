import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';

class BillPaymentPage extends StatefulWidget {
  const BillPaymentPage({super.key});

  @override
  State<BillPaymentPage> createState() => _BillPaymentPageState();
}

class _BillPaymentPageState extends State<BillPaymentPage> {
  int _selectedMethod = 0;
  bool _isProcessing = false;

  static const _methods = [
    ('Visa / Mastercard', Icons.credit_card_rounded, Color(0xFF1A56DB)),
    ('Internet Banking', Icons.account_balance_rounded, Color(0xFF057A55)),
    ('Dialog eZ Cash', Icons.phone_android_rounded, Color(0xFFE74694)),
    ('mCash', Icons.account_balance_wallet_rounded, Color(0xFFD97706)),
  ];

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isProcessing = false);
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.md),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(36),
              ),
              child: Icon(Icons.check_rounded,
                  color: AppColors.success, size: 40),
            ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
            const SizedBox(height: AppSpacing.lg),
            Text('Payment Successful!', style: AppTextStyles.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppFormatters.formatLKR(MockData.currentBill.amount),
              style: AppTextStyles.amountLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Your bill has been paid successfully',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Done',
              onPressed: () {
                Navigator.of(ctx).pop();
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bill = MockData.currentBill;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Pay Bill', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount summary
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount Due',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withAlpha(179),
                        ),
                      ),
                      Text(
                        AppFormatters.formatLKR(bill.amount),
                        style: AppTextStyles.displaySmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Bill Period',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withAlpha(179),
                        ),
                      ),
                      Text(
                        bill.period,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2),
            const SizedBox(height: AppSpacing.xl),

            Text('Select Payment Method', style: AppTextStyles.titleMedium)
                .animate()
                .fadeIn(duration: 300.ms, delay: 100.ms),
            const SizedBox(height: AppSpacing.md),

            RadioGroup<int>(
              groupValue: _selectedMethod,
              onChanged: (v) {
                if (v != null) setState(() => _selectedMethod = v);
              },
              child: Column(
                children: _methods.asMap().entries.map((e) {
                  final index = e.key;
                  final (label, icon, color) = e.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                      border: Border.all(
                        color: _selectedMethod == index
                            ? AppColors.primary
                            : AppColors.borderLight,
                        width: _selectedMethod == index ? 2 : 1,
                      ),
                    ),
                    child: RadioListTile<int>(
                      value: index,
                      activeColor: AppColors.primary,
                      title: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: color.withAlpha(26),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(icon, color: color, size: 18),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Text(label, style: AppTextStyles.titleSmall),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(
                        duration: 300.ms,
                        delay: Duration(milliseconds: 150 + index * 60),
                      );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            AppButton(
              label: 'Pay ${AppFormatters.formatLKR(bill.amount)}',
              onPressed: _processPayment,
              isLoading: _isProcessing,
            ).animate().fadeIn(duration: 300.ms, delay: 400.ms),
            const SizedBox(height: AppSpacing.xl2),
          ],
        ),
      ),
    );
  }
}
