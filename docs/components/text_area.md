# Text Area

> A multi-line text input for collecting longer-form content such as clinical notes, comments, or descriptions.

---

## When to use / when not to use

**Use when:**
- The user needs to enter more than one or two sentences (e.g. clinical notes, patient summaries, appointment comments).
- The input length is unpredictable and the field should grow to fit the content.
- A maximum character limit needs to be communicated via a counter.

**Do not use when:**
- A single line of input is sufficient — use `RdsTextField` instead.
- The input is a password — use `RdsPasswordField`.
- The user is searching or filtering — use `RdsSearchBar`.
- Rich formatting (bold, lists) is needed — consider a rich text editor component (not currently in RDS).

---

## Anatomy

```
┌──────────────────────────────────────────────────┐
│ Label                                             │
├──────────────────────────────────────────────────┤  ← border (1px outline, 8px radius)
│  Placeholder text                                 │
│                                                   │
│                                                   │  ← grows vertically
│                                                   │
└──────────────────────────────────────────────────┘
│ Support text / Error message        0 / 500       │
```

| Part | Description |
|---|---|
| 1. Label | Required. Floats above the input on focus or when filled. |
| 2. Input area | Editable multi-line region. Starts at `minLines` height, grows to `maxLines`. |
| 3. Border | Outline border reflecting state (color and width change per state). |
| 4. Support text | Optional descriptive text. Hidden when `errorText` is set. |
| 5. Error text | Replaces support text in the error state. |
| 6. Character counter | Shown bottom-right when `maxLength` is set. Format: `current / max`. |

Note: No trailing icon — it would conflict with the native resize affordance on web/desktop.

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| Default | Grows from `minLines` (3) up to `maxLines` (unlimited) | Most multi-line text inputs |
| With counter | Shows `current / max` counter below right | When a character limit must be communicated to the user |
| Bounded | `maxLines` is set; field stops growing and scrolls | When vertical space is constrained and content overflow must be controlled |

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
| `minLines` | `int` | `3` | Minimum number of visible lines. |
| `maxLines` | `int?` | `null` | Maximum visible lines before scrolling. `null` = unlimited. |
| `maxLength` | `int?` | `null` | Character limit. Shows counter when set. |
| `onChanged` | `ValueChanged<String>?` | `null` | Called on every text change. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled | Default | `outline` border (1px), `surface` fill | `color-outline`, `color-surface` |
| Hover | Pointer enters field | Border color shifts to `onSurface` at 8% state layer | `state-hover` |
| Focused | Field receives keyboard focus | `primary` border (2px); label color becomes `color-primary` | `color-primary` |
| Filled | Field has a value, not focused | `outline` border (1px); label floats | `color-outline` |
| Error | `errorText` is non-null | `danger` border (2px); error text in `color-danger` | `color-danger` |
| Focused error | Error + focused | `danger` border (2px) | `color-danger` |
| Disabled | `disabled: true` | `surfaceContainer` fill; full field at `opacity-disabled` | `color-surface-container`, `opacity-disabled` |
| Read only | `readOnly: true` | `surfaceContainer` fill; no focus ring | `color-surface-container` |

---

## Sizes

| Size | Min height | H-padding | V-padding | Font style | Icon size |
|---|---|---|---|---|---|
| Default | `minLines × body-large line-height` | `space-4` (16px) | `space-3` (12px) | `body-large` | `icon-md` (20px) |

The field height is dynamic — it grows as the user types, from `minLines` to `maxLines`.

---

## Tokens used

**Colors**
- `color-surface` — fill for enabled/focused states
- `color-surface-container` — fill for readOnly and disabled states
- `color-on-surface` — input text color
- `color-on-surface-variant` — label, icon, and support text color
- `color-on-surface-muted` — placeholder and counter color
- `color-primary` — focused border and floating label color
- `color-outline` — enabled border color
- `color-outline-variant` — disabled border color
- `color-danger` — error border and error text color

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
- `motion-duration-standard` — label float animation
- `motion-curve-standard` — label float easing

**Opacity**
- `opacity-disabled` — applied to the entire field when disabled (0.38)

---

## Behavior & interaction

### Mouse / touch
- Tapping anywhere in the field area focuses the input.
- On web/desktop the field shows a native resize handle at the bottom-right corner (browser behavior; not suppressed).
- Scrolling within a bounded text area (`maxLines` set) uses standard scroll behavior.

### Keyboard
- `Tab` / `Shift+Tab` moves focus in/out of the field.
- `Enter` / `Return` inserts a new line (unlike single-line fields where it submits).
- `textInputAction` is set to `newline` to ensure correct mobile keyboard behavior.

### Focus management
- Label animates to the floated position on focus.
- Character counter updates live as the user types.

### Animation
- Label float: `motion-duration-standard` (200ms), `motion-curve-standard`.

---

## Accessibility

- **Semantics:** `Semantics(textField: true, multiline: true, label: <effectiveLabel>)` wraps the `TextField`.
- **Min touch target:** Field height grows from the `minLines` minimum. The label tap area and the field itself together provide ≥ 44px vertical tap target.
- **Contrast:** `color-on-surface` on `color-surface` exceeds 7:1 in both themes. Error color meets 4.5:1.
- **Screen reader:** On iOS/Android VoiceOver/TalkBack announces "text field, multi-line" on focus. The label is announced as the field's accessible name.
- **Character counter:** The counter value is included in the `TextField`'s `counterText` slot, which is announced by screen readers on focus.

---

## Content guidelines

- **Label:** Sentence case, 1–3 words. Examples: `Clinical notes`, `Patient summary`, `Additional comments`.
- **Placeholder:** Give a realistic example of the expected content or a brief prompt (e.g. `Enter your observations here…`).
- **Support text:** State character limits or formatting requirements upfront (e.g. `Maximum 500 characters.`).
- **Error messages:** Specific and actionable (e.g. `Notes must be at least 10 characters.`).

---

## Composition

**Uses:**
- Primitive — no other RDS components internally. Relies on Flutter's `TextField` with `maxLines` and `minLines`.

**Used by:**
- `RdsFieldGroup` (T2a) — wraps multiple fields in a labeled section.
- Clinical note entry forms across Reya products.

---

## Flutter API

### Widget class
`RdsTextArea`

### Constructor
```dart
const RdsTextArea({
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
  int minLines = 3,
  int? maxLines,
  int? maxLength,
  ValueChanged<String>? onChanged,
});
```

### Example usage

```dart
// Clinical notes with character counter
RdsTextArea(
  label: 'Clinical notes',
  placeholder: 'Enter your observations here…',
  mandatory: true,
  minLines: 4,
  maxLines: 10,
  maxLength: 500,
  supportText: 'Describe findings clearly and concisely.',
  onChanged: (v) => setState(() => _notes = v),
)

// Read-only summary
RdsTextArea(
  label: 'Appointment summary',
  controller: TextEditingController(text: summaryText),
  readOnly: true,
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | Interactive knobs for all props including `minLines` slider and max length toggle. |
| `States gallery` | Static display of all visual states: enabled empty, enabled filled, with counter, error, disabled, read-only. |

### Knobs

| Knob | Type | Maps to prop | Options / Notes |
|---|---|---|---|
| `Label` | `string` | `label` | Default: `'Clinical notes'` |
| `Placeholder` | `string` | `placeholder` | Empty string maps to `null` |
| `Support text` | `string` | `supportText` | Empty string maps to `null` |
| `Error text` | `string` | `errorText` | Empty string maps to `null` |
| `Disabled` | `boolean` | `disabled` | Default: `false` |
| `Read only` | `boolean` | `readOnly` | Default: `false` |
| `Mandatory` | `boolean` | `mandatory` | Default: `false` |
| `Min lines` | `double.slider` | `minLines` | Range 1–8, default 3 |
| `Show max length (500)` | `boolean` | `maxLength` | When true sets `maxLength: 500` |

---

## Do / Don't

| Do | Don't |
|---|---|
| Set `minLines` to match the expected content volume (e.g. 4 for clinical notes, 2 for comments). | Don't use a fixed-height container around `RdsTextArea` — it will clip content as the field grows. |
| Show a character counter (`maxLength`) when the character limit affects data validity. | Don't hide the limit and then show an error after submission — surface constraints proactively. |
| Use `readOnly` to display notes that the current user cannot edit in their role. | Don't use `disabled` for display purposes — it conveys "broken" not "view-only". |
