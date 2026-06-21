# RDS — Reya Design System · Claude Code Build Plan & Prompts

A copy‑paste kit for building the Reya Design System (RDS) end‑to‑end with Claude Code:
the markdown knowledge base, the Flutter component library, and a public Widgetbook
renderer — using parallel agents wherever the dependency graph allows.

---

## 0. How to use this file

1. Open Claude Code at the root of your empty folder.
2. Paste **Prompt 1 (Foundation)** and let it finish. This builds everything downstream depends on. Verify the renderer runs, then commit.
3. For each tier (T1 → T2a → T2b → T3), paste the matching **Tier Dispatch** prompt. The orchestrator spawns one sub‑agent per component group, in parallel, each running the **Per‑Component Agent** template. (Manual alternative: open N terminals and paste the Per‑Component prompt in each, one disjoint group per terminal.)
4. After each tier, paste the **Wiring & Render pass** prompt (it touches the shared files agents are forbidden to edit), verify in the browser, commit.
5. When all tiers are done, paste the **Final QA & Deploy** prompt to publish RDS publicly.

> Keep this file in the repo as `docs/BUILD-PLAN.md` so every agent can read it.

---

## 1. Decisions locked

- **Framework:** Flutter (matches the dev team).
- **Library:** a Flutter package `rds` — what engineering imports.
- **Renderer:** a separate Flutter‑web app using **Widgetbook** — the public, browsable catalog. Knobs toggle every config; a theme addon switches themes; a device addon previews breakpoints. (If you want the lightest possible option instead, `storybook_flutter` works too; this plan assumes Widgetbook.)
- **Name:** RDS — Reya Design System. Public by default.
- **Single source of truth:** Markdown docs (`/docs`) for intent + Dart **design tokens** for values. Components read **only** from tokens — no hardcoded colors, sizes, radii, or shadows anywhere.
- **Audience:** engineering (consumes `rds`) and QA (browses the Widgetbook web build).
- **Brand tone to encode in the visual language:** calm, clinical, trustworthy, modern; generous whitespace; restrained, accessible color; comfortable with data‑dense SaaS screens for longevity / lifestyle‑medicine clinics. The Foundation agent proposes the specifics and documents them — it does not leave them implicit.

---

## 2. Target repository structure

```
.
├── docs/
│   ├── BUILD-PLAN.md            # this file
│   ├── context.md               # project brief + conventions (the map)
│   ├── visual-language.md       # type, scale, spacing, grid, radius, shadows, color, motion, icons
│   ├── themes.md                # theme model + light/dark/brand themes
│   ├── patterns.md              # app shell, nav strip, layout & navigation patterns
│   ├── _component-template.md   # the authoring contract (every component .md follows this)
│   └── components/
│       ├── button.md
│       ├── badge.md
│       └── …one per component
├── packages/
│   └── rds/                     # the library engineering consumes
│       ├── lib/
│       │   ├── rds.dart         # barrel export (wired by the Wiring pass only)
│       │   ├── tokens/          # colors, typography, spacing, radius, shadows, motion, opacity
│       │   ├── theme/           # RdsTheme ThemeExtension + light/dark themes
│       │   └── components/<name>/…dart
│       └── pubspec.yaml
└── widgetbook/                  # the public renderer (RDS)
    ├── lib/
    │   ├── main.dart            # Widgetbook root + addons (wired by the Wiring pass only)
    │   └── usecases/<name>.usecases.dart
    ├── web/
    └── pubspec.yaml             # depends on rds via path
```

---

## 3. The component authoring contract

Every `docs/components/<name>.md` MUST contain these sections, in this order. This is what keeps parallel agents consistent — the Foundation agent writes it to `docs/_component-template.md` and every component agent fills it in.

```
# <Component name>
> One‑line purpose.

## When to use / when not to use
## Anatomy            # labeled parts (text description; ASCII sketch if helpful)
## Variants           # named variants from the brief
## Configs (props)    # table: prop | type | default | description  → these map 1:1 to Widgetbook knobs
## States             # enabled, hover, focus, pressed, disabled, read‑only, error, selected, loading — as applicable; note the token used per state
## Sizes              # if the component has sizes
## Tokens used        # reference visual-language tokens by name; NO raw values
## Behavior & interaction   # gestures, keyboard, focus order, dismissal, animation
## Accessibility      # semantics label, min target (≥44px), contrast, screen‑reader notes
## Content guidelines # label length, truncation, casing
## Composition        # which RDS components it uses / is used by
## Flutter API        # widget name, constructor signature, public enums
## Widgetbook         # the use case(s) + which knobs expose which configs
## Do / Don't
```

---

## 4. Foundation deliverables — required contents

**`context.md`** — project overview and goals (move off Figma, md + tokens are source of truth, Flutter, public RDS renderer); audience; the repo map; how to run the renderer; the authoring contract summary; the dependency tiers and the shared‑file rule; naming conventions (`RdsButton`, `rds_button.dart`, `button.md`, `button.usecases.dart`); the Definition of Done; a short glossary.

**`visual-language.md`** —
- **Typography:** font family + fallbacks; full **type scale** (display / headline / title / body / label levels with size, weight, line‑height, letter‑spacing); responsive scaling notes.
- **Spacing system:** base unit (e.g. 4px) and the full scale.
- **Grid system:** columns, gutters, margins, and **breakpoints** (this is web).
- **Radius system:** named radius scale.
- **Shadows / elevation:** named elevation scale with usage.
- **Color system:** primitive palette → **semantic roles** (surface, on‑surface, primary, on‑primary, outline, etc.); the four **semantic colors** (danger / warning / success / neutral); the **muted pastel** background set for badges; **state‑layer** overlay opacities (hover / focus / pressed).
- **Motion:** durations + easing curves. **Iconography:** icon set, sizes, stroke. **Opacity & z‑index** tokens.

**`themes.md`** — the theme model (tokens exposed via a Dart `ThemeExtension` so components read `Theme.of(context).extension<RdsTheme>()`); light + dark (plus any brand theme); how to add a new theme; how it wires to the Widgetbook ThemeAddon.

**`patterns.md`** — app shell / layout; the **vertical navigation strip** (built from Vertical Tabs); top bar; content regions; responsive behavior; density; empty / loading / error states; example page templates.

Plus the Dart tokens + `RdsTheme` extension + light/dark themes, and both Flutter projects scaffolded and building.

---

## 5. Dependency tiers & parallel‑agent plan

Build a tier fully (parallel within the tier), wire + render‑check, commit, then start the next tier.

| Tier | Build in parallel | Depends on |
|------|-------------------|------------|
| **T0 Foundation** *(sequential, 1 agent)* | tokens, themes, context.md, visual-language.md, themes.md, patterns.md, _component-template.md, both project scaffolds | — |
| **T1 Atoms** *(parallel; suggested 5 agents)* | A: Button, Button group, Segmented buttons · B: Badge, Avatar, Tooltip, Input chip · C: Checkbox, Radio, Toggle switch, Toast · D: Tabs, Vertical tabs · E: Date/Time pickers (single, range, date‑time, time) · F: base fields — Text field (char/number/float/int), Text area, Password, Search bar | tokens only |
| **T2a Molecules** *(parallel)* | List Item *(keystone)* · Field groups · Field uploader · Segmented control input · Checkbox‑with‑label input · Date / Time / Date‑&‑Time fields | T1 |
| **T2b** *(parallel, needs List Item)* | Dropdown popup · List · Multi‑select / Single‑select / Toggle list inputs | List Item, List |
| **T3 Organisms** *(parallel)* | Card · Dropdown field · Combobox field | T2a/T2b |
| **On hold** | Table | — |

Why tiered: List Item composes Avatar + Badge + Checkbox + Radio + Toggle; Card composes List Item + Badge + Avatar + Buttons; Dropdown popup and the list‑inputs compose List Item / List. Agents must be able to `import` finished dependencies, so dependencies ship a tier earlier.

---

## 6. Shared‑file rule (prevents parallel conflicts)

Parallel agents may **only create/edit files inside their own component's folders**:
`docs/components/<name>.md`, `packages/rds/lib/components/<name>/…`, `widgetbook/lib/usecases/<name>.usecases.dart`.

They must **NOT** touch shared files: `packages/rds/lib/rds.dart` (barrel), `widgetbook/lib/main.dart`, tokens, themes, or `pubspec.yaml`. Each agent instead **ends its run by listing the export line(s) and the use‑case registration** it needs. The **Wiring pass** (run by the orchestrator after the tier) makes those edits in one place, then runs the renderer.

---

## 7. The prompts

### Prompt 1 — Foundation (run first, single agent)

```
You are setting up RDS (Reya Design System) in this empty repo. Reya builds B2B/B2B2C
SaaS web products for longevity & lifestyle‑medicine clinics. We are moving off Figma:
markdown docs + Dart design tokens are the source of truth, the library is a Flutter
package, and the public catalog is a Widgetbook web app. Read docs/BUILD-PLAN.md if
present; otherwise follow this.

Do, in order:
1. Create the repo structure in section 2 of the build plan.
2. Write docs/context.md, docs/visual-language.md, docs/themes.md, docs/patterns.md,
   and docs/_component-template.md with the full contents specified in section 4 and
   the authoring contract in section 3. Propose concrete values for the visual language
   (a calm, clinical, trustworthy, accessible, data‑dense‑friendly system) and document
   every decision — leave nothing implicit. WCAG AA contrast minimum.
3. Implement Dart design tokens under packages/rds/lib/tokens (colors, typography,
   spacing, radius, shadows, motion, opacity/state‑layers) and an RdsTheme ThemeExtension
   with light and dark themes under packages/rds/lib/theme. Components will read values
   ONLY through these — never hardcode style values.
4. Scaffold the `rds` package (with an empty rds.dart barrel) and a `widgetbook` app that
   depends on rds by path, with ThemeAddon (light/dark), a DeviceFrame/viewport addon, and
   one placeholder use case. Title it "RDS — Reya Design System".
5. Run `flutter analyze` (clean) and confirm `flutter run -d chrome` and
   `flutter build web` both succeed for the widgetbook app.
6. Print a short summary and the exact commands to run the renderer.

Golden rules for the whole project: token‑only styling; one component = one folder + one
.md + one usecases file; follow the authoring contract exactly; AA contrast; min 44px
touch targets; add Semantics for accessibility.
```

### Prompt 2 — Tier dispatch (parallel sub‑agents)

```
We are building Tier <T1 | T2a | T2b | T3> of RDS. Spawn one sub‑agent per group below,
running them IN PARALLEL. Give each sub‑agent the Per‑Component Agent prompt (next section)
with its group's components and their dependencies. Each sub‑agent obeys the shared‑file
rule: it edits only its own component folders and reports its exports/registrations back.

Groups for this tier:
<paste the relevant rows from the section‑5 table, e.g. for T1:
  Agent A: Button, Button group, Segmented buttons
  Agent B: Badge, Avatar, Tooltip, Input chip
  Agent C: Checkbox, Radio, Toggle switch, Toast
  Agent D: Tabs, Vertical tabs
  Agent E: Date/Time pickers
  Agent F: Text field, Text area, Password, Search bar>

Wait for all sub‑agents to finish, then collect every export line and use‑case
registration they reported and hand them to me for the Wiring pass. Do NOT edit shared
files yourself during this step.
```

### Prompt 3 — Per‑Component Agent (template, parameterized)

```
You own these RDS components: <LIST>. Tier: <TIER>. Dependencies you may import: <DEPS or "tokens only">.

Before coding: read docs/context.md, docs/visual-language.md, docs/themes.md,
docs/_component-template.md, and the .md + Dart of each dependency in <DEPS>.

For EACH component you own:
1. Write docs/components/<name>.md following the authoring contract exactly, using the
   build requirements in the appendix for that component (variants, configs, states).
2. Implement packages/rds/lib/components/<name>/<files>.dart. Token‑only styling; compose
   existing RDS components for dependencies (don't re‑implement them); cover every variant
   and every applicable state (enabled, hover, focus, pressed, disabled, read‑only, error,
   selected, loading); add Semantics; expose a clean constructor with enums for variants.
3. Create widgetbook/lib/usecases/<name>.usecases.dart with a WidgetbookComponent whose
   use cases expose EVERY config as a knob (boolean/string/list/options), plus one
   "Gallery" use case that lays out all variants × key states at once for visual review.
4. Run `flutter analyze` until clean.

SHARED‑FILE RULE: do not edit rds.dart, widgetbook/lib/main.dart, tokens, themes, or any
pubspec. At the end, output (a) the export lines to add to rds.dart and (b) the
WidgetbookComponent(s) to register in main.dart, for the Wiring pass.
```

### Prompt 4 — Wiring & Render pass (between tiers)

```
Tier <T> sub‑agents are done. Now: add all reported export lines to
packages/rds/lib/rds.dart and register all reported WidgetbookComponents in
widgetbook/lib/main.dart (organized into a folder/section per tier). Run `flutter analyze`
clean, then `flutter run -d chrome`. Confirm every new component appears in the catalog,
its knobs toggle correctly, and it renders in both light and dark themes. Fix any wiring
issues. Commit with message "RDS <T>: <components>".
```

### Prompt 5 — Final QA & Deploy (public)

```
Final pass for RDS:
1. Verify every component (except Table, on hold) has: a complete .md per contract, a
   token‑only Flutter implementation with all states/variants, and Widgetbook use cases
   with knobs for every config plus a Gallery use case. List any gaps and fix them.
2. Run `flutter analyze` clean across both projects.
3. Build the public catalog: `flutter build web --release` in widgetbook (set --base-href
   if deploying to a subpath). Then deploy the build to a public host — propose the
   simplest path (GitHub Pages via a gh-pages action, or Firebase Hosting, or Netlify) and
   set it up. Confirm the public URL loads, the theme switcher works, and the device
   addon previews breakpoints.
4. Update docs/context.md with the live URL and run instructions.
```

---

## 8. Definition of Done

**Per component:** `.md` complete per contract · Flutter widget implemented with token‑only styling · all applicable states + variants · Widgetbook use cases expose every config as a knob + a Gallery use case · `flutter analyze` clean · renders in light & dark · Semantics present.

**Whole system:** every non‑hold component shipped · renderer builds to web · public URL live · theme switching works · no hardcoded style values anywhere.

---

## 9. Component build requirements (appendix for Prompt 3)

States below are the *applicable* ones; include only those that make sense per component. All interactive components: enabled, hover, focus, pressed, disabled.

**Button** — variants: Primary, Tonal, Outlined, Text; semantic tone: default + Danger. Icon: none / leading / trailing / icon‑only. Configs: variant, tone, iconPosition, label, size, loading, disabled, fullWidth. States: + loading.
**Button group** — a row of related Buttons, optionally single/multi‑selectable. Configs: items, selectionMode, selected. *Uses Button.*
**Segmented buttons (outlined)** — single/multi‑select outlined segments. Configs: segments, selectionMode, selected, showIcons. States: + selected.
**Tabs** — variants: Primary, Secondary. Icon: none / leading / icon‑only. Configs: tabs, selected, variant, iconMode. States: + selected.
**Vertical tabs** — for the nav strip. Modes: with icons / without / icon‑only. Configs: items, selected, iconMode, collapsed. States: + selected.
**Input chip** — icon: none / leading / icon‑only. Toggle: click selects, click again deselects. Configs: label, iconMode, selected, disabled. States: + selected.
**Checkbox** — checked / unchecked / indeterminate. States: + read‑only, error.
**Radio** — selected / unselected. States: + read‑only, error.
**Toggle switch** — on / off. States: + read‑only.
**Tooltip** — Configs: message, placement, trigger (hover/focus/long‑press), delay.
**Toast** — semantic variants: Danger, Warning, Success, Neutral. Functional: auto‑dismiss (with duration) / manual‑dismiss; optional action button and/or link. Configs: variant, title, message, dismissMode, duration, action, link.
**Badge** — icon: none / leading / icon‑only. Configs: label, iconMode, color (muted pastel set + semantic), size.
**Avatar** — circular. Configs: type (image / icon / initials), backgroundColor (on/off + color), size.
**Date & Time pickers (M3‑inspired)** — variants: single date, date range, date+time, time only. Configs per variant; min/max; locale.
**Text field / Text area / Password / Search bar** — base field shell with: label, placeholder, leading/trailing icon (or none), support text, mandatory vs optional. Input types for Text field: characters, integer, float, number. States: enabled, hover, focus, filled, error, disabled, read‑only.
**List Item** *(uses Avatar, Badge, Checkbox, Radio, Toggle, Icon)* — independently toggleable parts: overline (UPPERCASE) · primary text · supporting text · leading = none/icon/avatar/checkbox/radio/toggle · trailing = none/icon/avatar/checkbox/radio/toggle · badge position = none / above overline / below primary‑above‑supporting / below supporting. Configs expose each toggle. States: + selected; optionally clickable.
**Field groups** — join two fields seamlessly (no gap). Examples: country‑flag dropdown + number (mobile number); number/float + unit dropdown (kg/lbs). Configs: the two child fields, shared states.
**Field uploader** — single vs multiple files. States + uploading/error.
**Segmented control input** — Segmented buttons wrapped as a form field (label, support, states). *Uses Segmented buttons.*
**Checkbox‑with‑label input** — e.g. "I agree to terms". *Uses Checkbox.*
**Date / Time / Date‑&‑Time fields** — form field that opens the matching picker. *Uses pickers + base field.*
**Dropdown popup** *(uses List Item)* — floating surface of List Items; Configs: items, selection, maxHeight/scroll.
**List** *(uses List Item)* — vertical stack; Configs: items, dividers, density.
**Multi‑select / Single‑select / Toggle list inputs** *(use List + List Item)* — selectable list as a form input via leading/trailing checkbox / radio / toggle.
**Card** *(uses List Item, Badge, Avatar, Button/Icon button)* — header (optional) / body / footer (optional). Header: left primary text OR less‑prominent secondary text; secondary text may also sit at the right end; left/right text replaceable by a Badge; right end may hold an icon button. Body: List Item variations OR an image. Footer: one or more text or icon‑only buttons separated by muted vertical separators.
**Dropdown field** *(uses Dropdown popup + base field)* — single value.
**Combobox field** *(uses Input chip + Dropdown popup + base field)* — multiple values shown as removable chips (x to remove).
**Table** — ON HOLD. Do not build yet.
