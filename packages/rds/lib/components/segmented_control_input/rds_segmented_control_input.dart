import 'package:flutter/material.dart';

import '../button_group/rds_button_group.dart';
import '../segmented_buttons/rds_segmented_buttons.dart';
import '../../theme/rds_theme.dart';

// ---------------------------------------------------------------------------
// RdsSegmentedControlInput
// ---------------------------------------------------------------------------

/// A form-field wrapper around [RdsSegmentedButtons].
///
/// Adds a label row (with optional mandatory/optional indicator), an
/// underlying [RdsSegmentedButtons] control, and optional support / error
/// text below — matching the standard RDS field anatomy used by
/// [RdsTextField], [RdsTextArea], etc.
///
/// ```dart
/// RdsSegmentedControlInput<String>(
///   label: 'Time range',
///   segments: const [
///     RdsSegment(value: '7d',  label: '7 days'),
///     RdsSegment(value: '30d', label: '30 days'),
///     RdsSegment(value: '90d', label: '90 days'),
///   ],
///   selected: _selected,
///   onChanged: (next) => setState(() => _selected = next),
///   mandatory: true,
/// )
/// ```
class RdsSegmentedControlInput<T> extends StatelessWidget {
  const RdsSegmentedControlInput({
    super.key,
    required this.label,
    required this.segments,
    this.selectionMode = RdsButtonGroupSelectionMode.single,
    required this.selected,
    this.onChanged,
    this.showIcons = false,
    this.supportText,
    this.errorText,
    this.mandatory = false,
    this.optional = false,
    this.disabled = false,
  }) : assert(
          !(mandatory && optional),
          'mandatory and optional cannot both be true',
        );

  /// Field label rendered above the segmented buttons.
  final String label;

  /// The ordered list of segments forwarded to [RdsSegmentedButtons].
  final List<RdsSegment<T>> segments;

  /// Single or multi-select forwarded to [RdsSegmentedButtons].
  final RdsButtonGroupSelectionMode selectionMode;

  /// The set of currently selected segment values.
  final Set<T> selected;

  /// Called when the selection changes. Pass `null` to disable interaction.
  final ValueChanged<Set<T>>? onChanged;

  /// Whether to render segment icons when present.
  final bool showIcons;

  /// Descriptive text shown below the field. Replaced by [errorText] when set.
  final String? supportText;

  /// Error message. When non-null the field enters the error state and this
  /// text is rendered in the danger color.
  final String? errorText;

  /// Appends " *" to the label to indicate a required field.
  final bool mandatory;

  /// Appends " (optional)" to the label to indicate an optional field.
  final bool optional;

  /// Disables interaction and dims the entire component via [opacityDisabled].
  final bool disabled;

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  bool get _isDisabled => disabled || onChanged == null;
  bool get _hasError => errorText != null && errorText!.isNotEmpty;

  String get _effectiveLabel {
    if (mandatory) return '$label *';
    if (optional) return '$label (optional)';
    return label;
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    Widget field = Semantics(
      label: _effectiveLabel,
      enabled: !_isDisabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ----- Label row -----
          _LabelRow(
            label: label,
            mandatory: mandatory,
            optional: optional,
            rds: rds,
          ),

          SizedBox(height: rds.space2),

          // ----- Segmented buttons -----
          RdsSegmentedButtons<T>(
            segments: segments,
            selectionMode: selectionMode,
            selected: selected,
            onSelectionChanged: _isDisabled ? null : onChanged,
            showIcons: showIcons,
          ),

          // ----- Support / error text -----
          if (_hasError || supportText != null) ...[
            SizedBox(height: rds.space1),
            Text(
              _hasError ? errorText! : supportText!,
              style: rds.bodySmall.copyWith(
                color: _hasError ? rds.danger : rds.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );

    // Wrap in Opacity when disabled so the entire shell dims uniformly.
    if (_isDisabled) {
      field = Opacity(opacity: rds.opacityDisabled, child: field);
    }

    return field;
  }
}

// ---------------------------------------------------------------------------
// _LabelRow — private helper
// ---------------------------------------------------------------------------

class _LabelRow extends StatelessWidget {
  const _LabelRow({
    required this.label,
    required this.mandatory,
    required this.optional,
    required this.rds,
  });

  final String label;
  final bool mandatory;
  final bool optional;
  final RdsTheme rds;

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> spans = [
      TextSpan(text: label),
    ];

    if (mandatory) {
      spans.add(
        TextSpan(
          text: ' *',
          style: TextStyle(color: rds.danger),
        ),
      );
    } else if (optional) {
      spans.add(
        TextSpan(
          text: ' (optional)',
          style: TextStyle(color: rds.onSurfaceMuted),
        ),
      );
    }

    return Text.rich(
      TextSpan(children: spans),
      style: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
    );
  }
}
