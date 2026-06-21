import 'package:flutter/material.dart';
import 'package:rds/rds.dart';

import 'rds_calendar_grid.dart';
import 'rds_picker_models.dart';

export 'rds_picker_models.dart';

// ---------------------------------------------------------------------------
// RdsDatePicker
// ---------------------------------------------------------------------------

/// An inline single-date calendar picker.
///
/// Shows a month grid with prev/next navigation, a clickable month/year header,
/// and selectable day cells. Works both as an embedded widget in a form and
/// when rendered inside a popup/dialog by the Date Field (T2a).
///
/// ```dart
/// RdsDatePicker(
///   value: _selectedDate,
///   onChanged: (date) => setState(() => _selectedDate = date),
/// )
/// ```
class RdsDatePicker extends StatefulWidget {
  const RdsDatePicker({
    super.key,
    this.value,
    this.onChanged,
    this.minDate,
    this.maxDate,
    this.firstDayOfWeek = 1,
  });

  /// The currently selected date. Null means no selection.
  final DateTime? value;

  /// Called when the user taps a day cell.
  final ValueChanged<DateTime>? onChanged;

  /// The earliest selectable date.
  final DateTime? minDate;

  /// The latest selectable date.
  final DateTime? maxDate;

  /// First day of the week. 0 = Sunday, 1 = Monday (default).
  final int firstDayOfWeek;

  @override
  State<RdsDatePicker> createState() => _RdsDatePickerState();
}

class _RdsDatePickerState extends State<RdsDatePicker> {
  late DateTime _displayMonth;

  @override
  void initState() {
    super.initState();
    final seed = widget.value ?? DateTime.now();
    _displayMonth = DateTime(seed.year, seed.month, 1);
  }

  @override
  void didUpdateWidget(RdsDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null &&
        (widget.value!.year != oldWidget.value?.year ||
            widget.value!.month != oldWidget.value?.month)) {
      _displayMonth = DateTime(widget.value!.year, widget.value!.month, 1);
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
      child: SizedBox(
        width: 304,
        child: RdsCalendarGrid(
          displayMonth: _displayMonth,
          selectedDate: widget.value,
          minDate: widget.minDate,
          maxDate: widget.maxDate,
          firstDayOfWeek: widget.firstDayOfWeek,
          onDaySelected: (date) => widget.onChanged?.call(date),
          onMonthChanged: (month) => setState(() => _displayMonth = month),
        ),
      ),
    );
  }
}
