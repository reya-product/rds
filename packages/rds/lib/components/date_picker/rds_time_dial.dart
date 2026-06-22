import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../theme/rds_theme.dart';

// ---------------------------------------------------------------------------
// Clock dial widget
// ---------------------------------------------------------------------------

/// A circular clock-face dial for selecting hour or minute values.
///
/// Used internally by [RdsTimePicker] and [RdsDateTimePicker].
/// The dial switches between hour and minute selection via [selectingMinute].
///
/// Touch/drag events move the clock hand to the nearest hour or minute marker.
class RdsTimeDial extends StatefulWidget {
  const RdsTimeDial({
    super.key,
    required this.hour,
    required this.minute,
    required this.selectingMinute,
    required this.use24HourFormat,
    required this.onHourChanged,
    required this.onMinuteChanged,
    this.onSelectionConfirmed,
  });

  /// Currently selected hour (0–23).
  final int hour;

  /// Currently selected minute (0–59).
  final int minute;

  /// When true the dial shows minute values (0–55 in steps of 5).
  /// When false it shows hour values.
  final bool selectingMinute;

  /// If true, show 0–23 for hours. If false, show 1–12 with AM/PM.
  final bool use24HourFormat;

  /// Called when user picks a new hour.
  final ValueChanged<int> onHourChanged;

  /// Called when user picks a new minute.
  final ValueChanged<int> onMinuteChanged;

  /// Called when the user lifts their finger/mouse (confirms current selection).
  final VoidCallback? onSelectionConfirmed;

  @override
  State<RdsTimeDial> createState() => _RdsTimeDialState();
}

class _RdsTimeDialState extends State<RdsTimeDial>
    with SingleTickerProviderStateMixin {
  late AnimationController _handController;
  late Animation<double> _handAngle;
  double _currentAngle = 0;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _handController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _currentAngle = _targetAngle();
    _handAngle = Tween<double>(begin: _currentAngle, end: _currentAngle)
        .animate(CurvedAnimation(
            parent: _handController, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(RdsTimeDial oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newAngle = _targetAngle();
    if ((newAngle - _currentAngle).abs() > 0.001 && !_dragging) {
      _handAngle = Tween<double>(begin: _currentAngle, end: newAngle)
          .animate(CurvedAnimation(
              parent: _handController, curve: Curves.easeInOut));
      _currentAngle = newAngle;
      _handController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _handController.dispose();
    super.dispose();
  }

  double _targetAngle() {
    if (widget.selectingMinute) {
      return (widget.minute / 60.0) * 2 * math.pi - math.pi / 2;
    } else {
      final total = widget.use24HourFormat ? 24.0 : 12.0;
      final h = widget.hour % (widget.use24HourFormat ? 24 : 12);
      return (h / total) * 2 * math.pi - math.pi / 2;
    }
  }

  void _handlePanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
    final pos = details.localPosition;
    final angle = math.atan2(pos.dy - center.dy, pos.dx - center.dx);
    _updateFromAngle(angle, constraints);
  }

  void _handleTapDown(TapDownDetails details, BoxConstraints constraints) {
    final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
    final pos = details.localPosition;
    final angle = math.atan2(pos.dy - center.dy, pos.dx - center.dx);
    _updateFromAngle(angle, constraints);
  }

  void _updateFromAngle(double angle, BoxConstraints constraints) {
    // angle in (-pi, pi], we add pi/2 to rotate to 12-o'clock = 0
    double normalized = (angle + math.pi / 2 + 2 * math.pi) % (2 * math.pi);

    if (widget.selectingMinute) {
      final rawMinute = (normalized / (2 * math.pi) * 60).round() % 60;
      // Snap to 5-minute increments? No — allow any minute for precision
      if (rawMinute != widget.minute) {
        widget.onMinuteChanged(rawMinute);
      }
    } else {
      if (widget.use24HourFormat) {
        // Outer ring = 1–12, inner ring = 13–24/0
        // Determine by distance from center
        final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
        // We can't access the tap position here, so use a simple 24-hour map
        int rawHour = (normalized / (2 * math.pi) * 24).round() % 24;
        if (rawHour != widget.hour) {
          widget.onHourChanged(rawHour);
        }
      } else {
        int rawHour = (normalized / (2 * math.pi) * 12).round() % 12;
        if (rawHour == 0) rawHour = 12;
        final h = widget.hour % 12 == 0 ? 12 : widget.hour % 12;
        if (rawHour != h) {
          // Preserve AM/PM
          final isPm = widget.hour >= 12;
          final newHour = isPm ? (rawHour == 12 ? 12 : rawHour + 12) : (rawHour == 12 ? 0 : rawHour);
          widget.onHourChanged(newHour);
        }
      }
    }

    setState(() {
      _currentAngle = angle;
      _dragging = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return LayoutBuilder(builder: (context, constraints) {
      final size = math.min(constraints.maxWidth, constraints.maxHeight);

      return GestureDetector(
        onTapDown: (d) => _handleTapDown(d, BoxConstraints.tight(Size(size, size))),
        onPanStart: (_) => setState(() => _dragging = true),
        onPanUpdate: (d) =>
            _handlePanUpdate(d, BoxConstraints.tight(Size(size, size))),
        onPanEnd: (_) {
          setState(() => _dragging = false);
          widget.onSelectionConfirmed?.call();
        },
        onTapUp: (_) {
          setState(() => _dragging = false);
          widget.onSelectionConfirmed?.call();
        },
        child: AnimatedBuilder(
          animation: _handController,
          builder: (context, child) {
            return CustomPaint(
              size: Size(size, size),
              painter: _ClockFacePainter(
                hour: widget.hour,
                minute: widget.minute,
                selectingMinute: widget.selectingMinute,
                use24HourFormat: widget.use24HourFormat,
                handAngle: _dragging ? _currentAngle : _handAngle.value,
                primaryColor: rds.primary,
                onPrimaryColor: rds.onPrimary,
                surfaceContainerColor: rds.surfaceContainer,
                onSurfaceColor: rds.onSurface,
                onSurfaceMutedColor: rds.onSurfaceMuted,
                primaryContainerColor: rds.primaryContainer,
              ),
            );
          },
        ),
      );
    });
  }
}

// ---------------------------------------------------------------------------
// CustomPainter for the clock face
// ---------------------------------------------------------------------------

class _ClockFacePainter extends CustomPainter {
  _ClockFacePainter({
    required this.hour,
    required this.minute,
    required this.selectingMinute,
    required this.use24HourFormat,
    required this.handAngle,
    required this.primaryColor,
    required this.onPrimaryColor,
    required this.surfaceContainerColor,
    required this.onSurfaceColor,
    required this.onSurfaceMutedColor,
    required this.primaryContainerColor,
  });

  final int hour;
  final int minute;
  final bool selectingMinute;
  final bool use24HourFormat;
  final double handAngle;
  final Color primaryColor;
  final Color onPrimaryColor;
  final Color surfaceContainerColor;
  final Color onSurfaceColor;
  final Color onSurfaceMutedColor;
  final Color primaryContainerColor;

  static const double _numberRadius = 0.75;
  static const double _innerNumberRadius = 0.52;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;

    // ---- Draw clock face background ----
    final bgPaint = Paint()..color = surfaceContainerColor;
    canvas.drawCircle(center, outerRadius, bgPaint);

    // ---- Draw hand ----
    final handLength = outerRadius * _numberRadius - 16;
    final handEnd = Offset(
      center.dx + handLength * math.cos(handAngle),
      center.dy + handLength * math.sin(handAngle),
    );

    final handPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, handEnd, handPaint);

    // Center dot
    canvas.drawCircle(center, 4, Paint()..color = primaryColor);

    // ---- Draw numbers ----
    if (selectingMinute) {
      _drawMinuteNumbers(canvas, center, outerRadius);
    } else {
      _drawHourNumbers(canvas, center, outerRadius);
    }
  }

  void _drawHourNumbers(Canvas canvas, Offset center, double outerRadius) {
    final count = use24HourFormat ? 24 : 12;

    for (var i = 1; i <= count; i++) {
      final isOuter = !use24HourFormat || i <= 12;
      final radius = isOuter
          ? outerRadius * _numberRadius
          : outerRadius * _innerNumberRadius;
      final angle = ((i % (use24HourFormat ? 12 : 12)) / 12.0) * 2 * math.pi -
          math.pi / 2;
      if (use24HourFormat && i % 12 == 0) {
        // Skip — handled below
      }
      final pos = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      final isSelected = !selectingMinute &&
          (use24HourFormat ? hour == i % 24 : (hour % 12 == i % 12));

      _drawNumberCircle(canvas, pos, i == 24 ? 0 : i, isSelected);
    }

    if (use24HourFormat) {
      // Draw 0 (midnight) at the top
      final angle = -math.pi / 2;
      final pos = Offset(
        center.dx + outerRadius * _numberRadius * math.cos(angle),
        center.dy + outerRadius * _numberRadius * math.sin(angle),
      );
      _drawNumberCircle(canvas, pos, 12, !selectingMinute && hour == 12);

      // Draw 0 inner (midnight on inner)
      final posInner = Offset(
        center.dx + outerRadius * _innerNumberRadius * math.cos(angle),
        center.dy + outerRadius * _innerNumberRadius * math.sin(angle),
      );
      _drawNumberCircle(canvas, posInner, 0, !selectingMinute && hour == 0);
    }
  }

  void _drawMinuteNumbers(Canvas canvas, Offset center, double outerRadius) {
    for (var i = 0; i < 12; i++) {
      final minuteValue = i * 5;
      final angle = (i / 12.0) * 2 * math.pi - math.pi / 2;
      final pos = Offset(
        center.dx + outerRadius * _numberRadius * math.cos(angle),
        center.dy + outerRadius * _numberRadius * math.sin(angle),
      );
      final isSelected = selectingMinute && minute == minuteValue;
      _drawNumberCircle(canvas, pos, minuteValue, isSelected);
    }
  }

  void _drawNumberCircle(Canvas canvas, Offset pos, int value, bool isSelected) {
    if (isSelected) {
      final circlePaint = Paint()..color = primaryColor;
      canvas.drawCircle(pos, 16, circlePaint);
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: value < 10 ? '0$value' : '$value',
        style: TextStyle(
          color: isSelected ? onPrimaryColor : onSurfaceColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      pos - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(_ClockFacePainter oldDelegate) {
    return oldDelegate.hour != hour ||
        oldDelegate.minute != minute ||
        oldDelegate.selectingMinute != selectingMinute ||
        oldDelegate.handAngle != handAngle ||
        oldDelegate.primaryColor != primaryColor;
  }
}
