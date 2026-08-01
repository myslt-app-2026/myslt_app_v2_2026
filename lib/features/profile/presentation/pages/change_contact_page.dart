import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class ChangeContactPage extends StatefulWidget {
  const ChangeContactPage({super.key});

  @override
  State<ChangeContactPage> createState() => _ChangeContactPageState();
}

class _ChangeContactPageState extends State<ChangeContactPage> {
  final _mobileCtrl = TextEditingController(text: '0771234567');
  final _emailCtrl = TextEditingController(text: 'kasun.perera@gmail.com');
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contact details updated successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
    context.pop();
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
        title: Text('Change Contact', style: AppTextStyles.titleMedium),
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
              const SizedBox(height: AppSpacing.lg),
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
                        'An OTP will be sent to verify your new contact details.',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.info),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                hint: '07X XXX XXXX',
                label: 'Mobile Number',
                controller: _mobileCtrl,
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: AppValidators.mobile,
              ).animate().fadeIn(duration: 300.ms, delay: 100.ms).slideY(begin: 0.2),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                hint: 'your@email.com',
                label: 'Email Address',
                controller: _emailCtrl,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: AppValidators.email,
              ).animate().fadeIn(duration: 300.ms, delay: 150.ms).slideY(begin: 0.2),
              const SizedBox(height: AppSpacing.xl3),
              AppButton(
                label: 'Save & Verify',
                onPressed: _handleSave,
                isLoading: _isLoading,
              ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
            ],
          ),
        ),
      ),
    );
  }
}
