import 'package:flutter/material.dart';
import 'package:rds/rds.dart';

import 'rds_calendar_grid.dart';
import 'rds_picker_models.dart';
import 'rds_time_picker.dart';

export 'rds_picker_models.dart';

// ---------------------------------------------------------------------------
// RdsDateTimePicker
// ---------------------------------------------------------------------------

/// An inline combined date + time picker.
///
/// Renders the calendar grid above a time selection section (hour/minute
/// spinners + AM/PM toggle, or 24-hour format based on [use24HourFormat]).
///
/// ```dart
/// RdsDateTimePicker(
///   value: _dateTime,
///   onChanged: (dt) => setState(() => _dateTime = dt),
///   use24HourFormat: false,
/// )
/// ```
class RdsDateTimePicker extends StatefulWidget {
  const RdsDateTimePicker({
    super.key,
    this.value,
    this.onChanged,
    this.minDate,
    this.maxDate,
    this.use24HourFormat = false,
    this.firstDayOfWeek = 1,
  });

  /// The currently selected date and time. Null means no selection.
  final DateTime? value;

  /// Called when the user changes either the date or time.
  final ValueChanged<DateTime>? onChanged;

  /// The earliest selectable date.
  final DateTime? minDate;

  /// The latest selectable date.
  final DateTime? maxDate;

  /// Whether to use 24-hour (true) or 12-hour AM/PM (false) format.
  final bool use24HourFormat;

  /// First day of the week. 0 = Sunday, 1 = Monday (default).
  final int firstDayOfWeek;

  @override
  State<RdsDateTimePicker> createState() => _RdsDateTimePickerState();
}

class _RdsDateTimePickerState extends State<RdsDateTimePicker> {
  late DateTime _displayMonth;
  DateTime? _selectedDate;
  late int _hour;
  late int _minute;
  bool _selectingMinuteInDial = false;

  @override
  void initState() {
    super.initState();
    final seed = widget.value ?? DateTime.now();
    _displayMonth = DateTime(seed.year, seed.month, 1);
    _selectedDate = widget.value;
    _hour = widget.value?.hour ?? 9;
    _minute = widget.value?.minute ?? 0;
  }

  @override
  void didUpdateWidget(RdsDateTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != null) {
      _selectedDate = widget.value;
      _hour = widget.value!.hour;
      _minute = widget.value!.minute;
      _displayMonth =
          DateTime(widget.value!.year, widget.value!.month, 1);
    }
  }

  void _onDaySelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onChanged?.call(
      DateTime(date.year, date.month, date.day, _hour, _minute),
    );
  }

  void _onTimeChanged(TimeOfDay time) {
    setState(() {
      _hour = time.hour;
      _minute = time.minute;
    });
    if (_selectedDate != null) {
      widget.onChanged?.call(
        DateTime(
            _selectedDate!.year,
            _selectedDate!.month,
            _selectedDate!.day,
            time.hour,
            time.minute),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Container(
      padding: EdgeInsets.all(rds.space4),
      decoration: BoxDecoration(
        color: rds.surface,
        borderRadius: BorderRadius.circular(rds.radiusLg),
        boxShadow: RdsShadows.shadowMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Date section ----
          SizedBox(
            width: 304,
            child: RdsCalendarGrid(
              displayMonth: _displayMonth,
              selectedDate: _selectedDate,
              minDate: widget.minDate,
              maxDate: widget.maxDate,
              firstDayOfWeek: widget.firstDayOfWeek,
              onDaySelected: _onDaySelected,
              onMonthChanged: (m) => setState(() => _displayMonth = m),
            ),
          ),

          SizedBox(height: rds.space4),
          Divider(color: rds.outlineVariant, height: 1),
          SizedBox(height: rds.space4),

          // ---- Time section label ----
          Padding(
            padding:
                EdgeInsets.only(left: rds.space1, bottom: rds.space3),
            child: Text(
              'Time',
              style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
            ),
          ),

          // ---- Time input row (spinners) ----
          _InlineTimeSection(
            hour: _hour,
            minute: _minute,
            use24HourFormat: widget.use24HourFormat,
            onChanged: _onTimeChanged,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Inline time section — spinner-style, no dial
// ---------------------------------------------------------------------------

/// A compact time selector used inside [RdsDateTimePicker].
/// Uses the spinner (input) approach rather than the dial, for compactness.
class _InlineTimeSection extends StatelessWidget {
  const _InlineTimeSection({
    required this.hour,
    required this.minute,
    required this.use24HourFormat,
    required this.onChanged,
  });

  final int hour;
  final int minute;
  final bool use24HourFormat;
  final ValueChanged<TimeOfDay> onChanged;

  @override
  Widget build(BuildContext context) {
    return RdsTimePicker(
      value: TimeOfDay(hour: hour, minute: minute),
      onChanged: onChanged,
      use24HourFormat: use24HourFormat,
      mode: RdsPickerMode.input,
    );
  }
}
