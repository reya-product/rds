/// Shared data models and enums for RDS date/time picker components.
library;

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// The interaction mode for [RdsTimePicker].
enum RdsPickerMode {
  /// Clock dial with a draggable hour/minute hand.
  dial,

  /// Numeric text inputs for hour and minute.
  input,
}

// ---------------------------------------------------------------------------
// Data classes
// ---------------------------------------------------------------------------

/// An immutable date range with optional [start] and [end] dates.
class RdsDateRange {
  final DateTime? start;
  final DateTime? end;

  const RdsDateRange({this.start, this.end});

  /// Returns true when both [start] and [end] are non-null and [start] is not
  /// after [end].
  bool get isComplete =>
      start != null && end != null && !start!.isAfter(end!);

  /// Returns true when [date] falls within this range (inclusive of endpoints).
  bool contains(DateTime date) {
    if (start == null || end == null) return false;
    final d = DateTime(date.year, date.month, date.day);
    final s = DateTime(start!.year, start!.month, start!.day);
    final e = DateTime(end!.year, end!.month, end!.day);
    return !d.isBefore(s) && !d.isAfter(e);
  }

  /// Returns true when [date] is the start date (day precision).
  bool isStart(DateTime date) {
    if (start == null) return false;
    return _sameDay(date, start!);
  }

  /// Returns true when [date] is the end date (day precision).
  bool isEnd(DateTime date) {
    if (end == null) return false;
    return _sameDay(date, end!);
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  RdsDateRange copyWith({DateTime? start, DateTime? end}) =>
      RdsDateRange(start: start ?? this.start, end: end ?? this.end);

  @override
  String toString() => 'RdsDateRange(start: $start, end: $end)';
}
