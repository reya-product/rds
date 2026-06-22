import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';
import '../../tokens/rds_motion.dart';
import '../../tokens/rds_shadows.dart';
import 'rds_overlay_shell.dart';

// ---------------------------------------------------------------------------
// RdsRightPanel
// ---------------------------------------------------------------------------

/// A slide-in panel anchored to the right edge of the screen.
///
/// Use [RdsRightPanel.show] to open the panel imperatively:
/// ```dart
/// RdsRightPanel.show(
///   context: context,
///   title: 'Add To Timeline',
///   body: AddToTimelineForm(),
///   footerActions: [
///     RdsButton(label: 'Add', onPressed: () { ... }),
///     RdsButton(
///       label: 'Close',
///       variant: RdsButtonVariant.text,
///       onPressed: () => Navigator.of(context).pop(),
///     ),
///   ],
/// );
/// ```
///
/// The panel slides in from the right over [RdsMotion.durationEmphasized]
/// (300 ms) using an ease-out cubic curve. A semi-transparent scrim covers
/// the rest of the screen; tapping it closes the panel when
/// [barrierDismissible] is true.
abstract final class RdsRightPanel {
  /// Opens a right-side panel and returns a [Future] that resolves when
  /// the panel closes (with the optional popped value).
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget body,
    required List<Widget> footerActions,
    List<Widget> headerActions = const [],
    double width = 420,
    EdgeInsets? bodyPadding,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: RdsMotion.durationEmphasized,
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return _RightPanelContent(
          title: title,
          headerActions: headerActions,
          body: body,
          bodyPadding: bodyPadding,
          footerActions: footerActions,
          width: width,
          onClose: () => Navigator.of(ctx).pop(),
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          )),
          child: child,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// _RightPanelContent — the rendered widget
// ---------------------------------------------------------------------------

class _RightPanelContent extends StatelessWidget {
  final String title;
  final List<Widget> headerActions;
  final Widget body;
  final EdgeInsets? bodyPadding;
  final List<Widget> footerActions;
  final double width;
  final VoidCallback onClose;

  const _RightPanelContent({
    required this.title,
    required this.headerActions,
    required this.body,
    required this.bodyPadding,
    required this.footerActions,
    required this.width,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final screenWidth = MediaQuery.of(context).size.width;
    final panelWidth = width.clamp(0.0, screenWidth * 0.95);

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: rds.surface,
        child: Container(
          width: panelWidth,
          height: double.infinity,
          decoration: BoxDecoration(
            color: rds.surface,
            boxShadow: RdsShadows.shadowXl,
          ),
          child: RdsOverlayShell(
            title: title,
            headerActions: headerActions,
            body: body,
            bodyPadding: bodyPadding,
            footerActions: footerActions,
            onClose: onClose,
          ),
        ),
      ),
    );
  }
}
