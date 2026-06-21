import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';
import '../../tokens/rds_icons.dart';

// ---------------------------------------------------------------------------
// Enum
// ---------------------------------------------------------------------------

/// Controls the icon display mode of the chip.
enum RdsChipIconMode {
  /// No icon — label only.
  none,

  /// Icon is displayed before the label.
  leading,

  /// Icon only — label is not rendered visually (but is used as semantic label).
  iconOnly,
}

// ---------------------------------------------------------------------------
// Widget
// ---------------------------------------------------------------------------

/// A toggleable chip used for multi-select or filter controls.
///
/// Clicking the chip toggles between selected and unselected states and calls
/// [onChanged] with the new value. When [disabled] is `true` the chip does not
/// respond to interaction.
///
/// Selected state: [primaryContainer] background, [onPrimaryContainer] content,
/// leading checkmark icon.
/// Unselected state: [surfaceContainer] background, [onSurface] content, [outline] border.
///
/// ## Usage
/// ```dart
/// RdsInputChip(
///   label: 'Cardiology',
///   selected: _selected,
///   onChanged: (v) => setState(() => _selected = v),
/// )
/// ```
class RdsInputChip extends StatefulWidget {
  /// Text label for the chip. Also used as the semantic label when
  /// [iconMode] is [RdsChipIconMode.iconOnly].
  final String label;

  /// Whether to show an icon, and where.
  final RdsChipIconMode iconMode;

  /// The icon to display. Required when [iconMode] is not [RdsChipIconMode.none].
  final IconData? icon;

  /// Whether the chip is currently selected.
  final bool selected;

  /// Called when the user toggles the chip.
  final ValueChanged<bool>? onChanged;

  /// When `true` the chip ignores interaction and renders at reduced opacity.
  final bool disabled;

  const RdsInputChip({
    super.key,
    required this.label,
    this.iconMode = RdsChipIconMode.none,
    this.icon,
    this.selected = false,
    this.onChanged,
    this.disabled = false,
  });

  @override
  State<RdsInputChip> createState() => _RdsInputChipState();
}

class _RdsInputChipState extends State<RdsInputChip> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  void _handleTap() {
    if (widget.disabled) return;
    widget.onChanged?.call(!widget.selected);
  }

  // ---------------------------------------------------------------------------
  // Style helpers
  // ---------------------------------------------------------------------------

  Color _backgroundColor(RdsTheme rds) {
    if (widget.selected) return rds.primaryContainer;
    return rds.surfaceContainer;
  }

  Color _contentColor(RdsTheme rds) {
    if (widget.selected) return rds.onPrimaryContainer;
    return rds.onSurface;
  }

  Color _stateOverlayColor(RdsTheme rds) {
    final base = _contentColor(rds);
    if (_pressed) return base.withOpacity(rds.statePressed);
    if (_focused) return base.withOpacity(rds.stateFocus);
    if (_hovered) return base.withOpacity(rds.stateHover);
    return Colors.transparent;
  }

  Border? _border(RdsTheme rds) {
    if (widget.selected) return null;
    return Border.all(color: rds.outline, width: 1);
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final contentColor = _contentColor(rds);
    final opacity = widget.disabled ? rds.opacityDisabled : 1.0;

    // Determine leading icon: selected always shows a checkmark in leading/none mode.
    Widget? leadingIcon;
    if (widget.iconMode == RdsChipIconMode.leading ||
        (widget.iconMode == RdsChipIconMode.none && widget.selected)) {
      final displayIcon = widget.selected
          ? RdsIcons.check
          : (widget.icon ?? RdsIcons.check);
      leadingIcon = Icon(
        widget.selected ? RdsIcons.check : displayIcon,
        size: 16,
        color: contentColor,
      );
    } else if (widget.iconMode == RdsChipIconMode.iconOnly) {
      leadingIcon = Icon(
        widget.selected ? RdsIcons.check : (widget.icon ?? RdsIcons.check),
        size: 16,
        color: contentColor,
      );
    }

    Widget chipContent;

    switch (widget.iconMode) {
      case RdsChipIconMode.iconOnly:
        chipContent = leadingIcon ?? const SizedBox.shrink();

      case RdsChipIconMode.none:
      case RdsChipIconMode.leading:
        chipContent = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              leadingIcon,
              SizedBox(width: rds.space1),
            ],
            Text(
              widget.label,
              style: rds.labelMedium.copyWith(color: contentColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
    }

    // Wrap in ConstrainedBox for 44px min touch target.
    return Semantics(
      button: true,
      checked: widget.selected,
      enabled: !widget.disabled,
      label: widget.label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Align(
          alignment: Alignment.center,
          child: Opacity(
            opacity: opacity,
            child: MouseRegion(
              onEnter: widget.disabled ? null : (_) => setState(() => _hovered = true),
              onExit: widget.disabled ? null : (_) => setState(() => _hovered = false),
              cursor: widget.disabled
                  ? SystemMouseCursors.forbidden
                  : SystemMouseCursors.click,
              child: GestureDetector(
                onTapDown: widget.disabled ? null : (_) => setState(() => _pressed = true),
                onTapUp: widget.disabled ? null : (_) => setState(() => _pressed = false),
                onTapCancel: widget.disabled ? null : () => setState(() => _pressed = false),
                onTap: widget.disabled ? null : _handleTap,
                child: Focus(
                  onFocusChange: (hasFocus) => setState(() => _focused = hasFocus),
                  child: Container(
                    height: 32,
                    padding: EdgeInsets.symmetric(horizontal: rds.space3),
                    decoration: BoxDecoration(
                      color: _backgroundColor(rds),
                      borderRadius: BorderRadius.circular(rds.radiusFull),
                      border: _border(rds),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        chipContent,
                        // State layer overlay
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              decoration: BoxDecoration(
                                color: _stateOverlayColor(rds),
                                borderRadius: BorderRadius.circular(rds.radiusFull),
                              ),
                            ),
                          ),
                        ),
                        // Focus ring
                        if (_focused && !widget.disabled)
                          Positioned.fill(
                            child: IgnorePointer(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(rds.radiusFull),
                                  border: Border.all(
                                    color: rds.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
