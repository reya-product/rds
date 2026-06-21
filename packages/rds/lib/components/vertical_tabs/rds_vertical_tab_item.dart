import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

/// A single item in the [RdsVerticalTabs] navigation strip.
class RdsVerticalTabItem {
  const RdsVerticalTabItem({
    required this.label,
    required this.icon,
    this.disabled = false,
    this.badge,
  });

  /// Navigation label. Used for semantics and tooltip in collapsed mode.
  final String label;

  /// Icon to display in the nav strip.
  final IconData icon;

  /// When true the item is not interactive.
  final bool disabled;

  /// Optional badge count or label (e.g. '3', 'NEW').
  /// Displayed as a small pill overlay on the icon.
  final String? badge;
}

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// Controls icon and label visibility in [RdsVerticalTabs].
enum RdsVerticalTabIconMode {
  /// Icon (24px) followed by label. Default expanded mode.
  withLabels,

  /// Label only — icon is hidden.
  labelsOnly,

  /// Icon only — label is hidden visually but read by screen readers and shown
  /// as a Flutter [Tooltip] on hover.
  iconOnly,
}
