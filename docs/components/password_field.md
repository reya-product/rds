# Password Field

> A single-line text input that obscures entered text, with a visibility toggle so users can verify what they have typed.

---

## When to use / when not to use

**Use when:**
- Collecting a password, passphrase, or other sensitive credential.
- Any field whose content should be hidden from shoulder surfers by default.

**Do not use when:**
- Collecting any non-sensitive single-line text — use `RdsTextField` instead.
- Collecting multi-line content — use `RdsTextArea`.
- A search or filter input is needed — use `RdsSearchBar`.
- Displaying a PIN entry where an obscure keypad is more appropriate than a text field.

---

## Anatomy

```
┌──────────────────────────────────────────────────────┐
│ Password *                                            │
├──────────────────────────────────────────────────────┤  ← border
│  ••••••••••••••••••••••••        [eye icon button]   │
└──────────────────────────────────────────────────────┘
│ Minimum 8 characters.                                 │
```

| Part | Description |
|---|---|
| 1. Label | Required. Floats above on focus/fill. Supports mandatory (`*`) and optional suffixes. |
| 2. Obscured text | The password value shown as bullet characters (•). |
| 3. Visibility toggle | Eye icon button at the trailing edge. Toggles between obscured and revealed text. |
| 4. Border | Outline border reflecting the current state. |
| 5. Support text | Optional instruction text (e.g. character requirements). |
| 6. Error text | Shown when validation fails (e.g. "Password must be at least 8 characters."). |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| Default (obscured) | Text shown as bullet dots; eye icon at trailing | Password entry (login, account creation) |
| Revealed | Text visible; eye-off icon at trailing | After user taps the eye icon to verify their input |

The revealed/obscured toggle is managed internally by the component — it is not a separate constructor variant.

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | — (required) | The field label. |
| `placeholder` | `String?` | `null` | Hint text shown when empty. |
| `leadingIcon` | `IconData?` | `null` | Optional icon at the leading edge. |
| `supportText` | `String?` | `null` | Descriptive text below the field. |
| `errorText` | `String?` | `null` | Error message. Setting this triggers the error state. |
| `mandatory` | `bool` | `false` | Appends `*` to the label. |
| `optional` | `bool` | `false` | Appends `(optional)` to the label. |
| `disabled` | `bool` | `false` | Disables all interaction; applies `opacity-disabled`. |
| `readOnly` | `bool` | `false` | Shows value but prevents editing; `surfaceContainer` fill. |
| `controller` | `TextEditingController?` | `null` | External text controller. |
| `focusNode` | `FocusNode?` | `null` | External focus node. |
| `onChanged` | `ValueChanged<String>?` | `null` | Called on every text change. |
| `onSubmitted` | `ValueChanged<String>?` | `null` | Called when the user presses Enter/Done. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled | Default | `outline` border (1px), `surface` fill; text obscured | `color-outline`, `color-surface` |
| Hover | Pointer enters field | Border state layer at `state-hover` opacity | `state-hover` |
| Focused | Field receives keyboard focus | `primary` border (2px); label floats | `color-primary` |
| Revealed | User taps eye icon | Text becomes visible; eye-off icon shown | — (internal state) |
| Error | `errorText` is non-null | `danger` border (2px); error text in `color-danger` | `color-danger` |
| Focused error | Error + focused | `danger` border (2px) | `color-danger` |
| Disabled | `disabled: true` | `surfaceContainer` fill; `opacity-disabled` on full field; eye icon dimmed | `color-surface-container`, `opacity-disabled` |
| Read only | `readOnly: true` | `surfaceContainer` fill; no focus ring | `color-surface-container` |

---

## Tokens used

**Colors**
- `color-surface` — fill for enabled/focused states
- `color-surface-container` — fill for readOnly and disabled states
- `color-on-surface` — input text (bullet dots and revealed text)
- `color-on-surface-variant` — label, eye icon, and support text color
- `color-on-surface-muted` — placeholder text color
- `color-primary` — focused border and floating label color
- `color-outline` — enabled border color
- `color-outline-variant` — disabled border color
- `color-danger` — error border and error text color

**Typography**
- `body-large` — input text (obscured bullets or revealed characters)
- `body-medium` — label (resting position)
- `body-small` — floating label, support text, error text

**Spacing**
- `space-3` — eye icon button padding (12px)
- `space-4` — horizontal content padding (16px)

**Radius**
- `radius-md` — field border radius (8px)

**Iconography**
- `RdsIcons.eye` (`Symbols.visibility`) — obscured state trailing icon
- `RdsIcons.eyeOff` (`Symbols.visibility_off`) — revealed state trailing icon
- `icon-md` (20px) — icon size

**Motion**
- `motion-duration-standard` — label float animation
- `motion-curve-standard` — easing

**Opacity**
- `opacity-disabled` — full field when disabled (0.38)

---

## Behavior & interaction

### Mouse / touch
- Tapping the field focuses it.
- Tapping the eye icon toggles obscured/revealed text without losing focus — focus is explicitly restored to the field via `FocusNode.requestFocus()` after the toggle.
- When `disabled: true` the eye icon tap has no effect.

### Keyboard
- `Tab` / `Shift+Tab` moves focus.
- `Enter` fires `onSubmitted`.
- The eye icon button is reachable via Tab and activatable with Space/Enter (handled by `GestureDetector` wrapping a `Semantics(button: true)` node).

### Focus management
- Toggling visibility restores focus to the text input so the user can continue typing without re-tapping the field.
- The eye icon button itself does not retain focus after activation.

### Animation
- No special animation for the obscure toggle beyond the icon swap.
- Label float follows `motion-duration-standard` / `motion-curve-standard`.

---

## Accessibility

- **Semantics (field):** `Semantics(textField: true, obscured: _obscureText, label: <effectiveLabel>)`. The `obscured` flag signals to screen readers that the field contains sensitive data.
- **Semantics (toggle button):** `Semantics(label: 'Show password' | 'Hide password', button: true)` — the label updates dynamically with the current state. A `Tooltip` provides the same string on hover.
- **Min touch target:** Eye icon button uses `Padding(all: space-3)` around the 20px icon, giving a ~44px touch target.
- **Contrast:** `color-on-surface-variant` (eye icon) on `color-surface` passes WCAG AA 3:1 for UI components.
- **Screen reader:** VoiceOver/TalkBack announces "Password field, secure text entry" on focus. The toggle button announces "Show password, button" / "Hide password, button".
- **Keyboard:** Fully keyboard navigable. Eye icon is in the Tab order after the text field.

---

## Content guidelines

- **Label:** Use `Password`, `New password`, `Confirm password`, or similar. Sentence case, no colon.
- **Placeholder:** Use `Enter your password` or leave blank. Do not reveal password format requirements as placeholder — use `supportText` instead.
- **Support text:** Describe requirements proactively (e.g. `Minimum 8 characters, at least one number.`).
- **Error messages:** Specific and actionable (e.g. `Password must be at least 8 characters.` / `Passwords do not match.`).

---

## Composition

**Uses:**
- Primitive — no other RDS components internally. Relies on Flutter's `TextField` with `obscureText`.
- `RdsIcons.eye` / `RdsIcons.eyeOff` for the visibility toggle icon.

**Used by:**
- Login screens, account creation flows, password change dialogs.

---

## Flutter API

### Widget class
`RdsPasswordField`

### Constructor
```dart
const RdsPasswordField({
  super.key,
  required String label,
  String? placeholder,
  IconData? leadingIcon,
  String? supportText,
  String? errorText,
  bool mandatory = false,
  bool optional = false,
  bool disabled = false,
  bool readOnly = false,
  TextEditingController? controller,
  FocusNode? focusNode,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onSubmitted,
});
```

### Example usage

```dart
// Login password
RdsPasswordField(
  label: 'Password',
  placeholder: 'Enter your password',
  mandatory: true,
  supportText: 'Minimum 8 characters.',
  onChanged: (v) => setState(() => _password = v),
  onSubmitted: (_) => _handleLogin(),
)

// Password with error
RdsPasswordField(
  label: 'New password',
  errorText: _passwordError,
  controller: _passwordController,
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | Interactive knobs for all props. Toggle the eye icon by interacting with the component. |
| `States gallery` | Static display of: enabled empty, enabled filled (obscured), mandatory, error, disabled, read-only. |

### Knobs

| Knob | Type | Maps to prop | Options / Notes |
|---|---|---|---|
| `Label` | `string` | `label` | Default: `'Password'` |
| `Placeholder` | `string` | `placeholder` | Empty string maps to `null` |
| `Support text` | `string` | `supportText` | Empty string maps to `null` |
| `Error text` | `string` | `errorText` | Empty string maps to `null` |
| `Disabled` | `boolean` | `disabled` | Default: `false` |
| `Read only` | `boolean` | `readOnly` | Default: `false` |
| `Mandatory` | `boolean` | `mandatory` | Default: `false` |

---

## Do / Don't

| Do | Don't |
|---|---|
| Always use `RdsPasswordField` for password inputs — never `RdsTextField` with obscure workarounds. | Don't expose the password value in a support text or error message. |
| Use `supportText` to communicate requirements before submission (proactive guidance). | Don't make the visibility toggle disabled when the field is not disabled — users need to verify what they typed. |
| Ensure `onSubmitted` triggers form submission so the user can submit without lifting their hands from the keyboard. | Don't hide the label — passwords still need a label for users who do not understand `•••` by context alone. |
