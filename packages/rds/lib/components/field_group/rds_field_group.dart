import 'package:flutter/material.dart';
import '../../theme/rds_theme.dart';
import '../text_field/rds_text_field.dart';

// ---------------------------------------------------------------------------
// RdsFieldGroup
// ---------------------------------------------------------------------------

/// A layout widget that joins two child fields side-by-side with a single
/// shared border.
///
/// The left field's right corner radii are zeroed and the right field's left
/// corner radii are zeroed, so both fields share one continuous rounded-rect
/// outline drawn by this container. A single 1px vertical divider is painted
/// at the junction.
///
/// Neither child field should draw its own border — the [_FieldGroupChild]
/// wrapper overrides the [InputDecorationTheme] so that any [TextField]-based
/// child renders with [InputBorder.none].
///
/// ```dart
/// RdsFieldGroup(
///   label: 'Phone number',
///   leftChild: _CountryDropdown(),
///   rightChild: RdsTextField(
///     label: 'Mobile number',
///     placeholder: '07700 900000',
///   ),
///   leftFlex: 2,
///   rightFlex: 3,
/// )
/// ```
class RdsFieldGroup extends StatelessWidget {
  const RdsFieldGroup({
    super.key,
    required this.leftChild,
    required this.rightChild,
    this.leftFlex = 1,
    this.rightFlex = 1,
    this.label,
    this.supportText,
    this.errorText,
    this.mandatory = false,
  });

  /// The left-side field widget.
  final Widget leftChild;

  /// The right-side field widget.
  final Widget rightChild;

  /// Flex factor controlling the width proportion of the left field.
  final int leftFlex;

  /// Flex factor controlling the width proportion of the right field.
  final int rightFlex;

  /// Optional shared label rendered above both fields.
  final String? label;

  /// Optional helper text shown below both fields. Hidden when [errorText] is set.
  final String? supportText;

  /// Error message. When non-null and non-empty the group enters the error state.
  final String? errorText;

  /// Appends an asterisk to the shared [label] when true.
  final bool mandatory;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final bool hasError = errorText != null && errorText!.isNotEmpty;
    final bool hasBelow = hasError || (supportText != null && supportText!.isNotEmpty);

    final Color borderColor = hasError ? rds.danger : rds.outline;
    final double borderWidth = hasError ? 2.0 : 1.0;

    return Semantics(
      container: true,
      label: label ?? '',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Shared label
          if (label != null) ...[
            Text(
              mandatory ? '${label!} *' : label!,
              style: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
            ),
            SizedBox(height: rds.space1),
          ],

          // Joined field row
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(rds.radiusMd),
              border: Border.all(
                color: borderColor,
                width: borderWidth,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                // Inset by border width so the clip aligns with the inside edge.
                rds.radiusMd - borderWidth,
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      flex: leftFlex,
                      child: _FieldGroupChild(child: leftChild),
                    ),
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: borderColor,
                    ),
                    Flexible(
                      flex: rightFlex,
                      child: _FieldGroupChild(child: rightChild),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Support / error text
          if (hasBelow) ...[
            SizedBox(height: rds.space1),
            Text(
              hasError ? errorText! : supportText!,
              style: rds.bodySmall.copyWith(
                color: hasError ? rds.danger : rds.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _FieldGroupChild
// ---------------------------------------------------------------------------

/// Strips the individual border from any [TextField]-based child by overriding
/// [InputDecorationTheme] with [InputBorder.none] on every border variant.
///
/// The group container draws the shared outer border; children must not
/// draw their own borders or the join will look doubled.
class _FieldGroupChild extends StatelessWidget {
  const _FieldGroupChild({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          filled: true,
          fillColor: rds.surface,
          // Remove label floating so inline fields look cleaner.
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: EdgeInsets.symmetric(
            horizontal: rds.space3,
            vertical: rds.space3,
          ),
        ),
      ),
      child: child,
    );
  }
}
