# Badge

> A non-interactive pill label used to convey status, category, or metadata inline with other content.

---

## When to use / when not to use

**Use when:**
- Labelling an entity with a category, tag, or classification (e.g. "Cardiology", "Draft").
- Showing semantic status that does not change in response to direct user action (e.g. "Active", "Warning").
- Annotating list items, table cells, or cards with a secondary attribute.
- Displaying a count or short numeric value alongside a label.

**Do not use when:**
- The label triggers an action — use `RdsButton` (text or outlined variant) instead.
- The user needs to toggle or select a value — use `RdsInputChip` instead.
- You need to display a notification count on top of an icon — use a dot indicator or notification badge overlay instead.
- The content is longer than ~20 characters; badges are designed for short labels only.

---

## Anatomy

```
┌──────────────────────────────────┐
│  [icon?]  Label text             │
└──────────────────────────────────┘
     1         2
```

| Part | Description |
|---|---|
| 1. Icon (optional) | A 10–14px icon shown before the label (`leading` mode) or as the sole content (`iconOnly` mode). |
| 2. Label text | Short text rendered in `label-small`, `label-medium`, or `label-large` depending on `size`. |
| 3. Container | A pill-shaped (`radius-full`) container with a pastel or semantic background color. |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| Label only (`iconMode: none`) | Pill with text only. | Default; use when no icon is needed. |
| Leading icon (`iconMode: leading`) | Icon to the left of the label. | When an icon reinforces the category meaning. |
| Icon only (`iconMode: iconOnly`) | Pill with icon only; label used as semantic label. | Very dense layouts; always pair with a visible label nearby. |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | required | Text displayed inside the badge. |
| `iconMode` | `RdsBadgeIconMode` | `RdsBadgeIconMode.none` | Whether to show an icon and where. |
| `icon` | `IconData?` | `null` | The icon to display; required when `iconMode` is not `none`. |
| `color` | `RdsBadgeColor` | `RdsBadgeColor.neutral` | Color scheme (pastel or semantic). |
| `size` | `RdsBadgeSize` | `RdsBadgeSize.medium` | Controls height and type scale. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Default | Always | Pill with background and text. | — |

Badge is a purely display component — it has no interactive states.

---

## Sizes

| Size | Height | H-padding | Font style | Icon size |
|---|---|---|---|---|
| `small` | 20px | `space-2` (8px) | `label-small` | 10px |
| `medium` | 24px | `space-3` (12px) | `label-medium` | 12px |
| `large` | 28px | `space-3` (12px) | `label-large` | 14px |

---

## Tokens used

**Colors**
- `badge-blue-background` / `badge-blue-text` — blue pastel pair
- `badge-purple-background` / `badge-purple-text` — purple pastel pair
- `badge-pink-background` / `badge-pink-text` — pink pastel pair
- `badge-orange-background` / `badge-orange-text` — orange pastel pair
- `badge-yellow-background` / `badge-yellow-text` — yellow pastel pair
- `badge-teal-background` / `badge-teal-text` — teal pastel pair
- `badge-green-background` / `badge-green-text` — green pastel pair
- `badge-red-background` / `badge-red-text` — red pastel pair
- `badge-amber-background` / `badge-amber-text` — amber pastel pair
- `badge-neutral-background` / `badge-neutral-text` — neutral pastel pair
- `color-danger-container` / `color-on-danger-container` — semantic danger
- `color-warning-container` / `color-on-warning-container` — semantic warning
- `color-success-container` / `color-on-success-container` — semantic success

**Typography**
- `label-small` — small badge text
- `label-medium` — medium badge text (default)
- `label-large` — large badge text

**Spacing**
- `space-2` — horizontal padding for `small` size
- `space-3` — horizontal padding for `medium` and `large` sizes
- `space-1` — gap between leading icon and label text

**Radius**
- `radius-full` — pill shape

---

## Behavior & interaction

### Mouse / touch
- Not interactive. No hover, press, or focus states.

### Keyboard
- Not focusable (excluded from tab order).

### Focus management
- No focus management — purely presentational.

### Animation
- None.

---

## Accessibility

- **Semantics:** For `iconOnly` mode, the `label` prop is passed as the `Semantics.label` so screen readers can announce the badge content.
- **Min touch target:** Not applicable — badge is non-interactive.
- **Contrast:** All pastel color pairs are verified at WCAG AA (≥ 4.5:1). Semantic pairs use `*Container` / `on*Container` token pairs which are also AA-verified.
- **Screen reader:** Badge text is read inline as part of the containing widget's semantic tree.
- **Keyboard:** No keyboard interaction required.

---

## Content guidelines

- **Label:** Sentence case, 1–20 characters recommended. Avoid punctuation. Do not truncate — pick a shorter label instead.
- **Icon only:** Always ensure a text label is visible nearby so color-blind users are not relying on badge color alone.
- **Semantic colors:** Use `danger` for error/critical states, `warning` for caution, `success` for positive/completed states.

---

## Composition

**Uses:**
- Primitive — no RDS dependencies.

**Used by:**
- `RdsListItem` — displays metadata badges on list rows.
- `RdsCard` — category or status annotation.

---

## Flutter API

### Widget class
`RdsBadge`

### Constructor
```dart
const RdsBadge({
  super.key,
  required String label,
  RdsBadgeIconMode iconMode = RdsBadgeIconMode.none,
  IconData? icon,
  RdsBadgeColor color = RdsBadgeColor.neutral,
  RdsBadgeSize size = RdsBadgeSize.medium,
});
```

### Public enums

```dart
enum RdsBadgeColor {
  blue, purple, pink, orange, yellow, teal, green, red, amber, neutral,
  danger, warning, success,
}

enum RdsBadgeSize { small, medium, large }

enum RdsBadgeIconMode { none, leading, iconOnly }
```

### Example usage

```dart
// Status badge
RdsBadge(
  label: 'Active',
  color: RdsBadgeColor.success,
)

// Category badge with icon
RdsBadge(
  label: 'Cardiology',
  iconMode: RdsBadgeIconMode.leading,
  icon: RdsIcons.user,
  color: RdsBadgeColor.teal,
  size: RdsBadgeSize.large,
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | All props exposed as knobs; live preview of a single badge. |
| `Gallery` | Grid showing all `RdsBadgeColor` values × all `RdsBadgeSize` values. |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `Label` | `string` | `label` | — |
| `Color` | `list` | `color` | All `RdsBadgeColor` values |
| `Size` | `list` | `size` | `small`, `medium`, `large` |
| `Icon mode` | `list` | `iconMode` | `none`, `leading`, `iconOnly` |

---

## Do / Don't

| Do | Don't |
|---|---|
| Use token-named color variants (`danger`, `success`, etc.) to communicate semantic meaning consistently. | Don't invent custom background/text colors outside the `RdsBadgeColor` enum. |
| Keep badge labels short (≤ 3 words). | Don't put entire sentences or truncated strings inside a badge. |
| Use `iconOnly` mode only when space is critically constrained; ensure a nearby label explains the badge. | Don't rely on color alone to convey meaning — icon or text must also differentiate. |
| Match badge size to the surrounding text size (e.g. `small` badge alongside `label-small` text). | Don't mix large badges with small body text — they will look misaligned. |
