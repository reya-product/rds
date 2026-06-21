import 'package:flutter/material.dart';

/// RDS type scale.
///
/// All styles use the 'Inter' font family. The theme layer handles font loading
/// via `google_fonts`. At the token level we specify numeric values only.
///
/// Components apply color via the theme's semantic color tokens — not here.
abstract final class RdsTypography {
  // ---------------------------------------------------------------------------
  // Display
  // ---------------------------------------------------------------------------

  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 57,
    fontWeight: FontWeight.w400,
    height: 64 / 57,
    letterSpacing: -0.25,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 52 / 45,
    letterSpacing: 0,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 44 / 36,
    letterSpacing: 0,
  );

  // ---------------------------------------------------------------------------
  // Headline
  // ---------------------------------------------------------------------------

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    fontWeight: FontWeight.w400,
    height: 40 / 32,
    letterSpacing: 0,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 36 / 28,
    letterSpacing: 0,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 32 / 24,
    letterSpacing: 0,
  );

  // ---------------------------------------------------------------------------
  // Title
  // ---------------------------------------------------------------------------

  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 28 / 22,
    letterSpacing: 0,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
    letterSpacing: 0.15,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0.10,
  );

  // ---------------------------------------------------------------------------
  // Body
  // ---------------------------------------------------------------------------

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: 0.50,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0.25,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    letterSpacing: 0.40,
  );

  // ---------------------------------------------------------------------------
  // Label
  // ---------------------------------------------------------------------------

  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0.10,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0.50,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 16 / 11,
    letterSpacing: 0.50,
  );
}
