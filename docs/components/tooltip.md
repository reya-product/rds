# Tooltip

> A floating text bubble that appears near a UI element to provide supplementary context or describe an icon-only action.

---

## When to use / when not to use

**Use when:**
- Labelling an icon-only button or control so keyboard and pointer users understand its action.
- Providing brief supplementary context for a truncated label or an abbreviation.
- Explaining a disabled state ("Cannot submit — required fields missing").

**Do not use when:**
- The information is critical and should always be visible — use inline helper text or a `RdsCard` instead.
- The content is longer than ~40 words — use a popover or dialog.
- The target is a mobile-only touch surface where hover is unavailable and long-press disrupts the flow.
- You need rich content (images, links, multi-line formatted text) — use a popover instead.

---

## Anatomy

```
   ┌──────────────────────┐
   │  Tooltip message     │
   └──────────────────────┘
              ▲
        [target widget]
```

| Part | Description |
|---|---|
| 1. Bubble container | Dark pill or rounded rectangle with `radius-sm`, `shadow-sm`, constrained to 32–240px width. |
| 2. Message text | `body-small` text in `surface` color (inverted from background). |
| 3. Target widget | The wrapped child widget that triggers the tooltip. |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| Top (`placement: top`) | Bubble appears above the target. | Default for most contexts. |
| Bottom (`placement: bottom`) | Bubble appears below the target. | When top is obscured by navigation or toolbar. |
| Left (`placement: left`) | Bubble appears to the left. | Rightmost elements in a toolbar. |
| Right (`placement: right`) | Bubble appears to the right. | Leftmost elements, sidebar icons. |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `message` | `String` | required | Text content of the tooltip bubble. |
| `child` | `Widget` | required | The widget the tooltip is anchored to. |
| `placement` | `RdsTooltipPlacement` | `RdsTooltipPlacement.top` | Preferred edge the bubble appears on. |
| `trigger` | `RdsTooltipTrigger` | `RdsTooltipTrigger.hover` | What gesture shows the tooltip. |
| `waitDuration` | `Duration` | `500ms` | Delay before the tooltip appears. |
| `showDuration` | `Duration` | `1500ms` | How long the tooltip stays after pointer leaves. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Hidden | Default | Tooltip not visible; child renders normally. | — |
| Visible | Hover / focus / long-press after delay | Bubble fades in above/below/beside child. | `motion-duration-standard` |
| Dismissing | Pointer leaves / focus lost | Bubble fades out. | `motion-duration-fast` |

---

## Tokens used

**Colors**
- `color-on-surface` — tooltip bubble background (inverted to contrast surfaces in both themes)
- `color-surface` — tooltip text color (inverted from background)

**Typography**
- `body-small` — tooltip message text

**Spacing**
- `space-3` — horizontal padding inside bubble
- `space-2` — vertical padding inside bubble; also side margin from viewport edge

**Radius**
- `radius-sm` — bubble corner radius

**Shadows**
- `shadow-sm` — bubble elevation

**Motion**
- `motion-duration-standard` — fade-in transition
- `motion-duration-fast` — fade-out transition

---

## Behavior & interaction

### Mouse / touch
- On desktop: tooltip appears after `waitDuration` when the pointer enters the child's bounds. It disappears after `showDuration` when the pointer leaves.
- On mobile/touch: tooltip appears on long-press and dismisses on tap outside.

### Keyboard
- When `trigger` is `focus`, the tooltip appears when the child gains keyboard focus and dismisses on blur.
- The tooltip itself is not focusable and cannot be navigated into.

### Focus management
- Focus remains on the triggering child — the tooltip is purely decorative from a focus perspective.

### Animation
- Fades in at `motion-duration-standard` (200ms).
- Fades out at `motion-duration-fast` (100ms).
- Respects `MediaQuery.disableAnimations` — when true, appears/disappears instantly.

---

## Accessibility

- **Semantics:** Flutter's `Tooltip` automatically provides a `Semantics` node with `tooltip: message`. Screen readers announce the message when the child is focused.
- **Min touch target:** Not applicable — the tooltip itself is non-interactive.
- **Contrast:** `onSurface` background with `surface` text meets WCAG AA in both light and dark themes.
- **Screen reader:** iOS VoiceOver and Android TalkBack announce tooltip content when the wrapped child is focused.
- **Keyboard:** Icon-only controls MUST have a `RdsTooltip` so keyboard-only users can discover the action label via focus + screen reader.

---

## Content guidelines

- **Message:** Sentence case, 1–8 words. Describe the action or provide context. Do not repeat visible label text.
- **Avoid HTML/markdown:** Plain text only.
- **Disabled state message:** Explain why the element is disabled (e.g. "Select at least one item first").

---

## Composition

**Uses:**
- Primitive — wraps Flutter's built-in `Tooltip` widget with RDS styling.

**Used by:**
- `RdsButton` (icon-only variant) — action description.
- Any icon-only interactive control in RDS.

---

## Flutter API

### Widget class
`RdsTooltip`

### Constructor
```dart
const RdsTooltip({
  super.key,
  required String message,
  required Widget child,
  RdsTooltipPlacement placement = RdsTooltipPlacement.top,
  RdsTooltipTrigger trigger = RdsTooltipTrigger.hover,
  Duration waitDuration = const Duration(milliseconds: 500),
  Duration showDuration = const Duration(milliseconds: 1500),
});
```

### Public enums

```dart
enum RdsTooltipPlacement {
  top, bottom, left, right,
  topStart, topEnd, bottomStart, bottomEnd,
}

enum RdsTooltipTrigger { hover, focus, longPress }
```

### Example usage

```dart
RdsTooltip(
  message: 'Delete record',
  child: IconButton(
    icon: Icon(RdsIcons.delete),
    onPressed: _handleDelete,
  ),
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | All props exposed as knobs; hover the box to see the tooltip. |
| `Gallery` | All placement positions shown simultaneously around a central target. |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `Message` | `string` | `message` | — |
| `Placement` | `list` | `placement` | All `RdsTooltipPlacement` values |
| `Trigger` | `list` | `trigger` | `hover`, `focus`, `longPress` |
| `Wait duration (ms)` | `double.input` | `waitDuration` | — |

---

## Do / Don't

| Do | Don't |
|---|---|
| Always wrap icon-only interactive elements with `RdsTooltip` to label them for screen readers and keyboard users. | Don't show tooltips on elements that already have a visible text label — it is redundant. |
| Keep messages to a single short phrase. | Don't put critical information only in a tooltip — users who cannot hover will miss it. |
| Use `placement: bottom` when the control is near the top of the screen to avoid clipping. | Don't nest tooltips inside other tooltips or use them on disabled, non-interactive elements unless explaining the disabled reason. |
