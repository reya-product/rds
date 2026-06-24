import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';
import '../../tokens/rds_icon_size.dart';
import '../tabs/rds_tab_item.dart';

export '../tabs/rds_tab_item.dart';

// ---------------------------------------------------------------------------
// RdsContainerTabs
// ---------------------------------------------------------------------------

/// A horizontal "folder tab" bar where the active tab appears elevated above
/// a full-width bottom divider, visually connecting to the content panel below.
///
/// - **Active tab** — surface fill, 3-sided border (top/left/right), top
///   corners rounded, 31px tall.
/// - **Inactive tabs** — surfaceContainer fill, no border, 28px tall.
/// - Both rows are bottom-aligned inside a 32px bar so the height difference
///   creates the lifted/recessed effect without custom painting.
///
/// Reuses [RdsTabItem] and [RdsTabIconMode] from the standard tab components.
///
/// ```dart
/// RdsContainerTabs(
///   tabs: const [
///     RdsTabItem(label: 'Overview'),
///     RdsTabItem(label: 'Members'),
///     RdsTabItem(label: 'Settings'),
///   ],
///   selectedIndex: _index,
///   onChanged: (i) => setState(() => _index = i),
/// )
/// ```
class RdsContainerTabs extends StatelessWidget {
  const RdsContainerTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.iconMode = RdsTabIconMode.none,
  });

  final List<RdsTabItem> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final RdsTabIconMode iconMode;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return SizedBox(
      height: 32,
      child: Stack(
        children: [
          // Full-width bottom divider — active tab's surface fill covers it
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 1,
            child: ColoredBox(color: rds.outlineVariant),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(tabs.length, (i) {
                return _ContainerTabItem(
                  item: tabs[i],
                  isSelected: i == selectedIndex,
                  iconMode: iconMode,
                  rds: rds,
                  onTap: tabs[i].disabled ? null : () => onChanged(i),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ContainerTabItem
// ---------------------------------------------------------------------------

class _ContainerTabItem extends StatefulWidget {
  const _ContainerTabItem({
    required this.item,
    required this.isSelected,
    required this.iconMode,
    required this.rds,
    required this.onTap,
  });

  final RdsTabItem item;
  final bool isSelected;
  final RdsTabIconMode iconMode;
  final RdsTheme rds;
  final VoidCallback? onTap;

  @override
  State<_ContainerTabItem> createState() => _ContainerTabItemState();
}

class _ContainerTabItemState extends State<_ContainerTabItem> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _isInteractive => widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final rds = widget.rds;
    final isSelected = widget.isSelected;
    final item = widget.item;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final animDuration = reducedMotion ? rds.durationInstant : rds.durationFast;

    final Color fill;
    final Color textColor;
    final double height;
    final BorderRadius borderRadius;

    if (item.disabled) {
      fill = rds.surfaceContainer;
      textColor = rds.onSurfaceVariant.withOpacity(rds.opacityDisabled);
      height = 28;
      borderRadius = BorderRadius.zero;
    } else if (isSelected) {
      fill = rds.surface;
      textColor = rds.onSurface;
      height = 31;
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(rds.radiusMd),
        topRight: Radius.circular(rds.radiusMd),
      );
    } else {
      fill = rds.surfaceContainer;
      textColor = rds.onSurfaceVariant;
      height = 28;
      borderRadius = BorderRadius.zero;
    }

    double stateOpacity = 0.0;
    if (_isInteractive && !item.disabled) {
      if (_pressed) {
        stateOpacity = rds.statePressed;
      } else if (_focused) {
        stateOpacity = rds.stateFocus;
      } else if (_hovered) {
        stateOpacity = rds.stateHover;
      }
    }

    Widget tabBody = AnimatedContainer(
      duration: animDuration,
      curve: rds.curveStandard,
      height: height,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: borderRadius,
        border: isSelected && !item.disabled
            ? Border(
                top: BorderSide(color: rds.outlineVariant, width: 1),
                left: BorderSide(color: rds.outlineVariant, width: 1),
                right: BorderSide(color: rds.outlineVariant, width: 1),
              )
            : _focused && _isInteractive
                ? Border.all(color: rds.primary, width: 2)
                : !item.disabled
                    ? Border(
                        top: BorderSide(color: rds.outlineVariant, width: 1),
                        right: BorderSide(color: rds.outlineVariant, width: 1),
                      )
                    : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildContent(item, textColor, rds),
          if (stateOpacity > 0)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: rds.onSurface.withOpacity(stateOpacity),
                  borderRadius: borderRadius,
                ),
              ),
            ),
        ],
      ),
    );

    return Semantics(
      selected: isSelected,
      button: true,
      label: item.label,
      enabled: !item.disabled,
      child: MouseRegion(
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
          onTap: widget.onTap,
          child: Focus(
            onFocusChange: (hasFocus) => setState(() => _focused = hasFocus),
            child: tabBody,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(RdsTabItem item, Color textColor, RdsTheme rds) {
    const double iconSize = RdsIconSize.md;

    Widget? iconWidget;
    if (widget.iconMode != RdsTabIconMode.none && item.icon != null) {
      iconWidget = Icon(item.icon, size: iconSize, color: textColor);
    }

    Widget? labelWidget;
    if (widget.iconMode != RdsTabIconMode.iconOnly) {
      labelWidget = Text(
        item.label,
        style: rds.labelLarge.copyWith(color: textColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    Widget inner;
    if (widget.iconMode == RdsTabIconMode.iconOnly && iconWidget != null) {
      inner = Tooltip(message: item.label, child: iconWidget);
    } else if (widget.iconMode == RdsTabIconMode.leading &&
        iconWidget != null &&
        labelWidget != null) {
      inner = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          SizedBox(width: rds.space1),
          labelWidget,
        ],
      );
    } else {
      inner = labelWidget ?? iconWidget ?? const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: rds.space3),
      child: inner,
    );
  }
}
