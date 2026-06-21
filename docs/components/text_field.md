# Text Field

> A single-line text input for collecting short-form data from the user. The primary form input in RDS.

---

## When to use / when not to use

**Use when:**
- Collecting a single line of text, such as a name, email address, or numeric value.
- The expected input is short enough to fit on one line.
- A specific input type constraint is needed (free text, integer, float, signed number).
- A leading or trailing icon is required to convey field purpose or trigger an action.

**Do not use when:**
- The user needs to enter more than one or two sentences — use `RdsTextArea` instead.
- The input is a password — use `RdsPasswordField` instead (handles obscure text + visibility toggle).
- The user needs to search or filter a list — use `RdsSearchBar` instead (pill shape, no label, inline clear).
- Selecting from a predefined list — use a dropdown or select input from T2b instead.

---

## Anatomy

```
┌─────────────────────────────────────────────────────┐
│ Label *                                              │
├──[leading icon]──────────────────────[trailing]──│  ← border (1px outline, 8px radius)
│  Placeholder text                                    │
└─────────────────────────────────────────────────────┘
│ Support text / Error message                         │
```

| Part | Description |
|---|---|
| 1. Label | Required. Floats above the input area on focus or when filled. Shows `*` (mandatory) or `(optional)` suffix. |
| 2. Leading icon | Optional. Conveys the field's purpose (e.g. person icon for a name field). |
| 3. Input area | The editable text region. Height is part of a 56px total field. |
| 4. Trailing icon | Optional. Used for action affordances (e.g. calendar picker trigger). Tappable via `onTrailingIconTap`. |
| 5. Border | Outline border reflecting the current state (color and width change per state). |
| 6. Support text | Optional descriptive text beneath the field. Hidden when `errorText` is set. |
| 7. Error text | Replaces support text in error state. Shown in `color-danger`. |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| Default (characters) | Free text, no input constraints | Names, emails, general text |
| Integer | Digits only keyboard; only `0–9` accepted | Age, quantity, ID numbers |
| Float | Decimal number keyboard; accepts `0–9` and `.` | Lab values, measurements |
| Number | Decimal keyboard with sign; accepts `-`, `0–9`, `.` | Temperatures, deltas, values that can be negative |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | — (required) | The field label. |
| `placeholder` | `String?` | `null` | Hint text shown when empty. |
| `leadingIcon` | `IconData?` | `null` | Icon at the left edge of the input. |
| `trailingIcon` | `IconData?` | `null` | Icon at the right edge of the input. |
| `onTrailingIconTap` | `VoidCallback?` | `null` | Callback when the trailing icon is tapped. |
| `supportText` | `String?` | `null` | Descriptive text below the field. |
| `errorText` | `String?` | `null` | Error message. Setting this triggers the error state. |
| `mandatory` | `bool` | `false` | Appends `*` to the label. |
| `optional` | `bool` | `false` | Appends `(optional)` to the label. |
| `disabled` | `bool` | `false` | Disables all interaction; applies `opacity-disabled`. |
| `readOnly` | `bool` | `false` | Shows value but prevents editing; `surfaceContainer` fill. |
| `controller` | `TextEditingController?` | `null` | External text controller. |
| `focusNode` | `FocusNode?` | `null` | External focus node. |
| `inputType` | `RdsTextFieldInputType` | `.characters` | Controls keyboard type and input formatters. |
| `maxLength` | `int?` | `null` | Maximum character count; shows counter when set. |
| `onChanged` | `ValueChanged<String>?` | `null` | Called on every text change. |
| `onSubmitted` | `ValueChanged<String>?` | `null` | Called when the user presses Enter/Done. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled | Default | `outline` border (1px), `surface` fill | `color-outline`, `color-surface` |
| Hover | Pointer enters field | Border color shifts to `onSurface` at 8% state layer | `state-hover` |
| Focused | Field receives keyboard focus | `primary` border (2px); label color becomes `color-primary` | `color-primary` |
| Filled | Field has a value, not focused | `outline` border (1px); label floats above | `color-outline` |
| Error | `errorText` is non-null | `danger` border (2px); label + error text in `color-danger` | `color-danger` |
| Focused error | Error + focused | `danger` border (2px) | `color-danger` |
| Disabled | `disabled: true` | `surfaceContainer` fill; full field at `opacity-disabled` (0.38) | `color-surface-container`, `opacity-disabled` |
| Read only | `readOnly: true` | `surfaceContainer` fill; no focus ring; cursor becomes text cursor | `color-surface-container` |

---

## Sizes

| Size | Height | H-padding | Font style | Icon size |
|---|---|---|---|---|
| Default (single line) | 56px total (input area ~24px) | `space-4` (16px) | `body-large` for input, `body-medium` for label | `icon-md` (20px) |

---

## Tokens used

**Colors**
- `color-surface` — fill for enabled/focused states
- `color-surface-container` — fill for readOnly and disabled states
- `color-on-surface` — input text color
- `color-on-surface-variant` — label, icon, and support text color
- `color-on-surface-muted` — placeholder text color
- `color-primary` — focused border and floating label color
- `color-outline` — enabled border color
- `color-outline-variant` — disabled border color
- `color-danger` — error border, error text, and focused-error label color

**Typography**
- `body-large` — input text
- `body-medium` — label (resting position)
- `body-small` — floating label, support text, error text, character counter

**Spacing**
- `space-3` — vertical content padding (12px)
- `space-4` — horizontal content padding (16px)

**Radius**
- `radius-md` — field border radius (8px)

**Motion**
- `motion-duration-standard` — label float animation (200ms)
- `motion-curve-standard` — label float easing

**Opacity**
- `opacity-disabled` — applied to the entire field when `disabled: true` (0.38)

---

## Behavior & interaction

### Mouse / touch
- Tapping anywhere in the field area focuses the input.
- Tapping the trailing icon fires `onTrailingIconTap` (if set).
- The cursor becomes `text` on hover over the input area.

### Keyboard
- `Tab` / `Shift+Tab` moves focus in/out of the field.
- `Enter` fires `onSubmitted` (if set).
- `inputType: integer` blocks non-digit key presses at the formatter level.
- `inputType: float` allows one decimal point only.
- `inputType: number` allows a leading minus sign in addition to float rules.

### Focus management
- On focus the label animates (floats) to the top edge of the border.
- On blur with an empty value the label returns to the resting position.
- On blur with a value the label stays floated.

### Animation
- Label float: `motion-duration-standard` (200ms), `motion-curve-standard`.
- Border color/width change: Flutter's `InputDecoration` animates automatically.

---

## Accessibility

- **Semantics:** `Semantics(textField: true, label: <effectiveLabel>)` wrapping the `TextField`. The `effectiveLabel` includes the mandatory asterisk or "(optional)" suffix so screen readers announce it.
- **Min touch target:** The field fills its container width; vertical touch target is ≥ 44px due to the 56px field height.
- **Contrast:** `color-on-surface` on `color-surface` exceeds 7:1 in light and dark themes. Error color `color-danger` against `color-surface` exceeds 4.5:1.
- **Screen reader:** The label text is announced on focus. Error text is included in `InputDecoration.errorText` which Flutter's accessibility tree exposes automatically.
- **Keyboard:** Fully operable with Tab/Shift+Tab and the on-screen keyboard.

---

## Content guidelines

- **Label:** Sentence case. Keep to 1–3 words. Do not use a colon at the end. Truncate with ellipsis if the container is too narrow.
- **Placeholder:** Use concise examples (e.g. `you@example.com`, `DD/MM/YYYY`). Do not restate the label as placeholder.
- **Support text:** Explain constraints or format expectations in a single sentence (e.g. "We'll never share your email.").
- **Error messages:** Specific and actionable. Start with the problem (e.g. "Enter a valid email address." not "Error: invalid."). Avoid technical jargon.
- **Mandatory marker:** Use the `mandatory` prop rather than writing `*` in the label string.

---

## Composition

**Uses:**
- Primitive — no other RDS components internally. Relies on Flutter's `TextField` and `InputDecoration`.

**Used by:**
- `RdsFieldGroup` (T2a) — wraps multiple fields in a labeled section.
- Various T3 forms and modals.

---

## Flutter API

### Widget class
`RdsTextField`

### Constructor
```dart
const RdsTextField({
  super.key,
  required String label,
  String? placeholder,
  IconData? leadingIcon,
  IconData? trailingIcon,
  VoidCallback? onTrailingIconTap,
  String? supportText,
  String? errorText,
  bool mandatory = false,
  bool optional = false,
  bool disabled = false,
  bool readOnly = false,
  TextEditingController? controller,
  FocusNode? focusNode,
  RdsTextFieldInputType inputType = RdsTextFieldInputType.characters,
  int? maxLength,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onSubmitted,
});
```

### Public enums

```dart
enum RdsTextFieldInputType {
  /// Free text, no restrictions.
  characters,

  /// Digits only. Uses FilteringTextInputFormatter.digitsOnly.
  integer,

  /// Decimal numbers. Accepts digits and one decimal point.
  float,

  /// Signed decimal. Accepts a leading minus sign, digits, and one decimal point.
  number,
}
```

### Example usage

```dart
// Basic email field
RdsTextField(
  label: 'Email address',
  placeholder: 'you@example.com',
  mandatory: true,
  leadingIcon: RdsIcons.user,
  supportText: "We'll never share your email.",
  onChanged: (v) => setState(() => _email = v),
)

// Integer field with error
RdsTextField(
  label: 'Age',
  inputType: RdsTextFieldInputType.integer,
  errorText: _ageError,
  controller: _ageController,
)

// Read-only field
RdsTextField(
  label: 'Patient ID',
  controller: TextEditingController(text: 'PAT-00123'),
  readOnly: true,
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | Interactive knobs for all props. Test any combination of state and configuration. |
| `States gallery` | Static display of all visual states: enabled empty, enabled filled, focused (simulated), error, disabled, read-only, mandatory, with icon, integer input type. |

### Knobs

| Knob | Type | Maps to prop | Options / Notes |
|---|---|---|---|
| `Label` | `string` | `label` | Default: `'Email address'` |
| `Placeholder` | `string` | `placeholder` | Empty string maps to `null` |
| `Support text` | `string` | `supportText` | Empty string maps to `null` |
| `Error text` | `string` | `errorText` | Empty string maps to `null` (no error) |
| `Disabled` | `boolean` | `disabled` | Default: `false` |
| `Read only` | `boolean` | `readOnly` | Default: `false` |
| `Mandatory` | `boolean` | `mandatory` | Default: `false` |
| `Optional` | `boolean` | `optional` | Default: `false` |
| `Input type` | `list` | `inputType` | `characters`, `integer`, `float`, `number` |

---

## Do / Don't

| Do | Don't |
|---|---|
| Use `mandatory: true` to indicate required fields — the prop handles the asterisk consistently. | Don't manually append `*` to the label string — it breaks screen reader announcements. |
| Use `supportText` to explain the format or constraint before the user makes an error. | Don't use placeholder text as a substitute for a label — it disappears when the user types. |
| Use `readOnly` for fields that show data the user cannot change in the current context. | Don't disable a field just to show a value — use `readOnly` to preserve visual clarity and allow text selection. |
| Use `inputType: integer` for whole numbers to prevent invalid key presses at source. | Don't validate numeric input only on submit — apply formatters so the user cannot type invalid characters at all. |
