import 'package:flutter/material.dart';
import '../../theme/rds_theme.dart';
import '../../tokens/rds_shadows.dart';

import 'rds_calendar_grid.dart';
import 'rds_picker_models.dart';

export 'rds_picker_models.dart';

// ---------------------------------------------------------------------------
// RdsDateRangePicker
// ---------------------------------------------------------------------------

/// An inline date range picker showing two side-by-side calendar months.
///
/// The user selects a range by tapping a start date, then an end date.
/// During selection a hover-preview strip shows the tentative range.
/// On narrow screens (< 640px) the two months stack vertically.
///
/// ```dart
/// RdsDateRangePicker(
///   startDate: _range.start,
///   endDate: _range.end,
///   onChanged: (range) => setState(() => _range = range),
/// )
/// ```
class RdsDateRangePicker extends StatefulWidget {
  const RdsDateRangePicker({
    super.key,
    this.startDate,
    this.endDate,
    this.onChanged,
    this.minDate,
    this.maxDate,
    this.firstDayOfWeek = 1,
  });

  /// The currently selected start date.
  final DateTime? startDate;

  /// The currently selected end date.
  final DateTime? endDate;

  /// Called when the range changes. Both [RdsDateRange.start] and
  /// [RdsDateRange.end] may be null while the user is in mid-selection.
  final ValueChanged<RdsDateRange>? onChanged;

  /// The earliest selectable date.
  final DateTime? minDate;

  /// The latest selectable date.
  final DateTime? maxDate;

  /// First day of the week. 0 = Sunday, 1 = Monday (default).
  final int firstDayOfWeek;

  @override
  State<RdsDateRangePicker> createState() => _RdsDateRangePickerState();
}

class _RdsDateRangePickerState extends State<RdsDateRangePicker> {
  late DateTime _leftMonth;
  late DateTime _rightMonth;
  DateTime? _hoverDate;

  // Internal selection state: tracks whether next tap is start or end
  DateTime? _pendingStart;

  @override
  void initState() {
    super.initState();
    final seed = widget.startDate ?? DateTime.now();
    _leftMonth = DateTime(seed.year, seed.month, 1);
    _rightMonth = DateTime(_leftMonth.year, _leftMonth.month + 1, 1);

    // If we have both, initialise pending state accordingly
    if (widget.startDate != null && widget.endDate == null) {
      _pendingStart = widget.startDate;
    }
  }

  RdsDateRange get _currentRange =>
      RdsDateRange(start: widget.startDate, end: widget.endDate);

  /// Whether we are currently waiting for the user to pick an end date.
  bool get _awaitingEnd =>
      widget.startDate != null && widget.endDate == null;

  void _handleDaySelected(DateTime date) {
    if (widget.startDate == null || widget.endDate != null) {
      // Start a new selection
      widget.onChanged?.call(RdsDateRange(start: date, end: null));
      _pendingStart = date;
    } else {
      // Complete the range
      if (date.isBefore(widget.startDate!)) {
        // User clicked before existing start — swap
        widget.onChanged?.call(RdsDateRange(start: date, end: widget.startDate));
      } else {
        widget.onChanged?.call(RdsDateRange(start: widget.startDate, end: date));
      }
      _pendingStart = null;
    }
  }

  void _handleMonthChanged(DateTime month, {required bool isLeft}) {
    setState(() {
      if (isLeft) {
        _leftMonth = month;
        // Ensure right is always one month ahead of left
        if (!month.isBefore(_rightMonth)) {
          _rightMonth = DateTime(month.year, month.month + 1, 1);
        }
      } else {
        _rightMonth = month;
        if (!_leftMonth.isBefore(month)) {
          _leftMonth = DateTime(month.year, month.month - 1, 1);
        }
      }
    });
  }

  RdsDateRange? get _hoverRange {
    if (!_awaitingEnd || _hoverDate == null) return null;
    return _currentRange;
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
      child: LayoutBuilder(builder: (context, constraints) {
        final narrow = constraints.maxWidth < 640;

        final leftGrid = SizedBox(
          width: 304,
          child: RdsCalendarGrid(
            displayMonth: _leftMonth,
            highlightRange: _currentRange,
            hoverDate: _awaitingEnd ? _hoverDate : null,
            minDate: widget.minDate,
            maxDate: widget.maxDate,
            firstDayOfWeek: widget.firstDayOfWeek,
            onDaySelected: _handleDaySelected,
            onDayHovered: (d) => setState(() => _hoverDate = d),
            onMonthChanged: (m) => _handleMonthChanged(m, isLeft: true),
          ),
        );

        final rightGrid = SizedBox(
          width: 304,
          child: RdsCalendarGrid(
            displayMonth: _rightMonth,
            highlightRange: _currentRange,
            hoverDate: _awaitingEnd ? _hoverDate : null,
            minDate: widget.minDate,
            maxDate: widget.maxDate,
            firstDayOfWeek: widget.firstDayOfWeek,
            onDaySelected: _handleDaySelected,
            onDayHovered: (d) => setState(() => _hoverDate = d),
            onMonthChanged: (m) => _handleMonthChanged(m, isLeft: false),
          ),
        );

        if (narrow) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              leftGrid,
              SizedBox(height: rds.space4),
              Divider(color: rds.outlineVariant),
              SizedBox(height: rds.space4),
              rightGrid,
            ],
          );
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            leftGrid,
            SizedBox(width: rds.space6),
            VerticalDivider(
              color: rds.outlineVariant,
              width: 1,
            ),
            SizedBox(width: rds.space6),
            rightGrid,
          ],
        );
      }),
    );
  }
}
