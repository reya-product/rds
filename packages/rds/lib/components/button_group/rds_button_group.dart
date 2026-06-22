import 'package:flutter/material.dart';
import '../../theme/rds_theme.dart';
import '../button/rds_button.dart';

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// Selection behaviour of [RdsButtonGroup].
enum RdsButtonGroupSelectionMode {
  /// Buttons are independent actions — no selection state tracked.
  none,

  /// Exactly one button can be selected at a time (radio-like).
  single,

  /// Any number of buttons can be selected simultaneously.
  multi,
}

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

/// Configuration for a single button within [RdsButtonGroup].
class RdsButtonGroupItem {
  const RdsButtonGroupItem({
    required this.label,
    this.icon,
    this.iconPosition = RdsButtonIconPosition.none,
    this.disabled = false,
    this.tooltip,
  });

  /// The button label.
  final String label;

  /// Optional icon data.
  final IconData? icon;

  /// Icon position within this button.
  final RdsButtonIconPosition iconPosition;

  /// Whether this specific button is disabled regardless of group state.
  final bool disabled;

  /// Tooltip text shown on hover (required for icon-only items).
  final String? tooltip;
}

// ---------------------------------------------------------------------------
// RdsButtonGroup
// ---------------------------------------------------------------------------

/// A horizontal row of semantically related [RdsButton]s with optional
/// selection tracking.
///
/// In [RdsButtonGroupSelectionMode.single] and
/// [RdsButtonGroupSelectionMode.multi] modes, selected buttons render with
/// the `primary` fill (equivalent to [RdsButtonVariant.primary]) and
/// unselected buttons render with the `outlined` style.
///
/// In [RdsButtonGroupSelectionMode.none] mode all buttons render as
/// [RdsButtonVariant.outlined] and [onSelectionChanged] is never called.
///
/// Buttons are spaced by `space-2` (8px) gaps. No connecting border between
/// them — each button is a distinct rounded rectangle.
///
/// ```dart
/// RdsButtonGroup(
///   items: const [
///     RdsButtonGroupItem(label: 'Day'),
///     RdsButtonGroupItem(label: 'Week'),
///     RdsButtonGroupItem(label: 'Month'),
///   ],
///   selectionMode: RdsButtonGroupSelectionMode.single,
///   selected: {1},
///   onSelectionChanged: (next) => setState(() => _selected = next),
/// )
/// ```
class RdsButtonGroup extends StatelessWidget {
  const RdsButtonGroup({
    super.key,
    required this.items,
    this.selectionMode = RdsButtonGroupSelectionMode.none,
    this.selected = const {},
    this.onSelectionChanged,
    this.size = RdsButtonSize.medium,
    this.disabled = false,
  });

  /// The list of button items. Order determines the index used in [selected].
  final List<RdsButtonGroupItem> items;

  /// Controls how selection works.
  final RdsButtonGroupSelectionMode selectionMode;

  /// The set of currently selected indices.
  final Set<int> selected;

  /// Called when the selection changes. Receives the new [Set<int>].
  /// Not called when [selectionMode] is [RdsButtonGroupSelectionMode.none].
  final ValueChanged<Set<int>>? onSelectionChanged;

  /// Size applied uniformly to all buttons.
  final RdsButtonSize size;

  /// Disables all buttons in the group.
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Semantics(
      label: 'Button group',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = selected.contains(index);
          final isDisabled = disabled || item.disabled;

          final variant = _variantForIndex(index, isSelected);
          final onPressed = (selectionMode == RdsButtonGroupSelectionMode.none)
              ? null
              : isDisabled
                  ? null
                  : () => _handleTap(index);

          Widget btn = RdsButton(
            label: item.label,
            variant: variant,
            icon: item.icon,
            iconPosition: item.iconPosition,
            size: size,
            disabled: isDisabled,
            onPressed: onPressed,
          );

          // Wrap icon-only buttons in a Tooltip
          if (item.iconPosition == RdsButtonIconPosition.iconOnly &&
              item.tooltip != null) {
            btn = Tooltip(message: item.tooltip!, child: btn);
          }

          final isLast = index == items.length - 1;
          if (isLast) return btn;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              btn,
              SizedBox(width: rds.space2),
            ],
          );
        }),
      ),
    );
  }

  RdsButtonVariant _variantForIndex(int index, bool isSelected) {
    if (selectionMode == RdsButtonGroupSelectionMode.none) {
      return RdsButtonVariant.outlined;
    }
    return isSelected ? RdsButtonVariant.primary : RdsButtonVariant.outlined;
  }

  void _handleTap(int index) {
    if (onSelectionChanged == null) return;

    Set<int> next;
    switch (selectionMode) {
      case RdsButtonGroupSelectionMode.none:
        return;
      case RdsButtonGroupSelectionMode.single:
        next = {index};
        break;
      case RdsButtonGroupSelectionMode.multi:
        next = Set<int>.from(selected);
        if (next.contains(index)) {
          next.remove(index);
        } else {
          next.add(index);
        }
        break;
    }
    onSelectionChanged!(next);
  }
}
