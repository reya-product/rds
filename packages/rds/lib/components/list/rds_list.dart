import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';
import '../list_item/rds_list_item.dart';

// ---------------------------------------------------------------------------
// RdsListDensity
// ---------------------------------------------------------------------------

/// Controls the vertical density of an [RdsList].
///
/// - [comfortable] — standard padding, uses the default `RdsListItem` sizing.
/// - [compact] — reduced vertical padding via a `Theme` override on
///   `ListTileThemeData.contentPadding`.
enum RdsListDensity {
  /// Standard vertical padding (default). ListItems render at their natural
  /// minimum height of 56px.
  comfortable,

  /// Reduced vertical padding. Achieved by injecting a `ListTileTheme`
  /// override so every list item within the list uses tighter content padding.
  compact,
}

// ---------------------------------------------------------------------------
// RdsList
// ---------------------------------------------------------------------------

/// A vertical stack of [RdsListItem] widgets, optionally separated by thin
/// dividers.
///
/// [RdsList] is deliberately non-scrollable — it expands to the natural height
/// of its children and relies on the parent to provide scrolling when needed.
///
/// ### Example usage
/// ```dart
/// RdsList(
///   showDividers: true,
///   density: RdsListDensity.compact,
///   items: [
///     RdsListItem(primaryText: 'Dr. Sarah Chen', onTap: () {}),
///     RdsListItem(primaryText: 'Dr. Marcus Lee', onTap: () {}),
///     RdsListItem(primaryText: 'Dr. Aisha Patel', onTap: () {}),
///   ],
/// )
/// ```
class RdsList extends StatelessWidget {
  /// Pre-built [RdsListItem] widgets to display.
  final List<RdsListItem> items;

  /// When true, a 1px [outlineVariant] divider is drawn between items.
  final bool showDividers;

  /// Controls vertical density. Defaults to [RdsListDensity.comfortable].
  final RdsListDensity density;

  const RdsList({
    super.key,
    required this.items,
    this.showDividers = false,
    this.density = RdsListDensity.comfortable,
  });

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    if (items.isEmpty) return const SizedBox.shrink();

    final rows = <Widget>[];

    for (var i = 0; i < items.length; i++) {
      rows.add(items[i]);

      if (showDividers && i < items.length - 1) {
        rows.add(
          Divider(
            height: 1,
            thickness: 1,
            color: rds.outlineVariant,
          ),
        );
      }
    }

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );

    // In compact density, inject a ListTileTheme override that reduces the
    // vertical content padding on each list item.
    if (density == RdsListDensity.compact) {
      return ListTileTheme(
        data: ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(
            vertical: rds.space1,
            horizontal: rds.space4,
          ),
          minVerticalPadding: rds.space1,
        ),
        child: column,
      );
    }

    return column;
  }
}
