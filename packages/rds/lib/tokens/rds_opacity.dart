/// RDS opacity and state-layer tokens.
///
/// State layers are semi-transparent overlays drawn over interactive elements.
/// The overlay color is the component's "on-color" (e.g. [RdsColors.onPrimaryLight])
/// at the given state opacity.
abstract final class RdsOpacity {
  // ---------------------------------------------------------------------------
  // Content opacity
  // ---------------------------------------------------------------------------

  /// Opacity for disabled text and icons.
  static const double disabled = 0.38;

  /// Opacity for secondary / muted content.
  static const double medium = 0.60;

  /// Full opacity — normal content.
  static const double full = 1.0;

  // ---------------------------------------------------------------------------
  // State-layer opacities
  // ---------------------------------------------------------------------------

  /// Hover state overlay opacity.
  static const double hover = 0.08;

  /// Keyboard focus state overlay opacity.
  static const double focus = 0.12;

  /// Pressed / active state overlay opacity.
  static const double pressed = 0.16;

  /// Dragged state overlay opacity.
  static const double dragged = 0.16;

  /// Disabled container overlay opacity (the container dims to this).
  static const double disabledContainer = 0.12;

  /// Disabled content overlay opacity (icons and text dim to this).
  static const double disabledContent = 0.38;
}
