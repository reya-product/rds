import 'package:flutter/material.dart';

import '../../tokens/rds_icons.dart';
import '../date_picker/rds_date_picker.dart';
import '_rds_picker_field_base.dart';

// ---------------------------------------------------------------------------
// RdsDateField
// ---------------------------------------------------------------------------

/// A read-only text field that displays a formatted date and opens
/// [RdsDatePicker] in a dialog when tapped.
///
/// ```dart
/// RdsDateField(
///   label: 'Date of birth',
///   value: _date,
///   onChanged: (d) => setState(() => _date = d),
///   mandatory: true,
/// )
/// ```
class RdsDateField extends StatefulWidget {
  const RdsDateField({
    super.key,
    required this.label,
    this.value,
    this.onChanged,
    this.placeholder = 'DD/MM/YYYY',
    this.minDate,
    this.maxDate,
    this.supportText,
    this.errorText,
    this.mandatory = false,
    this.disabled = false,
    this.readOnly = false,
  });

  /// The field label displayed above the input.
  final String label;

  /// The currently selected date. Null means no selection (placeholder shown).
  final DateTime? value;

  /// Called when the user confirms a date in the picker dialog.
  final ValueChanged<DateTime>? onChanged;

  /// Placeholder text shown when [value] is null.
  final String placeholder;

  /// Forwarded to [RdsDatePicker] as the minimum selectable date.
  final DateTime? minDate;

  /// Forwarded to [RdsDatePicker] as the maximum selectable date.
  final DateTime? maxDate;

  /// Descriptive text shown below the field. Replaced by [errorText] when set.
  final String? supportText;

  /// Error message. When non-null the field enters the error state.
  final String? errorText;

  /// Shows an asterisk after the label when true.
  final bool mandatory;

  /// Prevents all interaction and dims the field.
  final bool disabled;

  /// Shows value but prevents opening the picker.
  final bool readOnly;

  @override
  State<RdsDateField> createState() => _RdsDateFieldState();
}

class _RdsDateFieldState extends State<RdsDateField> {
  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _openPicker(BuildContext context) async {
    if (widget.disabled || widget.readOnly) return;

    final result = await showDialog<DateTime>(
      context: context,
      builder: (_) => RdsPickerDialog<DateTime>(
        title: 'Select date',
        initialValue: widget.value,
        pickerBuilder: (ctx, val, onChange) => RdsDatePicker(
          value: val,
          onChanged: onChange,
          minDate: widget.minDate,
          maxDate: widget.maxDate,
        ),
      ),
    );

    if (result != null) {
      widget.onChanged?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RdsPickerFieldBase(
      label: widget.label,
      displayValue: widget.value != null ? _formatDate(widget.value!) : null,
      placeholder: widget.placeholder,
      leadingIcon: RdsIcons.calendar,
      supportText: widget.supportText,
      errorText: widget.errorText,
      mandatory: widget.mandatory,
      disabled: widget.disabled,
      readOnly: widget.readOnly,
      onTap: () => _openPicker(context),
    );
  }
}
