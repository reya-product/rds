# _component-template.md — RDS Component Authoring Contract

> Every file under `docs/components/<name>.md` MUST follow this template exactly.
> Each section is mandatory unless marked (optional). Do not reorder sections.
> Replace every `<!-- instruction -->` comment and blockquote with real content.
> Remove this preamble block when filling in the template.

---

# [Component Name]

> [One-line purpose: what this component does and when a user encounters it.]

<!-- Example: "A pressable label that triggers an action. The primary interaction affordance in RDS." -->

---

## When to use / when not to use

<!-- Describe the use cases where this component is appropriate, and explicitly list when NOT to use it (including which alternative to use instead). Aim for 2–4 bullets in each section. -->

**Use when:**
- [Situation 1]
- [Situation 2]

**Do not use when:**
- [Situation A — use [AlternativeComponent] instead]
- [Situation B]

---

## Anatomy

<!-- Describe every named part of the component. Use a labeled ASCII sketch where helpful.
     Number each part and explain its role. -->

```
[ASCII sketch of the component with numbered callouts]
```

| Part | Description |
|---|---|
| 1. [Part name] | [What it is and its role] |
| 2. [Part name] | [What it is and its role] |

---

## Variants

<!-- List every named variant. For each variant: name, visual description, when to use. -->

| Variant | Visual description | When to use |
|---|---|---|
| [Variant 1] | [What it looks like] | [When to choose it] |
| [Variant 2] | [What it looks like] | [When to choose it] |

---

## Configs (props)

<!-- Full table of every constructor parameter / prop. These map 1:1 to Widgetbook knobs.
     "default" = what the component renders with no props passed. -->

| Prop | Type | Default | Description |
|---|---|---|---|
| `[propName]` | `[DartType]` | `[defaultValue]` | [What it controls] |

---

## States

<!-- List every applicable state. For each state: describe what triggers it, what changes visually, and which token produces the visual change.
     Standard interactive states: enabled, hover, focus, pressed, disabled.
     Component-specific: error, selected, loading, read-only, indeterminate, etc. -->

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled | Default | Normal appearance | — |
| Hover | Mouse over / pointer enter | [Description] | `state-hover` opacity over [on-color] |
| Focus | Keyboard focus | [Description] | `state-focus` opacity; focus ring |
| Pressed | Tap / click | [Description] | `state-pressed` opacity |
| Disabled | `disabled: true` | [Description] | `opacity-disabled` on content |

<!-- Add component-specific states below: -->

---

## Sizes

<!-- (Optional — omit if the component has no size variants) -->
<!-- List every named size. For each: name, total height, padding values, font style, icon size. Reference token names. -->

| Size | Height | H-padding | Font style | Icon size |
|---|---|---|---|---|
| [Size name] | [px or token] | [token] | [type-scale token] | [icon-size token] |

---

## Tokens used

<!-- IMPORTANT: List token NAMES only — never raw hex values or pixel numbers.
     Group by category. This section is the contract between design and code. -->

**Colors**
- `color-primary` — [what it's used for in this component]
- `color-on-primary` — [what it's used for]

**Typography**
- `label-large` — [what it's used for]

**Spacing**
- `space-2` — [what it's used for]
- `space-4` — [what it's used for]

**Radius**
- `radius-md` — [what it's used for]

**Shadows**
- `shadow-sm` — (if applicable)

**Motion**
- `motion-duration-standard` — [what transition uses it]
- `motion-curve-standard` — [what transition uses it]

---

## Behavior & interaction

<!-- Describe gestures, keyboard navigation, focus management, animation, dismissal, and edge-case behaviors. -->

### Mouse / touch
- [Click/tap behavior]
- [Hover behavior]

### Keyboard
- [Key bindings — e.g. Space/Enter to activate]
- [Tab order]

### Focus management
- [Where focus goes on open/close/activation]

### Animation
- [What animates, duration token, curve token]

---

## Accessibility

<!-- Mandatory. Cover semantics, minimum touch target, contrast, screen reader behavior. -->

- **Semantics:** `Semantics(label: '...', button: true, ...)` — [describe what label to use]
- **Min touch target:** [height] × [width] — minimum 44 × 44px for interactive components
- **Contrast:** [Which color pairs are used — confirm AA compliance]
- **Screen reader:** [What is announced on interaction]
- **Keyboard:** [Can the user operate this with keyboard only?]

---

## Content guidelines

<!-- Rules for copy: label length, casing, truncation, placeholder text, error messages. -->

- **Label:** [Casing convention, max character count, truncation behavior]
- **Placeholder:** [If applicable — what good placeholder text looks like]
- **Error messages:** [If applicable — tone and format]

---

## Composition

<!-- Which RDS components does this component use internally?
     Which RDS components USE this component? -->

**Uses:**
- `[RdsComponentName]` — [why/how]

**Used by:**
- `[RdsComponentName]` — [why/how]

*If this component uses no other RDS components: "Primitive — no RDS dependencies."*

---

## Flutter API

<!-- Complete Dart API reference. This is what an engineer reads to use the component. -->

### Widget class
`[RdsComponentName]`

### Constructor
```dart
const RdsComponentName({
  super.key,
  required [Type] [param],
  [Type] [param] = [default],
  // ... all params
});
```

### Public enums

```dart
enum [RdsComponentNameVariant] {
  [value1],
  [value2],
}
```

### Example usage

```dart
RdsComponentName(
  // required params
  // optional params with non-default values
)
```

---

## Widgetbook

<!-- Describe every use case and every knob in the Widgetbook usecases file. -->

### Use cases

| Use case name | Description |
|---|---|
| `[Use case 1]` | [What this scenario demonstrates] |
| `Gallery` | Renders all variants × key states in a grid for visual review |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `[Knob label]` | `[boolean/list/string/slider]` | `[propName]` | `[values if list]` |

---

## Do / Don't

<!-- 2–4 paired rules with brief explanations. -->

| Do | Don't |
|---|---|
| [Correct usage] | [Incorrect usage to avoid] |
| [Correct usage] | [Incorrect usage to avoid] |
