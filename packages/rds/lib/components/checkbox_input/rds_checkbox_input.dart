import 'package:flutter/material.dart';

import '../checkbox/rds_checkbox.dart';
import '../../theme/rds_theme.dart';

// ---------------------------------------------------------------------------
// RdsCheckboxInput
// ---------------------------------------------------------------------------

/// A checkbox control composed with a tappable label (and optional support
/// text, link, and error message).
///
/// The entire row — checkbox plus all label content — is a single tap target.
/// Tapping anywhere on the row toggles the checkbox unless [disabled] or
/// [readOnly] is set.
///
/// ```dart
/// // Simple
/// RdsCheckboxInput(
///   label: 'I agree to the terms',
///   value: _agreed,
///   onChanged: (v) => setState(() => _agreed = v),
/// )
///
/// // Rich — support text + link
/// RdsCheckboxInput(
///   label: 'Receive newsletter',
///   supportText: 'We send one email per week with the latest updates.',
///   linkText: 'View sample',
///   onLinkTap: () => launchUrl(...),
///   value: _subscribed,
///   onChanged: (v) => setState(() => _subscribed = v),
/// )
///
/// // Error
/// RdsCheckboxInput(
///   label: 'I agree to the terms',
///   value: false,
///   errorText: 'You must accept the terms to continue.',
///   onChanged: (v) => setState(() => _agreed = v),
/// )
/// ```
class RdsCheckboxInput extends StatelessWidget {
  const RdsCheckboxInput({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
    this.supportText,
    this.linkText,
    this.onLinkTap,
    this.errorText,
    this.disabled = false,
    this.readOnly = false,
  });

  /// Primary label text. Tapping it (or anywhere on the row) toggles the
  /// checkbox.
  final String label;

  /// Current checkbox value.
  /// - `true` — checked
  /// - `false` — unchecked
  /// - `null` — indeterminate
  final bool? value;

  /// Called when the value changes. If null the component is non-interactive.
  final ValueChanged<bool?>? onChanged;

  /// Optional secondary description text rendered below [label].
  final String? supportText;

  /// Optional link label rendered below [supportText] (or [label] when
  /// [supportText] is null). Only shown when [onLinkTap] is also non-null.
  final String? linkText;

  /// Called when [linkText] is tapped. The link is only rendered when this is
  /// non-null.
  final VoidCallback? onLinkTap;

  /// Error message displayed below the row. When non-empty the checkbox also
  /// receives `error: true`.
  final String? errorText;

  /// Disables all interaction and applies disabled opacity to the label text.
  final bool disabled;

  /// Renders the component as read-only (no interaction, muted styling on the
  /// label text).
  final bool readOnly;

  // ---- internal helpers ----

  bool get _isInteractive =>
      !disabled && !readOnly && onChanged != null;

  void _handleTap() {
    if (!_isInteractive) return;
    // toggle: true→false, false/null→true
    onChanged!(value == true ? false : true);
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final hasError = errorText != null && errorText!.isNotEmpty;

    // Resolve label / support text color based on state.
    final Color labelColor;
    final Color supportColor;
    if (disabled) {
      labelColor = rds.onSurface.withOpacity(rds.opacityDisabled);
      supportColor = rds.onSurfaceVariant.withOpacity(rds.opacityDisabled);
    } else if (readOnly) {
      labelColor = rds.onSurfaceVariant;
      supportColor = rds.onSurfaceMuted;
    } else {
      labelColor = rds.onSurface;
      supportColor = rds.onSurfaceVariant;
    }

    // The checkbox width (default 20px) + the gap between checkbox and label
    // defines the indent used for the error message.
    const double checkboxSize = 20.0;
    final double errorIndent = checkboxSize + rds.space3;

    // ---- label column ----
    final Widget labelColumn = Padding(
      padding: const EdgeInsets.only(top: 2), // optical alignment with checkbox
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: rds.bodyMedium.copyWith(color: labelColor),
          ),
          if (supportText != null) ...[
            SizedBox(height: rds.space1),
            Text(
              supportText!,
              style: rds.bodySmall.copyWith(color: supportColor),
            ),
          ],
          if (linkText != null && onLinkTap != null) ...[
            SizedBox(height: rds.space1),
            GestureDetector(
              onTap: disabled || readOnly ? null : onLinkTap,
              child: Text(
                linkText!,
                style: rds.bodySmall.copyWith(
                  color: (disabled || readOnly)
                      ? rds.primary.withOpacity(rds.opacityDisabled)
                      : rds.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: (disabled || readOnly)
                      ? rds.primary.withOpacity(rds.opacityDisabled)
                      : rds.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    // ---- main row wrapped in a minimum-height tap target ----
    Widget row = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.translucent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RdsCheckbox(
              value: value,
              onChanged: _isInteractive ? onChanged : null,
              disabled: disabled,
              readOnly: readOnly,
              error: hasError,
              size: checkboxSize,
            ),
            SizedBox(width: rds.space3),
            Expanded(child: labelColumn),
          ],
        ),
      ),
    );

    // ---- error text below the row ----
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        row,
        if (hasError) ...[
          SizedBox(height: rds.space1),
          Padding(
            padding: EdgeInsets.only(left: errorIndent),
            child: Text(
              errorText!,
              style: rds.bodySmall.copyWith(color: rds.danger),
            ),
          ),
        ],
      ],
    );

    // ---- accessibility wrapper ----
    return MergeSemantics(
      child: Semantics(
        checked: value ?? false,
        label: label,
        enabled: _isInteractive,
        child: content,
      ),
    );
  }
}
