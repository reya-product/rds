import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';
import '../../tokens/rds_icon_size.dart';
import '../../tokens/rds_shadows.dart';
import '../avatar/rds_avatar.dart';
import '../badge/rds_badge.dart';
import '../button/rds_button.dart';
import '../list_item/rds_list_item.dart';
import '../list_item/rds_list_item_config.dart';
import 'rds_card_action.dart';

export 'rds_card_action.dart';

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// Controls the shadow depth of [RdsCard].
enum RdsCardElevation {
  /// No shadow — flat surface.
  none,

  /// Subtle shadow (`shadow-sm`). The default.
  low,

  /// Moderate shadow (`shadow-md`). Use for popovers or highlighted cards.
  medium,
}

/// Controls which content type is rendered in the card body zone.
enum RdsCardBodyType {
  /// The body renders a list of [RdsListItem] widgets.
  listItems,

  /// The body renders a full-bleed network image.
  image,
}

/// Controls what appears in the card header's leading (left) slot.
enum RdsCardHeaderLeading {
  /// No leading widget.
  none,

  /// An [RdsAvatar] configured by [RdsCard.headerLeadingAvatar].
  avatar,

  /// An [RdsBadge] configured by [RdsCard.headerLeadingBadge].
  badge,
}

/// Controls what appears in the card header's trailing (right) slot.
enum RdsCardHeaderTrailing {
  /// No trailing widget.
  none,

  /// An [RdsBadge] configured by [RdsCard.headerTrailingBadge].
  badge,

  /// A tappable icon button using [RdsCard.headerTrailingIcon].
  iconButton,
}

// ---------------------------------------------------------------------------
// RdsCard
// ---------------------------------------------------------------------------

/// The primary content container in RDS.
///
/// Composes three optional/required zones:
/// - **Header** (optional) — avatar/badge leading, primary/secondary text,
///   badge/icon-button trailing.
/// - **Body** (required) — list items, a network image, or arbitrary content.
/// - **Footer** (optional) — a row of [RdsCardAction] buttons.
///
/// ## Usage
/// ```dart
/// // Basic list card
/// RdsCard(
///   headerPrimaryText: 'Jane Doe',
///   headerSecondaryText: 'Patient · Age 34',
///   headerLeading: RdsCardHeaderLeading.avatar,
///   headerLeadingAvatar: const RdsAvatarConfig(
///     type: RdsAvatarType.initials,
///     name: 'Jane Doe',
///   ),
///   bodyItems: [
///     RdsListItem(primaryText: 'Heart rate', supportingText: '72 bpm'),
///     RdsListItem(primaryText: 'Blood pressure', supportingText: '120/80'),
///   ],
///   footerActions: [
///     RdsCardAction(label: 'View details', onPressed: () {}),
///   ],
/// )
///
/// // Metric card with custom body content
/// RdsCard(
///   bodyContent: Column(
///     children: [
///       Text('98.6°F', style: rds.displaySmall),
///       Text('Body temperature', style: rds.bodySmall),
///     ],
///   ),
///   footerActions: [
///     RdsCardAction(label: 'Details', onPressed: () {}),
///   ],
/// )
/// ```
class RdsCard extends StatefulWidget {
  // ---- Header zone ----

  /// What to show in the header leading slot.
  final RdsCardHeaderLeading headerLeading;

  /// Avatar config when [headerLeading] is [RdsCardHeaderLeading.avatar].
  final RdsAvatarConfig? headerLeadingAvatar;

  /// Badge config when [headerLeading] is [RdsCardHeaderLeading.badge].
  final RdsBadgeConfig? headerLeadingBadge;

  /// Main header text rendered in `titleMedium`.
  final String? headerPrimaryText;

  /// Subtitle rendered in `bodySmall` with `onSurfaceVariant` color.
  final String? headerSecondaryText;

  /// What to show in the header trailing slot.
  final RdsCardHeaderTrailing headerTrailing;

  /// Badge config when [headerTrailing] is [RdsCardHeaderTrailing.badge].
  final RdsBadgeConfig? headerTrailingBadge;

  /// Icon data when [headerTrailing] is [RdsCardHeaderTrailing.iconButton].
  final IconData? headerTrailingIcon;

  /// Tap callback for the trailing icon button.
  final VoidCallback? onHeaderTrailingTap;

  // ---- Body zone ----

  /// Whether the body renders list items or an image.
  /// Ignored when [bodyContent] is non-null.
  final RdsCardBodyType bodyType;

  /// List of [RdsListItem] widgets rendered when [bodyType] is
  /// [RdsCardBodyType.listItems] and [bodyContent] is null.
  final List<RdsListItem> bodyItems;

  /// Network image URL used when [bodyType] is [RdsCardBodyType.image]
  /// and [bodyContent] is null.
  final String? bodyImageUrl;

  /// Fixed height of the body image in logical pixels.
  final double bodyImageHeight;

  /// Escape hatch: when non-null this widget is rendered as the entire body,
  /// taking priority over [bodyType], [bodyItems], and [bodyImageUrl].
  /// It is wrapped in standard `space4` padding.
  final Widget? bodyContent;

  // ---- Footer zone ----

  /// Actions rendered as [RdsButton]s in the footer row.
  /// Empty list → no footer rendered.
  final List<RdsCardAction> footerActions;

  // ---- Card-level ----

  /// Shadow depth. Defaults to [RdsCardElevation.low].
  final RdsCardElevation elevation;

  /// When true, renders a 1px `outlineVariant` border around the card.
  final bool outlined;

  /// When non-null the whole card is tappable with hover/press overlays.
  final VoidCallback? onTap;

  /// When true the background is tinted [RdsTheme.primaryContainer].
  final bool selected;

  /// Explicit width in logical pixels. When null the card fills its parent.
  final double? width;

  const RdsCard({
    super.key,
    // Header
    this.headerLeading = RdsCardHeaderLeading.none,
    this.headerLeadingAvatar,
    this.headerLeadingBadge,
    this.headerPrimaryText,
    this.headerSecondaryText,
    this.headerTrailing = RdsCardHeaderTrailing.none,
    this.headerTrailingBadge,
    this.headerTrailingIcon,
    this.onHeaderTrailingTap,
    // Body
    this.bodyType = RdsCardBodyType.listItems,
    this.bodyItems = const [],
    this.bodyImageUrl,
    this.bodyImageHeight = 200,
    this.bodyContent,
    // Footer
    this.footerActions = const [],
    // Card-level
    this.elevation = RdsCardElevation.low,
    this.outlined = true,
    this.onTap,
    this.selected = false,
    this.width,
  });

  @override
  State<RdsCard> createState() => _RdsCardState();
}

class _RdsCardState extends State<RdsCard> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _isInteractive => widget.onTap != null;

  // ---------------------------------------------------------------------------
  // Shadow helper
  // ---------------------------------------------------------------------------

  List<BoxShadow> _resolveShadow() {
    switch (widget.elevation) {
      case RdsCardElevation.none:
        return RdsShadows.shadowNone;
      case RdsCardElevation.low:
        return RdsShadows.shadowSm;
      case RdsCardElevation.medium:
        return RdsShadows.shadowMd;
    }
  }

  // ---------------------------------------------------------------------------
  // Header zone
  // ---------------------------------------------------------------------------

  bool get _hasHeader =>
      widget.headerPrimaryText != null ||
      widget.headerLeading != RdsCardHeaderLeading.none ||
      widget.headerTrailing != RdsCardHeaderTrailing.none;

  Widget _buildHeaderLeading(RdsTheme rds) {
    switch (widget.headerLeading) {
      case RdsCardHeaderLeading.none:
        return const SizedBox.shrink();
      case RdsCardHeaderLeading.avatar:
        final cfg = widget.headerLeadingAvatar;
        return RdsAvatar(
          type: cfg?.type ?? RdsAvatarType.icon,
          imageUrl: cfg?.imageUrl,
          icon: cfg?.icon,
          name: cfg?.name,
          size: cfg?.size ?? RdsAvatarSize.md,
          backgroundColor: cfg?.backgroundColor,
        );
      case RdsCardHeaderLeading.badge:
        final cfg = widget.headerLeadingBadge;
        if (cfg == null) return const SizedBox.shrink();
        return RdsBadge(
          label: cfg.label,
          iconMode: cfg.iconMode,
          icon: cfg.icon,
          color: cfg.color,
          size: cfg.size,
        );
    }
  }

  Widget _buildHeaderTrailing(RdsTheme rds) {
    switch (widget.headerTrailing) {
      case RdsCardHeaderTrailing.none:
        return const SizedBox.shrink();
      case RdsCardHeaderTrailing.badge:
        final cfg = widget.headerTrailingBadge;
        if (cfg == null) return const SizedBox.shrink();
        return RdsBadge(
          label: cfg.label,
          iconMode: cfg.iconMode,
          icon: cfg.icon,
          color: cfg.color,
          size: cfg.size,
        );
      case RdsCardHeaderTrailing.iconButton:
        return Semantics(
          button: true,
          label: 'More options',
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: widget.onHeaderTrailingTap,
              child: Padding(
                padding: EdgeInsets.all(rds.space2),
                child: Icon(
                  widget.headerTrailingIcon,
                  size: RdsIconSize.md,
                  color: rds.onSurfaceVariant,
                ),
              ),
            ),
          ),
        );
    }
  }

  Widget _buildHeader(RdsTheme rds) {
    final hasLeading = widget.headerLeading != RdsCardHeaderLeading.none;
    final hasTrailing = widget.headerTrailing != RdsCardHeaderTrailing.none;

    return Padding(
      padding: EdgeInsets.all(rds.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Leading slot
          if (hasLeading) ...[
            _buildHeaderLeading(rds),
            SizedBox(width: rds.space3),
          ],

          // Text block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.headerPrimaryText != null)
                  Text(
                    widget.headerPrimaryText!,
                    style: rds.titleMedium.copyWith(color: rds.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (widget.headerSecondaryText != null) ...[
                  SizedBox(height: rds.space1),
                  Text(
                    widget.headerSecondaryText!,
                    style: rds.bodySmall.copyWith(color: rds.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Trailing slot
          if (hasTrailing) ...[
            SizedBox(width: rds.space2),
            _buildHeaderTrailing(rds),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Body zone
  // ---------------------------------------------------------------------------

  Widget _buildBody(RdsTheme rds) {
    // Escape hatch: arbitrary content with standard padding
    if (widget.bodyContent != null) {
      return Padding(
        padding: EdgeInsets.all(rds.space4),
        child: widget.bodyContent,
      );
    }

    switch (widget.bodyType) {
      case RdsCardBodyType.listItems:
        if (widget.bodyItems.isEmpty) return const SizedBox.shrink();
        return Column(
          children: widget.bodyItems,
        );

      case RdsCardBodyType.image:
        if (widget.bodyImageUrl == null || widget.bodyImageUrl!.isEmpty) {
          return SizedBox(
            height: widget.bodyImageHeight,
            child: ColoredBox(
              color: rds.surfaceContainer,
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: RdsIconSize.xl,
                  color: rds.onSurfaceMuted,
                ),
              ),
            ),
          );
        }
        // When there is no header above the image, give it top rounded corners
        // matching the card radius. When a header is present, use square top
        // so it appears flush against the header divider.
        final topRadius = _hasHeader
            ? Radius.zero
            : Radius.circular(rds.radiusLg);

        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: topRadius,
            topRight: topRadius,
          ),
          child: Image.network(
            widget.bodyImageUrl!,
            height: widget.bodyImageHeight,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return SizedBox(
                height: widget.bodyImageHeight,
                child: ColoredBox(
                  color: rds.surfaceContainer,
                  child: Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: RdsIconSize.xl,
                      color: rds.onSurfaceMuted,
                    ),
                  ),
                ),
              );
            },
          ),
        );
    }
  }

  // ---------------------------------------------------------------------------
  // Footer zone
  // ---------------------------------------------------------------------------

  Widget _buildFooter(RdsTheme rds) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: rds.space3,
        horizontal: rds.space2,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < widget.footerActions.length; i++) ...[
              _buildFooterAction(rds, widget.footerActions[i]),
              if (i < widget.footerActions.length - 1)
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: rds.outlineVariant,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFooterAction(RdsTheme rds, RdsCardAction action) {
    final iconPosition = action.iconOnly
        ? RdsButtonIconPosition.iconOnly
        : (action.icon != null ? RdsButtonIconPosition.leading : RdsButtonIconPosition.none);

    return RdsButton(
      label: action.label,
      variant: action.variant,
      size: RdsButtonSize.small,
      iconPosition: iconPosition,
      icon: action.icon,
      onPressed: action.onPressed,
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final animDuration =
        reducedMotion ? rds.durationInstant : rds.durationStandard;

    final bgColor = widget.selected ? rds.primaryContainer : rds.surface;
    final shadow = _resolveShadow();
    final radius = BorderRadius.circular(rds.radiusLg);

    // State-layer opacity
    double stateOpacity = 0.0;
    if (_isInteractive) {
      if (_pressed) {
        stateOpacity = rds.statePressed;
      } else if (_hovered) {
        stateOpacity = rds.stateHover;
      }
    }

    // --- Build all zones ---
    final zones = <Widget>[];

    if (_hasHeader) {
      zones.add(_buildHeader(rds));
      // Header / body divider
      zones.add(Divider(
        height: 1,
        thickness: 1,
        color: rds.outlineVariant,
      ));
    }

    zones.add(_buildBody(rds));

    if (widget.footerActions.isNotEmpty) {
      // Body / footer divider
      zones.add(Divider(
        height: 1,
        thickness: 1,
        color: rds.outlineVariant,
      ));
      zones.add(_buildFooter(rds));
    }

    // --- Assemble inner column ---
    Widget inner = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: zones,
    );

    // --- State layer overlay ---
    if (_isInteractive) {
      inner = Stack(
        children: [
          inner,
          if (stateOpacity > 0)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  duration: animDuration,
                  opacity: stateOpacity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: rds.onSurface.withOpacity(1),
                      borderRadius: radius,
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    }

    // --- Card container ---
    Widget card = AnimatedContainer(
      duration: animDuration,
      curve: rds.curveStandard,
      width: widget.width,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: radius,
        boxShadow: shadow,
        border: widget.outlined
            ? Border.all(color: rds.outlineVariant, width: 1)
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: inner,
    );

    // --- Interaction wrappers ---
    if (widget.onTap != null) {
      card = MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() {
          _hovered = false;
          _pressed = false;
        }),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: card,
        ),
      );
    }

    // --- Semantics ---
    return Semantics(
      button: widget.onTap != null,
      selected: widget.selected,
      label: widget.headerPrimaryText,
      child: card,
    );
  }
}
