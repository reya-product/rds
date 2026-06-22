# Date Field / Time Field / Date-Time Field
> Form fields that display a formatted date, time, or date+time value and open the matching picker in a dialog when tapped.

## When to use / when not to use

**Use when:**
- Collecting a specific date (date of birth, appointment date, scheduled action)
- Collecting a time (appointment slot, reminder time)
- Collecting a combined date+time (event start, medication schedule)
- The value must be validated (min/max date, required)

**Do not use when:**
- The user needs to type a date manually (prefer a plain text field with masking)
- The date range is very large and a free-text entry would be faster

## Anatomy

```
┌───────────────────────────────────────────┐
│ Label *                                    │  ← bodyMedium, onSurfaceVariant
├──[🗓]──────────── DD/MM/YYYY ──────[▼]───┤  ← leading icon | value/placeholder | chevron
└───────────────────────────────────────────┘
│ Support text / error message               │  ← bodySmall
```

Parts:
1. **Label** — field name, with optional `*` (mandatory) or `(optional)` suffix
2. **Leading icon** — calendar (date/datetime), clock (time)
3. **Display area** — shows formatted value or placeholder
4. **Trailing chevron** — indicates tappable / expandable
5. **Support text** — helper hint below the field
6. **Error text** — replaces support text in error state

## Variants

| Variant | Widget | Opens | Value type |
|---------|--------|-------|------------|
| Date | `RdsDateField` | `RdsDatePicker` | `DateTime` |
| Time | `RdsTimeField` | `RdsTimePicker` | `TimeOfDay` |
| Date + Time | `RdsDateTimeField` | `RdsDateTimePicker` | `DateTime` |

## Configs (props)

### Shared across all three variants

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `label` | `String` | required | Field label |
| `onChanged` | `ValueChanged<T>?` | null | Called on confirm; null = disabled |
| `placeholder` | `String` | variant-specific | Text when no value selected |
| `supportText` | `String?` | null | Helper text below |
| `errorText` | `String?` | null | Error message; triggers error state |
| `mandatory` | `bool` | false | Appends `*` to label |
| `disabled` | `bool` | false | Dims and prevents interaction |
| `readOnly` | `bool` | false | Shows value; prevents opening picker |

### RdsDateField specific
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `value` | `DateTime?` | null | Selected date |
| `minDate` | `DateTime?` | null | Earliest selectable date |
| `maxDate` | `DateTime?` | null | Latest selectable date |

### RdsTimeField specific
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `value` | `TimeOfDay?` | null | Selected time |
| `use24HourFormat` | `bool` | true | 24h vs 12h AM/PM display |

### RdsDateTimeField specific
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `value` | `DateTime?` | null | Selected date+time |
| `minDate` | `DateTime?` | null | Earliest selectable date |
| `maxDate` | `DateTime?` | null | Latest selectable date |
| `use24HourFormat` | `bool` | true | 24h vs 12h AM/PM display |

## States

| State | Visual |
|-------|--------|
| Enabled (empty) | `outline` border; placeholder in `onSurfaceMuted` |
| Enabled (filled) | `outline` border; value in `onSurface` |
| Focused | `primary` border 2px (shown while picker dialog is open) |
| Error | `danger` border 2px; error text below in `danger` |
| Disabled | `opacityDisabled` overlay; field non-interactive |
| Read only | `surfaceContainer` background; tapping does nothing |

## Sizes

Single fixed size. Height matches `RdsTextField` (~56px including label float).

## Tokens used

| Element | Token |
|---------|-------|
| Field background | `color-surface` |
| Read-only background | `color-surface-container` |
| Border (default) | `color-outline` |
| Border (focused) | `color-primary` |
| Border (error) | `color-danger` |
| Label text | `color-on-surface-variant`, `body-medium` |
| Value text | `color-on-surface`, `body-large` |
| Placeholder text | `color-on-surface-muted`, `body-large` |
| Icon | `color-on-surface-variant`, `icon-md` (20px) |
| Support text | `color-on-surface-variant`, `body-small` |
| Error text | `color-danger`, `body-small` |
| Corner radius | `radius-md` |
| Padding | `space-4` horizontal, `space-4` vertical |
| Dialog corner radius | `radius-lg` |
| Dialog max width | 360px |

## Behavior & interaction

1. **Tap to open** — tapping anywhere on the field (or its trailing icon) opens the picker dialog via `showDialog`. Disabled and readOnly fields do not open.
2. **Dialog lifecycle** — dialog shows Cancel + Confirm buttons. Cancel closes without change. Confirm calls `onChanged` with the selected value.
3. **Focus** — field gains focus while dialog is open (shows focused border); unfocuses when dialog dismisses.
4. **Value display format:**
   - Date: `DD/MM/YYYY` (e.g. `15/06/1990`)
   - Time 24h: `HH:MM` (e.g. `14:30`)
   - Time 12h: `HH:MM AM/PM` (e.g. `02:30 PM`)
   - DateTime: `DD/MM/YYYY HH:MM`

## Accessibility

- The field uses `TextField(readOnly: true)` which exposes correct `textField` semantics to screen readers
- The label is spoken as the accessible name
- Error text is announced via `errorText` in `InputDecoration` (Flutter reads it automatically)
- Mandatory indicator (`*`) should be read; the label string includes it
- Min tap target: 56px height of the field exceeds the 44px minimum

## Content guidelines

- **Labels:** sentence case, concise (≤ 3 words). E.g. "Date of birth", not "Please enter your date of birth"
- **Placeholders:** use the format hint (`DD/MM/YYYY`) — don't repeat the label
- **Error messages:** specific and actionable. E.g. "Date of birth is required" not "Invalid"
- **Support text:** use for format hints or constraints. E.g. "Must be at least 18 years ago"

## Composition

- Composes `RdsPickerFieldBase` (shared field shell)
- Opens `RdsDatePicker` / `RdsTimePicker` / `RdsDateTimePicker` via `_RdsPickerDialog`
- Dialog footer uses `RdsButton` for Cancel (text variant) and Confirm (primary variant)
- Used by: forms, scheduling flows, profile data entry

## Flutter API

```dart
// Date field
RdsDateField(
  label: 'Date of birth',
  value: _date,
  onChanged: (d) => setState(() => _date = d),
  minDate: DateTime(1900),
  maxDate: DateTime.now(),
  mandatory: true,
  supportText: 'Enter your date of birth as shown on your ID',
)

// Time field
RdsTimeField(
  label: 'Appointment time',
  value: _time,
  onChanged: (t) => setState(() => _time = t),
  use24HourFormat: false,
)

// Date + time field
RdsDateTimeField(
  label: 'Appointment',
  value: _dateTime,
  onChanged: (dt) => setState(() => _dateTime = dt),
  minDate: DateTime.now(),
)
```

## Widgetbook

Each variant has its own `WidgetbookComponent`:
- `dateFieldComponent` — knobs: label, placeholder, mandatory, disabled, readOnly, errorText, supportText; states gallery
- `timeFieldComponent` — knobs: label, use24HourFormat, mandatory, disabled, readOnly, errorText
- `dateTimeFieldComponent` — knobs: label, use24HourFormat, mandatory, disabled, readOnly, errorText

## Do / Don't

**Do:**
- Use for all date/time inputs that require picker UX
- Provide `minDate` / `maxDate` when the domain constrains the range
- Show `supportText` to explain the expected format or constraints
- Use `mandatory: true` for required fields

**Don't:**
- Don't use for date-of-birth fields where users prefer typing (use a masked text field instead for power users)
- Don't leave `errorText` set after the user has corrected the value
- Don't use `RdsDateField` for free-form text dates — that's `RdsTextField`
