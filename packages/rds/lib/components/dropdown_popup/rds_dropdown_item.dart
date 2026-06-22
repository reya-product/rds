import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// RdsDropdownItem
// ---------------------------------------------------------------------------

/// A data object representing a single option in an [RdsDropdownPopup].
///
/// Each item maps to one [RdsListItem] row in the popup. The [value] is the
/// opaque identifier passed back via [RdsDropdownPopup.onItemSelected]; the
/// [label] is what the user sees.
///
/// ```dart
/// const RdsDropdownItem(
///   value: 'dr_chen',
///   label: 'Dr. Sarah Chen',
///   supportingText: 'General Practice',
///   leadingIcon: RdsIcons.user,
/// )
/// ```
class RdsDropdownItem {
  /// The opaque value returned when this item is selected.
  final dynamic value;

  /// The human-readable label shown in the list row.
  final String label;

  /// Optional secondary text shown below [label].
  final String? supportingText;

  /// Optional icon shown in the leading slot of the row.
  final IconData? leadingIcon;

  /// When true the item is rendered at reduced opacity and cannot be selected.
  final bool disabled;

  const RdsDropdownItem({
    required this.value,
    required this.label,
    this.supportingText,
    this.leadingIcon,
    this.disabled = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RdsDropdownItem &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
