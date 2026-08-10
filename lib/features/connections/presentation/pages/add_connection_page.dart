import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class AddConnectionPage extends StatefulWidget {
  const AddConnectionPage({super.key});

  @override
  State<AddConnectionPage> createState() => _AddConnectionPageState();
}

class _AddConnectionPageState extends State<AddConnectionPage> {
  int _step = 0;
  final _accountCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _accountCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (_step == 0) {
      setState(() => _step = 1);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connection added successfully!'),
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
          onPressed: () => _step > 0 ? setState(() => _step = 0) : context.pop(),
        ),
        title: Text('Add Connection', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Form(
          key: _formKey,
          child: _step == 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xl),
                    Icon(Icons.add_link_rounded, size: 48, color: AppColors.primary),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Add New Connection', style: AppTextStyles.headlineMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Enter your SLT account number to link it.',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xl2),
                    AppTextField(
                      hint: 'Your SLT account number',
                      label: 'Account Number',
                      controller: _accountCtrl,
                      prefixIcon: Icons.tag_rounded,
                      keyboardType: TextInputType.number,
                      validator: AppValidators.accountNumber,
                    ),
                    const SizedBox(height: AppSpacing.xl2),
                    AppButton(label: 'Send OTP', onPressed: _next, isLoading: _isLoading),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xl),
                    Icon(Icons.verified_outlined, size: 48, color: AppColors.primary),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Verify OTP', style: AppTextStyles.headlineMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Enter the OTP sent to your registered number.',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xl2),
                    AppTextField(
                      hint: '6-digit OTP',
                      label: 'OTP Code',
                      controller: _otpCtrl,
                      prefixIcon: Icons.pin_outlined,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      validator: AppValidators.otp,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: AppSpacing.sm),
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: AppColors.infoLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('Demo: use 123456', style: AppTextStyles.caption.copyWith(color: AppColors.info)),
                    ),
                    const SizedBox(height: AppSpacing.xl2),
                    AppButton(label: 'Add Connection', onPressed: _next, isLoading: _isLoading),
                  ],
                ),
        ),
      ),
    );
  }
}
