import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'rds_theme.dart';
import 'rds_themes.dart';

// ---------------------------------------------------------------------------
// RdsBrandTheme — pairs color tokens with a typeface
// ---------------------------------------------------------------------------

/// A named brand theme: color palette (light + dark) + typeface.
///
/// Two brands are pre-defined: [RdsBrandThemes.reya] and
/// [RdsBrandThemes.ihl].  The [buildThemeData] helper returns a
/// [ThemeData] ready for [MaterialApp.theme] or Widgetbook's [ThemeAddon].
class RdsBrandTheme {
  const RdsBrandTheme({
    required this.name,
    required this.light,
    required this.dark,
    required this.applyFont,
  });

  /// Human-readable brand name shown in Widgetbook.
  final String name;

  /// Color tokens for light mode.
  final RdsTheme light;

  /// Color tokens for dark mode.
  final RdsTheme dark;

  /// Applies the brand typeface to a base [TextTheme].
  ///
  /// Receives the RDS-scaled text theme and returns a new [TextTheme] with the
  /// brand font applied (e.g. via `GoogleFonts.*TextTheme`).
  final TextTheme Function(TextTheme) applyFont;

  /// Builds a [ThemeData] for [brightness] using this brand's colors + font.
  ThemeData buildThemeData(Brightness brightness) => rdsThemeData(
        brightness: brightness,
        rdsTheme: brightness == Brightness.light ? light : dark,
        applyFont: applyFont,
      );
}

// ---------------------------------------------------------------------------
// RdsBrandThemes — pre-defined brand instances
// ---------------------------------------------------------------------------

abstract final class RdsBrandThemes {
  // ---- Reya — Schibsted Grotesk -------------------------------------------

  static final reya = RdsBrandTheme(
    name: 'Reya',
    light: RdsThemes.reyaLight,
    dark: RdsThemes.reyaDark,
    applyFont: (t) => GoogleFonts.schibstedGroteskTextTheme(t),
  );

  // ---- IHL — Karelia -------------------------------------------------------

  static final ihl = RdsBrandTheme(
    name: 'IHL',
    light: RdsThemes.ihlLight,
    dark: RdsThemes.ihlDark,
    applyFont: (t) => t.apply(fontFamily: 'Karelia'),
  );
}
