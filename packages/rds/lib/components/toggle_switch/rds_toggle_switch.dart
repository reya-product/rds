import 'package:flutter/material.dart';
import '../../theme/rds_theme.dart';

// ---------------------------------------------------------------------------
// RdsToggleSwitch
// ---------------------------------------------------------------------------

/// A pill-shaped toggle switch that animates between on and off states.
///
/// Track size: 44×24px. Thumb: 18×18px. Min touch target: 44×44px.
///
/// ```dart
/// RdsToggleSwitch(
///   value: _on,
///   onChanged: (v) => setState(() => _on = v),
/// )
/// ```
class RdsToggleSwitch extends StatefulWidget {
  const RdsToggleSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.disabled = false,
    this.readOnly = false,
    this.semanticLabel,
  });

  /// Whether the switch is on.
  final bool value;

  /// Called when the user toggles the switch. If null, the switch is
  /// non-interactive (treated as disabled for pointer events).
  final ValueChanged<bool>? onChanged;

  /// Disables the switch — blocks all interaction and applies
  /// [RdsTheme.opacityDisabled] opacity.
  final bool disabled;

  /// Renders as read-only — shows the current state with
  /// [surfaceContainer] track coloring and no interaction.
  final bool readOnly;

  /// Optional semantic label for screen readers.
  final String? semanticLabel;

  @override
  State<RdsToggleSwitch> createState() => _RdsToggleSwitchState();
}

class _RdsToggleSwitchState extends State<RdsToggleSwitch> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _isInteractive =>
      !widget.disabled && !widget.readOnly && widget.onChanged != null;

  void _handleTap() {
    if (!_isInteractive) return;
    widget.onChanged?.call(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final animDuration =
        reducedMotion ? rds.durationInstant : rds.durationStandard;

    // Track dimensions
    const trackWidth = 44.0;
    const trackHeight = 24.0;
    const thumbSize = 18.0;
    const thumbPadding = (trackHeight - thumbSize) / 2; // 3px

    // Thumb travel: from left edge+padding to right edge-padding-thumbSize
    const thumbOffLeft = thumbPadding;
    const thumbOffRight = trackWidth - thumbPadding - thumbSize;

    // ---- resolve colors ----
    final Color trackColor;
    final Color thumbColor;

    if (widget.readOnly) {
      trackColor = rds.surfaceContainer;
      thumbColor = rds.outlineVariant;
    } else if (widget.value) {
      trackColor = rds.primary;
      thumbColor = rds.onPrimary;
    } else {
      trackColor = rds.outlineVariant;
      thumbColor = rds.onSurfaceMuted;
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

    final stateLayerColor = widget.value
        ? rds.onPrimary.withOpacity(stateOpacity)
        : rds.onSurface.withOpacity(stateOpacity);

    // ---- build track ----
    Widget track = AnimatedContainer(
      duration: animDuration,
      curve: rds.curveStandard,
      width: trackWidth,
      height: trackHeight,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(rds.radiusFull),
      ),
      child: Stack(
        children: [
          // Animated thumb position
          AnimatedPositioned(
            duration: animDuration,
            curve: rds.curveStandard,
            left: widget.value ? thumbOffRight : thumbOffLeft,
            top: thumbPadding,
            child: AnimatedContainer(
              duration: animDuration,
              curve: rds.curveStandard,
              width: thumbSize,
              height: thumbSize,
              decoration: BoxDecoration(
                color: thumbColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
          // State layer overlay
          if (stateOpacity > 0)
            Positioned.fill(
              child: AnimatedOpacity(
                duration: animDuration,
                opacity: stateOpacity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: stateLayerColor,
                    borderRadius: BorderRadius.circular(rds.radiusFull),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    // ---- 44px touch target ----
    Widget touchArea = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      child: Center(child: track),
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
      toggled: widget.value,
      enabled: _isInteractive,
      label: widget.semanticLabel,
      child: touchArea,
    );
  }
}
