# Date / Time Pickers

> Inline calendar and clock widgets for selecting dates, date ranges, and times. Used directly in forms or surfaced inside popups by the Date/Time Field components (T2a).

---

## When to use / when not to use

**Use when:**
- The user must select a specific calendar date, date range, or time value.
- The picker is embedded inline in a form section where space allows, or is presented in a popup triggered by a Date/Time Field.
- Precise time input is required alongside a date (use the Date-Time Picker).
- A standalone clock-style time input is needed without a date (use the Time Picker).

**Do not use when:**
- The user only needs to type a known date — prefer a plain text field with date validation.
- The date is optional and relative (e.g. "in 3 days") — consider a duration field instead.
- The picker would appear inline in a very narrow column (< 280px) — use the popup variant triggered by a Date Field instead.

---

## Anatomy

### Date Picker (single)

```
┌─────────────────────────────────────────────┐
│  [<]   June 2024   [>]                   1  │
│  Mo Tu We Th Fr Sa Su                    2  │
│                    1                         │
│   3  4  5  6  7  8  9                        │
│  10 11 12 13 14 15 16                        │
│  17 18 19 20 21 22 23                        │
│  24 25 26 27 28 29 30                        │
└─────────────────────────────────────────────┘
  3                          4
```

| Part | Description |
|---|---|
| 1. Month/year header | Displays the current month and year. Tapping opens the month/year selector overlay. |
| 2. Weekday labels | Abbreviated weekday names (Mo–Su or Su–Sa depending on `firstDayOfWeek`). Styled with `label-small` and `on-surface-muted`. |
| 3. Prev/next navigation | Chevron icon buttons to move one month backward or forward. |
| 4. Day cells | 40×40px touch targets in a `radius-full` circle. States: default, today (outline border), selected (primary fill), hover, disabled. |

### Date Range Picker

```
┌──────────────────────────────┬──────────────────────────────┐
│  [<]  June 2024  [>]         │  [<]  July 2024  [>]         │
│  Mo Tu We Th Fr Sa Su        │  Mo Tu We Th Fr Sa Su        │
│                  1  2        │   1  2  3  4  5  6  7        │
│   3  4  5 [6][════════9]     │  [████████████12] 13 14      │
│  10 11 12 13 14 15 16        │  15 16 17 18 19 20 21        │
└──────────────────────────────┴──────────────────────────────┘
```

| Part | Description |
|---|---|
| Left calendar | Shows the month containing the start date. |
| Right calendar | Shows the month following the left calendar. |
| Range strip | A `primary-container` colored strip connecting start and end endpoints. |
| Start/end cells | `primary` filled circles marking the range endpoints. |
| Hover preview | While selecting end date, a translucent strip previews the tentative range. |

### Date-Time Picker

```
┌─────────────────────────────────────────────┐
│  [calendar grid — same as Date Picker]       │
├─────────────────────────────────────────────┤
│  Time                                        │
│  [▲]  :  [▲]                  [AM]           │
│  [09] :  [30]                 [PM]           │
│  [▼]  :  [▼]                                │
└─────────────────────────────────────────────┘
```

| Part | Description |
|---|---|
| Calendar section | Full single-date calendar grid. |
| Divider | Separates date and time sections. |
| Time section | Hour/minute spinners with an AM/PM toggle (or 24-hour inputs when `use24HourFormat` is true). |

### Time Picker — Dial

```
        12
    11      1
  10   ╔══╗  2
  9  ══╬  ║  3     ← hand pointing to 9
  8    ╚══╝  4
    7      5
        6
```

| Part | Description |
|---|---|
| Clock face | `surface-container` filled circle drawn with `CustomPainter`. |
| Hour/minute numbers | Painted text at trigonometric positions on the dial radius. |
| Clock hand | Line from center to selected value, colored `primary`. |
| Selected number | `primary` circle drawn behind the active number. |
| Time header | Tappable hour and minute segments above the dial. |

### Time Picker — Input

```
  ┌────┐   ┌────┐   ┌───┐
  │ 09 │ : │ 30 │   │AM │
  └────┘   └────┘   │PM │
                     └───┘
```

| Part | Description |
|---|---|
| Hour input | Number text field with increment/decrement spinner buttons. |
| Minute input | Number text field with increment/decrement spinner buttons. |
| AM/PM toggle | Vertical two-option toggle (hidden in 24h mode). |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| Date Picker | Single-month calendar grid | Picking a single date |
| Date Range Picker | Two-month calendar side by side | Picking a start and end date (booking, reporting periods) |
| Date-Time Picker | Calendar + time spinners stacked | Scheduling events with a specific time |
| Time Picker — Dial | Clock face with draggable hand | Mobile-friendly time selection; when precision is secondary to feel |
| Time Picker — Input | Numeric text fields with spinners | Desktop-friendly; when precise time entry is needed |

---

## Configs (props)

### RdsDatePicker

| Prop | Type | Default | Description |
|---|---|---|---|
| `value` | `DateTime?` | `null` | The currently selected date. |
| `onChanged` | `ValueChanged<DateTime>?` | `null` | Called when a day is tapped. |
| `minDate` | `DateTime?` | `null` | Days before this date are disabled. |
| `maxDate` | `DateTime?` | `null` | Days after this date are disabled. |
| `firstDayOfWeek` | `int` | `1` | 0 = Sunday, 1 = Monday. |

### RdsDateRangePicker

| Prop | Type | Default | Description |
|---|---|---|---|
| `startDate` | `DateTime?` | `null` | Current range start. |
| `endDate` | `DateTime?` | `null` | Current range end. |
| `onChanged` | `ValueChanged<RdsDateRange>?` | `null` | Called after each tap with the updated range. |
| `minDate` | `DateTime?` | `null` | Earliest selectable date. |
| `maxDate` | `DateTime?` | `null` | Latest selectable date. |
| `firstDayOfWeek` | `int` | `1` | 0 = Sunday, 1 = Monday. |

### RdsDateTimePicker

| Prop | Type | Default | Description |
|---|---|---|---|
| `value` | `DateTime?` | `null` | Current date and time selection. |
| `onChanged` | `ValueChanged<DateTime>?` | `null` | Called when date or time changes. |
| `minDate` | `DateTime?` | `null` | Earliest selectable date. |
| `maxDate` | `DateTime?` | `null` | Latest selectable date. |
| `use24HourFormat` | `bool` | `false` | True = 24h clock; false = 12h AM/PM. |
| `firstDayOfWeek` | `int` | `1` | 0 = Sunday, 1 = Monday. |

### RdsTimePicker

| Prop | Type | Default | Description |
|---|---|---|---|
| `value` | `TimeOfDay?` | `null` | Current time selection. |
| `onChanged` | `ValueChanged<TimeOfDay>?` | `null` | Called when the time changes. |
| `use24HourFormat` | `bool` | `false` | True = 24h clock; false = 12h AM/PM. |
| `mode` | `RdsPickerMode` | `RdsPickerMode.dial` | `dial` for clock face; `input` for numeric text fields. |

---

## States

### Day cell states

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled | Default | Normal text, transparent background | — |
| Today | Day matches current date | `outline` border around the circle | `color-outline` |
| Hover | Pointer enters cell | Semi-transparent overlay on circle | `state-hover` × `on-surface` |
| Selected | User tapped the day | `primary` filled circle, `on-primary` text | `color-primary`, `color-on-primary` |
| Range in-between | Day falls between start and end | `primary-container` strip background | `color-primary-container` |
| Range endpoint | Day is the start or end of a range | `primary` filled circle (same as selected) | `color-primary` |
| Disabled | Outside `minDate`/`maxDate` | Reduced opacity text, non-interactive | `opacity-disabled` |

### Clock dial states

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Idle | Default | Full face visible, hand at current time | — |
| Dragging | Pointer held and moved | Hand follows pointer angle in real time | — |
| Selected number | Number matches current value | `primary` circle behind number | `color-primary` |
| Switching mode | Tap hour/minute in header | Animated hand rotation to new position | `motion-duration-standard` |

---

## Sizes

The picker widgets have fixed internal sizing consistent with the 4px grid.

| Component | Width | Notes |
|---|---|---|
| Date Picker | 304px | Fixed; designed for popup and inline use |
| Date Range Picker | 668px (wide) / stacks on narrow | Stacks vertically below 640px |
| Date-Time Picker | 304px | Same width as Date Picker |
| Time Picker — Dial | 256px dial + padding | Minimum 288px container |
| Day cell | 40 × 40px | `radius-full` shape |

---

## Tokens used

**Colors**
- `color-primary` — selected day circle fill, clock hand, range endpoint fill
- `color-on-primary` — text on selected day circle
- `color-primary-container` — range strip background, AM/PM active background, active time segment background
- `color-on-primary-container` — text on primary-container backgrounds
- `color-surface` — picker container background
- `color-surface-container` — clock face background, time input container
- `color-on-surface` — day cell text, input text
- `color-on-surface-variant` — month/year header text, navigation icon color
- `color-on-surface-muted` — weekday label text, hint text
- `color-outline` — today indicator border, time input border, AM/PM toggle border
- `color-outline-variant` — divider between date and time sections, range picker vertical divider

**Typography**
- `title-small` — month/year header
- `label-small` — weekday abbreviations
- `body-medium` — day cell numbers
- `display-small` — time header segments (HH : MM)
- `headline-medium` — time input field numbers
- `label-medium` — month grid labels in month/year selector, AM/PM labels

**Spacing**
- `space-1` — gaps between weekday row and day grid
- `space-2` — inner padding of time header segments
- `space-3` — time input internal padding; month/year selector padding
- `space-4` — picker container padding; gap between calendar and time section

**Radius**
- `radius-full` — day cell shape (circle)
- `radius-lg` — picker container corners
- `radius-md` — time input borders, month/year selector month chips

**Shadows**
- `shadow-md` — picker container elevation (modeled from `0 4px 6px rgba(0,0,0,0.07)`)

**Motion**
- `motion-duration-standard` — month-to-month slide animation, time header active state, clock hand rotation
- `motion-duration-fast` — AM/PM option background change
- `motion-curve-standard` — all easing

**Opacity**
- `opacity-disabled` — disabled day cell text opacity

---

## Behavior & interaction

### Mouse / touch

#### Date Picker
- Tapping a day cell calls `onChanged` with that `DateTime`.
- Tapping the month/year header opens an inline overlay showing a 3-column month grid and a scrollable year list. Selecting a month or scrolling to a year and tapping a month navigates the calendar.
- Prev/next chevrons advance the calendar by one month.

#### Date Range Picker
- First tap sets `startDate`; `endDate` is null until second tap.
- While awaiting `endDate`, hovering days previews the tentative range with a strip.
- If the user taps a day earlier than the current `startDate`, it becomes the new `startDate` and selection resets.
- Both calendars share the range state; any day in either can be tapped.

#### Time Picker — Dial
- Dragging on the clock face rotates the hand and updates the value continuously.
- Tapping (non-drag) snaps to the nearest value at the tap angle.
- On drag end, if in hour mode, the picker automatically switches to minute selection.
- Tapping the hour segment in the header switches back to hour selection.
- Tapping the minute segment switches to minute selection.

#### Time Picker — Input
- Increment/decrement buttons step hour/minute by 1; values wrap (e.g. 59 → 0).
- Text fields accept freeform number input; on blur, the value is clamped to the valid range and re-formatted to zero-padded 2 digits.
- AM/PM toggle is a vertical two-option button group.

### Keyboard

- **Date Picker / Date Range Picker:** Arrow keys move focus between day cells (←→ between days, ↑↓ between weeks). Enter/Space selects the focused day. PageUp/PageDown navigate months.
- **Time Picker — Input:** Tab moves between hour and minute fields. Arrow keys increment/decrement within a focused field.
- **Time Picker — Dial:** Arrow keys rotate the hand by 1 unit (1 hour or 1 minute). Tab switches between hour/minute segments in the header.

### Focus management
- On first open, focus lands on the today cell (date) or the hour segment (time).
- The month/year selector overlay traps focus within it until dismissed.
- Closing the selector returns focus to the month/year header button.

### Animation
- **Month transition:** 200ms slide animation (`motion-duration-standard`, `motion-curve-standard`) when navigating months.
- **Clock hand rotation:** 200ms ease-in-out when switching between pre-set times or switching from hour to minute mode.
- **State layer (hover/press):** 200ms fade on/off.
- **Reduced motion:** When `MediaQuery.disableAnimationsOf(context)` is true, all animation durations collapse to 0ms.

---

## Accessibility

- **Semantics — day cells:** Each tappable day has `Semantics(label: 'Month Day, Year', selected: bool, button: true)`. Disabled cells have `enabled: false`.
- **Semantics — time header segments:** `Semantics(label: 'Hour: N' / 'Minute: N', selected: bool, button: true)`.
- **Semantics — AM/PM options:** `Semantics(label: 'AM' / 'PM', selected: bool, button: true)`.
- **Min touch target:** Day cells are 40×40px; nav buttons are 36×36px but sit in a row where the minimum tap area meets the 44px row height. Spinner buttons are constrained to at least 44×44px tap zones.
- **Contrast:** All day cell color pairs meet WCAG AA:
  - `on-primary` on `primary` ✓
  - `on-primary-container` on `primary-container` ✓
  - `on-surface` on `surface` ✓
  - `on-surface-muted` on `surface` (used only for decorative weekday labels) — informational only.
- **Screen reader:** VoiceOver/TalkBack reads the day label and announces "selected" for the active date.
- **Keyboard:** The full picker is operable without a mouse. See Keyboard section above.

---

## Content guidelines

- **Month/year header:** Format is `Month YYYY` (e.g. "June 2024"). Do not abbreviate the year.
- **Weekday labels:** Two-letter abbreviations in the locale's language. Default is English (Mo, Tu, We, Th, Fr, Sa, Su).
- **AM/PM labels:** Always uppercase. "AM" and "PM" (not "am/pm").
- **Error states:** Date/time pickers do not display error states themselves. Errors (e.g. "end date must be after start date") are shown by the wrapping Date Field component.
- **Placeholder:** No placeholder text on the pickers themselves; placeholders live in the triggering field.

---

## Composition

**Uses:**
- `RdsCalendarGrid` — shared internal month grid used by Date, Date Range, and Date-Time pickers.
- `RdsTimeDial` — shared clock-face `CustomPainter` widget used by Time Picker (dial) and Date-Time Picker.
- `RdsIcons.chevronLeft` / `chevronRight` / `chevronDown` / `chevronUp` — navigation and disclosure icons.

**Used by:**
- `RdsDateField` (T2a) — triggers `RdsDatePicker` in a popup overlay.
- `RdsDateRangeField` (T2a) — triggers `RdsDateRangePicker`.
- `RdsTimeField` (T2a) — triggers `RdsTimePicker`.
- `RdsDateTimeField` (T2a) — triggers `RdsDateTimePicker`.

---

## Flutter API

### RdsDatePicker

```dart
class RdsDatePicker extends StatefulWidget {
  const RdsDatePicker({
    super.key,
    this.value,
    this.onChanged,
    this.minDate,
    this.maxDate,
    this.firstDayOfWeek = 1,
  });

  final DateTime? value;
  final ValueChanged<DateTime>? onChanged;
  final DateTime? minDate;
  final DateTime? maxDate;
  final int firstDayOfWeek; // 0 = Sunday, 1 = Monday
}
```

### RdsDateRangePicker

```dart
class RdsDateRangePicker extends StatefulWidget {
  const RdsDateRangePicker({
    super.key,
    this.startDate,
    this.endDate,
    this.onChanged,
    this.minDate,
    this.maxDate,
    this.firstDayOfWeek = 1,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<RdsDateRange>? onChanged;
  final DateTime? minDate;
  final DateTime? maxDate;
  final int firstDayOfWeek;
}
```

### RdsDateTimePicker

```dart
class RdsDateTimePicker extends StatefulWidget {
  const RdsDateTimePicker({
    super.key,
    this.value,
    this.onChanged,
    this.minDate,
    this.maxDate,
    this.use24HourFormat = false,
    this.firstDayOfWeek = 1,
  });

  final DateTime? value;
  final ValueChanged<DateTime>? onChanged;
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool use24HourFormat;
  final int firstDayOfWeek;
}
```

### RdsTimePicker

```dart
class RdsTimePicker extends StatefulWidget {
  const RdsTimePicker({
    super.key,
    this.value,
    this.onChanged,
    this.use24HourFormat = false,
    this.mode = RdsPickerMode.dial,
  });

  final TimeOfDay? value;
  final ValueChanged<TimeOfDay>? onChanged;
  final bool use24HourFormat;
  final RdsPickerMode mode;
}
```

### Shared model classes and enums

```dart
enum RdsPickerMode { dial, input }

class RdsDateRange {
  const RdsDateRange({this.start, this.end});

  final DateTime? start;
  final DateTime? end;

  bool get isComplete;
  bool contains(DateTime date);
  bool isStart(DateTime date);
  bool isEnd(DateTime date);
  RdsDateRange copyWith({DateTime? start, DateTime? end});
}
```

### Example usage

```dart
// Single date picker
RdsDatePicker(
  value: _selectedDate,
  onChanged: (date) => setState(() => _selectedDate = date),
  minDate: DateTime(2020),
  maxDate: DateTime(2030, 12, 31),
)

// Date range picker
RdsDateRangePicker(
  startDate: _range.start,
  endDate: _range.end,
  onChanged: (range) => setState(() => _range = range),
)

// Date + time
RdsDateTimePicker(
  value: _dateTime,
  onChanged: (dt) => setState(() => _dateTime = dt),
  use24HourFormat: true,
)

// Time only — dial
RdsTimePicker(
  value: _time,
  onChanged: (t) => setState(() => _time = t),
  mode: RdsPickerMode.dial,
  use24HourFormat: false,
)

// Time only — input
RdsTimePicker(
  value: _time,
  onChanged: (t) => setState(() => _time = t),
  mode: RdsPickerMode.input,
  use24HourFormat: true,
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Single date — Playground` | Interactive single date picker with `firstDayOfWeek` knob. Displays the selected date below the picker. |
| `Date range — Playground` | Interactive range picker with `firstDayOfWeek` knob. Displays the selected start → end below. |
| `Date + time — Playground` | Interactive date-time picker with `24-hour format` and `firstDayOfWeek` knobs. |
| `Time picker — Dial` | Clock dial time picker with `24-hour format` knob. |
| `Time picker — Input` | Spinner input time picker with `24-hour format` knob. |
| `Gallery` | All five variants rendered statically for visual review across themes. |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `First day of week` | `list<int>` | `firstDayOfWeek` | `0` (Sunday), `1` (Monday) |
| `24-hour format` | `boolean` | `use24HourFormat` | true / false |

---

## Do / Don't

| Do | Don't |
|---|---|
| Use `RdsDatePicker` inline in a form when there is enough horizontal space (≥ 304px). | Don't embed the range picker in a narrow column — it requires ≥ 640px or will stack. |
| Pass `minDate` and `maxDate` to prevent selection of out-of-range dates (e.g. past dates for future appointments). | Don't leave `minDate`/`maxDate` null when the business logic has date constraints — users will be confused when they select an invalid date. |
| Switch to `RdsPickerMode.input` in contexts where keyboard entry is preferred (e.g. dense data forms on desktop). | Don't use the dial mode inside a dense data grid row — it is too large for those contexts. |
| Let the `RdsDateField` (T2a) manage the popup trigger and dismiss behavior when the picker is opened from a form field. | Don't build a custom popup wrapper from scratch — reuse the T2a field components that already handle positioning, focus trapping, and keyboard dismissal. |
