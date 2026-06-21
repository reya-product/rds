# Checkbox

> A tristate selection control that allows users to check, uncheck, or set an indeterminate state. Used for standalone boolean choices, list multi-selection, and parent/child grouping patterns.

---

## When to use / when not to use

**Use when:**
- The user can independently toggle a single boolean option (e.g. "Agree to terms").
- In a list where multiple items can be selected simultaneously.
- As a parent control to represent a partially-selected child group (indeterminate state).
- Inside a form row where the input is a yes/no choice.

**Do not use when:**
- Exactly one item must be selected from a group — use `RdsRadio` instead.
- The action is binary and immediate (e.g. enabling a feature that takes effect on change) — use `RdsToggleSwitch` instead.
- A single choice toggles a view or layout — use a Segmented Button instead.

---

## Anatomy

```
┌─────────────────────┐
│  ┌──────┐           │
│  │  ✓   │  Label    │  ← 44×44 touch target wraps both
│  └──────┘           │
└─────────────────────┘
    ↑
    20×20 control box
```

| Part | Description |
|---|---|
| 1. Control box | The 20×20px square that holds the visual check/dash/empty state. 2px border, `radius-xs` corner. |
| 2. Checkmark | Animated path drawn in `color-on-primary` when `value == true`. |
| 3. Dash | Horizontal dash drawn in `color-on-primary` when `value == null` (indeterminate). |
| 4. Touch target | 44×44px `ConstrainedBox` around the control — invisible, but catches all pointer events. |
| 5. State layer | Circular overlay centered on the touch target, applied on hover/focus/press. |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| Unchecked | Transparent fill, `color-outline` 2px border | Default empty state |
| Checked | `color-primary` fill, white animated checkmark | Item is selected |
| Indeterminate | `color-primary` fill, white animated dash | Partial child selection (parent checkbox pattern) |
| Error | `color-danger` border (unchecked) or fill (checked) | Validation failed on this field |
| Read-only | `color-surface-container` fill (checked) / `color-outline-variant` border; no cursor change | Display-only; value cannot be changed |
| Disabled | All states dimmed to `opacity-disabled` | Field is not currently available |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `value` | `bool?` | required | `true` = checked, `false` = unchecked, `null` = indeterminate |
| `onChanged` | `ValueChanged<bool?>?` | `null` | Callback with new value. If null, acts as non-interactive. |
| `disabled` | `bool` | `false` | Applies `opacity-disabled` and blocks interaction. |
| `readOnly` | `bool` | `false` | Shows value with muted styling, no pointer cursor, no interaction. |
| `error` | `bool` | `false` | Applies `color-danger` border/fill. |
| `size` | `double` | `20.0` | Width and height of the visible control box in logical pixels. |
| `semanticLabel` | `String?` | `null` | Accessibility label announced by screen readers. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled | Default | Normal appearance | — |
| Hover | Mouse pointer over touch target | Circular semi-transparent overlay appears | `state-hover` × `color-primary` or `color-on-primary` |
| Focus | Keyboard focus (Tab) | Circular semi-transparent overlay appears | `state-focus` × `color-primary` or `color-on-primary` |
| Pressed | Tap / click held | Circular overlay at pressed opacity | `state-pressed` × `color-primary` or `color-on-primary` |
| Checked | `value == true` | `color-primary` fill, animated checkmark draws in | `color-primary`, `color-on-primary` |
| Indeterminate | `value == null` | `color-primary` fill, animated dash draws in | `color-primary`, `color-on-primary` |
| Error unchecked | `error: true`, `value == false` | `color-danger` 2px border | `color-danger` |
| Error checked | `error: true`, `value != false` | `color-danger` fill | `color-danger` |
| Read-only | `readOnly: true` | `color-surface-container` fill / `color-outline-variant` border; `SystemMouseCursors.basic` | `color-surface-container`, `color-outline-variant` |
| Disabled | `disabled: true` | Entire widget at `opacity-disabled` | `opacity-disabled` |

---

## Sizes

| Size | Control box | Touch target | Border width |
|---|---|---|---|
| Default | 20×20px | 44×44px | 2px |
| Custom (via `size` prop) | N×N px | max(N, 44)×max(N, 44)px | 2px |

---

## Tokens used

**Colors**
- `color-primary` — fill and border when checked/indeterminate
- `color-on-primary` — checkmark and dash color
- `color-outline` — border when unchecked (enabled)
- `color-outline-variant` — border in read-only unchecked
- `color-surface-container` — fill in read-only checked
- `color-danger` — border or fill in error state

**Spacing**
- (no explicit padding tokens — control is a fixed-size box)

**Radius**
- `radius-xs` — control box corner radius (2px)

**Motion**
- `motion-duration-fast` — checkmark draw-in animation (100ms)
- `motion-duration-standard` — fill color transition (200ms)
- `motion-curve-standard` — `ease-in-out` for fill transitions

**Opacity**
- `opacity-disabled` — full widget opacity when `disabled: true`
- `state-hover` — hover overlay opacity
- `state-focus` — focus overlay opacity
- `state-pressed` — pressed overlay opacity

---

## Behavior & interaction

### Mouse / touch
- Tapping anywhere within the 44×44px touch target activates the checkbox.
- `value == false` → taps set `value = true`.
- `value == true` → taps set `value = false`.
- `value == null` (indeterminate) → taps set `value = true`.
- Mouse pointer shows `SystemMouseCursors.click` when interactive; `SystemMouseCursors.basic` when read-only or disabled.

### Keyboard
- `Space` or `Enter` — toggles the checkbox when focused.
- `Tab` / `Shift+Tab` — moves focus to next/previous interactive element.

### Focus management
- Focus ring is a circular state-layer overlay drawn over the touch target area.
- Focus is not visible on disabled or read-only checkboxes.

### Animation
- The checkmark and dash are drawn with `CustomPainter` using a progress value animated from 0→1.
- Duration: `motion-duration-fast` (100ms), curve: `ease-out`.
- Checking in reverse (unchecking) runs the same animation reversed.
- When `MediaQuery.disableAnimations` is true, the tick appears/disappears instantly (`motion-duration-instant`).

---

## Accessibility

- **Semantics:** `Semantics(checked: value ?? false, enabled: !disabled && !readOnly, label: semanticLabel)`
- **Min touch target:** 44×44px via `ConstrainedBox` wrapping the visual control.
- **Contrast:** `color-primary` on `color-on-primary` (white) meets WCAG AA. `color-danger` border meets 3:1 against surface backgrounds.
- **Screen reader:** Announces "Checkbox, checked" / "Checkbox, unchecked" / "Checkbox, indeterminate" (via `checked` semantic). Label from `semanticLabel` is prepended.
- **Keyboard:** Fully keyboard-operable via `Focus` widget + Space/Enter activation.

---

## Content guidelines

- **Label:** Use sentence case. Keep to 1–2 words for standalone checkboxes; a short phrase in list contexts. Always pair the `semanticLabel` with a visible text label in the parent widget.
- **Error messages:** Displayed by the parent field/form component, not by the checkbox itself.

---

## Composition

**Uses:**
- No RDS component dependencies — primitive widget.

**Used by:**
- `RdsCheckboxWithLabel` (T2a) — pairs this control with a label, hint, and error message.
- `RdsListItem` (T2a) — optionally places a checkbox as the trailing or leading slot.

*Primitive — no RDS dependencies.*

---

## Flutter API

### Widget class
`RdsCheckbox`

### Constructor
```dart
const RdsCheckbox({
  super.key,
  required bool? value,
  ValueChanged<bool?>? onChanged,
  bool disabled = false,
  bool readOnly = false,
  bool error = false,
  double size = 20.0,
  String? semanticLabel,
});
```

### Example usage

```dart
// Standalone boolean
RdsCheckbox(
  value: _agreed,
  onChanged: (v) => setState(() => _agreed = v),
  semanticLabel: 'I agree to the terms of service',
)

// Indeterminate (parent of a partial list selection)
RdsCheckbox(
  value: null, // indeterminate
  onChanged: (v) => _selectAll(v ?? false),
  semanticLabel: 'Select all items',
)

// Error state
RdsCheckbox(
  value: false,
  error: true,
  onChanged: (v) => setState(() => _accepted = v),
  semanticLabel: 'Accept privacy policy',
)

// Read-only
RdsCheckbox(
  value: true,
  readOnly: true,
  semanticLabel: 'Feature enabled',
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | All knobs: value (checked/unchecked/indeterminate), disabled, readOnly, error |
| `Gallery` | All 9 states rendered in a Wrap grid: unchecked, checked, indeterminate, error variants, read-only, disabled |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `Value` | `list` | `value` | `checked`, `unchecked`, `indeterminate` |
| `Disabled` | `boolean` | `disabled` | — |
| `Read Only` | `boolean` | `readOnly` | — |
| `Error` | `boolean` | `error` | — |

---

## Do / Don't

| Do | Don't |
|---|---|
| Use checkboxes for independent, multi-selectable options. | Use a checkbox where only one item can be selected — use Radio. |
| Always provide a visible text label adjacent to the checkbox in the parent widget. | Rely solely on `semanticLabel` for visual identification. |
| Use the indeterminate state to represent a partially-selected parent group. | Set `value = null` for "no selection" — null means indeterminate (partial selection). |
| Use `readOnly` when a value is known but not editable in the current context. | Use `disabled` when the value is merely display-only — prefer `readOnly` to preserve visual clarity. |
