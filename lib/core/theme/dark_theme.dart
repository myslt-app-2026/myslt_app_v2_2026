import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// Dark theme for the mySLT application.
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  ).copyWith(
    primary: AppColors.teal,
    onPrimary: Colors.black,
    primaryContainer: AppColors.primaryDark,
    secondary: AppColors.accent,
    onSecondary: Colors.white,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.textDarkPrimary,
    surfaceContainerHighest: AppColors.backgroundDark,
    error: AppColors.error,
    onError: Colors.white,
    outline: AppColors.borderDark,
    outlineVariant: AppColors.dividerDark,
  ),
  scaffoldBackgroundColor: AppColors.backgroundDark,
  textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
    displayLarge: GoogleFonts.poppins(
      fontWeight: FontWeight.w700,
      color: AppColors.textDarkPrimary,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontWeight: FontWeight.w600,
      color: AppColors.textDarkPrimary,
    ),
    titleLarge: GoogleFonts.poppins(
      fontWeight: FontWeight.w600,
      color: AppColors.textDarkPrimary,
    ),
    bodyLarge: GoogleFonts.inter(color: AppColors.textDarkPrimary),
    bodyMedium: GoogleFonts.inter(color: AppColors.textDarkPrimary),
    bodySmall: GoogleFonts.inter(color: AppColors.textDarkSecondary),
    labelMedium: GoogleFonts.inter(color: AppColors.textDarkSecondary),
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
    ),
    color: AppColors.cardDark,
    surfaceTintColor: Colors.transparent,
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    centerTitle: false,
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.textDarkPrimary,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textDarkPrimary,
    ),
    iconTheme: const IconThemeData(color: AppColors.textDarkPrimary),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.teal,
      foregroundColor: Colors.black,
      minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      ),
      elevation: 0,
      textStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.cardDark,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.lg,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
      borderSide: BorderSide(color: AppColors.borderDark, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
      borderSide: BorderSide(color: AppColors.borderDark, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
      borderSide: BorderSide(color: AppColors.teal, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
      borderSide: BorderSide(color: AppColors.error, width: 1),
    ),
    hintStyle: GoogleFonts.inter(
      color: AppColors.textDarkSecondary,
      fontSize: 14,
    ),
    labelStyle: GoogleFonts.inter(
      color: AppColors.textDarkSecondary,
      fontSize: 14,
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.dividerDark,
    thickness: 1,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected)
          ? AppColors.teal
          : AppColors.textDarkSecondary,
    ),
    trackColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected)
          ? AppColors.teal.withAlpha(77)
          : AppColors.borderDark,
    ),
  ),
);
