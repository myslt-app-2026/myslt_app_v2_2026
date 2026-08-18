import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/auth_state_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';

const String _googleSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24">
  <path fill="#EA4335" d="M5.266 9.765A7.077 7.077 0 0 1 12 4.909c1.69 0 3.218.6 4.418 1.582L19.91 3C17.782 1.145 15.055 0 12 0 7.27 0 3.198 2.698 1.24 6.65l4.026 3.115Z"/>
  <path fill="#34A853" d="M16.04 15.34c-1.07.69-2.47 1.1-4.04 1.1a7.09 7.09 0 0 1-6.733-4.855L1.226 14.7c1.933 3.88 5.972 6.55 10.774 6.55 2.927 0 5.618-.963 7.694-2.618l-3.655-3.29Z"/>
  <path fill="#4285F4" d="M22.5 12c0-.832-.073-1.636-.205-2.418H12v4.582h5.882c-.255 1.345-1.018 2.482-2.155 3.245l3.655 3.29C21.518 18.782 22.5 15.655 22.5 12Z"/>
  <path fill="#FBBC05" d="M5.267 11.585A7.063 7.063 0 0 1 5.267 9.76L1.24 6.645a11.968 11.968 0 0 0 0 8.055l4.027-3.115Z"/>
</svg>
''';

/// Modernized Login Page featuring a premium light theme layout, glassmorphic card,
/// glowing pastel ambient details, and smooth entrance animations.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _rememberMe = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final success = await ref.read(authNotifierProvider.notifier).login(
          _usernameController.text.trim(),
          _passwordController.text,
        );

    if (!mounted) return;
    if (success) {
      context.go(AppRoutes.home);
    } else {
      final error = ref.read(authNotifierProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Login failed'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Modern Light Grey-Blue
      body: Stack(
        children: [
          // ── Ambient Background Glows (Pastel Light Theme) ──
          Positioned(
            top: size.height * 0.05,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withAlpha(20),
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.2, 1.2), duration: 8.seconds, curve: Curves.easeInOut)
                .blur(begin: const Offset(50, 50), end: const Offset(70, 70)),
          ),
          Positioned(
            top: size.height * 0.35,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.teal.withAlpha(15),
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.3, 1.3), duration: 10.seconds, curve: Curves.easeInOut)
                .blur(begin: const Offset(60, 60), end: const Offset(80, 80)),
          ),

          // ── Scrollable Form Layout ──
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageHorizontal,
                vertical: AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: AppSpacing.xl),

                  // ── Logo Header ──
                  Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(26),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/images/sltLogo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'mySLT',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: const Color(0xFF0F172A),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ).animate().fadeIn(delay: 150.ms),
                      Text(
                        'Your Self-Care Companion',
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFF475569),
                          letterSpacing: 2,
                        ),
                      ).animate().fadeIn(delay: 250.ms),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl3),

                  // ── Glassmorphism Form Card ──
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(160),
                          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                          border: Border.all(
                            color: Colors.white.withAlpha(220),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome Back',
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: const Color(0xFF0F172A),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Sign in to access your details',
                                style: AppTextStyles.caption.copyWith(color: const Color(0xFF475569)),
                              ),
                              const SizedBox(height: AppSpacing.xl),

                              // Username Input Field
                              _buildInputField(
                                hint: 'NIC / Account Number',
                                label: 'Username',
                                controller: _usernameController,
                                focusNode: _usernameFocus,
                                nextFocusNode: _passwordFocus,
                                icon: Icons.person_outline_rounded,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (v) => AppValidators.required(v, 'Username'),
                              ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.1),
                              const SizedBox(height: AppSpacing.md),

                              // Password Input Field
                              _buildInputField(
                                hint: 'Enter password',
                                label: 'Password',
                                controller: _passwordController,
                                focusNode: _passwordFocus,
                                icon: Icons.lock_outline_rounded,
                                isPassword: true,
                                textInputAction: TextInputAction.done,
                                validator: (v) => AppValidators.required(v, 'Password'),
                                onFieldSubmitted: (_) => _handleLogin(),
                              ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.1),
                              const SizedBox(height: AppSpacing.md),

                              // Remember Me & Forgot Password
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Theme(
                                        data: ThemeData(
                                          unselectedWidgetColor: const Color(0xFF94A3B8),
                                        ),
                                        child: Checkbox(
                                          value: _rememberMe,
                                          activeColor: AppColors.primary,
                                          checkColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          onChanged: (v) =>
                                              setState(() => _rememberMe = v ?? false),
                                        ),
                                      ),
                                      Text(
                                        'Remember Me',
                                        style: AppTextStyles.caption.copyWith(color: const Color(0xFF475569)),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () => context.push(AppRoutes.forgotPassword),
                                    child: Text(
                                      'Forgot Password?',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ).animate().fadeIn(delay: 500.ms),
                              const SizedBox(height: AppSpacing.lg),

                              if (authState.error != null) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withAlpha(20),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.error.withAlpha(80)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          authState.error!,
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.error,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                              ],

                              // Submit Button
                              AppButton(
                                label: 'Sign In',
                                onPressed: _handleLogin,
                                isLoading: authState.isLoading,
                              ).animate().fadeIn(delay: 550.ms).scale(begin: const Offset(0.95, 0.95)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 0.1),
                  const SizedBox(height: AppSpacing.xl),

                  // ── Social Sign-in Header ──
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        child: Text(
                          'or continue with',
                          style: AppTextStyles.caption.copyWith(color: const Color(0xFF94A3B8)),
                        ),
                      ),
                      const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                    ],
                  ).animate().fadeIn(delay: 600.ms),
                  const SizedBox(height: AppSpacing.md),

                  // Social Sign-in Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildSocialButton(
                          label: 'Google',
                          iconWidget: SvgPicture.string(
                            _googleSvg,
                            width: 20,
                            height: 20,
                          ),
                          onTap: () => _handleSocialLogin('Google'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildSocialButton(
                          label: 'Facebook',
                          icon: Icons.facebook_rounded,
                          color: const Color(0xFF1877F2),
                          onTap: () => _handleSocialLogin('Facebook'),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 650.ms).slideY(begin: 0.1),
                  const SizedBox(height: AppSpacing.xl2),

                  // ── Registration Link ──
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF64748B)),
                        ),
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.register),
                          child: Text(
                            'Register',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 700.ms),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.done,
    String? Function(String?)? validator,
    void Function(String)? onFieldSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: const Color(0xFF475569),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: isPassword,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          onFieldSubmitted: (v) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else if (onFieldSubmitted != null) {
              onFieldSubmitted(v);
            }
          },
          style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF0F172A)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.black38),
            prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 20),
            filled: true,
            fillColor: Colors.white.withAlpha(200),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String label,
    IconData? icon,
    Color? color,
    Widget? iconWidget,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconWidget != null)
              iconWidget
            else if (icon != null)
              Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF475569),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSocialLogin(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider sign-in coming in production!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
