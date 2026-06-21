# RDS Patterns

> Structural and behavioral patterns for Reya SaaS products.
> These are not individual components — they are composition recipes that
> assemble components into full application surfaces.

---

## App Shell

The RDS app shell is the top-level layout container for all Reya web products. It consists of three regions:

```
┌────────────────────────────────────────────────────┐
│  TOP BAR (56px tall, full width)                   │
│  [Logo/Name]                [Search][Bell][Avatar] │
├──────────┬─────────────────────────────────────────┤
│          │                                         │
│  VERTICAL│  CONTENT AREA                           │
│  NAV     │                                         │
│  STRIP   │  Page Header (title + breadcrumbs + actions) │
│          │  ─────────────────────────────────────  │
│  64px    │  Page Content                           │
│  (collapsed)│                                      │
│  or 220px│                                         │
│  (expanded)│                                       │
│          │                                         │
└──────────┴─────────────────────────────────────────┘
```

### Token references

- Top bar height: `56px` (fixed)
- Nav strip collapsed width: `64px`
- Nav strip expanded width: `220px`
- Nav strip background: `rds.surfaceVariant`
- Top bar background: `rds.surface`
- Top bar border-bottom: `1px solid rds.outlineVariant`
- Content area background: `rds.surfaceVariant`
- Content area padding: `rds.space6` (24px) on all sides

---

## Top Bar

**Height:** 56px
**Background:** `rds.surface`
**Border bottom:** `1px solid rds.outlineVariant`
**Shadow:** `shadow-xs`

### Anatomy

```
[Logo / App name]                    [Search] [Notifications] [Avatar]
← left section →                    ←──────── right section ─────────→
```

| Region | Contents | Notes |
|---|---|---|
| Left | Logo image (32px) or app name in `titleLarge` | Clicking navigates to home |
| Center | Empty (reserved for future breadcrumbs override) | |
| Right | Search icon button → Search bar, Notification bell + count badge, Avatar (36px) | Ordered right-to-left by priority |

### Behavior

- **Search:** Icon button that expands to a full-width `SearchBar` on press. On mobile, takes full-width overlay.
- **Notifications:** Badge count over bell icon. Clicking opens a dropdown panel.
- **Avatar:** Opens a dropdown menu with profile, settings, sign-out.
- The top bar is `position: fixed` on web — content area must account for 56px top offset.

---

## Vertical Navigation Strip

Built from `RdsVerticalTabs` (T1 Atom). The nav strip provides primary navigation.

### Modes

| Mode | Width | Content |
|---|---|---|
| **Collapsed** | 64px | Icon only, centered vertically |
| **Expanded** | 220px | Icon (24px) + label (`labelLarge`) |

### Anatomy

```
Expanded mode:
┌────────────────────┐
│ ▣ Dashboard        │  ← selected state
│ 📋 Patients        │
│ 📅 Schedule        │
│ 📊 Reports         │
│ ─────────────────  │  ← divider between sections
│ ⚙  Settings       │
└────────────────────┘

Collapsed mode:
┌──────┐
│  ▣   │  ← selected (highlighted)
│  📋  │
│  📅  │
│  📊  │
│  ──  │
│  ⚙   │
└──────┘
```

### Properties

- **Background:** `rds.surfaceVariant`
- **Selected item background:** `rds.primaryContainer`
- **Selected item icon/text color:** `rds.onPrimaryContainer`
- **Unselected item color:** `rds.onSurfaceVariant`
- **Hover state:** `rds.primary` at `stateHover` opacity overlay
- **Icon size:** `icon-lg` (24px)
- **Item height:** 48px
- **Collapse toggle:** chevron icon at the bottom of the strip
- **Transition:** width animates over `durationEmphasized` (300ms) with `curveEmphasized`

### Tooltips in collapsed mode

When collapsed, each nav item shows a `Tooltip` with the item label on hover. This ensures icon-only navigation remains accessible.

---

## Content Area

The area to the right of the nav strip and below the top bar.

### Page Container

Constrains content width per breakpoint:

| Breakpoint | Max content width | Horizontal padding |
|---|---|---|
| xs | 100% | 16px |
| sm | 100% | 24px |
| md | 100% | 32px |
| lg | 1240px | 48px |
| xl | 1440px (centered) | auto |

### Page Header

Sits at the top of every content page:

```
[Breadcrumbs (optional)]
[Page Title]                           [Action buttons]
[Page subtitle / description (optional)]
─────────────────────────────────────── (divider)
```

- **Title:** `headlineLarge` style, `rds.onSurface` color
- **Breadcrumbs:** `bodySmall`, `rds.onSurfaceVariant`; chevron separator
- **Actions:** `RdsButton` group, right-aligned; typically one primary + one or two outlined/text buttons
- **Spacing below header to content:** `rds.space6` (24px)

### Section

Groups related content within a page:

```
Section title (titleLarge)
[optional section description (bodyMedium)]
────── (optional section divider)
Section content
```

### Card Grid

A responsive grid of `RdsCard` components:

| Breakpoint | Columns | Gap |
|---|---|---|
| xs | 1 | 16px |
| sm | 2 | 24px |
| md | 2–3 | 24px |
| lg | 3–4 | 32px |

---

## Responsive Behavior

### Breakpoint-specific behavior

| Breakpoint | Nav strip | Top bar | Content |
|---|---|---|---|
| `xl`, `lg` | Expanded (220px) | Full | Full grid |
| `md` | Collapsed (64px) | Full | Reduced grid |
| `sm` | Hidden; hamburger in top bar | Condensed | Stacked single column |
| `xs` | Hidden; hamburger → bottom sheet drawer | Minimal | Full-width stacked |

### Navigation collapse triggers

- Below `md` (< 905px): nav strip auto-collapses to icon-only.
- Below `sm` (< 600px): nav strip hides entirely; navigation drawer opens from a hamburger icon in the top bar.
- Drawer: slides in from the left, full-height, overlays content; scrim behind it.

---

## Density

### Default (Comfortable)

Used for most content pages. Generous spacing for clarity.

- List items: `48px` min height
- Form fields: `56px` height
- Card padding: `rds.space6` (24px)
- Table rows: `52px` height

### Compact

Used for data-dense views: lab result tables, scheduling grids, patient lists.

- List items: `36px` min height
- Form fields: `40px` height
- Card padding: `rds.space4` (16px)
- Table rows: `36px` height

Components accept a `dense: bool` prop (or `RdsDensity.compact` enum) to switch modes.

---

## Empty State

Used when a list, table, or page has no content to show.

### Layout

```
             ┌──────────────────────┐
             │                      │
             │    [Icon 48px]       │
             │                      │
             │  Headline (titleLarge)│
             │                      │
             │  Body copy            │
             │  (bodyMedium, muted)  │
             │                      │
             │  [Optional CTA btn]  │
             │                      │
             └──────────────────────┘
```

### Rules

- Centered vertically and horizontally in its container.
- Icon: `RdsIcons` at 48px, `rds.onSurfaceMuted` color.
- Headline: `titleLarge`, `rds.onSurfaceVariant`.
- Body: `bodyMedium`, `rds.onSurfaceMuted`, max 2 lines.
- CTA: `RdsButton` variant `tonal` or `outlined`; use only if there is a clear action.

---

## Loading State

### Skeleton shimmer

Used while card and list content is loading. Mirrors the layout of the target content.

- Shimmer color: animate between `rds.surfaceContainer` and `rds.outline` at 40% opacity.
- Skeleton blocks mimic the shapes of text lines, images, and card regions.
- Animation: `durationSlow` (500ms) repeating shimmer sweep.
- Show skeleton immediately; do not delay.

### Spinner

Used for action-triggered loading (button press, form submit, data refresh).

- Use `CircularProgressIndicator` with `color: rds.primary`, `strokeWidth: 2`.
- Inline spinner inside a button: replaces label; button width stays fixed.
- Full-page spinner: centered in the content area with a faint scrim.

---

## Error State

### Inline (form fields)

Shown below a field when validation fails.

- Error text: `bodySmall`, `rds.danger` color.
- Field border: `rds.danger`.
- Error icon: `RdsIcons.error` at `icon-sm` (16px).

### Banner (page-level)

For non-blocking page-level errors (e.g. "Could not load latest data — showing cached results").

- Full-width bar below the page header.
- Background: `rds.dangerContainer` or `rds.warningContainer`.
- Text: `bodyMedium`, `rds.onDangerContainer`.
- Leading icon: `RdsIcons.warning` or `RdsIcons.error`.
- Optional: dismiss button (icon-only) on the right.

### Dialog (blocking)

For errors requiring user acknowledgment before proceeding.

- `RdsDialog` with danger styling.
- Title: `titleLarge`, `rds.onSurface`.
- Body: `bodyMedium` explaining what happened and next steps.
- Actions: "Try again" (`RdsButton.primary`) + "Cancel" (`RdsButton.text`).

---

## Example Page Templates

### Dashboard

```
Top bar
Nav strip (expanded)
Content:
  Page header: "Dashboard" + date range picker (right)
  KPI card row: 4 stat cards (value + label + trend)
  Main content grid:
    Left column (8/12): chart card
    Right column (4/12): activity list card
  Full-width section: recent records list
```

### List / Table Page

```
Top bar
Nav strip
Content:
  Page header: "Patients" + "New patient" button (right)
  Filter bar: search + filter chips + sort dropdown
  Table or list (full width)
  Pagination (bottom right)
```

### Detail / Profile Page

```
Top bar
Nav strip
Content:
  Breadcrumbs: Patients > Jane Smith
  Profile header: Avatar + Name + Tags (badges) + Status badge + Actions
  Tab bar: Overview | Lab Results | Appointments | Notes
  Tab content:
    Overview: 2-column card grid
    Lab Results: filterable table
    Appointments: list
    Notes: timeline list
```

### Form / Wizard Page

```
Top bar
Nav strip
Content:
  Page header: "New Patient" + progress indicator (right)
  Step indicator (1 of 4)
  Form card (centered, max-width 640px):
    Section: Personal details
    Section: Contact
    Section: Health history
  Footer: "Back" button (text) + "Next" button (primary)
```
