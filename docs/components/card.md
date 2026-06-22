# Card
> The primary content container in RDS. Composed of an optional header zone, a required body zone, and an optional footer zone.

## When to use / when not to use

**Use when:**
- Displaying a self-contained unit of information (patient summary, metric, appointment)
- Grouping related fields or list items under a single heading
- Presenting an entity that may be tapped to navigate or trigger an action

**Do not use when:**
- Content spans the full page width without a visual boundary — use a page section instead
- The content is a single line with no grouping need — use `RdsListItem` directly

## Anatomy

```
┌─────────────────────────────────────────┐
│ [leading] Primary text          [trail] │  ← Header zone (optional)
│           Secondary text                │
├─────────────────────────────────────────┤
│  List item                              │  ← Body zone (required)
│  List item                              │
│  List item                              │
├─────────────────────────────────────────┤
│  Action 1  │  Action 2  │  Action 3     │  ← Footer zone (optional)
└─────────────────────────────────────────┘
```

Zones:
1. **Header** — optional; leading slot (avatar/badge/none), primary + secondary text, trailing slot (badge/iconButton/none)
2. **Body** — required; list items, full-bleed image, or arbitrary widget via `bodyContent`
3. **Footer** — optional; row of `RdsCardAction` text buttons separated by muted vertical dividers

## Variants

| Body type | Use case |
|-----------|----------|
| `listItems` | Patient vitals, form summaries, structured data |
| `image` | Content cards, media thumbnails |
| `bodyContent` (escape hatch) | Metric widgets, charts, custom layouts |

## Configs (props)

### Header zone
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `headerLeading` | `RdsCardHeaderLeading` | `none` | Leading slot type |
| `headerLeadingAvatar` | `RdsAvatarConfig?` | null | Avatar config when `headerLeading == avatar` |
| `headerLeadingBadge` | `RdsBadgeConfig?` | null | Badge config when `headerLeading == badge` |
| `headerPrimaryText` | `String?` | null | Main header text (`titleMedium`) |
| `headerSecondaryText` | `String?` | null | Subtitle text (`bodySmall`) |
| `headerTrailing` | `RdsCardHeaderTrailing` | `none` | Trailing slot type |
| `headerTrailingBadge` | `RdsBadgeConfig?` | null | Badge config when `headerTrailing == badge` |
| `headerTrailingIcon` | `IconData?` | null | Icon when `headerTrailing == iconButton` |
| `onHeaderTrailingTap` | `VoidCallback?` | null | Callback for trailing icon button |

### Body zone
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `bodyType` | `RdsCardBodyType` | `listItems` | Body content strategy |
| `bodyItems` | `List<RdsListItem>` | `[]` | Items when `bodyType == listItems` |
| `bodyImageUrl` | `String?` | null | Network URL when `bodyType == image` |
| `bodyImageHeight` | `double` | 180 | Image height in logical pixels |
| `bodyContent` | `Widget?` | null | Escape hatch — overrides `bodyType` |

### Footer zone
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `footerActions` | `List<RdsCardAction>` | `[]` | Action buttons; empty = no footer |

### Card-level
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `elevation` | `RdsCardElevation` | `low` | Shadow depth |
| `outlined` | `bool` | false | Adds 1px `outlineVariant` border |
| `onTap` | `VoidCallback?` | null | Makes card tappable with hover/press overlays |
| `selected` | `bool` | false | Tints background `primaryContainer` |
| `width` | `double?` | null | Explicit width; null fills parent |

## Enums

```dart
enum RdsCardElevation { none, low, medium }
enum RdsCardBodyType { listItems, image }
enum RdsCardHeaderLeading { none, avatar, badge }
enum RdsCardHeaderTrailing { none, badge, iconButton }
```

## States

| State | Visual |
|-------|--------|
| Default | `surface` background, `shadow-sm` |
| Outlined | 1px `outlineVariant` border |
| Selected | `primaryContainer` background tint |
| Tappable hover | `onSurface` overlay at `opacity-hover` |
| Tappable pressed | `onSurface` overlay at `opacity-pressed` |

## Tokens used

| Element | Token |
|---------|-------|
| Background (default) | `color-surface` |
| Background (selected) | `color-primary-container` |
| Border | `color-outline-variant` |
| Shadow (low) | `shadow-sm` |
| Shadow (medium) | `shadow-md` |
| Header primary text | `color-on-surface`, `title-medium` |
| Header secondary text | `color-on-surface-variant`, `body-small` |
| Footer divider | `color-outline-variant` |
| Corner radius | `radius-lg` |
| Header padding | `space-4` |
| Body padding (list items) | none (list items own their padding) |
| Body padding (custom content) | `space-4` |
| Footer padding | `space-3` horizontal, `space-2` vertical |

## Behavior & interaction

1. **Tappable card** — when `onTap` is set, the entire card surface is wrapped in an `InkWell` with overlay colors. Pointer cursor changes to `click`.
2. **Selected state** — `selected: true` sets the background to `primaryContainer`; used for selection within a list of cards.
3. **Header trailing icon button** — independently tappable even when `onTap` is set; receives `onHeaderTrailingTap`.
4. **Footer actions** — each `RdsCardAction` renders as a text-style `RdsButton`; separated by 1px `outlineVariant` vertical dividers.
5. **Image body** — renders a `ClipRRect`-cropped network image with `BoxFit.cover`; full-bleed (no horizontal padding).

## Accessibility

- `Semantics(button: true)` wraps the card when `onTap` is set
- `Semantics(selected: true/false)` reflects `selected` state
- `semanticLabel` defaults to `headerPrimaryText` if set
- Footer actions have individual semantic labels via `RdsButton`
- Min tap target for icon button: 40px (padded to 44px via `SizedBox`)

## Content guidelines

- **Primary text:** entity name or card title — noun phrase, sentence case
- **Secondary text:** role, category, or timestamp — keep to one line
- **Footer actions:** verb phrase, ≤ 2 words (e.g. "View", "Edit", "Dismiss")
- **Max footer actions:** 3 (at wider widths); prefer 1–2

## Composition

- Composes `RdsListItem` for body items
- Composes `RdsAvatar` for header leading avatar
- Composes `RdsBadge` for header leading/trailing badge
- Composes `RdsButton` (text variant) for footer actions
- Used by: patient list, appointment scheduler, metric dashboard, settings panels

## Flutter API

```dart
// Patient summary card
RdsCard(
  headerLeading: RdsCardHeaderLeading.avatar,
  headerLeadingAvatar: const RdsAvatarConfig(
    type: RdsAvatarType.initials,
    name: 'Jane Doe',
  ),
  headerPrimaryText: 'Jane Doe',
  headerSecondaryText: 'Patient · Age 34',
  headerTrailing: RdsCardHeaderTrailing.iconButton,
  headerTrailingIcon: RdsIcons.moreVertical,
  onHeaderTrailingTap: () {},
  bodyItems: [
    RdsListItem(primaryText: 'Heart rate', supportingText: '72 bpm'),
    RdsListItem(primaryText: 'Blood pressure', supportingText: '120/80'),
    RdsListItem(primaryText: 'BMI', supportingText: '22.4'),
  ],
  footerActions: [
    RdsCardAction(label: 'View profile', onPressed: () {}),
    RdsCardAction(label: 'Book appointment', onPressed: () {}),
  ],
  outlined: true,
)

// Metric card with custom body
RdsCard(
  headerPrimaryText: 'Body Temperature',
  bodyContent: Column(
    children: [
      Text('98.6°F', style: rds.displaySmall.copyWith(color: rds.onSurface)),
      Text('Recorded today at 09:14', style: rds.bodySmall.copyWith(color: rds.onSurfaceMuted)),
    ],
  ),
  footerActions: [RdsCardAction(label: 'History', onPressed: () {})],
)

// Tappable selectable card
RdsCard(
  headerPrimaryText: 'Dr. Smith',
  headerSecondaryText: 'Cardiologist',
  bodyItems: [
    RdsListItem(primaryText: 'Mon–Fri, 09:00–17:00'),
  ],
  selected: _isSelected,
  onTap: () => setState(() => _isSelected = !_isSelected),
  elevation: RdsCardElevation.none,
  outlined: true,
)
```

## Widgetbook

- `cardComponent` — use cases: Playground (all knobs), Patient summary card, Metric card, Image card, Gallery

## Do / Don't

**Do:**
- Use `outlined: true` when cards sit on a white/light `surface` background (distinguishes boundary from background)
- Use `elevation: RdsCardElevation.none` for cards inside already-elevated surfaces (e.g. dialogs)
- Limit footer to ≤ 3 actions

**Don't:**
- Don't put interactive controls (text fields, dropdowns) in the card body — use a form page instead
- Don't stack cards inside `bodyContent` (no nested cards)
- Don't use both `selected` and `onTap` without a clear affordance; the selected tint alone is sufficient for selection
