import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// RdsListInputItem<T>
// ---------------------------------------------------------------------------

/// A single option in a selectable list input.
///
/// Used by [RdsMultiSelectListInput], [RdsSingleSelectListInput], and
/// [RdsToggleListInput] to describe each row in the list.
///
/// ```dart
/// RdsListInputItem(
///   value: 'cardio',
///   label: 'Cardiovascular health',
///   supportingText: 'Heart rate, blood pressure',
///   leadingIcon: Icons.favorite_outline,
/// )
/// ```
class RdsListInputItem<T> {
  /// The value this item represents. Used to track selection.
  final T value;

  /// Primary label text displayed in the row.
  final String label;

  /// Optional secondary text displayed below [label].
  final String? supportingText;

  /// Optional icon displayed before the label in the row.
  final IconData? leadingIcon;

  /// When true, the row is rendered in a disabled state and cannot be
  /// selected or toggled.
  final bool disabled;

  const RdsListInputItem({
    required this.value,
    required this.label,
    this.supportingText,
    this.leadingIcon,
    this.disabled = false,
  });
}
