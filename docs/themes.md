# RDS Themes

> How design tokens are exposed to components through a Dart `ThemeExtension`,
> and how light, dark, and future brand themes are structured.

---

## Theme Model

### Core Principle

Components in RDS **never** read raw values. They always read through:

```dart
final rds = Theme.of(context).extension<RdsTheme>()!;
rds.primary      // Color
rds.bodyMedium   // TextStyle
rds.space4       // double (16.0)
```

This single access pattern means:
- Theming is implemented once, in one place.
- Components are theme-agnostic — they work in light, dark, and future brand themes without changes.
- Tokens can be overridden at the `MaterialApp` level for white-labeling.

### Architecture

```
Primitive tokens (RdsColors, RdsTypography, RdsSpacing, …)
         ↓
Semantic roles (RdsThemeData — named by intent, not value)
         ↓
RdsTheme (ThemeExtension — attaches to MaterialApp's ThemeData)
         ↓
Component reads via Theme.of(context).extension<RdsTheme>()!
```

### Token Resolution

```
packages/rds/lib/tokens/rds_colors.dart
  → RdsColors.brand500 = Color(0xFF2A9090)         ← Primitive

packages/rds/lib/theme/rds_themes.dart
  → RdsThemes.light.data.primary = RdsColors.brand500   ← Semantic role

packages/rds/lib/components/button/rds_button.dart
  → color: rds.primary                              ← Component usage
```

### Classes

| Class | File | Role |
|---|---|---|
| `RdsThemeData` | `theme/rds_theme_data.dart` | Plain data class holding all semantic token fields |
| `RdsTheme` | `theme/rds_theme.dart` | `ThemeExtension<RdsTheme>` — wraps `RdsThemeData`, attaches to Flutter's `ThemeData` |
| `RdsThemes` | `theme/rds_themes.dart` | Static instances: `RdsThemes.light`, `RdsThemes.dark` + the `rdsThemeData()` helper |

---

## Light Theme

Full token values for the light theme. All values reference primitive tokens from `RdsColors`.

### Colors

| Semantic role | Dart field | Hex |
|---|---|---|
| Surface | `surface` | `#FFFFFF` |
| Surface variant | `surfaceVariant` | `#F9FAFB` |
| Surface container | `surfaceContainer` | `#F3F4F6` |
| On surface | `onSurface` | `#111827` |
| On surface variant | `onSurfaceVariant` | `#4B5563` |
| On surface muted | `onSurfaceMuted` | `#9CA3AF` |
| Primary | `primary` | `#2A9090` |
| Primary container | `primaryContainer` | `#EFF8F8` |
| On primary | `onPrimary` | `#FFFFFF` |
| On primary container | `onPrimaryContainer` | `#1C6060` |
| Outline | `outline` | `#D1D5DB` |
| Outline variant | `outlineVariant` | `#E5E7EB` |
| Scrim | `scrim` | `rgba(17,24,39, 0.40)` |
| Danger | `danger` | `#DC2626` |
| Danger container | `dangerContainer` | `#FEF2F2` |
| On danger | `onDanger` | `#FFFFFF` |
| On danger container | `onDangerContainer` | `#B91C1C` |
| Warning | `warning` | `#D97706` |
| Warning container | `warningContainer` | `#FFFBEB` |
| On warning | `onWarning` | `#FFFFFF` |
| On warning container | `onWarningContainer` | `#92400E` |
| Success | `success` | `#16A34A` |
| Success container | `successContainer` | `#F0FDF4` |
| On success | `onSuccess` | `#FFFFFF` |
| On success container | `onSuccessContainer` | `#15803D` |
| Neutral | `neutral` | `#4B5563` |
| Neutral container | `neutralContainer` | `#F3F4F6` |
| On neutral container | `onNeutralContainer` | `#374151` |

### Typography (same across themes)

Typography styles are theme-invariant. Only text *color* changes between themes (always applied via semantic `onSurface*` colors at component level).

| Field | Size | Weight | Line height | Letter spacing |
|---|---|---|---|---|
| `displayLarge` | 57px | 400 | 64px | -0.25px |
| `displayMedium` | 45px | 400 | 52px | 0 |
| `displaySmall` | 36px | 400 | 44px | 0 |
| `headlineLarge` | 32px | 400 | 40px | 0 |
| `headlineMedium` | 28px | 400 | 36px | 0 |
| `headlineSmall` | 24px | 400 | 32px | 0 |
| `titleLarge` | 22px | 500 | 28px | 0 |
| `titleMedium` | 16px | 500 | 24px | +0.15px |
| `titleSmall` | 14px | 500 | 20px | +0.1px |
| `bodyLarge` | 16px | 400 | 24px | +0.5px |
| `bodyMedium` | 14px | 400 | 20px | +0.25px |
| `bodySmall` | 12px | 400 | 16px | +0.4px |
| `labelLarge` | 14px | 500 | 20px | +0.1px |
| `labelMedium` | 12px | 500 | 16px | +0.5px |
| `labelSmall` | 11px | 500 | 16px | +0.5px |

### Spacing

Space tokens are theme-invariant. All values in logical pixels.
`space0=0, space1=4, space2=8, space3=12, space4=16, space5=20, space6=24, space8=32, space10=40, space12=48, space16=64, space20=80, space24=96`

### Radius

Radius tokens are theme-invariant.
`radiusNone=0, radiusXs=2, radiusSm=4, radiusMd=8, radiusLg=12, radiusXl=16, radius2xl=24, radiusFull=9999`

### Motion

Motion tokens are theme-invariant.
`durationInstant=0ms, durationFast=100ms, durationStandard=200ms, durationEmphasized=300ms, durationSlow=500ms`

### Opacity / State Layers

Opacity tokens are theme-invariant.
`opacityDisabled=0.38, opacityMedium=0.60, stateHover=0.08, stateFocus=0.12, statePressed=0.16`

---

## Dark Theme

The dark theme inverts the neutral scale and adjusts semantic/brand colors for dark backgrounds. All adjustments preserve WCAG AA contrast.

### Colors (dark theme overrides)

| Semantic role | Dart field | Hex | Rationale |
|---|---|---|---|
| Surface | `surface` | `#0F1117` | Very dark blue-black, not pure black |
| Surface variant | `surfaceVariant` | `#1A1F2C` | Slightly lighter panel background |
| Surface container | `surfaceContainer` | `#242A36` | Card/panel background |
| On surface | `onSurface` | `#E8EAED` | Slightly warm white for comfort |
| On surface variant | `onSurfaceVariant` | `#9AA0AC` | Secondary text |
| On surface muted | `onSurfaceMuted` | `#5C6370` | Muted/disabled text |
| Primary | `primary` | `#3EAAAA` | brand-400 — lighter for dark bg AA |
| Primary container | `primaryContainer` | `#0E3030` | brand-900 — dark teal container |
| On primary | `onPrimary` | `#030712` | Dark text on light primary |
| On primary container | `onPrimaryContainer` | `#A2DCDB` | brand-200 — light text on dark container |
| Outline | `outline` | `#3A3F4B` | Subtle border on dark |
| Outline variant | `outlineVariant` | `#2D3240` | Even subtler divider |
| Scrim | `scrim` | `rgba(0,0,0, 0.60)` | Darker scrim for dark mode |
| Danger | `danger` | `#F87171` | danger-400 — bright enough on dark |
| Danger container | `dangerContainer` | `#7F1D1D` | danger-900 — dark container |
| On danger | `onDanger` | `#030712` | Dark on bright danger |
| On danger container | `onDangerContainer` | `#FECACA` | danger-200 — light text on dark |
| Warning | `warning` | `#FBBF24` | warning-400 |
| Warning container | `warningContainer` | `#78350F` | warning-900 |
| On warning | `onWarning` | `#030712` | Dark on bright warning |
| On warning container | `onWarningContainer` | `#FDE68A` | warning-200 |
| Success | `success` | `#4ADE80` | success-400 |
| Success container | `successContainer` | `#14532D` | success-900 |
| On success | `onSuccess` | `#030712` | Dark on bright success |
| On success container | `onSuccessContainer` | `#BBF7D0` | success-200 |
| Neutral | `neutral` | `#9AA0AC` | Visible on dark surface |
| Neutral container | `neutralContainer` | `#242A36` | Same as surface-container |
| On neutral container | `onNeutralContainer` | `#CBD5E1` | Light text on dark container |

---

## Brand Theme (Future)

The brand theme is a variant of the light theme where surfaces are slightly tinted with the brand color. It is intended for future white-labeling: partner clinics may have a custom primary brand color substituted.

**Approach:** Pass custom `primary`, `primaryContainer`, `onPrimary`, and `onPrimaryContainer` values to `RdsThemeData.copyWith()`. Surface colors remain neutral.

```dart
// Future white-label example
final partnerTheme = RdsThemes.light.copyWith(
  data: RdsThemes.light.data.copyWith(
    primary: const Color(0xFF6366F1),       // Partner brand — indigo
    primaryContainer: const Color(0xFFEEF2FF),
    onPrimary: const Color(0xFFFFFFFF),
    onPrimaryContainer: const Color(0xFF3730A3),
  ),
);
```

---

## Adding a New Theme

1. Create an `RdsThemeData` instance with the desired values:
   ```dart
   const myThemeData = RdsThemeData(
     surface: Color(0xFF...),
     // ... all fields
   );
   ```

2. Wrap it in `RdsTheme`:
   ```dart
   const myTheme = RdsTheme(myThemeData);
   ```

3. Register the Material `ThemeData` using the helper:
   ```dart
   rdsThemeData(brightness: Brightness.light, rdsTheme: myTheme)
   ```

4. Add it to the Widgetbook `ThemeAddon` (see below).

5. Pass it to your `MaterialApp`:
   ```dart
   MaterialApp(
     theme: rdsThemeData(brightness: Brightness.light, rdsTheme: myTheme),
     // ...
   )
   ```

---

## Widgetbook ThemeAddon Configuration

```dart
ThemeAddon(
  themes: [
    WidgetbookTheme(
      name: 'Light',
      data: rdsThemeData(
        brightness: Brightness.light,
        rdsTheme: RdsThemes.light,
      ),
    ),
    WidgetbookTheme(
      name: 'Dark',
      data: rdsThemeData(
        brightness: Brightness.dark,
        rdsTheme: RdsThemes.dark,
      ),
    ),
    // Add brand/partner themes here:
    // WidgetbookTheme(name: 'Partner - Indigo', data: rdsThemeData(...)),
  ],
  themeBuilder: (context, theme, child) => Theme(data: theme, child: child),
),
```

The `themeBuilder` wraps every use case in the selected theme, ensuring `Theme.of(context).extension<RdsTheme>()!` always resolves correctly.

---

## Token Resolution Diagram

```
┌─────────────────────────────────────────────────┐
│  PRIMITIVE TOKENS  (rds_colors.dart, etc.)      │
│  RdsColors.brand500 = Color(0xFF2A9090)          │
│  RdsSpacing.space4  = 16.0                       │
└────────────────────────┬────────────────────────┘
                         │ referenced by
┌────────────────────────▼────────────────────────┐
│  SEMANTIC ROLES  (rds_themes.dart)               │
│  RdsThemes.light.data.primary = brand500         │
│  RdsThemes.dark.data.primary  = brand400         │
└────────────────────────┬────────────────────────┘
                         │ wrapped in ThemeExtension
┌────────────────────────▼────────────────────────┐
│  RdsTheme (ThemeExtension)                       │
│  Attached to MaterialApp via ThemeData           │
│  extensions: [RdsTheme(RdsThemes.light.data)]    │
└────────────────────────┬────────────────────────┘
                         │ read by
┌────────────────────────▼────────────────────────┐
│  COMPONENT                                       │
│  final rds = Theme.of(context)                   │
│                        .extension<RdsTheme>()!   │
│  color: rds.primary    // Color(0xFF2A9090)      │
│  padding: EdgeInsets.all(rds.space4)             │
└─────────────────────────────────────────────────┘
```
