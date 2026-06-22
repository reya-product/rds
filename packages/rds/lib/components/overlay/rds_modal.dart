import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';
import '../../tokens/rds_motion.dart';
import 'rds_overlay_shell.dart';

// ---------------------------------------------------------------------------
// RdsModal
// ---------------------------------------------------------------------------

/// A center-aligned dialog with header, scrollable body, and footer.
///
/// Use [RdsModal.show] to open the modal imperatively:
/// ```dart
/// RdsModal.show(
///   context: context,
///   title: 'Onboard Member',
///   body: OnboardMemberForm(),
///   footerActions: [
///     RdsButton(label: 'Done', onPressed: () { ... }),
///     RdsButton(
///       label: 'Cancel',
///       variant: RdsButtonVariant.text,
///       onPressed: () => Navigator.of(context).pop(),
///     ),
///   ],
/// );
/// ```
///
/// The modal fades in + scales from 0.92 → 1.0 over
/// [RdsMotion.durationEmphasized] (300 ms). A semi-transparent scrim covers
/// the background; tapping it closes the modal when [barrierDismissible]
/// is true.
abstract final class RdsModal {
  /// Opens a centered modal dialog and returns a [Future] that resolves when
  /// the modal closes (with the optional popped value).
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget body,
    required List<Widget> footerActions,
    List<Widget> headerActions = const [],
    double maxWidth = 560,
    double maxHeightFraction = 0.85,
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
        return _ModalContent(
          title: title,
          headerActions: headerActions,
          body: body,
          bodyPadding: bodyPadding,
          footerActions: footerActions,
          maxWidth: maxWidth,
          maxHeightFraction: maxHeightFraction,
          onClose: () => Navigator.of(ctx).pop(),
        );
      },
      transitionBuilder: (ctx, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// _ModalContent — the rendered widget
// ---------------------------------------------------------------------------

class _ModalContent extends StatelessWidget {
  final String title;
  final List<Widget> headerActions;
  final Widget body;
  final EdgeInsets? bodyPadding;
  final List<Widget> footerActions;
  final double maxWidth;
  final double maxHeightFraction;
  final VoidCallback onClose;

  const _ModalContent({
    required this.title,
    required this.headerActions,
    required this.body,
    required this.bodyPadding,
    required this.footerActions,
    required this.maxWidth,
    required this.maxHeightFraction,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final screenSize = MediaQuery.of(context).size;
    final maxHeight = screenSize.height * maxHeightFraction;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
          ),
          margin: EdgeInsets.symmetric(horizontal: rds.space6),
          decoration: BoxDecoration(
            color: rds.surface,
            borderRadius: BorderRadius.circular(rds.radiusLg),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 32,
                offset: Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
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
