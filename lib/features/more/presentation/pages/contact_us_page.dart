import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  static const Color _bgSoftBlue = Color(0xFFDFEBF6);
  static const Color _iconColor = Color(0xFF5A6E85);
  static const Color _textDark = Color(0xFF0F172A);

  Future<void> _callNumber(BuildContext context, String number) async {
    final uri = Uri.parse('tel:$number');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else if (context.mounted) {
        await _copyToClipboard(context, number, 'Phone number');
      }
    } catch (_) {
      if (context.mounted) {
        await _copyToClipboard(context, number, 'Phone number');
      }
    }
  }

  Future<void> _sendEmail(BuildContext context, String email) async {
    final uri = Uri.parse('mailto:$email?subject=SLT Customer Inquiry');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else if (context.mounted) {
        await _copyToClipboard(context, email, 'Email address');
      }
    } catch (_) {
      if (context.mounted) {
        await _copyToClipboard(context, email, 'Email address');
      }
    }
  }

  Future<void> _copyToClipboard(
    BuildContext context,
    String text,
    String label,
  ) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$label ($text) copied to clipboard'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBg = isDark ? const Color(0xFF0B1324) : _bgSoftBlue;
    final textColor = isDark ? Colors.white : _textDark;
    final iconColor = isDark ? const Color(0xFF94A3B8) : _iconColor;

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: pageBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: isDark ? Colors.white : AppColors.primary,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Contact Us',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item 1: Phone with sound waves -> 1212
                _buildContactRow(
                  context: context,
                  icon: SizedBox(
                    width: 58,
                    height: 58,
                    child: CustomPaint(
                      painter: _PhoneWavesPainter(color: iconColor),
                    ),
                  ),
                  label: '1212',
                  isUnderlined: true,
                  fontSize: 26,
                  textColor: textColor,
                  hint: 'SLT 24/7 Hotline',
                  onTap: () => _callNumber(context, '1212'),
                  onLongPress: () => _copyToClipboard(context, '1212', 'Hotline'),
                ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1),

                const SizedBox(height: 52),

                // Item 2: Envelope with @ -> 1212@slt.com.lk
                _buildContactRow(
                  context: context,
                  icon: SizedBox(
                    width: 58,
                    height: 52,
                    child: CustomPaint(
                      painter: _MailAtPainter(
                        color: iconColor,
                        bgColor: pageBg,
                      ),
                    ),
                  ),
                  label: '1212@slt.com.lk',
                  isUnderlined: false,
                  fontSize: 22,
                  textColor: textColor,
                  hint: 'Email Support',
                  onTap: () => _sendEmail(context, '1212@slt.com.lk'),
                  onLongPress: () =>
                      _copyToClipboard(context, '1212@slt.com.lk', 'Email'),
                ).animate().fadeIn(delay: 100.ms, duration: 350.ms).slideY(begin: 0.1),

                const SizedBox(height: 52),

                // Item 3: Support Agent Headset -> 0112121212
                _buildContactRow(
                  context: context,
                  icon: SizedBox(
                    width: 58,
                    height: 56,
                    child: CustomPaint(
                      painter: _SupportAgentPainter(color: iconColor),
                    ),
                  ),
                  label: '0112121212',
                  isUnderlined: true,
                  fontSize: 26,
                  textColor: textColor,
                  hint: 'Direct Line / Landline',
                  onTap: () => _callNumber(context, '0112121212'),
                  onLongPress: () =>
                      _copyToClipboard(context, '0112121212', 'Direct Line'),
                ).animate().fadeIn(delay: 200.ms, duration: 350.ms).slideY(begin: 0.1),

                const SizedBox(height: 64),

                // Quick Helper Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF162035)
                        : Colors.white.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF26334D)
                          : const Color(0xFFC7D9EC),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.touch_app_rounded,
                        color: isDark ? const Color(0xFF38BDF8) : AppColors.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tap any number to call or email to send inquiry. Long-press to copy.',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF475569),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 350.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow({
    required BuildContext context,
    required Widget icon,
    required String label,
    required bool isUnderlined,
    required double fontSize,
    required Color textColor,
    required String hint,
    required VoidCallback onTap,
    required VoidCallback onLongPress,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        decoration: isUnderlined
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        decorationColor: textColor,
                        decorationThickness: 1.8,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      hint,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textColor.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: textColor.withValues(alpha: 0.25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Custom Icon Painters ─────────────────────────────────────────────────────

/// Telephone receiver with 2 sound waves in outline style.
class _PhoneWavesPainter extends CustomPainter {
  const _PhoneWavesPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // Handset receiver body
    final path = Path();
    path.moveTo(w * 0.16, h * 0.36);
    path.lineTo(w * 0.28, h * 0.24);
    path.cubicTo(w * 0.35, h * 0.18, w * 0.44, h * 0.23, w * 0.46, h * 0.32);
    path.lineTo(w * 0.41, h * 0.43);
    path.cubicTo(w * 0.46, h * 0.56, w * 0.56, h * 0.66, w * 0.69, h * 0.71);
    path.lineTo(w * 0.80, h * 0.66);
    path.cubicTo(w * 0.89, h * 0.68, w * 0.94, h * 0.77, w * 0.88, h * 0.84);
    path.lineTo(w * 0.76, h * 0.96);
    path.cubicTo(w * 0.60, h * 1.00, w * 0.38, h * 0.86, w * 0.22, h * 0.70);
    path.cubicTo(w * 0.06, h * 0.54, w * 0.02, h * 0.36, w * 0.16, h * 0.36);
    path.close();
    canvas.drawPath(path, paint);

    // Inner wave
    final wave1 = Path();
    wave1.addArc(
      Rect.fromCircle(center: Offset(w * 0.38, h * 0.38), radius: w * 0.28),
      -1.35,
      0.85,
    );
    canvas.drawPath(wave1, paint);

    // Outer wave
    final wave2 = Path();
    wave2.addArc(
      Rect.fromCircle(center: Offset(w * 0.38, h * 0.38), radius: w * 0.42),
      -1.35,
      0.85,
    );
    canvas.drawPath(wave2, paint);
  }

  @override
  bool shouldRepaint(covariant _PhoneWavesPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Envelope with '@' badge outline.
class _MailAtPainter extends CustomPainter {
  const _MailAtPainter({required this.color, required this.bgColor});
  final Color color;
  final Color bgColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // Envelope main body
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.06, h * 0.24, w * 0.88, h * 0.68),
      const Radius.circular(6),
    );
    canvas.drawRRect(rect, paint);

    // Lower folds meeting at bottom
    canvas.drawLine(
      Offset(w * 0.08, h * 0.90),
      Offset(w * 0.40, h * 0.58),
      paint,
    );
    canvas.drawLine(
      Offset(w * 0.92, h * 0.90),
      Offset(w * 0.60, h * 0.58),
      paint,
    );

    // Flap lines folding down
    final flap = Path();
    flap.moveTo(w * 0.08, h * 0.26);
    flap.lineTo(w * 0.50, h * 0.64);
    flap.lineTo(w * 0.92, h * 0.26);
    canvas.drawPath(flap, paint);

    // Upward paper/badge with @ symbol
    final badgeRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.50, h * 0.26),
        width: w * 0.40,
        height: h * 0.44,
      ),
      const Radius.circular(5),
    );
    // Fill badge with background to mask overlap
    canvas.drawRRect(
      badgeRect,
      Paint()
        ..color = bgColor
        ..style = PaintingStyle.fill,
    );
    canvas.drawRRect(badgeRect, paint);

    // Draw @ text inside badge
    final textPainter = TextPainter(
      text: TextSpan(
        text: '@',
        style: TextStyle(
          color: color,
          fontSize: h * 0.26,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(
        w * 0.50 - textPainter.width / 2,
        h * 0.26 - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _MailAtPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.bgColor != bgColor;
}

/// Headset agent/robot icon with microphone.
class _SupportAgentPainter extends CustomPainter {
  const _SupportAgentPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Head / bubble path
    final headRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.10, h * 0.14, w * 0.76, h * 0.58),
      const Radius.circular(10),
    );

    final bubblePath = Path();
    bubblePath.addRRect(headRect);
    // Speech bubble tail at bottom left
    bubblePath.moveTo(w * 0.22, h * 0.72);
    bubblePath.lineTo(w * 0.14, h * 0.92);
    bubblePath.lineTo(w * 0.38, h * 0.72);
    canvas.drawPath(bubblePath, paint);

    // Two eyes (rounded dots)
    canvas.drawCircle(Offset(w * 0.32, h * 0.34), 2.5, fillPaint);
    canvas.drawCircle(Offset(w * 0.64, h * 0.34), 2.5, fillPaint);

    // Friendly smile
    final smilePath = Path();
    smilePath.addArc(
      Rect.fromCenter(
        center: Offset(w * 0.48, h * 0.46),
        width: w * 0.22,
        height: h * 0.16,
      ),
      0.1,
      2.9,
    );
    canvas.drawPath(smilePath, paint);

    // Headset boom with circular microphone
    final micPath = Path();
    micPath.moveTo(w * 0.86, h * 0.44);
    micPath.cubicTo(
      w * 0.88,
      h * 0.82,
      w * 0.66,
      h * 0.90,
      w * 0.52,
      h * 0.88,
    );
    canvas.drawPath(micPath, paint);
    canvas.drawCircle(Offset(w * 0.46, h * 0.88), 4.5, paint);
  }

  @override
  bool shouldRepaint(covariant _SupportAgentPainter oldDelegate) =>
      oldDelegate.color != color;
}
