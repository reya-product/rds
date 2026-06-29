import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/rds_theme.dart';
import '../../tokens/rds_icon_size.dart';
import '../../tokens/rds_icons.dart';
import '../dropdown_popup/rds_dropdown_item.dart';
import '../dropdown_popup/rds_dropdown_popup.dart';
import '../input_chip/rds_input_chip.dart';

export '../dropdown_popup/rds_dropdown_item.dart';

// ---------------------------------------------------------------------------
// RdsComboboxField
// ---------------------------------------------------------------------------

/// A multi-value form field where selected options appear as removable
/// [RdsInputChip]s inside the field body, and the user types to filter the
/// floating [RdsDropdownPopup].
///
/// ```dart
/// RdsComboboxField(
///   label: 'Health focus areas',
///   items: const [
///     RdsDropdownItem(value: 'cardio', label: 'Cardiovascular health'),
///     RdsDropdownItem(value: 'sleep', label: 'Sleep quality'),
///   ],
///   selected: _selected,
///   onChanged: (v) => setState(() => _selected = v),
/// )
/// ```
class RdsComboboxField extends StatefulWidget {
  /// The label displayed above the field.
  final String label;

  /// All available options for the popup.
  final List<RdsDropdownItem> items;

  /// The currently selected set of values. Already-selected values are
  /// excluded from the popup and rendered as chips inside the field.
  final Set<dynamic> selected;

  /// Called when the selection changes. `null` disables the field.
  final ValueChanged<Set<dynamic>>? onChanged;

  /// Placeholder text shown in the inline text input.
  final String placeholder;

  /// Descriptive helper text shown below the field.
  final String? supportText;

  /// Error message. When non-null the field enters the error state.
  final String? errorText;

  /// Shows an asterisk after the label when true.
  final bool mandatory;

  /// Prevents interaction and dims the field.
  final bool disabled;

  /// Maximum number of items that can be selected. `null` means no cap.
  final int? maxSelections;

  /// Maximum height of the floating popup before the list scrolls.
  final double popupMaxHeight;

  const RdsComboboxField({
    super.key,
    required this.label,
    required this.items,
    this.selected = const {},
    this.onChanged,
    this.placeholder = 'Search...',
    this.supportText,
    this.errorText,
    this.mandatory = false,
    this.disabled = false,
    this.maxSelections,
    this.popupMaxHeight = 320,
  });

  @override
  State<RdsComboboxField> createState() => _RdsComboboxFieldState();
}

class _RdsComboboxFieldState extends State<RdsComboboxField> {
  bool _isOpen = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _keyboardListenerFocusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _searchController.addListener(_onSearchChanged);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_focusNode.hasFocus && !_isOpen) {
      _openDropdown();
    }
  }

  void _onSearchChanged() {
    // Rebuild the overlay when the search query changes.
    _overlayEntry?.markNeedsBuild();
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _keyboardListenerFocusNode.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  bool get _isDisabled => widget.disabled || widget.onChanged == null;

  bool get _atMax =>
      widget.maxSelections != null &&
      widget.selected.length >= widget.maxSelections!;

  // ---------------------------------------------------------------------------
  // Filtered items: excludes selected values, filters by search query
  // ---------------------------------------------------------------------------

  List<RdsDropdownItem> get _filteredItems {
    final query = _searchController.text.toLowerCase();
    return widget.items
        .where((i) => !widget.selected.contains(i.value))
        .where(
          (i) =>
              query.isEmpty || i.label.toLowerCase().contains(query),
        )
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Selection mutations
  // ---------------------------------------------------------------------------

  void _addItem(dynamic value) {
    if (_atMax) return;
    final next = Set<dynamic>.from(widget.selected)..add(value);
    widget.onChanged?.call(next);
    _searchController.clear();
    // Rebuild overlay to refresh filtered list.
    _overlayEntry?.markNeedsBuild();
  }

  void _removeItem(dynamic value) {
    final next = Set<dynamic>.from(widget.selected)..remove(value);
    widget.onChanged?.call(next);
  }

  // ---------------------------------------------------------------------------
  // Overlay lifecycle
  // ---------------------------------------------------------------------------

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
          // The popup, positioned below the field.
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: Material(
                color: Colors.transparent,
                child: RdsDropdownPopup(
                  items: _filteredItems,
                  selectedValues: const {},
                  onItemSelected: (val) {
                    _addItem(val);
                    // Keep popup open for multi-select; close if at max.
                    if (_atMax) _closeDropdown();
                  },
                  maxHeight: widget.popupMaxHeight,
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

  /// Resolves a label string for the given selected value.
  String _labelForValue(dynamic value) {
    final match = widget.items.where((i) => i.value == value);
    if (match.isEmpty) return value.toString();
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

    // Chevron animates 180° when open.
    final chevron = GestureDetector(
      onTap: _isDisabled ? null : _toggleDropdown,
      child: AnimatedRotation(
        turns: _isOpen ? 0.5 : 0.0,
        duration: rds.durationStandard,
        curve: rds.curveStandard,
        child: Icon(
          RdsIcons.chevronDown,
          size: RdsIconSize.md,
          color: _isDisabled
              ? rds.onSurface.withOpacity(rds.opacityDisabled)
              : rds.onSurfaceVariant,
        ),
      ),
    );

    // Chips for the currently selected items.
    final chips = widget.selected.map((value) {
      return RdsInputChip(
        label: _labelForValue(value),
        selected: true,
        disabled: _isDisabled,
        onChanged: _isDisabled
            ? null
            : (_) => _removeItem(value),
      );
    }).toList();

    // Inline search text field (no decoration).
    final inlineInput = _isDisabled
        ? const SizedBox.shrink()
        : Flexible(
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              enabled: !_isDisabled,
              style: rds.bodyLarge.copyWith(color: rds.onSurface),
              cursorColor: rds.primary,
              decoration: InputDecoration(
                hintText: widget.selected.isEmpty ? widget.placeholder : null,
                hintStyle: rds.bodyLarge.copyWith(color: rds.onSurfaceMuted),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: rds.space2,
                ),
              ),
              onTap: _isDisabled ? null : () {
                if (!_isOpen) _openDropdown();
              },
              onChanged: (_) {
                if (!_isOpen) _openDropdown();
                _overlayEntry?.markNeedsBuild();
              },
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
      focusNode: _keyboardListenerFocusNode,
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          _closeDropdown();
        }
      },
      child: Semantics(
        textField: true,
        enabled: !_isDisabled,
        label: _labelText,
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
            padding: EdgeInsets.fromLTRB(
              rds.space3,
              rds.space2,
              rds.space2,
              rds.space2,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label row
                Padding(
                  padding: EdgeInsets.only(bottom: rds.space1),
                  child: Text(
                    _labelText,
                    style: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
                  ),
                ),
                // Chips + input + chevron row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: rds.space2,
                        runSpacing: rds.space2,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ...chips,
                          inlineInput,
                        ],
                      ),
                    ),
                    SizedBox(width: rds.space1),
                    chevron,
                  ],
                ),
              ],
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
              : SystemMouseCursors.text,
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
