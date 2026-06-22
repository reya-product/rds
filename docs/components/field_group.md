# Field Group

> A layout molecule that joins two child fields side-by-side with a single shared rounded-rect border and a 1px vertical divider at the junction.

---

## When to use / when not to use

**Use when:**
- Two fields belong to one logical value — e.g. country-code + phone number, numeric value + unit picker, area code + extension.
- The visual grouping needs to be unambiguous (a single border communicates "these inputs are one thing").
- Horizontal space is sufficient for both fields to remain legible.

**Do not use when:**
- The two fields are independent and only appear near each other — use regular spacing instead.
- More than two fields need to be joined — use a custom layout with shared border drawn manually.
- On narrow viewports where both fields become too small to interact with comfortably; consider stacking them vertically.

---

## Anatomy

```
┌─ label (optional) ───────────────────────────────────────────┐
│                                                               │
│  ┌────────────────────────┬────────────────────────────────┐  │
│  │  leftChild             │  rightChild                    │  │
│  └────────────────────────┴────────────────────────────────┘  │
│                                                               │
│  support / error text (optional)                              │
└───────────────────────────────────────────────────────────────┘

Parts:
  1. Shared label (optional)     — above the joined field row
  2. Outer container border      — single rounded-rect drawn by RdsFieldGroup
  3. Left child slot             — any RdsTextField-compatible widget
  4. Junction divider            — 1px vertical line at color-outline (or color-danger on error)
  5. Right child slot            — any RdsTextField-compatible widget
  6. Support / error text        — below the row; error overrides support
```

| Part | Description |
|---|---|
| 1. Shared label | Optional text label above the group. Supports `mandatory: true` asterisk. |
| 2. Outer border | The group container draws the single combined border. Children render with `InputBorder.none`. |
| 3. Left child | Any widget that fills its flex area. Typically an `RdsTextField` or a mock dropdown. |
| 4. Junction divider | A `VerticalDivider` (1×1px) at `color-outline`. Changes to `color-danger` on error. |
| 5. Right child | Same as left child. |
| 6. Footer text | Single-line helper or error message below the row. |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| Default | Equal flex 1:1 — both children share 50% width. | When both fields need equal prominence. |
| Unequal flex | Supply `leftFlex`/`rightFlex` to control proportions. | When one field (e.g. a unit picker) should be narrower. |
| With label | `label` and optionally `mandatory: true`. | When the group needs a semantic field label. |
| Error | `errorText` non-null: border and divider turn `color-danger`, error text appears below. | Validation failure. |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `leftChild` | `Widget` | required | Left field widget (any RDS field or custom widget). |
| `rightChild` | `Widget` | required | Right field widget. |
| `leftFlex` | `int` | `1` | Flex factor for left field width. |
| `rightFlex` | `int` | `1` | Flex factor for right field width. |
| `label` | `String?` | `null` | Optional shared label above the group. |
| `supportText` | `String?` | `null` | Helper text below the group. Hidden when `errorText` is set. |
| `errorText` | `String?` | `null` | Error message. When non-null the group enters error state. |
| `mandatory` | `bool` | `false` | Appends ` *` to the label when true. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled | Default | Normal `color-outline` border, `color-surface` backgrounds. | `color-outline` |
| Focus (child) | Child field focused | Individual child shows its focus border *inside* the clip; group border unchanged. | `color-primary` (on child) |
| Error | `errorText` non-null | Group border and junction divider switch to `color-danger` at 2px; error text below. | `color-danger` |
| Disabled | `disabled` on child | Child dims; group border remains `color-outline`. Manage disabled state on individual children. | `opacity-disabled` (on child) |

---

## Tokens used

**Colors**
- `color-surface` — fill color for child field backgrounds
- `color-outline` — group border and junction divider (enabled state)
- `color-danger` — group border and junction divider (error state)
- `color-on-surface-variant` — label and support text color

**Typography**
- `body-medium` — label
- `body-small` — support / error text

**Spacing**
- `space-1` — gap between label and field row; gap between row and support text
- `space-3` — horizontal/vertical padding inside child fields (via `_FieldGroupChild` override)

**Radius**
- `radius-md` — outer container border radius; clip radius = `radius-md - border-width`

---

## Behavior & interaction

### Mouse / touch
- Tapping anywhere in a child slot focuses that child field's input.
- The group border does not respond to hover itself; individual children handle hover via their own state layers.

### Keyboard
- Tab moves focus between the two child fields in document order (left → right).
- Each child field handles its own keyboard behavior.

### Focus management
- Focus is managed entirely by the children. `RdsFieldGroup` is a layout-only widget.

### Animation
- No group-level animation. Children animate their own focus/error borders.

---

## Accessibility

- **Semantics:** `Semantics(container: true, label: label ?? '')` wraps the whole group.
- **Min touch target:** Each child must meet the 44×44px minimum — enforce via child widget height.
- **Contrast:** `color-outline` on `color-surface` meets AA for UI component boundaries (3:1+). `color-danger` on white at `danger-600` = `#DC2626` passes AA.
- **Screen reader:** The outer semantics label is read first; individual fields announce themselves when focused.
- **Keyboard:** Fully keyboard-navigable via the children's own keyboard support.

---

## Content guidelines

- **Label:** Sentence case. Describe the combined value, not one field (e.g. "Phone number", not "Country code and number").
- **Support text:** Keep to one line. Describe format or constraints relevant to the whole group.
- **Error messages:** Describe the problem with the combined value where possible. Sentence case, no period needed for short messages.

---

## Composition

**Uses:**
- Any `RdsTextField`-derived widget — passed as `leftChild` / `rightChild`.
- `_FieldGroupChild` (private) — strips individual child borders via `Theme.of(context).copyWith(inputDecorationTheme: ...)`.

**Used by:**
- Forms requiring phone number input (country code + number).
- Clinical data entry (numeric value + unit).

---

## Flutter API

### Widget class
`RdsFieldGroup`

### Constructor
```dart
const RdsFieldGroup({
  super.key,
  required Widget leftChild,
  required Widget rightChild,
  int leftFlex = 1,
  int rightFlex = 1,
  String? label,
  String? supportText,
  String? errorText,
  bool mandatory = false,
});
```

### Example usage

```dart
// Phone number group
RdsFieldGroup(
  label: 'Phone number',
  mandatory: true,
  supportText: 'Include country code.',
  leftFlex: 2,
  rightFlex: 3,
  leftChild: _CountryCodeDropdown(),
  rightChild: RdsTextField(
    label: 'Mobile number',
    placeholder: '07700 900000',
    inputType: RdsTextFieldInputType.integer,
  ),
)

// Weight + unit group
RdsFieldGroup(
  label: 'Weight',
  leftFlex: 3,
  rightFlex: 2,
  leftChild: RdsTextField(
    label: 'Value',
    placeholder: '75.5',
    inputType: RdsTextFieldInputType.float,
  ),
  rightChild: _UnitDropdown(),
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Phone number` | Left: mock country-code dropdown (+1). Right: integer `RdsTextField`. |
| `Weight with unit` | Left: float `RdsTextField`. Right: mock unit dropdown (kg/lb/st). |
| `With error` | Phone number group in error state — red border, error text below. |

### Knobs

None in static use cases — the three scenarios are hardcoded to demonstrate specific compositions. Add knobs to a Playground use case if needed in future.

---

## Do / Don't

| Do | Don't |
|---|---|
| Pass complete, fully-configured child widgets; `RdsFieldGroup` only handles layout and the shared border. | Re-implement field decoration or label inside the group wrapper — children handle their own internals. |
| Match `leftFlex`/`rightFlex` to the expected content width (shorter unit pickers get a lower flex value). | Use equal flex for very unequal content — the narrower field will look cramped. |
| Apply `errorText` at the group level when the validation error applies to the combined value. | Set `errorText` on both the group and the individual child simultaneously — the double error text is confusing. |
| Use a single shared `label` on the group when both fields form one logical input. | Leave `label` null when the group would otherwise be unlabelled — it must be identifiable to screen reader users. |
