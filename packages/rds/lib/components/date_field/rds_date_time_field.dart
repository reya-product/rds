import 'package:flutter/material.dart';

import '../../tokens/rds_icons.dart';
import '../date_picker/rds_date_time_picker.dart';
import '_rds_picker_field_base.dart';

// ---------------------------------------------------------------------------
// RdsDateTimeField
// ---------------------------------------------------------------------------

/// A read-only text field that displays a formatted date and time, and opens
/// [RdsDateTimePicker] in a dialog when tapped.
///
/// ```dart
/// RdsDateTimeField(
///   label: 'Appointment',
///   value: _dateTime,
///   onChanged: (dt) => setState(() => _dateTime = dt),
///   use24HourFormat: false,
/// )
/// ```
class RdsDateTimeField extends StatefulWidget {
  const RdsDateTimeField({
    super.key,
    required this.label,
    this.value,
    this.onChanged,
    this.placeholder = 'DD/MM/YYYY HH:MM',
    this.minDate,
    this.maxDate,
    this.use24HourFormat = true,
    this.supportText,
    this.errorText,
    this.mandatory = false,
    this.disabled = false,
    this.readOnly = false,
  });

  /// The field label displayed above the input.
  final String label;

  /// The currently selected date and time. Null means no selection.
  final DateTime? value;

  /// Called when the user confirms a date/time in the picker dialog.
  final ValueChanged<DateTime>? onChanged;

  /// Placeholder text shown when [value] is null.
  final String placeholder;

  /// Forwarded to [RdsDateTimePicker] as the minimum selectable date.
  final DateTime? minDate;

  /// Forwarded to [RdsDateTimePicker] as the maximum selectable date.
  final DateTime? maxDate;

  /// Whether to use 24-hour (true) or 12-hour AM/PM (false) display format.
  final bool use24HourFormat;

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
  State<RdsDateTimeField> createState() => _RdsDateTimeFieldState();
}

class _RdsDateTimeFieldState extends State<RdsDateTimeField> {
  String _formatDateTime(DateTime dt) {
    final date =
        '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    final String time;
    if (widget.use24HourFormat) {
      time =
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } else {
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      time = '${h.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} $period';
    }
    return '$date $time';
  }

  Future<void> _openPicker(BuildContext context) async {
    if (widget.disabled || widget.readOnly) return;

    final result = await showDialog<DateTime>(
      context: context,
      builder: (_) => _RdsPickerDialog<DateTime>(
        title: 'Select date & time',
        initialValue: widget.value,
        pickerBuilder: (ctx, val, onChange) => RdsDateTimePicker(
          value: val,
          onChanged: onChange,
          minDate: widget.minDate,
          maxDate: widget.maxDate,
          use24HourFormat: widget.use24HourFormat,
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
      displayValue: widget.value != null ? _formatDateTime(widget.value!) : null,
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
