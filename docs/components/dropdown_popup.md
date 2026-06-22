# Dropdown Popup

> A floating surface containing a scrollable list of selectable options. The visual popup layer used by Dropdown Field and Combobox Field.

---

## When to use / when not to use

**Use when:**
- You need the visual popup content for a Dropdown Field or Combobox Field (T3) — i.e. you are building a higher-level input component.
- You need a standalone floating option list that the parent controls via `OverlayEntry` or `showMenu`.
- The options list may be long enough to require scrolling, or filtered by a search input.

**Do not use when:**
- You need a fully self-contained input with a trigger — use `RdsDropdownField` (T3) instead.
- You need a context menu (right-click menu) — use `showMenu` with a bespoke widget tree.
- You need a bottom sheet on mobile — use `showModalBottomSheet`.
- The list items need custom row layouts — extend `RdsListItem` or use a custom `Column`.

---

## Anatomy

```
┌─────────────────────────────────────────┐  ← 1. surface
│  [RdsSearchBar]  Search…               │  ← 2. search field (optional)
│  ─────────────────────────────────────  │  ← 3. divider (auto, when searchable)
│  [ListItem]  Option A                   │  ← 4. list item
│  ─────────────────────────────────────  │  ← 5. item divider (optional)
│  [ListItem]  Option B    ✓             │  ← 4. list item (selected)
│  [ListItem]  Option C                   │  ← 4. list item
│  [ListItem]  Option D    (disabled)    │  ← 4. list item (disabled)
└─────────────────────────────────────────┘
```

| Part | Description |
|---|---|
| 1. Surface | `DecoratedBox` with `color-surface` background, `radius-md` corners, 1px `outline-variant` border, and `shadow-md`. |
| 2. Search field | Optional `RdsSearchBar` at the top of the popup. Shown when `searchable: true`. Filters items as the user types. |
| 3. Search divider | 1px `outline-variant` divider separating the search bar from the item list. Auto-inserted when `searchable: true`. |
| 4. List item | One `RdsListItem` per `RdsDropdownItem`. Selected items use `selected: true` (tinted background, primary checkmark in trailing). Disabled items use `enabled: false`. |
| 5. Item divider | Optional 1px `outline-variant` full-width divider between items. Shown when `showDividers: true`. |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| Default | Plain list of options, no search field, no dividers. | Simple short lists (≤8 options). |
| With dividers | Full-width dividers between every item. | When visual separation aids scanning. |
| Searchable | Search field pinned above the list; list filters on input. | Long lists (>10 options) or when the user must type to narrow. |
| With icons | Each item has a leading icon from `RdsDropdownItem.leadingIcon`. | When icons add quick recognition (e.g. status, category). |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `items` | `List<RdsDropdownItem>` | required | Options to display. |
| `selectedValues` | `Set<dynamic>` | `{}` | Currently selected values. Selected items show a checkmark. |
| `onItemSelected` | `ValueChanged<dynamic>` | required | Called when a non-disabled item is tapped. Receives the item's `value`. |
| `maxHeight` | `double` | `320` | Maximum popup height before the list scrolls. |
| `width` | `double?` | `null` | Explicit popup width. `null` fills the available constraint (typically set by the trigger). |
| `showDividers` | `bool` | `false` | Draws 1px dividers between items. |
| `searchable` | `bool` | `false` | Adds an `RdsSearchBar` at the top that filters items. |
| `onSearchChanged` | `ValueChanged<String>?` | `null` | Called on each keystroke in the search field. |

**`RdsDropdownItem` data class:**

| Field | Type | Default | Description |
|---|---|---|---|
| `value` | `dynamic` | required | Opaque identifier. Returned by `onItemSelected`. |
| `label` | `String` | required | Human-readable label shown in the row. |
| `supportingText` | `String?` | `null` | Optional secondary text below the label. |
| `leadingIcon` | `IconData?` | `null` | Optional icon in the leading slot. |
| `disabled` | `bool` | `false` | Prevents selection; renders at `opacity-disabled`. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled | Default | Normal item row. | — |
| Hover | Pointer enters item | State layer overlay on item row. | `state-hover` × `on-surface` |
| Pressed | Tap / click | Darker state layer. | `state-pressed` × `on-surface` |
| Selected | `value` in `selectedValues` | `primary-container` background; `check` icon in trailing slot. | `color-primary-container`, `color-primary` |
| Disabled | `RdsDropdownItem.disabled: true` | Reduced opacity; no pointer cursor; no interaction. | `opacity-disabled` |
| Empty search | Search query matches no items | "No options" placeholder text in `on-surface-muted`. | `color-on-surface-muted` |

---

## Tokens used

**Colors**
- `color-surface` — popup background
- `color-outline-variant` — 1px border, dividers, search-to-list separator
- `color-primary-container` — selected item row background
- `color-primary` — checkmark icon and overline on selected item
- `color-on-surface-muted` — "No options" placeholder text

**Radius**
- `radius-md` — popup corner radius

**Shadows**
- `shadow-md` — popup elevation

**Spacing**
- `space-1` — gap between search bar and divider (internal)
- `space-2` — bottom padding below search bar
- `space-3` — horizontal/vertical padding around search bar
- `space-4` — horizontal inset of items

**Motion**
- (Popup open/close animation is the parent's responsibility; this widget is static.)

---

## Behavior & interaction

### Mouse / touch
- Tapping an enabled item calls `onItemSelected` with the item's `value`.
- Tapping a disabled item does nothing.
- Tapping a selected item calls `onItemSelected` (the parent decides whether to deselect).
- When `searchable: true`, typing in the search bar filters the displayed items in real time.
- Clearing the search bar restores the full list.

### Keyboard
- Tab focus moves through items in document order.
- Space/Enter activates the focused item.
- Arrow keys (Up/Down) should be implemented by the parent overlay that hosts this popup.

### Focus management
- The popup widget itself does not steal focus on mount.
- When `searchable: true` the parent may auto-focus the search bar on open.

### Scrolling
- The item list scrolls vertically when the total height of items exceeds `maxHeight`.
- When `searchable: true`, `maxHeight` is reduced by the search bar height (~60px) to keep the popup within bounds.

### Animation
- Popup enter/exit animation is the parent's responsibility (e.g., `FadeTransition` + `SizeTransition` via `OverlayEntry`).
- This widget is static and does not animate internally.

---

## Accessibility

- **Semantics:** Each item row emits `Semantics(button: true, selected: …, enabled: …, label: item.label)`.
- **Min touch target:** List item rows have a minimum height of 56px (enforced by `RdsListItem`).
- **Contrast:** `on-surface` on `surface` (default) and `on-primary-container` on `primary-container` (selected) both meet WCAG AA.
- **Screen reader:** Each item announces its label, role (button), and selected/enabled state.
- **Keyboard:** Items receive focus and respond to Space/Enter. The search bar is a standard text input.

---

## Content guidelines

- **Label:** Sentence case. Keep labels ≤ 40 characters. Truncate with ellipsis if longer.
- **Supporting text:** Optional. Use to add context (e.g. job title, category, metric). ≤ 60 characters.
- **Search placeholder:** Use "Search…" (the default). Can be customized at the parent level by passing a pre-configured `RdsSearchBar`.
- **Disabled items:** Keep the label visible and unchanged so the user understands what is unavailable.

---

## Composition

**Uses:**
- `RdsListItem` — each option row.
- `RdsSearchBar` — the optional search field at the top.

**Used by:**
- `RdsDropdownField` (T3) — single-select dropdown input.
- `RdsComboboxField` (T3) — single-select with free-text entry.
- `RdsMultiSelectInput` (T2b) — multi-select variant (wraps this popup).
- `RdsSingleSelectInput` (T2b) — thin wrapper around this popup.

---

## Flutter API

### Widget class
`RdsDropdownPopup`

### Constructor
```dart
const RdsDropdownPopup({
  super.key,
  required List<RdsDropdownItem> items,
  Set<dynamic> selectedValues = const {},
  required ValueChanged<dynamic> onItemSelected,
  double maxHeight = 320,
  double? width,
  bool showDividers = false,
  bool searchable = false,
  ValueChanged<String>? onSearchChanged,
});
```

### Data class
```dart
class RdsDropdownItem {
  final dynamic value;
  final String label;
  final String? supportingText;
  final IconData? leadingIcon;
  final bool disabled;

  const RdsDropdownItem({
    required dynamic value,
    required String label,
    String? supportingText,
    IconData? leadingIcon,
    bool disabled = false,
  });
}
```

### Example usage

```dart
// Basic usage inside an overlay
RdsDropdownPopup(
  items: const [
    RdsDropdownItem(value: 'a', label: 'Option A'),
    RdsDropdownItem(value: 'b', label: 'Option B'),
    RdsDropdownItem(value: 'c', label: 'Option C', disabled: true),
  ],
  selectedValues: {_selected},
  onItemSelected: (v) {
    setState(() => _selected = v);
    Navigator.of(context).pop();
  },
)

// Searchable, long list
RdsDropdownPopup(
  items: _allDoctors,
  selectedValues: _selectedDoctors,
  onItemSelected: (v) => setState(() => _toggle(v)),
  searchable: true,
  showDividers: true,
  maxHeight: 400,
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | Knob-driven. Adjust `showDividers`, `searchable`, and `maxHeight`. 8 pre-populated demo items. `StatefulBuilder` tracks `selectedValues`. |
| `With icons` | All items have `leadingIcon` set to demonstrate icon-leading rows. |
| `Searchable` | Popup with `searchable: true` and a pre-populated long list. |
| `Long list` | 20 items to demonstrate scrolling when list exceeds `maxHeight`. |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `Show dividers` | boolean | `showDividers` | true / false |
| `Searchable` | boolean | `searchable` | true / false |
| `Max height` | double (slider) | `maxHeight` | 160 – 480 |

---

## Do / Don't

| Do | Don't |
|---|---|
| Let the parent Dropdown Field control positioning via `OverlayEntry`. | Position the popup from within the popup itself — it has no notion of its anchor. |
| Use `selectedValues` as a `Set` to naturally support both single and multi-select parents. | Pass a mutable `Set` reference and mutate it outside `setState`. |
| Keep `maxHeight` at 320 (default) for standard dropdowns. | Set `maxHeight` so large it exceeds the viewport — always cap at roughly 40–50% of screen height in the parent. |
| Use `searchable: true` for lists with more than 10 items. | Show a search bar in a list of 3–5 items — it adds friction without benefit. |
