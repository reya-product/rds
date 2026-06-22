import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';
import '../list_item/rds_list_item.dart';
import '_list_input_wrapper.dart';
import 'rds_list_input_item.dart';

// ---------------------------------------------------------------------------
// RdsSingleSelectListInput<T>
// ---------------------------------------------------------------------------

/// A labelled list of options where each row has a leading radio button.
/// Only one item can be selected at a time.
///
/// Pass [onChanged] as null to put the entire input in a disabled state.
///
/// ```dart
/// RdsSingleSelectListInput<String>(
///   label: 'Primary health goal',
///   items: const [
///     RdsListInputItem(value: 'cardio', label: 'Cardiovascular health'),
///     RdsListInputItem(value: 'sleep',  label: 'Sleep quality'),
///   ],
///   selected: _selected,
///   onChanged: (v) => setState(() => _selected = v),
/// )
/// ```
class RdsSingleSelectListInput<T> extends StatelessWidget {
  /// Field label rendered above the list.
  final String label;

  /// All available options.
  final List<RdsListInputItem<T>> items;

  /// Currently selected value, or null when nothing is selected.
  final T? selected;

  /// Called with the newly selected value when the user taps a row.
  /// When null, the entire input is disabled.
  final ValueChanged<T?>? onChanged;

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

  const RdsSingleSelectListInput({
    super.key,
    required this.label,
    required this.items,
    this.selected,
    this.onChanged,
    this.supportText,
    this.errorText,
    this.mandatory = false,
    this.showDividers = false,
    this.bordered = false,
  });

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    final rows = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final isItemEnabled = onChanged != null && !item.disabled;
      final isSelected = selected == item.value;

      rows.add(
        RdsListItem(
          primaryText: item.label,
          supportingText: item.supportingText,
          leading: RdsListItemLeading.radio,
          radioValue: item.value,
          radioGroupValue: selected,
          onRadioChanged: isItemEnabled
              ? (v) => onChanged!(v as T?)
              : null,
          onTap: isItemEnabled && !isSelected
              ? () => onChanged!(item.value)
              : null,
          enabled: isItemEnabled,
          selected: isSelected,
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
