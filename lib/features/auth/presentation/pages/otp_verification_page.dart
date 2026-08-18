import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/auth_state_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_button.dart';

/// OTP verification page with 6-digit pin input, countdown timer,
/// and shake animation on wrong OTP.
class OtpVerificationPage extends ConsumerStatefulWidget {
  const OtpVerificationPage({super.key, required this.phoneOrEmail});

  final String phoneOrEmail;

  @override
  ConsumerState<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  String _otp = '';
  int _secondsRemaining = 60;
  Timer? _timer;
  final StreamController<ErrorAnimationType> _errorController =
      StreamController<ErrorAnimationType>.broadcast();

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _timer?.cancel();
    _errorController.close();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    if (_otp.length < 6) return;
    final success =
        await ref.read(authNotifierProvider.notifier).verifyOtp(_otp);

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account verified successfully! Welcome to mySLT.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.go(AppRoutes.home);
    } else {
      _errorController.add(ErrorAnimationType.shake);
      _shakeController.forward().then((_) => _shakeController.reset());
      final err = ref.read(authNotifierProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err ?? 'OTP verification failed'),
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
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.xl),
            // SLT logo
            Image.asset(
              'assets/images/sltLogo.png',
              width: 64,
              height: 64,
              fit: BoxFit.contain,
            ).animate().fadeIn(duration: 400.ms).scale(
                  begin: const Offset(0.8, 0.8),
                  curve: Curves.elasticOut,
                ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.lock_open_rounded,
                size: 36,
                color: AppColors.primary,
              ),
            ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Verify OTP',
              style: AppTextStyles.headlineLarge,
            ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Enter the 6-digit code sent to',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 300.ms, delay: 150.ms),
            Text(
              widget.phoneOrEmail.isEmpty
                  ? '***** your registered number'
                  : widget.phoneOrEmail,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
            const SizedBox(height: AppSpacing.xl3),

            // PIN input
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                final offset = Curves.elasticIn.transform(_shakeAnimation.value);
                return Transform.translate(
                  offset: Offset(offset * 10 * (offset < 0.5 ? 1 : -1), 0),
                  child: child,
                );
              },
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                errorAnimationController: _errorController,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 56,
                  fieldWidth: 48,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.borderLight,
                  selectedColor: AppColors.accent,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: AppColors.primary.withAlpha(13),
                ),
                enableActiveFill: true,
                onChanged: (value) => setState(() => _otp = value),
                onCompleted: (value) {
                  setState(() => _otp = value);
                  _handleVerify();
                },
                textStyle: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 250.ms).slideY(begin: 0.3),
            const SizedBox(height: AppSpacing.xl),

            // Demo hint
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.infoLight,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadiusSm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, size: 16, color: AppColors.info),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Demo: use code 123456',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.info,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
            const SizedBox(height: AppSpacing.xl),

            AppButton(
              label: 'Verify',
              onPressed: _otp.length == 6 ? _handleVerify : null,
              isLoading: authState.isLoading,
              isDisabled: _otp.length < 6,
            ).animate().fadeIn(duration: 300.ms, delay: 350.ms),
            const SizedBox(height: AppSpacing.xl),

            // Resend timer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive the code? ",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (_secondsRemaining > 0)
                  Text(
                    'Resend in ${_secondsRemaining}s',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  )
                else
                  GestureDetector(
                    onTap: _startTimer,
                    child: Text(
                      'Resend',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ).animate().fadeIn(duration: 300.ms, delay: 400.ms),
          ],
        ),
      ),
    );
  }
}
