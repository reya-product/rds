import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';
import '../../tokens/rds_icon_size.dart';
import '../../tokens/rds_icons.dart';

// ---------------------------------------------------------------------------
// RdsOverlayShell
// ---------------------------------------------------------------------------

/// The shared header / body / footer layout used by both [RdsRightPanel] and
/// [RdsModal].
///
/// Layout (top → bottom):
/// ```
/// ┌──────────────────────────────────────────────┐  ← kHeaderHeight = 64
/// │  Title                    [actions]  [×]     │
/// ├──────────────────────────────────────────────┤  ← outlineVariant divider
/// │  (scrollable body)                           │  ← Expanded
/// ├──────────────────────────────────────────────┤  ← outlineVariant divider
/// │  [action1]  [action2]  [action3]             │  ← kFooterPaddingV = 16
/// └──────────────────────────────────────────────┘
/// ```
///
/// The [body] is wrapped in a [SingleChildScrollView] so long forms scroll
/// without overflowing. [footerActions] are laid out left-to-right with
/// [space3] gaps. If [footerActions] is empty the footer zone is omitted.
class RdsOverlayShell extends StatelessWidget {
  /// Displayed in `headlineMedium` on the left of the header.
  final String title;

  /// Widgets shown to the right of the title, left of the close button.
  /// Typically zero or one `RdsButton` (e.g. a "Preview" action).
  final List<Widget> headerActions;

  /// Main content of the overlay — usually a form.
  /// Rendered inside a [SingleChildScrollView] with [bodyPadding].
  final Widget body;

  /// Padding around [body]. Defaults to `space6` on all sides.
  final EdgeInsets? bodyPadding;

  /// Buttons shown in the footer row (left-aligned, `space3` gaps).
  /// Pass an empty list to hide the footer entirely.
  final List<Widget> footerActions;

  /// Called when the × button is tapped.
  final VoidCallback onClose;

  static const double _kHeaderHeight = 64.0;

  const RdsOverlayShell({
    super.key,
    required this.title,
    required this.body,
    required this.footerActions,
    required this.onClose,
    this.headerActions = const [],
    this.bodyPadding,
  });

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final padding = bodyPadding ?? EdgeInsets.all(rds.space6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(
          title: title,
          actions: headerActions,
          onClose: onClose,
          rds: rds,
        ),
        Divider(height: 1, thickness: 1, color: rds.outlineVariant),
        Expanded(
          child: SingleChildScrollView(
            padding: padding,
            child: body,
          ),
        ),
        if (footerActions.isNotEmpty) ...[
          Divider(height: 1, thickness: 1, color: rds.outlineVariant),
          _Footer(actions: footerActions, rds: rds),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Private: header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final VoidCallback onClose;
  final RdsTheme rds;

  const _Header({
    required this.title,
    required this.actions,
    required this.onClose,
    required this.rds,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: RdsOverlayShell._kHeaderHeight,
      child: ColoredBox(
        color: rds.surface,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: rds.space5),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: rds.headlineMedium.copyWith(color: rds.onSurface),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Optional header action buttons
              if (actions.isNotEmpty) ...[
                SizedBox(width: rds.space2),
                ...actions,
                SizedBox(width: rds.space1),
              ],
              // Close button — always present
              Semantics(
                label: 'Close',
                button: true,
                child: InkWell(
                  onTap: onClose,
                  borderRadius: BorderRadius.circular(rds.radiusFull),
                  child: Padding(
                    padding: EdgeInsets.all(rds.space2),
                    child: Icon(
                      RdsIcons.close,
                      size: RdsIconSize.lg,
                      color: rds.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private: footer
// ---------------------------------------------------------------------------

class _Footer extends StatelessWidget {
  final List<Widget> actions;
  final RdsTheme rds;

  const _Footer({required this.actions, required this.rds});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: rds.surface,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: rds.space5,
          vertical: rds.space4,
        ),
        child: Row(
          children: [
            for (int i = 0; i < actions.length; i++) ...[
              if (i > 0) SizedBox(width: rds.space3),
              actions[i],
            ],
          ],
        ),
      ),
    );
  }
}
