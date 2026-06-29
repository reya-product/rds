import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/rds_theme.dart';
import '../../tokens/rds_icon_size.dart';
import '../../tokens/rds_icons.dart';
import '../dropdown_popup/rds_dropdown_item.dart';
import '../dropdown_popup/rds_dropdown_popup.dart';

export '../dropdown_popup/rds_dropdown_item.dart';

// ---------------------------------------------------------------------------
// RdsDropdownField
// ---------------------------------------------------------------------------

/// A single-value form field backed by [RdsDropdownPopup].
///
/// Renders a read-only field that looks identical to [RdsTextField] but opens
/// a floating [RdsDropdownPopup] overlay when tapped. The chevron trailing
/// icon rotates 180° while the popup is open.
///
/// ```dart
/// RdsDropdownField(
///   label: 'Health focus',
///   items: const [
///     RdsDropdownItem(value: 'cardio', label: 'Cardiovascular health'),
///     RdsDropdownItem(value: 'sleep', label: 'Sleep quality'),
///   ],
///   value: _selected,
///   onChanged: (v) => setState(() => _selected = v),
/// )
/// ```
class RdsDropdownField extends StatefulWidget {
  /// The label displayed above the field.
  final String label;

  /// The list of options shown in the popup.
  final List<RdsDropdownItem> items;

  /// The currently selected value. `null` means nothing is selected.
  final dynamic value;

  /// Called when the user selects an item. `null` disables the field.
  final ValueChanged<dynamic>? onChanged;

  /// Placeholder text shown when [value] is null.
  final String placeholder;

  /// Descriptive helper text shown below the field.
  final String? supportText;

  /// Error message. When non-null the field enters the error state.
  final String? errorText;

  /// Shows an asterisk after the label when true.
  final bool mandatory;

  /// Prevents interaction and dims the field.
  final bool disabled;

  /// When true the popup includes an [RdsSearchBar] for filtering.
  final bool searchable;

  /// Maximum height of the floating popup before the list scrolls.
  final double popupMaxHeight;

  const RdsDropdownField({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.placeholder = 'Select...',
    this.supportText,
    this.errorText,
    this.mandatory = false,
    this.disabled = false,
    this.searchable = false,
    this.popupMaxHeight = 320,
  });

  @override
  State<RdsDropdownField> createState() => _RdsDropdownFieldState();
}

class _RdsDropdownFieldState extends State<RdsDropdownField> {
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  bool get _isDisabled => widget.disabled || widget.onChanged == null;

  void _openDropdown() {
    if (_isDisabled || _isOpen) return;
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isOpen = false);
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  OverlayEntry _buildOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (ctx) => Stack(
        children: [
          // Full-screen tap barrier to dismiss the popup.
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _closeDropdown,
              child: const SizedBox.expand(),
            ),
          ),
          // The popup itself, positioned below the field.
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: Material(
                color: Colors.transparent,
                child: RdsDropdownPopup(
                  items: widget.items,
                  selectedValues:
                      widget.value != null ? {widget.value} : const {},
                  onItemSelected: (val) {
                    widget.onChanged?.call(val);
                    _closeDropdown();
                  },
                  maxHeight: widget.popupMaxHeight,
                  searchable: widget.searchable,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  String get _labelText =>
      widget.mandatory ? '${widget.label} *' : widget.label;

  /// Resolves the display label for the currently selected value, or null.
  String? get _displayValue {
    if (widget.value == null) return null;
    final match = widget.items.where((i) => i.value == widget.value);
    if (match.isEmpty) return null;
    return match.first.label;
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final bool isError =
        widget.errorText != null && widget.errorText!.isNotEmpty;

    final borderColor = isError
        ? rds.danger
        : (_isFocused || _isOpen)
            ? rds.primary
            : _isDisabled
                ? rds.outlineVariant
                : rds.outline;
    final borderWidth =
        (isError || _isFocused || _isOpen) && !_isDisabled ? 2.0 : 1.0;

    final fillColor = _isDisabled ? rds.surfaceContainer : rds.surface;

    final labelStyle = rds.bodyMedium.copyWith(color: rds.onSurfaceVariant);
    final valueStyle = rds.bodyLarge.copyWith(
      color: _displayValue != null
          ? (widget.disabled
              ? rds.onSurface.withOpacity(rds.opacityDisabled)
              : rds.onSurface)
          : rds.onSurfaceMuted,
    );

    // Chevron animates 180° when open.
    final chevron = AnimatedRotation(
      turns: _isOpen ? 0.5 : 0.0,
      duration: rds.durationStandard,
      curve: rds.curveStandard,
      child: Icon(
        RdsIcons.chevronDown,
        size: RdsIconSize.md,
        color: _isDisabled ? rds.onSurface.withOpacity(rds.opacityDisabled) : rds.onSurfaceVariant,
      ),
    );

    // Support / error text below the field.
    Widget? belowText;
    if (isError) {
      belowText = Text(
        widget.errorText!,
        style: rds.bodySmall.copyWith(color: rds.danger),
      );
    } else if (widget.supportText != null && widget.supportText!.isNotEmpty) {
      belowText = Text(
        widget.supportText!,
        style: rds.bodySmall.copyWith(color: rds.onSurfaceVariant),
      );
    }

    final fieldShell = KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          _closeDropdown();
        }
      },
      child: Semantics(
        button: true,
        enabled: !_isDisabled,
        label: _labelText,
        value: _displayValue ?? widget.placeholder,
        child: GestureDetector(
          onTap: _isDisabled ? null : _toggleDropdown,
          behavior: HitTestBehavior.opaque,
          child: Focus(
            focusNode: _focusNode,
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent &&
                  (event.logicalKey == LogicalKeyboardKey.enter ||
                      event.logicalKey == LogicalKeyboardKey.space)) {
                _toggleDropdown();
                return KeyEventResult.handled;
              }
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.escape) {
                _closeDropdown();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: CompositedTransformTarget(
              link: _layerLink,
              child: AnimatedContainer(
                duration: rds.durationFast,
                decoration: BoxDecoration(
                  color: fillColor,
                  border: Border(
                    bottom: BorderSide(color: borderColor, width: borderWidth),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        rds.space4,
                        rds.space2,
                        rds.space4,
                        0,
                      ),
                      child: Text(
                        _labelText,
                        style: labelStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        rds.space4,
                        rds.space1,
                        rds.space3,
                        rds.space3,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _displayValue ?? widget.placeholder,
                              style: valueStyle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(width: rds.space2),
                          chevron,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Widget result = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: Opacity(
        opacity: widget.disabled ? rds.opacityDisabled : 1.0,
        child: MouseRegion(
          cursor: _isDisabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          child: fieldShell,
        ),
      ),
    );

    if (belowText != null) {
      result = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          result,
          Padding(
            padding: EdgeInsets.only(
              top: rds.space1,
              left: rds.space4,
            ),
            child: belowText,
          ),
        ],
      );
    }

    return result;
  }
}
