import 'package:flutter/material.dart';
import '../../theme/rds_theme.dart';
import '../../tokens/rds_icon_size.dart';

import 'rds_tab_item.dart';

export 'rds_tab_item.dart';

// ---------------------------------------------------------------------------
// RdsTabs
// ---------------------------------------------------------------------------

/// A horizontal tab bar built from scratch (no Flutter TabBar wrapper).
///
/// Supports [RdsTabVariant.primary] (underline indicator) and
/// [RdsTabVariant.secondary] (filled pill tabs), with optional leading icons
/// or icon-only mode.
///
/// ```dart
/// RdsTabs(
///   tabs: const [
///     RdsTabItem(label: 'Overview', icon: Symbols.dashboard),
///     RdsTabItem(label: 'Lab Results', icon: Symbols.biotech),
///     RdsTabItem(label: 'Notes', icon: Symbols.notes),
///   ],
///   selectedIndex: _selectedIndex,
///   onChanged: (i) => setState(() => _selectedIndex = i),
/// )
/// ```
class RdsTabs extends StatelessWidget {
  const RdsTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.variant = RdsTabVariant.primary,
    this.iconMode = RdsTabIconMode.none,
  });

  /// The list of tab data objects.
  final List<RdsTabItem> tabs;

  /// Index of the currently selected tab.
  final int selectedIndex;

  /// Called with the new index when a tab is tapped.
  final ValueChanged<int> onChanged;

  /// Visual style variant.
  final RdsTabVariant variant;

  /// Whether to show icons, and where.
  final RdsTabIconMode iconMode;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return switch (variant) {
      RdsTabVariant.primary => _PrimaryTabBar(
          tabs: tabs,
          selectedIndex: selectedIndex,
          onChanged: onChanged,
          iconMode: iconMode,
          rds: rds,
        ),
      RdsTabVariant.secondary => _SecondaryTabBar(
          tabs: tabs,
          selectedIndex: selectedIndex,
          onChanged: onChanged,
          iconMode: iconMode,
          rds: rds,
        ),
    };
  }
}

// ---------------------------------------------------------------------------
// Primary variant — underline indicator
// ---------------------------------------------------------------------------

class _PrimaryTabBar extends StatelessWidget {
  const _PrimaryTabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    required this.iconMode,
    required this.rds,
  });

  final List<RdsTabItem> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final RdsTabIconMode iconMode;
  final RdsTheme rds;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: rds.surface,
        border: Border(
          bottom: BorderSide(color: rds.outlineVariant, width: 1),
        ),
      ),
      height: 48,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(tabs.length, (i) {
            return _PrimaryTabItem(
              item: tabs[i],
              isSelected: i == selectedIndex,
              iconMode: iconMode,
              rds: rds,
              onTap: tabs[i].disabled ? null : () => onChanged(i),
            );
          }),
        ),
      ),
    );
  }
}

class _PrimaryTabItem extends StatefulWidget {
  const _PrimaryTabItem({
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
  State<_PrimaryTabItem> createState() => _PrimaryTabItemState();
}

class _PrimaryTabItemState extends State<_PrimaryTabItem> {
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
    final animDuration = reducedMotion ? rds.durationInstant : rds.durationStandard;

    // Resolve content color
    Color contentColor;
    if (item.disabled) {
      contentColor = rds.onSurfaceVariant.withOpacity(rds.opacityDisabled);
    } else if (isSelected) {
      contentColor = rds.primary;
    } else {
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

    // Build label/icon content
    Widget content = _buildContent(item, contentColor, rds);

    // Focus ring
    if (_focused && _isInteractive) {
      content = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(rds.radiusSm),
          border: Border.all(
            color: rds.primary.withOpacity(rds.stateFocus + 0.2),
            width: 2,
          ),
        ),
        child: content,
      );
    }

    // Assemble the full tab item with indicator
    Widget tabBody = SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // State layer
          if (stateOpacity > 0)
            Positioned.fill(
              child: ColoredBox(
                color: rds.onSurface.withOpacity(stateOpacity),
              ),
            ),
          // Content
          Center(child: content),
          // Animated indicator bar
          AnimatedContainer(
            duration: animDuration,
            curve: rds.curveStandard,
            height: isSelected ? 3 : 0,
            decoration: BoxDecoration(
              color: rds.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
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

  Widget _buildContent(RdsTabItem item, Color contentColor, RdsTheme rds) {
    const double iconSize = RdsIconSize.md;

    Widget? iconWidget;
    if (widget.iconMode != RdsTabIconMode.none && item.icon != null) {
      iconWidget = Icon(item.icon, size: iconSize, color: contentColor);
    }

    Widget? labelWidget;
    if (widget.iconMode != RdsTabIconMode.iconOnly) {
      labelWidget = Text(
        item.label,
        style: rds.labelLarge.copyWith(color: contentColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    Widget inner;
    if (widget.iconMode == RdsTabIconMode.iconOnly && iconWidget != null) {
      // Show tooltip with label for icon-only tabs
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
      padding: EdgeInsets.symmetric(horizontal: rds.space4),
      child: inner,
    );
  }
}

// ---------------------------------------------------------------------------
// Secondary variant — filled pill tabs
// ---------------------------------------------------------------------------

class _SecondaryTabBar extends StatelessWidget {
  const _SecondaryTabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    required this.iconMode,
    required this.rds,
  });

  final List<RdsTabItem> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final RdsTabIconMode iconMode;
  final RdsTheme rds;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: 44,
        padding: EdgeInsets.all(rds.space1),
        decoration: BoxDecoration(
          color: rds.surfaceContainer,
          borderRadius: BorderRadius.circular(rds.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(tabs.length, (i) {
            final spacer = i < tabs.length - 1
                ? SizedBox(width: rds.space2)
                : const SizedBox.shrink();
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SecondaryTabItem(
                  item: tabs[i],
                  isSelected: i == selectedIndex,
                  iconMode: iconMode,
                  rds: rds,
                  onTap: tabs[i].disabled ? null : () => onChanged(i),
                ),
                spacer,
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _SecondaryTabItem extends StatefulWidget {
  const _SecondaryTabItem({
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
  State<_SecondaryTabItem> createState() => _SecondaryTabItemState();
}

class _SecondaryTabItemState extends State<_SecondaryTabItem> {
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
    final animDuration = reducedMotion ? rds.durationInstant : rds.durationStandard;

    // Resolve fill and content color
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

    final borderRadius = BorderRadius.circular(rds.radiusFull);

    // Build label/icon content
    final content = _buildContent(item, contentColor, rds);

    Widget tabBody = AnimatedContainer(
      duration: animDuration,
      curve: rds.curveStandard,
      height: 36,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: borderRadius,
        border: _focused && _isInteractive
            ? Border.all(color: rds.primary, width: 2)
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          content,
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

  Widget _buildContent(RdsTabItem item, Color contentColor, RdsTheme rds) {
    const double iconSize = RdsIconSize.md;

    Widget? iconWidget;
    if (widget.iconMode != RdsTabIconMode.none && item.icon != null) {
      iconWidget = Icon(item.icon, size: iconSize, color: contentColor);
    }

    Widget? labelWidget;
    if (widget.iconMode != RdsTabIconMode.iconOnly) {
      labelWidget = Text(
        item.label,
        style: rds.labelLarge.copyWith(color: contentColor),
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
