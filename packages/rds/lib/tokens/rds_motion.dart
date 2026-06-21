import 'package:flutter/material.dart';

/// RDS motion / animation tokens.
///
/// Use [durationInstant] when `MediaQuery.disableAnimationsOf(context)` is true
/// to respect the system's reduced-motion preference.
abstract final class RdsMotion {
  // ---------------------------------------------------------------------------
  // Durations
  // ---------------------------------------------------------------------------

  /// No animation. Use for immediate state changes and reduced-motion mode.
  static const Duration durationInstant = Duration.zero;

  /// 100ms — micro-interactions (checkbox tick, toggle thumb snap).
  static const Duration durationFast = Duration(milliseconds: 100);

  /// 200ms — standard transitions (color, size, opacity changes).
  static const Duration durationStandard = Duration(milliseconds: 200);

  /// 300ms — enter/exit animations (modals, drawers, menus).
  static const Duration durationEmphasized = Duration(milliseconds: 300);

  /// 500ms — complex page transitions, skeleton loading.
  static const Duration durationSlow = Duration(milliseconds: 500);

  // ---------------------------------------------------------------------------
  // Easing curves
  // ---------------------------------------------------------------------------

  /// ease-in-out — standard transitions.
  static const Curve curveStandard = Curves.easeInOut;

  /// cubic-bezier(0.2, 0, 0, 1) — M3 emphasized easing for enter/exit.
  static const Curve curveEmphasized = Cubic(0.2, 0, 0, 1);

  /// ease-out — elements entering the screen.
  static const Curve curveEnter = Curves.easeOut;

  /// ease-in — elements exiting the screen.
  static const Curve curveExit = Curves.easeIn;
}
