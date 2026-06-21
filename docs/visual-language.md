# RDS Visual Language

> The complete, concrete specification for every visual token in the Reya Design System.
> Every value is explicit. Nothing is left vague or TBD.
> Components read these values exclusively through `RdsTheme` — never hardcoded.

---

## Typography

### Font Family

**Primary:** Inter (loaded via `google_fonts` package)
**Fallback stack:** `system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif`

Inter was chosen for its optical clarity at small sizes, its comprehensive Latin character set, and its suitability for data-dense medical SaaS. The tabular-numeric variant (`fontFeatures: [FontFeature.tabularFigures()]`) is used for all numeric data display.

### Type Scale

| Token name | Size | Weight | Line height | Letter spacing | Usage |
|---|---|---|---|---|---|
| `display-large` | 57px | 400 | 64px | -0.25px | Hero numbers (e.g. large health score) |
| `display-medium` | 45px | 400 | 52px | 0 | Large stats on dashboards |
| `display-small` | 36px | 400 | 44px | 0 | Section heroes |
| `headline-large` | 32px | 400 | 40px | 0 | Page titles |
| `headline-medium` | 28px | 400 | 36px | 0 | Card titles, modal headers |
| `headline-small` | 24px | 400 | 32px | 0 | Section titles |
| `title-large` | 22px | 500 | 28px | 0 | Panel headers, drawer titles |
| `title-medium` | 16px | 500 | 24px | +0.15px | List group labels, table headers |
| `title-small` | 14px | 500 | 20px | +0.1px | Sub-section labels, tab labels |
| `body-large` | 16px | 400 | 24px | +0.5px | Primary body copy |
| `body-medium` | 14px | 400 | 20px | +0.25px | Secondary body, form labels, table cells |
| `body-small` | 12px | 400 | 16px | +0.4px | Captions, metadata, timestamps |
| `label-large` | 14px | 500 | 20px | +0.1px | Button labels, tab labels |
| `label-medium` | 12px | 500 | 16px | +0.5px | Badge labels, chip labels |
| `label-small` | 11px | 500 | 16px | +0.5px | Overlines, micro-chip labels |

### Responsive Scaling

For web at `display-*` and `headline-*` levels, use CSS `clamp()` to fluid-scale between mobile minimum and desktop maximum:

```css
/* Example for display-large */
font-size: clamp(36px, 4vw, 57px);

/* Example for headline-large */
font-size: clamp(24px, 3vw, 32px);
```

In Flutter, responsive scaling is handled by `TextScaleAddon` in Widgetbook (1.0 / 1.15 / 1.3) and `MediaQuery.textScalerOf(context)` at runtime.

---

## Spacing System

**Base unit:** 4px. All spacing values are multiples of 4px.

| Token | Value | Usage |
|---|---|---|
| `space-0` | 0 | Reset / no spacing |
| `space-1` | 4px | Micro gaps (icon-to-text, badge padding) |
| `space-2` | 8px | Tight internal padding (chips, small buttons) |
| `space-3` | 12px | Compact internal padding (input padding) |
| `space-4` | 16px | Standard component internal padding |
| `space-5` | 20px | Comfortable internal padding (cards, panels) |
| `space-6` | 24px | Section padding, large component internals |
| `space-8` | 32px | Section spacing, page gutter (mobile) |
| `space-10` | 40px | Large section gaps |
| `space-12` | 48px | XL section gaps |
| `space-16` | 64px | Page-level vertical rhythm |
| `space-20` | 80px | Feature section separation |
| `space-24` | 96px | Hero sections |

---

## Grid System (Web)

| Breakpoint | Name | Columns | Gutter | Margin | Min width | Max width |
|---|---|---|---|---|---|---|
| `xs` | Mobile | 4 | 16px | 16px | 0 | 599px |
| `sm` | Tablet | 8 | 24px | 24px | 600px | 904px |
| `md` | Laptop | 12 | 24px | 32px | 905px | 1239px |
| `lg` | Desktop | 12 | 32px | 48px | 1240px | 1439px |
| `xl` | Wide | 12 | 32px | auto | 1440px+ | 1440px (content centered) |

Content is centered in a max-width container at `xl`. At `lg` and below, margins are fixed.

---

## Radius System

| Token | Value | Usage |
|---|---|---|
| `radius-none` | 0 | Tables, data grids, flush elements |
| `radius-xs` | 2px | Tiny indicators, progress bars |
| `radius-sm` | 4px | Badges, chips, small buttons |
| `radius-md` | 8px | Cards, modals, dropdowns, buttons |
| `radius-lg` | 12px | Large cards, sheets, popovers |
| `radius-xl` | 16px | Bottom sheets, side drawers |
| `radius-2xl` | 24px | Hero cards, marketing panels |
| `radius-full` | 9999px | Pills, avatars, FABs, toggle thumbs |

---

## Shadows / Elevation

| Token | Value | Usage |
|---|---|---|
| `shadow-none` | `none` | Flat surfaces, inline elements |
| `shadow-xs` | `0 1px 2px rgba(0,0,0,0.05)` | Subtle cards, timeline items |
| `shadow-sm` | `0 1px 3px rgba(0,0,0,0.10), 0 1px 2px rgba(0,0,0,0.06)` | Cards, inline dropdowns |
| `shadow-md` | `0 4px 6px rgba(0,0,0,0.07), 0 2px 4px rgba(0,0,0,0.06)` | Modals, popovers, date pickers |
| `shadow-lg` | `0 10px 15px rgba(0,0,0,0.10), 0 4px 6px rgba(0,0,0,0.05)` | Elevated panels, command palettes |
| `shadow-xl` | `0 20px 25px rgba(0,0,0,0.10), 0 10px 10px rgba(0,0,0,0.04)` | Overlays, side drawers, toasts |

Elevation is expressed through shadow only — we do not use color tinting for elevation (unlike Material 3's surface-tint system), in order to maintain clinical precision in the color palette.

---

## Color System

### Design Philosophy

- **Calm and clinical:** Avoid saturated primaries. Use muted teal-blue as the brand color.
- **Trustworthy:** High contrast, generous whitespace, restrained use of color.
- **Accessible:** All text/background combinations meet WCAG AA (4.5:1 for body, 3:1 for large text and UI components).
- **Data-dense-friendly:** Semantic status colors (danger/warning/success) are visually distinct and distinguishable without color alone.

### Primitive Palette

#### Neutral Grays

| Token | Hex | Luminance |
|---|---|---|
| `neutral-0` | `#FFFFFF` | White |
| `neutral-50` | `#F9FAFB` | Near-white surfaces |
| `neutral-100` | `#F3F4F6` | Container backgrounds |
| `neutral-200` | `#E5E7EB` | Borders, dividers |
| `neutral-300` | `#D1D5DB` | Outline, placeholder |
| `neutral-400` | `#9CA3AF` | Muted icons, placeholder text |
| `neutral-500` | `#6B7280` | Secondary text |
| `neutral-600` | `#4B5563` | Body text on light |
| `neutral-700` | `#374151` | Stronger body text |
| `neutral-800` | `#1F2937` | Headings |
| `neutral-900` | `#111827` | Primary text on light |
| `neutral-950` | `#030712` | Near-black |

#### Brand — Clinical Teal-Blue

The brand color is a desaturated teal-blue that reads as calm and medical without veering into pharmaceutical cliché. It passes AA contrast on white at `brand-600` and above.

| Token | Hex |
|---|---|
| `brand-50` | `#EFF8F8` |
| `brand-100` | `#D0EEED` |
| `brand-200` | `#A2DCDB` |
| `brand-300` | `#6CC4C2` |
| `brand-400` | `#3EAAAA` |
| `brand-500` | `#2A9090` |
| `brand-600` | `#237878` |
| `brand-700` | `#1C6060` |
| `brand-800` | `#154848` |
| `brand-900` | `#0E3030` |

#### Danger — Red

| Token | Hex |
|---|---|
| `danger-50` | `#FEF2F2` |
| `danger-100` | `#FEE2E2` |
| `danger-200` | `#FECACA` |
| `danger-300` | `#FCA5A5` |
| `danger-400` | `#F87171` |
| `danger-500` | `#EF4444` |
| `danger-600` | `#DC2626` |
| `danger-700` | `#B91C1C` |
| `danger-800` | `#991B1B` |
| `danger-900` | `#7F1D1D` |

#### Warning — Amber

| Token | Hex |
|---|---|
| `warning-50` | `#FFFBEB` |
| `warning-100` | `#FEF3C7` |
| `warning-200` | `#FDE68A` |
| `warning-300` | `#FCD34D` |
| `warning-400` | `#FBBF24` |
| `warning-500` | `#F59E0B` |
| `warning-600` | `#D97706` |
| `warning-700` | `#B45309` |
| `warning-800` | `#92400E` |
| `warning-900` | `#78350F` |

#### Success — Green

| Token | Hex |
|---|---|
| `success-50` | `#F0FDF4` |
| `success-100` | `#DCFCE7` |
| `success-200` | `#BBF7D0` |
| `success-300` | `#86EFAC` |
| `success-400` | `#4ADE80` |
| `success-500` | `#22C55E` |
| `success-600` | `#16A34A` |
| `success-700` | `#15803D` |
| `success-800` | `#166534` |
| `success-900` | `#14532D` |

---

### Semantic Color Roles — Light Theme

Semantic roles map intent to primitive tokens. Components reference semantic roles only.

| Role | Token name | Primitive | Hex |
|---|---|---|---|
| Surface | `color-surface` | neutral-0 | `#FFFFFF` |
| Surface variant | `color-surface-variant` | neutral-50 | `#F9FAFB` |
| Surface container | `color-surface-container` | neutral-100 | `#F3F4F6` |
| On surface | `color-on-surface` | neutral-900 | `#111827` |
| On surface variant | `color-on-surface-variant` | neutral-600 | `#4B5563` |
| On surface muted | `color-on-surface-muted` | neutral-400 | `#9CA3AF` |
| Primary | `color-primary` | brand-500 | `#2A9090` |
| Primary container | `color-primary-container` | brand-50 | `#EFF8F8` |
| On primary | `color-on-primary` | neutral-0 | `#FFFFFF` |
| On primary container | `color-on-primary-container` | brand-700 | `#1C6060` |
| Outline | `color-outline` | neutral-300 | `#D1D5DB` |
| Outline variant | `color-outline-variant` | neutral-200 | `#E5E7EB` |
| Scrim | `color-scrim` | neutral-900 @ 40% | `rgba(17,24,39,0.4)` |
| Danger | `color-danger` | danger-600 | `#DC2626` |
| Danger container | `color-danger-container` | danger-50 | `#FEF2F2` |
| On danger | `color-on-danger` | neutral-0 | `#FFFFFF` |
| On danger container | `color-on-danger-container` | danger-700 | `#B91C1C` |
| Warning | `color-warning` | warning-600 | `#D97706` |
| Warning container | `color-warning-container` | warning-50 | `#FFFBEB` |
| On warning | `color-on-warning` | neutral-0 | `#FFFFFF` |
| On warning container | `color-on-warning-container` | warning-800 | `#92400E` |
| Success | `color-success` | success-600 | `#16A34A` |
| Success container | `color-success-container` | success-50 | `#F0FDF4` |
| On success | `color-on-success` | neutral-0 | `#FFFFFF` |
| On success container | `color-on-success-container` | success-700 | `#15803D` |
| Neutral | `color-neutral` | neutral-600 | `#4B5563` |
| Neutral container | `color-neutral-container` | neutral-100 | `#F3F4F6` |
| On neutral container | `color-on-neutral-container` | neutral-700 | `#374151` |

---

### Semantic Color Roles — Dark Theme

| Role | Token name | Hex |
|---|---|---|
| Surface | `color-surface` | `#0F1117` |
| Surface variant | `color-surface-variant` | `#1A1F2C` |
| Surface container | `color-surface-container` | `#242A36` |
| On surface | `color-on-surface` | `#E8EAED` |
| On surface variant | `color-on-surface-variant` | `#9AA0AC` |
| On surface muted | `color-on-surface-muted` | `#5C6370` |
| Primary | `color-primary` | `#3EAAAA` (brand-400) |
| Primary container | `color-primary-container` | `#0E3030` (brand-900) |
| On primary | `color-on-primary` | `#030712` |
| On primary container | `color-on-primary-container` | `#A2DCDB` (brand-200) |
| Outline | `color-outline` | `#3A3F4B` |
| Outline variant | `color-outline-variant` | `#2D3240` |
| Scrim | `color-scrim` | `rgba(0,0,0,0.6)` |
| Danger | `color-danger` | `#F87171` (danger-400) |
| Danger container | `color-danger-container` | `#7F1D1D` (danger-900) |
| On danger | `color-on-danger` | `#030712` |
| On danger container | `color-on-danger-container` | `#FECACA` (danger-200) |
| Warning | `color-warning` | `#FBBF24` (warning-400) |
| Warning container | `color-warning-container` | `#78350F` (warning-900) |
| On warning | `color-on-warning` | `#030712` |
| On warning container | `color-on-warning-container` | `#FDE68A` (warning-200) |
| Success | `color-success` | `#4ADE80` (success-400) |
| Success container | `color-success-container` | `#14532D` (success-900) |
| On success | `color-on-success` | `#030712` |
| On success container | `color-on-success-container` | `#BBF7D0` (success-200) |
| Neutral | `color-neutral` | `#9AA0AC` |
| Neutral container | `color-neutral-container` | `#242A36` |
| On neutral container | `color-on-neutral-container` | `#CBD5E1` |

---

### Muted Pastel Badge Colors

Used for categorization badges. All text/background pairs are verified AA (4.5:1+).

| Name | Background | Text color |
|---|---|---|
| `badge-blue` | `#DBEAFE` | `#1D4ED8` |
| `badge-purple` | `#EDE9FE` | `#6D28D9` |
| `badge-pink` | `#FCE7F3` | `#BE185D` |
| `badge-orange` | `#FFEDD5` | `#C2410C` |
| `badge-yellow` | `#FEF9C3` | `#A16207` |
| `badge-teal` | `#CCFBF1` | `#0F766E` |
| `badge-green` | `#DCFCE7` | `#15803D` |
| `badge-red` | `#FEE2E2` | `#B91C1C` |
| `badge-amber` | `#FEF3C7` | `#B45309` |
| `badge-neutral` | `#F3F4F6` | `#374151` |

---

### State Layer Opacities

State layers are colored overlays drawn on top of interactive elements. The overlay color is the component's "on-color" at the given opacity.

| State | Token | Opacity |
|---|---|---|
| Hover | `state-hover` | 0.08 |
| Focus | `state-focus` | 0.12 |
| Pressed | `state-pressed` | 0.16 |
| Dragged | `state-dragged` | 0.16 |
| Disabled container | `state-disabled-container` | 0.12 |
| Disabled content | `state-disabled-content` | 0.38 |

---

## Motion

| Token | Duration | Easing | Usage |
|---|---|---|---|
| `motion-duration-instant` | 0ms | — | No animation; immediate state changes |
| `motion-duration-fast` | 100ms | `ease-out` | Micro-interactions (checkbox tick, toggle thumb) |
| `motion-duration-standard` | 200ms | `ease-in-out` | Most transitions (color changes, size changes) |
| `motion-duration-emphasized` | 300ms | `cubic-bezier(0.2,0,0,1)` | Enter/exit animations (modals, drawers, menus) |
| `motion-duration-slow` | 500ms | `ease-in-out` | Complex page transitions, skeleton loading |

### Motion Principles

- **Purposeful:** Animation communicates state changes; it does not decorate.
- **Fast by default:** Most UI transitions are 200ms or less.
- **Reduced motion:** Respect `prefers-reduced-motion` (Flutter: `MediaQuery.disableAnimations`). When true, use `instant` duration for all transitions.

---

## Iconography

**Icon set:** Material Symbols — Outlined variant, optical size 20–24, weight 300.
This provides a consistent, modern, medical-neutral icon language.

**Flutter package:** `material_symbols_icons ^4.2719.3`

### Icon Sizes

| Token | Value | Usage |
|---|---|---|
| `icon-xs` | 12px | Micro decorations (badge dot) |
| `icon-sm` | 16px | Inline icons in dense text |
| `icon-md` | 20px | Standard button icon, form field icon |
| `icon-lg` | 24px | Navigation icons, action icons |
| `icon-xl` | 32px | Large decorative icons, empty states |

### Icon Usage Rules

- Always pair icons with a text label or `Semantics(label: ...)` for accessibility.
- Icon-only interactive elements must have a `Tooltip` with the action name.
- Use `icon-md` (20px) inside buttons and form fields.
- Use `icon-lg` (24px) in navigation and standalone action areas.

---

## Opacity Tokens

| Token | Value | Usage |
|---|---|---|
| `opacity-disabled` | 0.38 | Disabled text and icons |
| `opacity-medium` | 0.60 | Secondary/muted content |
| `opacity-full` | 1.00 | Normal content |

---

## Z-Index Tokens

Z-index values define the stacking context for layered UI elements. In Flutter, these map to widget order; in web CSS they are applied directly.

| Token | Value | Usage |
|---|---|---|
| `z-base` | 0 | Normal document flow |
| `z-dropdown` | 100 | Dropdown menus, autocomplete lists |
| `z-sticky` | 200 | Sticky headers, table headers |
| `z-overlay` | 300 | Backdrops, scrims |
| `z-modal` | 400 | Modals, dialogs, bottom sheets |
| `z-toast` | 500 | Toast notifications (always on top) |
