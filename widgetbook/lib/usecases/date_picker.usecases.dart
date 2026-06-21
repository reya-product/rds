import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

// ---------------------------------------------------------------------------
// Exports
// ---------------------------------------------------------------------------

/// All date/time picker use cases bundled into a single [WidgetbookComponent].
final datePickerComponent = WidgetbookComponent(
  name: 'Date Picker',
  useCases: [
    WidgetbookUseCase(
      name: 'Single date — Playground',
      builder: _singlePlayground,
    ),
    WidgetbookUseCase(
      name: 'Date range — Playground',
      builder: _rangePlayground,
    ),
    WidgetbookUseCase(
      name: 'Date + time — Playground',
      builder: _dateTimePlayground,
    ),
    WidgetbookUseCase(
      name: 'Time picker — Dial',
      builder: _timeDialPlayground,
    ),
    WidgetbookUseCase(
      name: 'Time picker — Input',
      builder: _timeInputPlayground,
    ),
    WidgetbookUseCase(
      name: 'Gallery',
      builder: _gallery,
    ),
  ],
);

// ---------------------------------------------------------------------------
// Single date picker — playground
// ---------------------------------------------------------------------------

Widget _singlePlayground(BuildContext context) {
  final firstDayOfWeek = context.knobs.list<int>(
    label: 'First day of week',
    options: [0, 1],
    initialOption: 1,
    labelBuilder: (v) => v == 0 ? 'Sunday' : 'Monday',
  );

  return _PickerHost(
    builder: (value, onChanged) => RdsDatePicker(
      value: value as DateTime?,
      onChanged: onChanged,
      firstDayOfWeek: firstDayOfWeek,
      minDate: DateTime(2020, 1, 1),
      maxDate: DateTime(2030, 12, 31),
    ),
  );
}

// ---------------------------------------------------------------------------
// Date range picker — playground
// ---------------------------------------------------------------------------

Widget _rangePlayground(BuildContext context) {
  final firstDayOfWeek = context.knobs.list<int>(
    label: 'First day of week',
    options: [0, 1],
    initialOption: 1,
    labelBuilder: (v) => v == 0 ? 'Sunday' : 'Monday',
  );

  return _RangePickerHost(firstDayOfWeek: firstDayOfWeek);
}

// ---------------------------------------------------------------------------
// Date + time picker — playground
// ---------------------------------------------------------------------------

Widget _dateTimePlayground(BuildContext context) {
  final use24h = context.knobs.boolean(
    label: '24-hour format',
    initialValue: false,
  );
  final firstDayOfWeek = context.knobs.list<int>(
    label: 'First day of week',
    options: [0, 1],
    initialOption: 1,
    labelBuilder: (v) => v == 0 ? 'Sunday' : 'Monday',
  );

  return _DateTimePickerHost(
    use24HourFormat: use24h,
    firstDayOfWeek: firstDayOfWeek,
  );
}

// ---------------------------------------------------------------------------
// Time picker — dial
// ---------------------------------------------------------------------------

Widget _timeDialPlayground(BuildContext context) {
  final use24h = context.knobs.boolean(
    label: '24-hour format',
    initialValue: false,
  );

  return _TimePickerHost(
    mode: RdsPickerMode.dial,
    use24HourFormat: use24h,
  );
}

// ---------------------------------------------------------------------------
// Time picker — input
// ---------------------------------------------------------------------------

Widget _timeInputPlayground(BuildContext context) {
  final use24h = context.knobs.boolean(
    label: '24-hour format',
    initialValue: false,
  );

  return _TimePickerHost(
    mode: RdsPickerMode.input,
    use24HourFormat: use24h,
  );
}

// ---------------------------------------------------------------------------
// Gallery — all variants side by side
// ---------------------------------------------------------------------------

Widget _gallery(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GallerySection(
            title: 'Date Picker (single)',
            child: RdsDatePicker(
              value: DateTime(2024, 6, 15),
              onChanged: (_) {},
            ),
          ),
          SizedBox(height: rds.space8),
          _GallerySection(
            title: 'Time Picker — Dial',
            child: RdsTimePicker(
              value: const TimeOfDay(hour: 9, minute: 30),
              onChanged: (_) {},
              mode: RdsPickerMode.dial,
              use24HourFormat: false,
            ),
          ),
          SizedBox(height: rds.space8),
          _GallerySection(
            title: 'Time Picker — Input (24h)',
            child: RdsTimePicker(
              value: const TimeOfDay(hour: 14, minute: 45),
              onChanged: (_) {},
              mode: RdsPickerMode.input,
              use24HourFormat: true,
            ),
          ),
          SizedBox(height: rds.space8),
          _GallerySection(
            title: 'Date + Time Picker',
            child: RdsDateTimePicker(
              value: DateTime(2024, 6, 15, 9, 30),
              onChanged: (_) {},
              use24HourFormat: false,
            ),
          ),
          SizedBox(height: rds.space8),
          _GallerySection(
            title: 'Date Range Picker',
            child: _RangePickerHost(firstDayOfWeek: 1),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Host widgets (stateful wrappers for Widgetbook use cases)
// ---------------------------------------------------------------------------

/// Generic host for widgets that track a single [DateTime?] value.
class _PickerHost extends StatefulWidget {
  const _PickerHost({required this.builder});

  final Widget Function(Object? value, ValueChanged<DateTime> onChanged)
      builder;

  @override
  State<_PickerHost> createState() => _PickerHostState();
}

class _PickerHostState extends State<_PickerHost> {
  DateTime? _value;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.builder(_value, (d) => setState(() => _value = d)),
            SizedBox(height: rds.space4),
            if (_value != null)
              Text(
                'Selected: ${_value!.year}-${_value!.month.toString().padLeft(2, '0')}-${_value!.day.toString().padLeft(2, '0')}',
                style: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
              )
            else
              Text(
                'No date selected',
                style: rds.bodyMedium.copyWith(color: rds.onSurfaceMuted),
              ),
          ],
        ),
      ),
    );
  }
}

/// Host for the date range picker.
class _RangePickerHost extends StatefulWidget {
  const _RangePickerHost({required this.firstDayOfWeek});

  final int firstDayOfWeek;

  @override
  State<_RangePickerHost> createState() => _RangePickerHostState();
}

class _RangePickerHostState extends State<_RangePickerHost> {
  RdsDateRange _range = const RdsDateRange();

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RdsDateRangePicker(
              startDate: _range.start,
              endDate: _range.end,
              onChanged: (r) => setState(() => _range = r),
              firstDayOfWeek: widget.firstDayOfWeek,
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2030, 12, 31),
            ),
            SizedBox(height: rds.space4),
            _buildRangeLabel(rds),
          ],
        ),
      ),
    );
  }

  Widget _buildRangeLabel(RdsTheme rds) {
    if (_range.start == null && _range.end == null) {
      return Text(
        'No range selected',
        style: rds.bodyMedium.copyWith(color: rds.onSurfaceMuted),
      );
    }
    final start = _range.start != null
        ? '${_range.start!.year}-${_range.start!.month.toString().padLeft(2, '0')}-${_range.start!.day.toString().padLeft(2, '0')}'
        : '—';
    final end = _range.end != null
        ? '${_range.end!.year}-${_range.end!.month.toString().padLeft(2, '0')}-${_range.end!.day.toString().padLeft(2, '0')}'
        : 'pick end date…';
    return Text(
      '$start → $end',
      style: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
    );
  }
}

/// Host for the date+time picker.
class _DateTimePickerHost extends StatefulWidget {
  const _DateTimePickerHost({
    required this.use24HourFormat,
    required this.firstDayOfWeek,
  });

  final bool use24HourFormat;
  final int firstDayOfWeek;

  @override
  State<_DateTimePickerHost> createState() => _DateTimePickerHostState();
}

class _DateTimePickerHostState extends State<_DateTimePickerHost> {
  DateTime? _value;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(rds.space6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RdsDateTimePicker(
                value: _value,
                onChanged: (dt) => setState(() => _value = dt),
                use24HourFormat: widget.use24HourFormat,
                firstDayOfWeek: widget.firstDayOfWeek,
                minDate: DateTime(2020, 1, 1),
                maxDate: DateTime(2030, 12, 31),
              ),
              SizedBox(height: rds.space4),
              if (_value != null)
                Text(
                  'Selected: ${_value!.year}-'
                  '${_value!.month.toString().padLeft(2, '0')}-'
                  '${_value!.day.toString().padLeft(2, '0')} '
                  '${_value!.hour.toString().padLeft(2, '0')}:'
                  '${_value!.minute.toString().padLeft(2, '0')}',
                  style:
                      rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
                )
              else
                Text(
                  'No date/time selected',
                  style:
                      rds.bodyMedium.copyWith(color: rds.onSurfaceMuted),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Host for the time picker.
class _TimePickerHost extends StatefulWidget {
  const _TimePickerHost({
    required this.mode,
    required this.use24HourFormat,
  });

  final RdsPickerMode mode;
  final bool use24HourFormat;

  @override
  State<_TimePickerHost> createState() => _TimePickerHostState();
}

class _TimePickerHostState extends State<_TimePickerHost> {
  TimeOfDay? _value;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RdsTimePicker(
              value: _value,
              onChanged: (t) => setState(() => _value = t),
              mode: widget.mode,
              use24HourFormat: widget.use24HourFormat,
            ),
            SizedBox(height: rds.space4),
            if (_value != null)
              Text(
                'Selected: ${_value!.hour.toString().padLeft(2, '0')}:${_value!.minute.toString().padLeft(2, '0')}',
                style:
                    rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
              )
            else
              Text(
                'No time selected',
                style: rds.bodyMedium.copyWith(color: rds.onSurfaceMuted),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Gallery helper widgets
// ---------------------------------------------------------------------------

class _GallerySection extends StatelessWidget {
  const _GallerySection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: rds.titleMedium.copyWith(color: rds.onSurface),
        ),
        SizedBox(height: rds.space3),
        child,
      ],
    );
  }
}
