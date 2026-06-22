# Segmented Control Input

> A form-field shell around RdsSegmentedButtons — adding a label, support text, error text, and mandatory/optional indicators so that a segmented control can participate fully in a form layout.

---

## When to use / when not to use

**Use when:**
- You need a user to choose one (or several) values from a small fixed set inside a form, and the field requires a label, validation feedback, or a helper message.
- You are building a settings screen, filter panel, or data-entry form that already uses other RDS field components and you need visual consistency.
- The underlying [RdsSegmentedButtons] is the right control for the choice (2–5 options, all always visible) but the surrounding layout calls for a labeled form field.
- You need to communicate a required (`mandatory`) or optional field designation to the user.

**Do not use when:**
- You need a bare segmented control without any label or surrounding chrome — use `RdsSegmentedButtons` directly.
- The number of options is large enough that a dropdown would be more scannable — use `RdsSingleSelectInput` or `RdsDropdownField` instead.
- The options change dynamically or are loaded asynchronously — segmented controls are for small, static option sets.
- `readOnly` semantics are required — segmented controls have no meaningful visual distinction between read-only and disabled; use the `disabled` state instead.

---

## Anatomy

```
┌──────────────────────────────────────────┐
│ 1. Label row                              │
│    Time range *                           │
├──────────────────────────────────────────┤
│ 2. Segmented buttons                      │
│    [ Day ]  [ Week ]  [ Month ]           │
└──────────────────────────────────────────┘
  3. Support / error text
     Select the period you want to view.
```

| Part | Description |
|---|---|
| 1. Label row | `bodyMedium` text in `onSurfaceVariant`. Appends " *" in `danger` color when `mandatory: true`, or " (optional)" in `onSurfaceMuted` when `optional: true`. |
| 2. Segmented buttons | The underlying `RdsSegmentedButtons<T>` control. All props (segments, selectionMode, selected, showIcons) are forwarded. |
| 3. Support / error text | `bodySmall` helper text below the control. Rendered in `onSurfaceVariant` normally; rendered in `danger` when `errorText` is set. |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| Default (enabled) | Label, segmented buttons, optional support text | Standard form usage |
| Error | Same layout; support text replaced by `errorText` in `danger` color | When validation has failed and the user must correct their selection |
| Disabled | Entire component dimmed to `opacityDisabled`; segments are non-interactive | When the field is unavailable given the current form state |
| Mandatory | " *" appended to label in `danger` | To signal that a selection is required before submission |
| Optional | " (optional)" appended to label in `onSurfaceMuted` | To explicitly label optional fields in otherwise-required forms |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | required | Field label above the segmented buttons |
| `segments` | `List<RdsSegment<T>>` | required | Ordered list of segments forwarded to `RdsSegmentedButtons` |
| `selectionMode` | `RdsButtonGroupSelectionMode` | `single` | Single or multi-select; forwarded to `RdsSegmentedButtons` |
| `selected` | `Set<T>` | required | Currently selected segment values |
| `onChanged` | `ValueChanged<Set<T>>?` | `null` | Selection-change callback; `null` disables interaction |
| `showIcons` | `bool` | `false` | Whether to render segment icons when present |
| `supportText` | `String?` | `null` | Helper text shown below; hidden when `errorText` is set |
| `errorText` | `String?` | `null` | Validation error message; shown in `danger` color; overrides `supportText` |
| `mandatory` | `bool` | `false` | Appends " *" to the label |
| `optional` | `bool` | `false` | Appends " (optional)" to the label |
| `disabled` | `bool` | `false` | Dims the component and disables interaction |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled | Default | Normal label, buttons, support text | — |
| Error | `errorText` is non-null and non-empty | Support text replaced by error message in danger color | `color-danger` |
| Disabled | `disabled: true` or `onChanged == null` | Entire component dimmed; segments non-interactive | `opacity-disabled` |
| Mandatory | `mandatory: true` | " *" appended to label in danger color | `color-danger` |
| Optional | `optional: true` | " (optional)" appended to label in muted color | `color-on-surface-muted` |

Note: hover, focus, and pressed states are owned by the underlying `RdsSegmentedButtons` segments and are not re-defined here.

---

## Sizes

This component has no independent size variants. The label uses `body-medium` and the support text uses `body-small`. The segmented buttons use their own internal sizing. Vertical spacing between parts uses `space-2` (label → buttons) and `space-1` (buttons → support text).

---

## Tokens used

**Colors**
- `color-on-surface-variant` — label text and support text color
- `color-on-surface-muted` — "(optional)" indicator text
- `color-danger` — mandatory asterisk color; error text color

**Typography**
- `body-medium` — field label
- `body-small` — support text and error text

**Spacing**
- `space-1` — gap between segmented buttons and support/error text
- `space-2` — gap between label and segmented buttons

**Opacity**
- `opacity-disabled` — wraps the entire component when disabled

---

## Behavior & interaction

### Mouse / touch
- Segment tapping and selection are handled entirely by the underlying `RdsSegmentedButtons`; see that component's documentation.
- When `disabled: true` or `onChanged == null`, all segments are non-interactive.

### Keyboard
- Focus and keyboard activation (Space/Enter) are delegated to the underlying `RdsSegmentedButtons` segments.
- Tab navigates between individual segments within the control.

### Focus management
- The label is not separately focusable; focus enters the first segment directly.
- When the field is disabled, segments are not in the tab order.

### Animation
- Segment selection animations (`durationStandard`, `curveStandard`) are handled inside `RdsSegmentedButtons`.
- The `Opacity` wrapper for the disabled state has no animation — it changes immediately.

---

## Accessibility

- **Semantics:** The outer `Semantics` widget carries `label: _effectiveLabel` (the label string with mandatory/optional suffix) and `enabled: !isDisabled`. Individual segments carry their own `Semantics(label: segment.label, button: true, selected: ...)` from `RdsSegmentedButtons`.
- **Min touch target:** 44 × 44 px minimum, enforced by `RdsSegmentedButtons` internal constraints.
- **Contrast:** Label and support text use `color-on-surface-variant` on `color-surface` (meets WCAG AA 4.5:1). Error text uses `color-danger` which is verified AA on light and dark surface tokens. The mandatory asterisk uses `color-danger`.
- **Screen reader:** The field label is announced as part of the outer Semantics node. Each segment is announced independently with its label, button role, and selected state when focused.
- **Keyboard:** Fully operable by keyboard; Tab to navigate segments, Space or Enter to select.

---

## Content guidelines

- **Label:** Use sentence case. Keep labels concise (1–4 words). Avoid ending with a colon. Example: "Time range", "View mode", "Display unit".
- **Mandatory indicator:** Do not write "required" in the label text — the " *" appended by `mandatory: true` communicates this. Accompany with a form-level note explaining that fields marked with * are required.
- **Optional indicator:** Use sparingly — only in forms where most fields are required, to explicitly call out exceptions.
- **Support text:** Use to explain what the selection affects or to provide context that is not obvious from the segment labels. Keep to one sentence (< 80 characters).
- **Error messages:** Use active, specific language. Avoid "Invalid selection." Prefer "Please select a time range to continue." Messages should not exceed one sentence.

---

## Composition

**Uses:**
- `RdsSegmentedButtons<T>` — the core selection control; all segment props are forwarded to it.

**Used by:**
- Form layouts in scheduling, filter panels, and settings screens where a segmented choice is part of a validated form.

---

## Flutter API

### Widget class
`RdsSegmentedControlInput<T>`

### Constructor
```dart
const RdsSegmentedControlInput({
  super.key,
  required String label,
  required List<RdsSegment<T>> segments,
  RdsButtonGroupSelectionMode selectionMode = RdsButtonGroupSelectionMode.single,
  required Set<T> selected,
  ValueChanged<Set<T>>? onChanged,
  bool showIcons = false,
  String? supportText,
  String? errorText,
  bool mandatory = false,
  bool optional = false,
  bool disabled = false,
});
```

### Public enums

This component introduces no new enums. It reuses:

```dart
// From RdsButtonGroup:
enum RdsButtonGroupSelectionMode { none, single, multi }
```

### Example usage

```dart
// Basic single-select field
RdsSegmentedControlInput<String>(
  label: 'Time range',
  segments: const [
    RdsSegment(value: '7d',  label: '7 days'),
    RdsSegment(value: '30d', label: '30 days'),
    RdsSegment(value: '90d', label: '90 days'),
  ],
  selected: _selected,
  onChanged: (next) => setState(() => _selected = next),
  mandatory: true,
  supportText: 'Select the period you want to view.',
)

// Error state
RdsSegmentedControlInput<String>(
  label: 'Time range',
  segments: const [
    RdsSegment(value: '7d',  label: '7 days'),
    RdsSegment(value: '30d', label: '30 days'),
    RdsSegment(value: '90d', label: '90 days'),
  ],
  selected: _selected,
  onChanged: (next) => setState(() => _selected = next),
  mandatory: true,
  errorText: 'Please select a time range to continue.',
)

// Disabled
RdsSegmentedControlInput<String>(
  label: 'Time range',
  segments: const [
    RdsSegment(value: '7d',  label: '7 days'),
    RdsSegment(value: '30d', label: '30 days'),
    RdsSegment(value: '90d', label: '90 days'),
  ],
  selected: const {'30d'},
  onChanged: null,
  disabled: true,
)

// Multi-select
RdsSegmentedControlInput<String>(
  label: 'Visible columns',
  segments: const [
    RdsSegment(value: 'name',  label: 'Name'),
    RdsSegment(value: 'date',  label: 'Date'),
    RdsSegment(value: 'score', label: 'Score'),
  ],
  selectionMode: RdsButtonGroupSelectionMode.multi,
  selected: _selectedColumns,
  onChanged: (next) => setState(() => _selectedColumns = next),
  optional: true,
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | Interactive use case with string/boolean/list knobs for all props; uses `_PlaygroundBody` to maintain live selection state. |
| `Gallery` | Shows enabled, mandatory, optional, error, and disabled states side-by-side with section labels for visual comparison. |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `Label` | string | `label` | Free text; default "Time range" |
| `Mandatory` | boolean | `mandatory` | true / false |
| `Optional` | boolean | `optional` | true / false |
| `Disabled` | boolean | `disabled` | true / false |
| `Error text` | string | `errorText` | Free text; empty string = no error |
| `Support text` | string | `supportText` | Free text; empty string = hidden |
| `Selection mode` | list | `selectionMode` | `single`, `multi` |

---

## Do / Don't

| Do | Don't |
|---|---|
| Use `RdsSegmentedControlInput` whenever a segmented choice appears inside a form that also has other labeled fields — it keeps vertical rhythm consistent. | Don't use `RdsSegmentedButtons` directly in a form layout without a label; unlabeled controls are inaccessible and visually inconsistent. |
| Pass `mandatory: true` for required fields and let the asterisk communicate the requirement; reinforce it with a form-level legend. | Don't set both `mandatory: true` and `optional: true` simultaneously — the component asserts against this combination. |
| Show a concise, actionable `errorText` when validation fails. | Don't leave both `errorText` and `supportText` visible at the same time — `errorText` always takes precedence; `supportText` is hidden. |
| Use `onChanged: null` or `disabled: true` to prevent interaction when the field is not applicable; both produce the same visual dimming. | Don't use this component for read-only display of a user's past selection — use a plain `Text` widget with a label instead. |
