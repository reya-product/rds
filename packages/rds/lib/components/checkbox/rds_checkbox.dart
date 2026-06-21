import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:rds/rds.dart';

// ---------------------------------------------------------------------------
// RdsCheckbox
// ---------------------------------------------------------------------------

/// A tristate checkbox control built entirely from RDS tokens.
///
/// Supports checked, unchecked, and indeterminate (null) states.
/// Do NOT use Flutter's built-in [Checkbox] — this widget paints its own
/// box to match RDS token styling precisely.
///
/// ```dart
/// RdsCheckbox(
///   value: _checked,
///   onChanged: (v) => setState(() => _checked = v),
/// )
///
/// // Indeterminate
/// RdsCheckbox(
///   value: null,
///   onChanged: (v) => setState(() => _checked = v),
/// )
///
/// // Error state
/// RdsCheckbox(
///   value: false,
///   error: true,
///   onChanged: (v) => setState(() => _checked = v),
/// )
/// ```
class RdsCheckbox extends StatefulWidget {
  const RdsCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.disabled = false,
    this.readOnly = false,
    this.error = false,
    this.size = 20.0,
    this.semanticLabel,
  });

  /// The current value.
  /// - `true` — checked
  /// - `false` — unchecked
  /// - `null` — indeterminate
  final bool? value;

  /// Called when the value changes. If null, the checkbox is non-interactive.
  /// The callback receives the new boolean value; indeterminate resolves to `true`.
  final ValueChanged<bool?>? onChanged;

  /// Disables the checkbox — blocks all interaction and applies
  /// [RdsTheme.opacityDisabled] opacity.
  final bool disabled;

  /// Renders as read-only — shows the current state with no interaction
  /// and uses [surfaceContainer] / [outlineVariant] styling.
  final bool readOnly;

  /// Applies an error visual: [danger] border when unchecked / [danger] fill
  /// when checked or indeterminate.
  final bool error;

  /// Width and height of the visible control box. Defaults to 20px.
  /// The touch target is always at least 44×44px regardless of this value.
  final double size;

  /// Optional semantic label for screen readers.
  final String? semanticLabel;

  @override
  State<RdsCheckbox> createState() => _RdsCheckboxState();
}

class _RdsCheckboxState extends State<RdsCheckbox>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  late AnimationController _tickController;
  late Animation<double> _tickProgress;

  bool get _isInteractive =>
      !widget.disabled && !widget.readOnly && widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    _tickController = AnimationController(vsync: this);
    _tickProgress = CurvedAnimation(
      parent: _tickController,
      curve: Curves.easeOut,
    );
    // Start the tick fully complete if already checked/indeterminate
    if (widget.value != false) {
      _tickController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(RdsCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    if (oldWidget.value != widget.value) {
      final isActive = widget.value != false;
      if (reducedMotion) {
        _tickController.value = isActive ? 1.0 : 0.0;
      } else {
        if (isActive) {
          _tickController.forward(from: 0.0);
        } else {
          _tickController.reverse(from: 1.0);
        }
      }
    }
  }

  @override
  void dispose() {
    _tickController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!_isInteractive) return;
    final next = widget.value == true ? false : true;
    widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final animDuration =
        reducedMotion ? rds.durationInstant : rds.durationFast;

    // Update controller duration based on reduced motion preference
    _tickController.duration = animDuration;

    // ---- resolve fill and border color ----
    final Color fillColor;
    final Color borderColor;
    final Color iconColor = rds.onPrimary;

    if (widget.readOnly) {
      if (widget.value != false) {
        fillColor = rds.surfaceContainer;
        borderColor = rds.outlineVariant;
      } else {
        fillColor = Colors.transparent;
        borderColor = rds.outlineVariant;
      }
    } else if (widget.error) {
      if (widget.value != false) {
        fillColor = rds.danger;
        borderColor = rds.danger;
      } else {
        fillColor = Colors.transparent;
        borderColor = rds.danger;
      }
    } else {
      if (widget.value != false) {
        fillColor = rds.primary;
        borderColor = rds.primary;
      } else {
        fillColor = Colors.transparent;
        borderColor = rds.outline;
      }
    }

    // ---- state layer ----
    double stateOpacity = 0.0;
    if (_isInteractive) {
      if (_pressed) {
        stateOpacity = rds.statePressed;
      } else if (_focused) {
        stateOpacity = rds.stateFocus;
      } else if (_hovered) {
        stateOpacity = rds.stateHover;
      }
    }

    final stateLayerColor = (widget.value != false)
        ? rds.onPrimary.withOpacity(stateOpacity)
        : rds.primary.withOpacity(stateOpacity);

    // ---- build the checkbox box ----
    Widget box = AnimatedContainer(
      duration: animDuration,
      curve: rds.curveStandard,
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(rds.radiusXs),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: widget.value != false
          ? AnimatedBuilder(
              animation: _tickProgress,
              builder: (context, _) {
                return CustomPaint(
                  painter: _CheckboxMarkPainter(
                    progress: _tickProgress.value,
                    color: iconColor,
                    isIndeterminate: widget.value == null,
                  ),
                );
              },
            )
          : null,
    );

    // ---- state layer overlay (circular, covers full 44px touch zone) ----
    Widget touchArea = SizedBox(
      width: math.max(widget.size, 44.0),
      height: math.max(widget.size, 44.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // State layer (ripple) — behind the box
          if (stateOpacity > 0)
            AnimatedContainer(
              duration: animDuration,
              curve: rds.curveStandard,
              width: math.max(widget.size, 44.0),
              height: math.max(widget.size, 44.0),
              decoration: BoxDecoration(
                color: stateLayerColor,
                shape: BoxShape.circle,
              ),
            ),
          box,
        ],
      ),
    );

    // ---- apply disabled opacity ----
    if (widget.disabled) {
      touchArea = Opacity(opacity: rds.opacityDisabled, child: touchArea);
    }

    // ---- interaction wrappers ----
    touchArea = MouseRegion(
      cursor: _isInteractive
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) {
        if (_isInteractive) setState(() => _hovered = true);
      },
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) {
          if (_isInteractive) setState(() => _pressed = true);
        },
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: _isInteractive ? _handleTap : null,
        child: Focus(
          onFocusChange: (hasFocus) => setState(() => _focused = hasFocus),
          child: touchArea,
        ),
      ),
    );

    return Semantics(
      checked: widget.value ?? false,
      enabled: _isInteractive,
      label: widget.semanticLabel,
      child: touchArea,
    );
  }
}

// ---------------------------------------------------------------------------
// CustomPainter for the checkmark and dash
// ---------------------------------------------------------------------------

class _CheckboxMarkPainter extends CustomPainter {
  const _CheckboxMarkPainter({
    required this.progress,
    required this.color,
    required this.isIndeterminate,
  });

  final double progress;
  final Color color;
  final bool isIndeterminate;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    if (isIndeterminate) {
      // Horizontal dash centered in the box
      final y = size.height / 2;
      final xStart = size.width * 0.2;
      final xEnd = size.width * 0.8;
      final currentX = xStart + (xEnd - xStart) * progress;
      canvas.drawLine(Offset(xStart, y), Offset(currentX, y), paint);
    } else {
      // Checkmark: two segments
      // Segment 1: short diagonal down-right (left arm of tick)
      // Segment 2: longer diagonal up-right (right arm of tick)
      final p1 = Offset(size.width * 0.18, size.height * 0.50);
      final p2 = Offset(size.width * 0.42, size.height * 0.72);
      final p3 = Offset(size.width * 0.82, size.height * 0.28);

      final totalLength =
          _dist(p1, p2) + _dist(p2, p3);
      final drawn = totalLength * progress;

      final seg1 = _dist(p1, p2);

      if (drawn <= seg1) {
        final t = drawn / seg1;
        canvas.drawLine(p1, Offset.lerp(p1, p2, t)!, paint);
      } else {
        canvas.drawLine(p1, p2, paint);
        final remaining = drawn - seg1;
        final seg2 = _dist(p2, p3);
        final t = (remaining / seg2).clamp(0.0, 1.0);
        canvas.drawLine(p2, Offset.lerp(p2, p3, t)!, paint);
      }
    }
  }

  double _dist(Offset a, Offset b) {
    final dx = b.dx - a.dx;
    final dy = b.dy - a.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  @override
  bool shouldRepaint(_CheckboxMarkPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.isIndeterminate != isIndeterminate;
}
