# Tabs

> A horizontal tab bar that lets users switch between related views within the same page context. Tabs are one of the most common navigation and content-organization patterns in Reya SaaS products.

---

## When to use / when not to use

**Use when:**
- Switching between two or more sibling content panes within a single page (e.g. patient profile sections: Overview, Lab Results, Appointments, Notes).
- The number of tabs is between 2 and 7; beyond 7 the bar becomes too wide.
- All tabs are related to the same subject or task.
- Users need to jump freely between views without losing their place in other tabs.

**Do not use when:**
- There are more than 7 tabs — use a `RdsVerticalTabs` strip or nested navigation instead.
- Tabs represent sequential steps — use a stepper/progress indicator instead.
- The tabs would navigate to completely different pages — use `RdsVerticalTabs` or the top-level router.
- You need to show/hide a single optional panel — use an accordion or sheet.

---

## Anatomy

```
Primary variant:
┌──────────────────────────────────────────────────────────┐
│  Overview   Lab Results   Schedule   Notes   Disabled    │  ← tab row
│  ─────────                                               │  ← selected indicator (3px, primary)
└──────────────────────────────────────────────────────────┘
  ^1            ^2                              ^5

Secondary variant:
┌──────────────────────────────────────────────────────────┐
│ ┌───────────┐  Lab Results   Schedule   Notes   Disabled │
│ │ Overview  │                                            │  ← selected pill
│ └───────────┘                                            │
└──────────────────────────────────────────────────────────┘
     surfaceContainer container (pill) wraps all tabs
```

| Part | Description |
|---|---|
| 1. Tab item | Interactive region for a single tab. Contains label and/or icon. 48px tall (primary) / 36px tall (secondary). |
| 2. Selected indicator (primary) | 3px bottom bar in `color-primary`. Appears under the selected tab. |
| 3. Selected fill (secondary) | `color-primary-container` rounded-rect background on the active tab. |
| 4. Container (secondary) | `color-surface-container` pill wrapping all secondary tabs. |
| 5. Disabled tab | Rendered at `opacity-disabled`. Not interactive. |
| 6. Icon (optional) | `icon-md` (20px) — shown left of label (`leading`) or in place of label (`iconOnly`). |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| `primary` | Plain surface background; selected tab has a 3px `primary` bottom bar and `primary`-colored label; divider line runs the full width. | Default — page-level content switching, detail views, dashboard sections. |
| `secondary` | All tabs sit inside a `surfaceContainer` pill container; selected tab has a `primaryContainer` filled pill. | Embedded within a card or panel, or as a compact filter control. |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `tabs` | `List<RdsTabItem>` | required | Ordered list of tab data. |
| `selectedIndex` | `int` | required | Index of the currently active tab. Controlled externally. |
| `onChanged` | `ValueChanged<int>` | required | Callback fired with the tapped tab's index. |
| `variant` | `RdsTabVariant` | `RdsTabVariant.primary` | Primary (underline) or secondary (pill fill). |
| `iconMode` | `RdsTabIconMode` | `RdsTabIconMode.none` | Whether to show icons, and where. |

### RdsTabItem fields

| Field | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | required | Display text. Always required for accessibility. |
| `icon` | `IconData?` | `null` | Icon data. Required when `iconMode` is not `none`. |
| `disabled` | `bool` | `false` | Disables the tab — uninteractive, dimmed. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled (unselected) | Default | `onSurfaceVariant` label; no indicator. | `color-on-surface-variant` |
| Enabled (selected) | `selectedIndex` matches | Primary: bottom bar + `primary` label. Secondary: `primaryContainer` fill + `onPrimaryContainer` label. | `color-primary`, `color-primary-container`, `color-on-primary-container` |
| Hover | Pointer enter | Semi-transparent `onSurface` overlay. | `state-hover` × `color-on-surface` |
| Focus | Keyboard focus | Focus ring outline (2px `primary`). | `state-focus`; `color-primary` |
| Pressed | Tap / click down | Darker overlay. | `state-pressed` × `color-on-surface` |
| Disabled | `RdsTabItem.disabled = true` | Dimmed at `opacity-disabled`; cursor indicates non-interactive. | `opacity-disabled` |

---

## Sizes

| Variant | Height | H-padding | Font style | Icon size |
|---|---|---|---|---|
| Primary | 48px | `space-4` (16px) | `label-large` | `icon-md` (20px) |
| Secondary (each pill) | 36px | `space-3` (12px) | `label-large` | `icon-md` (20px) |
| Secondary (outer container) | 44px (includes `space-1` inner padding) | `space-1` | — | — |

---

## Tokens used

**Colors**
- `color-primary` — selected indicator bar (primary variant); focus ring color
- `color-primary-container` — selected fill (secondary variant)
- `color-on-primary-container` — selected label/icon color (secondary variant)
- `color-surface` — tab bar background (primary variant)
- `color-surface-container` — outer pill container (secondary variant)
- `color-on-surface` — state layer overlay color
- `color-on-surface-variant` — unselected label/icon color
- `color-outline-variant` — bottom border (primary variant)

**Typography**
- `label-large` — tab label text

**Spacing**
- `space-1` — icon-to-label gap; secondary container inner padding
- `space-2` — gap between secondary tabs
- `space-3` — secondary tab horizontal padding
- `space-4` — primary tab horizontal padding

**Radius**
- `radius-sm` — focus ring border radius (primary tab item)
- `radius-md` — secondary variant rounded rect (tab pills)
- `radius-full` — secondary outer container pill; top corners of indicator bar

**Motion**
- `motion-duration-standard` — indicator / fill color transition
- `motion-curve-standard` — easing for indicator transition

**Opacity**
- `opacity-disabled` — disabled tab dim

---

## Behavior & interaction

### Mouse / touch
- Tapping an enabled tab calls `onChanged` with the new index. The consumer is responsible for updating `selectedIndex`.
- Disabled tabs do not respond to taps.
- On overflow the tab row scrolls horizontally via `SingleChildScrollView`.

### Keyboard
- `Tab` moves focus between interactive tab items.
- `Enter` or `Space` activates the focused tab.
- Arrow keys are not implemented at the widget level (consumer can add them via `FocusNode` if needed).

### Focus management
- Each tab item is individually focusable via Flutter's `Focus` widget.
- Focus is visible as a 2px `primary`-colored border around the tab item.

### Animation
- **Primary variant:** indicator bar height animates `0 → 3px` (or reverse) using `AnimatedContainer` with `durationStandard` + `curveStandard`.
- **Secondary variant:** fill color and border animate using `AnimatedContainer` with `durationStandard`.
- `MediaQuery.disableAnimations` is respected — when true, `durationInstant` is used.

---

## Accessibility

- **Semantics:** Each tab item wraps content in `Semantics(selected: isSelected, button: true, label: item.label, enabled: !item.disabled)`. Screen readers announce the label, role, and selection state.
- **Min touch target:** 48px height for primary tabs; secondary tabs are 36px tall but sit inside a 44px outer container.
- **Contrast:** `color-primary` on `color-surface` (primary selected) passes AA. `color-on-primary-container` on `color-primary-container` passes AA.
- **Screen reader:** VoiceOver/TalkBack announces "Tab name, tab, selected/unselected, N of N".
- **Keyboard:** Fully operable via Tab + Enter/Space. No pointer required.
- **Icon-only mode:** Tab label is used as `Semantics.label` and as a `Tooltip` message for sighted mouse users.

---

## Content guidelines

- **Label:** Title case, max 20 characters per tab. Avoid verbs — prefer nouns (e.g. "Overview" not "View Overview").
- **Icon:** Use icons that unambiguously represent the tab content. Pair with label unless screen space is extremely tight.
- **Count:** 2–7 tabs. Fewer is better. If you have more than 5 consider restructuring the IA.
- **Truncation:** Labels truncate with ellipsis if the container is narrower than the text. Prefer short labels to avoid this.

---

## Composition

**Uses:**
- Primitive Flutter widgets only — no RDS component dependencies.

**Used by:**
- Patient detail page — "Overview | Lab Results | Appointments | Notes" tab bar.
- Dashboard detail cards — embedded content switcher.
- Any page following the "Detail / Profile Page" template in `patterns.md`.

---

## Flutter API

### Widget class
`RdsTabs`

### Constructor
```dart
const RdsTabs({
  super.key,
  required List<RdsTabItem> tabs,
  required int selectedIndex,
  required ValueChanged<int> onChanged,
  RdsTabVariant variant = RdsTabVariant.primary,
  RdsTabIconMode iconMode = RdsTabIconMode.none,
});
```

### Public enums

```dart
enum RdsTabVariant {
  primary,
  secondary,
}

enum RdsTabIconMode {
  none,
  leading,
  iconOnly,
}
```

### RdsTabItem class

```dart
class RdsTabItem {
  const RdsTabItem({
    required String label,
    IconData? icon,
    bool disabled = false,
  });
}
```

### Example usage

```dart
// Stateful parent
int _selectedIndex = 0;

RdsTabs(
  tabs: const [
    RdsTabItem(label: 'Overview'),
    RdsTabItem(label: 'Lab Results'),
    RdsTabItem(label: 'Schedule', disabled: true),
  ],
  selectedIndex: _selectedIndex,
  onChanged: (i) => setState(() => _selectedIndex = i),
)

// Secondary variant with icons
RdsTabs(
  variant: RdsTabVariant.secondary,
  iconMode: RdsTabIconMode.leading,
  tabs: const [
    RdsTabItem(label: 'All', icon: Symbols.list),
    RdsTabItem(label: 'Active', icon: Symbols.check_circle),
    RdsTabItem(label: 'Archived', icon: Symbols.archive),
  ],
  selectedIndex: _selectedIndex,
  onChanged: (i) => setState(() => _selectedIndex = i),
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | All knobs active. Shows tabs above a placeholder content area. `selectedIndex` is controlled by the knob (display-only). |
| `Gallery` | Both variants × all three icon modes rendered in a scrollable column. Tabs are interactive so you can tap to see state changes. |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `Variant` | list | `variant` | `primary`, `secondary` |
| `Icon mode` | list | `iconMode` | `none`, `leading`, `iconOnly` |
| `Selected index` | int input | `selectedIndex` | 0–4 |

---

## Do / Don't

| Do | Don't |
|---|---|
| Keep tab labels short (1–2 words). | Write long sentences as tab labels. |
| Use `primary` variant for page-level switching. | Use `secondary` tabs as the main page navigation. |
| Provide an icon for icon-only tabs (accessibility). | Use `iconOnly` mode without an `icon` on `RdsTabItem`. |
| Use `secondary` variant when embedding a tab bar inside a card. | Stack multiple primary tab bars on the same page. |
