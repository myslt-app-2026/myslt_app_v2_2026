import 'package:flutter/material.dart';

/// SLT-Mobitel brand color palette.
/// All colors defined as per the official mySLT brand guidelines.
abstract final class AppColors {
  // ─── Primary Brand ────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF0052CC); // Vibrant Cobalt Blue
  static const Color primaryLight = Color(0xFF0066FF); // Electric Blue
  static const Color primaryDark = Color(0xFF083B82); // Deep Royal Navy Blue

  // ─── Accent & Cyan ────────────────────────────────────────────────────────
  static const Color accent = Color(0xFF009BEB); // Sky Cyan Blue
  static const Color accentLight = Color(0xFF38BDF8);
  static const Color cyan = Color(0xFF00BCD4); // Quick actions cyan

  // ─── Teal (Secondary) ─────────────────────────────────────────────────────
  static const Color teal = Color(0xFF00D2B4);
  static const Color tealLight = Color(0xFF33E0C8);
  static const Color tealDark = Color(0xFF0095CC);

  // ─── Brand Green & Badges ─────────────────────────────────────────────────
  static const Color brandGreen = Color(0xFF00C853); // Active glowing green indicator

  // ─── Gradient Stops ───────────────────────────────────────────────────────
  static const List<Color> brandGradient = [primary, accent, teal];
  static const List<Color> headerGradient = [Color(0xFF083B82), Color(0xFF0052CC)];
  static const List<Color> cardGradient = [Color(0xFF00A2F3), Color(0xFF0052CC)];
  static const List<Color> buttonGradient = [
    Color(0xFF0A4FBA),
    Color(0xFF1E6DEB),
  ];
  static const List<Color> loginBgGradient = [
    Color(0xFF06576F),
    Color(0xFF0A3D7C),
    Color(0xFFE2F1F3),
    Color(0xFFEEF7F7),
  ];

  // ─── Semantic Colors ──────────────────────────────────────────────────────
  static const Color success = Color(0xFF00A859); // "Normal" status text
  static const Color successLight = Color(0xFFE8F8F0); // "Normal" status badge background
  static const Color warning = Color(0xFFD97706); // Amber text
  static const Color warningLight = Color(0xFFFEF3C7); // "Due in 5 days" badge background
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // ─── Light Theme Surfaces ─────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF6F9FC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color softBlueTint = Color(0xFFEEF5FF); // "Package Upgrade" button tint
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFD1D5DB);

  // ─── Dark Theme Surfaces ──────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF0D1117);
  static const Color surfaceDark = Color(0xFF161B22);
  static const Color cardDark = Color(0xFF1C2230);
  static const Color dividerDark = Color(0xFF30363D);
  static const Color borderDark = Color(0xFF21262D);

  // ─── Text Colors ──────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textDarkPrimary = Color(0xFFF9FAFB);
  static const Color textDarkSecondary = Color(0xFF9CA3AF);

  // ─── Shimmer ──────────────────────────────────────────────────────────────
  static const Color shimmerBase = Color(0xFFE5E7EB);
  static const Color shimmerHighlight = Color(0xFFF9FAFB);
  static const Color shimmerBaseDark = Color(0xFF21262D);
  static const Color shimmerHighlightDark = Color(0xFF30363D);

  // ─── Glass Effect ─────────────────────────────────────────────────────────
  static const Color glassLight = Color(0x1AFFFFFF);
  static const Color glassDark = Color(0x1A000000);
  static const Color glassBorderLight = Color(0x33FFFFFF);
  static const Color glassBorderDark = Color(0x1AFFFFFF);
}
