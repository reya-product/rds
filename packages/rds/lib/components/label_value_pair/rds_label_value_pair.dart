import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

/// A single label/value entry for [RdsLabelValuePair] or [RdsLabelValueList].
class RdsLabelValueItem {
  const RdsLabelValueItem({
    required this.label,
    this.value,
    this.isLink = false,
    this.onTap,
  });

  /// Short descriptor shown on the left (e.g. "FIRST NAME").
  final String label;

  /// Content shown on the right. Null or empty string renders as "—".
  final String? value;

  /// When true the value is styled in [RdsTheme.primary] to signal an
  /// interactive/tappable value (phone numbers, emails, URLs, etc.).
  final bool isLink;

  /// Callback invoked when the row is tapped. Has no effect when null.
  final VoidCallback? onTap;
}

// ---------------------------------------------------------------------------
// RdsLabelValuePair — single row
// ---------------------------------------------------------------------------

/// A single label → value row with an optional bottom divider.
///
/// - Label: left-aligned, [RdsTheme.labelMedium] in [RdsTheme.onSurfaceVariant].
/// - Value: right-aligned, [RdsTheme.titleSmall] in [RdsTheme.onSurface].
///   Null / empty value renders as "—".
/// - Link values ([isLink] = true) use [RdsTheme.primary] and are tappable.
/// - A 1px [RdsTheme.outlineVariant] divider is drawn below by default.
///
/// ```dart
/// RdsLabelValuePair(label: 'FIRST NAME', value: 'Juliana')
///
/// RdsLabelValuePair(
///   label: 'MOBILE #',
///   value: '+1 718-479-7777',
///   isLink: true,
///   onTap: () => launchUrl(Uri.parse('tel:+17184797777')),
/// )
/// ```
class RdsLabelValuePair extends StatefulWidget {
  const RdsLabelValuePair({
    super.key,
    required this.label,
    this.value,
    this.isLink = false,
    this.onTap,
    this.showDivider = true,
  });

  final String label;
  final String? value;
  final bool isLink;
  final VoidCallback? onTap;

  /// Whether to draw a 1px bottom divider. Set to false on the last row of a
  /// group when the outer container already provides a border.
  final bool showDivider;

  @override
  State<RdsLabelValuePair> createState() => _RdsLabelValuePairState();
}

class _RdsLabelValuePairState extends State<RdsLabelValuePair> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _isInteractive => widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final displayValue =
        (widget.value == null || widget.value!.isEmpty) ? '—' : widget.value!;
    final isEmpty = widget.value == null || widget.value!.isEmpty;

    final Color valueColor;
    if (isEmpty) {
      valueColor = rds.onSurfaceMuted;
    } else if (widget.isLink) {
      valueColor = _pressed
          ? rds.primary.withOpacity(1 - rds.statePressed)
          : _hovered
              ? rds.primary.withOpacity(1 - rds.stateHover)
              : rds.primary;
    } else {
      valueColor = rds.onSurface;
    }

    Widget row = Container(
      decoration: BoxDecoration(
        color: rds.surface,
        border: widget.showDivider
            ? Border(bottom: BorderSide(color: rds.outlineVariant, width: 1))
            : null,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: rds.space3,
        vertical: rds.space2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Label — left
          Expanded(
            child: Text(
              widget.label,
              style: rds.labelMedium.copyWith(color: rds.onSurfaceVariant),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: rds.space4),
          // Value — right
          Expanded(
            flex: 2,
            child: Text(
              displayValue,
              style: rds.titleSmall.copyWith(color: valueColor),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    if (!_isInteractive) return row;

    return Semantics(
      button: true,
      label: '${widget.label}: $displayValue',
      child: MouseRegion(
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
          child: row,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// RdsLabelValueList — convenience wrapper for a group of rows
// ---------------------------------------------------------------------------

/// Renders a list of [RdsLabelValueItem]s as stacked [RdsLabelValuePair] rows.
///
/// The last row's divider is suppressed automatically so the outer container's
/// border acts as the terminator.
///
/// ```dart
/// RdsLabelValueList(
///   items: const [
///     RdsLabelValueItem(label: 'FIRST NAME', value: 'Juliana'),
///     RdsLabelValueItem(label: 'MIDDLE NAME'),
///     RdsLabelValueItem(label: 'LAST NAME', value: 'Crain'),
///     RdsLabelValueItem(
///       label: 'MOBILE #',
///       value: '+1 718-479-7777',
///       isLink: true,
///     ),
///   ],
/// )
/// ```
class RdsLabelValueList extends StatelessWidget {
  const RdsLabelValueList({
    super.key,
    required this.items,
    this.suppressLastDivider = true,
  });

  final List<RdsLabelValueItem> items;

  /// When true the final row omits its bottom divider. Defaults to true.
  final bool suppressLastDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(items.length, (i) {
        final item = items[i];
        final isLast = i == items.length - 1;
        return RdsLabelValuePair(
          label: item.label,
          value: item.value,
          isLink: item.isLink,
          onTap: item.onTap,
          showDivider: isLast && suppressLastDivider ? false : true,
        );
      }),
    );
  }
}
