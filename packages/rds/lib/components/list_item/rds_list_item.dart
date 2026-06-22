import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';
import '../../tokens/rds_icon_size.dart';
import '../../tokens/rds_icons.dart';
import '../avatar/rds_avatar.dart';
import '../badge/rds_badge.dart';
import '../checkbox/rds_checkbox.dart';
import '../radio/rds_radio.dart';
import '../toggle_switch/rds_toggle_switch.dart';
import 'rds_list_item_config.dart';

// Re-export config so consumers need only one import.
export 'rds_list_item_config.dart';

// ---------------------------------------------------------------------------
// RdsListItem
// ---------------------------------------------------------------------------

/// A highly configurable row widget used in lists, menus, and selection UIs.
///
/// Every part of the row is independently toggled through props:
/// - [leading] / [trailing] — slot type from [RdsListItemLeading] / [RdsListItemTrailing]
/// - [overline] — UPPERCASE micro-label above [primaryText]
/// - [primaryText] — the main required label
/// - [supportingText] — secondary line below primary
/// - [badgePosition] / [badge] — optional [RdsBadge] at a named position
/// - [onTap] — when non-null makes the row interactive (hover + press overlays)
/// - [selected] / [enabled] — selection and enabled states
///
/// ## Usage
/// ```dart
/// // Simple text row
/// RdsListItem(primaryText: 'Patient name')
///
/// // Row with leading icon and trailing toggle
/// RdsListItem(
///   primaryText: 'Notifications',
///   supportingText: 'Allow push notifications',
///   leading: RdsListItemLeading.icon,
///   leadingIcon: RdsIcons.notification,
///   trailing: RdsListItemTrailing.toggle,
///   toggleValue: _notificationsOn,
///   onToggleChanged: (v) => setState(() => _notificationsOn = v),
///   onTap: () => setState(() => _notificationsOn = !_notificationsOn),
/// )
///
/// // Selectable row with avatar
/// RdsListItem(
///   primaryText: 'Jane Doe',
///   supportingText: 'jane@example.com',
///   leading: RdsListItemLeading.avatar,
///   leadingAvatar: RdsAvatarConfig(type: RdsAvatarType.initials, name: 'Jane Doe'),
///   selected: _isSelected,
///   onTap: () => setState(() => _isSelected = !_isSelected),
/// )
/// ```
class RdsListItem extends StatefulWidget {
  // ---- Text content ----

  /// Main label. Required.
  final String primaryText;

  /// Optional UPPERCASE text displayed above [primaryText].
  /// Rendered with [RdsTheme.labelSmall] in [RdsTheme.onSurfaceMuted]
  /// (or [RdsTheme.primary] when [selected]).
  final String? overline;

  /// Optional secondary text displayed below [primaryText].
  final String? supportingText;

  // ---- Slots ----

  /// What to show in the leading (left) slot.
  final RdsListItemLeading leading;

  /// What to show in the trailing (right) slot.
  final RdsListItemTrailing trailing;

  // ---- Badge ----

  /// Where to render the [badge].
  final RdsListItemBadgePosition badgePosition;

  /// Badge configuration. Only rendered when [badgePosition] is not
  /// [RdsListItemBadgePosition.none].
  final RdsBadgeConfig? badge;

  // ---- Leading slot data ----

  /// Icon for [RdsListItemLeading.icon].
  final IconData? leadingIcon;

  /// Avatar config for [RdsListItemLeading.avatar].
  final RdsAvatarConfig? leadingAvatar;

  // ---- Trailing slot data ----

  /// Icon for [RdsListItemTrailing.icon].
  final IconData? trailingIcon;

  /// Avatar config for [RdsListItemTrailing.avatar].
  final RdsAvatarConfig? trailingAvatar;

  // ---- Control callbacks (shared between leading & trailing) ----

  /// Current value for checkbox (leading or trailing).
  final bool? checkboxValue;

  /// Callback when checkbox value changes.
  final ValueChanged<bool?>? onCheckboxChanged;

  /// Value this radio represents.
  final dynamic radioValue;

  /// Currently selected value in the radio group.
  final dynamic radioGroupValue;

  /// Callback when this radio is selected.
  final ValueChanged? onRadioChanged;

  /// Current value for toggle switch.
  final bool toggleValue;

  /// Callback when toggle switch changes.
  final ValueChanged<bool>? onToggleChanged;

  // ---- Interaction ----

  /// When non-null, the entire row is tappable and shows hover/press overlays.
  final VoidCallback? onTap;

  // ---- State ----

  /// When true: [RdsTheme.primaryContainer] background; leading icon and
  /// overline are tinted [RdsTheme.primary].
  final bool selected;

  /// When false: applies [RdsTheme.opacityDisabled] to the full row and
  /// blocks all interaction.
  final bool enabled;

  const RdsListItem({
    super.key,
    required this.primaryText,
    this.overline,
    this.supportingText,
    this.leading = RdsListItemLeading.none,
    this.trailing = RdsListItemTrailing.none,
    this.badgePosition = RdsListItemBadgePosition.none,
    this.badge,
    this.leadingIcon,
    this.leadingAvatar,
    this.trailingIcon,
    this.trailingAvatar,
    this.checkboxValue,
    this.onCheckboxChanged,
    this.radioValue,
    this.radioGroupValue,
    this.onRadioChanged,
    this.toggleValue = false,
    this.onToggleChanged,
    this.onTap,
    this.selected = false,
    this.enabled = true,
  });

  @override
  State<RdsListItem> createState() => _RdsListItemState();
}

class _RdsListItemState extends State<RdsListItem> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _isInteractive => widget.enabled && widget.onTap != null;

  // ---------------------------------------------------------------------------
  // Leading widget
  // ---------------------------------------------------------------------------

  Widget _buildLeading(RdsTheme rds) {
    final iconColor = widget.selected ? rds.primary : rds.onSurfaceVariant;

    switch (widget.leading) {
      case RdsListItemLeading.none:
        return const SizedBox.shrink();

      case RdsListItemLeading.icon:
        return Icon(
          widget.leadingIcon ?? RdsIcons.user,
          size: RdsIconSize.lg,
          color: iconColor,
        );

      case RdsListItemLeading.avatar:
        final cfg = widget.leadingAvatar;
        return RdsAvatar(
          type: cfg?.type ?? RdsAvatarType.icon,
          imageUrl: cfg?.imageUrl,
          icon: cfg?.icon,
          name: cfg?.name,
          size: cfg?.size ?? RdsAvatarSize.md,
          backgroundColor: cfg?.backgroundColor,
        );

      case RdsListItemLeading.checkbox:
        return RdsCheckbox(
          value: widget.checkboxValue,
          onChanged: widget.enabled ? widget.onCheckboxChanged : null,
          disabled: !widget.enabled,
        );

      case RdsListItemLeading.radio:
        return RdsRadio(
          value: widget.radioValue,
          groupValue: widget.radioGroupValue,
          onChanged: widget.enabled ? widget.onRadioChanged : null,
          disabled: !widget.enabled,
        );

      case RdsListItemLeading.toggle:
        return RdsToggleSwitch(
          value: widget.toggleValue,
          onChanged: widget.enabled ? widget.onToggleChanged : null,
          disabled: !widget.enabled,
        );
    }
  }

  // ---------------------------------------------------------------------------
  // Trailing widget
  // ---------------------------------------------------------------------------

  Widget _buildTrailing(RdsTheme rds) {
    switch (widget.trailing) {
      case RdsListItemTrailing.none:
        return const SizedBox.shrink();

      case RdsListItemTrailing.icon:
        return Icon(
          widget.trailingIcon ?? RdsIcons.chevronRight,
          size: RdsIconSize.md,
          color: rds.onSurfaceMuted,
        );

      case RdsListItemTrailing.avatar:
        final cfg = widget.trailingAvatar;
        return RdsAvatar(
          type: cfg?.type ?? RdsAvatarType.icon,
          imageUrl: cfg?.imageUrl,
          icon: cfg?.icon,
          name: cfg?.name,
          size: cfg?.size ?? RdsAvatarSize.sm,
          backgroundColor: cfg?.backgroundColor,
        );

      case RdsListItemTrailing.checkbox:
        return RdsCheckbox(
          value: widget.checkboxValue,
          onChanged: widget.enabled ? widget.onCheckboxChanged : null,
          disabled: !widget.enabled,
        );

      case RdsListItemTrailing.radio:
        return RdsRadio(
          value: widget.radioValue,
          groupValue: widget.radioGroupValue,
          onChanged: widget.enabled ? widget.onRadioChanged : null,
          disabled: !widget.enabled,
        );

      case RdsListItemTrailing.toggle:
        return RdsToggleSwitch(
          value: widget.toggleValue,
          onChanged: widget.enabled ? widget.onToggleChanged : null,
          disabled: !widget.enabled,
        );
    }
  }

  // ---------------------------------------------------------------------------
  // Badge widget
  // ---------------------------------------------------------------------------

  Widget? _buildBadge() {
    final cfg = widget.badge;
    if (cfg == null || widget.badgePosition == RdsListItemBadgePosition.none) {
      return null;
    }
    return RdsBadge(
      label: cfg.label,
      iconMode: cfg.iconMode,
      icon: cfg.icon,
      color: cfg.color,
      size: cfg.size,
    );
  }

  // ---------------------------------------------------------------------------
  // Text block
  // ---------------------------------------------------------------------------

  Widget _buildTextBlock(RdsTheme rds) {
    final overlineColor = widget.selected ? rds.primary : rds.onSurfaceMuted;
    final badgeWidget = _buildBadge();

    final children = <Widget>[];

    // Above-overline badge
    if (badgeWidget != null &&
        widget.badgePosition == RdsListItemBadgePosition.aboveOverline) {
      children.add(badgeWidget);
      children.add(SizedBox(height: rds.space1));
    }

    // Overline
    if (widget.overline != null && widget.overline!.isNotEmpty) {
      children.add(
        Text(
          widget.overline!.toUpperCase(),
          style: rds.labelSmall.copyWith(color: overlineColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
      children.add(SizedBox(height: rds.space1));
    }

    // Primary text
    children.add(
      Text(
        widget.primaryText,
        style: rds.bodyLarge.copyWith(color: rds.onSurface),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );

    // Below-primary-above-supporting badge
    if (badgeWidget != null &&
        widget.badgePosition ==
            RdsListItemBadgePosition.belowPrimaryAboveSupporting) {
      children.add(SizedBox(height: rds.space1));
      children.add(badgeWidget);
    }

    // Supporting text
    if (widget.supportingText != null && widget.supportingText!.isNotEmpty) {
      children.add(SizedBox(height: rds.space1));
      children.add(
        Text(
          widget.supportingText!,
          style: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    // Below-supporting badge
    if (badgeWidget != null &&
        widget.badgePosition == RdsListItemBadgePosition.belowSupporting) {
      children.add(SizedBox(height: rds.space1));
      children.add(badgeWidget);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    final hasLeading = widget.leading != RdsListItemLeading.none;
    final hasTrailing = widget.trailing != RdsListItemTrailing.none;

    // Background
    Color bgColor = widget.selected ? rds.primaryContainer : rds.surface;

    // State layer
    double stateOpacity = 0.0;
    if (_isInteractive) {
      if (_pressed) {
        stateOpacity = rds.statePressed;
      } else if (_hovered) {
        stateOpacity = rds.stateHover;
      }
    }

    Widget content = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: rds.space3,
          horizontal: rds.space4,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading zone
            if (hasLeading) ...[
              SizedBox(
                width: 40,
                child: Center(child: _buildLeading(rds)),
              ),
              SizedBox(width: rds.space3),
            ],

            // Text block — expands to fill remaining space
            Expanded(child: _buildTextBlock(rds)),

            // Trailing zone
            if (hasTrailing) ...[
              SizedBox(width: rds.space3),
              SizedBox(
                width: 40,
                child: Center(child: _buildTrailing(rds)),
              ),
            ],
          ],
        ),
      ),
    );

    // State layer overlay + background
    content = AnimatedContainer(
      duration: rds.durationStandard,
      curve: rds.curveStandard,
      color: bgColor,
      child: Stack(
        children: [
          content,
          if (stateOpacity > 0)
            Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(
                  color: rds.onSurface.withOpacity(stateOpacity),
                ),
              ),
            ),
        ],
      ),
    );

    // Disabled opacity
    if (!widget.enabled) {
      content = Opacity(opacity: rds.opacityDisabled, child: content);
    }

    // Interaction wrappers
    if (widget.onTap != null) {
      content = MouseRegion(
        cursor: widget.enabled
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
          onTap: _isInteractive ? widget.onTap : null,
          child: content,
        ),
      );
    }

    return Semantics(
      button: widget.onTap != null,
      selected: widget.selected,
      enabled: widget.enabled,
      label: widget.primaryText,
      child: content,
    );
  }
}
