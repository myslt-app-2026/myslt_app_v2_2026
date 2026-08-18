import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/auth_state_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Step 1 controllers
  final _nameCtrl = TextEditingController();
  final _nicCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();

  // Step 2 controllers
  final _emailCtrl = TextEditingController();
  final _accountCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();

  @override
  void dispose() {
    _pageController.dispose();
    _nameCtrl.dispose();
    _nicCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _accountCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (!_step1Key.currentState!.validate()) return;
    }
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      context.pop();
    }
  }

  Future<void> _handleSubmit() async {
    if (!_step2Key.currentState!.validate()) return;

    final success = await ref.read(authNotifierProvider.notifier).register(
          name: _nameCtrl.text.trim(),
          nic: _nicCtrl.text.trim(),
          mobile: _mobileCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          accountNumber: _accountCtrl.text.trim(),
          password: _passwordCtrl.text,
        );

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Please enter the OTP sent to your mobile.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pushReplacement(AppRoutes.otp, extra: _mobileCtrl.text.trim());
    } else {
      final err = ref.read(authNotifierProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err ?? 'Registration failed'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: _prevStep,
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
            Text(
              'Create Account',
              style: AppTextStyles.titleMedium,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: _buildStepIndicator(),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildStep1(),
          _buildStep2(authState),
          _buildStep3OtpPlaceholder(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Row(
        children: List.generate(3, (i) {
          final isActive = i <= _currentStep;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 4,
              margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Form(
        key: _step1Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text('Personal Information', style: AppTextStyles.headlineMedium)
                .animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: 0.2),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Step 1 of 3 — Enter your personal details',
              style: AppTextStyles.bodySmall,
            ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
            const SizedBox(height: AppSpacing.xl2),

            AppTextField(
              hint: 'Your full name',
              label: 'Full Name',
              controller: _nameCtrl,
              prefixIcon: Icons.person_outline_rounded,
              textCapitalization: TextCapitalization.words,
              validator: AppValidators.fullName,
            ).animate().fadeIn(duration: 300.ms, delay: 150.ms).slideY(begin: 0.2),
            const SizedBox(height: AppSpacing.lg),

            AppTextField(
              hint: 'e.g., 990123456V or 199901234567',
              label: 'NIC Number',
              controller: _nicCtrl,
              prefixIcon: Icons.credit_card_outlined,
              keyboardType: TextInputType.number,
              validator: AppValidators.nic,
            ).animate().fadeIn(duration: 300.ms, delay: 200.ms).slideY(begin: 0.2),
            const SizedBox(height: AppSpacing.lg),

            AppTextField(
              hint: '07X XXX XXXX',
              label: 'Mobile Number',
              controller: _mobileCtrl,
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: AppValidators.mobile,
            ).animate().fadeIn(duration: 300.ms, delay: 250.ms).slideY(begin: 0.2),
            const SizedBox(height: AppSpacing.xl3),

            AppButton(
              label: 'Continue',
              onPressed: _nextStep,
              icon: Icons.arrow_forward_rounded,
              iconPosition: IconPosition.right,
            ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2(AuthState authState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Form(
        key: _step2Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text('Account Details', style: AppTextStyles.headlineMedium)
                .animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: 0.2),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Step 2 of 3 — Link your SLT account',
              style: AppTextStyles.bodySmall,
            ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
            const SizedBox(height: AppSpacing.xl2),

            AppTextField(
              hint: 'your@email.com',
              label: 'Email Address',
              controller: _emailCtrl,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: AppValidators.email,
            ).animate().fadeIn(duration: 300.ms, delay: 150.ms).slideY(begin: 0.2),
            const SizedBox(height: AppSpacing.lg),

            AppTextField(
              hint: 'Your SLT account number',
              label: 'Account Number',
              controller: _accountCtrl,
              prefixIcon: Icons.tag_rounded,
              keyboardType: TextInputType.number,
              validator: AppValidators.accountNumber,
            ).animate().fadeIn(duration: 300.ms, delay: 200.ms).slideY(begin: 0.2),
            const SizedBox(height: AppSpacing.lg),

            AppTextField(
              hint: 'Create a strong password',
              label: 'Password',
              controller: _passwordCtrl,
              prefixIcon: Icons.lock_outline_rounded,
              isPassword: true,
              validator: AppValidators.password,
            ).animate().fadeIn(duration: 300.ms, delay: 250.ms).slideY(begin: 0.2),
            const SizedBox(height: AppSpacing.lg),

            AppTextField(
              hint: 'Repeat your password',
              label: 'Confirm Password',
              controller: _confirmPasswordCtrl,
              prefixIcon: Icons.lock_outline_rounded,
              isPassword: true,
              validator: (v) =>
                  AppValidators.confirmPassword(v, _passwordCtrl.text),
            ).animate().fadeIn(duration: 300.ms, delay: 300.ms).slideY(begin: 0.2),
            const SizedBox(height: AppSpacing.xl3),

            AppButton(
              label: 'Create Account',
              onPressed: _handleSubmit,
              isLoading: authState.isLoading,
            ).animate().fadeIn(duration: 300.ms, delay: 350.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildStep3OtpPlaceholder() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
