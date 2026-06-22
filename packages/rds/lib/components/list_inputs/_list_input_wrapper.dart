import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';

// ---------------------------------------------------------------------------
// ListInputWrapper (private)
// ---------------------------------------------------------------------------

/// Shared shell for all three list input variants.
///
/// Renders:
///   1. Label row (with optional mandatory asterisk)
///   2. Optional border container wrapping [child]
///   3. [child] — the list of [RdsListItem] rows
///   4. Support or error text below the list
class ListInputWrapper extends StatelessWidget {
  /// Field label rendered above the list.
  final String label;

  /// When true, an asterisk (*) is appended to [label].
  final bool mandatory;

  /// Helper text rendered below the list when [errorText] is null or empty.
  final String? supportText;

  /// Error message rendered below the list. Overrides [supportText] and is
  /// coloured with [RdsTheme.danger].
  final String? errorText;

  /// When true, draws a rounded border around [child].
  final bool bordered;

  /// The list of rows to render.
  final Widget child;

  const ListInputWrapper({
    required this.label,
    required this.mandatory,
    required this.bordered,
    required this.child,
    this.supportText,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    final hasError = errorText != null && errorText!.isNotEmpty;
    final hasSupport = supportText != null && supportText!.isNotEmpty;

    // ---- Label ----
    final labelWidget = Text.rich(
      TextSpan(
        text: label,
        style: rds.labelLarge.copyWith(color: rds.onSurface),
        children: mandatory
            ? [
                TextSpan(
                  text: ' *',
                  style: rds.labelLarge.copyWith(color: rds.danger),
                ),
              ]
            : null,
      ),
    );

    // ---- List body (optionally bordered) ----
    final Widget listBody = bordered
        ? DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: rds.outline),
              borderRadius: BorderRadius.circular(rds.radiusMd),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(rds.radiusMd),
              child: child,
            ),
          )
        : child;

    // ---- Support / error text ----
    Widget? bottomText;
    if (hasError) {
      bottomText = Text(
        errorText!,
        style: rds.bodySmall.copyWith(color: rds.danger),
      );
    } else if (hasSupport) {
      bottomText = Text(
        supportText!,
        style: rds.bodySmall.copyWith(color: rds.onSurfaceVariant),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        labelWidget,
        SizedBox(height: rds.space2),
        listBody,
        if (bottomText != null) ...[
          SizedBox(height: rds.space1),
          bottomText,
        ],
      ],
    );
  }
}
