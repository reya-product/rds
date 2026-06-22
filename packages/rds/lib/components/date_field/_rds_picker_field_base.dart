import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';
import '../../tokens/rds_icons.dart';
import '../button/rds_button.dart';

// ---------------------------------------------------------------------------
// RdsPickerFieldBase
// ---------------------------------------------------------------------------

/// Shared field-shell widget used by [RdsDateField], [RdsTimeField], and
/// [RdsDateTimeField].
///
/// Renders a read-only [TextField] styled with standard RDS field decoration
/// (label, support/error text, leading icon, trailing chevron) and fires
/// [onTap] when the user taps the field or its trailing icon.
class RdsPickerFieldBase extends StatefulWidget {
  const RdsPickerFieldBase({
    super.key,
    required this.label,
    required this.placeholder,
    required this.leadingIcon,
    required this.onTap,
    this.displayValue,
    this.supportText,
    this.errorText,
    this.mandatory = false,
    this.disabled = false,
    this.readOnly = false,
  });

  final String label;
  final String? displayValue;
  final String placeholder;
  final IconData leadingIcon;
  final VoidCallback onTap;
  final String? supportText;
  final String? errorText;
  final bool mandatory;
  final bool disabled;
  final bool readOnly;

  @override
  State<RdsPickerFieldBase> createState() => _RdsPickerFieldBaseState();
}

class _RdsPickerFieldBaseState extends State<RdsPickerFieldBase> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  String get _labelText {
    if (widget.mandatory) return '${widget.label} *';
    return widget.label;
  }

  void _handleTap() {
    if (widget.disabled || widget.readOnly) return;
    _focusNode.requestFocus();
    widget.onTap();
    // Unfocus after a frame so the border reverts when dialog closes.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(rds.radiusMd),
      borderSide: BorderSide(color: rds.outline),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(rds.radiusMd),
      borderSide: BorderSide(color: rds.primary, width: 2),
    );
    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(rds.radiusMd),
      borderSide: BorderSide(color: rds.danger, width: 2),
    );
    final disabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(rds.radiusMd),
      borderSide: BorderSide(color: rds.outlineVariant),
    );

    return Opacity(
      opacity: widget.disabled ? rds.opacityDisabled : 1.0,
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.translucent,
        child: AbsorbPointer(
          // AbsorbPointer so the TextField itself doesn't steal the tap;
          // we handle it via GestureDetector above and the onTap below.
          absorbing: false,
          child: TextField(
            focusNode: _focusNode,
            readOnly: true,
            enabled: !widget.disabled,
            onTap: _handleTap,
            controller: TextEditingController(
              text: widget.displayValue ?? '',
            ),
            style: rds.bodyLarge.copyWith(
              color: widget.displayValue != null
                  ? rds.onSurface
                  : rds.onSurfaceMuted,
            ),
            decoration: InputDecoration(
              labelText: _labelText,
              labelStyle:
                  rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
              hintText: widget.placeholder,
              hintStyle:
                  rds.bodyLarge.copyWith(color: rds.onSurfaceMuted),
              prefixIcon: Icon(
                widget.leadingIcon,
                color: rds.onSurfaceVariant,
                size: rds.iconMd,
              ),
              suffixIcon: Icon(
                RdsIcons.chevronDown,
                color: rds.onSurfaceVariant,
                size: rds.iconMd,
              ),
              filled: true,
              fillColor: widget.readOnly
                  ? rds.surfaceContainer
                  : rds.surface,
              border: border,
              enabledBorder: border,
              focusedBorder: focusedBorder,
              errorBorder: errorBorder,
              focusedErrorBorder: errorBorder,
              disabledBorder: disabledBorder,
              errorText: widget.errorText,
              errorStyle:
                  rds.bodySmall.copyWith(color: rds.danger),
              helperText: widget.errorText == null
                  ? widget.supportText
                  : null,
              helperStyle: rds.bodySmall
                  .copyWith(color: rds.onSurfaceVariant),
              contentPadding: EdgeInsets.symmetric(
                horizontal: rds.space4,
                vertical: rds.space4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _RdsPickerDialog
// ---------------------------------------------------------------------------

/// Generic dialog shell used by the date/time field components.
///
/// Shows [pickerBuilder]'s widget in a constrained dialog with Cancel and
/// Confirm buttons.  On confirm, pops with the current picker value.
class _RdsPickerDialog<T> extends StatefulWidget {
  const _RdsPickerDialog({
    super.key,
    required this.title,
    required this.pickerBuilder,
    this.initialValue,
  });

  final String title;
  final T? initialValue;
  final Widget Function(
    BuildContext context,
    T? value,
    ValueChanged<T> onChanged,
  ) pickerBuilder;

  @override
  State<_RdsPickerDialog<T>> createState() => _RdsPickerDialogState<T>();
}

class _RdsPickerDialogState<T> extends State<_RdsPickerDialog<T>> {
  late T? _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Dialog(
      backgroundColor: rds.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(rds.radiusLg),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title bar
            Padding(
              padding: EdgeInsets.fromLTRB(
                  rds.space6, rds.space5, rds.space6, rds.space3),
              child: Text(
                widget.title,
                style: rds.titleLarge.copyWith(color: rds.onSurface),
              ),
            ),
            // Picker content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: rds.space4),
                child: widget.pickerBuilder(
                  context,
                  _current,
                  (val) => setState(() => _current = val),
                ),
              ),
            ),
            // Footer
            Padding(
              padding: EdgeInsets.all(rds.space4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RdsButton(
                    label: 'Cancel',
                    variant: RdsButtonVariant.text,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(width: rds.space2),
                  RdsButton(
                    label: 'Confirm',
                    variant: RdsButtonVariant.primary,
                    onPressed: _current != null
                        ? () => Navigator.of(context).pop(_current)
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
