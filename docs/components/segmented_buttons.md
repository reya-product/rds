# Segmented Buttons

> A connected outlined control for switching between mutually exclusive (or multi-select) options. Visually distinguishes the selected segment with a filled container.

---

## When to use / when not to use

**Use when:**
- Users must choose one option from a small, fixed set (2–5 items) — e.g. chart period, view layout, filter category.
- The available options are always visible (no overflow); you want a compact, inline selector.
- Single or multi-select filtering directly within a content area where a dropdown would be too heavyweight.

**Do not use when:**
- There are more than 5 options — the control becomes too wide. Use `RdsDropdown` or `RdsTabs` instead.
- The options represent distinct page-level views — use `RdsTabs` or `RdsVerticalTabs`.
- Selection triggers a significant action or side effect — use `RdsButtonGroup` with `selectionMode: single` where the unselected state is more visually distinct.
- Options are boolean (on/off) — use `RdsToggleSwitch`.

---

## Anatomy

```
┌───────────────────────────────────────────────────┐
│ ┌──────────────┬────────────────┬──────────────┐  │
│ │  ✓  Option A │   Option B     │   Option C   │  │
│ └──────────────┴────────────────┴──────────────┘  │
└───────────────────────────────────────────────────┘
     1      2          3                4            5
```

| Part | Description |
|---|---|
| 1. Outer border | Single shared `color-outline` border, `radius-md` corners, 1px width — wraps the entire control. |
| 2. Checkmark | `icon-md` (20px) checkmark icon shown on the selected segment when `showCheckmark: true`. Uses `color-on-primary-container`. |
| 3. Segment label | `label-large` text. `color-on-primary-container` when selected; `color-on-surface` when unselected. |
| 4. Segment icon (optional) | `icon-md` icon shown when `showIcons: true` and the segment has an icon. Same color logic as label. |
| 5. Internal divider | 1px `color-outline` vertical line between adjacent segments. |

---

## Variants

There is a single visual variant (outlined). Selection state drives the fill:

| State | Fill | Text / icon color |
|---|---|---|
| Unselected | Transparent | `color-on-surface` |
| Selected | `color-primary-container` | `color-on-primary-container` |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `segments` | `List<RdsSegment<T>>` | required | Ordered list of segment data. |
| `selectionMode` | `RdsButtonGroupSelectionMode` | `single` | `single` (one at a time) or `multi` (any number). `none` behaves like `single`. |
| `selected` | `Set<T>` | required | Currently selected segment values. |
| `onSelectionChanged` | `ValueChanged<Set<T>>?` | `null` | Called with the new value set on tap. |
| `showIcons` | `bool` | `true` | Whether to render a segment's icon when present. |
| `showCheckmark` | `bool` | `true` | Whether to prepend a checkmark to selected segments. |
| `disabled` | `bool` | `false` | Disables the entire control. |

### RdsSegment<T> fields

| Field | Type | Default | Description |
|---|---|---|---|
| `value` | `T` | required | The value identifying this segment in the `selected` set. |
| `label` | `String` | required | Display text. |
| `icon` | `IconData?` | `null` | Optional icon. |
| `disabled` | `bool` | `false` | Disables this specific segment. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled unselected | Default | Transparent fill, `color-on-surface` label | — |
| Enabled selected | Value in `selected` | `color-primary-container` fill, `color-on-primary-container` label + checkmark | `color-primary-container`, `color-on-primary-container` |
| Hover | Mouse over an interactive segment | State layer at 8% opacity over the segment's content color | `state-hover` |
| Focus | Keyboard focus | State layer at 12% opacity | `state-focus` |
| Pressed | Tap / click hold | State layer at 16% opacity | `state-pressed` |
| Disabled segment | `segment.disabled: true` | Segment at `opacity-disabled` (38%) | `opacity-disabled` |
| Disabled all | `disabled: true` | Entire control at `opacity-disabled` | `opacity-disabled` |

---

## Tokens used

**Colors**
- `color-primary-container` — fill for selected segments
- `color-on-primary-container` — label/icon/checkmark color for selected segments
- `color-on-surface` — label/icon color for unselected segments
- `color-outline` — outer border and internal dividers
- `state-hover` — hover state layer opacity
- `state-focus` — focus state layer opacity
- `state-pressed` — pressed state layer opacity
- `opacity-disabled` — disabled segment/control opacity

**Typography**
- `label-large` — segment label text (14px, weight 500)

**Spacing**
- `space-1` — gap between checkmark and icon, or between icon and label
- `space-2` — vertical padding
- `space-4` — horizontal padding

**Radius**
- `radius-md` — outer border-radius (8px)

**Motion**
- `motion-duration-standard` — fill and color transitions
- `motion-curve-standard` — easing for transitions

**Opacity**
- `opacity-disabled` — disabled state

---

## Behavior & interaction

### Mouse / touch
- Tapping a segment in `single` mode sets `selected = {tappedValue}`.
- Tapping a segment in `multi` mode toggles the tapped value in/out of the set.
- Tapping a disabled segment has no effect.
- Tapping an already-selected segment in `single` mode keeps it selected (no deselection).

### Keyboard
- `Tab` moves focus through each segment left-to-right.
- `Space` or `Enter` activates the focused segment.
- `Left`/`Right` arrow keys do not navigate segments (each is an independent focus node).

### Focus management
- Each segment is an independent `Focus` node.
- After activation, focus remains on the activated segment.

### Animation
- Fill color and label color transitions use `motion-duration-standard` (200ms) `motion-curve-standard` (ease-in-out).
- `motion-duration-instant` is used when `MediaQuery.disableAnimations` is true.

---

## Accessibility

- **Semantics:** The outer container has `Semantics(label: 'Segmented buttons')`. Each segment has `Semantics(button: true, selected: <bool>, enabled: <bool>, label: <segmentLabel>)`.
- **Min touch target:** 44 × 44px per segment enforced via `BoxConstraints(minHeight: 44, minWidth: 44)`.
- **Contrast:** `color-primary-container` / `color-on-primary-container` and unselected `color-on-surface` both meet WCAG AA.
- **Screen reader:** Each segment announces its label, role ("button"), and selected state.
- **Keyboard:** Fully operable via Tab + Space/Enter.

---

## Content guidelines

- **Labels:** 1–2 words. Noun or adjective form ("Month", "Active", "All"). Do not use verbs.
- **Parallel structure:** All segments in a control should follow the same grammatical form.
- **Length:** Keep labels at roughly equal lengths. If one label is significantly longer, consider abbreviating or switching to a dropdown.
- **Icons:** When icons are used, pair with labels for clarity unless the icons are universally understood (e.g. bold / italic / underline).

---

## Composition

**Uses:**
- Primitive — uses `RdsTheme` and `RdsIcons.check` directly. No other RDS component dependency.

**Used by:**
- Filter bars in dashboards and data views.
- View-switcher patterns in cards or panels.

---

## Flutter API

### Widget class
`RdsSegmentedButtons<T>`

### Constructor
```dart
const RdsSegmentedButtons({
  Key? key,
  required List<RdsSegment<T>> segments,
  RdsButtonGroupSelectionMode selectionMode = RdsButtonGroupSelectionMode.single,
  required Set<T> selected,
  ValueChanged<Set<T>>? onSelectionChanged,
  bool showIcons = true,
  bool showCheckmark = true,
  bool disabled = false,
});
```

### Public classes / enums

```dart
class RdsSegment<T> {
  const RdsSegment({
    required T value,
    required String label,
    IconData? icon,
    bool disabled = false,
  });
}
```

*(Also reuses `RdsButtonGroupSelectionMode` from `RdsButtonGroup`.)*

### Example usage

```dart
// Single-select period switcher
RdsSegmentedButtons<String>(
  segments: const [
    RdsSegment(value: '7d',  label: '7 days'),
    RdsSegment(value: '30d', label: '30 days'),
    RdsSegment(value: '90d', label: '90 days'),
  ],
  selected: {'30d'},
  onSelectionChanged: (next) => setState(() => _period = next),
)

// Multi-select filter with icons
RdsSegmentedButtons<String>(
  segments: [
    RdsSegment(value: 'active',   label: 'Active',   icon: RdsIcons.success),
    RdsSegment(value: 'pending',  label: 'Pending',  icon: RdsIcons.warning),
    RdsSegment(value: 'archived', label: 'Archived', icon: RdsIcons.info),
  ],
  selectionMode: RdsButtonGroupSelectionMode.multi,
  selected: {'active', 'pending'},
  onSelectionChanged: (next) => setState(() => _status = next),
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | All props as knobs; interactive sandbox |
| `Gallery` | Single-select, multi-select, with/without icons, with/without checkmark |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `Selection mode` | list | `selectionMode` | `single`, `multi` |
| `Show icons` | boolean | `showIcons` | `true` |
| `Show checkmark` | boolean | `showCheckmark` | `true` |
| `Disabled` | boolean | `disabled` | `false` |

---

## Do / Don't

| Do | Don't |
|---|---|
| Use 2–5 segments with short (≤ 2-word) labels | Use 6+ segments — the control will be too wide on mobile |
| Use `single` mode for mutually exclusive period/view selectors | Leave no segment selected in `single` mode (always initialise with at least one value in `selected`) |
| Show icons consistently — either all segments have icons or none | Mix icon-bearing and icon-less segments in the same control |
| Use `multi` mode for filter chips that can overlap (e.g. status filters) | Use `multi` mode when only one option can logically apply — use `single` instead |
