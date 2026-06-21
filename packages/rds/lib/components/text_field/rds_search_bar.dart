import 'package:flutter/material.dart';
import 'package:rds/rds.dart';

// ---------------------------------------------------------------------------
// RdsSearchBar
// ---------------------------------------------------------------------------

/// A compact, pill-shaped search input.
///
/// Always shows a leading search icon. When the field has content a clear (×)
/// button appears at the trailing edge. Has no floating label — placeholder
/// text is used instead.
///
/// Height is fixed at 40px. Background transitions from [surfaceContainer]
/// (unfocused) to [surface] (focused) to signal activation.
///
/// ```dart
/// RdsSearchBar(
///   placeholder: 'Search patients…',
///   onChanged: (q) => setState(() => _query = q),
///   onSubmitted: (q) => _runSearch(q),
/// )
/// ```
class RdsSearchBar extends StatefulWidget {
  const RdsSearchBar({
    super.key,
    this.placeholder = 'Search…',
    this.controller,
    this.focusNode,
    this.disabled = false,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  /// Placeholder text displayed when the field is empty.
  final String placeholder;

  /// Controller for managing the field's text value externally.
  final TextEditingController? controller;

  /// FocusNode for managing focus externally.
  final FocusNode? focusNode;

  /// Prevents all interaction and dims the field.
  final bool disabled;

  /// Called every time the text value changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the search (presses Enter/Search key).
  final ValueChanged<String>? onSubmitted;

  /// Called when the clear button is tapped. If null the internal controller
  /// is cleared and [onChanged] is called with an empty string.
  final VoidCallback? onClear;

  @override
  State<RdsSearchBar> createState() => _RdsSearchBarState();
}

class _RdsSearchBarState extends State<RdsSearchBar> {
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

  void _handleClear() {
    if (widget.onClear != null) {
      widget.onClear!();
    } else {
      _controller.clear();
      widget.onChanged?.call('');
    }
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.removeListener(_onTextChange);
    if (widget.focusNode == null) _focusNode.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    // Background: surfaceContainer when unfocused, surface when focused
    final Color fillColor = _isFocused ? rds.surface : rds.surfaceContainer;
    final Color borderColor = _isFocused ? rds.primary : Colors.transparent;
    final double borderWidth = _isFocused ? 2.0 : 0.0;

    Widget clearButton = AnimatedOpacity(
      duration: rds.durationFast,
      opacity: _hasValue ? 1.0 : 0.0,
      child: IgnorePointer(
        ignoring: !_hasValue,
        child: Semantics(
          label: 'Clear search',
          button: true,
          child: Tooltip(
            message: 'Clear',
            child: GestureDetector(
              onTap: widget.disabled ? null : _handleClear,
              child: Padding(
                padding: EdgeInsets.all(rds.space2),
                child: Icon(
                  RdsIcons.close,
                  size: RdsIconSize.md,
                  color: rds.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Widget field = Semantics(
      textField: true,
      label: widget.placeholder,
      enabled: !widget.disabled,
      child: SizedBox(
        height: 40,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: !widget.disabled,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          style: rds.bodyLarge.copyWith(color: rds.onSurface),
          cursorColor: rds.primary,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: rds.bodyLarge.copyWith(color: rds.onSurfaceMuted),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: rds.space3, right: rds.space2),
              child: Icon(
                RdsIcons.search,
                size: RdsIconSize.md,
                color: rds.onSurfaceVariant,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: clearButton,
            suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(rds.radiusFull),
              borderSide: BorderSide(color: borderColor, width: borderWidth),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(rds.radiusFull),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(rds.radiusFull),
              borderSide: BorderSide(color: rds.primary, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(rds.radiusFull),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: rds.space3,
              vertical: rds.space2,
            ),
            isDense: true,
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
