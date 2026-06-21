# Radio

> A single-selection control that allows the user to choose exactly one option from a mutually exclusive group. Pairs with sibling Radio widgets sharing the same `groupValue`.

---

## When to use / when not to use

**Use when:**
- The user must select exactly one option from 2–5 choices that are all visible at once.
- The options are mutually exclusive and all choices should be visible (not hidden in a dropdown).
- The choice significantly affects downstream form behavior and needs visual prominence.

**Do not use when:**
- Multiple items can be selected — use `RdsCheckbox` instead.
- There are more than ~5 options and space is constrained — use a single-select dropdown instead.
- The choice is binary (on/off) — consider `RdsToggleSwitch` or a single `RdsCheckbox`.
- Options are selected from a long list — use `RdsSingleSelectInput` (T2b) instead.

---

## Anatomy

```
┌──────────────────┐
│  ○  ●  ○         │  ← group of radio buttons; only one is filled
│                  │
│  (A) (B) (C)     │
└──────────────────┘
     ↑
     20×20 control: outer ring (2px) + inner dot (animated)
```

| Part | Description |
|---|---|
| 1. Outer ring | 20×20px circle, 2px stroke. Color: `color-outline` (unselected) or `color-primary` (selected). |
| 2. Inner dot | Filled circle inside the ring, animates from 0→full size on selection. Color: `color-primary`. |
| 3. Touch target | 44×44px area via `ConstrainedBox`. |
| 4. State layer | Circular overlay centered on the touch target for hover/focus/press. |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| Unselected | `color-outline` ring, transparent interior | Default state |
| Selected | `color-primary` ring + animated `color-primary` inner dot | Currently chosen option |
| Error | `color-danger` ring | Validation failure on this option or group |
| Read-only | `color-outline-variant` ring and dot; no cursor change | Display-only value |
| Disabled | Full widget at `opacity-disabled` | Option not currently available |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `value` | `T` | required | The value this radio represents. |
| `groupValue` | `T?` | required | The currently selected value in the group. Radio appears selected when `value == groupValue`. |
| `onChanged` | `ValueChanged<T?>?` | `null` | Called when the user taps this radio. If null, non-interactive. |
| `disabled` | `bool` | `false` | Applies `opacity-disabled` and blocks interaction. |
| `readOnly` | `bool` | `false` | Shows the state without allowing changes. |
| `error` | `bool` | `false` | Applies `color-danger` ring. |
| `size` | `double` | `20.0` | Diameter of the visible control in logical pixels. |
| `semanticLabel` | `String?` | `null` | Accessibility label for screen readers. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled unselected | Default | `color-outline` ring, empty interior | `color-outline` |
| Enabled selected | `value == groupValue` | `color-primary` ring + filled inner dot | `color-primary` |
| Hover | Mouse over touch target | Circular semi-transparent overlay | `state-hover` × `color-primary` or `color-on-surface` |
| Focus | Keyboard focus | Circular semi-transparent overlay | `state-focus` × `color-primary` or `color-on-surface` |
| Pressed | Tap held | Circular overlay at pressed opacity | `state-pressed` × `color-primary` or `color-on-surface` |
| Error | `error: true` | `color-danger` ring | `color-danger` |
| Read-only | `readOnly: true` | `color-outline-variant` ring + dot; basic cursor | `color-outline-variant` |
| Disabled | `disabled: true` | Full widget at `opacity-disabled` | `opacity-disabled` |

---

## Sizes

| Size | Control diameter | Touch target |
|---|---|---|
| Default | 20px | 44×44px |
| Custom (via `size`) | N px | max(N, 44)×max(N, 44)px |

---

## Tokens used

**Colors**
- `color-primary` — selected ring and inner dot
- `color-outline` — unselected ring (enabled)
- `color-outline-variant` — ring and dot in read-only state
- `color-danger` — ring in error state

**Radius**
- `radius-full` — circular shape (9999px)

**Motion**
- `motion-duration-fast` — inner dot scale animation (100ms)
- `motion-curve-standard` — `ease-out` curve for dot animation

**Opacity**
- `opacity-disabled` — full widget opacity when disabled
- `state-hover` — hover overlay
- `state-focus` — focus overlay
- `state-pressed` — pressed overlay

---

## Behavior & interaction

### Mouse / touch
- Tapping a radio selects it and calls `onChanged(value)`.
- Tapping an already-selected radio has no effect.
- Pointer shows `SystemMouseCursors.click` when interactive; `SystemMouseCursors.basic` otherwise.

### Keyboard
- `Space` — selects the focused radio (if not already selected).
- `Tab` / `Shift+Tab` — moves focus between interactive elements.
- Arrow keys within a group should be handled by the parent group widget (not by `RdsRadio` itself).

### Focus management
- Focus ring is a circular state-layer overlay on the 44px touch target.
- Focus is not shown on disabled or read-only radios.

### Animation
- The inner dot animates from scale 0 to full size using `CustomPainter` + `AnimationController`.
- Duration: `motion-duration-fast` (100ms), curve: `ease-out`.
- Deselection reverses the animation.
- `MediaQuery.disableAnimations` collapses duration to zero.

---

## Accessibility

- **Semantics:** `Semantics(inMutuallyExclusiveGroup: true, checked: value == groupValue, enabled: ..., label: semanticLabel)`.
- **Min touch target:** 44×44px via `ConstrainedBox`.
- **Contrast:** `color-primary` ring passes WCAG AA 3:1 against white and `color-surface-container`. `color-danger` ring passes 3:1.
- **Screen reader:** Announces "Radio button, [label], selected/not selected, in group".
- **Keyboard:** Fully keyboard-operable. Arrow-key group navigation should be wired by the parent `RadioGroup` (T2a).

---

## Content guidelines

- **Label:** Always render a visible label adjacent to the radio in the parent widget. Use sentence case. Keep labels short (1–4 words).
- **Group label:** The group itself should have a visible heading (e.g. a `Text` widget above the group) so the choices are understood in context.

---

## Composition

**Uses:**
- No RDS component dependencies — primitive widget.

**Used by:**
- `RdsListItem` (T2a) — radio as a leading slot in a selectable list.
- `RdsRadioGroupInput` (T2a, planned) — wraps multiple radios with a shared label and error message.

*Primitive — no RDS dependencies.*

---

## Flutter API

### Widget class
`RdsRadio<T>`

### Constructor
```dart
const RdsRadio<T>({
  super.key,
  required T value,
  required T? groupValue,
  ValueChanged<T?>? onChanged,
  bool disabled = false,
  bool readOnly = false,
  bool error = false,
  double size = 20.0,
  String? semanticLabel,
});
```

### Example usage

```dart
// Basic radio group
Column(
  children: [
    RdsRadio<String>(
      value: 'male',
      groupValue: _sex,
      onChanged: (v) => setState(() => _sex = v),
      semanticLabel: 'Male',
    ),
    RdsRadio<String>(
      value: 'female',
      groupValue: _sex,
      onChanged: (v) => setState(() => _sex = v),
      semanticLabel: 'Female',
    ),
    RdsRadio<String>(
      value: 'other',
      groupValue: _sex,
      onChanged: (v) => setState(() => _sex = v),
      semanticLabel: 'Prefer not to say',
    ),
  ],
)

// Error state
RdsRadio<String>(
  value: 'optionA',
  groupValue: _selected,
  error: true,
  onChanged: (v) => setState(() => _selected = v),
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | Knobs: selected (bool), disabled, readOnly, error. Shows a single radio. |
| `Gallery` | Grid of 8 states: unselected, selected, error (both), read-only (both), disabled (both) |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `Selected` | `boolean` | `groupValue == value` | — |
| `Disabled` | `boolean` | `disabled` | — |
| `Read Only` | `boolean` | `readOnly` | — |
| `Error` | `boolean` | `error` | — |

---

## Do / Don't

| Do | Don't |
|---|---|
| Use radio buttons when all options are visible and only one may be chosen. | Use radios for multi-select — use checkboxes. |
| Keep the group to 5 or fewer options. | Present more than 5 options as radios — use a dropdown. |
| Add a visible group label above the radio group. | Rely only on individual radio labels without a group context. |
| Pre-select a sensible default when one exists. | Leave all radios unselected if a valid default value exists. |
