import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class GiftDataPage extends StatefulWidget {
  const GiftDataPage({super.key});

  @override
  State<GiftDataPage> createState() => _GiftDataPageState();
}

class _GiftDataPageState extends State<GiftDataPage> {
  final _formKey = GlobalKey<FormState>();
  final _mobileCtrl = TextEditingController();
  double _selectedAmountGB = 1.0;
  bool _isLoading = false;

  final List<double> _presetAmounts = [0.5, 1.0, 2.0, 5.0, 10.0];

  int get _pointsCost => (_selectedAmountGB * 400).round();

  @override
  void dispose() {
    _mobileCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleGift() async {
    if (!_formKey.currentState!.validate()) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        title: Text('Confirm Gift', style: AppTextStyles.headlineSmall),
        content: Text(
          'Are you sure you want to gift ${_selectedAmountGB >= 1.0 ? '${_selectedAmountGB.toStringAsFixed(0)} GB' : '${(_selectedAmountGB * 1024).toStringAsFixed(0)} MB'} data to ${_mobileCtrl.text}?\n\nCost: $_pointsCost Loyalty Points',
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
          content: Text('Successfully gifted data to ${_mobileCtrl.text}!'),
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
        title: Text('Gift Data', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 36),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Share Data with Friends & Family',
                      style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Send data packages immediately using your loyalty points.',
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withAlpha(204)),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: AppSpacing.xl),

              // Recipient Input
              Text('Recipient Details', style: AppTextStyles.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                hint: '07X XXX XXXX',
                label: 'SLT/Mobitel Number',
                controller: _mobileCtrl,
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: AppValidators.mobile,
              ).animate().fadeIn(duration: 300.ms, delay: 100.ms).slideY(begin: 0.1),
              const SizedBox(height: AppSpacing.xl),

              // Data Amount Selection
              Text('Select Data Amount', style: AppTextStyles.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _presetAmounts.map((amount) {
                  final isSelected = _selectedAmountGB == amount;
                  final label = amount >= 1.0 ? '${amount.toStringAsFixed(0)} GB' : '${(amount * 1024).toStringAsFixed(0)} MB';
                  return ChoiceChip(
                    label: Text(label),
                    selected: isSelected,
                    selectedColor: const Color(0xFF7C3AED).withAlpha(40),
                    checkmarkColor: const Color(0xFF7C3AED),
                    labelStyle: AppTextStyles.labelMedium.copyWith(
                      color: isSelected ? const Color(0xFF7C3AED) : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedAmountGB = amount);
                      }
                    },
                  );
                }).toList(),
              ).animate().fadeIn(duration: 300.ms, delay: 150.ms).slideY(begin: 0.1),
              const SizedBox(height: AppSpacing.lg),

              // Slider for custom selection
              Slider(
                value: _selectedAmountGB,
                min: 0.5,
                max: 10.0,
                divisions: 19,
                activeColor: const Color(0xFF7C3AED),
                inactiveColor: AppColors.borderLight,
                onChanged: (value) {
                  setState(() => _selectedAmountGB = value);
                },
              ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
              const SizedBox(height: AppSpacing.xl),

              // Cost Summary Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Loyalty Cost', style: AppTextStyles.caption),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.stars_rounded, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              '$_pointsCost pts',
                              style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Selected Data', style: AppTextStyles.caption),
                        const SizedBox(height: 2),
                        Text(
                          _selectedAmountGB >= 1.0 ? '${_selectedAmountGB.toStringAsFixed(1)} GB' : '${(_selectedAmountGB * 1024).toStringAsFixed(0)} MB',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: const Color(0xFF7C3AED),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 250.ms).slideY(begin: 0.1),
              const SizedBox(height: AppSpacing.xl3),

              // Action button
              AppButton(
                label: 'Gift Now',
                onPressed: _handleGift,
                isLoading: _isLoading,
                variant: AppButtonVariant.primary,
              ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
}
