# Checkbox-with-Label Input

> A tappable row that composes `RdsCheckbox` with a primary label, optional support text, an optional inline link, and an optional error message — used wherever a user must acknowledge or opt into something.

---

## When to use / when not to use

**Use when:**
- The user must make a binary (or tri-state) acknowledgement — "I agree to terms", newsletter opt-in, feature toggle with explanatory copy.
- A label is required to give the checkbox meaning (almost all real-world cases).
- You need a description or a "View terms" link alongside the control.

**Do not use when:**
- The label and checkbox are fully independent (use a bare `RdsCheckbox` instead).
- You need a group of mutually exclusive options — use `RdsRadio` + label rows instead.
- The option is an immediate action that takes effect without a form submit — consider `RdsToggleSwitch` with label.

---

## Anatomy

```
┌──────────────────────────────────────────────────┐
│ [1]  [2] Label text                              │
│      [3] Support / description text              │
│      [4] Link text →                             │
└──────────────────────────────────────────────────┘
[5] Error message text
```

| Part | Description |
|---|---|
| 1. Checkbox | `RdsCheckbox` control — shows checked / unchecked / indeterminate / error state |
| 2. Label | Primary text; tapping it (or anywhere on the row) toggles the checkbox |
| 3. Support text | Optional secondary description below the label (`bodySmall`, `onSurfaceVariant`) |
| 4. Link text | Optional inline link below support text; tapping it fires `onLinkTap` independently of the checkbox toggle |
| 5. Error text | Shown when `errorText` is non-empty; indented to align past the checkbox |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| Simple | Checkbox + single-line label | Quick options where the label alone is self-explanatory |
| Rich | Checkbox + label + support text ± link | When the option needs a description or a "learn more" / "view terms" link |
| Error | Any variant with `errorText` set; checkbox border turns danger-red, error text appears below | Form validation — highlight which checkbox must be checked |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | required | Primary label text; tapping it toggles the checkbox |
| `value` | `bool?` | required | `true` = checked, `false` = unchecked, `null` = indeterminate |
| `onChanged` | `ValueChanged<bool?>?` | `null` | Callback on toggle; `null` makes the component non-interactive |
| `supportText` | `String?` | `null` | Secondary description text rendered below `label` |
| `linkText` | `String?` | `null` | Inline link label — only shown when `onLinkTap` is also non-null |
| `onLinkTap` | `VoidCallback?` | `null` | Called when the link is tapped; link hidden if this is null |
| `errorText` | `String?` | `null` | Error message; also sets `error: true` on the inner checkbox |
| `disabled` | `bool` | `false` | Disables all interaction; applies `opacity-disabled` to label text |
| `readOnly` | `bool` | `false` | Renders as read-only (no interaction; muted `onSurfaceVariant` label color) |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled | Default | Normal label color, checkbox in its default state | `color-on-surface` for label |
| Error | `errorText` is non-empty | Danger-color checkbox border/fill; danger-color error text below | `color-danger` |
| Disabled | `disabled: true` | Label and support text at 38% opacity; checkbox disabled | `opacity-disabled` |
| Read-only | `readOnly: true` | Label uses `onSurfaceVariant`; checkbox read-only style; no interaction | `color-on-surface-variant` |

The inner `RdsCheckbox` inherits its own hover / focus / pressed state layers from its own implementation.

---

## Tokens used

**Colors**
- `color-on-surface` — label text in enabled state
- `color-on-surface-variant` — support text; label text in read-only state
- `color-on-surface-muted` — support text in read-only state
- `color-primary` — link text color; underline decoration
- `color-danger` — error text and checkbox error state

**Typography**
- `body-medium` — primary label text
- `body-small` — support text, link text, error text

**Spacing**
- `space-1` — gap between label and support text; gap between support text and link; gap between row and error text
- `space-3` — gap between the checkbox and the label column

**Opacity**
- `opacity-disabled` — applied to label and support text when `disabled: true`

---

## Behavior & interaction

### Mouse / touch
- Tapping anywhere on the row (checkbox or label) toggles the checkbox via `_handleTap`, unless `disabled` or `readOnly` is true or `onChanged` is null.
- Tapping the link text calls `onLinkTap` without toggling the checkbox. The link tap is handled by its own `GestureDetector` child; propagation to the parent row tap is prevented by Flutter's normal hit-test order (the inner `GestureDetector` consumes the tap first).
- The entire row uses `HitTestBehavior.translucent` so that the gap between the checkbox and the label is also tappable.

### Keyboard
- The inner `RdsCheckbox` handles its own keyboard focus and `Space` to toggle.
- `Tab` moves focus to the checkbox; `Space` toggles. There is no separate focus on the label text.

### Focus management
- Focus is owned by the inner `RdsCheckbox`. No additional focus handling is added at the row level.

### Animation
- Checkbox tick / untick animation is delegated entirely to `RdsCheckbox` (`motion-duration-fast`, `ease-out`).
- There is no additional animation at the `RdsCheckboxInput` level.

---

## Accessibility

- **Semantics:** `MergeSemantics` + `Semantics(checked: value ?? false, label: label, enabled: !disabled)` wraps the whole widget so screen readers announce the label and checked state as a single unit.
- **Min touch target:** The row has `ConstrainedBox(constraints: BoxConstraints(minHeight: 44))`. The inner `RdsCheckbox` already enforces 44×44px for its own touch area.
- **Contrast:** `color-on-surface` (#111827) on `color-surface` (#FFFFFF) — contrast ratio ~19:1 (WCAG AAA). `color-danger` (#DC2626) on white — ~5.1:1 (WCAG AA). `color-primary` (#2A9090) on white — ~4.6:1 (WCAG AA).
- **Screen reader:** Announces "[label], checkbox, [checked/unchecked/mixed], [enabled/disabled]". The link text is a separate focusable element.
- **Keyboard:** Fully operable via keyboard through the inner `RdsCheckbox` focus handling.

---

## Content guidelines

- **Label:** Sentence case. Keep to one line when possible (≤ 60 characters). For legal text ("I agree to the terms of service") use the `linkText` + `onLinkTap` pattern rather than embedding a URL in the label string.
- **Support text:** One to two sentences maximum. Explain the consequence of the choice, not the mechanics. End with a full stop.
- **Link text:** Short verb phrase — "View terms", "Learn more", "See sample". Do not use the URL as the link text.
- **Error messages:** Complete sentence, sentence case, full stop. Actionable: "You must accept the terms to continue." not "Required."

---

## Composition

**Uses:**
- `RdsCheckbox` — the actual toggle control; receives `error`, `disabled`, `readOnly`, and the `onChanged` callback from this widget.

**Used by:**
- Form screens requiring legal consent flows (terms acceptance, privacy opt-in).
- Settings panels with feature-level toggles that need description copy.

---

## Flutter API

### Widget class
`RdsCheckboxInput`

### Constructor
```dart
const RdsCheckboxInput({
  super.key,
  required String label,
  required bool? value,
  ValueChanged<bool?>? onChanged,
  String? supportText,
  String? linkText,
  VoidCallback? onLinkTap,
  String? errorText,
  bool disabled = false,
  bool readOnly = false,
});
```

### Public enums

None — this component has no enum parameters.

### Example usage

```dart
// Simple — unchecked, toggleable
RdsCheckboxInput(
  label: 'I agree to the terms of service',
  value: _agreed,
  onChanged: (v) => setState(() => _agreed = v),
)

// Rich — with support text and link
RdsCheckboxInput(
  label: 'Receive weekly updates',
  supportText: 'We send one email per week. Unsubscribe at any time.',
  linkText: 'View sample email',
  onLinkTap: () => launchUrl(Uri.parse('https://example.com/sample')),
  value: _subscribed,
  onChanged: (v) => setState(() => _subscribed = v),
)

// Error — requires acknowledgement
RdsCheckboxInput(
  label: 'I agree to the terms of service',
  value: false,
  errorText: 'You must accept the terms to continue.',
  onChanged: (v) => setState(() => _agreed = v),
)

// Disabled
RdsCheckboxInput(
  label: 'Feature not available on your plan',
  value: false,
  disabled: true,
  onChanged: null,
)

// Read-only
RdsCheckboxInput(
  label: 'Terms accepted on 2024-01-15',
  value: true,
  readOnly: true,
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | All knobs exposed; `StatefulBuilder` so the checkbox actually toggles |
| `Gallery` | Fixed grid showing: simple, rich (with support text + link), error state, disabled, read-only |

### Knobs

| Knob | Type | Maps to prop | Options / default |
|---|---|---|---|
| `Label` | string | `label` | `"I agree to the terms of service"` |
| `Support text` | string | `supportText` | `""` (empty = no support text) |
| `Link text` | string | `linkText` | `""` (empty = no link) |
| `Error text` | string | `errorText` | `""` (empty = no error) |
| `Disabled` | boolean | `disabled` | `false` |
| `Read only` | boolean | `readOnly` | `false` |
| `Value` | boolean | `value` | `false` |

---

## Do / Don't

| Do | Don't |
|---|---|
| Keep the label concise and self-explanatory so users can decide without reading the support text | Write a paragraph-length label — move detail into `supportText` |
| Use `linkText` + `onLinkTap` to surface legal documents inline | Embed raw URLs or HTML in the label string |
| Show `errorText` after the user attempts to submit a form without checking a required box | Show the error before the user has had a chance to interact |
| Use `disabled` for options unavailable on the user's plan; use `readOnly` for confirmed choices they can see but not edit | Use `readOnly` when the intent is to prevent an action — `disabled` is the correct choice |
