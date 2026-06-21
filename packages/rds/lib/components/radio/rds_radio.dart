import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:rds/rds.dart';

// ---------------------------------------------------------------------------
// RdsRadio
// ---------------------------------------------------------------------------

/// A radio button control built entirely from RDS tokens.
///
/// Pair multiple [RdsRadio] widgets with the same [groupValue] type to form
/// a mutually-exclusive group.
///
/// ```dart
/// RdsRadio<String>(
///   value: 'option_a',
///   groupValue: _selected,
///   onChanged: (v) => setState(() => _selected = v),
/// )
/// ```
class RdsRadio<T> extends StatefulWidget {
  const RdsRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.disabled = false,
    this.readOnly = false,
    this.error = false,
    this.size = 20.0,
    this.semanticLabel,
  });

  /// The value this radio button represents.
  final T value;

  /// The currently selected value in the group.
  final T? groupValue;

  /// Called when this radio is tapped. If null, the radio is non-interactive.
  final ValueChanged<T?>? onChanged;

  /// Disables the radio — blocks all interaction and applies
  /// [RdsTheme.opacityDisabled] opacity.
  final bool disabled;

  /// Renders as read-only — shows the current state with no interaction.
  final bool readOnly;

  /// Applies an error visual: [danger] ring color.
  final bool error;

  /// Diameter of the visible control. Defaults to 20px.
  /// Touch target is always at least 44×44px.
  final double size;

  /// Optional semantic label for screen readers.
  final String? semanticLabel;

  bool get _isSelected => value == groupValue;

  @override
  State<RdsRadio<T>> createState() => _RdsRadioState<T>();
}

class _RdsRadioState<T> extends State<RdsRadio<T>>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  late AnimationController _dotController;
  late Animation<double> _dotScale;

  bool get _isInteractive =>
      !widget.disabled && !widget.readOnly && widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(vsync: this);
    _dotScale = CurvedAnimation(parent: _dotController, curve: Curves.easeOut);
    if (widget._isSelected) {
      _dotController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(RdsRadio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    if (oldWidget._isSelected != widget._isSelected) {
      if (reducedMotion) {
        _dotController.value = widget._isSelected ? 1.0 : 0.0;
      } else {
        if (widget._isSelected) {
          _dotController.forward(from: 0.0);
        } else {
          _dotController.reverse(from: 1.0);
        }
      }
    }
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!_isInteractive || widget._isSelected) return;
    widget.onChanged?.call(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final animDuration =
        reducedMotion ? rds.durationInstant : rds.durationFast;

    _dotController.duration = animDuration;

    // ---- resolve ring and dot colors ----
    final Color ringColor;
    final Color dotColor;

    if (widget.readOnly) {
      ringColor = rds.outlineVariant;
      dotColor = rds.outlineVariant;
    } else if (widget.error) {
      ringColor = rds.danger;
      dotColor = rds.danger;
    } else if (widget._isSelected) {
      ringColor = rds.primary;
      dotColor = rds.primary;
    } else {
      ringColor = rds.outline;
      dotColor = rds.primary;
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

    final stateLayerColor = widget._isSelected
        ? rds.primary.withOpacity(stateOpacity)
        : rds.onSurface.withOpacity(stateOpacity);

    // ---- radio ring + animated dot ----
    Widget radio = AnimatedBuilder(
      animation: _dotScale,
      builder: (context, _) {
        return CustomPaint(
          painter: _RadioPainter(
            ringColor: ringColor,
            dotColor: dotColor,
            dotProgress: _dotScale.value,
            size: widget.size,
          ),
          size: Size(widget.size, widget.size),
        );
      },
    );

    // ---- wrap in 44px touch area with state layer ----
    Widget touchArea = SizedBox(
      width: math.max(widget.size, 44.0),
      height: math.max(widget.size, 44.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
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
          radio,
        ],
      ),
    );

    // ---- disabled opacity ----
    if (widget.disabled) {
      touchArea = Opacity(opacity: rds.opacityDisabled, child: touchArea);
    }

    // ---- interaction ----
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
      inMutuallyExclusiveGroup: true,
      checked: widget._isSelected,
      enabled: _isInteractive,
      label: widget.semanticLabel,
      child: touchArea,
    );
  }
}

// ---------------------------------------------------------------------------
// CustomPainter for the radio ring + dot
// ---------------------------------------------------------------------------

class _RadioPainter extends CustomPainter {
  const _RadioPainter({
    required this.ringColor,
    required this.dotColor,
    required this.dotProgress,
    required this.size,
  });

  final Color ringColor;
  final Color dotColor;
  final double dotProgress;
  final double size;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final radius = size / 2;
    const ringWidth = 2.0;

    // Outer ring
    final ringPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth;
    canvas.drawCircle(center, radius - ringWidth / 2, ringPaint);

    // Inner dot (animated scale)
    if (dotProgress > 0) {
      final dotRadius = (radius - ringWidth - 3) * dotProgress;
      if (dotRadius > 0) {
        final dotPaint = Paint()
          ..color = dotColor
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, dotRadius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_RadioPainter old) =>
      old.ringColor != ringColor ||
      old.dotColor != dotColor ||
      old.dotProgress != dotProgress ||
      old.size != size;
}
