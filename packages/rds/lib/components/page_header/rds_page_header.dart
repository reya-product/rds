import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';

// ---------------------------------------------------------------------------
// RdsPageHeader
// ---------------------------------------------------------------------------

/// A horizontal app-bar–style header strip used at the top of a page or tile.
///
/// The header is composed of:
/// - [leading] — optional widget anchored to the far left (logo, back button,
///   avatar, etc.)
/// - [title] — required primary text
/// - [subtitle] — optional secondary text shown below / beside the title
/// - [badge] — optional widget (e.g. [RdsBadge]) placed immediately after the
///   title
/// - [actions] — optional list of widgets anchored to the far right (icon
///   buttons, tonal action button, profile icon, etc.)
/// - [height] — defaults to 56; pass 64 for the taller page-header variant
///
/// ## Examples
///
/// ```dart
/// // Simple page title with icon buttons
/// RdsPageHeader(
///   title: 'Patient Record',
///   actions: [
///     IconButton(icon: const Icon(Icons.search), onPressed: () {}),
///   ],
/// )
///
/// // Tile bar with logo + badge
/// RdsPageHeader(
///   leading: Image.asset('assets/logo.png', height: 24),
///   title: 'Juliana Crain',
///   subtitle: '38Y · F · She/Her/Hers',
///   badge: RdsBadge(label: 'CONCIERGE +2'),
///   actions: [
///     IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
///   ],
/// )
/// ```
class RdsPageHeader extends StatelessWidget {
  const RdsPageHeader({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.badge,
    this.actions = const [],
    this.height = 56,
    this.backgroundColor,
  });

  /// Widget shown at the far left (logo, avatar, back-arrow, etc.).
  final Widget? leading;

  /// Primary title text.
  final String title;

  /// Optional secondary line beneath the title.
  final String? subtitle;

  /// Optional widget placed immediately after the title (badge, chip, etc.).
  final Widget? badge;

  /// Widgets shown at the far right, in order left→right.
  final List<Widget> actions;

  /// Total height of the header bar. Defaults to 56; use 64 for the taller
  /// page-header variant (Example 1 from Figma).
  final double height;

  /// Background fill. Defaults to [RdsTheme.surface].
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final bg = backgroundColor ?? rds.surface;

    return Container(
      height: height,
      color: bg,
      padding: EdgeInsets.symmetric(horizontal: rds.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Leading ────────────────────────────────────────────────────────
          if (leading != null) ...[
            leading!,
            SizedBox(width: rds.space3),
          ],

          // ── Title block ────────────────────────────────────────────────────
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: rds.titleSmall.copyWith(color: rds.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (badge != null) ...[
                      SizedBox(width: rds.space2),
                      badge!,
                    ],
                  ],
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: rds.bodySmall.copyWith(color: rds.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // ── Actions ────────────────────────────────────────────────────────
          if (actions.isNotEmpty) ...[
            SizedBox(width: rds.space2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          ],
        ],
      ),
    );
  }
}
