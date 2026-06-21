import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'rds_toast_widget.dart';

// ---------------------------------------------------------------------------
// RdsToast — imperative overlay API
// ---------------------------------------------------------------------------

/// Provides the static [RdsToast.show] method for imperatively displaying
/// toast notifications via Flutter's [Overlay] system.
///
/// ```dart
/// RdsToast.show(
///   context,
///   variant: RdsToastVariant.success,
///   message: 'Changes saved.',
/// );
///
/// RdsToast.show(
///   context,
///   variant: RdsToastVariant.danger,
///   title: 'Error',
///   message: 'Failed to save. Please try again.',
///   dismissMode: RdsDismissMode.manual,
///   position: RdsToastPosition.topRight,
/// );
/// ```
abstract final class RdsToast {
  /// Shows a toast notification using an [OverlayEntry].
  ///
  /// The toast slides in with [RdsTheme.durationEmphasized] and slides out
  /// when dismissed (auto or manual).
  ///
  /// Parameters:
  /// - [context] — used to obtain the [Overlay] and [RdsTheme].
  /// - [variant] — semantic tone: danger, warning, success, or neutral.
  /// - [message] — the primary body text.
  /// - [title] — optional bold heading above the message.
  /// - [dismissMode] — auto (timed) or manual (close button).
  /// - [duration] — how long the toast is visible in auto mode (default 4s).
  /// - [position] — where on screen the toast appears.
  /// - [action] — optional action button.
  /// - [link] — optional link.
  static void show(
    BuildContext context, {
    required RdsToastVariant variant,
    required String message,
    String? title,
    RdsDismissMode dismissMode = RdsDismissMode.auto,
    Duration duration = const Duration(seconds: 4),
    RdsToastPosition position = RdsToastPosition.bottomCenter,
    RdsToastAction? action,
    RdsToastLink? link,
  }) {
    final overlay = Overlay.of(context);
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);

    late OverlayEntry entry;
    final controller = _ToastController(
      animationDuration: reducedMotion ? Duration.zero : rds.durationEmphasized,
      animationCurve: rds.curveEmphasized,
      holdDuration: dismissMode == RdsDismissMode.auto ? duration : null,
    );

    void dismiss() {
      controller.animateOut().then((_) {
        if (entry.mounted) entry.remove();
        controller.dispose();
      });
    }

    entry = OverlayEntry(
      builder: (overlayContext) {
        return _ToastOverlay(
          controller: controller,
          position: position,
          child: RdsToastWidget(
            variant: variant,
            message: message,
            title: title,
            dismissMode: dismissMode,
            action: action,
            link: link,
            onDismiss: dismiss,
          ),
        );
      },
    );

    overlay.insert(entry);
    controller.animateIn().then((_) {
      if (dismissMode == RdsDismissMode.auto) {
        controller.holdThenDismiss(dismiss);
      }
    });
  }
}

// ---------------------------------------------------------------------------
// Internal: animation controller for the toast lifecycle
// ---------------------------------------------------------------------------

class _ToastController {
  _ToastController({
    required this.animationDuration,
    required this.animationCurve,
    this.holdDuration,
  })  : _animController = AnimationController(
          vsync: _TickerProviderImpl(),
          duration: animationDuration,
        ) {
    _slideAnimation = CurvedAnimation(
      parent: _animController,
      curve: animationCurve,
      reverseCurve: animationCurve.flipped,
    );
  }

  final Duration animationDuration;
  final Curve animationCurve;
  final Duration? holdDuration;

  final AnimationController _animController;
  late final Animation<double> _slideAnimation;

  Animation<double> get animation => _slideAnimation;

  Future<void> animateIn() => _animController.forward();

  Future<void> animateOut() => _animController.reverse();

  void holdThenDismiss(VoidCallback onDismiss) {
    if (holdDuration != null) {
      Future.delayed(holdDuration!, onDismiss);
    }
  }

  void dispose() {
    _animController.dispose();
  }
}

// ---------------------------------------------------------------------------
// Minimal TickerProvider for the overlay controller
// ---------------------------------------------------------------------------

class _TickerProviderImpl extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

// ---------------------------------------------------------------------------
// Internal: the positioned overlay wrapper with slide + fade animation
// ---------------------------------------------------------------------------

class _ToastOverlay extends StatelessWidget {
  const _ToastOverlay({
    required this.controller,
    required this.position,
    required this.child,
  });

  final _ToastController controller;
  final RdsToastPosition position;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.animation,
      builder: (context, _) {
        final t = controller.animation.value;

        // Slide direction: topRight → slides down from top; bottomCenter → slides up
        final slideOffset = position == RdsToastPosition.topRight
            ? Offset(0, -1 + t) // starts above, slides to 0
            : Offset(0, 1 - t); // starts below, slides to 0

        return Positioned.fill(
          child: IgnorePointer(
            ignoring: t == 0,
            child: Stack(
              children: [
                _buildPositioned(
                  FractionalTranslation(
                    translation: slideOffset,
                    child: Opacity(
                      opacity: t,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 360),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPositioned(Widget content) {
    const edgeInset = 16.0;
    const bottomInset = 32.0;

    switch (position) {
      case RdsToastPosition.topRight:
        return Positioned(
          top: edgeInset + 48, // Below status bar / app bar
          right: edgeInset,
          child: content,
        );
      case RdsToastPosition.bottomCenter:
        return Positioned(
          bottom: bottomInset,
          left: edgeInset,
          right: edgeInset,
          child: Center(child: content),
        );
    }
  }
}
