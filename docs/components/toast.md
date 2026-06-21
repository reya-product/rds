# Toast

> A brief, non-blocking notification that surfaces feedback about a completed action or system event. Toasts appear at the bottom-center or top-right of the screen and auto-dismiss or remain until manually closed.

---

## When to use / when not to use

**Use when:**
- Confirming a completed action: "Changes saved", "Patient added".
- Reporting a background error that does not block the user's current flow.
- Surfacing a system advisory or informational update the user should know about.
- Providing an undo affordance immediately after a destructive action.

**Do not use when:**
- The user must acknowledge the message before proceeding — use a Modal Dialog.
- The error directly relates to a form field — use inline field validation instead.
- The message requires more than ~2 lines of text — use a Banner or inline alert.
- The user needs to take a complex multi-step action in response — use a Dialog or Drawer.

---

## Anatomy

```
┌─────────────────────────────────────────────────────────────┐
│  [icon]  Title (optional)                         [close ×] │
│          Message body text                                   │
│          [Action button]  [Link]                             │
└─────────────────────────────────────────────────────────────┘
     ↑         ↑                                      ↑
  leading   text column                         trailing close
   icon     (title + message + actions)          (manual only)
```

| Part | Description |
|---|---|
| 1. Container | Rounded pill/card with `radius-lg`, semantic container background color, `shadow-md`. |
| 2. Leading icon | 20px (`icon-md`) Material Symbol icon indicating the semantic variant. |
| 3. Title | Optional bold `label-large` text above the message. |
| 4. Message | Required `body-small` text; the primary notification content. |
| 5. Action button | Optional label-only inline button triggering a `VoidCallback`. |
| 6. Link | Optional underlined label linking to a URL string. |
| 7. Close button | `RdsIcons.close` icon — shown only in `manual` dismiss mode. |

---

## Variants

| Variant | Background | Icon | Icon color | When to use |
|---|---|---|---|---|
| `danger` | `color-danger-container` | `error` | `color-danger` | Failed action, error state |
| `warning` | `color-warning-container` | `warning` | `color-warning` | Caution / advisory |
| `success` | `color-success-container` | `check_circle` | `color-success` | Successful action completed |
| `neutral` | `color-surface-container` | `info` | `color-neutral` | Informational or general update |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `variant` | `RdsToastVariant` | required | Semantic tone: `danger`, `warning`, `success`, `neutral`. |
| `message` | `String` | required | The primary notification message. |
| `title` | `String?` | `null` | Optional bold heading above the message. |
| `dismissMode` | `RdsDismissMode` | `auto` | `auto` — dismiss after `duration`; `manual` — shows a close button. |
| `duration` | `Duration` | `Duration(seconds: 4)` | How long to display before auto-dismissing. Applies to `RdsToast.show()` only. |
| `position` | `RdsToastPosition` | `bottomCenter` | `topRight` or `bottomCenter`. Applies to `RdsToast.show()` only. |
| `action` | `RdsToastAction?` | `null` | Optional inline action button (label + callback). |
| `link` | `RdsToastLink?` | `null` | Optional inline link (label + URL string). |
| `onDismiss` | `VoidCallback?` | `null` | Called when the close button is tapped. Required to show close button in `manual` mode. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Entering | `RdsToast.show()` called | Slides in + fades in from position edge | `motion-duration-emphasized`, `motion-curve-emphasized` |
| Visible | After enter animation completes | Fully opaque, drop shadow | `shadow-md` |
| Exiting | Auto-dismiss timer fires or user dismisses | Slides out + fades out | `motion-duration-emphasized`, reversed |
| Action hover | Mouse over action button | Text underline appears | — |
| Link hover | Mouse over link | Underline opacity increases | — |

---

## Sizes

Toast has a fixed internal padding and a max-width constraint:

| Property | Value | Token |
|---|---|---|
| Max width | 360px | (fixed) |
| Internal padding | 16px all sides | `space-4` |
| Icon size | 20px | `icon-md` |
| Corner radius | 12px | `radius-lg` |
| Shadow | `shadow-md` | `shadow-md` |
| Gap: icon → text | 12px | `space-3` |
| Gap: action → link | 12px | `space-3` |

---

## Tokens used

**Colors**
- `color-danger-container` — danger background
- `color-on-danger-container` — text/icons on danger background
- `color-danger` — leading icon for danger variant
- `color-warning-container` — warning background
- `color-on-warning-container` — text/icons on warning background
- `color-warning` — leading icon for warning variant
- `color-success-container` — success background
- `color-on-success-container` — text/icons on success background
- `color-success` — leading icon for success variant
- `color-surface-container` — neutral background
- `color-on-surface` — text/icons on neutral background
- `color-neutral` — leading icon for neutral variant

**Typography**
- `label-large` — title text (500 weight, 14px)
- `body-small` — message text (12px)
- `label-large` — action button and link labels

**Spacing**
- `space-4` — container padding (16px)
- `space-3` — icon-to-text gap (12px)
- `space-2` — text-to-close gap (8px)
- `space-1` — title-to-message gap (4px)

**Radius**
- `radius-lg` — container corner radius (12px)

**Shadows**
- `shadow-md` — container elevation (`0 4px 6px rgba(0,0,0,0.07)`)

**Motion**
- `motion-duration-emphasized` — slide in / slide out (300ms)
- `motion-curve-emphasized` — `cubic-bezier(0.2, 0, 0, 1)`

**Icons**
- `RdsIcons.error` — danger variant leading icon
- `RdsIcons.warning` — warning variant leading icon
- `RdsIcons.success` — success variant leading icon
- `RdsIcons.info` — neutral variant leading icon
- `RdsIcons.close` — dismiss button

---

## Behavior & interaction

### Mouse / touch
- Action button: tap calls `onPressed`.
- Link: tap should open the URL via the host application's URL-launching mechanism.
- Close button (manual mode): tap calls `onDismiss`, triggering the exit animation.

### Keyboard
- Close button is focusable via `Tab`.
- Action button is keyboard-activatable via `Space` / `Enter`.
- Toast itself is not part of the normal focus order when auto-dismissed.

### Focus management
- Focus is not stolen when the toast appears.
- The close button receives focus when `Tab` reaches it in document order.

### Animation
- **Enter:** The toast widget slides in from outside the screen edge toward its resting position, simultaneously fading in from 0 → 1 opacity.
  - `topRight` position: slides down from above.
  - `bottomCenter` position: slides up from below.
  - Duration: `motion-duration-emphasized` (300ms), curve: `motion-curve-emphasized`.
- **Exit:** Reverses the enter animation.
- **Auto-dismiss:** After `duration` (default 4s) the exit animation plays, then the `OverlayEntry` is removed.
- `MediaQuery.disableAnimations` collapses duration to zero for immediate show/hide.

### Dismissal
- `auto` mode: automatically dismisses after `duration`. No close button shown.
- `manual` mode: displays a close (`×`) button. Dismisses only when tapped.

---

## Accessibility

- **Semantics:** `Semantics(liveRegion: true, label: "danger notification: [title]. [message]")` — announces immediately to screen readers.
- **Min touch target:** The close button hit area is at least 44×44px.
- **Contrast:** All container/text pairs (e.g. `color-danger-container` / `color-on-danger-container`) are verified WCAG AA (4.5:1+).
- **Screen reader:** `liveRegion: true` causes VoiceOver / TalkBack to read the toast content when it appears, without requiring user focus.
- **Keyboard:** Close button and action buttons are reachable via `Tab`.
- **Reduced motion:** All slide/fade transitions collapse to instant when `MediaQuery.disableAnimations` is true.

---

## Content guidelines

- **Message:** Use sentence case. 1–2 short sentences maximum. Be specific: "Lab results saved" not "Saved successfully".
- **Title:** Optional. Use only when extra context is needed (e.g. "Connection error"). Do not repeat the icon's implied meaning.
- **Action label:** Short verb phrase: "Undo", "View", "Retry". Not a full sentence.
- **Link label:** Short noun phrase: "View record", "See details".
- **Tone:** Neutral and factual — avoid alarming language in warning/danger toasts. State the situation, not an emotion.

---

## Composition

**Uses:**
- `RdsIcons` — leading icon and close button icons.

**Used by:**
- `RdsToast.show()` — the imperative API creates and manages `RdsToastWidget` inside an `OverlayEntry`.

---

## Flutter API

### Widget class
`RdsToastWidget` — the visual widget (use directly in layouts or Widgetbook).

### Constructor
```dart
const RdsToastWidget({
  super.key,
  required RdsToastVariant variant,
  required String message,
  String? title,
  RdsDismissMode dismissMode = RdsDismissMode.auto,
  RdsToastAction? action,
  RdsToastLink? link,
  VoidCallback? onDismiss,
});
```

### Static method
```dart
// Imperative overlay API — call from any BuildContext
RdsToast.show(
  context,
  variant: RdsToastVariant,
  message: String,
  title: String?,               // optional
  dismissMode: RdsDismissMode,  // default: auto
  duration: Duration,           // default: 4s
  position: RdsToastPosition,   // default: bottomCenter
  action: RdsToastAction?,      // optional
  link: RdsToastLink?,          // optional
);
```

### Public enums

```dart
enum RdsToastVariant { danger, warning, success, neutral }
enum RdsDismissMode { auto, manual }
enum RdsToastPosition { topRight, bottomCenter }
```

### Data classes

```dart
class RdsToastAction {
  const RdsToastAction({required String label, required VoidCallback onPressed});
  final String label;
  final VoidCallback onPressed;
}

class RdsToastLink {
  const RdsToastLink({required String label, required String url});
  final String label;
  final String url;
}
```

### Example usage

```dart
// Imperative (most common)
RdsToast.show(
  context,
  variant: RdsToastVariant.success,
  message: 'Patient record saved.',
);

// With title and undo action
RdsToast.show(
  context,
  variant: RdsToastVariant.warning,
  title: 'Unsaved changes',
  message: 'Your changes were discarded.',
  dismissMode: RdsDismissMode.manual,
  position: RdsToastPosition.topRight,
  action: RdsToastAction(
    label: 'Undo',
    onPressed: _restoreChanges,
  ),
);

// Widget directly (e.g. in a layout preview)
RdsToastWidget(
  variant: RdsToastVariant.danger,
  title: 'Connection error',
  message: 'Could not reach the server. Check your connection.',
  dismissMode: RdsDismissMode.manual,
  onDismiss: () {},
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | All knobs: variant, dismiss mode, message, show title, title, show action, action label, show link, link label. Displays `RdsToastWidget` directly. |
| `Gallery` | All 4 variants displayed simultaneously — success, danger, warning, neutral — with manual dismiss buttons. |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `Variant` | `list` | `variant` | `danger`, `warning`, `success`, `neutral` |
| `Dismiss mode` | `list` | `dismissMode` | `auto`, `manual` |
| `Message` | `string` | `message` | freeform |
| `Show title` | `boolean` | `title != null` | — |
| `Title` | `string` | `title` | freeform |
| `Show action` | `boolean` | `action != null` | — |
| `Action label` | `string` | `action.label` | freeform |
| `Show link` | `boolean` | `link != null` | — |
| `Link label` | `string` | `link.label` | freeform |

---

## Do / Don't

| Do | Don't |
|---|---|
| Use toasts for brief, non-blocking feedback about completed actions. | Use toasts for critical errors the user must address before continuing — use a Dialog. |
| Keep messages to 1–2 short sentences. | Write paragraph-length toast messages. |
| Use `manual` dismiss mode when the user may need to re-read or act on the message. | Use `auto` dismiss for destructive action confirmations — give the user time to undo. |
| Provide an "Undo" action for destructive operations (delete, discard). | Nest multiple toasts for a single action — batch into one message if possible. |
