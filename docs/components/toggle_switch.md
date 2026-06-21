# Toggle Switch

> A pill-shaped binary switch that animates between on and off states. Represents an immediate, persistent setting change — unlike a checkbox, toggling takes effect instantly without requiring a form submission.

---

## When to use / when not to use

**Use when:**
- A setting or feature can be turned on or off and the change takes effect immediately.
- The user is adjusting a preference that has an active/inactive state (e.g. notifications enabled, dark mode, auto-save).
- The control represents a persistent, system-level state rather than a form field value.

**Do not use when:**
- The choice requires confirmation before applying — use a Checkbox inside a form with a Submit button.
- The user can select one of more than two states — use Radio buttons or a Segmented Control.
- The control represents selecting an item from a list — use Checkbox.
- The action is destructive or irreversible — use an explicit button + confirmation dialog.

---

## Anatomy

```
┌────────────────────────────┐
│  ┌──────────────────────┐  │
│  │  ○              (●)  │  │  ← track (44×24px pill)
│  └──────────────────────┘  │  ← thumb (18×18px circle) slides left/right
│                            │
└────────────────────────────┘
         ↑ 44×44 touch target
```

| Part | Description |
|---|---|
| 1. Track | Pill-shaped container (44×24px, `radius-full`). Color changes between `color-outline-variant` (off) and `color-primary` (on). |
| 2. Thumb | Circular handle (18×18px) that slides left (off) or right (on). Color: `color-on-surface-muted` (off) or `color-on-primary` (on). Drop shadow for depth. |
| 3. Touch target | `ConstrainedBox(minWidth: 44, minHeight: 44)` — ensures 44×44px minimum. |
| 4. State layer | Semi-transparent overlay on the track for hover/focus/press. |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| Off | `color-outline-variant` track, `color-on-surface-muted` thumb on left | Default / inactive state |
| On | `color-primary` track, `color-on-primary` thumb on right | Active / enabled state |
| Read-only | `color-surface-container` track, `color-outline-variant` thumb; no interaction | Display-only value, not editable |
| Disabled | All visual elements at `opacity-disabled`; no interaction | Setting unavailable in current context |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `value` | `bool` | required | `true` = on, `false` = off. |
| `onChanged` | `ValueChanged<bool>?` | `null` | Called when the user taps. If null, non-interactive. |
| `disabled` | `bool` | `false` | Applies `opacity-disabled` and blocks interaction. |
| `readOnly` | `bool` | `false` | Shows the state without allowing changes; uses muted track styling. |
| `semanticLabel` | `String?` | `null` | Accessibility label for screen readers. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Off | `value == false` | `color-outline-variant` track, `color-on-surface-muted` thumb left | `color-outline-variant`, `color-on-surface-muted` |
| On | `value == true` | `color-primary` track, `color-on-primary` thumb right | `color-primary`, `color-on-primary` |
| Hover | Mouse over touch target | Semi-transparent overlay on track | `state-hover` × `color-on-primary` or `color-on-surface` |
| Focus | Keyboard focus | Semi-transparent overlay on track | `state-focus` × `color-on-primary` or `color-on-surface` |
| Pressed | Tap held | Overlay at pressed opacity | `state-pressed` × appropriate on-color |
| Read-only | `readOnly: true` | `color-surface-container` track, `color-outline-variant` thumb; basic cursor | `color-surface-container`, `color-outline-variant` |
| Disabled | `disabled: true` | Full widget at `opacity-disabled` | `opacity-disabled` |

---

## Sizes

| Size | Track | Thumb | Touch target |
|---|---|---|---|
| Default (only) | 44×24px | 18×18px | 44×44px |

The toggle switch has a single fixed size. Scale via parent layout if needed.

---

## Tokens used

**Colors**
- `color-primary` — track background when on
- `color-on-primary` — thumb color when on
- `color-outline-variant` — track background when off; thumb color in read-only
- `color-on-surface-muted` — thumb color when off
- `color-surface-container` — track background when read-only

**Radius**
- `radius-full` — track and thumb circular/pill shapes (9999px)

**Motion**
- `motion-duration-standard` — thumb position slide + track color transition (200ms)
- `motion-curve-standard` — `ease-in-out` for all transitions

**Opacity**
- `opacity-disabled` — full widget when `disabled: true`
- `state-hover` — hover overlay
- `state-focus` — focus overlay
- `state-pressed` — pressed overlay

---

## Behavior & interaction

### Mouse / touch
- Tapping anywhere on the 44×44px touch target toggles the value.
- Pointer shows `SystemMouseCursors.click` when interactive; `SystemMouseCursors.basic` when read-only or disabled.

### Keyboard
- `Space` — toggles the switch when focused.
- `Tab` / `Shift+Tab` — moves focus.

### Focus management
- Focus ring appears as a state-layer overlay on the track.
- No focus ring on disabled or read-only switches.

### Animation
- Thumb position: `AnimatedPositioned` slides left↔right over `motion-duration-standard` (200ms) with `ease-in-out`.
- Track color: `AnimatedContainer` transitions between off and on colors over the same duration.
- Thumb color: `AnimatedContainer` transitions simultaneously.
- `MediaQuery.disableAnimations` collapses all durations to zero (`motion-duration-instant`).

---

## Accessibility

- **Semantics:** `Semantics(toggled: value, enabled: !disabled && !readOnly, label: semanticLabel)`.
- **Min touch target:** 44×44px via `ConstrainedBox`.
- **Contrast:** `color-on-primary` (white) on `color-primary` meets WCAG AA. `color-on-surface-muted` on `color-outline-variant` meets 3:1 for UI components.
- **Screen reader:** Announces "[label], switch, on/off" via `toggled` semantic.
- **Keyboard:** Fully keyboard-operable via `Focus` widget + Space key.

---

## Content guidelines

- **Label:** Always render a visible label adjacent to the toggle in the parent widget. Describe the feature being enabled/disabled, not the action (e.g. "Email notifications" not "Enable email").
- **State label:** Optionally show "On" / "Off" text beside the toggle in dense layouts.

---

## Composition

**Uses:**
- No RDS component dependencies — primitive widget.

**Used by:**
- `RdsListItem` (T2a) — toggle as a trailing action slot.
- `RdsToggleListInput` (T2b, planned) — list of toggle switches in a settings panel.

*Primitive — no RDS dependencies.*

---

## Flutter API

### Widget class
`RdsToggleSwitch`

### Constructor
```dart
const RdsToggleSwitch({
  super.key,
  required bool value,
  ValueChanged<bool>? onChanged,
  bool disabled = false,
  bool readOnly = false,
  String? semanticLabel,
});
```

### Example usage

```dart
// Basic toggle
RdsToggleSwitch(
  value: _notificationsEnabled,
  onChanged: (v) => setState(() => _notificationsEnabled = v),
  semanticLabel: 'Email notifications',
)

// Read-only (display only)
RdsToggleSwitch(
  value: true,
  readOnly: true,
  semanticLabel: 'Automatic updates',
)

// Disabled
RdsToggleSwitch(
  value: false,
  disabled: true,
  semanticLabel: 'Dark mode',
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | Knobs: On (bool), Disabled, Read Only. Interactive toggle in a centered container. |
| `Gallery` | Grid of 6 states: off, on, read-only off, read-only on, disabled off, disabled on. |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `On` | `boolean` | `value` | — |
| `Disabled` | `boolean` | `disabled` | — |
| `Read Only` | `boolean` | `readOnly` | — |

---

## Do / Don't

| Do | Don't |
|---|---|
| Use for settings that take immediate effect when toggled. | Use for form fields that require Submit to apply — use Checkbox. |
| Always label the setting clearly using an adjacent text widget. | Show the toggle without a visible label. |
| Use `readOnly` to show a system-managed setting the user cannot change. | Use `disabled` for display-only values — `readOnly` is more semantically correct. |
| Use a single toggle per discrete binary setting. | Use a toggle to represent one option from a multi-choice group — use Radio. |
