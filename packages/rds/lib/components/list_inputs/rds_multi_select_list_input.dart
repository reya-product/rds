import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';
import '../list_item/rds_list_item.dart';
import '_list_input_wrapper.dart';
import 'rds_list_input_item.dart';

// Re-export the shared data class so consumers need only one import.
export 'rds_list_input_item.dart';

// ---------------------------------------------------------------------------
// RdsMultiSelectListInput<T>
// ---------------------------------------------------------------------------

/// A labelled list of options where each row has a leading checkbox.
/// Multiple items can be selected simultaneously.
///
/// Pass [onChanged] as null to put the entire input in a disabled state.
///
/// ```dart
/// RdsMultiSelectListInput<String>(
///   label: 'Health goals',
///   items: const [
///     RdsListInputItem(value: 'cardio', label: 'Cardiovascular health'),
///     RdsListInputItem(value: 'sleep',  label: 'Sleep quality'),
///   ],
///   selected: _selected,
///   onChanged: (s) => setState(() => _selected = s),
/// )
/// ```
class RdsMultiSelectListInput<T> extends StatelessWidget {
  /// Field label rendered above the list.
  final String label;

  /// All available options.
  final List<RdsListInputItem<T>> items;

  /// Currently selected values.
  final Set<T> selected;

  /// Called with the new full set whenever selection changes.
  /// When null, the entire input is disabled.
  final ValueChanged<Set<T>>? onChanged;

  /// Optional helper text rendered below the list.
  final String? supportText;

  /// Error message rendered below the list; takes precedence over [supportText].
  final String? errorText;

  /// When true, an asterisk is appended to [label].
  final bool mandatory;

  /// When true, a divider is drawn between each row.
  final bool showDividers;

  /// When true, a border with [RdsTheme.radiusMd] radius is drawn around the
  /// list of rows.
  final bool bordered;

  const RdsMultiSelectListInput({
    super.key,
    required this.label,
    required this.items,
    required this.selected,
    this.onChanged,
    this.supportText,
    this.errorText,
    this.mandatory = false,
    this.showDividers = false,
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
      final isChecked = selected.contains(item.value);

      rows.add(
        RdsListItem(
          primaryText: item.label,
          supportingText: item.supportingText,
          leading: RdsListItemLeading.checkbox,
          checkboxValue: isChecked,
          onCheckboxChanged: isItemEnabled ? (_) => _toggle(item.value) : null,
          onTap: isItemEnabled ? () => _toggle(item.value) : null,
          enabled: isItemEnabled,
          selected: isChecked,
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

    return _ListInputWrapper(
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
