import 'package:flutter/material.dart';

/// Plain data class holding all RDS semantic token fields.
///
/// Construct the light and dark instances in [RdsThemes].
/// Components access values through [RdsTheme] (the ThemeExtension wrapper).
@immutable
class RdsThemeData {
  // ---------------------------------------------------------------------------
  // Colors — surfaces
  // ---------------------------------------------------------------------------

  final Color surface;
  final Color surfaceVariant;
  final Color surfaceContainer;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color onSurfaceMuted;

  // ---------------------------------------------------------------------------
  // Colors — primary
  // ---------------------------------------------------------------------------

  final Color primary;
  final Color primaryContainer;
  final Color onPrimary;
  final Color onPrimaryContainer;

  // ---------------------------------------------------------------------------
  // Colors — outline
  // ---------------------------------------------------------------------------

  final Color outline;
  final Color outlineVariant;
  final Color scrim;

  // ---------------------------------------------------------------------------
  // Colors — danger
  // ---------------------------------------------------------------------------

  final Color danger;
  final Color dangerContainer;
  final Color onDanger;
  final Color onDangerContainer;

  // ---------------------------------------------------------------------------
  // Colors — warning
  // ---------------------------------------------------------------------------

  final Color warning;
  final Color warningContainer;
  final Color onWarning;
  final Color onWarningContainer;

  // ---------------------------------------------------------------------------
  // Colors — success
  // ---------------------------------------------------------------------------

  final Color success;
  final Color successContainer;
  final Color onSuccess;
  final Color onSuccessContainer;

  // ---------------------------------------------------------------------------
  // Colors — neutral
  // ---------------------------------------------------------------------------

  final Color neutral;
  final Color neutralContainer;
  final Color onNeutralContainer;

  // ---------------------------------------------------------------------------
  // Typography
  // ---------------------------------------------------------------------------

  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  // ---------------------------------------------------------------------------
  // Spacing
  // ---------------------------------------------------------------------------

  final double space0;
  final double space1;
  final double space2;
  final double space3;
  final double space4;
  final double space5;
  final double space6;
  final double space8;
  final double space10;
  final double space12;
  final double space16;
  final double space20;
  final double space24;

  // ---------------------------------------------------------------------------
  // Radius
  // ---------------------------------------------------------------------------

  final double radiusNone;
  final double radiusXs;
  final double radiusSm;
  final double radiusMd;
  final double radiusLg;
  final double radiusXl;
  final double radius2xl;
  final double radiusFull;

  // ---------------------------------------------------------------------------
  // Motion
  // ---------------------------------------------------------------------------

  final Duration durationInstant;
  final Duration durationFast;
  final Duration durationStandard;
  final Duration durationEmphasized;
  final Duration durationSlow;
  final Curve curveStandard;
  final Curve curveEmphasized;

  // ---------------------------------------------------------------------------
  // Opacity / state layers
  // ---------------------------------------------------------------------------

  final double opacityDisabled;
  final double opacityMedium;
  final double stateHover;
  final double stateFocus;
  final double statePressed;

  // ---------------------------------------------------------------------------
  // Constructor
  // ---------------------------------------------------------------------------

  const RdsThemeData({
    // Colors — surfaces
    required this.surface,
    required this.surfaceVariant,
    required this.surfaceContainer,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.onSurfaceMuted,
    // Colors — primary
    required this.primary,
    required this.primaryContainer,
    required this.onPrimary,
    required this.onPrimaryContainer,
    // Colors — outline
    required this.outline,
    required this.outlineVariant,
    required this.scrim,
    // Colors — danger
    required this.danger,
    required this.dangerContainer,
    required this.onDanger,
    required this.onDangerContainer,
    // Colors — warning
    required this.warning,
    required this.warningContainer,
    required this.onWarning,
    required this.onWarningContainer,
    // Colors — success
    required this.success,
    required this.successContainer,
    required this.onSuccess,
    required this.onSuccessContainer,
    // Colors — neutral
    required this.neutral,
    required this.neutralContainer,
    required this.onNeutralContainer,
    // Typography
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    // Spacing
    required this.space0,
    required this.space1,
    required this.space2,
    required this.space3,
    required this.space4,
    required this.space5,
    required this.space6,
    required this.space8,
    required this.space10,
    required this.space12,
    required this.space16,
    required this.space20,
    required this.space24,
    // Radius
    required this.radiusNone,
    required this.radiusXs,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusXl,
    required this.radius2xl,
    required this.radiusFull,
    // Motion
    required this.durationInstant,
    required this.durationFast,
    required this.durationStandard,
    required this.durationEmphasized,
    required this.durationSlow,
    required this.curveStandard,
    required this.curveEmphasized,
    // Opacity
    required this.opacityDisabled,
    required this.opacityMedium,
    required this.stateHover,
    required this.stateFocus,
    required this.statePressed,
  });

  // ---------------------------------------------------------------------------
  // copyWith
  // ---------------------------------------------------------------------------

  RdsThemeData copyWith({
    // Colors — surfaces
    Color? surface,
    Color? surfaceVariant,
    Color? surfaceContainer,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? onSurfaceMuted,
    // Colors — primary
    Color? primary,
    Color? primaryContainer,
    Color? onPrimary,
    Color? onPrimaryContainer,
    // Colors — outline
    Color? outline,
    Color? outlineVariant,
    Color? scrim,
    // Colors — danger
    Color? danger,
    Color? dangerContainer,
    Color? onDanger,
    Color? onDangerContainer,
    // Colors — warning
    Color? warning,
    Color? warningContainer,
    Color? onWarning,
    Color? onWarningContainer,
    // Colors — success
    Color? success,
    Color? successContainer,
    Color? onSuccess,
    Color? onSuccessContainer,
    // Colors — neutral
    Color? neutral,
    Color? neutralContainer,
    Color? onNeutralContainer,
    // Typography
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
    // Spacing
    double? space0,
    double? space1,
    double? space2,
    double? space3,
    double? space4,
    double? space5,
    double? space6,
    double? space8,
    double? space10,
    double? space12,
    double? space16,
    double? space20,
    double? space24,
    // Radius
    double? radiusNone,
    double? radiusXs,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    double? radiusXl,
    double? radius2xl,
    double? radiusFull,
    // Motion
    Duration? durationInstant,
    Duration? durationFast,
    Duration? durationStandard,
    Duration? durationEmphasized,
    Duration? durationSlow,
    Curve? curveStandard,
    Curve? curveEmphasized,
    // Opacity
    double? opacityDisabled,
    double? opacityMedium,
    double? stateHover,
    double? stateFocus,
    double? statePressed,
  }) {
    return RdsThemeData(
      // Colors — surfaces
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      onSurfaceMuted: onSurfaceMuted ?? this.onSurfaceMuted,
      // Colors — primary
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimary: onPrimary ?? this.onPrimary,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      // Colors — outline
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      scrim: scrim ?? this.scrim,
      // Colors — danger
      danger: danger ?? this.danger,
      dangerContainer: dangerContainer ?? this.dangerContainer,
      onDanger: onDanger ?? this.onDanger,
      onDangerContainer: onDangerContainer ?? this.onDangerContainer,
      // Colors — warning
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarning: onWarning ?? this.onWarning,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      // Colors — success
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      onSuccess: onSuccess ?? this.onSuccess,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      // Colors — neutral
      neutral: neutral ?? this.neutral,
      neutralContainer: neutralContainer ?? this.neutralContainer,
      onNeutralContainer: onNeutralContainer ?? this.onNeutralContainer,
      // Typography
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      displaySmall: displaySmall ?? this.displaySmall,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
      // Spacing
      space0: space0 ?? this.space0,
      space1: space1 ?? this.space1,
      space2: space2 ?? this.space2,
      space3: space3 ?? this.space3,
      space4: space4 ?? this.space4,
      space5: space5 ?? this.space5,
      space6: space6 ?? this.space6,
      space8: space8 ?? this.space8,
      space10: space10 ?? this.space10,
      space12: space12 ?? this.space12,
      space16: space16 ?? this.space16,
      space20: space20 ?? this.space20,
      space24: space24 ?? this.space24,
      // Radius
      radiusNone: radiusNone ?? this.radiusNone,
      radiusXs: radiusXs ?? this.radiusXs,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusLg: radiusLg ?? this.radiusLg,
      radiusXl: radiusXl ?? this.radiusXl,
      radius2xl: radius2xl ?? this.radius2xl,
      radiusFull: radiusFull ?? this.radiusFull,
      // Motion
      durationInstant: durationInstant ?? this.durationInstant,
      durationFast: durationFast ?? this.durationFast,
      durationStandard: durationStandard ?? this.durationStandard,
      durationEmphasized: durationEmphasized ?? this.durationEmphasized,
      durationSlow: durationSlow ?? this.durationSlow,
      curveStandard: curveStandard ?? this.curveStandard,
      curveEmphasized: curveEmphasized ?? this.curveEmphasized,
      // Opacity
      opacityDisabled: opacityDisabled ?? this.opacityDisabled,
      opacityMedium: opacityMedium ?? this.opacityMedium,
      stateHover: stateHover ?? this.stateHover,
      stateFocus: stateFocus ?? this.stateFocus,
      statePressed: statePressed ?? this.statePressed,
    );
  }
}
