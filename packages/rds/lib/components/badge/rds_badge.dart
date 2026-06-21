import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';
import '../../tokens/rds_colors.dart';

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// Controls which pastel or semantic color pair the badge uses.
enum RdsBadgeColor {
  blue,
  purple,
  pink,
  orange,
  yellow,
  teal,
  green,
  red,
  amber,
  neutral,
  danger,
  warning,
  success,
}

/// Controls the height and typography scale of the badge.
enum RdsBadgeSize {
  /// Height 20px, label-small text style.
  small,

  /// Height 24px, label-medium text style. The default.
  medium,

  /// Height 28px, label-large text style.
  large,
}

/// Controls whether an icon is shown, and where.
enum RdsBadgeIconMode {
  /// No icon — label only (or empty pill when label is absent).
  none,

  /// Icon before the label.
  leading,

  /// Icon only — no label text rendered.
  iconOnly,
}

// ---------------------------------------------------------------------------
// Widget
// ---------------------------------------------------------------------------

/// A non-interactive pill label used to convey status, category, or metadata.
///
/// ## Usage
/// ```dart
/// RdsBadge(
///   label: 'Active',
///   color: RdsBadgeColor.teal,
///   size: RdsBadgeSize.medium,
/// )
/// ```
class RdsBadge extends StatelessWidget {
  /// Text displayed inside the badge. Ignored when [iconMode] is [RdsBadgeIconMode.iconOnly].
  final String label;

  /// Whether to show an icon, and where relative to the label.
  final RdsBadgeIconMode iconMode;

  /// The icon to display. Required when [iconMode] is not [RdsBadgeIconMode.none].
  final IconData? icon;

  /// Color scheme applied to background and text/icon.
  final RdsBadgeColor color;

  /// Controls height and text scale.
  final RdsBadgeSize size;

  const RdsBadge({
    super.key,
    required this.label,
    this.iconMode = RdsBadgeIconMode.none,
    this.icon,
    this.color = RdsBadgeColor.neutral,
    this.size = RdsBadgeSize.medium,
  });

  // ---------------------------------------------------------------------------
  // Token helpers
  // ---------------------------------------------------------------------------

  /// Returns the (background, text/icon) color pair for [color].
  ///
  /// Pastel pairs come directly from [RdsColors] primitives.
  /// Semantic pairs are read from [RdsTheme] so they adapt to light/dark mode.
  (Color background, Color foreground) _colorPair(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    switch (color) {
      case RdsBadgeColor.blue:
        return (RdsColors.badgeBlueBackground, RdsColors.badgeBlueText);
      case RdsBadgeColor.purple:
        return (RdsColors.badgePurpleBackground, RdsColors.badgePurpleText);
      case RdsBadgeColor.pink:
        return (RdsColors.badgePinkBackground, RdsColors.badgePinkText);
      case RdsBadgeColor.orange:
        return (RdsColors.badgeOrangeBackground, RdsColors.badgeOrangeText);
      case RdsBadgeColor.yellow:
        return (RdsColors.badgeYellowBackground, RdsColors.badgeYellowText);
      case RdsBadgeColor.teal:
        return (RdsColors.badgeTealBackground, RdsColors.badgeTealText);
      case RdsBadgeColor.green:
        return (RdsColors.badgeGreenBackground, RdsColors.badgeGreenText);
      case RdsBadgeColor.red:
        return (RdsColors.badgeRedBackground, RdsColors.badgeRedText);
      case RdsBadgeColor.amber:
        return (RdsColors.badgeAmberBackground, RdsColors.badgeAmberText);
      case RdsBadgeColor.neutral:
        return (RdsColors.badgeNeutralBackground, RdsColors.badgeNeutralText);
      case RdsBadgeColor.danger:
        return (rds.dangerContainer, rds.onDangerContainer);
      case RdsBadgeColor.warning:
        return (rds.warningContainer, rds.onWarningContainer);
      case RdsBadgeColor.success:
        return (rds.successContainer, rds.onSuccessContainer);
    }
  }

  double _height(RdsTheme rds) {
    switch (size) {
      case RdsBadgeSize.small:
        return 20;
      case RdsBadgeSize.medium:
        return 24;
      case RdsBadgeSize.large:
        return 28;
    }
  }

  double _horizontalPadding(RdsTheme rds) {
    switch (size) {
      case RdsBadgeSize.small:
        return rds.space2; // 8px
      case RdsBadgeSize.medium:
      case RdsBadgeSize.large:
        return rds.space3; // 12px
    }
  }

  TextStyle _textStyle(RdsTheme rds) {
    switch (size) {
      case RdsBadgeSize.small:
        return rds.labelSmall;
      case RdsBadgeSize.medium:
        return rds.labelMedium;
      case RdsBadgeSize.large:
        return rds.labelLarge;
    }
  }

  /// Icon size scales with badge size.
  double _iconSize(RdsTheme rds) {
    switch (size) {
      case RdsBadgeSize.small:
        return 10;
      case RdsBadgeSize.medium:
        return 12;
      case RdsBadgeSize.large:
        return 14;
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final (bg, fg) = _colorPair(context);
    final height = _height(rds);
    final hPad = _horizontalPadding(rds);
    final textStyle = _textStyle(rds).copyWith(color: fg);
    final iconSize = _iconSize(rds);

    Widget content;

    switch (iconMode) {
      case RdsBadgeIconMode.none:
        content = Text(label, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis);

      case RdsBadgeIconMode.leading:
        content = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon, size: iconSize, color: fg),
            if (icon != null)
              SizedBox(width: rds.space1),
            Text(label, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        );

      case RdsBadgeIconMode.iconOnly:
        content = icon != null
            ? Icon(icon, size: iconSize, color: fg)
            : const SizedBox.shrink();
    }

    final semanticLabel = iconMode == RdsBadgeIconMode.iconOnly ? label : null;

    return Semantics(
      label: semanticLabel,
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: hPad),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(rds.radiusFull),
        ),
        alignment: Alignment.center,
        child: content,
      ),
    );
  }
}
