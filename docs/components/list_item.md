# List Item

> A configurable row widget that composes text, a leading control, a trailing control, and an optional badge into a single interactive or static list row.

---

## When to use / when not to use

**Use when:**
- Rendering items in a scrollable list, menu, or data panel where each row shares the same structural template.
- A row needs an optional leading control (avatar, icon, checkbox, radio, or toggle) and/or a trailing control of the same types.
- Rows must support selected, disabled, or tappable states in a uniform way.
- Building higher-level list-based components (Dropdown popup, Multi-select input, Single-select input, Toggle list input) that need a standardised row primitive.

**Do not use when:**
- The row structure is entirely bespoke and shares no anatomy with the standard slot model — build a custom `Row` instead.
- You need a card-style layout with imagery, charts, or arbitrary children — use `RdsCard`.
- You need a navigation drawer tile — use the app-shell navigation pattern defined in `docs/patterns.md`.

---

## Anatomy

```
┌─────────────────────────────────────────────────────────────┐
│  ①leading  ②badge-top (aboveOverline)                       │
│            ③overline text (UPPERCASE)          ④trailing    │
│            ⑤primary text                                    │
│            ⑥badge-mid (belowPrimaryAboveSupporting)         │
│            ⑦supporting text                                 │
│            ⑧badge-bottom (belowSupporting)                  │
└─────────────────────────────────────────────────────────────┘
```

| Part | Description |
|---|---|
| 1. Leading zone | 40 px wide slot flush left. Renders an icon, avatar, checkbox, radio, or toggle switch. Hidden when `leading` is `none`. |
| 2. Badge (above overline) | Optional `RdsBadge` placed before the overline when `badgePosition` is `aboveOverline`. |
| 3. Overline | Micro-label rendered in UPPERCASE with `label-small`. Hidden when `overline` is null. |
| 4. Trailing zone | 40 px wide slot flush right. Same slot type options as leading. Hidden when `trailing` is `none`. |
| 5. Primary text | Required main label. Rendered with `body-large`. |
| 6. Badge (between) | Optional `RdsBadge` between primary and supporting text when `badgePosition` is `belowPrimaryAboveSupporting`. |
| 7. Supporting text | Optional secondary line. Rendered with `body-medium`. Hidden when `supportingText` is null. |
| 8. Badge (below supporting) | Optional `RdsBadge` below supporting text when `badgePosition` is `belowSupporting`. |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| Text only | `primaryText` displayed alone, no slots | Minimal content lists |
| With leading icon | Icon in the left 40 px zone | Action menus, settings lists |
| With leading avatar | Circular avatar in the left 40 px zone | Contact lists, patient lists |
| With leading checkbox | Checkbox in the left slot | Multi-select lists |
| With leading radio | Radio button in the left slot | Single-select lists |
| With leading toggle | Toggle switch in the left slot | Feature enable/disable lists |
| With trailing (all types) | Same six options on the right | Controls at the right edge |
| Three-line | Overline + primary + supporting | Rich metadata rows |
| With badge | Any of the four badge positions | Status or categorisation annotation |
| Selected | `primaryContainer` background, `primary` accent | Indicating current selection |
| Disabled | `opacity-disabled` applied globally | Non-interactive context |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `primaryText` | `String` | required | Main label displayed with `body-large`. |
| `overline` | `String?` | `null` | UPPERCASE micro-label above `primaryText`. Hidden when null. |
| `supportingText` | `String?` | `null` | Secondary line below `primaryText`. Hidden when null. |
| `leading` | `RdsListItemLeading` | `none` | Type of widget in the leading slot. |
| `trailing` | `RdsListItemTrailing` | `none` | Type of widget in the trailing slot. |
| `badgePosition` | `RdsListItemBadgePosition` | `none` | Where to place the badge within the text block. |
| `badge` | `RdsBadgeConfig?` | `null` | Badge configuration. Required when `badgePosition` is not `none`. |
| `leadingIcon` | `IconData?` | `null` | Icon shown when `leading` is `icon`. |
| `trailingIcon` | `IconData?` | `null` | Icon shown when `trailing` is `icon`. |
| `leadingAvatar` | `RdsAvatarConfig?` | `null` | Avatar config when `leading` is `avatar`. |
| `trailingAvatar` | `RdsAvatarConfig?` | `null` | Avatar config when `trailing` is `avatar`. |
| `checkboxValue` | `bool?` | `null` | Current value for a checkbox in leading or trailing. |
| `onCheckboxChanged` | `ValueChanged<bool?>?` | `null` | Callback fired when the checkbox changes. |
| `radioValue` | `dynamic` | `null` | Value this radio button represents. |
| `radioGroupValue` | `dynamic` | `null` | Currently selected value in the radio group. |
| `onRadioChanged` | `ValueChanged?` | `null` | Callback fired when this radio is selected. |
| `toggleValue` | `bool` | `false` | Current on/off value for a toggle switch. |
| `onToggleChanged` | `ValueChanged<bool>?` | `null` | Callback fired when the toggle changes. |
| `onTap` | `VoidCallback?` | `null` | Tap handler. When non-null the row becomes interactive with hover/press overlays. |
| `selected` | `bool` | `false` | Shows `primaryContainer` background; accents overline and leading icon with `primary`. |
| `enabled` | `bool` | `true` | When `false`, applies `opacity-disabled` to the row and blocks all interaction. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled | Default | Normal appearance | — |
| Hover | Pointer enters row (only when `onTap` is non-null) | Semi-transparent overlay on `onSurface` | `state-hover` (0.08) |
| Pressed | Tap / click down | Darker overlay on `onSurface` | `state-pressed` (0.16) |
| Selected | `selected: true` | Background switches to `primaryContainer`; overline and leading icon tinted `primary` | `color-primary-container`, `color-primary` |
| Disabled | `enabled: false` | Full row at `opacity-disabled`; interaction blocked | `opacity-disabled` (0.38) |

---

## Sizes

List Item has no named size variants. The row height is content-driven with a minimum of 56 px enforced by `ConstrainedBox`. Height grows naturally when text wraps or multiple text lines are shown.

| Dimension | Value | Token |
|---|---|---|
| Min height | 56 px | hardcoded constraint |
| Vertical padding | 12 px | `space-3` |
| Horizontal padding | 16 px | `space-4` |
| Leading / trailing zone width | 40 px | fixed |
| Gap between zone and text | 12 px | `space-3` |

---

## Tokens used

**Colors**
- `color-surface` — default row background
- `color-primary-container` — selected row background
- `color-primary` — selected overline text and leading icon tint
- `color-on-surface` — primary text color; state-layer base color
- `color-on-surface-variant` — supporting text color
- `color-on-surface-muted` — overline text (default); trailing icon color
- `color-outline-variant` — divider between rows (applied by the parent list)

**Typography**
- `label-small` — overline text (11 px, weight 500, UPPERCASE)
- `body-large` — primary text (16 px, weight 400)
- `body-medium` — supporting text (14 px, weight 400)

**Spacing**
- `space-1` — gap between badge and adjacent text line (4 px)
- `space-3` — vertical padding and gap between slot and text (12 px)
- `space-4` — horizontal padding (16 px)

**Opacity / state layers**
- `state-hover` (0.08) — hover overlay opacity
- `state-pressed` (0.16) — press overlay opacity
- `opacity-disabled` (0.38) — disabled row opacity

**Motion**
- `motion-duration-standard` — background and overlay transitions (200 ms)
- `motion-curve-standard` — easing for animated transitions

---

## Behavior & interaction

### Mouse / touch
- When `onTap` is non-null and `enabled` is true, the full row is a hit target.
- Pointer enter triggers the hover state layer (8 % onSurface overlay).
- Tap down triggers the pressed state layer (16 % onSurface overlay).
- Releasing fires `onTap`.
- Controls (checkbox, radio, toggle) embedded in the leading or trailing slot respond to their own tap area independently — tapping the control fires its callback; tapping elsewhere in the row fires `onTap`.

### Keyboard
- `Tab` / `Shift+Tab` moves focus to the row's interactive zone and to any embedded control.
- `Space` / `Enter` activates `onTap` when the row itself is focused.
- Embedded checkboxes and toggles can be toggled with `Space` when focused; radios fire on `Space`.

### Focus management
- Row focus is managed by Flutter's `Focus` widget (applied via `InkWell` / `GestureDetector` chain).
- Embedded controls own their own `Focus` nodes and do not interfere with row-level focus.

### Animation
- Background color change (default ↔ selected ↔ disabled) animated with `motion-duration-standard` / `motion-curve-standard`.
- State layer appears immediately (no entry animation) and fades out on pointer exit.

---

## Accessibility

- **Semantics:** `Semantics(button: onTap != null, selected: selected, enabled: enabled, label: primaryText)` wraps the entire row.
- **Min touch target:** The row itself is at least 56 px tall. Embedded controls (checkbox, radio, toggle) maintain their own 44 × 44 px touch targets via their respective widgets.
- **Contrast:** `body-large` on `surface` — `onSurface` (#111827) on white (#FFFFFF) ≥ 12:1. `label-small` on `surface` — `onSurfaceMuted` (#9CA3AF) on white ≥ 2.7:1 (decorative overline, not primary content). `primary` on `primaryContainer` — verified AA.
- **Screen reader:** Announces `primaryText` as the label; `button` role when tappable; `selected` state exposed for selection lists.
- **Keyboard:** Fully operable via keyboard when `onTap` is set. Embedded controls are individually focusable and operable.

---

## Content guidelines

- **Primary text:** Sentence case. Keep to 1–2 lines (capped at 2 with ellipsis truncation). Avoid ending with punctuation unless it is a full sentence.
- **Overline:** ALL CAPS. Maximum ~3 words (category label, status, type). Do not repeat information already in `primaryText`.
- **Supporting text:** Full sentences or key metadata. Keep to 1–2 lines. Do not use to re-state `primaryText`.
- **Badge label:** Short (1–3 words). Status badges should use consistent labels (e.g. "Active", "Pending", "New") across the application.
- **Truncation:** Both `primaryText` and `supportingText` clamp to 2 lines with `TextOverflow.ellipsis`.

---

## Composition

**Uses:**
- `RdsAvatar` — renders the avatar variant in leading or trailing slots.
- `RdsBadge` — renders the badge at the configured position.
- `RdsCheckbox` — renders the checkbox variant in leading or trailing slots.
- `RdsRadio` — renders the radio variant in leading or trailing slots.
- `RdsToggleSwitch` — renders the toggle variant in leading or trailing slots.

**Used by:**
- `RdsList` (T2b) — wraps multiple `RdsListItem` rows with optional dividers.
- `RdsDropdownPopup` (T2b) — each option is an `RdsListItem` row.
- `RdsMultiSelectInput` (T2b) — uses `RdsListItem` with leading checkbox.
- `RdsSingleSelectInput` (T2b) — uses `RdsListItem` with leading radio or selected state.
- `RdsToggleListInput` (T2b) — uses `RdsListItem` with trailing toggle.

---

## Flutter API

### Widget class
`RdsListItem`

### Constructor
```dart
const RdsListItem({
  super.key,
  required String primaryText,
  String? overline,
  String? supportingText,
  RdsListItemLeading leading = RdsListItemLeading.none,
  RdsListItemTrailing trailing = RdsListItemTrailing.none,
  RdsListItemBadgePosition badgePosition = RdsListItemBadgePosition.none,
  RdsBadgeConfig? badge,
  IconData? leadingIcon,
  IconData? trailingIcon,
  RdsAvatarConfig? leadingAvatar,
  RdsAvatarConfig? trailingAvatar,
  bool? checkboxValue,
  ValueChanged<bool?>? onCheckboxChanged,
  dynamic radioValue,
  dynamic radioGroupValue,
  ValueChanged? onRadioChanged,
  bool toggleValue = false,
  ValueChanged<bool>? onToggleChanged,
  VoidCallback? onTap,
  bool selected = false,
  bool enabled = true,
});
```

### Public enums

```dart
enum RdsListItemLeading { none, icon, avatar, checkbox, radio, toggle }

enum RdsListItemTrailing { none, icon, avatar, checkbox, radio, toggle }

enum RdsListItemBadgePosition {
  none,
  aboveOverline,
  belowPrimaryAboveSupporting,
  belowSupporting,
}
```

### Config data classes

```dart
class RdsAvatarConfig {
  final RdsAvatarType type;
  final String? imageUrl;
  final IconData? icon;
  final String? name;
  final RdsAvatarSize size;       // default: RdsAvatarSize.md
  final Color? backgroundColor;
}

class RdsBadgeConfig {
  final String label;
  final RdsBadgeIconMode iconMode; // default: RdsBadgeIconMode.none
  final IconData? icon;
  final RdsBadgeColor color;       // default: RdsBadgeColor.neutral
  final RdsBadgeSize size;         // default: RdsBadgeSize.medium
}
```

### Example usage

```dart
// 1. Simple tappable text row
RdsListItem(
  primaryText: 'Account settings',
  trailing: RdsListItemTrailing.icon,
  trailingIcon: RdsIcons.chevronRight,
  onTap: () => Navigator.push(context, ...),
)

// 2. Contact row with avatar, badge, and supporting text
RdsListItem(
  overline: 'Clinician',
  primaryText: 'Dr. Amanda Shah',
  supportingText: 'Longevity & preventive care',
  leading: RdsListItemLeading.avatar,
  leadingAvatar: RdsAvatarConfig(
    type: RdsAvatarType.initials,
    name: 'Amanda Shah',
  ),
  trailing: RdsListItemTrailing.icon,
  trailingIcon: RdsIcons.chevronRight,
  badgePosition: RdsListItemBadgePosition.aboveOverline,
  badge: RdsBadgeConfig(label: 'Available', color: RdsBadgeColor.success),
  onTap: () {},
)

// 3. Multi-select row
RdsListItem(
  primaryText: 'Send weekly digest',
  leading: RdsListItemLeading.checkbox,
  checkboxValue: _checked,
  onCheckboxChanged: (v) => setState(() => _checked = v ?? false),
  onTap: () => setState(() => _checked = !_checked),
)

// 4. Feature toggle row
RdsListItem(
  primaryText: 'Dark mode',
  supportingText: 'Switch between light and dark themes',
  leading: RdsListItemLeading.icon,
  leadingIcon: RdsIcons.settings,
  trailing: RdsListItemTrailing.toggle,
  toggleValue: _darkMode,
  onToggleChanged: (v) => setState(() => _darkMode = v),
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | Knob-driven sandbox for every prop. Renders one item in a card container. |
| `Leading variants` | Static gallery of all six leading slot types, each with primary + supporting text. |
| `Trailing variants` | Static gallery of all six trailing slot types. |
| `Badge positions` | All four badge position values rendered in sequence. |
| `States` | Enabled, selected, disabled, hover simulation, minimal, and three-line variants. |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `Leading` | list | `leading` | All `RdsListItemLeading` values |
| `Trailing` | list | `trailing` | All `RdsListItemTrailing` values |
| `Badge position` | list | `badgePosition` | All `RdsListItemBadgePosition` values |
| `Primary text` | string | `primaryText` | Free text |
| `Overline (empty = none)` | string | `overline` | Free text; empty string treated as `null` |
| `Supporting text (empty = none)` | string | `supportingText` | Free text; empty string treated as `null` |
| `Selected` | boolean | `selected` | `true` / `false` |
| `Enabled` | boolean | `enabled` | `true` / `false` |

---

## Do / Don't

| Do | Don't |
|---|---|
| Use `onTap` on the row AND separate callbacks on embedded controls so both interactions work independently. | Wire only `onTap` and ignore `onCheckboxChanged` / `onToggleChanged` — the control will appear interactive but do nothing. |
| Keep `primaryText` to 1–2 lines of concise content. | Put paragraphs or rich formatted text in `primaryText` — use a card or custom layout instead. |
| Use `selected` + `primaryContainer` background to show the currently active item in a list. | Simulate selection by changing text color manually — always use the `selected` prop for consistent theming. |
| Wrap multiple `RdsListItem` rows in a parent container and add `Divider` separators between them using `color-outline-variant`. | Embed `RdsListItem` inside another `RdsListItem` or nest list items — keep the hierarchy flat. |
