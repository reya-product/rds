# Field Uploader

> A drag-and-drop / tap-to-browse file upload field that shows selected files as removable chips with optional upload-progress indicators.

---

## When to use / when not to use

**Use when:**
- Users need to attach files to a form (reports, images, documents).
- The product supports direct file uploads (single or batch).
- You want a consistent file-selection affordance with drag-and-drop support.

**Do not use when:**
- The user only needs to capture a photo from a camera — use a camera-specific control.
- Inline image cropping or editing is required — the uploader is attach-only.
- Only a URL or link to a file is needed — use a text field.

---

## Anatomy

```
┌─ label * ────────────────────────────────────────────────────────────────────┐
│                                                                               │
│  ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐  │
│    [↑]   Drop file here or browse                                            │
│    .pdf · Max 5 MB                                                           │
│  └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘  │
│                                                                               │
│  ┌─────────────────────────────────────────────────────────────────────────┐  │
│  │  report.pdf                                               1.2 MB   [✕]  │  │
│  ├─────────────────────────────────────────────────────────────────────────┤  │
│  │  ▓▓▓▓▓▓▓░░░░░░░  65%                                                    │  │
│  └─────────────────────────────────────────────────────────────────────────┘  │
│                                                                               │
│  support text                                                                 │
└───────────────────────────────────────────────────────────────────────────────┘

Parts:
  1. Label                — field label + optional asterisk
  2. Drop zone            — dashed border box; shown when no file selected (single) or always (multiple)
  3. Upload icon          — RdsIcons.upload at icon-lg
  4. Drop zone copy       — "Drop file here or browse" with tappable "browse" link
  5. Hint text            — accepted types and max file size hint
  6. File chip            — per-file row: name, size, remove button
  7. Progress bar         — 3px LinearProgressIndicator at bottom of chip
  8. Support / error text — below the chip list
```

| Part | Description |
|---|---|
| 1. Label | Required. Sentence case. Asterisk when `mandatory: true`. |
| 2. Drop zone | `surfaceContainer` background, dashed `color-outline` border, `radius-md`. Hidden in single-file mode once a file is selected. |
| 3. Upload icon | `RdsIcons.upload` at `icon-lg` (24px). Teal on drag-over. |
| 4. Drop zone copy | "browse" is a tappable text link in `color-primary`. |
| 5. Hint text | Accepted types + max size. `body-small`, `color-on-surface-muted`. |
| 6. File chip | `color-surface` background, `color-outline-variant` border, `radius-sm`. |
| 7. Progress bar | 3px high. Indeterminate when `uploading: true` and no per-file progress; determinate when `uploadProgress` key matches. |
| 8. Footer text | Support text or error text below the chip list. |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| Single file | Drop zone hidden once a file is attached; replaced by the file chip. | When only one file attachment is allowed. |
| Multiple files | Drop zone always visible; chip list grows below it. | When batch uploads are supported. |
| With progress | Chips show `LinearProgressIndicator` at their bottom edge. | While files are being uploaded to the server. |
| Error | Red footer text; the field border on the drop zone turns `color-danger`. | Form validation failure. |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | required | Field label. |
| `multiple` | `bool` | `false` | Allow multiple files. |
| `acceptedTypes` | `List<String>?` | `null` | Extension hints, e.g. `['.pdf', '.jpg']`. |
| `maxFileSizeMb` | `double?` | `null` | Max file size hint shown in the drop zone. |
| `files` | `List<RdsUploadedFile>` | `[]` | Currently selected/uploaded files. |
| `onFilesChanged` | `ValueChanged<List<RdsUploadedFile>>?` | `null` | Called when files are added or removed. |
| `onBrowseTap` | `VoidCallback?` | `null` | Called when the "browse" link or drop zone is tapped. Wire to a file picker. |
| `uploading` | `bool` | `false` | Shows indeterminate progress on all file chips. |
| `uploadProgress` | `Map<String, double>?` | `null` | Per-filename determinate progress (0.0–1.0). Key is `RdsUploadedFile.name`. |
| `supportText` | `String?` | `null` | Helper text below the field. Hidden when `errorText` is set. |
| `errorText` | `String?` | `null` | Error text. Activates the error state when non-null and non-empty. |
| `mandatory` | `bool` | `false` | Appends ` *` to the label. |
| `disabled` | `bool` | `false` | Dims the entire field and disables all interaction. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Enabled | Default | Normal `color-outline` dashed border on drop zone. | `color-outline` |
| Hover | Pointer over drop zone | — (cursor change; host app can style further) | — |
| Drag over | File dragged over drop zone | Background → `color-primary-container`; border → `color-primary`. | `color-primary-container`, `color-primary` |
| Error | `errorText` non-null | Footer text in `color-danger`; drop zone border turns `color-danger`. | `color-danger` |
| Uploading | `uploading: true` | All chips show `LinearProgressIndicator` (indeterminate). | `color-primary` |
| Upload progress | `uploadProgress` set | Chips show determinate progress bar at specified value. | `color-primary` |
| Disabled | `disabled: true` | Entire widget at `opacity-disabled`; no interaction. | `opacity-disabled` |

---

## Tokens used

**Colors**
- `color-surface` — file chip background
- `color-surface-container` — drop zone background
- `color-primary-container` — drop zone background on drag-over
- `color-primary` — drop zone border on drag-over, "browse" link, progress bar fill, upload icon (drag-over)
- `color-outline` — drop zone dashed border
- `color-outline-variant` — file chip border, progress bar track
- `color-danger` — error state border and footer text
- `color-on-surface` — file name text
- `color-on-surface-variant` — label, support text, remove icon
- `color-on-surface-muted` — file size text, hint text, upload icon (idle)

**Typography**
- `body-medium` — label, file name, drop zone copy
- `body-small` — support text, error text, file size, hint text

**Spacing**
- `space-1` — label-to-dropzone gap; dropzone-to-chips gap; chips-to-footer gap
- `space-2` — between chip rows; horizontal/vertical chip padding
- `space-3` — chip horizontal/vertical internal padding
- `space-4` — drop zone horizontal padding
- `space-6` — drop zone vertical padding

**Radius**
- `radius-md` — drop zone
- `radius-sm` — file chips

**Motion**
- `motion-duration-standard` — drop zone background/border color transition on drag-over
- `motion-curve-standard` — drag-over animation easing

---

## Behavior & interaction

### Mouse / touch
- Tapping the drop zone or "browse" link fires `onBrowseTap` (host app handles picker).
- Dragging a file over the drop zone enters drag-over visual state via `DragTarget`.
- Dropping a file calls `onAcceptWithDetails` on `DragTarget`; host app handles bytes.
- Tapping the `×` icon on a chip calls `onFilesChanged` with the file removed.

### Keyboard
- The "browse" text link is accessible via Tab + Enter.
- The `×` remove button on each chip is keyboard-focusable.

### Focus management
- Drop zone receives focus when the user tabs into it; "browse" link receives focus within it.

### Animation
- Drop zone background and border color transition at `motion-duration-standard` with `motion-curve-standard` on drag-enter/leave.
- Progress bar uses Flutter's built-in `LinearProgressIndicator` animation.

---

## Accessibility

- **Semantics:** `Semantics(container: true, label: 'Upload document [required]')` wraps the entire field.
- **Drop zone:** `Semantics(button: true, label: 'Drop file here or browse to upload')`.
- **File chip:** `Semantics(container: true, label: '{name}, {size}[, uploading]')`.
- **Remove button:** `Semantics(button: true, label: 'Remove {filename}')`.
- **Min touch target:** `×` icon is rendered at `icon-md` (20px) with sufficient padding; the overall chip row meets 44px height.
- **Contrast:** `color-primary` on white ≥ 4.5:1. `color-danger` on white ≥ 4.5:1.
- **Screen reader:** Each chip announces name, size, and upload state. Remove button is individually labelled.
- **Keyboard:** Fully operable via keyboard — Tab cycles through drop zone, browse link, and chip remove buttons.

---

## Content guidelines

- **Label:** Sentence case. Describe what should be uploaded (e.g. "Upload prescription", not "File").
- **Hint text:** List accepted types with dots: `.pdf, .jpg`. Follow with max size: "Max 10 MB".
- **Browse link:** Always use the word "browse" — it is the established convention.
- **Error messages:** Be specific. "File exceeds the maximum size of 5 MB" is better than "Invalid file".

---

## Composition

**Uses:**
- `RdsIcons.upload` — drop zone icon.
- `RdsIcons.close` — remove button on file chips.
- `RdsIcons.add` — "Add mock file" button in Widgetbook.
- `RdsIconSize.lg`, `RdsIconSize.md` — icon sizing.
- `LinearProgressIndicator` (Flutter SDK) — upload progress.
- `DragTarget<Object>` (Flutter SDK) — drag-and-drop target.

**Used by:**
- Any RDS form that requires file attachment input.

**Note on actual file picking:**
This widget does not depend on `file_picker` or `dart:html` — it cannot add package dependencies (shared-file rule). All file I/O is delegated to the host app via `onBrowseTap` and `onFilesChanged`. The widget is responsible for drop-zone UI, drag-over feedback, file chip display, and progress visualization only.

---

## Flutter API

### Widget class
`RdsFieldUploader`

### Data class
`RdsUploadedFile`

### Constructor — RdsFieldUploader
```dart
const RdsFieldUploader({
  super.key,
  required String label,
  bool multiple = false,
  List<String>? acceptedTypes,
  double? maxFileSizeMb,
  List<RdsUploadedFile> files = const [],
  ValueChanged<List<RdsUploadedFile>>? onFilesChanged,
  VoidCallback? onBrowseTap,
  bool uploading = false,
  Map<String, double>? uploadProgress,
  String? supportText,
  String? errorText,
  bool mandatory = false,
  bool disabled = false,
});
```

### Constructor — RdsUploadedFile
```dart
const RdsUploadedFile({
  required String name,
  required int sizeBytes,
  String? mimeType,
});
```

### Computed property
```dart
String get formattedSize; // "1.2 MB", "340.0 KB", "512 B"
```

### Example usage

```dart
// Single-file picker wired to file_picker package
RdsFieldUploader(
  label: 'Upload prescription',
  mandatory: true,
  acceptedTypes: const ['.pdf', '.jpg', '.png'],
  maxFileSizeMb: 5,
  files: _files,
  onFilesChanged: (updated) => setState(() => _files = updated),
  onBrowseTap: () async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final f = result.files.first;
      setState(() => _files = [
        RdsUploadedFile(name: f.name, sizeBytes: f.size),
      ]);
    }
  },
)

// Multiple files with upload progress
RdsFieldUploader(
  label: 'Supporting documents',
  multiple: true,
  files: _files,
  uploading: _isUploading,
  uploadProgress: _progress, // {'report.pdf': 0.65, 'id.jpg': 1.0}
  onFilesChanged: (updated) => setState(() => _files = updated),
  onBrowseTap: _openFilePicker,
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | Knobs for multiple, disabled, mandatory, errorText, supportText. "Add mock file" button simulates picker. |
| `Single file — empty` | Drop zone with no files selected. |
| `Single file — with file` | Drop zone hidden; one file chip visible. |
| `Multiple files` | Drop zone visible; two file chips in the list. |
| `Uploading` | Two chips with deterministic progress bars at 65% and 30%. |
| `Error` | One chip; error text and danger-colored footer. |

### Knobs (Playground)

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `Multiple` | boolean | `multiple` | true / false |
| `Disabled` | boolean | `disabled` | true / false |
| `Mandatory` | boolean | `mandatory` | true / false |
| `Error text` | string | `errorText` | — |
| `Support text` | string | `supportText` | — |

---

## Do / Don't

| Do | Don't |
|---|---|
| Wire `onBrowseTap` to a proper file-picker for actual file selection in your app. | Expect the widget to open a file dialog on its own — it cannot add a `file_picker` dependency. |
| Use `uploadProgress` for deterministic per-file feedback when the server reports byte progress. | Show `uploading: true` after the server has confirmed the upload is complete. |
| Provide `acceptedTypes` to set expectations in the drop zone hint. | Rely solely on UI hints for file type validation — validate server-side. |
| Use `multiple: true` only when the feature genuinely supports multiple file processing. | Default to multiple when only one file will be processed — the extra drop zone shown after selection is distracting. |
