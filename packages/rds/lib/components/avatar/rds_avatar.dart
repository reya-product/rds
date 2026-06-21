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
/// ## Usage
/// ```dart
/// // Image avatar
/// RdsAvatar(
///   type: RdsAvatarType.image,
///   imageUrl: 'https://example.com/photo.jpg',
///   size: RdsAvatarSize.md,
/// )
///
/// // Initials avatar
/// RdsAvatar(
///   type: RdsAvatarType.initials,
///   name: 'Jane Doe',
///   backgroundColor: Colors.teal,
/// )
///
/// // Icon avatar
/// RdsAvatar(
///   type: RdsAvatarType.icon,
///   icon: RdsIcons.user,
/// )
/// ```
class RdsAvatar extends StatelessWidget {
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

  const RdsAvatar({
    super.key,
    required this.type,
    this.imageUrl,
    this.icon,
    this.name,
    this.size = RdsAvatarSize.md,
    this.backgroundColor,
    this.showBackground = true,
  });

  // ---------------------------------------------------------------------------
  // Size helpers
  // ---------------------------------------------------------------------------

  double _diameter() {
    switch (size) {
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
    switch (size) {
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
    switch (size) {
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
    final bg = showBackground
        ? (backgroundColor ?? rds.primaryContainer)
        : Colors.transparent;
    final fgColor = backgroundColor != null
        ? rds.onPrimary
        : rds.onPrimaryContainer;

    Widget inner;

    switch (type) {
      case RdsAvatarType.image:
        inner = _buildImage(rds, fgColor);

      case RdsAvatarType.icon:
        inner = Icon(
          icon ?? RdsIcons.user,
          size: _iconSize(),
          color: fgColor,
        );

      case RdsAvatarType.initials:
        final initials = _extractInitials(name ?? '');
        inner = Text(
          initials,
          style: _initialsTextStyle(rds).copyWith(color: fgColor),
          maxLines: 1,
        );
    }

    final semanticLabel = _resolveSemanticLabel();

    return Semantics(
      label: semanticLabel,
      image: type == RdsAvatarType.image,
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
  }

  Widget _buildImage(RdsTheme rds, Color fallbackFg) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Icon(RdsIcons.user, size: _iconSize(), color: fallbackFg);
    }
    return Image.network(
      imageUrl!,
      width: _diameter(),
      height: _diameter(),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Icon(RdsIcons.user, size: _iconSize(), color: fallbackFg);
      },
    );
  }

  String _resolveSemanticLabel() {
    if (name != null && name!.isNotEmpty) return name!;
    if (type == RdsAvatarType.icon) return 'User avatar';
    if (type == RdsAvatarType.image) return 'Profile image';
    return 'Avatar';
  }
}
