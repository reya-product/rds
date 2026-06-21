# Button Group

> A horizontal row of semantically related buttons with optional single or multi-select behaviour.

---

## When to use / when not to use

**Use when:**
- A set of related actions should be presented together (e.g. "Copy / Paste / Cut").
- Users need to switch a view between mutually exclusive options that are actions by nature (e.g. "Day / Week / Month").
- Multi-select filtering across a small, fixed option set (≤ 6 options).

**Do not use when:**
- You need a connected pill-style control where segments share borders — use `RdsSegmentedButtons` instead.
- Options form a longer list (> 6 items) — use `RdsDropdown` or a `RdsMultiSelectInput`.
- Options represent a true toggle (binary on/off) — use `RdsToggleSwitch`.
- The buttons are unrelated actions that happen to be near each other — render individual `RdsButton` widgets.

---

## Anatomy

```
 ┌──────────┐  ┌──────────┐  ┌──────────┐
 │  Button  │  │  Button  │  │  Button  │
 └──────────┘  └──────────┘  └──────────┘
      1              2              3
      ←  space-2  →  ←  space-2  →
```

| Part | Description |
|---|---|
| 1–N. Button items | Each item is a full `RdsButton` with its own rounded border. In selection mode, selected buttons show `primary` fill; unselected show `outlined`. |
| Gap | `space-2` (8px) gap between each button. Buttons are visually separate — not connected. |

---

## Variants

`RdsButtonGroup` does not have named visual variants of its own — the buttons inside adopt their appearance based on selection state:

| Selection mode | Unselected button style | Selected button style |
|---|---|---|
| `none` | `outlined` | N/A |
| `single` | `outlined` | `primary` |
| `multi` | `outlined` | `primary` |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `items` | `List<RdsButtonGroupItem>` | required | Ordered list of button configurations. Index determines selection key. |
| `selectionMode` | `RdsButtonGroupSelectionMode` | `none` | `none` (plain actions), `single` (radio), `multi` (checkboxes). |
| `selected` | `Set<int>` | `{}` | Indices of currently selected buttons. |
| `onSelectionChanged` | `ValueChanged<Set<int>>?` | `null` | Called with the new selection set when a button is tapped (in selection modes only). |
| `size` | `RdsButtonSize` | `medium` | Size applied uniformly to all buttons. |
| `disabled` | `bool` | `false` | Disables all buttons in the group. |

### RdsButtonGroupItem fields

| Field | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | required | Button label text. |
| `icon` | `IconData?` | `null` | Optional icon. |
| `iconPosition` | `RdsButtonIconPosition` | `none` | Icon placement within this button. |
| `disabled` | `bool` | `false` | Disables this specific button regardless of group `disabled` state. |
| `tooltip` | `String?` | `null` | Tooltip for icon-only buttons. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled unselected | Default in selection mode | `outlined` style | `color-outline` border |
| Enabled selected | In `selected` set | `primary` fill | `color-primary`, `color-on-primary` |
| Hover | Mouse over an interactive button | State layer at 8% on the button's on-color | `state-hover` |
| Focus | Keyboard focus on a button | State layer at 12% | `state-focus` |
| Pressed | Tap / click hold | State layer at 16% | `state-pressed` |
| Disabled | Item `disabled: true` or group `disabled: true` | Full button at `opacity-disabled` | `opacity-disabled` |

---

## Tokens used

**Colors**
- `color-primary` — fill for selected buttons in selection modes
- `color-on-primary` — label/icon on selected primary-fill buttons
- `color-outline` — border for unselected/non-selection-mode buttons
- `state-hover`, `state-focus`, `state-pressed` — interactive state layers
- `opacity-disabled` — disabled button opacity

**Typography**
- `label-large` — button label text (via `RdsButton`)

**Spacing**
- `space-2` — gap between buttons in the row
- Button internal padding via `RdsButton` (see Button tokens)

**Radius**
- `radius-md` — each button's corner radius (via `RdsButton`)

**Motion**
- `motion-duration-standard` — state layer transitions (via `RdsButton`)
- `motion-curve-standard` — easing (via `RdsButton`)

---

## Behavior & interaction

### Mouse / touch
- Tapping a button in `none` mode calls `onPressed` directly on the button item (not tracked by the group).
- Tapping in `single` mode replaces the entire selection set with `{index}`.
- Tapping in `multi` mode toggles the tapped index into/out of the selection set.
- Tapping a disabled button has no effect.

### Keyboard
- `Tab` moves focus between buttons in the group.
- `Space` or `Enter` activates the focused button.
- Arrow keys do not navigate within the group (each button is a standalone focus target).

### Focus management
- Each button in the group is an independent focus node.
- Focus does not jump automatically after selection.

### Animation
- State layer transitions use `motion-duration-standard` (200ms) with `motion-curve-standard`.
- `motion-duration-instant` is used when `MediaQuery.disableAnimations` is true.

---

## Accessibility

- **Semantics:** The group container has `Semantics(label: 'Button group')`. Each child `RdsButton` has its own semantics with `button: true`, `enabled`, and `label`.
- **Min touch target:** 44 × 44px per button, enforced via `RdsButton`.
- **Contrast:** Selected buttons use `color-primary` / `color-on-primary`; unselected use `color-outline` border with `color-primary` label — all AA compliant.
- **Screen reader:** Each button announces its label and selected state. In selection modes, selected buttons are announced with `selected: true` via `Semantics`.
- **Keyboard:** Fully operable via Tab + Space/Enter.

---

## Content guidelines

- **Labels:** Keep each button label ≤ 2 words. Use parallel structure across items (all nouns or all verbs).
- **Item count:** 2–6 items. Fewer than 2 is not a group; more than 6 should use a dropdown or filter chip row.
- **Icons:** Use icons consistently — either all items have icons or none do. Mix sparingly.

---

## Composition

**Uses:**
- `RdsButton` — each item in the group is a full `RdsButton` instance.

**Used by:**
- Toolbar patterns in app shell layouts.
- Filter bars in list/table views.

---

## Flutter API

### Widget class
`RdsButtonGroup`

### Constructor
```dart
const RdsButtonGroup({
  Key? key,
  required List<RdsButtonGroupItem> items,
  RdsButtonGroupSelectionMode selectionMode = RdsButtonGroupSelectionMode.none,
  Set<int> selected = const {},
  ValueChanged<Set<int>>? onSelectionChanged,
  RdsButtonSize size = RdsButtonSize.medium,
  bool disabled = false,
});
```

### Public enums

```dart
enum RdsButtonGroupSelectionMode { none, single, multi }
```

*(Also reuses `RdsButtonSize` and `RdsButtonIconPosition` from `RdsButton`.)*

### RdsButtonGroupItem constructor
```dart
const RdsButtonGroupItem({
  required String label,
  IconData? icon,
  RdsButtonIconPosition iconPosition = RdsButtonIconPosition.none,
  bool disabled = false,
  String? tooltip,
});
```

### Example usage

```dart
// Simple action group (no selection)
RdsButtonGroup(
  items: const [
    RdsButtonGroupItem(label: 'Copy', icon: Icons.copy, iconPosition: RdsButtonIconPosition.leading),
    RdsButtonGroupItem(label: 'Paste', icon: Icons.paste, iconPosition: RdsButtonIconPosition.leading),
    RdsButtonGroupItem(label: 'Cut', icon: Icons.cut, iconPosition: RdsButtonIconPosition.leading),
  ],
)

// Single-select view switcher
RdsButtonGroup(
  items: const [
    RdsButtonGroupItem(label: 'Day'),
    RdsButtonGroupItem(label: 'Week'),
    RdsButtonGroupItem(label: 'Month'),
  ],
  selectionMode: RdsButtonGroupSelectionMode.single,
  selected: {1},
  onSelectionChanged: (next) => setState(() => _view = next),
)

// Multi-select filter
RdsButtonGroup(
  items: const [
    RdsButtonGroupItem(label: 'Active'),
    RdsButtonGroupItem(label: 'Pending'),
    RdsButtonGroupItem(label: 'Archived'),
  ],
  selectionMode: RdsButtonGroupSelectionMode.multi,
  selected: {0, 1},
  onSelectionChanged: (next) => setState(() => _filters = next),
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | All props exposed as knobs |
| `Gallery` | Selection modes side by side with pre-set selections |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `Selection mode` | list | `selectionMode` | `none`, `single`, `multi` |
| `Size` | list | `size` | `small`, `medium`, `large` |
| `Disabled` | boolean | `disabled` | `false` |

---

## Do / Don't

| Do | Don't |
|---|---|
| Use `selectionMode: single` for mutually exclusive view switches | Use `selectionMode: none` when the buttons share state — selection state will be lost |
| Keep all item labels at similar lengths for visual balance | Mix very short and very long labels in the same group |
| Provide `tooltip` for any icon-only item | Use icon-only items without a tooltip or semantic label |
| Limit to 6 items max | Create a button group with 8+ items — use a dropdown instead |
