import 'package:flutter/material.dart';

/// SLT-Mobitel brand color palette.
/// Updated to match the new mySLT design (royal blue + navy header,
/// teal / cyan accents, lime highlight, white cards with soft shadows).
abstract final class AppColors {
  // ─── Primary Brand ────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1450E6); // buttons, links, active items
  static const Color primaryLight = Color(0xFF3B6FF0);
  static const Color primaryDark = Color(0xFF0E3CB5);
  static const Color navy = Color(0xFF083579); // deep header colour (new)
  static const Color primaryTint = Color(0xFFEFF6FF); // light blue chip/button bg (new)

  // ─── Accent ───────────────────────────────────────────────────────────────
  static const Color accent = Color(0xFF0266E0);
  static const Color accentLight = Color(0xFF4D9BF0);
  static const Color lime = Color(0xFFA2E639); // "MOBITEL" / Fibre Active dot (new)
  static const Color cyan = Color(0xFF27D2EE); // Extra GB bar (new)

  // ─── Teal (Secondary) ─────────────────────────────────────────────────────
  static const Color teal = Color(0xFF14B8A6);
  static const Color tealLight = Color(0xFF2DD4BF);
  static const Color tealDark = Color(0xFF0F9488);

  // ─── Gradient Stops ───────────────────────────────────────────────────────
  static const List<Color> brandGradient = [primary, accent, teal];
  static const List<Color> headerGradient = [Color(0xFF0266E0), navy];
  static const List<Color> cardGradient = [Color(0xFF0A6FD8), Color(0xFF14B8A6)];

  // ─── Semantic Colors ──────────────────────────────────────────────────────
  static const Color success = Color(0xFF14B981);
  static const Color successLight = Color(0xFFE6FAF3);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // ─── Light Theme Surfaces ─────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFFE8EDF5);
  static const Color borderLight = Color(0xFFE6ECF5);

  // ─── Dark Theme Surfaces ──────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF0D1117);
  static const Color surfaceDark = Color(0xFF161B22);
  static const Color cardDark = Color(0xFF1C2230);
  static const Color dividerDark = Color(0xFF30363D);
  static const Color borderDark = Color(0xFF21262D);

  // ─── Text Colors ──────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF2A3040);
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