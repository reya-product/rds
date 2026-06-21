import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

/// A single tab entry supplied to [RdsTabs].
///
/// [label] is always required and is used for accessibility even when only an
/// icon is shown ([RdsTabIconMode.iconOnly]).
class RdsTabItem {
  const RdsTabItem({
    required this.label,
    this.icon,
    this.disabled = false,
  });

  /// Display label for this tab. Always required.
  final String label;

  /// Optional icon to render alongside or instead of the label.
  final IconData? icon;

  /// When true the tab is not interactive. It renders at disabled opacity.
  final bool disabled;
}

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// The visual style of the tab bar.
enum RdsTabVariant {
  /// Underline-indicator tabs on a plain surface background.
  /// The selected tab shows a 3px primary-colored bottom bar.
  primary,

  /// Pill/filled tabs inside a surfaceContainer container.
  /// The selected tab has a primaryContainer fill and rounded corners.
  secondary,
}

/// Controls whether icons are shown alongside or instead of labels.
enum RdsTabIconMode {
  /// Labels only — no icons rendered.
  none,

  /// Icon displayed to the left of the label.
  leading,

  /// Only the icon is shown; the label is used for semantics / tooltip only.
  iconOnly,
}
