# Vertical Tabs

> The primary navigation strip for Reya SaaS products. Renders a vertical column of icon-and-label nav items with collapsible width, section dividers, and an optional pinned bottom section.

---

## When to use / when not to use

**Use when:**
- Providing top-level application navigation (the app shell nav strip described in `patterns.md`).
- There are 3–8 primary destinations in the product.
- The navigation must support both expanded (icon + label) and collapsed (icon-only) modes to reclaim screen space.

**Do not use when:**
- Switching between sibling content panes within a single page — use `RdsTabs` (horizontal) instead.
- You need a hamburger/drawer navigation on small screens — use Flutter's `Drawer` widget.
- There are fewer than 2 navigation destinations — a simple button is sufficient.

---

## Anatomy

```
Expanded (220px):                Collapsed (64px):
┌────────────────────┐           ┌──────┐
│ ▣ Dashboard        │ ← selected│  ▣   │ ← selected (3px left bar)
│   Patients         │           │  👤  │
│   Schedule         │           │  📅  │
│   Reports       [3]│ ← badge   │  📊  │
│   ─────────────────│ ← divider │  ──  │
│   Settings         │           │  ⚙   │
└────────────────────┘           └──────┘
  ^1    ^2    ^3        ^4        ^5
```

| Part | Description |
|---|---|
| 1. Container | `surfaceVariant` background, `outlineVariant` right border. Width animates between 64px (collapsed) and 220px (expanded). |
| 2. Nav item | 48px tall, full-width tap target. Contains icon, optional label, optional badge. |
| 3. Left accent bar | 3px `primary`-colored bar, full item height minus 4px top/bottom, `radiusFull` corners. Visible on selected item only. |
| 4. Section divider | 1px `outlineVariant` horizontal rule between groups of nav items. |
| 5. Badge | Small `primary`-filled pill showing a count or short string. Overlaid top-right of the icon. |
| 6. Bottom section | Divider + pinned items (e.g. Settings, Profile) fixed to the bottom of the strip. |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| `withLabels` (expanded) | Icon (24px) + label side by side. Width 220px. | Default desktop expanded state. |
| `labelsOnly` | Label only — icon hidden. | Rare; when icons are unhelpful or space permits only text. |
| `iconOnly` (collapsed) | Icon only, centered. Width 64px. Label shown in `Tooltip` on hover. | Collapsed state; triggered automatically when `collapsed: true`. |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `items` | `List<RdsVerticalTabItem>` | required | Main nav items. |
| `selectedIndex` | `int` | required | Index of the selected main item. |
| `onChanged` | `ValueChanged<int>` | required | Called with new index when a main item is tapped. |
| `iconMode` | `RdsVerticalTabIconMode` | `RdsVerticalTabIconMode.withLabels` | Controls icon/label display. Overridden to `iconOnly` when `collapsed: true`. |
| `collapsed` | `bool` | `false` | When true, forces `iconOnly` mode and animates width to 64px. |
| `dividerAfterIndices` | `List<int>` | `[]` | Indices of main items after which a section divider is inserted. |
| `bottomItems` | `List<RdsVerticalTabItem>` | `[]` | Items pinned to the bottom of the strip. |
| `bottomSelectedIndex` | `int?` | `null` | Index of selected bottom item, if any. |
| `onBottomChanged` | `ValueChanged<int>?` | `null` | Called when a bottom item is tapped. |

### RdsVerticalTabItem fields

| Field | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | required | Nav destination label. Used for semantics and tooltip. |
| `icon` | `IconData` | required | Icon for this nav item. |
| `disabled` | `bool` | `false` | Non-interactive; rendered at `opacity-disabled`. |
| `badge` | `String?` | `null` | Short count/label shown as pill overlay on the icon. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled (unselected) | Default | Transparent background, `onSurfaceVariant` icon and label. | `color-on-surface-variant` |
| Enabled (selected) | `selectedIndex` matches | `primaryContainer` fill, `onPrimaryContainer` icon/label, 3px `primary` left bar. | `color-primary-container`, `color-on-primary-container`, `color-primary` |
| Hover | Pointer enter | Semi-transparent `onSurface` overlay over the item background. | `state-hover` × `color-on-surface` |
| Focus | Keyboard focus | 2px `primary` border around the item. | `state-focus`; `color-primary` |
| Pressed | Tap / click down | Darker overlay. | `state-pressed` × `color-on-surface` |
| Disabled | `RdsVerticalTabItem.disabled = true` | Dimmed at `opacity-disabled`; not interactive. | `opacity-disabled` |

---

## Sizes

| Element | Value | Token |
|---|---|---|
| Strip width — expanded | 220px | Fixed (matches `patterns.md`) |
| Strip width — collapsed | 64px | Fixed |
| Item height | 48px | Fixed |
| Icon size | 24px | `icon-lg` |
| Left accent bar width | 3px | Fixed |
| Horizontal item padding | `space-2` (8px) | `space-2` |
| Vertical item padding between items | `space-1` (4px) | `space-1` |

---

## Tokens used

**Colors**
- `color-surface-variant` — strip background
- `color-outline-variant` — right border; section divider; bottom pinned divider
- `color-primary-container` — selected item fill
- `color-on-primary-container` — selected item icon/label
- `color-primary` — left accent bar; badge fill; focus ring
- `color-on-primary` — badge text
- `color-on-surface` — state layer color
- `color-on-surface-variant` — unselected item icon/label

**Typography**
- `label-large` — nav item label

**Spacing**
- `space-1` — vertical gap between items; badge vertical padding
- `space-2` — strip horizontal padding; section divider vertical rhythm
- `space-3` — item internal horizontal padding (icon-to-content)

**Radius**
- `radius-md` — item background border radius (selected state)
- `radius-full` — accent bar ends; badge pill

**Motion**
- `motion-duration-emphasized` — strip width transition (collapsed ↔ expanded)
- `motion-duration-standard` — per-item fill/color transition
- `motion-curve-emphasized` — strip width easing
- `motion-curve-standard` — item state easing

**Opacity**
- `opacity-disabled` — disabled item dim

---

## Behavior & interaction

### Mouse / touch
- Tapping an enabled item calls `onChanged` with the item's index.
- When collapsed, hovering over an item shows a Flutter `Tooltip` with the item label.
- Disabled items do not respond to taps.

### Keyboard
- `Tab` navigates between interactive items.
- `Enter` or `Space` activates the focused item.
- Arrow keys are not implemented at widget level (consumer may add if needed).

### Focus management
- Each item is focusable via Flutter's `Focus` widget.
- Focus ring is a 2px `primary`-colored border on the item.

### Animation
- **Width transition:** `AnimatedContainer` transitions between `_kCollapsedWidth` (64px) and `_kExpandedWidth` (220px) using `durationEmphasized` + `curveEmphasized`.
- **Item state:** `AnimatedContainer` transitions fill color using `durationStandard` + `curveStandard`.
- `MediaQuery.disableAnimations` is respected — `durationInstant` used when true.

### Collapse/expand
- When `collapsed` switches to `true`, the strip width animates to 64px and labels fade out.
- Item tap targets remain full height (48px) at all widths.

---

## Accessibility

- **Semantics:** Each item wraps in `Semantics(selected: isSelected, button: true, label: item.label, enabled: !item.disabled)`. Screen readers announce "Label, button, selected/not selected".
- **Min touch target:** 48px × full strip width (minimum 64px). Exceeds the 44×44px minimum.
- **Contrast:** `color-on-primary-container` on `color-primary-container` (selected) passes AA. `color-on-surface-variant` on `color-surface-variant` (unselected) passes AA.
- **Screen reader:** Announces label + role + selection state. In collapsed mode tooltip is a Flutter `Tooltip` (visible on hover) but semantic label is always present.
- **Keyboard:** Fully keyboard-operable. No pointer required.

---

## Content guidelines

- **Label:** 1–2 words, Title Case. Represent destinations, not actions (e.g. "Patients" not "View Patients").
- **Icon:** Must clearly represent the destination. Use `RdsIcons` or Material Symbols outlined variants.
- **Badge:** Short string only — a number (max "99+") or a 3-letter word ("NEW"). Avoid long strings.
- **Count:** 3–8 main items. Groups (sections) should be logically cohesive.

---

## Composition

**Uses:**
- Primitive Flutter widgets only (`AnimatedContainer`, `InkWell`, `MouseRegion`, `Tooltip`, `Semantics`).

**Used by:**
- App shell (`patterns.md`) — the vertical nav strip is `RdsVerticalTabs`.
- Every product page that uses the standard app shell layout.

---

## Flutter API

### Widget class
`RdsVerticalTabs`

### Constructor
```dart
const RdsVerticalTabs({
  super.key,
  required List<RdsVerticalTabItem> items,
  required int selectedIndex,
  required ValueChanged<int> onChanged,
  RdsVerticalTabIconMode iconMode = RdsVerticalTabIconMode.withLabels,
  bool collapsed = false,
  List<int> dividerAfterIndices = const [],
  List<RdsVerticalTabItem> bottomItems = const [],
  int? bottomSelectedIndex,
  ValueChanged<int>? onBottomChanged,
});
```

### Public enums

```dart
enum RdsVerticalTabIconMode {
  withLabels,
  labelsOnly,
  iconOnly,
}
```

### RdsVerticalTabItem class

```dart
class RdsVerticalTabItem {
  const RdsVerticalTabItem({
    required String label,
    required IconData icon,
    bool disabled = false,
    String? badge,
  });
}
```

### Example usage

```dart
// Standard app shell nav strip
int _navIndex = 0;
bool _collapsed = false;

RdsVerticalTabs(
  items: const [
    RdsVerticalTabItem(label: 'Dashboard', icon: Symbols.dashboard),
    RdsVerticalTabItem(label: 'Patients', icon: Symbols.person),
    RdsVerticalTabItem(label: 'Schedule', icon: Symbols.calendar_today),
    RdsVerticalTabItem(label: 'Reports', icon: Symbols.bar_chart, badge: '3'),
  ],
  selectedIndex: _navIndex,
  onChanged: (i) => setState(() => _navIndex = i),
  collapsed: _collapsed,
  dividerAfterIndices: const [3],
  bottomItems: const [
    RdsVerticalTabItem(label: 'Settings', icon: Symbols.settings),
  ],
  bottomSelectedIndex: null,
  onBottomChanged: (i) { /* navigate to settings */ },
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | All knobs active. Shows the strip on the left with a content placeholder on the right. Demonstrates all modes and collapse toggle. |
| `Gallery` | Three strips side by side — expanded (withLabels), collapsed (iconOnly), and labelsOnly. Tabs are interactive. |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `Collapsed` | boolean | `collapsed` | `true`, `false` |
| `Icon mode` | list | `iconMode` | `withLabels`, `labelsOnly`, `iconOnly` |
| `Selected index` | int input | `selectedIndex` | 0–4 |

---

## Do / Don't

| Do | Don't |
|---|---|
| Use `RdsVerticalTabs` for top-level app navigation only. | Use vertical tabs as a secondary tab bar inside a page. |
| Keep labels to 1–2 words in Title Case. | Write long labels that overflow in the expanded strip. |
| Provide `dividerAfterIndices` to group related items. | List all items in one unseparated block when logical grouping exists. |
| Use `badge` for unread counts or status indicators. | Put decorative or non-actionable information in badges. |
