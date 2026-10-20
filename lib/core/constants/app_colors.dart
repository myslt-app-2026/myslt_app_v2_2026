import 'package:flutter/material.dart';

/// SLT-Mobitel brand color palette.
/// Updated to match the "Digital Life" reference design.
abstract final class AppColors {
  // ─── Primary Brand ────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF0650BB);
  static const Color primaryLight = Color(0xFF2265EA);
  static const Color primaryDark = Color(0xFF06357B);

  // ─── Accent (buttons: More Details, Pay) ──────────────────────────────────
  static const Color accent = Color(0xFF1050E6);
  static const Color accentLight = Color(0xFF3B73F0);

  // ─── Teal / Cyan (Secondary) ──────────────────────────────────────────────
  static const Color teal = Color(0xFF24D3F2);
  static const Color tealLight = Color(0xFF6BE3F7);
  static const Color tealDark = Color(0xFF009AE4);
  static const Color cyan = Color(0xFF24D3F2);

  // ─── Lime (Fibre Active dot, MOBITEL wordmark) ────────────────────────────
  static const Color lime = Color(0xFFA1E739);

  // ─── Gradient Stops ───────────────────────────────────────────────────────
  // NOTE: colors count must match any `stops:` used with these gradients.
  static const List<Color> brandGradient = [      // 3 colors
    Color(0xFF0370D7),
    Color(0xFF009AE4),
    Color(0xFF23B6AE),
  ];
  static const List<Color> headerGradient = [     // 2 colors
    Color(0xFF0650BB),
    Color(0xFF06357B),
  ];
  static const List<Color> cardGradient = [       // 2 colors
    Color(0xFF0370D7),
    Color(0xFF23B6AE),
  ];
  static const List<Color> buttonGradient = [     // 2 colors
    Color(0xFF1050E6),
    Color(0xFF1D4ED8),
  ];
  static const List<Color> loginBgGradient = [    // 4 colors (login page uses 4 stops)
    Color(0xFF0A5FD6),
    Color(0xFF1A73E8),
    Color(0xFF2E8CF0),
    Color(0xFF4FB3F5),
  ];

  // ─── Semantic Colors ──────────────────────────────────────────────────────
  static const Color success = Color(0xFF0FBB81);
  static const Color successLight = Color(0xFFEAFDF7);
  static const Color successText = Color(0xFF288266);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFDFAE9);
  static const Color warningText = Color(0xFFCA832B);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF2265EA);
  static const Color infoLight = Color(0xFFEDF8FC);
  static const Color softBlueTint = Color(0xFFEDF8FC);

  // ─── Icon / Tile Colors (SLT Go, Data Add-on, Storage, Kaspersky...) ──────
  static const Color tileBlue = Color(0xFF2265EA);
  static const Color tileGreen = Color(0xFF0FBB81);
  static const Color tileCyan = Color(0xFF24D3F2);
  static const Color tileIndigo = Color(0xFF5E86F7);
  static const Color tileSky = Color(0xFF33C8DC);
  static const Color tileDeepBlue = Color(0xFF1181D5);
  static const Color tileTeal = Color(0xFF11A585);

  // ─── Light Theme Surfaces ─────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFEEF1F5);
  static const Color navActiveBg = Color(0xFFEEF5FD);

  // ─── Dark Theme Surfaces ──────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF0D1117);
  static const Color surfaceDark = Color(0xFF161B22);
  static const Color cardDark = Color(0xFF1C2230);
  static const Color dividerDark = Color(0xFF30363D);
  static const Color borderDark = Color(0xFF21262D);

  // ─── Text Colors ──────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1F2636);
  static const Color textSecondary = Color(0xFF737A84);
  static const Color textTertiary = Color(0xFF9AA2AD);
  static const Color textDisabled = Color(0xFFAEB2B5);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textHeading = Color(0xFF233B69);
  static const Color textLink = Color(0xFF1F4EA8);
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