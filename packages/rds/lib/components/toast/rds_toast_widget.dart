import 'package:flutter/material.dart';
import '../../theme/rds_theme.dart';
import '../../tokens/rds_icon_size.dart';
import '../../tokens/rds_icons.dart';

// ---------------------------------------------------------------------------
// Enums and data classes
// ---------------------------------------------------------------------------

/// The semantic variant of [RdsToastWidget].
enum RdsToastVariant {
  /// Destructive or error feedback.
  danger,

  /// Advisory / cautionary feedback.
  warning,

  /// Positive confirmation feedback.
  success,

  /// General informational feedback.
  neutral,
}

/// Whether the toast auto-dismisses or requires the user to close it.
enum RdsDismissMode {
  /// Toast dismisses automatically after [RdsToastWidget.duration].
  auto,

  /// Toast remains visible until the user presses the close button.
  manual,
}

/// Position of the toast overlay on screen.
enum RdsToastPosition {
  /// Top-right corner of the screen.
  topRight,

  /// Bottom-center of the screen.
  bottomCenter,
}

/// A labelled button action attached to a toast.
class RdsToastAction {
  const RdsToastAction({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;
}

/// A labelled URL link attached to a toast.
class RdsToastLink {
  const RdsToastLink({
    required this.label,
    required this.url,
  });

  final String label;
  final String url;
}

// ---------------------------------------------------------------------------
// RdsToastWidget — the visual widget
// ---------------------------------------------------------------------------

/// The visual representation of an RDS toast notification.
///
/// This widget can be used directly in layouts (e.g. in Widgetbook) or is
/// managed internally by [RdsToast.show].
///
/// Layout:
/// ```
/// ┌─────────────────────────────────────────────────────────┐
/// │  [icon]  [title (opt)]                        [close?]  │
/// │          [message]                                       │
/// │          [action button / link (opt)]                    │
/// └─────────────────────────────────────────────────────────┘
/// ```
class RdsToastWidget extends StatelessWidget {
  const RdsToastWidget({
    super.key,
    required this.variant,
    required this.message,
    this.title,
    this.dismissMode = RdsDismissMode.auto,
    this.action,
    this.link,
    this.onDismiss,
  });

  /// The semantic variant controlling colors and leading icon.
  final RdsToastVariant variant;

  /// The primary message body.
  final String message;

  /// Optional bold title shown above the message.
  final String? title;

  /// Controls whether a close button is shown.
  final RdsDismissMode dismissMode;

  /// Optional action button.
  final RdsToastAction? action;

  /// Optional link label + URL.
  final RdsToastLink? link;

  /// Called when the dismiss button is pressed. If null, close button is hidden
  /// even in [RdsDismissMode.manual] mode.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final colors = _resolveColors(rds);

    final leadingIcon = Icon(
      _resolveIcon(),
      size: RdsIconSize.md,
      color: colors.iconColor,
    );

    Widget textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: rds.labelLarge.copyWith(color: colors.onContainer),
          ),
          SizedBox(height: rds.space1),
        ],
        Text(
          message,
          style: rds.bodySmall.copyWith(color: colors.onContainer),
        ),
        if (action != null || link != null) ...[
          SizedBox(height: rds.space2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (action != null)
                _ActionButton(
                  label: action!.label,
                  onPressed: action!.onPressed,
                  color: colors.iconColor,
                  rds: rds,
                ),
              if (action != null && link != null)
                SizedBox(width: rds.space3),
              if (link != null)
                _LinkButton(
                  label: link!.label,
                  color: colors.iconColor,
                  rds: rds,
                ),
            ],
          ),
        ],
      ],
    );

    Widget body = Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(rds.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(rds.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leadingIcon,
          SizedBox(width: rds.space3),
          Expanded(child: textContent),
          if (dismissMode == RdsDismissMode.manual && onDismiss != null) ...[
            SizedBox(width: rds.space2),
            _DismissButton(
              onPressed: onDismiss!,
              color: colors.onContainer,
              rds: rds,
            ),
          ],
        ],
      ),
    );

    return Semantics(
      liveRegion: true,
      label: '${variant.name} notification: ${title != null ? "$title. " : ""}$message',
      child: body,
    );
  }

  IconData _resolveIcon() {
    switch (variant) {
      case RdsToastVariant.danger:
        return RdsIcons.error;
      case RdsToastVariant.warning:
        return RdsIcons.warning;
      case RdsToastVariant.success:
        return RdsIcons.success;
      case RdsToastVariant.neutral:
        return RdsIcons.info;
    }
  }

  _ToastColors _resolveColors(RdsTheme rds) {
    switch (variant) {
      case RdsToastVariant.danger:
        return _ToastColors(
          background: rds.dangerContainer,
          onContainer: rds.onDangerContainer,
          iconColor: rds.danger,
        );
      case RdsToastVariant.warning:
        return _ToastColors(
          background: rds.warningContainer,
          onContainer: rds.onWarningContainer,
          iconColor: rds.warning,
        );
      case RdsToastVariant.success:
        return _ToastColors(
          background: rds.successContainer,
          onContainer: rds.onSuccessContainer,
          iconColor: rds.success,
        );
      case RdsToastVariant.neutral:
        return _ToastColors(
          background: rds.surfaceContainer,
          onContainer: rds.onSurface,
          iconColor: rds.neutral,
        );
    }
  }
}

// ---------------------------------------------------------------------------
// Internal sub-widgets
// ---------------------------------------------------------------------------

class _ToastColors {
  const _ToastColors({
    required this.background,
    required this.onContainer,
    required this.iconColor,
  });

  final Color background;
  final Color onContainer;
  final Color iconColor;
}

class _ActionButton extends StatefulWidget {
  const _ActionButton({
    required this.label,
    required this.onPressed,
    required this.color,
    required this.rds,
  });

  final String label;
  final VoidCallback onPressed;
  final Color color;
  final RdsTheme rds;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Text(
          widget.label,
          style: widget.rds.labelLarge.copyWith(
            color: widget.color,
            decoration: _hovered ? TextDecoration.underline : TextDecoration.none,
            decorationColor: widget.color,
          ),
        ),
      ),
    );
  }
}

class _LinkButton extends StatefulWidget {
  const _LinkButton({
    required this.label,
    required this.color,
    required this.rds,
  });

  final String label;
  final Color color;
  final RdsTheme rds;

  @override
  State<_LinkButton> createState() => _LinkButtonState();
}

class _LinkButtonState extends State<_LinkButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Text(
        widget.label,
        style: widget.rds.labelLarge.copyWith(
          color: widget.color,
          decoration: TextDecoration.underline,
          decorationColor: widget.color.withOpacity(_hovered ? 1.0 : 0.7),
        ),
      ),
    );
  }
}

class _DismissButton extends StatelessWidget {
  const _DismissButton({
    required this.onPressed,
    required this.color,
    required this.rds,
  });

  final VoidCallback onPressed;
  final Color color;
  final RdsTheme rds;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Dismiss notification',
      child: GestureDetector(
        onTap: onPressed,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Icon(
            RdsIcons.close,
            size: RdsIconSize.md,
            color: color,
          ),
        ),
      ),
    );
  }
}
