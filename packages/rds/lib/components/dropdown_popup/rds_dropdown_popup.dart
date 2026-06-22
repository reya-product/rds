import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';
import '../../tokens/rds_icons.dart';
import '../../tokens/rds_radius.dart';
import '../../tokens/rds_shadows.dart';
import '../list_item/rds_list_item.dart';
import '../text_field/rds_search_bar.dart';
import 'rds_dropdown_item.dart';

export 'rds_dropdown_item.dart';

// ---------------------------------------------------------------------------
// RdsDropdownPopup
// ---------------------------------------------------------------------------

/// The floating popup surface used by Dropdown Field and Combobox Field (T3).
///
/// [RdsDropdownPopup] is the **content** widget only — it does not manage
/// overlay positioning. The parent component is responsible for showing it
/// inside an `OverlayEntry`, `showMenu`, or similar mechanism.
///
/// ### Layout
/// ```
/// ┌─────────────────────────────┐  ← surface, shadow-md, border, radius-md
/// │  [SearchBar]  (optional)    │
/// │  ─────────────────────────  │
/// │  [ListItem]  Option A       │
/// │  [ListItem]  Option B  ✓   │  ← selected
/// │  [ListItem]  Option C       │
/// │  ─────────────────────────  │  ← optional dividers
/// │  [ListItem]  Option D       │
/// └─────────────────────────────┘
/// ```
///
/// ### Example usage
/// ```dart
/// RdsDropdownPopup(
///   items: [
///     const RdsDropdownItem(value: 'a', label: 'Option A'),
///     const RdsDropdownItem(value: 'b', label: 'Option B'),
///   ],
///   selectedValues: {_selected},
///   onItemSelected: (v) => setState(() => _selected = v),
/// )
/// ```
class RdsDropdownPopup extends StatefulWidget {
  /// The options to display in the list.
  final List<RdsDropdownItem> items;

  /// The set of currently selected values. Selected items show a checkmark.
  final Set<dynamic> selectedValues;

  /// Called when the user taps an enabled item. Receives the item's [value].
  final ValueChanged<dynamic> onItemSelected;

  /// Maximum height of the popup before the list becomes scrollable.
  final double maxHeight;

  /// Explicit width. When null the popup expands to fill its parent constraint.
  final double? width;

  /// When true, a thin [outlineVariant] divider is drawn between items.
  final bool showDividers;

  /// When true, an [RdsSearchBar] is shown at the top of the popup, above the
  /// item list.
  final bool searchable;

  /// Called each time the search field value changes.
  /// Only used when [searchable] is true.
  final ValueChanged<String>? onSearchChanged;

  const RdsDropdownPopup({
    super.key,
    required this.items,
    this.selectedValues = const {},
    required this.onItemSelected,
    this.maxHeight = 320,
    this.width,
    this.showDividers = false,
    this.searchable = false,
    this.onSearchChanged,
  });

  @override
  State<RdsDropdownPopup> createState() => _RdsDropdownPopupState();
}

class _RdsDropdownPopupState extends State<RdsDropdownPopup> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<RdsDropdownItem> get _filteredItems {
    if (_searchQuery.isEmpty) return widget.items;
    final query = _searchQuery.toLowerCase();
    return widget.items.where((item) {
      return item.label.toLowerCase().contains(query) ||
          (item.supportingText?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  void _handleSearchChanged(String value) {
    setState(() => _searchQuery = value);
    widget.onSearchChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final items = _filteredItems;

    Widget listContent;

    if (items.isEmpty) {
      listContent = Padding(
        padding: EdgeInsets.symmetric(
          vertical: rds.space4,
          horizontal: rds.space4,
        ),
        child: Text(
          'No options',
          style: rds.bodyMedium.copyWith(color: rds.onSurfaceMuted),
        ),
      );
    } else {
      final rows = <Widget>[];
      for (var i = 0; i < items.length; i++) {
        final item = items[i];
        final isSelected = widget.selectedValues.contains(item.value);

        rows.add(
          Semantics(
            selected: isSelected,
            enabled: !item.disabled,
            label: item.label,
            button: true,
            child: RdsListItem(
              primaryText: item.label,
              supportingText: item.supportingText,
              leading: item.leadingIcon != null
                  ? RdsListItemLeading.icon
                  : RdsListItemLeading.none,
              leadingIcon: item.leadingIcon,
              trailing: isSelected
                  ? RdsListItemTrailing.icon
                  : RdsListItemTrailing.none,
              trailingIcon: RdsIcons.check,
              selected: isSelected,
              enabled: !item.disabled,
              onTap: item.disabled
                  ? null
                  : () => widget.onItemSelected(item.value),
            ),
          ),
        );

        if (widget.showDividers && i < items.length - 1) {
          rows.add(
            Divider(
              height: 1,
              thickness: 1,
              color: rds.outlineVariant,
            ),
          );
        }
      }

      listContent = ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: rows,
      );
    }

    // Constrain the list to maxHeight and make it scrollable.
    Widget body = ConstrainedBox(
      constraints: BoxConstraints(maxHeight: widget.maxHeight),
      child: listContent,
    );

    // Prepend the search bar when searchable.
    if (widget.searchable) {
      body = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              rds.space3,
              rds.space3,
              rds.space3,
              rds.space2,
            ),
            child: RdsSearchBar(
              controller: _searchController,
              placeholder: 'Search…',
              onChanged: _handleSearchChanged,
              onClear: () {
                _searchController.clear();
                _handleSearchChanged('');
              },
            ),
          ),
          Divider(height: 1, thickness: 1, color: rds.outlineVariant),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: widget.maxHeight - 60),
            child: listContent,
          ),
        ],
      );
    }

    // Outer surface: background + border + radius + shadow.
    final popup = DecoratedBox(
      decoration: BoxDecoration(
        color: rds.surface,
        borderRadius: RdsRadius.borderRadiusMd,
        border: Border.all(color: rds.outlineVariant),
        boxShadow: RdsShadows.shadowMd,
      ),
      child: ClipRRect(
        borderRadius: RdsRadius.borderRadiusMd,
        child: body,
      ),
    );

    if (widget.width != null) {
      return SizedBox(width: widget.width, child: popup);
    }

    return popup;
  }
}
