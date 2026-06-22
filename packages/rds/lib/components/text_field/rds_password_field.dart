import 'package:flutter/material.dart';
import '../../theme/rds_theme.dart';
import '../../tokens/rds_icon_size.dart';
import '../../tokens/rds_icons.dart';

// ---------------------------------------------------------------------------
// RdsPasswordField
// ---------------------------------------------------------------------------

/// A single-line text input that obscures its content by default.
///
/// Provides a trailing eye-icon button that toggles visibility.
/// Inherits all base field styling from the RDS token set.
///
/// ```dart
/// RdsPasswordField(
///   label: 'Password',
///   placeholder: 'Enter your password',
///   mandatory: true,
///   onChanged: (v) => setState(() => _password = v),
/// )
/// ```
class RdsPasswordField extends StatefulWidget {
  const RdsPasswordField({
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
    this.onChanged,
    this.onSubmitted,
  });

  /// The field label displayed above the input.
  final String label;

  /// Placeholder text shown when the field is empty.
  final String? placeholder;

  /// Optional icon at the leading edge.
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

  /// Called every time the text value changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the field (e.g. presses Enter).
  final ValueChanged<String>? onSubmitted;

  @override
  State<RdsPasswordField> createState() => _RdsPasswordFieldState();
}

class _RdsPasswordFieldState extends State<RdsPasswordField> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;
  bool _isFocused = false;
  bool _obscureText = true;

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

  void _toggleObscure() {
    setState(() => _obscureText = !_obscureText);
    // Return focus to the field after tapping the icon
    _focusNode.requestFocus();
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

    final String toggleSemantics = _obscureText ? 'Show password' : 'Hide password';
    final IconData toggleIcon = _obscureText ? RdsIcons.eye : RdsIcons.eyeOff;

    Widget toggleButton = Semantics(
      label: toggleSemantics,
      button: true,
      child: Tooltip(
        message: toggleSemantics,
        child: GestureDetector(
          onTap: widget.disabled ? null : _toggleObscure,
          child: Padding(
            padding: EdgeInsets.all(rds.space3),
            child: Icon(
              toggleIcon,
              size: RdsIconSize.md,
              color: widget.disabled
                  ? rds.onSurfaceVariant.withOpacity(rds.opacityDisabled)
                  : rds.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );

    Widget field = Semantics(
      textField: true,
      label: effectiveLabel,
      enabled: !widget.disabled,
      readOnly: widget.readOnly,
      obscured: _obscureText,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: !widget.disabled,
        readOnly: widget.readOnly,
        obscureText: _obscureText,
        keyboardType: TextInputType.visiblePassword,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
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
          suffixIcon: toggleButton,
          helperText: isError ? null : widget.supportText,
          helperStyle: rds.bodySmall.copyWith(color: rds.onSurfaceVariant),
          errorText: isError ? widget.errorText : null,
          errorStyle: rds.bodySmall.copyWith(color: rds.danger),
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
            vertical: rds.space4,
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
