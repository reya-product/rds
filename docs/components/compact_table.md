# Compact Table
> A dense, read-only data table with a sticky header row and thin row dividers. Designed for embedding inside cards, drawers, or summary panels where vertical space is limited.

## When to use / when not to use

**Use when:**
- Displaying structured, multi-column data inline (e.g. measurement history, lab results, appointment list)
- The data is read-only and fits within the container width without horizontal scrolling
- 3–30 rows with 2–6 columns

**Do not use when:**
- The user needs to sort, filter, or paginate — use the full table (T3 Large Table, coming later)
- Only one column — use `RdsList`
- The data needs inline editing — use a form

## Anatomy

```
┌──────────────────────────────────────────────────┐
│  DATE         SOURCE       WEIGHT       BMI      │  ← header row (surfaceVariant bg)
├──────────────────────────────────────────────────┤  ← outline divider
│  Oct 15, 2023  At Center   180 lbs     22.20     │  ← data row
├ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┤  ← outlineVariant divider
│  Aug 30, 2023  At Center   179 lbs     11        │
└──────────────────────────────────────────────────┘
```

Parts:
1. **Outer container** — rounded `radiusLg` border, `outline` color (when `outlined: true`)
2. **Header row** — `surfaceVariant` background, uppercase `labelSmall` labels
3. **Header-body divider** — 1px `outline` (slightly more prominent than row dividers)
4. **Data row** — `surface` background; or striped tint on odd rows when `striped: true`
5. **Row divider** — 1px `outlineVariant` between adjacent rows
6. **Empty state** — centered `bodyMedium` message in `onSurfaceMuted`

## Configs (props)

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `columns` | `List<RdsCompactTableColumn<T>>` | required | Column definitions in display order |
| `rows` | `List<T>` | required | Data items to render |
| `outlined` | `bool` | true | Show 1px outer border with `radiusLg` corners |
| `striped` | `bool` | false | Alternating faint `surfaceVariant` tint on odd rows |
| `onRowTap` | `void Function(T row)?` | null | Makes rows tappable; shows hover/press ink |
| `emptyMessage` | `String` | `'No data'` | Shown when `rows` is empty |

## RdsCompactTableColumn props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `header` | `String` | required | Column label (auto-uppercased) |
| `cellBuilder` | `Widget Function(BuildContext, T)` | required | Builds the cell widget |
| `flex` | `int` | 1 | Column width weight (relative, like `Expanded.flex`) |
| `alignment` | `Alignment` | `centerLeft` | Aligns both header label and cell widget |

## Tokens used

| Element | Token |
|---------|-------|
| Outer border | `color-outline`, `radius-lg` |
| Header background | `color-surface-variant` |
| Header text | `color-on-surface-variant`, `label-small`, `letter-spacing: 0.8` |
| Header-body divider | `color-outline`, 1px |
| Row background | `color-surface` |
| Row background (striped odd) | `color-surface-variant` @ 40% opacity |
| Row divider | `color-outline-variant`, 1px |
| Row hover overlay | `color-on-surface` @ 6% opacity |
| Empty state text | `color-on-surface-muted`, `body-medium` |
| Header padding | `space-4` horizontal, `space-4` vertical |
| Cell padding | `space-4` horizontal, `space-5` vertical |
| Empty state padding | `space-8` all sides |

## Cell styling conventions

The `cellBuilder` controls all cell text styling. Recommended conventions for consistency:

| Content type | Style |
|-------------|-------|
| Primary identifier (date, name) | `bodyMedium`, `onSurface` |
| Secondary/provenance | `bodyMedium`, `onSurfaceMuted` |
| Metric / value | `bodyMedium`, `onSurface`, `fontWeight: w600` |
| Numeric / derived | `bodyMedium`, `onSurfaceVariant` |
| Right-aligned number | `alignment: Alignment.centerRight` on column |

## Behavior & interaction

1. **Static (default)** — no interaction; rows are not tappable.
2. **Tappable rows** — when `onRowTap` is set each row wraps in an `InkWell` with a `Material` ancestor for the ink effect. Cursor changes to pointer.
3. **Empty state** — when `rows` is empty the body zone shows `emptyMessage` centered in `bodyMedium`/`onSurfaceMuted`.
4. **Column widths** — flex-based; no fixed-pixel widths. The table fills its container width.
5. **Overflow** — long cell content is handled by the caller's cell widget (e.g. `overflow: TextOverflow.ellipsis`). The table does not scroll horizontally.

## Accessibility

- Header cells are `Text` widgets; screen readers announce column names as they navigate cells
- Tappable rows have `Semantics(button: true)` via `InkWell`
- No built-in sort/filter semantics (those belong in the full table)

## Content guidelines

- **Column headers:** noun phrases, ≤ 3 words. The widget uppercases them automatically.
- **Numeric columns:** right-align (`alignment: Alignment.centerRight`) for easier scanning
- **Units:** include in the cell value (e.g. "180 lbs") not in the header
- **Dates:** use a consistent, locale-appropriate format (e.g. "Oct 15, 2023")

## Composition

- Standalone widget; does not compose other RDS components
- Designed to embed inside `RdsCard` (set `outlined: false` when the card already provides a border) or standalone
- For the full feature-rich table (sort, filter, pagination) use `RdsDataTable` (planned)

## Flutter API

```dart
RdsCompactTable<WeightEntry>(
  columns: [
    RdsCompactTableColumn(
      header: 'Date',
      flex: 3,
      cellBuilder: (ctx, row) {
        final rds = Theme.of(ctx).extension<RdsTheme>()!;
        return Text(row.date, style: rds.bodyMedium.copyWith(color: rds.onSurface));
      },
    ),
    RdsCompactTableColumn(
      header: 'Source',
      flex: 2,
      cellBuilder: (ctx, row) {
        final rds = Theme.of(ctx).extension<RdsTheme>()!;
        return Text(row.source, style: rds.bodyMedium.copyWith(color: rds.onSurfaceMuted));
      },
    ),
    RdsCompactTableColumn(
      header: 'Weight',
      flex: 2,
      cellBuilder: (ctx, row) {
        final rds = Theme.of(ctx).extension<RdsTheme>()!;
        return Text(
          row.weight,
          style: rds.bodyMedium.copyWith(
            color: rds.onSurface,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    ),
    RdsCompactTableColumn(
      header: 'BMI',
      flex: 2,
      alignment: Alignment.centerRight,
      cellBuilder: (ctx, row) {
        final rds = Theme.of(ctx).extension<RdsTheme>()!;
        return Text(row.bmi, style: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant));
      },
    ),
  ],
  rows: weightHistory,
  outlined: true,
  onRowTap: (entry) => _showDetail(entry),
)

// Embedded inside an RdsCard body — no redundant outer border
RdsCard(
  headerPrimaryText: 'Weight history',
  bodyContent: RdsCompactTable<WeightEntry>(
    columns: [...],
    rows: weightHistory,
    outlined: false,
  ),
)
```

## Widgetbook

- `compactTableComponent` — use cases: Body weight log (mirrors screenshot), Playground, Empty state, Striped rows, Tappable rows, No outline

## Do / Don't

**Do:**
- Set `outlined: false` when embedding inside `RdsCard` (the card already provides a border)
- Right-align numeric columns for easier scanning
- Use `striped: true` for tables with 8+ rows to aid row tracking
- Add `onRowTap` only when tapping navigates or opens a detail view

**Don't:**
- Don't put interactive controls (buttons, dropdowns) in cells — that belongs in the full table
- Don't use more than 6 columns — the cells become too narrow to read
- Don't hardcode any px sizes or colors in `cellBuilder` — always read from `RdsTheme`
