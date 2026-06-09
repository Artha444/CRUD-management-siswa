import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors (Academic Atelier)
  static const Color primary = Color(0xFF004AC6);
  static const Color primaryContainer = Color(0xFF2563EB);
  static const Color primaryFixed = Color(0xFFDBE1FF);
  
  static const Color secondary = Color(0xFF495C95);
  static const Color secondaryContainer = Color(0xFFACBFFF);
  static const Color onSecondaryContainer = Color(0xFF394C84);
  
  static const Color surface = Color(0xFFFAF8FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF3F3FE);
  static const Color surfaceContainer = Color(0xFFEDEDF9);
  static const Color surfaceContainerHigh = Color(0xFFE7E7F3);
  static const Color surfaceContainerHighest = Color(0xFFE1E2ED);
  
  static const Color onSurface = Color(0xFF191B23);
  static const Color onSurfaceVariant = Color(0xFF434655);
  static const Color outlineVariant = Color(0xFFC3C6D7);
  static const Color outline = Color(0xFF737686);
  
  static const Color tertiary = Color(0xFF943700);
  static const Color tertiaryFixed = Color(0xFFFFDBCD);
  static const Color onTertiaryFixed = Color(0xFF360F00);
  static const Color onTertiaryFixedVariant = Color(0xFF7D2D00);
  
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryFixedVariant = Color(0xFF003EA8);

  // Text Styles
  static TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.manrope(
      color: onSurface,
      fontSize: 48,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
    ),
    headlineMedium: GoogleFonts.manrope(
      color: onSurface,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
    ),
    headlineSmall: GoogleFonts.manrope(
      color: onSurface,
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
    titleLarge: GoogleFonts.manrope(
      color: onSurface,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: GoogleFonts.inter(
      color: onSurface,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: GoogleFonts.inter(
      color: onSurface,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: GoogleFonts.inter(
      color: onSurface,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
    labelMedium: GoogleFonts.inter(
      color: onSurface,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
    labelSmall: GoogleFonts.inter(
      color: onSurface,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primary,
        primaryContainer: primaryContainer,
        secondary: secondary,
        secondaryContainer: secondaryContainer,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        tertiary: tertiary,
        error: error,
        errorContainer: errorContainer,
      ),
      scaffoldBackgroundColor: surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: primary),
      ),
    );
  }
}
