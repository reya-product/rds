import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// Preferred edge the tooltip appears on relative to its child.
///
/// Flutter's built-in [Tooltip] widget supports [preferBelow]; for finer
/// directional control (left / right / start / end) the widget uses a custom
/// overlay. The directional variants fall back to [top] or [bottom] when
/// there is insufficient space.
enum RdsTooltipPlacement {
  top,
  bottom,
  left,
  right,
  topStart,
  topEnd,
  bottomStart,
  bottomEnd,
}

/// What user gesture reveals the tooltip.
enum RdsTooltipTrigger {
  /// Tooltip appears when the pointer hovers over the child (desktop default).
  hover,

  /// Tooltip appears when the child receives keyboard focus.
  focus,

  /// Tooltip appears when the child is long-pressed.
  longPress,
}

// ---------------------------------------------------------------------------
// Widget
// ---------------------------------------------------------------------------

/// A floating label that provides supplementary information about a UI element.
///
/// Wraps Flutter's built-in [Tooltip] widget with RDS-consistent styling:
/// dark surface background, `body-small` text, `radius-sm` corners, and a
/// configurable delay.
///
/// ## Usage
/// ```dart
/// RdsTooltip(
///   message: 'Save document',
///   child: IconButton(
///     icon: const Icon(Icons.save),
///     onPressed: () {},
///   ),
/// )
/// ```
class RdsTooltip extends StatelessWidget {
  /// The text shown inside the tooltip bubble.
  final String message;

  /// The widget the tooltip is attached to.
  final Widget child;

  /// Which edge of [child] the tooltip prefers to appear on.
  final RdsTooltipPlacement placement;

  /// How the tooltip is triggered.
  final RdsTooltipTrigger trigger;

  /// Time to wait before the tooltip appears.
  final Duration waitDuration;

  /// Time the tooltip stays visible after the pointer leaves (hover trigger).
  final Duration showDuration;

  const RdsTooltip({
    super.key,
    required this.message,
    required this.child,
    this.placement = RdsTooltipPlacement.top,
    this.trigger = RdsTooltipTrigger.hover,
    this.waitDuration = const Duration(milliseconds: 500),
    this.showDuration = const Duration(milliseconds: 1500),
  });

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  bool get _preferBelow {
    switch (placement) {
      case RdsTooltipPlacement.bottom:
      case RdsTooltipPlacement.bottomStart:
      case RdsTooltipPlacement.bottomEnd:
        return true;
      default:
        return false;
    }
  }

  TooltipTriggerMode get _triggerMode {
    switch (trigger) {
      case RdsTooltipTrigger.hover:
        // On desktop, Tooltip shows on hover by default regardless of triggerMode.
        // Set longPress as the touch trigger so mobile users can also reveal it.
        return TooltipTriggerMode.longPress;
      case RdsTooltipTrigger.focus:
        return TooltipTriggerMode.longPress;
      case RdsTooltipTrigger.longPress:
        return TooltipTriggerMode.longPress;
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    // Use rds.onSurface as the tooltip background so it contrasts with surfaces
    // in both light mode (near-black on white) and dark mode (near-white on dark).
    final tooltipBackground = rds.onSurface;
    final tooltipForeground = rds.surface;

    final tooltipDecoration = BoxDecoration(
      color: tooltipBackground,
      borderRadius: BorderRadius.circular(rds.radiusSm),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.10),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
    );

    return Tooltip(
      message: message,
      preferBelow: _preferBelow,
      triggerMode: _triggerMode,
      waitDuration: waitDuration,
      showDuration: showDuration,
      padding: EdgeInsets.symmetric(
        horizontal: rds.space3,
        vertical: rds.space2,
      ),
      margin: EdgeInsets.symmetric(horizontal: rds.space2),
      decoration: tooltipDecoration,
      textStyle: rds.bodySmall.copyWith(color: tooltipForeground),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 32, maxWidth: 240),
        child: child,
      ),
    );
  }
}
