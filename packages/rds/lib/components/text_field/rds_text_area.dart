import 'package:flutter/material.dart';
import '../../theme/rds_theme.dart';
import '../../tokens/rds_icon_size.dart';

// ---------------------------------------------------------------------------
// RdsTextArea
// ---------------------------------------------------------------------------

/// A multi-line text input field.
///
/// Wraps Flutter's [TextField] with `maxLines` support. The field grows
/// vertically as the user types, up to [maxLines]. When [maxLength] is set
/// a character counter is displayed beneath the field.
///
/// ```dart
/// RdsTextArea(
///   label: 'Clinical notes',
///   placeholder: 'Enter your observations here…',
///   minLines: 3,
///   maxLines: 8,
///   maxLength: 500,
///   onChanged: (v) => setState(() => _notes = v),
/// )
/// ```
class RdsTextArea extends StatefulWidget {
  const RdsTextArea({
    super.key,
    required this.label,
    this.placeholder,
    this.leadingIcon,
    this.supportText,
    this.errorText,
    this.mandatory = false,
    this.optional = false,
    this.disabled = false,
    this.readOnly = false,
    this.controller,
    this.focusNode,
    this.minLines = 3,
    this.maxLines,
    this.maxLength,
    this.onChanged,
  });

  /// The field label displayed above the input.
  final String label;

  /// Placeholder text shown when the field is empty.
  final String? placeholder;

  /// Optional icon at the leading edge. Note: trailing icons are omitted
  /// because they conflict with the resize affordance.
  final IconData? leadingIcon;

  /// Descriptive text shown below the field. Replaced by [errorText] when set.
  final String? supportText;

  /// Error message. When non-null the field enters the error state.
  final String? errorText;

  /// Shows an asterisk after the label when true.
  final bool mandatory;

  /// Shows "(optional)" after the label when true.
  final bool optional;

  /// Prevents all interaction and dims the field.
  final bool disabled;

  /// Renders the field in a read-only style.
  final bool readOnly;

  /// Controller for managing the field's text value externally.
  final TextEditingController? controller;

  /// FocusNode for managing focus externally.
  final FocusNode? focusNode;

  /// Minimum number of visible lines. Defaults to 3.
  final int minLines;

  /// Maximum number of visible lines before the field scrolls.
  /// When null the field grows without a cap.
  final int? maxLines;

  /// Maximum character count. Shows a character counter when set.
  final int? maxLength;

  /// Called every time the text value changes.
  final ValueChanged<String>? onChanged;

  @override
  State<RdsTextArea> createState() => _RdsTextAreaState();
}

class _RdsTextAreaState extends State<RdsTextArea> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) _focusNode.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  String _buildLabel() {
    if (widget.mandatory) return '${widget.label} *';
    if (widget.optional) return '${widget.label} (optional)';
    return widget.label;
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final bool isError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final String effectiveLabel = _buildLabel();

    Widget field = Semantics(
      textField: true,
      label: effectiveLabel,
      enabled: !widget.disabled,
      readOnly: widget.readOnly,
      multiline: true,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: !widget.disabled,
        readOnly: widget.readOnly,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        onChanged: widget.onChanged,
        style: rds.bodyLarge.copyWith(color: rds.onSurface),
        cursorColor: rds.primary,
        decoration: InputDecoration(
          labelText: effectiveLabel,
          labelStyle: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
          floatingLabelStyle: rds.bodySmall.copyWith(
            color: isError
                ? rds.danger
                : (_isFocused ? rds.primary : rds.onSurfaceVariant),
          ),
          hintText: widget.placeholder,
          hintStyle: rds.bodyLarge.copyWith(color: rds.onSurfaceMuted),
          prefixIcon: widget.leadingIcon != null
              ? Icon(widget.leadingIcon, color: rds.onSurfaceVariant, size: RdsIconSize.md)
              : null,
          helperText: isError ? null : widget.supportText,
          helperStyle: rds.bodySmall.copyWith(color: rds.onSurfaceVariant),
          errorText: isError ? widget.errorText : null,
          errorStyle: rds.bodySmall.copyWith(color: rds.danger),
          counterStyle: rds.bodySmall.copyWith(color: rds.onSurfaceMuted),
          filled: true,
          fillColor: widget.readOnly || widget.disabled
              ? rds.surfaceContainer
              : rds.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(rds.radiusMd),
            borderSide: BorderSide(color: rds.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(rds.radiusMd),
            borderSide: BorderSide(color: rds.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(rds.radiusMd),
            borderSide: BorderSide(color: rds.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(rds.radiusMd),
            borderSide: BorderSide(color: rds.danger, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(rds.radiusMd),
            borderSide: BorderSide(color: rds.danger, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(rds.radiusMd),
            borderSide: BorderSide(color: rds.outlineVariant),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: rds.space4,
            vertical: rds.space3,
          ),
        ),
      ),
    );

    if (widget.disabled) {
      field = Opacity(opacity: rds.opacityDisabled, child: field);
    }

    return field;
  }
}
