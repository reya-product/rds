import 'package:flutter/material.dart';

import 'rds_theme_data.dart';

/// RDS ThemeExtension.
///
/// Attach to [MaterialApp.theme] and [MaterialApp.darkTheme] using
/// [ThemeData.extensions]. Components read values with:
///
/// ```dart
/// final rds = Theme.of(context).extension<RdsTheme>()!;
/// ```
///
/// See [RdsThemes] for the pre-built light and dark instances.
class RdsTheme extends ThemeExtension<RdsTheme> {
  final RdsThemeData data;

  const RdsTheme(this.data);

  // ---------------------------------------------------------------------------
  // ThemeExtension overrides
  // ---------------------------------------------------------------------------

  @override
  RdsTheme copyWith({RdsThemeData? data}) => RdsTheme(data ?? this.data);

  @override
  RdsTheme lerp(ThemeExtension<RdsTheme>? other, double t) {
    if (t < 0.5) return this;
    return other is RdsTheme ? other : this;
  }

  // ---------------------------------------------------------------------------
  // Color — surfaces
  // ---------------------------------------------------------------------------

  Color get surface => data.surface;
  Color get surfaceVariant => data.surfaceVariant;
  Color get surfaceContainer => data.surfaceContainer;
  Color get onSurface => data.onSurface;
  Color get onSurfaceVariant => data.onSurfaceVariant;
  Color get onSurfaceMuted => data.onSurfaceMuted;

  // ---------------------------------------------------------------------------
  // Color — extended surfaces
  // ---------------------------------------------------------------------------

  Color get surfaceContainerLowest => data.surfaceContainerLowest;
  Color get surfaceContainerLow => data.surfaceContainerLow;
  Color get surfaceContainerHigh => data.surfaceContainerHigh;
  Color get surfaceContainerHighest => data.surfaceContainerHighest;
  Color get surfaceBright => data.surfaceBright;
  Color get surfaceTint => data.surfaceTint;
  Color get inverseSurface => data.inverseSurface;
  Color get inverseOnSurface => data.inverseOnSurface;
  Color get surfaceContainerEmphasized => data.surfaceContainerEmphasized;

  // ---------------------------------------------------------------------------
  // Color — primary
  // ---------------------------------------------------------------------------

  Color get primary => data.primary;
  Color get primaryContainer => data.primaryContainer;
  Color get onPrimary => data.onPrimary;
  Color get onPrimaryContainer => data.onPrimaryContainer;
  Color get primaryVariant => data.primaryVariant;

  // ---------------------------------------------------------------------------
  // Color — outline
  // ---------------------------------------------------------------------------

  Color get outline => data.outline;
  Color get outlineVariant => data.outlineVariant;
  Color get outlineLowest => data.outlineLowest;
  Color get scrim => data.scrim;

  // ---------------------------------------------------------------------------
  // Color — danger
  // ---------------------------------------------------------------------------

  Color get danger => data.danger;
  Color get dangerContainer => data.dangerContainer;
  Color get onDanger => data.onDanger;
  Color get onDangerContainer => data.onDangerContainer;

  // ---------------------------------------------------------------------------
  // Color — warning
  // ---------------------------------------------------------------------------

  Color get warning => data.warning;
  Color get warningContainer => data.warningContainer;
  Color get onWarning => data.onWarning;
  Color get onWarningContainer => data.onWarningContainer;

  // ---------------------------------------------------------------------------
  // Color — success
  // ---------------------------------------------------------------------------

  Color get success => data.success;
  Color get successContainer => data.successContainer;
  Color get onSuccess => data.onSuccess;
  Color get onSuccessContainer => data.onSuccessContainer;

  // ---------------------------------------------------------------------------
  // Color — neutral
  // ---------------------------------------------------------------------------

  Color get neutral => data.neutral;
  Color get neutralContainer => data.neutralContainer;
  Color get onNeutralContainer => data.onNeutralContainer;

  // ---------------------------------------------------------------------------
  // Color — extra containers
  // ---------------------------------------------------------------------------

  Color get mandatoryContainer => data.mandatoryContainer;
  Color get pinkContainer => data.pinkContainer;
  Color get purpleContainer => data.purpleContainer;
  Color get blueContainer => data.blueContainer;
  Color get yellowContainer => data.yellowContainer;

  // ---------------------------------------------------------------------------
  // Color — icon / shape
  // ---------------------------------------------------------------------------

  Color get iconOnBackground => data.iconOnBackground;
  Color get iconNeutral => data.iconNeutral;
  Color get iconError => data.iconError;
  Color get iconWarning => data.iconWarning;
  Color get iconSuccess => data.iconSuccess;
  Color get iconBlue => data.iconBlue;
  Color get iconPurple => data.iconPurple;
  Color get iconPink => data.iconPink;
  Color get iconYellow => data.iconYellow;

  // ---------------------------------------------------------------------------
  // Color — graph
  // ---------------------------------------------------------------------------

  Color get graphPrimary => data.graphPrimary;
  Color get graphSecondary => data.graphSecondary;

  // ---------------------------------------------------------------------------
  // Typography
  // ---------------------------------------------------------------------------

  TextStyle get displayLarge => data.displayLarge;
  TextStyle get displayMedium => data.displayMedium;
  TextStyle get displaySmall => data.displaySmall;
  TextStyle get headlineLarge => data.headlineLarge;
  TextStyle get headlineMedium => data.headlineMedium;
  TextStyle get headlineSmall => data.headlineSmall;
  TextStyle get titleLarge => data.titleLarge;
  TextStyle get titleMedium => data.titleMedium;
  TextStyle get titleSmall => data.titleSmall;
  TextStyle get bodyLarge => data.bodyLarge;
  TextStyle get bodyMedium => data.bodyMedium;
  TextStyle get bodySmall => data.bodySmall;
  TextStyle get labelLarge => data.labelLarge;
  TextStyle get labelMedium => data.labelMedium;
  TextStyle get labelSmall => data.labelSmall;

  // ---------------------------------------------------------------------------
  // Spacing
  // ---------------------------------------------------------------------------

  double get space0 => data.space0;
  double get space1 => data.space1;
  double get space2 => data.space2;
  double get space3 => data.space3;
  double get space4 => data.space4;
  double get space5 => data.space5;
  double get space6 => data.space6;
  double get space8 => data.space8;
  double get space10 => data.space10;
  double get space12 => data.space12;
  double get space16 => data.space16;
  double get space20 => data.space20;
  double get space24 => data.space24;

  // ---------------------------------------------------------------------------
  // Radius
  // ---------------------------------------------------------------------------

  double get radiusNone => data.radiusNone;
  double get radiusXs => data.radiusXs;
  double get radiusSm => data.radiusSm;
  double get radiusMd => data.radiusMd;
  double get radiusLg => data.radiusLg;
  double get radiusXl => data.radiusXl;
  double get radius2xl => data.radius2xl;
  double get radiusFull => data.radiusFull;

  // ---------------------------------------------------------------------------
  // Motion
  // ---------------------------------------------------------------------------

  Duration get durationInstant => data.durationInstant;
  Duration get durationFast => data.durationFast;
  Duration get durationStandard => data.durationStandard;
  Duration get durationEmphasized => data.durationEmphasized;
  Duration get durationSlow => data.durationSlow;
  Curve get curveStandard => data.curveStandard;
  Curve get curveEmphasized => data.curveEmphasized;

  // ---------------------------------------------------------------------------
  // Opacity / state layers
  // ---------------------------------------------------------------------------

  double get opacityDisabled => data.opacityDisabled;
  double get opacityMedium => data.opacityMedium;
  double get stateHover => data.stateHover;
  double get stateFocus => data.stateFocus;
  double get statePressed => data.statePressed;
}
