import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/rds_theme.dart';
import '../../tokens/rds_icons.dart';
import '../../tokens/rds_shadows.dart';

import 'rds_picker_models.dart';
import 'rds_time_dial.dart';

export 'rds_picker_models.dart';

// ---------------------------------------------------------------------------
// RdsTimePicker
// ---------------------------------------------------------------------------

/// A standalone time picker supporting two interaction modes:
/// - [RdsPickerMode.dial]: M3-inspired circular clock face with draggable hand.
/// - [RdsPickerMode.input]: Numeric text inputs for H and MM, with AM/PM toggle.
///
/// ```dart
/// RdsTimePicker(
///   value: _time,
///   onChanged: (t) => setState(() => _time = t),
///   use24HourFormat: false,
///   mode: RdsPickerMode.dial,
/// )
/// ```
class RdsTimePicker extends StatefulWidget {
  const RdsTimePicker({
    super.key,
    this.value,
    this.onChanged,
    this.use24HourFormat = false,
    this.mode = RdsPickerMode.dial,
  });

  /// The currently selected time. Null means no selection.
  final TimeOfDay? value;

  /// Called when the user picks a time.
  final ValueChanged<TimeOfDay>? onChanged;

  /// Whether to use 24-hour (true) or 12-hour AM/PM (false) format.
  final bool use24HourFormat;

  /// Interaction mode: clock dial or numeric text inputs.
  final RdsPickerMode mode;

  @override
  State<RdsTimePicker> createState() => _RdsTimePickerState();
}

class _RdsTimePickerState extends State<RdsTimePicker> {
  late int _hour;
  late int _minute;
  bool _selectingMinute = false;

  @override
  void initState() {
    super.initState();
    final now = widget.value ?? TimeOfDay.now();
    _hour = now.hour;
    _minute = now.minute;
  }

  @override
  void didUpdateWidget(RdsTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null &&
        (widget.value!.hour != _hour || widget.value!.minute != _minute)) {
      _hour = widget.value!.hour;
      _minute = widget.value!.minute;
    }
  }

  TimeOfDay get _currentTime => TimeOfDay(hour: _hour, minute: _minute);

  void _setHour(int h) {
    setState(() => _hour = h);
    widget.onChanged?.call(TimeOfDay(hour: h, minute: _minute));
  }

  void _setMinute(int m) {
    setState(() => _minute = m);
    widget.onChanged?.call(TimeOfDay(hour: _hour, minute: m));
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
        children: [
          _buildTimeHeader(rds),
          SizedBox(height: rds.space4),
          if (widget.mode == RdsPickerMode.dial)
            _buildDial(rds)
          else
            _buildInputMode(rds),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Shared time header: shows HH : MM with AM/PM toggle
  // ---------------------------------------------------------------------------

  Widget _buildTimeHeader(RdsTheme rds) {
    final displayHour = widget.use24HourFormat
        ? _hour
        : (_hour % 12 == 0 ? 12 : _hour % 12);
    final isPm = _hour >= 12;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hour button
        Semantics(
          label: 'Hour: $displayHour',
          selected: !_selectingMinute && widget.mode == RdsPickerMode.dial,
          button: true,
          child: _TimeSegmentButton(
            value: displayHour.toString().padLeft(2, '0'),
            isActive: !_selectingMinute && widget.mode == RdsPickerMode.dial,
            onTap: widget.mode == RdsPickerMode.dial
                ? () => setState(() => _selectingMinute = false)
                : null,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: rds.space1),
          child: Text(
            ':',
            style: rds.displaySmall.copyWith(color: rds.onSurfaceVariant),
          ),
        ),
        // Minute button
        Semantics(
          label: 'Minute: $_minute',
          selected: _selectingMinute && widget.mode == RdsPickerMode.dial,
          button: true,
          child: _TimeSegmentButton(
            value: _minute.toString().padLeft(2, '0'),
            isActive: _selectingMinute && widget.mode == RdsPickerMode.dial,
            onTap: widget.mode == RdsPickerMode.dial
                ? () => setState(() => _selectingMinute = true)
                : null,
          ),
        ),
        if (!widget.use24HourFormat) ...[
          SizedBox(width: rds.space3),
          _AmPmToggle(
            isPm: isPm,
            onToggle: (pm) {
              final newHour = pm
                  ? (_hour % 12) + 12
                  : _hour % 12;
              _setHour(newHour);
            },
          ),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Dial mode
  // ---------------------------------------------------------------------------

  Widget _buildDial(RdsTheme rds) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 256,
          height: 256,
          child: RdsTimeDial(
            hour: _hour,
            minute: _minute,
            selectingMinute: _selectingMinute,
            use24HourFormat: widget.use24HourFormat,
            onHourChanged: _setHour,
            onMinuteChanged: _setMinute,
            onSelectionConfirmed: () {
              // Auto-switch to minute selection after hour is set
              if (!_selectingMinute) {
                setState(() => _selectingMinute = true);
              }
            },
          ),
        ),
        SizedBox(height: rds.space3),
        Text(
          _selectingMinute ? 'Select minute' : 'Select hour',
          style: rds.bodySmall.copyWith(color: rds.onSurfaceMuted),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Input mode
  // ---------------------------------------------------------------------------

  Widget _buildInputMode(RdsTheme rds) {
    final displayHour = widget.use24HourFormat
        ? _hour
        : (_hour % 12 == 0 ? 12 : _hour % 12);
    final maxHour = widget.use24HourFormat ? 23 : 12;
    final minHour = widget.use24HourFormat ? 0 : 1;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _TimeInput(
          label: 'HH',
          value: displayHour,
          min: minHour,
          max: maxHour,
          onChanged: (v) {
            if (widget.use24HourFormat) {
              _setHour(v);
            } else {
              final isPm = _hour >= 12;
              final newHour =
                  isPm ? (v == 12 ? 12 : v + 12) : (v == 12 ? 0 : v);
              _setHour(newHour);
            }
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: rds.space2),
          child: Text(
            ':',
            style: rds.headlineMedium.copyWith(color: rds.onSurface),
          ),
        ),
        _TimeInput(
          label: 'MM',
          value: _minute,
          min: 0,
          max: 59,
          onChanged: _setMinute,
        ),
        if (!widget.use24HourFormat) ...[
          SizedBox(width: rds.space3),
          _AmPmToggle(
            isPm: _hour >= 12,
            onToggle: (pm) {
              final newHour = pm ? (_hour % 12) + 12 : _hour % 12;
              _setHour(newHour);
            },
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Time segment button (in header, tappable in dial mode)
// ---------------------------------------------------------------------------

class _TimeSegmentButton extends StatefulWidget {
  const _TimeSegmentButton({
    required this.value,
    required this.isActive,
    this.onTap,
  });

  final String value;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  State<_TimeSegmentButton> createState() => _TimeSegmentButtonState();
}

class _TimeSegmentButtonState extends State<_TimeSegmentButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: rds.durationStandard,
          curve: rds.curveStandard,
          padding: EdgeInsets.symmetric(
            horizontal: rds.space3,
            vertical: rds.space2,
          ),
          decoration: BoxDecoration(
            color: widget.isActive
                ? rds.primaryContainer
                : _hovered
                    ? rds.onSurface.withOpacity(rds.stateHover)
                    : rds.surfaceContainer,
            borderRadius: BorderRadius.circular(rds.radiusMd),
          ),
          child: Text(
            widget.value,
            style: rds.displaySmall.copyWith(
              color: widget.isActive ? rds.onPrimaryContainer : rds.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AM/PM toggle
// ---------------------------------------------------------------------------

class _AmPmToggle extends StatelessWidget {
  const _AmPmToggle({
    required this.isPm,
    required this.onToggle,
  });

  final bool isPm;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: rds.outline),
        borderRadius: BorderRadius.circular(rds.radiusMd),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AmPmOption(
            label: 'AM',
            isSelected: !isPm,
            isTop: true,
            onTap: () => onToggle(false),
          ),
          Divider(height: 1, thickness: 1, color: rds.outline),
          _AmPmOption(
            label: 'PM',
            isSelected: isPm,
            isTop: false,
            onTap: () => onToggle(true),
          ),
        ],
      ),
    );
  }
}

class _AmPmOption extends StatefulWidget {
  const _AmPmOption({
    required this.label,
    required this.isSelected,
    required this.isTop,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isTop;
  final VoidCallback onTap;

  @override
  State<_AmPmOption> createState() => _AmPmOptionState();
}

class _AmPmOptionState extends State<_AmPmOption> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Semantics(
      label: widget.label,
      selected: widget.isSelected,
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: rds.durationFast,
            width: 52,
            padding: EdgeInsets.symmetric(vertical: rds.space2),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? rds.primaryContainer
                  : _hovered
                      ? rds.onSurface.withOpacity(rds.stateHover)
                      : Colors.transparent,
              borderRadius: widget.isTop
                  ? BorderRadius.vertical(
                      top: Radius.circular(rds.radiusMd - 1))
                  : BorderRadius.vertical(
                      bottom: Radius.circular(rds.radiusMd - 1)),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.label,
              style: rds.labelMedium.copyWith(
                color: widget.isSelected
                    ? rds.onPrimaryContainer
                    : rds.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Numeric time input (spinner)
// ---------------------------------------------------------------------------

class _TimeInput extends StatefulWidget {
  const _TimeInput({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  State<_TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends State<_TimeInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.value.toString().padLeft(2, '0'));
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
      if (!_focusNode.hasFocus) _commitValue();
    });
  }

  @override
  void didUpdateWidget(_TimeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_focused) {
      _controller.text = widget.value.toString().padLeft(2, '0');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _commitValue() {
    final parsed = int.tryParse(_controller.text.trim());
    if (parsed != null) {
      final clamped = parsed.clamp(widget.min, widget.max);
      widget.onChanged(clamped);
      _controller.text = clamped.toString().padLeft(2, '0');
    } else {
      _controller.text = widget.value.toString().padLeft(2, '0');
    }
  }

  void _increment() {
    final next = widget.value >= widget.max ? widget.min : widget.value + 1;
    widget.onChanged(next);
  }

  void _decrement() {
    final prev = widget.value <= widget.min ? widget.max : widget.value - 1;
    widget.onChanged(prev);
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Increment button
        _SpinnerButton(
          icon: RdsIcons.chevronUp,
          tooltip: 'Increase ${widget.label}',
          onTap: _increment,
        ),
        SizedBox(height: rds.space1),
        // Text field
        SizedBox(
          width: 72,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            onSubmitted: (_) => _commitValue(),
            style: rds.headlineMedium.copyWith(color: rds.onSurface),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: rds.space3,
                vertical: rds.space2,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(rds.radiusMd),
                borderSide: BorderSide(color: rds.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(rds.radiusMd),
                borderSide: BorderSide(color: rds.primary, width: 2),
              ),
              hintText: widget.label,
              hintStyle: rds.headlineMedium.copyWith(color: rds.onSurfaceMuted),
            ),
          ),
        ),
        SizedBox(height: rds.space1),
        // Decrement button
        _SpinnerButton(
          icon: RdsIcons.chevronDown,
          tooltip: 'Decrease ${widget.label}',
          onTap: _decrement,
        ),
      ],
    );
  }
}

class _SpinnerButton extends StatefulWidget {
  const _SpinnerButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  State<_SpinnerButton> createState() => _SpinnerButtonState();
}

class _SpinnerButtonState extends State<_SpinnerButton> {
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
          onTap: widget.onTap,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _hovered
                  ? rds.onSurface.withOpacity(rds.stateHover)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(widget.icon, size: 20, color: rds.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}
