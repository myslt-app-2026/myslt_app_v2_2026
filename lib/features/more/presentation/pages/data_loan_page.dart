import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

class DataLoanPage extends StatefulWidget {
  const DataLoanPage({super.key});

  @override
  State<DataLoanPage> createState() => _DataLoanPageState();
}

class _DataLoanPageState extends State<DataLoanPage> {
  bool _acceptedTerms = false;
  int _selectedLoanIndex = 0;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _loans = [
    {
      'title': 'Emergency 1GB',
      'amount': '1.0 GB',
      'price': 'Rs. 99.00',
      'repay': 'Rs. 99.00 will be deducted from your next recharge or added to your next bill.',
      'validity': 'Valid for 24 hours',
    },
    {
      'title': 'Weekend Boost 2GB',
      'amount': '2.0 GB',
      'price': 'Rs. 180.00',
      'repay': 'Rs. 180.00 will be deducted from your next recharge or added to your next bill.',
      'validity': 'Valid for 3 days',
    },
  ];

  Future<void> _handleLoan() async {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms & conditions first.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final selectedLoan = _loans[_selectedLoanIndex];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        title: Text('Confirm Data Loan', style: AppTextStyles.headlineSmall),
        content: Text(
          'Do you want to request a loan of ${selectedLoan['amount']} data?\n\nRepayment: ${selectedLoan['price']} will be billed to your account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${selectedLoan['amount']} Data Loan activated successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Data Loan', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            // Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_circle_rounded, color: AppColors.success, size: 28),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Loan Status', style: AppTextStyles.caption),
                        Text(
                          'Eligible for Loan',
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Maximum limit: 5.0 GB',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),
            const SizedBox(height: AppSpacing.xl),

            Text('Select Loan Package', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSpacing.md),

            // Packages list
            ..._loans.asMap().entries.map((entry) {
              final index = entry.key;
              final loan = entry.value;
              final isSelected = _selectedLoanIndex == index;

              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.borderLight,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(AppSpacing.md),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withAlpha(26) : AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.data_saver_on_rounded,
                      color: isSelected ? AppColors.primary : AppColors.textTertiary,
                    ),
                  ),
                  title: Text(loan['title'], style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text(loan['validity'], style: AppTextStyles.caption),
                      const SizedBox(height: 4),
                      Text(loan['repay'], style: AppTextStyles.bodySmall),
                    ],
                  ),
                  trailing: Text(
                    loan['price'],
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    setState(() => _selectedLoanIndex = index);
                  },
                ),
              ).animate().fadeIn(duration: 300.ms, delay: Duration(milliseconds: 100 + index * 100)).slideY(begin: 0.1);
            }),
            const SizedBox(height: AppSpacing.xl),

            // Terms Checkbox
            Row(
              children: [
                Checkbox(
                  value: _acceptedTerms,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() => _acceptedTerms = value ?? false);
                  },
                ),
                Expanded(
                  child: Text(
                    'I agree to repay the loan amount with the next billing cycle.',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 300.ms, delay: 250.ms),
            const SizedBox(height: AppSpacing.xl3),

            // Button
            AppButton(
              label: 'Request Loan',
              onPressed: _acceptedTerms ? _handleLoan : null,
              isLoading: _isLoading,
              isDisabled: !_acceptedTerms,
            ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
          ],
        ),
      ),
    );
  }
}
