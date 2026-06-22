import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';
import '../list_item/rds_list_item.dart';
import '_list_input_wrapper.dart';
import 'rds_list_input_item.dart';

// ---------------------------------------------------------------------------
// RdsToggleListInput<T>
// ---------------------------------------------------------------------------

/// A labelled list of settings where each row has a trailing toggle switch.
/// Each item is independently toggled — semantically a list of boolean settings.
///
/// Pass [onChanged] as null to put the entire input in a disabled state.
///
/// ```dart
/// RdsToggleListInput<String>(
///   label: 'Notifications',
///   items: const [
///     RdsListInputItem(value: 'email', label: 'Email notifications'),
///     RdsListInputItem(value: 'push',  label: 'Push notifications'),
///   ],
///   selected: _enabled,
///   onChanged: (s) => setState(() => _enabled = s),
/// )
/// ```
class RdsToggleListInput<T> extends StatelessWidget {
  /// Field label rendered above the list.
  final String label;

  /// All available options.
  final List<RdsListInputItem<T>> items;

  /// Currently toggled-on values.
  final Set<T> selected;

  /// Called with the new full set whenever any toggle changes.
  /// When null, the entire input is disabled.
  final ValueChanged<Set<T>>? onChanged;

  /// Optional helper text rendered below the list.
  final String? supportText;

  /// Error message rendered below the list; takes precedence over [supportText].
  final String? errorText;

  /// When true, an asterisk is appended to [label].
  final bool mandatory;

  /// When true, a divider is drawn between each row.
  /// Defaults to true for toggle lists, which typically show settings.
  final bool showDividers;

  /// When true, a border with [RdsTheme.radiusMd] radius is drawn around the
  /// list of rows.
  final bool bordered;

  const RdsToggleListInput({
    super.key,
    required this.label,
    required this.items,
    required this.selected,
    this.onChanged,
    this.supportText,
    this.errorText,
    this.mandatory = false,
    this.showDividers = true,
    this.bordered = false,
  });

  void _toggle(T value) {
    if (onChanged == null) return;
    final next = Set<T>.from(selected);
    if (next.contains(value)) {
      next.remove(value);
    } else {
      next.add(value);
    }
    onChanged!(next);
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    final rows = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final isItemEnabled = onChanged != null && !item.disabled;
      final isOn = selected.contains(item.value);

      rows.add(
        RdsListItem(
          primaryText: item.label,
          supportingText: item.supportingText,
          trailing: RdsListItemTrailing.toggle,
          toggleValue: isOn,
          onToggleChanged: isItemEnabled ? (_) => _toggle(item.value) : null,
          onTap: isItemEnabled ? () => _toggle(item.value) : null,
          enabled: isItemEnabled,
        ),
      );

      if (showDividers && i < items.length - 1) {
        rows.add(Divider(
          height: 1,
          thickness: 1,
          color: rds.outlineVariant,
        ));
      }
    }

    return ListInputWrapper(
      label: label,
      mandatory: mandatory,
      supportText: supportText,
      errorText: errorText,
      bordered: bordered,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: rows,
      ),
    );
  }
}
