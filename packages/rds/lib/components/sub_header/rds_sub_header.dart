import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';

// ---------------------------------------------------------------------------
// RdsSubHeader
// ---------------------------------------------------------------------------

/// A slim section-divider header bar that labels a group of content.
///
/// Renders as a [surfaceContainer]-filled strip with a 1px [outlineVariant]
/// bottom border. The [title] sits left-aligned; an optional [actionLabel]
/// (e.g. "EDIT") is right-aligned in [primary] colour with hover/press states.
///
/// ```dart
/// RdsSubHeader(title: 'Contact Information')
///
/// RdsSubHeader(
///   title: 'Contact Information',
///   actionLabel: 'EDIT',
///   onAction: () { /* open edit flow */ },
/// )
/// ```
class RdsSubHeader extends StatelessWidget {
  const RdsSubHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  /// Section title displayed on the left.
  final String title;

  /// Short action label displayed on the right (e.g. "EDIT", "VIEW ALL").
  /// Has no effect when null.
  final String? actionLabel;

  /// Called when the action label is tapped. If null the action renders
  /// non-interactively (useful for loading / disabled states).
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Container(
      decoration: BoxDecoration(
        color: rds.surfaceContainer,
        border: Border(
          bottom: BorderSide(color: rds.outlineVariant, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: rds.space3,
        vertical: rds.space1,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: rds.titleSmall.copyWith(color: rds.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (actionLabel != null)
            _ActionLabel(
              label: actionLabel!,
              onTap: onAction,
              rds: rds,
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ActionLabel — interactive right-hand label
// ---------------------------------------------------------------------------

class _ActionLabel extends StatefulWidget {
  const _ActionLabel({
    required this.label,
    required this.onTap,
    required this.rds,
  });

  final String label;
  final VoidCallback? onTap;
  final RdsTheme rds;

  @override
  State<_ActionLabel> createState() => _ActionLabelState();
}

class _ActionLabelState extends State<_ActionLabel> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _isInteractive => widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final rds = widget.rds;

    final Color color = _isInteractive
        ? rds.primary.withOpacity(_pressed
            ? 1 - rds.statePressed
            : _hovered
                ? 1 - rds.stateHover
                : 1.0)
        : rds.onSurfaceMuted;

    return Semantics(
      button: _isInteractive,
      label: widget.label,
      child: MouseRegion(
        cursor:
            _isInteractive ? SystemMouseCursors.click : SystemMouseCursors.basic,
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
          child: Text(
            widget.label,
            style: rds.labelLarge.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}
