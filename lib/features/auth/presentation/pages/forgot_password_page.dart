import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  int _step = 0;
  final _emailCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _otpCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (_step < 2) _step++;
    });
    if (_step == 2) {
      // Password reset done — go to login
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successful! Please login.'),
          backgroundColor: AppColors.success,
        ),
      );
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => _step > 0
              ? setState(() => _step--)
              : context.pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/sltLogo.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text('Forgot Password', style: AppTextStyles.titleMedium),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              _buildStepContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.email_outlined, size: 48, color: AppColors.primary)
                .animate()
                .scale(duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: AppSpacing.xl),
            Text('Forgot Password?', style: AppTextStyles.headlineLarge)
                .animate()
                .fadeIn(delay: 100.ms),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Enter your registered email and we\'ll send you a reset code.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: AppSpacing.xl2),
            AppTextField(
              hint: 'your@email.com',
              label: 'Email Address',
              controller: _emailCtrl,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: AppValidators.email,
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
            const SizedBox(height: AppSpacing.xl2),
            AppButton(
              label: 'Send Reset Code',
              onPressed: _next,
              isLoading: _isLoading,
            ).animate().fadeIn(delay: 250.ms),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.sms_outlined, size: 48, color: AppColors.primary)
                .animate()
                .scale(duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: AppSpacing.xl),
            Text('Enter OTP', style: AppTextStyles.headlineLarge)
                .animate()
                .fadeIn(delay: 100.ms),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'A 6-digit code was sent to ${_emailCtrl.text}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: AppSpacing.xl2),
            AppTextField(
              hint: 'Enter 6-digit OTP',
              label: 'OTP Code',
              controller: _otpCtrl,
              prefixIcon: Icons.pin_outlined,
              keyboardType: TextInputType.number,
              maxLength: 6,
              validator: AppValidators.otp,
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
            const SizedBox(height: AppSpacing.xl2),
            AppButton(
              label: 'Verify OTP',
              onPressed: _next,
              isLoading: _isLoading,
            ).animate().fadeIn(delay: 250.ms),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lock_outline_rounded,
                    size: 48, color: AppColors.primary)
                .animate()
                .scale(duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: AppSpacing.xl),
            Text('New Password', style: AppTextStyles.headlineLarge)
                .animate()
                .fadeIn(delay: 100.ms),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Create a strong new password for your account.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: AppSpacing.xl2),
            AppTextField(
              hint: 'Enter new password',
              label: 'New Password',
              controller: _pwCtrl,
              prefixIcon: Icons.lock_outline_rounded,
              isPassword: true,
              validator: AppValidators.password,
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
            const SizedBox(height: AppSpacing.xl2),
            AppButton(
              label: 'Reset Password',
              onPressed: _next,
              isLoading: _isLoading,
            ).animate().fadeIn(delay: 250.ms),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
