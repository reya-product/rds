# List

> A vertical stack of `RdsListItem` widgets — the simplest composable list surface, used wherever a sequence of rows must be grouped without a containing input.

---

## When to use / when not to use

**Use when:**
- Displaying a static or dynamic sequence of `RdsListItem` rows in a page, card, or panel.
- You need optional dividers between items without building the spacer/divider logic yourself.
- You want compact-density rendering (tighter vertical padding) for data-dense sections.

**Do not use when:**
- You need scroll behavior — wrap `RdsList` in `SingleChildScrollView` or `ListView` instead; `RdsList` is intentionally non-scrollable.
- You are rendering a selection popup (dropdown, combobox) — use `RdsDropdownPopup`.
- You need a table or data grid — use `Table` / custom grid layout; list items do not align columns.
- You have only one item — a bare `RdsListItem` is sufficient.

---

## Anatomy

```
┌─────────────────────────────────────────┐
│  [RdsListItem]  Dr. Sarah Chen          │  ← 1. item
│  ─────────────────────────────────────  │  ← 2. divider (optional)
│  [RdsListItem]  Dr. Marcus Lee          │
│  ─────────────────────────────────────  │
│  [RdsListItem]  Dr. Aisha Patel         │
└─────────────────────────────────────────┘
```

| Part | Description |
|---|---|
| 1. Item | An `RdsListItem` widget passed directly in the `items` list. `RdsList` renders it unchanged in `comfortable` density, or with reduced vertical padding in `compact` density. |
| 2. Divider | 1px `outline-variant` full-width horizontal line between items. Only rendered when `showDividers: true`. Has `height: 1` and `thickness: 1` so it does not add extra vertical space. |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| Default (comfortable, no dividers) | Items stacked with standard padding; no separators. | Short lists where proximity is enough to group items. |
| With dividers | 1px lines between every item. | When the list is long or items share similar layouts that could blur together. |
| Compact density | Reduced vertical padding on each item via `ListTileTheme` injection. | Data-dense panels (sidebars, settings pages, dense dashboards). |
| Compact + dividers | Reduced padding with 1px dividers. | Maximum data density with clear row separation. |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `items` | `List<RdsListItem>` | required | Pre-built `RdsListItem` widgets to display. |
| `showDividers` | `bool` | `false` | Draws 1px `outline-variant` dividers between items. |
| `density` | `RdsListDensity` | `comfortable` | Controls vertical padding. `comfortable` = default; `compact` = reduced. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled | Default | Normal list. Items render in their own enabled state. | — |
| Item hover | Pointer enters an item | State layer applied to the item row. Managed by `RdsListItem`. | `state-hover` |
| Item pressed | Tap on an item | Darker state layer on item row. Managed by `RdsListItem`. | `state-pressed` |
| Item selected | `RdsListItem.selected: true` | `primary-container` background on that row. | `color-primary-container` |
| Item disabled | `RdsListItem.enabled: false` | Item dimmed; no interaction. | `opacity-disabled` |
| Empty | `items` is empty | No output. `RdsList` returns `SizedBox.shrink()`. | — |

---

## Sizes

| Density | Min item height | Vertical padding | Notes |
|---|---|---|---|
| `comfortable` | 56px | `space-3` (12px) top + bottom (via `RdsListItem`) | Default. Uses `RdsListItem` natural sizing. |
| `compact` | ~40px | `space-1` (4px) top + bottom | Injected via `ListTileTheme.contentPadding`. |

---

## Tokens used

**Colors**
- `color-outline-variant` — divider color

**Spacing**
- `space-1` — compact vertical padding (via `ListTileTheme` override)
- `space-4` — horizontal padding in compact `ListTileTheme` override

---

## Behavior & interaction

### Mouse / touch
- `RdsList` itself is non-interactive. All interaction (hover, press, tap) is handled by individual `RdsListItem` widgets.
- Dividers have `IgnorePointer` semantics; they do not capture events.

### Keyboard
- Tab order follows document order through the items.
- Each `RdsListItem` handles its own keyboard interaction (Space/Enter to activate).

### Focus management
- Focus moves naturally through items in order.
- `RdsList` does not set an initial focus.

### Scrolling
- `RdsList` expands to its natural height. The parent is responsible for scrolling (e.g. `SingleChildScrollView`, `ListView`, `CustomScrollView`).

### Animation
- No list-level animations. Individual `RdsListItem` rows animate their own state layer transitions.

---

## Accessibility

- **Semantics:** Each `RdsListItem` in the list emits its own `Semantics` node (`button`, `selected`, `enabled`, `label`). `RdsList` adds no additional semantics wrapper.
- **Min touch target:** Each item row is at least 56px tall in `comfortable` mode; at least 44px in `compact` mode (enforced by `RdsListItem`'s `ConstrainedBox(minHeight: 56)`).
- **Contrast:** Divider color (`outline-variant`) is decorative and does not carry meaning.
- **Screen reader:** The list has no special role. Items announce as individual buttons or other interactive roles.
- **Keyboard:** Full keyboard navigation via item-level `GestureDetector` and `MouseRegion`.

---

## Content guidelines

- **Labels:** Follow `RdsListItem` content guidelines — sentence case, ≤ 40 characters for primary text.
- **Item order:** Use a meaningful order (alphabetical, chronological, or by relevance). Avoid arbitrary ordering that forces the user to scan the entire list.
- **Empty state:** When the list may be empty, handle it in the parent — show an empty-state illustration or message rather than rendering `RdsList` with an empty array.
- **Density:** Use `compact` only when horizontal space is severely constrained or information density is explicitly required (e.g. side panels, settings drawers). Default to `comfortable` for most product surfaces.

---

## Composition

**Uses:**
- `RdsListItem` — every item in the list is an `RdsListItem`.

**Used by:**
- `RdsDropdownPopup` — uses the same item-stacking pattern (internally handles its own `Column` but composes `RdsListItem` directly).
- `RdsMultiSelectInput` (T2b) — wraps `RdsList` for the option set.
- `RdsSingleSelectInput` (T2b) — wraps `RdsList` for a static option set.
- `RdsToggleListInput` (T2b) — wraps `RdsList` with toggle trailing items.
- Page-level panels and settings surfaces throughout Reya products.

---

## Flutter API

### Widget class
`RdsList`

### Constructor
```dart
const RdsList({
  super.key,
  required List<RdsListItem> items,
  bool showDividers = false,
  RdsListDensity density = RdsListDensity.comfortable,
});
```

### Public enums

```dart
enum RdsListDensity {
  /// Standard vertical padding — uses RdsListItem natural sizing.
  comfortable,

  /// Reduced vertical padding — injected via ListTileTheme override.
  compact,
}
```

### Example usage

```dart
// Minimal list
RdsList(
  items: [
    RdsListItem(primaryText: 'Dr. Sarah Chen', onTap: () {}),
    RdsListItem(primaryText: 'Dr. Marcus Lee', onTap: () {}),
    RdsListItem(primaryText: 'Dr. Aisha Patel', onTap: () {}),
  ],
)

// List with dividers inside a scrollable panel
SingleChildScrollView(
  child: RdsList(
    showDividers: true,
    density: RdsListDensity.compact,
    items: doctors.map((d) => RdsListItem(
      primaryText: d.name,
      supportingText: d.specialty,
      leading: RdsListItemLeading.avatar,
      leadingAvatar: RdsAvatarConfig(
        type: RdsAvatarType.initials,
        name: d.name,
      ),
      onTap: () => _selectDoctor(d),
    )).toList(),
  ),
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | Knob-driven. Control `showDividers` (bool) and `density` (list). 5 pre-built items. |
| `With dividers` | Static example of a 5-item list with `showDividers: true`. |
| `Compact density` | Static example of a 5-item list with `density: compact`. |
| `All leading types` | 6 items each with a different `leading` type (none, icon, avatar, checkbox, radio, toggle). |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `Show dividers` | boolean | `showDividers` | true / false |
| `Density` | list | `density` | `comfortable`, `compact` |

---

## Do / Don't

| Do | Don't |
|---|---|
| Wrap `RdsList` in `SingleChildScrollView` when the list may overflow its container. | Rely on `RdsList` to scroll — it will overflow without a scroll ancestor. |
| Use `comfortable` density as the default and switch to `compact` only when layout is constrained. | Use `compact` density on touch-first surfaces where the minimum 44px target may not be met. |
| Keep all items in a list visually consistent (same leading type, same trailing type). | Mix items with avatars, icons, and no-leading in the same list — it creates uneven visual rhythm. |
| Handle the empty case in the parent before rendering `RdsList`. | Pass an empty `items` list and expect a visible empty state — `RdsList` returns `SizedBox.shrink()`. |
