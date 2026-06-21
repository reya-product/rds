import 'package:flutter/material.dart';
import 'package:rds/rds.dart';

import 'rds_vertical_tab_item.dart';

export 'rds_vertical_tab_item.dart';

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

const double _kCollapsedWidth = 64.0;
const double _kExpandedWidth = 220.0;
const double _kItemHeight = 48.0;
const double _kAccentBarWidth = 3.0;

// ---------------------------------------------------------------------------
// RdsVerticalTabs
// ---------------------------------------------------------------------------

/// The primary vertical navigation strip for Reya SaaS products.
///
/// Renders a scrollable list of nav items with optional section dividers and
/// a pinned bottom section. Width animates between 64px (collapsed) and 220px
/// (expanded).
///
/// ```dart
/// RdsVerticalTabs(
///   items: navItems,
///   selectedIndex: _selectedIndex,
///   onChanged: (i) => setState(() => _selectedIndex = i),
///   collapsed: _isCollapsed,
/// )
/// ```
class RdsVerticalTabs extends StatelessWidget {
  const RdsVerticalTabs({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.iconMode = RdsVerticalTabIconMode.withLabels,
    this.collapsed = false,
    this.dividerAfterIndices = const [],
    this.bottomItems = const [],
    this.bottomSelectedIndex,
    this.onBottomChanged,
  });

  /// Main navigation items.
  final List<RdsVerticalTabItem> items;

  /// Index of the currently selected main item.
  final int selectedIndex;

  /// Called with the new index when a main item is tapped.
  final ValueChanged<int> onChanged;

  /// Icon/label display mode.
  /// When [collapsed] is true, this is forced to [RdsVerticalTabIconMode.iconOnly].
  final RdsVerticalTabIconMode iconMode;

  /// When true, the strip collapses to 64px and shows icons only.
  final bool collapsed;

  /// Indices of main items after which a section divider is drawn.
  final List<int> dividerAfterIndices;

  /// Optional items pinned to the bottom of the strip (e.g. Settings, Profile).
  final List<RdsVerticalTabItem> bottomItems;

  /// Index of the currently selected bottom item, if any.
  final int? bottomSelectedIndex;

  /// Called when a bottom item is tapped.
  final ValueChanged<int>? onBottomChanged;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final animDuration =
        reducedMotion ? rds.durationInstant : rds.durationEmphasized;

    final effectiveIconMode =
        collapsed ? RdsVerticalTabIconMode.iconOnly : iconMode;

    final double targetWidth = collapsed ? _kCollapsedWidth : _kExpandedWidth;

    return AnimatedContainer(
      duration: animDuration,
      curve: rds.curveEmphasized,
      width: targetWidth,
      decoration: BoxDecoration(
        color: rds.surfaceVariant,
        border: Border(
          right: BorderSide(color: rds.outlineVariant, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Main scrollable nav items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: rds.space2,
                vertical: rds.space2,
              ),
              children: _buildMainItems(context, rds, effectiveIconMode),
            ),
          ),
          // Bottom pinned items
          if (bottomItems.isNotEmpty) ...[
            Divider(
              height: 1,
              thickness: 1,
              color: rds.outlineVariant,
              indent: rds.space2,
              endIndent: rds.space2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: rds.space2,
                vertical: rds.space2,
              ),
              child: Column(
                children: List.generate(bottomItems.length, (i) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: i < bottomItems.length - 1 ? rds.space1 : 0,
                    ),
                    child: _VerticalTabItem(
                      item: bottomItems[i],
                      isSelected: bottomSelectedIndex == i,
                      iconMode: effectiveIconMode,
                      rds: rds,
                      collapsed: collapsed,
                      onTap: bottomItems[i].disabled
                          ? null
                          : () => onBottomChanged?.call(i),
                    ),
                  );
                }),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildMainItems(
    BuildContext context,
    RdsTheme rds,
    RdsVerticalTabIconMode effectiveIconMode,
  ) {
    final widgets = <Widget>[];

    for (int i = 0; i < items.length; i++) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(
            bottom: rds.space1,
          ),
          child: _VerticalTabItem(
            item: items[i],
            isSelected: i == selectedIndex,
            iconMode: effectiveIconMode,
            rds: rds,
            collapsed: collapsed,
            onTap: items[i].disabled ? null : () => onChanged(i),
          ),
        ),
      );

      if (dividerAfterIndices.contains(i)) {
        widgets.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: rds.space2),
            child: Divider(
              height: 1,
              thickness: 1,
              color: rds.outlineVariant,
            ),
          ),
        );
      }
    }

    return widgets;
  }
}

// ---------------------------------------------------------------------------
// Individual nav item
// ---------------------------------------------------------------------------

class _VerticalTabItem extends StatefulWidget {
  const _VerticalTabItem({
    required this.item,
    required this.isSelected,
    required this.iconMode,
    required this.rds,
    required this.collapsed,
    required this.onTap,
  });

  final RdsVerticalTabItem item;
  final bool isSelected;
  final RdsVerticalTabIconMode iconMode;
  final RdsTheme rds;
  final bool collapsed;
  final VoidCallback? onTap;

  @override
  State<_VerticalTabItem> createState() => _VerticalTabItemState();
}

class _VerticalTabItemState extends State<_VerticalTabItem> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _isInteractive => widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final rds = widget.rds;
    final item = widget.item;
    final isSelected = widget.isSelected;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final animDuration =
        reducedMotion ? rds.durationInstant : rds.durationStandard;

    // Resolve colors
    Color fillColor;
    Color contentColor;

    if (item.disabled) {
      fillColor = Colors.transparent;
      contentColor = rds.onSurfaceVariant.withOpacity(rds.opacityDisabled);
    } else if (isSelected) {
      fillColor = rds.primaryContainer;
      contentColor = rds.onPrimaryContainer;
    } else {
      fillColor = Colors.transparent;
      contentColor = rds.onSurfaceVariant;
    }

    // State layer
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

    final borderRadius = BorderRadius.circular(rds.radiusMd);

    Widget innerContent = _buildInnerContent(item, contentColor, rds);

    Widget itemBody = AnimatedContainer(
      duration: animDuration,
      curve: rds.curveStandard,
      height: _kItemHeight,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: borderRadius,
        border: _focused && _isInteractive
            ? Border.all(color: rds.primary, width: 2)
            : null,
      ),
      child: Stack(
        children: [
          // State layer overlay
          if (stateOpacity > 0)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: rds.onSurface.withOpacity(stateOpacity),
                  borderRadius: borderRadius,
                ),
              ),
            ),
          // Left accent bar for selected state
          if (isSelected)
            Positioned(
              left: 0,
              top: 4,
              bottom: 4,
              child: Container(
                width: _kAccentBarWidth,
                decoration: BoxDecoration(
                  color: rds.primary,
                  borderRadius: BorderRadius.circular(rds.radiusFull),
                ),
              ),
            ),
          // Content
          Positioned.fill(child: innerContent),
        ],
      ),
    );

    // Wrap in tooltip for collapsed icon-only mode
    if (widget.collapsed || widget.iconMode == RdsVerticalTabIconMode.iconOnly) {
      itemBody = Tooltip(
        message: item.label,
        preferBelow: false,
        child: itemBody,
      );
    }

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
            child: itemBody,
          ),
        ),
      ),
    );
  }

  Widget _buildInnerContent(
    RdsVerticalTabItem item,
    Color contentColor,
    RdsTheme rds,
  ) {
    const double iconSize = RdsIconSize.lg;

    final iconWidget = Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(item.icon, size: iconSize, color: contentColor),
        if (item.badge != null)
          Positioned(
            top: -4,
            right: -8,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: rds.space1,
                vertical: 1,
              ),
              decoration: BoxDecoration(
                color: rds.primary,
                borderRadius: BorderRadius.circular(rds.radiusFull),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 14),
              child: Text(
                item.badge!,
                style: rds.labelSmall.copyWith(color: rds.onPrimary),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );

    switch (widget.iconMode) {
      case RdsVerticalTabIconMode.iconOnly:
        // Collapsed — icon centered, badge overlay
        return Center(child: iconWidget);

      case RdsVerticalTabIconMode.labelsOnly:
        // Label only, no icon
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: rds.space3),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.label,
              style: rds.labelLarge.copyWith(color: contentColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );

      case RdsVerticalTabIconMode.withLabels:
        // Icon + label, with leading left-bar spacing
        return Padding(
          padding: EdgeInsets.only(
            left: rds.space3 + _kAccentBarWidth,
            right: rds.space3,
          ),
          child: Row(
            children: [
              iconWidget,
              SizedBox(width: rds.space3),
              Expanded(
                child: Text(
                  item.label,
                  style: rds.labelLarge.copyWith(color: contentColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
    }
  }
}
