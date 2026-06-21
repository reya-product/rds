# RDS — Reya Design System · Project Context

## Project Overview

**Reya** builds B2B and B2B2C SaaS web products for longevity and lifestyle-medicine clinics. Clinicians, care coordinators, and patients interact with dense data — lab panels, health scores, scheduling, and longitudinal trend charts — so the interface must be calm, trustworthy, and clinically precise without feeling cold.

**RDS (Reya Design System)** is the single shared UI layer for all Reya products. Its goals are:

- **Consistency:** every product surface looks and behaves identically.
- **Accessibility:** WCAG AA minimum on all interactive components.
- **Speed:** engineers pick up a component, import it, and ship. No pixel-matching with Figma.
- **Auditability:** every visual decision is documented in markdown and every value is a named token.

### Why we moved off Figma

Figma was the single source of truth, but it created drift: the Figma file, the code, and the docs diverged silently. A Figma update didn't guarantee a code update, and vice versa.

**New source of truth:**
1. **Markdown docs** (`/docs`) — intent, rationale, usage rules, anatomy.
2. **Dart design tokens** (`packages/rds/lib/tokens/`) — every concrete value (colors, sizes, durations, radii).

Figma may be used as a reference or for client presentations, but it is no longer authoritative.

---

## Audience

| Audience | How they interact with RDS |
|---|---|
| **Engineering** | Import the `rds` Flutter package (`import 'package:rds/rds.dart'`). Read component `.md` files for usage rules and API docs. |
| **QA / Design** | Browse the Widgetbook web app (the public component catalog). Use knobs to inspect every variant and state. Use the theme toggle and device addon. |
| **Foundation agent (Claude)** | Writes tokens, themes, docs, and scaffolds. Never hardcodes values. |
| **Component agents (Claude)** | Each owns one component's folder. Reads context, writes `.md`, Dart, and usecases. Obeys the shared-file rule. |

---

## Repo Map

```
.
├── docs/                            # Human-readable design docs (source of truth for intent)
│   ├── BUILD-PLAN.md                # Build orchestration plan — tiers, prompts, agent rules
│   ├── context.md                   # This file — project overview, conventions, glossary
│   ├── visual-language.md           # All visual token values: type, spacing, color, motion, etc.
│   ├── themes.md                    # Theme model, light/dark/brand themes, Widgetbook wiring
│   ├── patterns.md                  # App shell, nav, layout, empty/loading/error states
│   ├── _component-template.md       # Authoring contract — every component .md must follow this
│   └── components/                  # One .md per component (filled in by component agents)
│       ├── button.md
│       ├── badge.md
│       └── …
│
├── packages/
│   └── rds/                         # The Flutter package engineering imports
│       ├── pubspec.yaml
│       ├── analysis_options.yaml
│       └── lib/
│           ├── rds.dart             # Barrel export — edited only by the Wiring pass
│           ├── tokens/              # Primitive + semantic design tokens (Dart constants)
│           │   ├── rds_colors.dart
│           │   ├── rds_typography.dart
│           │   ├── rds_spacing.dart
│           │   ├── rds_radius.dart
│           │   ├── rds_shadows.dart
│           │   ├── rds_motion.dart
│           │   ├── rds_opacity.dart
│           │   ├── rds_icons.dart
│           │   └── rds_icon_size.dart
│           ├── theme/               # RdsTheme ThemeExtension + light/dark instances
│           │   ├── rds_theme_data.dart
│           │   ├── rds_theme.dart
│           │   └── rds_themes.dart
│           └── components/          # One sub-folder per component
│               ├── button/
│               │   └── rds_button.dart
│               └── …
│
└── widgetbook/                      # Public component catalog (Flutter web app)
    ├── pubspec.yaml
    ├── analysis_options.yaml
    └── lib/
        ├── main.dart                # Widgetbook root — edited only by the Wiring pass
        └── usecases/                # One usecases file per component
            ├── button.usecases.dart
            └── …
    └── web/
        ├── index.html
        └── manifest.json
```

---

## How to Run the Renderer

### Development (hot reload)
```bash
cd widgetbook
flutter pub get
flutter run -d chrome
```

### Production build
```bash
cd widgetbook
flutter build web --release
# Output is in widgetbook/build/web/
```

For deployment to a subpath (e.g. GitHub Pages at `/rds`):
```bash
flutter build web --release --base-href /rds/
```

### First-time setup
```bash
# Install dependencies for both packages (widgetbook's path dep handles rds automatically)
cd widgetbook && flutter pub get
```

---

## Authoring Contract Summary

Every component markdown file **must** follow the template in `docs/_component-template.md`. The required sections are:

1. Component name + one-line purpose
2. When to use / when not to use
3. Anatomy (labeled parts)
4. Variants
5. Configs (props table → these become Widgetbook knobs)
6. States
7. Sizes (if applicable)
8. Tokens used (token names only — no raw values)
9. Behavior & interaction
10. Accessibility
11. Content guidelines
12. Composition (which RDS components it uses / is used by)
13. Flutter API (class name, constructor, public enums)
14. Widgetbook (use cases + knobs)
15. Do / Don't

See `docs/_component-template.md` for the full fill-in-the-blank template.

---

## Dependency Tiers

Components are built in tiers to respect compositional dependencies. Build a tier fully, run the Wiring pass, verify the renderer, commit, then start the next tier.

| Tier | Name | Components | Depends on |
|---|---|---|---|
| **T0** | Foundation | Tokens, themes, docs, scaffolds | — |
| **T1** | Atoms | Button, Button group, Segmented buttons, Badge, Avatar, Tooltip, Input chip, Checkbox, Radio, Toggle switch, Toast, Tabs, Vertical tabs, Date/Time pickers, Text field, Text area, Password, Search bar | Tokens only |
| **T2a** | Molecules | List Item *(keystone)*, Field groups, Field uploader, Segmented control input, Checkbox-with-label input, Date/Time/Date-&-Time fields | T1 |
| **T2b** | List-based | Dropdown popup, List, Multi-select input, Single-select input, Toggle list input | List Item, List |
| **T3** | Organisms | Card, Dropdown field, Combobox field | T2a / T2b |
| **On hold** | — | Table | — |

**Why List Item is a keystone:** it composes Avatar + Badge + Checkbox + Radio + Toggle; everything above T2a depends on it.

---

## Shared-File Rule (Critical for parallel agents)

Each component agent may **only** create or edit files in its own component's folder:
- `docs/components/<name>.md`
- `packages/rds/lib/components/<name>/`
- `widgetbook/lib/usecases/<name>.usecases.dart`

Agents must **never** touch:
- `packages/rds/lib/rds.dart` (barrel export)
- `widgetbook/lib/main.dart`
- `packages/rds/lib/tokens/` (any token file)
- `packages/rds/lib/theme/` (any theme file)
- Any `pubspec.yaml`

At the end of each component run, the agent outputs the lines it needs added to `rds.dart` and `main.dart`. The **Wiring pass** (sequential, after the tier completes) applies those edits.

---

## Naming Conventions

| Thing | Convention | Example |
|---|---|---|
| Dart class | `Rds` prefix + PascalCase | `RdsButton` |
| Dart file | `rds_` prefix + snake_case | `rds_button.dart` |
| Docs file | snake_case, no prefix | `button.md` |
| Widgetbook usecases file | snake_case + `.usecases.dart` | `button.usecases.dart` |
| Component folder | snake_case, no prefix | `packages/rds/lib/components/button/` |
| Enum values | lowerCamelCase | `RdsButtonVariant.primary` |
| Token class | `Rds` prefix + PascalCase | `RdsColors`, `RdsSpacing` |

---

## Definition of Done

### Per Component
- [ ] `docs/components/<name>.md` is complete per the authoring contract
- [ ] Dart widget in `packages/rds/lib/components/<name>/rds_<name>.dart`
- [ ] Token-only styling — zero hardcoded colors, sizes, radii, shadows
- [ ] All applicable states: enabled, hover, focus, pressed, disabled (+ component-specific)
- [ ] All variants implemented
- [ ] `Semantics` widget present for accessibility
- [ ] Min 44px touch target for interactive components
- [ ] `widgetbook/lib/usecases/<name>.usecases.dart` with every config as a knob + Gallery use case
- [ ] `flutter analyze` clean
- [ ] Renders correctly in light and dark themes
- [ ] Export line added to `rds.dart` (by Wiring pass)
- [ ] Registered in `widgetbook/lib/main.dart` (by Wiring pass)

### Whole System
- [ ] Every non-hold component shipped per the per-component DoD
- [ ] Widgetbook builds to web (`flutter build web --release`)
- [ ] Public URL live and loading
- [ ] Theme switching (light/dark) works in the catalog
- [ ] Device addon previews breakpoints correctly
- [ ] No hardcoded style values anywhere in component code

---

## Glossary

| Term | Definition |
|---|---|
| **Token** | A named constant for a design decision (e.g. `RdsSpacing.space4 = 16.0`). Tokens are the only source of style values in component code. |
| **Semantic role** | A token whose name describes *intent* rather than *value* (e.g. `color-primary`, not `#2A9090`). Semantic tokens reference primitive tokens. |
| **State layer** | A semi-transparent overlay applied to an interactive element to communicate its interaction state (hover, focus, pressed). Defined as opacity multiplied by the on-color. |
| **Widgetbook use case** | A single named scenario for a component in the Widgetbook catalog (e.g. "Primary button — loading state"). Corresponds to a `WidgetbookUseCase` in Dart. |
| **Knob** | A Widgetbook control that lets a viewer change a component prop at runtime (e.g. a boolean knob to toggle `disabled`). Accessed via `context.knobs.*`. |
| **Barrel export** | A Dart file that re-exports many other files so importers only need one `import` statement. RDS uses `packages/rds/lib/rds.dart` as its barrel. |
| **Tier** | A dependency level in the build plan. All components in a tier can be built in parallel. Higher tiers depend on lower tiers. |
| **Wiring pass** | A sequential step after a tier completes where the orchestrator adds export lines to `rds.dart` and registers components in `main.dart`. Only this pass may edit shared files. |
| **Authoring contract** | The mandatory structure for every component markdown file. Defined in `docs/_component-template.md`. |
| **T0** | The Foundation tier: tokens, themes, docs, both project scaffolds. Built first, sequentially. |
