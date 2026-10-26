import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/providers/auth_state_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/validators.dart';

const String _googleSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
  <path fill="#4285F4" d="M22.56 12.25c0-.73-.06-1.42-.19-2.09H12v3.96h5.92a5.07 5.07 0 0 1-2.2 3.32v2.76h3.56c2.08-1.92 3.28-4.74 3.28-7.95z"/>
  <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.8l-3.56-2.76c-.98.66-2.24 1.06-3.72 1.06-2.87 0-5.3-1.94-6.17-4.54H2.15v2.85A11 11 0 0 0 12 23z"/>
  <path fill="#FBBC05" d="M5.83 13.96a6.6 6.6 0 0 1 0-3.92V7.19H2.15a11 11 0 0 0 0 9.62l3.68-2.85z"/>
  <path fill="#EA4335" d="M12 5.5c1.62 0 3.07.56 4.21 1.64l3.16-3.16A10.55 10.55 0 0 0 12 1a11 11 0 0 0-9.85 6.19l3.68 2.85C6.7 7.44 9.13 5.5 12 5.5z"/>
</svg>
''';

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
  bool _obscurePassword = true;

  static const Color _primaryBlue = Color(0xFF0864C4);
  static const Color _headingColor = Color(0xFF101522);
  static const Color _bodyColor = Color(0xFF475569);
  static const Color _mutedColor = Color(0xFF7B8496);
  static const Color _inputBorder = Color(0xFFE2E8F0);

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (ref.read(authNotifierProvider).isLoading) return;
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

    return Scaffold(
      backgroundColor: const Color(0xFFE4F2EF),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Stack(
                children: [
                  // Pale blue and mint lower background.
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xFFD8E6F4),
                            Color(0xFFEDF6F5),
                            Color(0xFFE4F2EF),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Dark teal, navy and royal-blue header.
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: ClipPath(
                      clipper: _LoginHeaderClipper(),
                      child: Container(
                        height: 360 + MediaQuery.of(context).padding.top,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF126B80),
                              Color(0xFF103F72),
                              Color(0xFF194DA9),
                            ],
                            stops: [0.0, 0.45, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SafeArea(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 480,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 24),
                              _buildHeader(),
                              const SizedBox(height: 44),

                              _buildLoginCard(
                                isLoading: authState.isLoading,
                                error: authState.error,
                              ),

                              const SizedBox(height: 46),
                              _buildSocialDivider(),
                              const SizedBox(height: 22),
                              _buildSocialButtons(),
                              const SizedBox(height: 32),
                              _buildRegisterLink(),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Keep your existing logo asset unchanged.
        Container(
          width: 76,
          height: 76,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x2520A6BF),
                blurRadius: 24,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/sltLogo.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'mySLT',
          style: AppTextStyles.headlineMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(30),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withAlpha(70),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00E676),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'YOUR SELF-CARE COMPANION',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard({
    required bool isLoading,
    required String? error,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFDFE),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: Colors.white),
        boxShadow: const [
          BoxShadow(
            color: Color(0x181E4A6A),
            blurRadius: 32,
            offset: Offset(0, 18),
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
              style: AppTextStyles.displayMedium.copyWith(
                color: _headingColor,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Sign in to access your details',
              style: AppTextStyles.bodyMedium.copyWith(
                color: _mutedColor,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),

            // Your existing backend authenticates using username.
            _buildInputField(
              label: 'Username',
              hint: 'NIC / Account Number',
              controller: _usernameController,
              focusNode: _usernameFocus,
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              label: 'Password',
              hint: 'Enter password',
              controller: _passwordController,
              focusNode: _passwordFocus,
              icon: Icons.lock_outline_rounded,
              isPassword: true,
            ),
            const SizedBox(height: 12),
            _buildRememberAndForgot(),
            const SizedBox(height: 12),

            if (error != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withAlpha(15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.error.withAlpha(60),
                  ),
                ),
                child: Semantics(
                  liveRegion: true,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.error,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          error,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],

            _buildSignInButton(isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    required IconData icon,
    bool isPassword = false,
  }) {
    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: color,
          width: width,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 13,
            color: _bodyColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: isPassword && _obscurePassword,
          keyboardType: TextInputType.text,
          textInputAction:
              isPassword ? TextInputAction.done : TextInputAction.next,
          autocorrect: false,
          enableSuggestions: !isPassword,
          validator: (value) => AppValidators.required(value, label),
          onFieldSubmitted: (_) {
            if (isPassword) {
              _handleLogin();
            } else {
              FocusScope.of(context).requestFocus(_passwordFocus);
            }
          },
          style: AppTextStyles.bodyMedium.copyWith(
            color: _headingColor,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF9BA6B5),
            ),
            prefixIcon: Icon(
              icon,
              color: const Color(0xFF98A5B5),
              size: 22,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    tooltip:
                        _obscurePassword ? 'Show password' : 'Hide password',
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFF98A5B5),
                      size: 20,
                    ),
                  )
                : null,
            filled: true,
            fillColor: const Color(0xFFF7FAFC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: border(_inputBorder),
            enabledBorder: border(_inputBorder),
            focusedBorder: border(_primaryBlue, 1.5),
            errorBorder: border(AppColors.error, 1.5),
            focusedErrorBorder: border(AppColors.error, 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberAndForgot() {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 28,
                height: 48,
                child: Checkbox(
                  value: _rememberMe,
                  activeColor: _primaryBlue,
                  checkColor: Colors.white,
                  side: const BorderSide(
                    color: Color(0xFFCFD6E0),
                    width: 1.4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Remember Me',
                style: AppTextStyles.bodySmall.copyWith(
                  color: _bodyColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () => context.push(AppRoutes.forgotPassword),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 2),
            ),
            child: Text(
              'Forgot Password?',
              style: AppTextStyles.bodySmall.copyWith(
                color: _primaryBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInButton(bool isLoading) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF00469E),
            Color(0xFF0862EB),
            Color(0xFF2863EC),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x553B8FEF),
            blurRadius: 18,
            offset: Offset(0, 9),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          elevation: 0,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                  semanticsLabel: 'Signing in',
                ),
              )
            : const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 22,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSocialDivider() {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Color(0xFFD1E1E4),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or continue with',
            style: AppTextStyles.bodySmall.copyWith(
              color: const Color(0xFF8C9EAD),
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: Color(0xFFD1E1E4),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildSocialButton(
            provider: 'Google',
            icon: SvgPicture.string(
              _googleSvg,
              width: 23,
              height: 23,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildSocialButton(
            provider: 'Facebook',
            icon: const Icon(
              Icons.facebook_rounded,
              color: Color(0xFF1877F2),
              size: 27,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildSocialButton(
            provider: 'Apple',
            icon: const Icon(
              Icons.apple,
              color: _headingColor,
              size: 27,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String provider,
    required Widget icon,
  }) {
    return Tooltip(
      message: 'Continue with $provider',
      child: Semantics(
        label: 'Continue with $provider',
        button: true,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x101B4D52),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _handleSocialLogin(provider),
              child: SizedBox(
                height: 48,
                child: Center(child: icon),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: AppTextStyles.bodySmall.copyWith(
            color: _mutedColor,
          ),
        ),
        TextButton(
          onPressed: () => context.push(AppRoutes.register),
          child: const Text(
            'Register',
            style: TextStyle(
              color: _primaryBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  void _handleSocialLogin(String provider) {
    // Same placeholder behavior as your existing page.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider sign-in coming in production!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _LoginHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height - 36)
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(_LoginHeaderClipper oldClipper) => false;
}
