import 'package:flutter/material.dart';

import '../avatar/rds_avatar.dart';
import '../badge/rds_badge.dart';

// ---------------------------------------------------------------------------
// Leading slot enum
// ---------------------------------------------------------------------------

/// Controls what appears in the leading (left) slot of an [RdsListItem].
enum RdsListItemLeading {
  /// No leading widget.
  none,

  /// A [Icon] using [RdsListItem.leadingIcon].
  icon,

  /// A [RdsAvatar] configured by [RdsListItem.leadingAvatar].
  avatar,

  /// A [RdsCheckbox] driven by [RdsListItem.checkboxValue] and
  /// [RdsListItem.onCheckboxChanged].
  checkbox,

  /// A [RdsRadio] driven by [RdsListItem.radioValue],
  /// [RdsListItem.radioGroupValue], and [RdsListItem.onRadioChanged].
  radio,

  /// A [RdsToggleSwitch] driven by [RdsListItem.toggleValue] and
  /// [RdsListItem.onToggleChanged].
  toggle,
}

// ---------------------------------------------------------------------------
// Trailing slot enum
// ---------------------------------------------------------------------------

/// Controls what appears in the trailing (right) slot of an [RdsListItem].
enum RdsListItemTrailing {
  /// No trailing widget.
  none,

  /// A [Icon] using [RdsListItem.trailingIcon].
  icon,

  /// A [RdsAvatar] configured by [RdsListItem.trailingAvatar].
  avatar,

  /// A [RdsCheckbox] driven by [RdsListItem.checkboxValue] and
  /// [RdsListItem.onCheckboxChanged].
  checkbox,

  /// A [RdsRadio] driven by [RdsListItem.radioValue],
  /// [RdsListItem.radioGroupValue], and [RdsListItem.onRadioChanged].
  radio,

  /// A [RdsToggleSwitch] driven by [RdsListItem.toggleValue] and
  /// [RdsListItem.onToggleChanged].
  toggle,
}

// ---------------------------------------------------------------------------
// Badge position enum
// ---------------------------------------------------------------------------

/// Controls where the badge is rendered relative to the text block.
enum RdsListItemBadgePosition {
  /// No badge shown.
  none,

  /// Badge appears above the overline text.
  aboveOverline,

  /// Badge appears between the primary text and the supporting text.
  belowPrimaryAboveSupporting,

  /// Badge appears below the supporting text.
  belowSupporting,
}

// ---------------------------------------------------------------------------
// Avatar config data class
// ---------------------------------------------------------------------------

/// Configuration bundle for an [RdsAvatar] used inside [RdsListItem].
class RdsAvatarConfig {
  /// How the avatar content is rendered.
  final RdsAvatarType type;

  /// Network image URL. Required when [type] is [RdsAvatarType.image].
  final String? imageUrl;

  /// Icon data. Required when [type] is [RdsAvatarType.icon].
  final IconData? icon;

  /// Full name for initials. Required when [type] is [RdsAvatarType.initials].
  final String? name;

  /// Avatar diameter token.
  final RdsAvatarSize size;

  /// Background color. Falls back to [RdsTheme.primaryContainer] when null.
  final Color? backgroundColor;

  const RdsAvatarConfig({
    required this.type,
    this.imageUrl,
    this.icon,
    this.name,
    this.size = RdsAvatarSize.md,
    this.backgroundColor,
  });
}

// ---------------------------------------------------------------------------
// Badge config data class
// ---------------------------------------------------------------------------

/// Configuration bundle for an [RdsBadge] used inside [RdsListItem].
class RdsBadgeConfig {
  /// Text displayed inside the badge.
  final String label;

  /// Whether/where to show an icon.
  final RdsBadgeIconMode iconMode;

  /// Icon to display when [iconMode] is not [RdsBadgeIconMode.none].
  final IconData? icon;

  /// Color scheme applied to background and text/icon.
  final RdsBadgeColor color;

  /// Controls height and text scale.
  final RdsBadgeSize size;

  const RdsBadgeConfig({
    required this.label,
    this.iconMode = RdsBadgeIconMode.none,
    this.icon,
    this.color = RdsBadgeColor.neutral,
    this.size = RdsBadgeSize.medium,
  });
}
