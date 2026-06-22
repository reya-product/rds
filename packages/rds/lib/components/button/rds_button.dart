import 'package:flutter/material.dart';
import '../../theme/rds_theme.dart';
import '../../tokens/rds_icon_size.dart';
import '../../tokens/rds_icons.dart';

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// The visual variant of [RdsButton].
enum RdsButtonVariant {
  /// Filled with `color-primary`. Highest emphasis.
  primary,

  /// Filled with `color-primary-container`. Medium-high emphasis.
  tonal,

  /// Outlined border, transparent fill. Medium emphasis.
  outlined,

  /// No fill, no border. Lowest emphasis.
  text,
}

/// The semantic tone of [RdsButton].
enum RdsButtonTone {
  /// Standard brand tone (default).
  // ignore: constant_identifier_names
  defaultTone,

  /// Destructive / danger tone.
  danger,
}

/// Where the icon is placed relative to the label.
enum RdsButtonIconPosition {
  /// No icon is shown.
  none,

  /// Icon appears before (left of) the label.
  leading,

  /// Icon appears after (right of) the label.
  trailing,

  /// Icon only — label is not shown visually but must be provided for accessibility.
  iconOnly,
}

/// The size of [RdsButton].
enum RdsButtonSize {
  /// Height 32px, compact padding.
  small,

  /// Height 40px (default).
  medium,

  /// Height 48px, comfortable padding.
  large,
}

// ---------------------------------------------------------------------------
// RdsButton
// ---------------------------------------------------------------------------

/// A pressable label that triggers an action.
///
/// Supports four visual [RdsButtonVariant]s, two semantic [RdsButtonTone]s,
/// leading/trailing/icon-only icon positions, three sizes, loading and
/// disabled states.
///
/// ```dart
/// RdsButton(
///   label: 'Save changes',
///   onPressed: () { ... },
/// )
///
/// RdsButton(
///   label: 'Delete',
///   variant: RdsButtonVariant.outlined,
///   tone: RdsButtonTone.danger,
///   icon: RdsIcons.delete,
///   iconPosition: RdsButtonIconPosition.leading,
///   onPressed: () { ... },
/// )
/// ```
class RdsButton extends StatefulWidget {
  const RdsButton({
    super.key,
    required this.label,
    this.variant = RdsButtonVariant.primary,
    this.tone = RdsButtonTone.defaultTone,
    this.iconPosition = RdsButtonIconPosition.none,
    this.icon,
    this.size = RdsButtonSize.medium,
    this.loading = false,
    this.disabled = false,
    this.fullWidth = false,
    this.onPressed,
  });

  /// The button label. Always required — used for semantics even if not
  /// visible (e.g. [RdsButtonIconPosition.iconOnly]).
  final String label;

  /// Visual variant controlling fill, border, and text colors.
  final RdsButtonVariant variant;

  /// Semantic tone: default brand or danger/destructive.
  final RdsButtonTone tone;

  /// Where the icon is placed relative to the label.
  final RdsButtonIconPosition iconPosition;

  /// The icon data to display. Required when [iconPosition] is not [RdsButtonIconPosition.none].
  final IconData? icon;

  /// Size of the button.
  final RdsButtonSize size;

  /// Shows a spinner and blocks interaction while true.
  final bool loading;

  /// Disables the button — blocks interaction and reduces opacity.
  final bool disabled;

  /// Whether the button stretches to fill its parent's width.
  final bool fullWidth;

  /// Called when the button is tapped. If null, the button acts as disabled.
  final VoidCallback? onPressed;

  @override
  State<RdsButton> createState() => _RdsButtonState();
}

class _RdsButtonState extends State<RdsButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _isInteractive => !widget.disabled && !widget.loading && widget.onPressed != null;

  void _handleTap() {
    if (_isInteractive) widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final animDuration = reducedMotion ? rds.durationInstant : rds.durationStandard;

    // ---- resolve colors for this variant + tone ----
    final colors = _resolveColors(rds);

    // ---- sizing ----
    final double height = _resolveHeight();
    final EdgeInsets padding = _resolvePadding(rds);
    const double iconSize = RdsIconSize.md;
    const double spinnerSize = RdsIconSize.md;

    // ---- state layer opacity ----
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

    // ---- build icon widget ----
    Widget? iconWidget;
    if (widget.iconPosition != RdsButtonIconPosition.none) {
      if (widget.loading && widget.iconPosition == RdsButtonIconPosition.iconOnly) {
        // For icon-only loading, show spinner instead of icon
        iconWidget = SizedBox(
          width: spinnerSize,
          height: spinnerSize,
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(colors.foreground),
          ),
        );
      } else if (widget.icon != null) {
        iconWidget = Icon(
          widget.icon,
          size: iconSize,
          color: colors.foreground,
        );
      }
    }

    // ---- build label ----
    Widget? labelWidget;
    if (widget.iconPosition != RdsButtonIconPosition.iconOnly) {
      if (widget.loading) {
        // Show spinner in-line with (or instead of) label
        labelWidget = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: spinnerSize,
              height: spinnerSize,
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(colors.foreground),
              ),
            ),
            SizedBox(width: rds.space2),
            Text(
              widget.label,
              style: rds.labelLarge.copyWith(color: colors.foreground),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        );
      } else {
        labelWidget = Text(
          widget.label,
          style: rds.labelLarge.copyWith(color: colors.foreground),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        );
      }
    }

    // ---- assemble content row ----
    Widget content;
    if (widget.iconPosition == RdsButtonIconPosition.iconOnly) {
      content = iconWidget ?? const SizedBox.shrink();
    } else if (widget.iconPosition == RdsButtonIconPosition.leading && iconWidget != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          SizedBox(width: rds.space2),
          labelWidget!,
        ],
      );
    } else if (widget.iconPosition == RdsButtonIconPosition.trailing && iconWidget != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          labelWidget!,
          SizedBox(width: rds.space2),
          iconWidget,
        ],
      );
    } else {
      content = labelWidget ?? const SizedBox.shrink();
    }

    // ---- build decoration ----
    final borderRadius = BorderRadius.circular(rds.radiusMd);

    final BoxDecoration decoration = BoxDecoration(
      color: colors.fill,
      borderRadius: borderRadius,
      border: colors.borderColor != null
          ? Border.all(color: colors.borderColor!, width: 1)
          : null,
    );

    // ---- build the button body ----
    Widget buttonBody = AnimatedContainer(
      duration: animDuration,
      curve: rds.curveStandard,
      height: height,
      decoration: decoration,
      padding: padding,
      child: Stack(
        alignment: Alignment.center,
        children: [
          content,
          // State layer overlay
          if (stateOpacity > 0)
            Positioned.fill(
              child: AnimatedOpacity(
                duration: animDuration,
                curve: rds.curveStandard,
                opacity: stateOpacity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.stateLayerColor,
                    borderRadius: borderRadius,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    // ---- apply disabled opacity ----
    if (widget.disabled) {
      buttonBody = Opacity(opacity: rds.opacityDisabled, child: buttonBody);
    }

    // ---- ensure min touch target ----
    Widget sizedBody = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      child: buttonBody,
    );

    if (widget.fullWidth) {
      sizedBody = SizedBox(width: double.infinity, child: sizedBody);
    }

    // ---- wrap in gesture/mouse handling ----
    final Widget interactive = MouseRegion(
      cursor: _isInteractive ? SystemMouseCursors.click : SystemMouseCursors.basic,
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
          child: sizedBody,
        ),
      ),
    );

    // ---- accessibility ----
    return Semantics(
      label: widget.iconPosition == RdsButtonIconPosition.iconOnly ? widget.label : null,
      button: true,
      enabled: _isInteractive,
      child: interactive,
    );
  }

  double _resolveHeight() {
    switch (widget.size) {
      case RdsButtonSize.small:
        return 32;
      case RdsButtonSize.medium:
        return 40;
      case RdsButtonSize.large:
        return 48;
    }
  }

  EdgeInsets _resolvePadding(RdsTheme rds) {
    if (widget.iconPosition == RdsButtonIconPosition.iconOnly) {
      // Square: equal horizontal and vertical padding
      switch (widget.size) {
        case RdsButtonSize.small:
          return EdgeInsets.all(rds.space2);
        case RdsButtonSize.medium:
          return EdgeInsets.all(rds.space3);
        case RdsButtonSize.large:
          return EdgeInsets.all(rds.space4);
      }
    }
    switch (widget.size) {
      case RdsButtonSize.small:
        return EdgeInsets.symmetric(horizontal: rds.space3, vertical: rds.space1);
      case RdsButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: rds.space4, vertical: rds.space2);
      case RdsButtonSize.large:
        return EdgeInsets.symmetric(horizontal: rds.space5, vertical: rds.space3);
    }
  }

  _ButtonColors _resolveColors(RdsTheme rds) {
    final isDanger = widget.tone == RdsButtonTone.danger;

    switch (widget.variant) {
      case RdsButtonVariant.primary:
        final fill = isDanger ? rds.danger : rds.primary;
        final fg = isDanger ? rds.onDanger : rds.onPrimary;
        return _ButtonColors(
          fill: fill,
          foreground: fg,
          borderColor: null,
          stateLayerColor: fg,
        );

      case RdsButtonVariant.tonal:
        final fill = isDanger ? rds.dangerContainer : rds.primaryContainer;
        final fg = isDanger ? rds.onDangerContainer : rds.onPrimaryContainer;
        return _ButtonColors(
          fill: fill,
          foreground: fg,
          borderColor: null,
          stateLayerColor: fg,
        );

      case RdsButtonVariant.outlined:
        final fg = isDanger ? rds.danger : rds.primary;
        final border = isDanger ? rds.danger : rds.outline;
        return _ButtonColors(
          fill: Colors.transparent,
          foreground: fg,
          borderColor: border,
          stateLayerColor: fg,
        );

      case RdsButtonVariant.text:
        final fg = isDanger ? rds.danger : rds.onSurface;
        return _ButtonColors(
          fill: Colors.transparent,
          foreground: fg,
          borderColor: null,
          stateLayerColor: fg,
        );
    }
  }
}

// ---------------------------------------------------------------------------
// Internal color bundle
// ---------------------------------------------------------------------------

class _ButtonColors {
  const _ButtonColors({
    required this.fill,
    required this.foreground,
    required this.borderColor,
    required this.stateLayerColor,
  });

  final Color fill;
  final Color foreground;
  final Color? borderColor;
  final Color stateLayerColor;
}
