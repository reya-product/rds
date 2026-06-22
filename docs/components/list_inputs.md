# List Inputs

> Selectable list form inputs — a labelled vertical list of options where each row is an `RdsListItem` with a selection control. Three variants cover multi-select (checkbox), single-select (radio), and independent toggles.

---

## When to use / when not to use

**Use when:**
- Presenting 3–10 options in a form where the user must choose from a set of known values.
- The options benefit from supporting text (descriptions) alongside the label.
- You need a scannable vertical list rather than an inline row of chips.

**Do not use when:**
- There are only 2 options — use `RdsCheckboxInput` or a pair of `RdsRadio` + labels instead.
- There are more than ~12 options — use a `RdsDropdownField` or `RdsComboboxField` with search.
- Options are tags or categories the user builds a set from — use `RdsInputChip`.

---

## Anatomy

```
Label *                                     ← 1. Label (+ mandatory asterisk)
┌────────────────────────────────────────┐  ← 2. Optional border container
│ [☑] Cardiovascular health             │  ← 3. RdsListItem row
│     Heart rate, blood pressure        │       (leading: checkbox / radio;
│─────────────────────────────────────  │        trailing: toggle switch)
│ [☐] Sleep quality                     │
│     Duration, cycles                  │  ← 4. Optional divider between rows
│─────────────────────────────────────  │
│ [☐] Nutrition tracking                │
└────────────────────────────────────────┘
Support / error text                        ← 5. Bottom text
```

| Part | Description |
|---|---|
| 1. Label | `labelLarge` text above the list; optional `*` suffix when `mandatory: true` |
| 2. Border container | Optional rounded border (controlled by `bordered`) |
| 3. Row | `RdsListItem` with selection control in leading or trailing slot |
| 4. Divider | Optional `outlineVariant`-coloured 1px divider between rows (controlled by `showDividers`) |
| 5. Bottom text | `bodySmall` support text (muted) or error text (danger colour) |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| `RdsMultiSelectListInput` | Checkbox in leading position; rows can be selected in any combination | User needs to pick zero or more options |
| `RdsSingleSelectListInput` | Radio in leading position; only one row selected at a time | User must pick exactly one option from a mutually exclusive set |
| `RdsToggleListInput` | Toggle switch in trailing position; each row is independently on/off | Settings list — each option is an independent boolean preference |

---

## Configs (props)

### RdsMultiSelectListInput

| Prop | Type | Default | Description |
|---|---|---------|-------------|
| `label` | `String` | required | Field label rendered above the list |
| `items` | `List<RdsListInputItem<T>>` | required | All available options |
| `selected` | `Set<T>` | required | Currently selected values |
| `onChanged` | `ValueChanged<Set<T>>?` | `null` | Called with new set on change; null = disabled |
| `supportText` | `String?` | `null` | Helper text below the list |
| `errorText` | `String?` | `null` | Error message; overrides `supportText` |
| `mandatory` | `bool` | `false` | Appends `*` to label |
| `showDividers` | `bool` | `false` | Draw dividers between rows |
| `bordered` | `bool` | `false` | Draw outer border around the list |

### RdsSingleSelectListInput

| Prop | Type | Default | Description |
|---|---|---------|-------------|
| `label` | `String` | required | Field label rendered above the list |
| `items` | `List<RdsListInputItem<T>>` | required | All available options |
| `selected` | `T?` | `null` | Currently selected value |
| `onChanged` | `ValueChanged<T?>?` | `null` | Called on selection change; null = disabled |
| `supportText` | `String?` | `null` | Helper text below the list |
| `errorText` | `String?` | `null` | Error message; overrides `supportText` |
| `mandatory` | `bool` | `false` | Appends `*` to label |
| `showDividers` | `bool` | `false` | Draw dividers between rows |
| `bordered` | `bool` | `false` | Draw outer border around the list |

### RdsToggleListInput

| Prop | Type | Default | Description |
|---|---|---------|-------------|
| `label` | `String` | required | Field label rendered above the list |
| `items` | `List<RdsListInputItem<T>>` | required | All available options |
| `selected` | `Set<T>` | required | Currently toggled-on values |
| `onChanged` | `ValueChanged<Set<T>>?` | `null` | Called on toggle change; null = disabled |
| `supportText` | `String?` | `null` | Helper text below the list |
| `errorText` | `String?` | `null` | Error message; overrides `supportText` |
| `mandatory` | `bool` | `false` | Appends `*` to label |
| `showDividers` | `bool` | `true` | Draw dividers between rows (default true for settings lists) |
| `bordered` | `bool` | `false` | Draw outer border around the list |

### RdsListInputItem

| Prop | Type | Default | Description |
|---|---|---------|-------------|
| `value` | `T` | required | The value this item represents |
| `label` | `String` | required | Primary label text |
| `supportingText` | `String?` | `null` | Secondary description text |
| `leadingIcon` | `IconData?` | `null` | Optional icon |
| `disabled` | `bool` | `false` | Item cannot be selected or toggled |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled | Default | Normal appearance | — |
| Hover | Pointer over row | State layer over row | `state-hover` opacity on `on-surface` |
| Pressed | Tap / click down | Deeper state layer | `state-pressed` opacity |
| Selected | Item in `selected` set | Row background tinted; control filled | `color-primary-container`; `color-primary` |
| Error | `errorText` non-null | Error text in danger colour below list | `color-danger` |
| Disabled (input) | `onChanged: null` | All rows non-interactive; opacity reduced | `opacity-disabled` via `RdsListItem` |
| Disabled (item) | `item.disabled: true` | Single row non-interactive; opacity reduced | `opacity-disabled` via `RdsListItem` |

---

## Tokens used

**Colors**
- `color-on-surface` — label text
- `color-on-surface-variant` — support text, supporting text in rows
- `color-on-surface-muted` — description text in label
- `color-outline` — border around the list when `bordered: true`; dividers
- `color-outline-variant` — row dividers; subtle border accents
- `color-primary` — selected checkbox/radio fill; mandatory asterisk uses `color-danger`
- `color-primary-container` — selected row background tint
- `color-danger` — error text; mandatory asterisk

**Typography**
- `label-large` — field label
- `body-small` — support text / error text
- `body-large` — row primary text (via `RdsListItem`)
- `body-medium` — row supporting text (via `RdsListItem`)

**Spacing**
- `space-1` — gap between support text and list
- `space-2` — gap between label and list
- `space-3` — row internal gap (via `RdsListItem`)
- `space-4` — row vertical padding (via `RdsListItem`)

**Radius**
- `radius-md` — border radius of the optional outer border container

**Motion**
- `motion-duration-standard` — row background colour transition (via `RdsListItem`)
- `motion-curve-standard` — row background colour transition (via `RdsListItem`)

---

## Behavior & interaction

### Mouse / touch
- Tapping anywhere on an enabled row fires the same callback as tapping the control directly.
- Disabled items (either by `item.disabled` or by `onChanged: null`) swallow no events — they simply do not fire callbacks.
- The whole-row tap on `RdsSingleSelectListInput` is a no-op when the row is already selected (radio semantics: you cannot deselect by re-tapping).

### Keyboard
- Tab moves focus to each `RdsListItem` row.
- Space or Enter activates the focused row (via `RdsListItem`'s built-in `onTap` focus handling).
- Arrow keys within a `RdsSingleSelectListInput` follow standard radio-group keyboard behaviour via the embedded `RdsRadio`.

### Focus management
- Focus follows each `RdsListItem` row independently.
- No focus trap — tab exits the list naturally.

### Animation
- Row background fades on selection via `RdsListItem`'s `AnimatedContainer` (`motion-duration-standard`).
- Checkbox tick, radio dot, and toggle thumb animations are handled by the respective atomic controls.

---

## Accessibility

- **Semantics:** Each `RdsListItem` row wraps its content in a `Semantics` widget with `button: true`, `selected`, `enabled`, and `label` set to `primaryText`. This is provided by `RdsListItem` automatically.
- **Min touch target:** 56px tall rows (enforced by `RdsListItem`'s `BoxConstraints(minHeight: 56)`), which exceeds the 44px WCAG minimum.
- **Contrast:** All text/background pairs use semantic colour tokens that meet WCAG AA: `on-surface` on `surface` (≥ 7:1), `on-surface-variant` on `surface` (≥ 4.5:1), `danger` on `surface` (≥ 4.5:1).
- **Screen reader:** The embedded `RdsCheckbox`, `RdsRadio`, and `RdsToggleSwitch` provide their own `Semantics` (checked/toggled state). The outer row `Semantics` announces the label.
- **Keyboard:** Fully operable with keyboard via tab + space/enter. Radio groups support arrow-key navigation via the native `RdsRadio` focus handling.

---

## Content guidelines

- **Label:** Title-case, concise (1–4 words). Examples: "Health goals", "Notification preferences".
- **Mandatory asterisk:** Only use when the field is truly required by the form; always pair with form-level validation.
- **Item labels:** Sentence-case, noun phrases. Avoid starting with verbs.
- **Supporting text on items:** 1 short phrase (< 60 chars). Describes what the option covers, not instructions.
- **Error messages:** Constructive and specific. "Please select at least one health goal" not "Error".
- **Support text:** Use for instructions that apply to the whole list, not to individual items.

---

## Composition

**Uses:**
- `RdsListItem` — each row in the list; provides selection controls, hover/press state layers, and accessibility semantics
- `RdsCheckbox` (via `RdsListItem`) — multi-select control
- `RdsRadio` (via `RdsListItem`) — single-select control
- `RdsToggleSwitch` (via `RdsListItem`) — toggle control

**Used by:**
- Form screens that require bounded selection (e.g. onboarding health goal pickers, settings panels)

---

## Flutter API

### Widget classes
- `RdsMultiSelectListInput<T>`
- `RdsSingleSelectListInput<T>`
- `RdsToggleListInput<T>`

### Constructors

```dart
// Multi-select
const RdsMultiSelectListInput({
  super.key,
  required String label,
  required List<RdsListInputItem<T>> items,
  required Set<T> selected,
  ValueChanged<Set<T>>? onChanged,
  String? supportText,
  String? errorText,
  bool mandatory = false,
  bool showDividers = false,
  bool bordered = false,
});

// Single-select
const RdsSingleSelectListInput({
  super.key,
  required String label,
  required List<RdsListInputItem<T>> items,
  T? selected,
  ValueChanged<T?>? onChanged,
  String? supportText,
  String? errorText,
  bool mandatory = false,
  bool showDividers = false,
  bool bordered = false,
});

// Toggle list
const RdsToggleListInput({
  super.key,
  required String label,
  required List<RdsListInputItem<T>> items,
  required Set<T> selected,
  ValueChanged<Set<T>>? onChanged,
  String? supportText,
  String? errorText,
  bool mandatory = false,
  bool showDividers = true,
  bool bordered = false,
});

// Shared data class
const RdsListInputItem({
  required T value,
  required String label,
  String? supportingText,
  IconData? leadingIcon,
  bool disabled = false,
});
```

### Example usage

```dart
// Multi-select
RdsMultiSelectListInput<String>(
  label: 'Health goals',
  mandatory: true,
  items: const [
    RdsListInputItem(value: 'cardio', label: 'Cardiovascular health',
        supportingText: 'Heart rate, blood pressure'),
    RdsListInputItem(value: 'sleep', label: 'Sleep quality',
        supportingText: 'Duration, cycles'),
    RdsListInputItem(value: 'fitness', label: 'Fitness goals', disabled: true),
  ],
  selected: _selected,
  onChanged: (s) => setState(() => _selected = s),
  showDividers: true,
  errorText: _submitted && _selected.isEmpty
      ? 'Please select at least one goal.'
      : null,
)

// Single-select
RdsSingleSelectListInput<String>(
  label: 'Primary health focus',
  items: _focusItems,
  selected: _focus,
  onChanged: (v) => setState(() => _focus = v),
  bordered: true,
)

// Toggle list
RdsToggleListInput<String>(
  label: 'Notification channels',
  items: _channelItems,
  selected: _enabledChannels,
  onChanged: (s) => setState(() => _enabledChannels = s),
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | Interactive use case with knobs for all major props; selection state is tracked so items actually toggle |
| `Gallery` | Static grid showing enabled, with selections, with dividers + border, error state, and disabled state |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `Show dividers` | boolean | `showDividers` | true / false |
| `Bordered` | boolean | `bordered` | true / false |
| `Mandatory` | boolean | `mandatory` | true / false |
| `Error text` | string | `errorText` | any string |
| `Disabled` | boolean | controls `onChanged: null` | true / false |

---

## Do / Don't

| Do | Don't |
|---|---|
| Use `RdsSingleSelectListInput` for mutually exclusive choices (e.g. preferred contact method) | Use `RdsMultiSelectListInput` when only one option should be selected — use the Single-select variant instead |
| Keep item labels concise noun phrases in sentence case | Write item labels as instructions ("Click here to select cardiovascular health") |
| Show `errorText` when the form is submitted with an invalid selection | Show `errorText` before the user has had a chance to interact |
| Use `showDividers: true` for toggle lists with dense settings content | Add borders and dividers together on short 2-3 item lists — pick one or neither |
