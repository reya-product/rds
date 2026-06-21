# Input Chip

> A toggleable pill that lets users select or deselect a value from a set — commonly used for filters, tags, and multi-select controls.

---

## When to use / when not to use

**Use when:**
- Presenting a set of filterable categories where multiple values can be selected simultaneously (e.g. "Cardiology", "Neurology", "Oncology").
- Offering a compact, scannable alternative to a list of checkboxes when the options are few (2–8).
- Showing currently applied filters that users can remove by clicking.

**Do not use when:**
- Only one option can be selected at a time — use `RdsRadio` or a `RdsSegmentedButtons` control instead.
- The action is one-shot and non-reversible (e.g. "Submit", "Delete") — use `RdsButton` instead.
- There are more than ~10 options — use a `RdsMultiSelectInput` (dropdown) instead.
- A binary on/off state is needed for a feature setting — use `RdsToggleSwitch` instead.

---

## Anatomy

```
┌──────────────────────────────────┐
│  [✓ / icon?]  Label text         │
└──────────────────────────────────┘
        1             2
   [state overlay]
        3
```

| Part | Description |
|---|---|
| 1. Leading icon | Checkmark (selected) or custom icon (unselected with icon mode). 16px, matches content color. |
| 2. Label text | `label-medium` text. Truncated with ellipsis if overflow occurs. |
| 3. State overlay | Semi-transparent layer animating hover, focus, and press feedback. |
| 4. Container | Pill shape (`radius-full`), 32px height. Background and border change by state. |
| 5. Focus ring | 2px `primary` border appears on keyboard focus. |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| Label only (`iconMode: none`) | Text chip; shows checkmark when selected. | Default; majority of chip use cases. |
| Leading icon (`iconMode: leading`) | Custom icon + label; checkmark replaces icon when selected. | When an icon reinforces the option's meaning (e.g. calendar for "Today"). |
| Icon only (`iconMode: iconOnly`) | Icon pill; checkmark replaces icon when selected; label is semantic only. | Extremely space-constrained toolbars; always provide a nearby visible label or tooltip. |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | required | Visible text and accessibility label. |
| `iconMode` | `RdsChipIconMode` | `RdsChipIconMode.none` | Whether and where to show an icon. |
| `icon` | `IconData?` | `null` | Icon for `leading` / `iconOnly` modes. |
| `selected` | `bool` | `false` | Whether the chip is currently active. |
| `onChanged` | `ValueChanged<bool>?` | `null` | Callback with the new selection value. |
| `disabled` | `bool` | `false` | When `true`, chip is non-interactive and dimmed. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled (unselected) | Default | `surfaceContainer` fill, `outline` border, `onSurface` content. | `color-surface-container`, `color-outline`, `color-on-surface` |
| Hover (unselected) | Pointer enters | State layer at `state-hover` opacity applied over `onSurface`. | `state-hover` (0.08) |
| Focus | Keyboard tab | 2px `primary` focus ring. State layer at `state-focus` opacity. | `color-primary`, `state-focus` (0.12) |
| Pressed | Tap / click | State layer at `state-pressed` opacity. | `state-pressed` (0.16) |
| Selected | `selected: true` | `primaryContainer` fill, no border, checkmark icon, `onPrimaryContainer` content. | `color-primary-container`, `color-on-primary-container` |
| Hover (selected) | Pointer enters selected chip | State layer at `state-hover` over `onPrimaryContainer`. | `state-hover` (0.08) |
| Disabled | `disabled: true` | All content at `opacity-disabled` (0.38). No interaction. | `opacity-disabled` |

---

## Sizes

| Size | Height | H-padding | Font style | Icon size | Touch target |
|---|---|---|---|---|---|
| Default (only) | 32px | `space-3` (12px) | `label-medium` | 16px | 44px via `ConstrainedBox` |

---

## Tokens used

**Colors**
- `color-surface-container` — unselected background
- `color-outline` — unselected border
- `color-on-surface` — unselected content (text, icon)
- `color-primary-container` — selected background
- `color-on-primary-container` — selected content (text, icon, checkmark)
- `color-primary` — focus ring color

**Typography**
- `label-medium` — chip label text

**Spacing**
- `space-3` — horizontal padding
- `space-1` — gap between icon and label

**Radius**
- `radius-full` — pill shape

**Opacity / state layers**
- `state-hover` (0.08) — hover overlay
- `state-focus` (0.12) — focus overlay
- `state-pressed` (0.16) — press overlay
- `opacity-disabled` (0.38) — disabled content opacity

**Motion**
- `motion-duration-fast` (100ms) — state layer animation

---

## Behavior & interaction

### Mouse / touch
- Click / tap toggles selected state and calls `onChanged` with the new boolean.
- Hover shows a subtle state layer overlay.

### Keyboard
- `Tab` moves focus to/from the chip.
- `Space` or `Enter` toggles the chip while focused.
- Focus ring (2px `primary` border) is drawn when chip is keyboard-focused.

### Focus management
- Focus stays on the chip after toggling — does not move to next item.

### Animation
- State layer transition: 100ms (`motion-duration-fast`), no curve.
- Selection state change (background color swap): 200ms (`motion-duration-standard`) eased.

---

## Accessibility

- **Semantics:** `Semantics(button: true, checked: selected, enabled: !disabled, label: label)` is applied.
- **Min touch target:** 44px height enforced via `ConstrainedBox` wrapping the 32px visual chip.
- **Contrast:** `primaryContainer` / `onPrimaryContainer` and `surfaceContainer` / `onSurface` pairs meet WCAG AA. Disabled opacity reduces to 0.38 which is permitted for disabled controls by WCAG.
- **Screen reader:** Announces as a button with a checked/unchecked state, e.g. "Cardiology, button, checked".
- **Keyboard:** Fully operable via keyboard. `Tab` + `Space`/`Enter` toggles.

---

## Content guidelines

- **Label:** Sentence case. 1–3 words recommended. Avoid verbs — use nouns or adjectives (e.g. "Active", "Cardiology", "This week").
- **Icon only:** Only use when the icon is universally understood AND a tooltip or nearby label provides the text equivalent.
- **Truncation:** Labels exceeding the available width are truncated with ellipsis. Prefer short labels over truncation.

---

## Composition

**Uses:**
- Primitive — no RDS dependencies (uses `RdsTheme` tokens only).

**Used by:**
- Filter bars in list views and dashboards.
- Tag input fields (custom composition).

---

## Flutter API

### Widget class
`RdsInputChip`

### Constructor
```dart
const RdsInputChip({
  super.key,
  required String label,
  RdsChipIconMode iconMode = RdsChipIconMode.none,
  IconData? icon,
  bool selected = false,
  ValueChanged<bool>? onChanged,
  bool disabled = false,
});
```

### Public enums

```dart
enum RdsChipIconMode { none, leading, iconOnly }
```

### Example usage

```dart
// Stateful toggle chip
RdsInputChip(
  label: 'Cardiology',
  selected: _isSelected,
  onChanged: (value) => setState(() => _isSelected = value),
)

// Chip with leading icon
RdsInputChip(
  label: 'Today',
  iconMode: RdsChipIconMode.leading,
  icon: RdsIcons.calendar,
  selected: _todaySelected,
  onChanged: (v) => setState(() => _todaySelected = v),
)

// Disabled chip
RdsInputChip(
  label: 'Unavailable',
  disabled: true,
  selected: false,
  onChanged: null,
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | All props as knobs; single chip preview with live toggle. |
| `Gallery` | All icon modes × selected/unselected × disabled shown in a grid. |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `Label` | `string` | `label` | — |
| `Icon mode` | `list` | `iconMode` | `none`, `leading`, `iconOnly` |
| `Selected` | `boolean` | `selected` | `true` / `false` |
| `Disabled` | `boolean` | `disabled` | `true` / `false` |

---

## Do / Don't

| Do | Don't |
|---|---|
| Use chips in groups so users can see and compare all available options at once. | Don't use a single isolated chip — if there is only one option, use a checkbox or toggle instead. |
| Show the selected count or applied filter summary elsewhere in the UI. | Don't rely on chip selection color alone to indicate state — the checkmark icon also communicates selection. |
| Keep chips in a `Wrap` widget so they reflow on narrow screens. | Don't place chips inside a horizontally scrolling row that hides options off-screen. |
| Use `disabled: true` with a `RdsTooltip` explaining why the option is unavailable. | Don't silently hide unavailable options — users need to understand why they cannot select them. |
