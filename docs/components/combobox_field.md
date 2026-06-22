# Combobox Field
> A multi-value form field where selected options appear as removable `RdsInputChip`s inside the field body. The user types to filter a floating `RdsDropdownPopup` of remaining options.

## When to use / when not to use

**Use when:**
- The user must select multiple values from a fixed list
- The list is long enough that inline checkboxes would overflow
- Search-to-filter UX is appropriate

**Do not use when:**
- Single selection only — use `RdsDropdownField`
- The list has ≤ 5 items — use `RdsMultiSelectListInput` or checkboxes
- The user types free-form text — use `RdsTextField` with tag management

## Anatomy

```
┌───────────────────────────────────────────┐
│ Label *                                    │  ← bodyMedium, onSurfaceVariant
├───────────────────────────────────────────┤
│ [Chip A ×]  [Chip B ×]  Search…           │  ← chips + inline text input
└───────────────────────────────────────────┘
│ Support text / error message               │  ← bodySmall
         ↓ (open while typing)
┌───────────────────────────────────────────┐
│  Option C  (A and B already excluded)     │
│  Option D                                 │
└───────────────────────────────────────────┘
```

## Configs (props)

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `label` | `String` | required | Field label |
| `items` | `List<RdsDropdownItem>` | required | All available options |
| `selected` | `Set<dynamic>` | `{}` | Currently selected values |
| `onChanged` | `ValueChanged<Set<dynamic>>?` | null | Called when selection changes; null = disabled |
| `placeholder` | `String` | `'Search...'` | Shown in the inline text input when empty |
| `supportText` | `String?` | null | Helper text below the field |
| `errorText` | `String?` | null | Error message; triggers error state |
| `mandatory` | `bool` | false | Appends `*` to label |
| `disabled` | `bool` | false | Dims and prevents interaction |
| `maxSelections` | `int?` | null | Cap on number of selected items |
| `popupMaxHeight` | `double` | 320 | Max popup height before scrolling |

## States

| State | Visual |
|-------|--------|
| Empty (no selection) | `outline` border; placeholder text |
| With chips | `outline` border; chips + text input |
| Focused / popup open | `primary` border 2px; popup visible |
| Error | `danger` border 2px; error text in `danger` |
| Disabled | `opacityDisabled` overlay; chips non-removable |
| At max selections | Text input hidden; popup not opened |

## Tokens used

| Element | Token |
|---------|-------|
| Field background | `color-surface` |
| Border (default) | `color-outline` |
| Border (focused) | `color-primary` 2px |
| Border (error) | `color-danger` 2px |
| Label text | `color-on-surface-variant`, `body-medium` |
| Chip | `RdsInputChip` (see input_chip.md) |
| Text input | `color-on-surface`, `body-large` |
| Placeholder | `color-on-surface-muted`, `body-large` |
| Corner radius | `radius-md` |
| Padding | `space-4` horizontal, `space-3` vertical |
| Popup shadow | `shadow-md` |

## Behavior & interaction

1. **Chip rendering** — each item in `selected` renders as an `RdsInputChip` inside the field. Chips appear before the inline text input.
2. **Chip removal** — tapping the × on a chip removes the value from `selected` and calls `onChanged`.
3. **Typing** — typing in the inline text input opens the popup (if not already open) and filters options in real-time by label. Already-selected items are excluded.
4. **Selection** — tapping a popup item adds it to `selected`, calls `onChanged`, and clears the text input. The popup stays open.
5. **Max selections** — when `selected.length == maxSelections`, the text input is hidden and tapping the field does nothing. Removing a chip re-enables input.
6. **Dismiss** — tapping outside, pressing Escape, or blurring the field closes the popup.
7. **Keyboard** — Backspace in empty text input removes the last chip. Escape closes popup.

## Accessibility

- `Semantics(label: '$label: $selectedCount selected')` on the field container
- Each chip has `Semantics(label: '$label, remove', button: true)`
- Screen reader announces popup open/close state

## Content guidelines

- **Labels:** sentence case, ≤ 3 words
- **Placeholder:** "Search…" or "Add …" (e.g. "Add conditions")
- **Chip labels:** match the `RdsDropdownItem.label` exactly — don't truncate
- **Max selections:** show `supportText` to communicate the limit (e.g. "Choose up to 3 areas")

## Composition

- Renders `RdsInputChip` for each selected value
- Opens `RdsDropdownPopup` via `OverlayEntry` + `LayerLink`
- Items filtered via text controller, excludes already-selected values
- Used by: multi-tag form fields, health interest selection, diagnosis coding

## Flutter API

```dart
RdsComboboxField(
  label: 'Health focus areas',
  items: const [
    RdsDropdownItem(value: 'cardio', label: 'Cardiovascular health'),
    RdsDropdownItem(value: 'sleep', label: 'Sleep quality'),
    RdsDropdownItem(value: 'nutrition', label: 'Nutrition & diet'),
    RdsDropdownItem(value: 'mental', label: 'Mental wellbeing'),
  ],
  selected: _selected,
  onChanged: (v) => setState(() => _selected = v),
  mandatory: true,
  maxSelections: 3,
  supportText: 'Select up to 3 focus areas',
)
```

## Widgetbook

- `comboboxFieldComponent` — use cases: Playground (all knobs), States gallery

## Do / Don't

**Do:**
- Always set `supportText` when `maxSelections` is set — users need to know the limit
- Use for 4+ selectable items
- Keep option labels short enough to fit as chips (≤ 25 chars)

**Don't:**
- Don't use for single selection — use `RdsDropdownField`
- Don't set `errorText` before the user has interacted
- Don't nest inside another overlay (popup misalignment)
