import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../tokens/rds_colors.dart';
import '../tokens/rds_motion.dart';
import '../tokens/rds_opacity.dart';
import '../tokens/rds_radius.dart';
import '../tokens/rds_spacing.dart';
import '../tokens/rds_typography.dart';
import 'rds_theme.dart';
import 'rds_theme_data.dart';

/// Pre-built light and dark [RdsTheme] instances.
///
/// Use [rdsThemeData] to get a [ThemeData] suitable for [MaterialApp.theme].
abstract final class RdsThemes {
  // ---------------------------------------------------------------------------
  // Light theme
  // ---------------------------------------------------------------------------

  static const RdsTheme light = RdsTheme(_reyaLightData);

  static const RdsThemeData _reyaLightData = RdsThemeData(
    // Colors — surfaces
    surface: RdsColors.surfaceLight,
    surfaceVariant: RdsColors.surfaceVariantLight,
    surfaceContainer: RdsColors.surfaceContainerLight,
    onSurface: RdsColors.onSurfaceLight,
    onSurfaceVariant: RdsColors.onSurfaceVariantLight,
    onSurfaceMuted: RdsColors.onSurfaceMutedLight,
    // Colors — primary
    primary: RdsColors.primaryLight,
    primaryContainer: RdsColors.primaryContainerLight,
    onPrimary: RdsColors.onPrimaryLight,
    onPrimaryContainer: RdsColors.onPrimaryContainerLight,
    // Colors — outline
    outline: RdsColors.outlineLight,
    outlineVariant: RdsColors.outlineVariantLight,
    scrim: RdsColors.scrimLight,
    // Colors — danger
    danger: RdsColors.dangerLight,
    dangerContainer: RdsColors.dangerContainerLight,
    onDanger: RdsColors.onDangerLight,
    onDangerContainer: RdsColors.onDangerContainerLight,
    // Colors — warning
    warning: RdsColors.warningLight,
    warningContainer: RdsColors.warningContainerLight,
    onWarning: RdsColors.onWarningLight,
    onWarningContainer: RdsColors.onWarningContainerLight,
    // Colors — success
    success: RdsColors.successLight,
    successContainer: RdsColors.successContainerLight,
    onSuccess: RdsColors.onSuccessLight,
    onSuccessContainer: RdsColors.onSuccessContainerLight,
    // Colors — neutral
    neutral: RdsColors.neutralLight,
    neutralContainer: RdsColors.neutralContainerLight,
    onNeutralContainer: RdsColors.onNeutralContainerLight,
    // Typography (same for both themes)
    displayLarge: RdsTypography.displayLarge,
    displayMedium: RdsTypography.displayMedium,
    displaySmall: RdsTypography.displaySmall,
    headlineLarge: RdsTypography.headlineLarge,
    headlineMedium: RdsTypography.headlineMedium,
    headlineSmall: RdsTypography.headlineSmall,
    titleLarge: RdsTypography.titleLarge,
    titleMedium: RdsTypography.titleMedium,
    titleSmall: RdsTypography.titleSmall,
    bodyLarge: RdsTypography.bodyLarge,
    bodyMedium: RdsTypography.bodyMedium,
    bodySmall: RdsTypography.bodySmall,
    labelLarge: RdsTypography.labelLarge,
    labelMedium: RdsTypography.labelMedium,
    labelSmall: RdsTypography.labelSmall,
    // Spacing (same for both themes)
    space0: RdsSpacing.space0,
    space1: RdsSpacing.space1,
    space2: RdsSpacing.space2,
    space3: RdsSpacing.space3,
    space4: RdsSpacing.space4,
    space5: RdsSpacing.space5,
    space6: RdsSpacing.space6,
    space8: RdsSpacing.space8,
    space10: RdsSpacing.space10,
    space12: RdsSpacing.space12,
    space16: RdsSpacing.space16,
    space20: RdsSpacing.space20,
    space24: RdsSpacing.space24,
    // Radius (same for both themes)
    radiusNone: RdsRadius.radiusNone,
    radiusXs: RdsRadius.radiusXs,
    radiusSm: RdsRadius.radiusSm,
    radiusMd: RdsRadius.radiusMd,
    radiusLg: RdsRadius.radiusLg,
    radiusXl: RdsRadius.radiusXl,
    radius2xl: RdsRadius.radius2xl,
    radiusFull: RdsRadius.radiusFull,
    // Motion (same for both themes)
    durationInstant: RdsMotion.durationInstant,
    durationFast: RdsMotion.durationFast,
    durationStandard: RdsMotion.durationStandard,
    durationEmphasized: RdsMotion.durationEmphasized,
    durationSlow: RdsMotion.durationSlow,
    curveStandard: RdsMotion.curveStandard,
    curveEmphasized: RdsMotion.curveEmphasized,
    // Opacity (same for both themes)
    opacityDisabled: RdsOpacity.disabled,
    opacityMedium: RdsOpacity.medium,
    stateHover: RdsOpacity.hover,
    stateFocus: RdsOpacity.focus,
    statePressed: RdsOpacity.pressed,
  );

  // ---------------------------------------------------------------------------
  // Dark theme
  // ---------------------------------------------------------------------------

  static const RdsTheme dark = RdsTheme(_reyaDarkData);

  /// Reya brand — light color tokens. Alias for [light].
  static const RdsTheme reyaLight = light;

  /// Reya brand — dark color tokens. Alias for [dark].
  static const RdsTheme reyaDark = dark;

  /// Love.Life brand — light color tokens.
  /// Color values are identical to Reya until Love.Life tokens are provided.
  static const RdsTheme loveDotLifeLight = light;

  /// Love.Life brand — dark color tokens.
  /// Color values are identical to Reya until Love.Life tokens are provided.
  static const RdsTheme loveDotLifeDark = dark;

  static const RdsThemeData _reyaDarkData = RdsThemeData(
    // Colors — surfaces
    surface: RdsColors.surfaceDark,
    surfaceVariant: RdsColors.surfaceVariantDark,
    surfaceContainer: RdsColors.surfaceContainerDark,
    onSurface: RdsColors.onSurfaceDark,
    onSurfaceVariant: RdsColors.onSurfaceVariantDark,
    onSurfaceMuted: RdsColors.onSurfaceMutedDark,
    // Colors — primary
    primary: RdsColors.primaryDark,
    primaryContainer: RdsColors.primaryContainerDark,
    onPrimary: RdsColors.onPrimaryDark,
    onPrimaryContainer: RdsColors.onPrimaryContainerDark,
    // Colors — outline
    outline: RdsColors.outlineDark,
    outlineVariant: RdsColors.outlineVariantDark,
    scrim: RdsColors.scrimDark,
    // Colors — danger
    danger: RdsColors.dangerDark,
    dangerContainer: RdsColors.dangerContainerDark,
    onDanger: RdsColors.onDangerDark,
    onDangerContainer: RdsColors.onDangerContainerDark,
    // Colors — warning
    warning: RdsColors.warningDark,
    warningContainer: RdsColors.warningContainerDark,
    onWarning: RdsColors.onWarningDark,
    onWarningContainer: RdsColors.onWarningContainerDark,
    // Colors — success
    success: RdsColors.successDark,
    successContainer: RdsColors.successContainerDark,
    onSuccess: RdsColors.onSuccessDark,
    onSuccessContainer: RdsColors.onSuccessContainerDark,
    // Colors — neutral
    neutral: RdsColors.neutralDark,
    neutralContainer: RdsColors.neutralContainerDark,
    onNeutralContainer: RdsColors.onNeutralContainerDark,
    // Typography (same as light)
    displayLarge: RdsTypography.displayLarge,
    displayMedium: RdsTypography.displayMedium,
    displaySmall: RdsTypography.displaySmall,
    headlineLarge: RdsTypography.headlineLarge,
    headlineMedium: RdsTypography.headlineMedium,
    headlineSmall: RdsTypography.headlineSmall,
    titleLarge: RdsTypography.titleLarge,
    titleMedium: RdsTypography.titleMedium,
    titleSmall: RdsTypography.titleSmall,
    bodyLarge: RdsTypography.bodyLarge,
    bodyMedium: RdsTypography.bodyMedium,
    bodySmall: RdsTypography.bodySmall,
    labelLarge: RdsTypography.labelLarge,
    labelMedium: RdsTypography.labelMedium,
    labelSmall: RdsTypography.labelSmall,
    // Spacing (same as light)
    space0: RdsSpacing.space0,
    space1: RdsSpacing.space1,
    space2: RdsSpacing.space2,
    space3: RdsSpacing.space3,
    space4: RdsSpacing.space4,
    space5: RdsSpacing.space5,
    space6: RdsSpacing.space6,
    space8: RdsSpacing.space8,
    space10: RdsSpacing.space10,
    space12: RdsSpacing.space12,
    space16: RdsSpacing.space16,
    space20: RdsSpacing.space20,
    space24: RdsSpacing.space24,
    // Radius (same as light)
    radiusNone: RdsRadius.radiusNone,
    radiusXs: RdsRadius.radiusXs,
    radiusSm: RdsRadius.radiusSm,
    radiusMd: RdsRadius.radiusMd,
    radiusLg: RdsRadius.radiusLg,
    radiusXl: RdsRadius.radiusXl,
    radius2xl: RdsRadius.radius2xl,
    radiusFull: RdsRadius.radiusFull,
    // Motion (same as light)
    durationInstant: RdsMotion.durationInstant,
    durationFast: RdsMotion.durationFast,
    durationStandard: RdsMotion.durationStandard,
    durationEmphasized: RdsMotion.durationEmphasized,
    durationSlow: RdsMotion.durationSlow,
    curveStandard: RdsMotion.curveStandard,
    curveEmphasized: RdsMotion.curveEmphasized,
    // Opacity (same as light)
    opacityDisabled: RdsOpacity.disabled,
    opacityMedium: RdsOpacity.medium,
    stateHover: RdsOpacity.hover,
    stateFocus: RdsOpacity.focus,
    statePressed: RdsOpacity.pressed,
  );
}

// ---------------------------------------------------------------------------
// Helper — build a Material ThemeData with RdsTheme extension attached
// ---------------------------------------------------------------------------

/// Returns a [ThemeData] configured for use with the given [rdsTheme].
///
/// Pass this to [MaterialApp.theme] or [MaterialApp.darkTheme].
///
/// ```dart
/// MaterialApp(
///   theme: rdsThemeData(brightness: Brightness.light, rdsTheme: RdsThemes.light),
///   darkTheme: rdsThemeData(brightness: Brightness.dark, rdsTheme: RdsThemes.dark),
/// )
/// ```
ThemeData rdsThemeData({
  required Brightness brightness,
  required RdsTheme rdsTheme,
  TextTheme Function(TextTheme)? applyFont,
}) {
  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: rdsTheme.primary,
    onPrimary: rdsTheme.onPrimary,
    primaryContainer: rdsTheme.primaryContainer,
    onPrimaryContainer: rdsTheme.onPrimaryContainer,
    secondary: rdsTheme.primary,
    onSecondary: rdsTheme.onPrimary,
    secondaryContainer: rdsTheme.primaryContainer,
    onSecondaryContainer: rdsTheme.onPrimaryContainer,
    tertiary: rdsTheme.neutral,
    onTertiary: rdsTheme.onNeutralContainer,
    tertiaryContainer: rdsTheme.neutralContainer,
    onTertiaryContainer: rdsTheme.onNeutralContainer,
    error: rdsTheme.danger,
    onError: rdsTheme.onDanger,
    errorContainer: rdsTheme.dangerContainer,
    onErrorContainer: rdsTheme.onDangerContainer,
    surface: rdsTheme.surface,
    onSurface: rdsTheme.onSurface,
    surfaceContainerHighest: rdsTheme.surfaceContainer,
    onSurfaceVariant: rdsTheme.onSurfaceVariant,
    outline: rdsTheme.outline,
    outlineVariant: rdsTheme.outlineVariant,
    scrim: rdsTheme.scrim,
  );

  final _fontApplier = applyFont ?? (t) => GoogleFonts.schibstedGroteskTextTheme(t);
  final baseTextTheme = _fontApplier(
    TextTheme(
      displayLarge: rdsTheme.displayLarge,
      displayMedium: rdsTheme.displayMedium,
      displaySmall: rdsTheme.displaySmall,
      headlineLarge: rdsTheme.headlineLarge,
      headlineMedium: rdsTheme.headlineMedium,
      headlineSmall: rdsTheme.headlineSmall,
      titleLarge: rdsTheme.titleLarge,
      titleMedium: rdsTheme.titleMedium,
      titleSmall: rdsTheme.titleSmall,
      bodyLarge: rdsTheme.bodyLarge,
      bodyMedium: rdsTheme.bodyMedium,
      bodySmall: rdsTheme.bodySmall,
      labelLarge: rdsTheme.labelLarge,
      labelMedium: rdsTheme.labelMedium,
      labelSmall: rdsTheme.labelSmall,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    textTheme: baseTextTheme.apply(
      bodyColor: rdsTheme.onSurface,
      displayColor: rdsTheme.onSurface,
    ),
    scaffoldBackgroundColor: rdsTheme.surfaceVariant,
    extensions: [rdsTheme],
  );
}
