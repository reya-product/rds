# Dropdown Field
> A single-value form field that opens a floating `RdsDropdownPopup` overlay when tapped. The trailing chevron animates 180° to signal open/closed state.

## When to use / when not to use

**Use when:**
- The user must pick exactly one value from a fixed list
- The list has 4–20 items (fewer → use `RdsSegmentedControlInput`; more → add `searchable: true`)
- Screen space is tight and you can't show all options inline

**Do not use when:**
- Multiple selections are needed — use `RdsComboboxField`
- The list has ≤ 3 options — use `RdsSegmentedControlInput`
- The user types a free-form value — use `RdsTextField`

## Anatomy

```
┌───────────────────────────────────────────┐
│ Label *                                    │  ← bodyMedium, onSurfaceVariant
├────────────────── Value ──────────[▼]─────┤  ← value or placeholder | chevron
└───────────────────────────────────────────┘
│ Support text / error message               │  ← bodySmall
         ↓ (open)
┌───────────────────────────────────────────┐
│ [🔍 Search…]        (when searchable)     │
├───────────────────────────────────────────┤
│  Option 1                                 │
│  Option 2  ← selected                    │
│  Option 3                                 │
└───────────────────────────────────────────┘
```

## Configs (props)

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `label` | `String` | required | Field label |
| `items` | `List<RdsDropdownItem>` | required | Options to show in the popup |
| `value` | `dynamic` | null | Currently selected value |
| `onChanged` | `ValueChanged<dynamic>?` | null | Called on selection; null = disabled |
| `placeholder` | `String` | `'Select...'` | Shown when no value selected |
| `supportText` | `String?` | null | Helper text below the field |
| `errorText` | `String?` | null | Error message; triggers error state |
| `mandatory` | `bool` | false | Appends `*` to label |
| `disabled` | `bool` | false | Dims and prevents interaction |
| `searchable` | `bool` | false | Adds a search bar at the top of the popup |
| `popupMaxHeight` | `double` | 320 | Max popup height before scrolling |

## States

| State | Visual |
|-------|--------|
| Enabled (empty) | `outline` border; placeholder in `onSurfaceMuted` |
| Enabled (filled) | `outline` border; value in `onSurface` |
| Focused / open | `primary` border 2px; chevron rotated 180° |
| Error | `danger` border 2px; error text in `danger` |
| Disabled | `opacityDisabled` overlay; non-interactive |

## Tokens used

| Element | Token |
|---------|-------|
| Field background | `color-surface` |
| Border (default) | `color-outline` |
| Border (focused) | `color-primary` 2px |
| Border (error) | `color-danger` 2px |
| Label text | `color-on-surface-variant`, `body-medium` |
| Value text | `color-on-surface`, `body-large` |
| Placeholder text | `color-on-surface-muted`, `body-large` |
| Chevron icon | `color-on-surface-variant`, `icon-md` |
| Corner radius | `radius-md` |
| Padding | `space-4` horizontal, `space-4` vertical |
| Popup shadow | `shadow-md` |
| Popup corner radius | `radius-md` |

## Behavior & interaction

1. **Open** — tapping the field or chevron inserts an `OverlayEntry` via `LayerLink`/`CompositedTransformFollower` to float the popup directly below the field. The chevron animates to 180°.
2. **Dismiss** — tapping outside, pressing Escape, or selecting an item closes the popup. The chevron returns to 0°.
3. **Selection** — selecting an item calls `onChanged(item.value)` and closes the popup.
4. **Searchable mode** — when `searchable: true`, a search `RdsSearchBar` appears at the top of the popup; items are filtered in real-time by label.
5. **Keyboard** — Escape closes the popup; Tab moves focus away (closing the popup).

## Accessibility

- `Semantics(button: true, label: '$label: $value')` on the field
- Screen reader announces chevron state ("expanded"/"collapsed")
- Keyboard navigable: Enter/Space opens; Escape closes; Arrow keys navigate items (via `RdsDropdownPopup`)

## Content guidelines

- **Labels:** sentence case, ≤ 3 words
- **Placeholder:** "Select…" or domain-specific hint (e.g. "Choose a clinic")
- **Option labels:** noun phrases, sentence case, ≤ 4 words
- **Error messages:** specific and actionable (e.g. "Please select a health focus area")

## Composition

- Composed from `RdsPickerFieldBase`-style shell (inline `TextField(readOnly:true)` + `InputDecoration`)
- Opens `RdsDropdownPopup` via `OverlayEntry`
- Optionally includes `RdsSearchBar` inside the popup for filtering
- Used by: forms requiring a single selection from a fixed set

## Flutter API

```dart
RdsDropdownField(
  label: 'Health focus',
  items: const [
    RdsDropdownItem(value: 'cardio', label: 'Cardiovascular health'),
    RdsDropdownItem(value: 'sleep', label: 'Sleep quality'),
    RdsDropdownItem(value: 'nutrition', label: 'Nutrition & diet'),
  ],
  value: _selected,
  onChanged: (v) => setState(() => _selected = v),
  mandatory: true,
  searchable: true,
  supportText: 'Select the primary health goal for this patient',
)
```

## Widgetbook

- `dropdownFieldComponent` — use cases: Playground (all knobs), States gallery

## Do / Don't

**Do:**
- Add `searchable: true` when the list has more than ~10 items
- Use `mandatory: true` for required fields
- Keep option labels concise — the popup has limited width

**Don't:**
- Don't set `errorText` before the user has interacted with the field
- Don't use for multi-select — use `RdsComboboxField`
- Don't put RdsDropdownField inside a scrollable popup — the overlay will misalign
