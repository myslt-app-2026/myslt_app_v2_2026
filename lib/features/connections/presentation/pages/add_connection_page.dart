import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/mock/mock_data.dart';
import '../../data/models/connection_model.dart';
import '../../providers/connections_provider.dart';

enum _ConnectionTab { telephone, broadband }
enum _PaymentType { postPaid, prePaid }

class AddConnectionPage extends ConsumerStatefulWidget {
  const AddConnectionPage({super.key});

  @override
  ConsumerState<AddConnectionPage> createState() => _AddConnectionPageState();
}

class _AddConnectionPageState extends ConsumerState<AddConnectionPage> {
  int _step = 0; // 0 = details input, 1 = OTP verification
  _ConnectionTab _tab = _ConnectionTab.telephone;
  _PaymentType _paymentType = _PaymentType.postPaid;

  // Controllers
  final _phoneCtrl = TextEditingController();
  final _accountCtrl = TextEditingController();
  final _nicCtrl = TextEditingController();
  final _uidCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Track validation errors matching the HTML behavior
  String? _phoneError;
  String? _accountError;
  String? _nicError;
  String? _uidError;
  String? _pwdError;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _accountCtrl.dispose();
    _nicCtrl.dispose();
    _uidCtrl.dispose();
    _pwdCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  void _clearErrors() {
    setState(() {
      _phoneError = null;
      _accountError = null;
      _nicError = null;
      _uidError = null;
      _pwdError = null;
    });
  }

  bool _validateForm() {
    bool isValid = true;
    _clearErrors();

    if (_tab == _ConnectionTab.broadband) {
      final uid = _uidCtrl.text.trim();
      if (uid.length < 3) {
        _uidError = 'Enter your user ID.';
        isValid = false;
      }
      final pwd = _pwdCtrl.text;
      if (pwd.isEmpty) {
        _pwdError = 'Enter your password.';
        isValid = false;
      }
    } else {
      // Telephone tab
      final phone = _phoneCtrl.text.trim();
      if (!RegExp(r'^0\d{9}$').hasMatch(phone)) {
        _phoneError = 'Enter a 10-digit number starting with 0.';
        isValid = false;
      }

      if (_paymentType == _PaymentType.postPaid) {
        final acc = _accountCtrl.text.trim();
        if (!RegExp(r'^\d{6,12}$').hasMatch(acc)) {
          _accountError = 'Enter your SLT account number (digits only).';
          isValid = false;
        }
      }

      final nic = _nicCtrl.text.trim();
      if (!RegExp(r'^(\d{9}[VvXx]|\d{12})$').hasMatch(nic)) {
        _nicError = 'Enter a valid NIC, e.g. 199012345678.';
        isValid = false;
      }
    }

    setState(() {});
    return isValid;
  }

  Future<void> _handlePrimaryAction() async {
    if (_step == 0) {
      if (!_validateForm()) return;

      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (_tab == _ConnectionTab.broadband) {
        // Direct add for broadband
        _completeAddConnection(
          accountNumber: _uidCtrl.text.trim(),
          name: 'Broadband (${_uidCtrl.text.trim()})',
          type: ConnectionType.fiber,
          planName: 'SLT Fiber Broadband',
        );
      } else {
        // Transition to OTP step for Telephone
        setState(() => _step = 1);
      }
    } else {
      // Step 1: Verify OTP
      if (!_formKey.currentState!.validate()) return;

      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted) return;
      setState(() => _isLoading = false);

      final isPost = _paymentType == _PaymentType.postPaid;
      final accNumber = isPost ? _accountCtrl.text.trim() : _phoneCtrl.text.trim();
      final typeName = isPost ? 'Postpaid' : 'Prepaid';

      _completeAddConnection(
        accountNumber: accNumber,
        name: 'SLT $typeName (${_phoneCtrl.text.trim()})',
        type: ConnectionType.mobile,
        planName: 'SLT Voice $typeName',
      );
    }
  }

  void _completeAddConnection({
    required String accountNumber,
    required String name,
    required ConnectionType type,
    required String planName,
  }) {
    final newConn = ConnectionModel(
      id: 'conn_${DateTime.now().millisecondsSinceEpoch}',
      accountNumber: accountNumber,
      name: name,
      type: type,
      isActive: false,
      planName: planName,
    );

    // Add to MockData list
    MockData.connections.add(newConn);
    // Refresh Riverpod provider state
    ref.read(connectionsProvider.notifier).refresh();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connection added successfully!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    const navyColor = Color(0xFF0A2A80);
    const blueColor = Color(0xFF0A62C9);
    const cardBg = Colors.white;
    const scaffoldBg = Color(0xFFF4F6FB);
    const textInk = Color(0xFF0F172A);
    const textMute = Color(0xFF6B7280);
    const borderLine = Color(0xFFD9DEEA);
    const segBg = Color(0xFFE6EAF4);
    const errorColor = Color(0xFFD92D20);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: cardBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: navyColor, size: 20),
          onPressed: () {
            if (_step > 0) {
              setState(() => _step = 0);
            } else {
              context.pop();
            }
          },
        ),
        title: Text(
          'Add Connection',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: textInk,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: borderLine, height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: _step == 0
                ? _buildStep0Details(
                    navyColor: navyColor,
                    blueColor: blueColor,
                    cardBg: cardBg,
                    textInk: textInk,
                    textMute: textMute,
                    borderLine: borderLine,
                    segBg: segBg,
                    errorColor: errorColor,
                  )
                : _buildStep1Otp(
                    navyColor: navyColor,
                    blueColor: blueColor,
                    cardBg: cardBg,
                    textInk: textInk,
                    textMute: textMute,
                    borderLine: borderLine,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep0Details({
    required Color navyColor,
    required Color blueColor,
    required Color cardBg,
    required Color textInk,
    required Color textMute,
    required Color borderLine,
    required Color segBg,
    required Color errorColor,
  }) {
    final isBroadband = _tab == _ConnectionTab.broadband;
    final isPrePaid = _paymentType == _PaymentType.prePaid && !isBroadband;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Custom SVG-like link icon with plus (+)
        _buildHeaderIcon(navyColor),
        const SizedBox(height: 14),

        // Heading & Subtitle
        Text(
          'Add New Connection',
          style: GoogleFonts.poppins(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: textInk,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Enter your details to link an SLT account.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: textMute,
          ),
        ),
        const SizedBox(height: 22),

        // Segmented Control (Telephone / Broadband)
        Container(
          decoration: BoxDecoration(
            color: segBg,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _tab = _ConnectionTab.telephone;
                      _clearErrors();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: !isBroadband ? cardBg : Colors.transparent,
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: !isBroadband
                          ? [
                              BoxShadow(
                                color: navyColor.withValues(alpha: 0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      'Telephone',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: !isBroadband ? FontWeight.w600 : FontWeight.w500,
                        color: !isBroadband ? navyColor : textMute,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _tab = _ConnectionTab.broadband;
                      _clearErrors();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isBroadband ? cardBg : Colors.transparent,
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: isBroadband
                          ? [
                              BoxShadow(
                                color: navyColor.withValues(alpha: 0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      'Broadband',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: isBroadband ? FontWeight.w600 : FontWeight.w500,
                        color: isBroadband ? navyColor : textMute,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Type Pill Buttons (Post paid / Pre paid) - Only for Telephone
        if (!isBroadband) ...[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: navyColor, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _paymentType = _PaymentType.postPaid;
                      _clearErrors();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: _paymentType == _PaymentType.postPaid ? navyColor : cardBg,
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(999)),
                    ),
                    child: Text(
                      'Post paid',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _paymentType == _PaymentType.postPaid ? Colors.white : navyColor,
                      ),
                    ),
                  ),
                ),
                Container(width: 1.5, height: 32, color: navyColor),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _paymentType = _PaymentType.prePaid;
                      _clearErrors();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: _paymentType == _PaymentType.prePaid ? navyColor : cardBg,
                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(999)),
                    ),
                    child: Text(
                      'Pre paid',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _paymentType == _PaymentType.prePaid ? Colors.white : navyColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
        ],

        // Input Fields
        if (!isBroadband) ...[
          // Field 1: Telephone number
          _buildFieldBox(
            label: 'Telephone number',
            controller: _phoneCtrl,
            hint: 'Enter telephone number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            errorText: _phoneError,
            cardBg: cardBg,
            textInk: textInk,
            textMute: textMute,
            borderLine: borderLine,
            blueColor: blueColor,
            errorColor: errorColor,
          ),
          const SizedBox(height: 18),

          // Field 2: SLT account number (Hidden if Pre paid)
          if (!isPrePaid) ...[
            _buildFieldBox(
              label: 'SLT account number',
              controller: _accountCtrl,
              hint: 'Enter SLT account number',
              icon: Icons.tag_rounded,
              keyboardType: TextInputType.number,
              errorText: _accountError,
              cardBg: cardBg,
              textInk: textInk,
              textMute: textMute,
              borderLine: borderLine,
              blueColor: blueColor,
              errorColor: errorColor,
            ),
            const SizedBox(height: 18),
          ],

          // Field 3: National identity card number
          _buildFieldBox(
            label: 'National identity card number',
            controller: _nicCtrl,
            hint: 'Enter NIC number',
            icon: Icons.badge_outlined,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            maxLength: 12,
            errorText: _nicError,
            cardBg: cardBg,
            textInk: textInk,
            textMute: textMute,
            borderLine: borderLine,
            blueColor: blueColor,
            errorColor: errorColor,
          ),
          const SizedBox(height: 22),
        ] else ...[
          // Broadband Tab Fields
          // Field 1: User ID
          _buildFieldBox(
            label: 'User ID',
            controller: _uidCtrl,
            hint: 'Enter your user ID',
            icon: Icons.person_outline_rounded,
            keyboardType: TextInputType.text,
            errorText: _uidError,
            cardBg: cardBg,
            textInk: textInk,
            textMute: textMute,
            borderLine: borderLine,
            blueColor: blueColor,
            errorColor: errorColor,
          ),
          const SizedBox(height: 18),

          // Field 2: Password
          _buildFieldBox(
            label: 'Password',
            controller: _pwdCtrl,
            hint: 'Enter your password',
            icon: Icons.lock_outline_rounded,
            keyboardType: TextInputType.visiblePassword,
            isPassword: true,
            obscureText: _obscurePassword,
            onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
            errorText: _pwdError,
            cardBg: cardBg,
            textInk: textInk,
            textMute: textMute,
            borderLine: borderLine,
            blueColor: blueColor,
            errorColor: errorColor,
          ),
          const SizedBox(height: 22),
        ],

        // Submit Button (Send OTP or Add connection)
        _buildCtaButton(
          label: isBroadband ? 'Add Connection' : 'Send OTP',
          navyColor: navyColor,
          blueColor: blueColor,
          onTap: _handlePrimaryAction,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildStep1Otp({
    required Color navyColor,
    required Color blueColor,
    required Color cardBg,
    required Color textInk,
    required Color textMute,
    required Color borderLine,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Icon(Icons.mark_email_read_outlined, size: 42, color: navyColor),
        const SizedBox(height: 16),
        Text(
          'Verify OTP',
          style: GoogleFonts.poppins(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: textInk,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Enter the OTP sent to ${_phoneCtrl.text.trim().isNotEmpty ? _phoneCtrl.text.trim() : 'your number'}.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: textMute,
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'OTP Code',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textMute,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderLine),
          ),
          child: TextFormField(
            controller: _otpCtrl,
            keyboardType: TextInputType.number,
            maxLength: 6,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'OTP is required';
              if (v.trim().length != 6) return 'Enter the 6-digit OTP';
              return null;
            },
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 4,
              color: textInk,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: '• • • • • •',
              hintStyle: GoogleFonts.inter(
                fontSize: 18,
                letterSpacing: 4,
                color: textMute.withValues(alpha: 0.5),
              ),
              prefixIcon: Icon(Icons.pin_outlined, color: textMute, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
        ),

        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.infoLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, size: 16, color: AppColors.info),
              const SizedBox(width: 8),
              Text(
                'Demo: enter any 6 digits (e.g. 123456)',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        _buildCtaButton(
          label: 'Add Connection',
          navyColor: navyColor,
          blueColor: blueColor,
          onTap: _handlePrimaryAction,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildFieldBox({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color cardBg,
    required Color textInk,
    required Color textMute,
    required Color borderLine,
    required Color blueColor,
    required Color errorColor,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    int? maxLength,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
    String? errorText,
  }) {
    final hasError = errorText != null && errorText.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textMute,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasError ? errorColor : borderLine,
              width: hasError ? 1.5 : 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Icon(icon, color: hasError ? errorColor : textMute, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  textCapitalization: textCapitalization,
                  maxLength: maxLength,
                  obscureText: isPassword && obscureText,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: textInk,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    hintText: hint,
                    hintStyle: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: textMute.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
              if (isPassword && onTogglePassword != null)
                GestureDetector(
                  onTap: onTogglePassword,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Text(
                      obscureText ? 'Show' : 'Hide',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: blueColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 2),
            child: Text(
              errorText,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: errorColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCtaButton({
    required String label,
    required Color navyColor,
    required Color blueColor,
    required VoidCallback onTap,
    required bool isLoading,
  }) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [navyColor, blueColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: navyColor.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: isLoading ? null : onTap,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(Color navyColor) {
    // Custom chain link with plus icon matching the SVG:
    // <svg class="ico" viewBox="0 0 34 34" fill="none" stroke="currentColor" stroke-width="3.2" stroke-linecap="round">
    // <path d="M14 10H9a6 6 0 000 12h5M20 10h5a6 6 0 010 12h-1M11 16h10M27 20v8M23 24h8"/>
    // </svg>
    return SizedBox(
      width: 36,
      height: 36,
      child: CustomPaint(
        painter: _LinkPlusIconPainter(color: navyColor),
      ),
    );
  }
}

class _LinkPlusIconPainter extends CustomPainter {
  const _LinkPlusIconPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.2 * (size.width / 34.0)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final scale = size.width / 34.0;

    // Left link
    final leftPath = Path();
    leftPath.moveTo(14 * scale, 10 * scale);
    leftPath.lineTo(9 * scale, 10 * scale);
    leftPath.arcToPoint(
      Offset(9 * scale, 22 * scale),
      radius: Radius.circular(6 * scale),
      clockwise: false,
    );
    leftPath.lineTo(14 * scale, 22 * scale);
    canvas.drawPath(leftPath, paint);

    // Right link
    final rightPath = Path();
    rightPath.moveTo(20 * scale, 10 * scale);
    rightPath.lineTo(25 * scale, 10 * scale);
    rightPath.arcToPoint(
      Offset(24 * scale, 22 * scale),
      radius: Radius.circular(6 * scale),
      clockwise: true,
    );
    canvas.drawPath(rightPath, paint);

    // Center bar
    canvas.drawLine(
      Offset(11 * scale, 16 * scale),
      Offset(21 * scale, 16 * scale),
      paint,
    );

    // Plus (+) vertical & horizontal lines
    // M27 20v8
    canvas.drawLine(
      Offset(27 * scale, 20 * scale),
      Offset(27 * scale, 28 * scale),
      paint,
    );
    // M23 24h8
    canvas.drawLine(
      Offset(23 * scale, 24 * scale),
      Offset(31 * scale, 24 * scale),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _LinkPlusIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
