# Overlay (Right Panel & Modal)
> Container components for contextual tasks. Both variants share an identical header / body / footer structure. The form actions go in the **footer** of the overlay — never inside the body.

## Variants

| Variant | Widget / method | Use when |
|---------|-----------------|----------|
| Right Panel | `RdsRightPanel.show()` | Contextual tasks alongside a primary view (editing, adding a record, configuration) |
| Modal | `RdsModal.show()` | Blocking tasks that need full attention before continuing (onboarding, confirmation flows) |

## Anatomy

```
┌──────────────────────────────────────────────────────┐
│  Title                         [header actions]  [×] │  ← Header — 64px, surface bg
├──────────────────────────────────────────────────────┤  ← outlineVariant divider
│                                                      │
│  (scrollable body — forms, tables, custom widgets)   │  ← Expanded + SingleChildScrollView
│                                                      │
├──────────────────────────────────────────────────────┤  ← outlineVariant divider
│  [Primary action]  [Secondary]  [Text action]        │  ← Footer — auto height
└──────────────────────────────────────────────────────┘
```

Zones:
1. **Header** — title (`headlineMedium`), optional header actions (left of ×), × close button
2. **Body** — scrollable `SingleChildScrollView` wrapping any widget; padded by `bodyPadding`
3. **Footer** — left-aligned row of `RdsButton`s (primary, outlined, text variants); omitted if `footerActions` is empty

## API

### RdsRightPanel.show()

```dart
Future<T?> RdsRightPanel.show<T>({
  required BuildContext context,
  required String title,
  required Widget body,
  required List<Widget> footerActions,
  List<Widget> headerActions = const [],   // buttons between title and ×
  double width = 420,                      // panel width in logical pixels
  EdgeInsets? bodyPadding,                 // defaults to space6 all sides
  bool barrierDismissible = true,
})
```

### RdsModal.show()

```dart
Future<T?> RdsModal.show<T>({
  required BuildContext context,
  required String title,
  required Widget body,
  required List<Widget> footerActions,
  List<Widget> headerActions = const [],
  double maxWidth = 560,
  double maxHeightFraction = 0.85,         // max height as fraction of screen
  EdgeInsets? bodyPadding,
  bool barrierDismissible = true,
})
```

### RdsOverlayShell (widget, direct use)

Both `RdsRightPanel` and `RdsModal` use `RdsOverlayShell` internally. You can also use it directly (e.g. in a `Scaffold` side-by-side layout or in Widgetbook previews):

```dart
RdsOverlayShell(
  title: 'Add To Timeline',
  body: myForm,
  footerActions: [...],
  onClose: () {},
  headerActions: [],          // optional
  bodyPadding: EdgeInsets.all(24), // optional
)
```

## Props

### Shared (both variants)

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `title` | `String` | required | Header title |
| `body` | `Widget` | required | Content (typically a form) |
| `footerActions` | `List<Widget>` | required | Footer buttons; empty = no footer |
| `headerActions` | `List<Widget>` | `[]` | Widgets between title and × button |
| `bodyPadding` | `EdgeInsets?` | `space6` all | Padding around body |
| `barrierDismissible` | `bool` | `true` | Tap scrim to dismiss |

### RdsRightPanel-specific

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `width` | `double` | 420 | Panel width; clamped to 95% of screen width |

### RdsModal-specific

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `maxWidth` | `double` | 560 | Max dialog width |
| `maxHeightFraction` | `double` | 0.85 | Max height as fraction of screen |

## Tokens used

| Element | Token |
|---------|-------|
| Background | `color-surface` |
| Header height | 64px |
| Header padding | `space-5` horizontal |
| Header title | `headline-medium`, `color-on-surface` |
| × icon | `RdsIcons.close`, `icon-lg` (24px), `color-on-surface-variant` |
| Header/footer dividers | `color-outline-variant`, 1px |
| Footer padding | `space-5` horizontal, `space-4` vertical |
| Footer button gap | `space-3` |
| Modal corner radius | `radius-lg` |
| Right panel shadow | `shadow-xl` |
| Modal shadow | `boxShadow(blur:32, offset:0,8, black@20%)` |
| Animation duration | `RdsMotion.durationEmphasized` (300 ms) |
| Right panel curve | `Curves.easeOutCubic` |
| Modal curve | `Curves.easeOut` + `Curves.easeOutCubic` scale |

## Behavior & interaction

### Right panel
1. Slides from the right edge using `SlideTransition(Offset(1,0) → Offset.zero)`
2. Full screen height; width capped at `min(width, 95vw)`
3. Scrim (`black54`) covers the area to the left; tap closes if `barrierDismissible: true`
4. Returns `T?` via `Navigator.of(context).pop(value)` from inside footer actions

### Modal
1. Fades in + scales from 0.92 → 1.0 (`FadeTransition` + `ScaleTransition`)
2. Centered on screen; constrained to `maxWidth × maxHeightFraction`
3. Rounded `radiusLg` corners with `Clip.antiAlias`
4. Scrim (`black54`); tap outside closes if `barrierDismissible: true`

### Body scrolling
The body is always wrapped in `SingleChildScrollView`. Tall forms scroll naturally; the header and footer remain fixed (sticky).

### Dismissal
Always provide a **Close** or **Cancel** `RdsButton` (text variant) in `footerActions` that calls `Navigator.of(context).pop()`. The × button in the header also pops without a return value.

## Accessibility

- × button has `Semantics(label: 'Close', button: true)`
- Barrier scrim has `barrierLabel` from `MaterialLocalizations`
- Focus is trapped inside the overlay while open (Flutter `showGeneralDialog` handles this)

## Content guidelines

- **Title:** verb + noun, sentence case (e.g. "Add To Timeline", "Edit Vitals Differential", "Onboard Member")
- **Footer order (left → right):** primary action → secondary action → destructive/cancel (text variant)
- **Max footer buttons:** 3; prefer 1–2
- **Body padding:** use default `space6`; reduce to `space4` for dense forms

## Composition

- `RdsOverlayShell` — shared layout widget (header + body + footer)
- `RdsRightPanel` — wraps shell in `showGeneralDialog` with slide animation
- `RdsModal` — wraps shell in `showGeneralDialog` with fade+scale animation
- Body typically contains RDS form fields: `RdsTextField`, `RdsDateField`, `RdsSegmentedControlInput`, `RdsCheckboxInput`, etc.
- Footer typically contains `RdsButton` widgets

## Flutter API

```dart
// Right panel — "Add To Timeline"
RdsRightPanel.show(
  context: context,
  title: 'Add To Timeline',
  body: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      RdsSegmentedControlInput<String>(
        label: 'Type',
        mandatory: true,
        segments: [
          RdsSegment(value: 'intervention', label: 'Intervention'),
          RdsSegment(value: 'health_metric', label: 'Health Metric'),
          RdsSegment(value: 'event', label: 'Event'),
        ],
        selected: {_type},
        onChanged: (s) => setState(() => _type = s.first),
      ),
      SizedBox(height: 20),
      RdsTextField(label: 'Behavior Name', mandatory: true, onChanged: (_) {}),
      SizedBox(height: 20),
      RdsDateField(label: 'Start Date', mandatory: true, onChanged: (_) {}),
    ],
  ),
  footerActions: [
    RdsButton(
      label: 'Add',
      variant: RdsButtonVariant.primary,
      onPressed: _onAdd,
    ),
    RdsButton(
      label: 'Close',
      variant: RdsButtonVariant.text,
      onPressed: () => Navigator.of(context).pop(),
    ),
  ],
);

// Modal — "Onboard Member"
RdsModal.show(
  context: context,
  title: 'Onboard Member',
  body: _onboardForm,
  footerActions: [
    RdsButton(label: 'Done', variant: RdsButtonVariant.primary, onPressed: _onDone),
    RdsButton(label: 'Cancel', variant: RdsButtonVariant.text,
      onPressed: () => Navigator.of(context).pop()),
  ],
);

// Right panel with header action (e.g. "Preview" button)
RdsRightPanel.show(
  context: context,
  title: 'Edit Vitals Differential',
  headerActions: [
    RdsButton(label: 'Preview', variant: RdsButtonVariant.outlined, onPressed: _preview),
  ],
  body: _vitalsForm,
  footerActions: [
    RdsButton(label: 'Save', variant: RdsButtonVariant.primary, onPressed: _onSave),
    RdsButton(label: 'Preview Changes', variant: RdsButtonVariant.outlined, onPressed: _preview),
    RdsButton(label: 'Close', variant: RdsButtonVariant.text,
      onPressed: () => Navigator.of(context).pop()),
  ],
);
```

## Widgetbook

- `overlayComponent` — use cases:
  - **Right panel — launcher**: click button to open live right panel with form
  - **Modal — launcher**: click button to open live modal with form  
  - **Right panel — shell preview**: static inline preview of the panel shell (no route)
  - **Modal — shell preview**: static inline preview of the modal shell
  - **Right panel with header actions**: demonstrates `headerActions` + multi-button footer (title knob)

## Do / Don't

**Do:**
- Always put form action buttons in `footerActions`, never inside the form body
- Always include a way to close without saving (`Close` / `Cancel` text button)
- Use `RdsRightPanel` for tasks where context from the underlying page matters
- Use `RdsModal` for tasks that must be completed before continuing

**Don't:**
- Don't put navigation links or tabs inside the overlay body
- Don't nest overlays (opening a panel from inside a modal)
- Don't use `RdsRightPanel` for alerts or simple confirmations — use `showDialog` directly
- Don't exceed 3 footer actions
