import 'package:flutter/material.dart';

import '../../tokens/rds_icons.dart';
import '../date_picker/rds_picker_models.dart';
import '../date_picker/rds_time_picker.dart';
import '_rds_picker_field_base.dart';

// ---------------------------------------------------------------------------
// RdsTimeField
// ---------------------------------------------------------------------------

/// A read-only text field that displays a formatted time and opens
/// [RdsTimePicker] in a dialog when tapped.
///
/// ```dart
/// RdsTimeField(
///   label: 'Appointment time',
///   value: _time,
///   onChanged: (t) => setState(() => _time = t),
///   use24HourFormat: false,
/// )
/// ```
class RdsTimeField extends StatefulWidget {
  const RdsTimeField({
    super.key,
    required this.label,
    this.value,
    this.onChanged,
    this.placeholder = 'HH:MM',
    this.use24HourFormat = true,
    this.supportText,
    this.errorText,
    this.mandatory = false,
    this.disabled = false,
    this.readOnly = false,
  });

  /// The field label displayed above the input.
  final String label;

  /// The currently selected time. Null means no selection (placeholder shown).
  final TimeOfDay? value;

  /// Called when the user confirms a time in the picker dialog.
  final ValueChanged<TimeOfDay>? onChanged;

  /// Placeholder text shown when [value] is null.
  final String placeholder;

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
  State<RdsTimeField> createState() => _RdsTimeFieldState();
}

class _RdsTimeFieldState extends State<RdsTimeField> {
  String _formatTime(TimeOfDay t) {
    if (widget.use24HourFormat) {
      return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    } else {
      final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
      final period = t.period == DayPeriod.am ? 'AM' : 'PM';
      return '${h.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')} $period';
    }
  }

  Future<void> _openPicker(BuildContext context) async {
    if (widget.disabled || widget.readOnly) return;

    final result = await showDialog<TimeOfDay>(
      context: context,
      builder: (_) => _RdsPickerDialog<TimeOfDay>(
        title: 'Select time',
        initialValue: widget.value,
        pickerBuilder: (ctx, val, onChange) => RdsTimePicker(
          value: val,
          onChanged: onChange,
          use24HourFormat: widget.use24HourFormat,
          mode: RdsPickerMode.dial,
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
      displayValue: widget.value != null ? _formatTime(widget.value!) : null,
      placeholder: widget.placeholder,
      leadingIcon: RdsIcons.time,
      supportText: widget.supportText,
      errorText: widget.errorText,
      mandatory: widget.mandatory,
      disabled: widget.disabled,
      readOnly: widget.readOnly,
      onTap: () => _openPicker(context),
    );
  }
}
