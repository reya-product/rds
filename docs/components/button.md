# Button

> A pressable label that triggers an action. The primary interaction affordance in RDS.

---

## When to use / when not to use

**Use when:**
- The user needs to trigger a discrete action (submit, save, delete, navigate).
- Emphasis hierarchy matters: use `primary` for the single most important action, `tonal` or `outlined` for secondary actions, `text` for tertiary or inline actions.
- A loading state must be communicated while an async action runs.
- A destructive action needs to be clearly signalled — use `danger` tone.

**Do not use when:**
- The action navigates to a different page and should be bookmarkable — use a plain `<a>` link or `TextButton` with an underline instead.
- You need to select between options in a group — use `RdsButtonGroup` or `RdsSegmentedButtons`.
- The action is a toggle (on/off state) — use `RdsToggleSwitch`.
- The surface is a form and the action is a checkbox or radio choice — use those components.

---

## Anatomy

```
┌─────────────────────────────────┐
│  [icon]  Label text  [icon]     │
└─────────────────────────────────┘
     1          2         3

Icon-only:
┌──────┐
│ [ico]│
└──────┘
    1
```

| Part | Description |
|---|---|
| 1. Icon (optional) | `icon-md` (20px) Material Symbol. Position controlled by `iconPosition`. In loading state, replaced by a spinner for `iconOnly` buttons. |
| 2. Label | `label-large` text style. Hidden (but still used for semantics) in `iconOnly` position. In loading (non-icon-only) mode, a spinner is shown inline before the label. |
| 3. Container | Rounded rectangle with `radius-md`. Fill, border, and text colors vary by variant and tone. State layer overlay on top. |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| `primary` | Filled with `color-primary` (teal), white label | Single highest-emphasis action per view |
| `tonal` | Filled with `color-primary-container` (light teal), `color-on-primary-container` label | Secondary action that still needs some fill emphasis |
| `outlined` | `color-outline` border, transparent fill, `color-primary` label | Secondary actions alongside a primary button |
| `text` | No fill, no border, `color-on-surface` label | Low-emphasis / tertiary actions, inline actions in lists |

**Tone modifiers** (applied to any variant):

| Tone | Effect |
|---|---|
| `defaultTone` | Uses primary brand colors (see Variants above) |
| `danger` | `primary` → `color-danger` fill; `tonal` → `color-danger-container` fill; `outlined`/`text` → `color-danger` label |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | required | Button label. Used for accessibility even in `iconOnly` mode. |
| `variant` | `RdsButtonVariant` | `primary` | Visual style: `primary`, `tonal`, `outlined`, `text`. |
| `tone` | `RdsButtonTone` | `defaultTone` | Semantic tone: `defaultTone` or `danger`. |
| `iconPosition` | `RdsButtonIconPosition` | `none` | Where the icon appears: `none`, `leading`, `trailing`, `iconOnly`. |
| `icon` | `IconData?` | `null` | Icon data. Required when `iconPosition` is not `none`. |
| `size` | `RdsButtonSize` | `medium` | `small` (h=32), `medium` (h=40), `large` (h=48). |
| `loading` | `bool` | `false` | Shows a spinner; blocks interaction; preserves button size. |
| `disabled` | `bool` | `false` | Reduces opacity to `opacity-disabled`; blocks interaction. |
| `fullWidth` | `bool` | `false` | Stretches button to fill parent width. |
| `onPressed` | `VoidCallback?` | `null` | Tap callback. If null, button behaves as disabled. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled | Default | Normal appearance | — |
| Hover | Mouse over / pointer enter | State layer overlay at 8% opacity over the on-color | `state-hover` |
| Focus | Keyboard focus (Tab) | State layer overlay at 12% opacity | `state-focus` |
| Pressed | Tap / click hold | State layer overlay at 16% opacity | `state-pressed` |
| Disabled | `disabled: true` or `onPressed: null` | Entire button at `opacity-disabled` (38%); no interaction | `opacity-disabled` |
| Loading | `loading: true` | Spinner replaces or precedes the label; interaction blocked | — |

---

## Sizes

| Size | Height | H-padding | V-padding | Font style | Icon size |
|---|---|---|---|---|---|
| `small` | 32px | `space-3` (12px) | `space-1` (4px) | `label-large` | `icon-md` (20px) |
| `medium` | 40px | `space-4` (16px) | `space-2` (8px) | `label-large` | `icon-md` (20px) |
| `large` | 48px | `space-5` (20px) | `space-3` (12px) | `label-large` | `icon-md` (20px) |

For `iconOnly`, horizontal and vertical padding are equal: `space-2` / `space-3` / `space-4` for small/medium/large respectively.

---

## Tokens used

**Colors**
- `color-primary` — fill for `primary` variant (default tone)
- `color-on-primary` — label/icon for `primary` variant (default tone)
- `color-primary-container` — fill for `tonal` variant (default tone)
- `color-on-primary-container` — label/icon for `tonal` variant (default tone)
- `color-outline` — border for `outlined` variant (default tone)
- `color-on-surface` — label/icon for `text` variant (default tone)
- `color-danger` — fill for `primary` + danger; border/label for `outlined`/`text` + danger
- `color-on-danger` — label for `primary` + danger fill
- `color-danger-container` — fill for `tonal` + danger
- `color-on-danger-container` — label for `tonal` + danger

**Typography**
- `label-large` — button label text style (14px, weight 500)

**Spacing**
- `space-1` — vertical padding (small icon-label buttons)
- `space-2` — vertical padding (medium), gap between icon and label, spinner gap
- `space-3` — horizontal padding (small), vertical padding (large)
- `space-4` — horizontal padding (medium)
- `space-5` — horizontal padding (large)

**Radius**
- `radius-md` — button container corner radius (8px)

**Motion**
- `motion-duration-standard` — color/fill transitions on state change
- `motion-curve-standard` — easing for transitions

**Opacity**
- `opacity-disabled` — applied to full button widget when disabled
- `state-hover` — state layer opacity on hover
- `state-focus` — state layer opacity on focus
- `state-pressed` — state layer opacity on press

---

## Behavior & interaction

### Mouse / touch
- Tap / click triggers `onPressed` immediately on release.
- Pointer cursor changes to `click` when interactive, `basic` when disabled.
- State layer animates in on hover, intensifies on press, fades on release.

### Keyboard
- `Tab` / `Shift+Tab` moves focus to/from the button.
- `Space` or `Enter` activates the button when focused.
- No key activates a disabled or loading button.

### Focus management
- Focus ring is communicated via the `state-focus` state layer overlay.
- Focus does not move automatically on press; the calling widget manages post-action focus.

### Animation
- All color/state layer transitions use `motion-duration-standard` (200ms) with `motion-curve-standard` (ease-in-out).
- When `MediaQuery.disableAnimations` is true, `motion-duration-instant` (0ms) is used.

---

## Accessibility

- **Semantics:** `Semantics(button: true, enabled: <bool>, label: <label>)` — for `iconOnly` buttons the `label` is set explicitly so screen readers announce the action name.
- **Min touch target:** 44 × 44px enforced via `ConstrainedBox(constraints: BoxConstraints(minWidth: 44, minHeight: 44))`.
- **Contrast:** `color-primary` / `color-on-primary` and `color-danger` / `color-on-danger` both meet WCAG AA (4.5:1 for 14px bold text).
- **Screen reader:** Announces the label, role ("button"), and enabled state. Loading state should be announced by the caller via live region if needed.
- **Keyboard:** Fully operable via Tab + Space/Enter.

---

## Content guidelines

- **Label:** Title-case for standalone actions ("Save Changes"), sentence-case for inline context ("Add another item"). Maximum ~24 characters before truncation with ellipsis.
- **Icon-only buttons:** Always provide a `tooltip` on the parent or via a `Tooltip` widget wrapping the button; the `label` is used for screen readers.
- **Danger tone:** Use active-voice, specific verbs: "Delete record" not "Remove" or "Are you sure?". Pair with a confirmation dialog for irreversible actions.
- **Loading label:** Keep the same label text during loading — do not change to "Loading…" since the spinner communicates the state.

---

## Composition

**Uses:**
- Primitive — no RDS component dependencies. Uses `RdsTheme` for all styling.

**Used by:**
- `RdsButtonGroup` — renders individual `RdsButton` instances.
- `RdsSegmentedButtons` — (indirectly) — shares the same visual grammar but uses its own internal `_RdsSegmentItem` widget.

---

## Flutter API

### Widget class
`RdsButton`

### Constructor
```dart
const RdsButton({
  Key? key,
  required String label,
  RdsButtonVariant variant = RdsButtonVariant.primary,
  RdsButtonTone tone = RdsButtonTone.defaultTone,
  RdsButtonIconPosition iconPosition = RdsButtonIconPosition.none,
  IconData? icon,
  RdsButtonSize size = RdsButtonSize.medium,
  bool loading = false,
  bool disabled = false,
  bool fullWidth = false,
  VoidCallback? onPressed,
});
```

### Public enums

```dart
enum RdsButtonVariant { primary, tonal, outlined, text }
enum RdsButtonTone { defaultTone, danger }
enum RdsButtonIconPosition { none, leading, trailing, iconOnly }
enum RdsButtonSize { small, medium, large }
```

### Example usage

```dart
// Primary button
RdsButton(
  label: 'Save changes',
  onPressed: () {},
)

// Danger outlined with leading icon
RdsButton(
  label: 'Delete record',
  variant: RdsButtonVariant.outlined,
  tone: RdsButtonTone.danger,
  icon: RdsIcons.delete,
  iconPosition: RdsButtonIconPosition.leading,
  onPressed: () {},
)

// Icon-only loading state
RdsButton(
  label: 'Upload file',
  iconPosition: RdsButtonIconPosition.iconOnly,
  icon: RdsIcons.upload,
  loading: true,
  onPressed: null,
)

// Full-width large primary
RdsButton(
  label: 'Continue',
  size: RdsButtonSize.large,
  fullWidth: true,
  onPressed: () {},
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | All props exposed as knobs; interactive sandbox |
| `Gallery` | Grid of all variants × tones × sizes in enabled state |
| `States` | All interaction states for a single variant |
| `Icon positions` | All four icon positions side by side |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `Variant` | list | `variant` | `primary`, `tonal`, `outlined`, `text` |
| `Tone` | list | `tone` | `defaultTone`, `danger` |
| `Icon position` | list | `iconPosition` | `none`, `leading`, `trailing`, `iconOnly` |
| `Label` | string | `label` | `'Button'` |
| `Size` | list | `size` | `small`, `medium`, `large` |
| `Loading` | boolean | `loading` | `false` |
| `Disabled` | boolean | `disabled` | `false` |
| `Full width` | boolean | `fullWidth` | `false` |

---

## Do / Don't

| Do | Don't |
|---|---|
| Use one `primary` button per focal area to establish clear hierarchy | Place multiple `primary` buttons in a single row or card |
| Use `danger` tone for destructive actions (delete, revoke) | Use `danger` tone for non-destructive warnings — use `RdsToast` instead |
| Provide a meaningful `label` even for icon-only buttons (screen readers) | Leave `label` blank or generic ("Button") for icon-only variants |
| Keep labels concise (≤ 3 words for primary actions) | Use long sentences or passive voice ("Changes will be saved") as a button label |
