import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../theme/rds_theme.dart';
import '../../tokens/rds_icons.dart';
import '../../tokens/rds_shadows.dart';

import 'rds_picker_models.dart';

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

/// A single-month calendar grid shared by [RdsDatePicker], [RdsDateRangePicker],
/// and [RdsDateTimePicker].
///
/// The grid shows the month header (year/month label with prev/next navigation),
/// abbreviated weekday labels, and the day cells. Callers provide callbacks to
/// handle day selection and month navigation. Range highlighting is controlled
/// via [highlightRange] and [hoverDate].
class RdsCalendarGrid extends StatefulWidget {
  const RdsCalendarGrid({
    super.key,
    required this.displayMonth,
    this.selectedDate,
    this.highlightRange,
    this.hoverDate,
    this.minDate,
    this.maxDate,
    this.firstDayOfWeek = 1,
    this.onDaySelected,
    this.onDayHovered,
    this.onMonthChanged,
    this.showMonthYearHeader = true,
    this.showNavigation = true,
  });

  /// The month/year currently displayed in this grid.
  final DateTime displayMonth;

  /// The single selected date (used in non-range mode).
  final DateTime? selectedDate;

  /// The selected range (used in range mode).
  final RdsDateRange? highlightRange;

  /// The date being hovered during range selection (shows preview strip).
  final DateTime? hoverDate;

  /// The earliest selectable date (days before this are disabled).
  final DateTime? minDate;

  /// The latest selectable date (days after this are disabled).
  final DateTime? maxDate;

  /// First day of the week. 0 = Sunday, 1 = Monday.
  final int firstDayOfWeek;

  /// Called when the user taps a day cell.
  final ValueChanged<DateTime>? onDaySelected;

  /// Called when the pointer enters a day cell (used for range preview).
  final ValueChanged<DateTime>? onDayHovered;

  /// Called when the user navigates to a different month.
  /// Passes the new [DateTime] representing the first day of the new month.
  final ValueChanged<DateTime>? onMonthChanged;

  /// Whether to show the month/year header with navigation arrows.
  final bool showMonthYearHeader;

  /// Whether to show prev/next navigation arrows in the header.
  final bool showNavigation;

  @override
  State<RdsCalendarGrid> createState() => _RdsCalendarGridState();
}

class _RdsCalendarGridState extends State<RdsCalendarGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;
  DateTime? _prevDisplayMonth;
  int _slideDirection = 1; // +1 = slide left (forward), -1 = slide right (back)

  // Month/Year selector overlay state
  bool _showingMonthYearSelector = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _slideAnimation = Tween<double>(begin: 0, end: 0).animate(_slideController);
  }

  @override
  void didUpdateWidget(RdsCalendarGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.displayMonth.year != widget.displayMonth.year ||
        oldWidget.displayMonth.month != widget.displayMonth.month) {
      _prevDisplayMonth = oldWidget.displayMonth;
      _slideDirection = widget.displayMonth.isAfter(oldWidget.displayMonth) ? 1 : -1;
      _slideController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _goToPrevMonth() {
    if (widget.onMonthChanged == null) return;
    final current = widget.displayMonth;
    widget.onMonthChanged!(DateTime(current.year, current.month - 1, 1));
  }

  void _goToNextMonth() {
    if (widget.onMonthChanged == null) return;
    final current = widget.displayMonth;
    widget.onMonthChanged!(DateTime(current.year, current.month + 1, 1));
  }

  bool _isDayDisabled(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    if (widget.minDate != null) {
      final min = DateTime(
          widget.minDate!.year, widget.minDate!.month, widget.minDate!.day);
      if (d.isBefore(min)) return true;
    }
    if (widget.maxDate != null) {
      final max = DateTime(
          widget.maxDate!.year, widget.maxDate!.month, widget.maxDate!.day);
      if (d.isAfter(max)) return true;
    }
    return false;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSelected(DateTime date) {
    if (widget.selectedDate == null) return false;
    return date.year == widget.selectedDate!.year &&
        date.month == widget.selectedDate!.month &&
        date.day == widget.selectedDate!.day;
  }

  bool _isRangeStart(DateTime date) =>
      widget.highlightRange?.isStart(date) ?? false;

  bool _isRangeEnd(DateTime date) =>
      widget.highlightRange?.isEnd(date) ?? false;

  bool _isInRange(DateTime date) =>
      widget.highlightRange?.contains(date) ?? false;

  /// Returns true if [date] is in the preview hover range
  bool _isInHoverRange(DateTime date) {
    if (widget.hoverDate == null) return false;
    final range = widget.highlightRange;
    // Only show preview if exactly one endpoint is set
    if (range == null) return false;
    if (range.start != null && range.end == null) {
      final start = DateTime(range.start!.year, range.start!.month, range.start!.day);
      final hover = DateTime(
          widget.hoverDate!.year, widget.hoverDate!.month, widget.hoverDate!.day);
      final d = DateTime(date.year, date.month, date.day);
      if (hover.isAfter(start)) {
        return !d.isBefore(start) && !d.isAfter(hover);
      } else {
        return !d.isBefore(hover) && !d.isAfter(start);
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showMonthYearHeader) _buildHeader(rds),
        SizedBox(height: rds.space2),
        _buildWeekdayRow(rds),
        SizedBox(height: rds.space1),
        AnimatedBuilder(
          animation: _slideController,
          builder: (context, child) {
            return ClipRect(
              child: _buildDayGrid(rds),
            );
          },
        ),
        if (_showingMonthYearSelector)
          _MonthYearSelector(
            displayMonth: widget.displayMonth,
            minDate: widget.minDate,
            maxDate: widget.maxDate,
            onSelected: (dt) {
              setState(() => _showingMonthYearSelector = false);
              widget.onMonthChanged?.call(dt);
            },
            onDismiss: () =>
                setState(() => _showingMonthYearSelector = false),
          ),
      ],
    );
  }

  Widget _buildHeader(RdsTheme rds) {
    final monthName = _monthName(widget.displayMonth.month);
    final year = widget.displayMonth.year.toString();

    return Row(
      children: [
        if (widget.showNavigation)
          _NavButton(
            icon: RdsIcons.chevronLeft,
            tooltip: 'Previous month',
            onPressed: _goToPrevMonth,
          ),
        Expanded(
          child: GestureDetector(
            onTap: () =>
                setState(() => _showingMonthYearSelector = !_showingMonthYearSelector),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$monthName $year',
                      style: rds.titleSmall.copyWith(color: rds.onSurface),
                    ),
                    SizedBox(width: rds.space1),
                    Icon(
                      _showingMonthYearSelector
                          ? RdsIcons.chevronUp
                          : RdsIcons.chevronDown,
                      size: 16,
                      color: rds.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (widget.showNavigation)
          _NavButton(
            icon: RdsIcons.chevronRight,
            tooltip: 'Next month',
            onPressed: _goToNextMonth,
          ),
      ],
    );
  }

  Widget _buildWeekdayRow(RdsTheme rds) {
    final labels = _weekdayLabels(widget.firstDayOfWeek);
    return Row(
      children: labels.map((label) {
        return Expanded(
          child: Center(
            child: Text(
              label,
              style: rds.labelSmall.copyWith(color: rds.onSurfaceMuted),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDayGrid(RdsTheme rds) {
    final days = _buildCalendarDays(widget.displayMonth, widget.firstDayOfWeek);
    final rows = <Widget>[];

    for (var r = 0; r < days.length; r += 7) {
      final week = days.sublist(r, math.min(r + 7, days.length));
      rows.add(
        Row(
          children: week.map((day) {
            if (day == null) {
              return const Expanded(child: SizedBox(height: 40));
            }
            return Expanded(
              child: _DayCell(
                date: day,
                isToday: _isToday(day),
                isSelected: _isSelected(day),
                isRangeStart: _isRangeStart(day),
                isRangeEnd: _isRangeEnd(day),
                isInRange: _isInRange(day),
                isInHoverRange: _isInHoverRange(day),
                isDisabled: _isDayDisabled(day),
                isOtherMonth: day.month != widget.displayMonth.month,
                onTap: _isDayDisabled(day) || day.month != widget.displayMonth.month
                    ? null
                    : () => widget.onDaySelected?.call(day),
                onHover: day.month != widget.displayMonth.month
                    ? null
                    : (hovered) {
                        if (hovered) widget.onDayHovered?.call(day);
                      },
              ),
            );
          }).toList(),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }
}

// ---------------------------------------------------------------------------
// Day cell
// ---------------------------------------------------------------------------

class _DayCell extends StatefulWidget {
  const _DayCell({
    required this.date,
    required this.isToday,
    required this.isSelected,
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.isInRange,
    required this.isInHoverRange,
    required this.isDisabled,
    required this.isOtherMonth,
    this.onTap,
    this.onHover,
  });

  final DateTime date;
  final bool isToday;
  final bool isSelected;
  final bool isRangeStart;
  final bool isRangeEnd;
  final bool isInRange;
  final bool isInHoverRange;
  final bool isDisabled;
  final bool isOtherMonth;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onHover;

  @override
  State<_DayCell> createState() => _DayCellState();
}

class _DayCellState extends State<_DayCell> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    final isSelectedOrEndpoint =
        widget.isSelected || widget.isRangeStart || widget.isRangeEnd;
    final inRange = widget.isInRange || widget.isInHoverRange;

    Color? cellBg;
    Color textColor;
    BoxBorder? cellBorder;
    bool showRangeStrip = false;
    bool isStripStart = false;
    bool isStripEnd = false;

    if (widget.isDisabled || widget.isOtherMonth) {
      textColor = rds.onSurface.withOpacity(rds.opacityDisabled);
    } else if (isSelectedOrEndpoint) {
      cellBg = rds.primary;
      textColor = rds.onPrimary;
    } else if (inRange) {
      showRangeStrip = true;
      textColor = rds.onPrimaryContainer;
    } else if (widget.isToday) {
      cellBorder = Border.all(color: rds.outline, width: 1);
      textColor = rds.onSurface;
    } else {
      textColor = rds.onSurface;
    }

    if (inRange && !isSelectedOrEndpoint) {
      isStripStart = widget.isRangeStart ||
          (widget.date.weekday == (widget.date.weekday)); // always fill strip for mid-range
      isStripEnd = widget.isRangeEnd;
    }

    // Determine which part of the range strip to show (rounded left/right/none)
    final isRangeLeft = widget.isRangeStart;
    final isRangeRight = widget.isRangeEnd;

    Widget cell = SizedBox(
      height: 40,
      child: Stack(
        children: [
          // Range strip background
          if (showRangeStrip)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: rds.primaryContainer,
                  borderRadius: BorderRadius.horizontal(
                    left: isRangeLeft ? const Radius.circular(9999) : Radius.zero,
                    right: isRangeRight ? const Radius.circular(9999) : Radius.zero,
                  ),
                ),
              ),
            ),
          // Hover overlay
          if (_hovered && !widget.isDisabled && !widget.isOtherMonth)
            Positioned.fill(
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: rds.onSurface.withOpacity(rds.stateHover),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          // Day circle background (selected/today)
          Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cellBg,
                shape: BoxShape.circle,
                border: cellBorder,
              ),
              alignment: Alignment.center,
              child: Text(
                '${widget.date.day}',
                style: rds.bodyMedium.copyWith(
                  color: textColor,
                  fontWeight: isSelectedOrEndpoint ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (widget.onTap == null) return cell;

    return Semantics(
      label: _semanticLabel(widget.date),
      selected: widget.isSelected || widget.isRangeStart || widget.isRangeEnd,
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => _hovered = true);
          widget.onHover?.call(true);
        },
        onExit: (_) {
          setState(() => _hovered = false);
          widget.onHover?.call(false);
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: cell,
        ),
      ),
    );
  }

  String _semanticLabel(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// ---------------------------------------------------------------------------
// Month/Year selector overlay
// ---------------------------------------------------------------------------

class _MonthYearSelector extends StatefulWidget {
  const _MonthYearSelector({
    required this.displayMonth,
    this.minDate,
    this.maxDate,
    required this.onSelected,
    required this.onDismiss,
  });

  final DateTime displayMonth;
  final DateTime? minDate;
  final DateTime? maxDate;
  final ValueChanged<DateTime> onSelected;
  final VoidCallback onDismiss;

  @override
  State<_MonthYearSelector> createState() => _MonthYearSelectorState();
}

class _MonthYearSelectorState extends State<_MonthYearSelector> {
  late int _selectedYear;
  late ScrollController _yearScrollController;

  static const double _yearItemHeight = 40.0;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.displayMonth.year;
    final minYear = widget.minDate?.year ?? (_selectedYear - 50);
    final offset = (_selectedYear - minYear - 2).clamp(0, 9999).toDouble();
    _yearScrollController = ScrollController(
      initialScrollOffset: offset * _yearItemHeight,
    );
  }

  @override
  void dispose() {
    _yearScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final minYear = widget.minDate?.year ?? (_selectedYear - 50);
    final maxYear = widget.maxDate?.year ?? (_selectedYear + 50);
    final years = List.generate(maxYear - minYear + 1, (i) => minYear + i);

    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return Material(
      color: rds.surface,
      elevation: 0,
      borderRadius: BorderRadius.circular(rds.radiusLg),
      child: Container(
        padding: EdgeInsets.all(rds.space3),
        decoration: BoxDecoration(
          color: rds.surface,
          borderRadius: BorderRadius.circular(rds.radiusLg),
          border: Border.all(color: rds.outlineVariant),
          boxShadow: RdsShadows.shadowSm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month grid
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Month', style: rds.labelSmall.copyWith(color: rds.onSurfaceMuted)),
                  SizedBox(height: rds.space2),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: rds.space1,
                    crossAxisSpacing: rds.space1,
                    childAspectRatio: 2.2,
                    children: List.generate(12, (i) {
                      final isSelected = i + 1 == widget.displayMonth.month &&
                          _selectedYear == widget.displayMonth.year;
                      return GestureDetector(
                        onTap: () => widget.onSelected(
                            DateTime(_selectedYear, i + 1, 1)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? rds.primary : Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(rds.radiusSm),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            monthNames[i],
                            style: rds.labelMedium.copyWith(
                              color: isSelected ? rds.onPrimary : rds.onSurface,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            SizedBox(width: rds.space3),
            // Year scroll list
            SizedBox(
              width: 72,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Year', style: rds.labelSmall.copyWith(color: rds.onSurfaceMuted)),
                  SizedBox(height: rds.space2),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      controller: _yearScrollController,
                      itemCount: years.length,
                      itemExtent: _yearItemHeight,
                      itemBuilder: (context, index) {
                        final year = years[index];
                        final isSelected = year == _selectedYear;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedYear = year),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? rds.primaryContainer
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius.circular(rds.radiusSm),
                            ),
                            child: Text(
                              year.toString(),
                              style: rds.bodyMedium.copyWith(
                                color: isSelected
                                    ? rds.onPrimaryContainer
                                    : rds.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Navigation button
// ---------------------------------------------------------------------------

class _NavButton extends StatefulWidget {
  const _NavButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _hovered
                  ? rds.onSurface.withOpacity(rds.stateHover)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              widget.icon,
              size: 20,
              color: rds.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Calendar computation helpers
// ---------------------------------------------------------------------------

/// Returns abbreviated weekday labels starting from [firstDayOfWeek].
/// 0 = Sunday, 1 = Monday.
List<String> _weekdayLabels(int firstDayOfWeek) {
  const all = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
  return [
    ...all.sublist(firstDayOfWeek),
    ...all.sublist(0, firstDayOfWeek),
  ];
}

/// Returns a flat list of 35 or 42 [DateTime?] values representing the grid
/// cells for the given [month]. Leading/trailing cells are null or fall in
/// adjacent months.
List<DateTime?> _buildCalendarDays(DateTime month, int firstDayOfWeek) {
  final firstOfMonth = DateTime(month.year, month.month, 1);
  final lastOfMonth =
      DateTime(month.year, month.month + 1, 0); // day 0 of next month

  // Dart: Monday=1 … Sunday=7
  // Convert to 0-based: Sunday=0, Monday=1 … Saturday=6
  int startWeekday = firstOfMonth.weekday % 7; // 0=Sun,1=Mon,...,6=Sat
  int leadingEmpty = (startWeekday - firstDayOfWeek + 7) % 7;

  final result = <DateTime?>[];

  // Leading null cells
  for (var i = 0; i < leadingEmpty; i++) {
    result.add(null);
  }

  // Month days
  for (var d = 1; d <= lastOfMonth.day; d++) {
    result.add(DateTime(month.year, month.month, d));
  }

  // Trailing nulls to fill last row
  while (result.length % 7 != 0) {
    result.add(null);
  }

  return result;
}

/// Full month name for the calendar header.
String _monthName(int month) {
  const names = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  return names[month - 1];
}
