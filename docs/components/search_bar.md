# Search Bar

> A compact, pill-shaped input for filtering or searching content within a view. Always visible; no floating label.

---

## When to use / when not to use

**Use when:**
- The user needs to search or filter a list, table, or dataset on the current screen.
- A lightweight, inline search input is required (not a full-page search experience).
- The search is immediate/as-you-type — no submit step is needed.

**Do not use when:**
- A labeled form field is required — use `RdsTextField`.
- The input collects structured data (dates, numbers, names) rather than performing a search.
- The search navigates to a new page — consider a more prominent search pattern (e.g. a top-app-bar search).
- Password input is needed — use `RdsPasswordField`.

---

## Anatomy

```
╭──────────────────────────────────────────────────╮
│  🔍  Search patients…                         ×  │  ← 40px height, radiusFull
╰──────────────────────────────────────────────────╯
```

| Part | Description |
|---|---|
| 1. Container | Pill-shaped (radiusFull). Height fixed at 40px. Background toggles between `surfaceContainer` (unfocused) and `surface` (focused). |
| 2. Search icon | Always visible at the leading edge. `RdsIcons.search`, `icon-md`. Not tappable. |
| 3. Input area | Single-line editable region. No floating label — placeholder text is always present. |
| 4. Clear button (×) | Trailing `RdsIcons.close` icon. Appears only when the field contains text; fades out when empty. |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| Empty | `surfaceContainer` background; search icon + placeholder visible; no clear button | Default state before the user types |
| Active (has content) | Background transitions to `surface` on focus; clear button fades in | User has entered a query |
| Disabled | `opacity-disabled` applied; no interaction | When search is temporarily unavailable |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `placeholder` | `String` | `'Search…'` | Hint text shown when empty. |
| `controller` | `TextEditingController?` | `null` | External text controller. |
| `focusNode` | `FocusNode?` | `null` | External focus node. |
| `disabled` | `bool` | `false` | Disables all interaction; applies `opacity-disabled`. |
| `onChanged` | `ValueChanged<String>?` | `null` | Called on every keystroke. |
| `onSubmitted` | `ValueChanged<String>?` | `null` | Called when the user presses Enter/Search. |
| `onClear` | `VoidCallback?` | `null` | Called when the clear button is tapped. If null, the field is cleared internally and `onChanged('')` is called. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Empty / unfocused | Default, no content | `surfaceContainer` background, no border, no clear button | `color-surface-container` |
| Focused (empty) | Field gains focus | `surface` background; `primary` border (2px) | `color-surface`, `color-primary` |
| Active (has content) | User has typed text | Clear button fades in; same border/bg as focused | — |
| Clear button visible | `_hasValue == true` | `RdsIcons.close` at trailing edge at full opacity | — |
| Clear button hidden | `_hasValue == false` | Trailing icon at opacity 0; non-interactive | — |
| Disabled | `disabled: true` | Full field at `opacity-disabled`; pointer not allowed | `opacity-disabled` |

---

## Sizes

| Size | Height | Shape | H-padding | Icon size |
|---|---|---|---|---|
| Default | 40px | Pill (`radius-full`) | `space-3` (12px) | `icon-md` (20px) |

The search bar has one size only. It is intentionally more compact than the 56px form fields to fit in toolbars and list headers.

---

## Tokens used

**Colors**
- `color-surface-container` — background when unfocused
- `color-surface` — background when focused
- `color-on-surface` — input text color
- `color-on-surface-variant` — search icon, clear icon, placeholder color
- `color-on-surface-muted` — placeholder text
- `color-primary` — focused border color

**Typography**
- `body-large` — input text and placeholder

**Spacing**
- `space-2` — clear button internal padding (8px)
- `space-3` — horizontal content padding (12px)

**Radius**
- `radius-full` — pill container shape (9999px)

**Iconography**
- `RdsIcons.search` — leading search icon, always present
- `RdsIcons.close` — trailing clear button, visible when field has content
- `icon-md` (20px) — icon size

**Motion**
- `motion-duration-fast` — clear button opacity fade in/out (100ms)

**Opacity**
- `opacity-disabled` — full field when disabled (0.38)

---

## Behavior & interaction

### Mouse / touch
- Tapping anywhere in the pill focuses the input.
- Tapping the clear (×) button clears the field and returns focus to the input.
- When `disabled: true`, neither the input nor the clear button can be interacted with.
- The clear button is wrapped in `IgnorePointer` when not visible to prevent accidental taps.

### Keyboard
- `Tab` / `Shift+Tab` moves focus in/out.
- `Escape` can be used by wrapping consumers to dismiss the search or clear the field — not handled internally.
- `Enter` fires `onSubmitted` (e.g. to perform a full search rather than filtering as you type).
- `textInputAction` is set to `TextInputAction.search` to show the Search key on mobile keyboards.

### Focus management
- Tapping the clear button calls `FocusNode.requestFocus()` so the user can immediately continue typing.

### Animation
- Clear button: `AnimatedOpacity` with `motion-duration-fast` (100ms) — fast to avoid distraction.
- Background color transitions: handled by `AnimatedContainer` inside `_isFocused` listener (standard 200ms).

---

## Accessibility

- **Semantics:** `Semantics(textField: true, label: <placeholder>)` wraps the `TextField`. Because there is no separate label widget, the placeholder text serves as the accessible name.
- **Clear button:** `Semantics(label: 'Clear search', button: true)` with a `Tooltip` showing 'Clear'.
- **Min touch target:** The 40px height meets the minimum for a search control (WCAG 2.5.5 recommends 24px for non-interactive and 44px for interactive — the clear button padding ensures ≥ 44px tap area).
- **Contrast:** `color-on-surface-variant` on `color-surface-container` passes WCAG AA 3:1 for UI components.
- **Screen reader:** Focus is announced as "Search…, text field". When text is present and the clear button appears, the button is in the accessibility tree and announced as "Clear search, button".
- **Keyboard:** Fully operable with keyboard only.

---

## Content guidelines

- **Placeholder:** Use a domain-specific prompt: `Search patients…`, `Search by name or ID`, `Filter by condition`. Avoid generic `Search…` unless no better alternative exists.
- **No label:** The search bar intentionally has no floating label. The placeholder is the primary affordance — use a descriptive placeholder.
- **Confirmation:** For immediate filtering, no confirmation step is needed. For server-side searches, show a loading indicator within the results area (not within the search bar itself).

---

## Composition

**Uses:**
- Primitive — no other RDS components internally. Relies on Flutter's `TextField` with custom `InputDecoration`.
- `RdsIcons.search` and `RdsIcons.close` for icons.

**Used by:**
- Patient list headers, medication search panels, appointment filter toolbars.
- Can be composed with a results `ListView` or `RdsList` component.

---

## Flutter API

### Widget class
`RdsSearchBar`

### Constructor
```dart
const RdsSearchBar({
  super.key,
  String placeholder = 'Search…',
  TextEditingController? controller,
  FocusNode? focusNode,
  bool disabled = false,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onSubmitted,
  VoidCallback? onClear,
});
```

### Example usage

```dart
// Basic patient search
RdsSearchBar(
  placeholder: 'Search patients…',
  onChanged: (query) => setState(() => _filterPatients(query)),
)

// With external controller and submit handler
RdsSearchBar(
  placeholder: 'Search by name or ID',
  controller: _searchController,
  onSubmitted: (query) => context.read<PatientBloc>().add(SearchPatients(query)),
  onClear: () {
    _searchController.clear();
    context.read<PatientBloc>().add(ClearSearch());
  },
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | Interactive knobs for placeholder and disabled state. Type to see the clear button appear. |
| `States gallery` | Static display of: empty (unfocused), with content (clear button visible), disabled, focused (simulated). |

### Knobs

| Knob | Type | Maps to prop | Options / Notes |
|---|---|---|---|
| `Placeholder` | `string` | `placeholder` | Default: `'Search patients…'` |
| `Disabled` | `boolean` | `disabled` | Default: `false` |

---

## Do / Don't

| Do | Don't |
|---|---|
| Use a descriptive placeholder that tells the user what they can search for. | Don't add a label above the search bar — it breaks the compact, toolbar-native aesthetic. |
| Use `onChanged` for as-you-type filtering of local data. | Don't fire expensive server queries on every keystroke — debounce in the parent widget. |
| Place the clear button only when there is content to clear. | Don't show the clear button as a permanent element — it signals "there is something to clear" and should be absent when the field is empty. |
| Use `onClear` to reset related state (filtered lists, pagination, etc.). | Don't rely solely on the user manually deleting text to reset — always provide the clear button. |
