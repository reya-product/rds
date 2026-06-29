import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/rds_theme.dart';
import '../../tokens/rds_icon_size.dart';
import '../../tokens/rds_icons.dart';

// ---------------------------------------------------------------------------
// Enum
// ---------------------------------------------------------------------------

/// The type of input accepted by [RdsTextField].
enum RdsTextFieldInputType {
  /// Free text — no restrictions on characters or format.
  characters,

  /// Whole numbers only. Uses [TextInputType.number] and
  /// [FilteringTextInputFormatter.digitsOnly].
  integer,

  /// Decimal numbers. Uses [TextInputType.numberWithOptions(decimal: true)].
  /// Accepts digits and a single decimal point.
  float,

  /// Like [float] but also accepts a leading minus sign for negative values.
  number,
}

// ---------------------------------------------------------------------------
// RdsTextField
// ---------------------------------------------------------------------------

/// A single-line text input field.
///
/// Wraps Flutter's [TextField] with RDS token-based styling, supporting four
/// input types, optional leading/trailing icons, error states, and all RDS
/// field states (enabled, focused, filled, error, disabled, readOnly).
///
/// ```dart
/// RdsTextField(
///   label: 'Email address',
///   placeholder: 'you@example.com',
///   onChanged: (v) => setState(() => _email = v),
/// )
///
/// RdsTextField(
///   label: 'Age',
///   inputType: RdsTextFieldInputType.integer,
///   mandatory: true,
///   leadingIcon: RdsIcons.user,
///   onChanged: (v) => setState(() => _age = v),
/// )
/// ```
class RdsTextField extends StatefulWidget {
  const RdsTextField({
    super.key,
    required this.label,
    this.placeholder,
    this.leadingIcon,
    this.trailingIcon,
    this.onTrailingIconTap,
    this.supportText,
    this.errorText,
    this.mandatory = false,
    this.optional = false,
    this.disabled = false,
    this.readOnly = false,
    this.controller,
    this.focusNode,
    this.inputType = RdsTextFieldInputType.characters,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
  });

  /// The field label displayed above the input.
  final String label;

  /// Placeholder text shown when the field is empty.
  final String? placeholder;

  /// Optional icon to display at the leading (left) edge of the input.
  final IconData? leadingIcon;

  /// Optional icon to display at the trailing (right) edge of the input.
  /// Ignored if [inputType] introduces its own trailing widget.
  final IconData? trailingIcon;

  /// Callback fired when the trailing icon is tapped.
  final VoidCallback? onTrailingIconTap;

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

  /// Renders the field in a read-only style (no focus ring, muted background).
  final bool readOnly;

  /// Controller for managing the field's text value externally.
  final TextEditingController? controller;

  /// FocusNode for managing focus externally.
  final FocusNode? focusNode;

  /// Constrains which characters can be entered.
  final RdsTextFieldInputType inputType;

  /// Maximum number of characters. Shows a counter when set.
  final int? maxLength;

  /// Called every time the text value changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the field (e.g. presses Enter).
  final ValueChanged<String>? onSubmitted;

  @override
  State<RdsTextField> createState() => _RdsTextFieldState();
}

class _RdsTextFieldState extends State<RdsTextField> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;
  bool _isFocused = false;
  bool _hasValue = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();
    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);
    _hasValue = _controller.text.isNotEmpty;
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  void _onTextChange() {
    final hasValue = _controller.text.isNotEmpty;
    if (hasValue != _hasValue) {
      setState(() => _hasValue = hasValue);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.removeListener(_onTextChange);
    if (widget.focusNode == null) _focusNode.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  List<TextInputFormatter> get _formatters {
    switch (widget.inputType) {
      case RdsTextFieldInputType.characters:
        return [];
      case RdsTextFieldInputType.integer:
        return [FilteringTextInputFormatter.digitsOnly];
      case RdsTextFieldInputType.float:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ];
      case RdsTextFieldInputType.number:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
        ];
    }
  }

  TextInputType get _keyboardType {
    switch (widget.inputType) {
      case RdsTextFieldInputType.characters:
        return TextInputType.text;
      case RdsTextFieldInputType.integer:
        return TextInputType.number;
      case RdsTextFieldInputType.float:
        return const TextInputType.numberWithOptions(decimal: true);
      case RdsTextFieldInputType.number:
        return const TextInputType.numberWithOptions(decimal: true, signed: true);
    }
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
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: !widget.disabled,
        readOnly: widget.readOnly,
        keyboardType: _keyboardType,
        inputFormatters: _formatters,
        maxLength: widget.maxLength,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        style: rds.bodyLarge.copyWith(
          color: widget.disabled
              ? rds.onSurface.withOpacity(rds.opacityDisabled)
              : rds.onSurface,
        ),
        cursorColor: rds.primary,
        decoration: _buildDecoration(rds, isError: isError),
      ),
    );

    if (widget.disabled) {
      field = Opacity(opacity: rds.opacityDisabled, child: field);
    }

    return field;
  }

  String _buildLabel() {
    if (widget.mandatory) return '${widget.label} *';
    if (widget.optional) return '${widget.label} (optional)';
    return widget.label;
  }

  InputDecoration _buildDecoration(RdsTheme rds, {required bool isError}) {
    return InputDecoration(
      labelText: _buildLabel(),
      labelStyle: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
      floatingLabelStyle: rds.bodySmall.copyWith(
        color: isError ? rds.danger : (_isFocused ? rds.primary : rds.onSurfaceVariant),
      ),
      hintText: widget.placeholder,
      hintStyle: rds.bodyLarge.copyWith(color: rds.onSurfaceMuted),
      prefixIcon: widget.leadingIcon != null
          ? Icon(widget.leadingIcon, color: rds.onSurfaceVariant, size: RdsIconSize.md)
          : null,
      suffixIcon: widget.trailingIcon != null
          ? GestureDetector(
              onTap: widget.onTrailingIconTap,
              child: Icon(
                widget.trailingIcon,
                color: rds.onSurfaceVariant,
                size: RdsIconSize.md,
              ),
            )
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
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: rds.outline),
      ),
      enabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: rds.outline),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: rds.primary, width: 2),
      ),
      errorBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: rds.danger, width: 2),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: rds.danger, width: 2),
      ),
      disabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: rds.outlineVariant),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: rds.space4,
        vertical: rds.space4,
      ),
    );
  }
}
