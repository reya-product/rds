import 'package:flutter/material.dart';

import '../button/rds_button.dart';

/// A single action rendered as an [RdsButton] in the card footer.
///
/// Actions appear in a horizontal row at the bottom of an [RdsCard].
/// Between each adjacent pair a muted vertical divider is rendered.
class RdsCardAction {
  /// The button label. Always required — used for accessibility even when
  /// [iconOnly] is true.
  final String label;

  /// Optional icon to show on the button.
  final IconData? icon;

  /// When true the label is visually hidden and only the [icon] is shown.
  /// [icon] must be non-null when [iconOnly] is true.
  final bool iconOnly;

  /// Called when the action is tapped.
  final VoidCallback? onPressed;

  /// Visual variant of the button.
  final RdsButtonVariant variant;

  const RdsCardAction({
    required this.label,
    this.icon,
    this.iconOnly = false,
    this.onPressed,
    this.variant = RdsButtonVariant.text,
  });
}
