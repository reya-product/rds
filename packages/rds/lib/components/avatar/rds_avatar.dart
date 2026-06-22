import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';
import '../../tokens/rds_icons.dart';

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// Defines what content the avatar displays.
enum RdsAvatarType {
  /// Shows a network image with an icon fallback on load error.
  image,

  /// Shows a centred icon on a background.
  icon,

  /// Shows up to two initials derived from a [name] string.
  initials,
}

/// Controls the physical size of the avatar circle.
enum RdsAvatarSize {
  /// 24px diameter.
  xs,

  /// 32px diameter.
  sm,

  /// 40px diameter (default).
  md,

  /// 48px diameter.
  lg,

  /// 64px diameter.
  xl,

  /// 80px diameter.
  xxl,
}

// ---------------------------------------------------------------------------
// Widget
// ---------------------------------------------------------------------------

/// A circular avatar that can display an image, icon, or name initials.
///
/// Set [onEdit] to show a pencil badge anchored to the bottom-right of the
/// circle. The badge is always shown when [onEdit] is non-null.
///
/// ## Usage
/// ```dart
/// // Image avatar
/// RdsAvatar(
///   type: RdsAvatarType.image,
///   imageUrl: 'https://example.com/photo.jpg',
///   size: RdsAvatarSize.md,
/// )
///
/// // Initials avatar with edit badge
/// RdsAvatar(
///   type: RdsAvatarType.initials,
///   name: 'Jane Doe',
///   onEdit: () => print('edit tapped'),
/// )
///
/// // Icon avatar
/// RdsAvatar(
///   type: RdsAvatarType.icon,
///   icon: RdsIcons.user,
/// )
/// ```
class RdsAvatar extends StatefulWidget {
  /// How the avatar content is rendered.
  final RdsAvatarType type;

  /// URL for a network image. Required when [type] is [RdsAvatarType.image].
  final String? imageUrl;

  /// Icon to display. Required when [type] is [RdsAvatarType.icon].
  final IconData? icon;

  /// Full name used to derive initials. Required when [type] is [RdsAvatarType.initials].
  final String? name;

  /// Avatar diameter.
  final RdsAvatarSize size;

  /// Background color. Falls back to [RdsTheme.primaryContainer] if null.
  final Color? backgroundColor;

  /// Whether the background fill is shown. When false the circle is transparent.
  final bool showBackground;

  /// When non-null, a circular edit badge (pencil icon) is shown at the
  /// bottom-right of the avatar. Tapping the badge calls this callback.
  final VoidCallback? onEdit;

  const RdsAvatar({
    super.key,
    required this.type,
    this.imageUrl,
    this.icon,
    this.name,
    this.size = RdsAvatarSize.md,
    this.backgroundColor,
    this.showBackground = true,
    this.onEdit,
  });

  @override
  State<RdsAvatar> createState() => _RdsAvatarState();
}

class _RdsAvatarState extends State<RdsAvatar> {
  // ---------------------------------------------------------------------------
  // Size helpers
  // ---------------------------------------------------------------------------

  double _diameter() {
    switch (widget.size) {
      case RdsAvatarSize.xs:
        return 24;
      case RdsAvatarSize.sm:
        return 32;
      case RdsAvatarSize.md:
        return 40;
      case RdsAvatarSize.lg:
        return 48;
      case RdsAvatarSize.xl:
        return 64;
      case RdsAvatarSize.xxl:
        return 80;
    }
  }

  double _iconSize() {
    switch (widget.size) {
      case RdsAvatarSize.xs:
        return 12;
      case RdsAvatarSize.sm:
        return 16;
      case RdsAvatarSize.md:
        return 20;
      case RdsAvatarSize.lg:
        return 24;
      case RdsAvatarSize.xl:
        return 32;
      case RdsAvatarSize.xxl:
        return 40;
    }
  }

  TextStyle _initialsTextStyle(RdsTheme rds) {
    switch (widget.size) {
      case RdsAvatarSize.xs:
        return rds.labelSmall;
      case RdsAvatarSize.sm:
      case RdsAvatarSize.md:
        return rds.labelMedium;
      case RdsAvatarSize.lg:
        return rds.labelLarge;
      case RdsAvatarSize.xl:
      case RdsAvatarSize.xxl:
        return rds.titleMedium;
    }
  }

  // Edit badge diameter scales with avatar size.
  double _badgeDiameter() {
    switch (widget.size) {
      case RdsAvatarSize.xs:
      case RdsAvatarSize.sm:
        return 14;
      case RdsAvatarSize.md:
      case RdsAvatarSize.lg:
        return 20;
      case RdsAvatarSize.xl:
      case RdsAvatarSize.xxl:
        return 24;
    }
  }

  // ---------------------------------------------------------------------------
  // Initials extraction
  // ---------------------------------------------------------------------------

  String _extractInitials(String fullName) {
    final words = fullName.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final diameter = _diameter();
    final bg = widget.showBackground
        ? (widget.backgroundColor ?? rds.primaryContainer)
        : Colors.transparent;
    final fgColor = widget.backgroundColor != null
        ? rds.onPrimary
        : rds.onPrimaryContainer;

    Widget inner;

    switch (widget.type) {
      case RdsAvatarType.image:
        inner = _buildImage(rds, fgColor);

      case RdsAvatarType.icon:
        inner = Icon(
          widget.icon ?? RdsIcons.user,
          size: _iconSize(),
          color: fgColor,
        );

      case RdsAvatarType.initials:
        final initials = _extractInitials(widget.name ?? '');
        inner = Text(
          initials,
          style: _initialsTextStyle(rds).copyWith(color: fgColor),
          maxLines: 1,
        );
    }

    final semanticLabel = _resolveSemanticLabel();

    Widget circle = Semantics(
      label: semanticLabel,
      image: widget.type == RdsAvatarType.image,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
        ),
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        child: inner,
      ),
    );

    if (widget.onEdit == null) return circle;

    // Overlay the edit badge anchored to the bottom-right of the avatar circle.
    final badgeDiam = _badgeDiameter();
    final badgeIcon = badgeDiam * 0.55;
    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          circle,
          Positioned(
            bottom: 0,
            right: 0,
            child: Semantics(
              button: true,
              label: 'Edit',
              child: GestureDetector(
                onTap: widget.onEdit,
                child: Container(
                  width: badgeDiam,
                  height: badgeDiam,
                  decoration: BoxDecoration(
                    color: rds.primaryContainer,
                    shape: BoxShape.circle,
                    border: Border.all(color: rds.surface, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    RdsIcons.edit,
                    size: badgeIcon,
                    color: rds.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(RdsTheme rds, Color fallbackFg) {
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      return Icon(RdsIcons.user, size: _iconSize(), color: fallbackFg);
    }
    return Image.network(
      widget.imageUrl!,
      width: _diameter(),
      height: _diameter(),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Icon(RdsIcons.user, size: _iconSize(), color: fallbackFg);
      },
    );
  }

  String _resolveSemanticLabel() {
    if (widget.name != null && widget.name!.isNotEmpty) return widget.name!;
    if (widget.type == RdsAvatarType.icon) return 'User avatar';
    if (widget.type == RdsAvatarType.image) return 'Profile image';
    return 'Avatar';
  }
}
