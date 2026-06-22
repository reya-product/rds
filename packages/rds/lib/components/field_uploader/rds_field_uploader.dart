import 'package:flutter/material.dart';
import '../../theme/rds_theme.dart';
import '../../tokens/rds_icon_size.dart';
import '../../tokens/rds_icons.dart';
import 'rds_uploaded_file.dart';

// ---------------------------------------------------------------------------
// RdsFieldUploader
// ---------------------------------------------------------------------------

/// A drag-and-drop / tap-to-browse file upload field.
///
/// ## File picking
/// This widget provides the full drop-zone UI and file-chip list but does NOT
/// perform actual file I/O — it cannot take on file_picker as a dependency.
/// Wire up file selection via [onBrowseTap]:
///
/// ```dart
/// RdsFieldUploader(
///   label: 'Upload report',
///   files: _files,
///   onFilesChanged: (f) => setState(() => _files = f),
///   onBrowseTap: () async {
///     final result = await FilePicker.platform.pickFiles(allowMultiple: true);
///     if (result != null) {
///       setState(() => _files = result.files.map((f) => RdsUploadedFile(
///         name: f.name,
///         sizeBytes: f.size,
///       )).toList());
///     }
///   },
/// )
/// ```
///
/// On Flutter web, dropping files onto the [DragTarget] area fires
/// [onFilesChanged] with the dragged data if the host app overrides the drag
/// handling. The widget itself handles the visual drag-over state.
class RdsFieldUploader extends StatefulWidget {
  const RdsFieldUploader({
    super.key,
    required this.label,
    this.multiple = false,
    this.acceptedTypes,
    this.maxFileSizeMb,
    this.files = const [],
    this.onFilesChanged,
    this.onBrowseTap,
    this.uploading = false,
    this.uploadProgress,
    this.supportText,
    this.errorText,
    this.mandatory = false,
    this.disabled = false,
  });

  /// Field label.
  final String label;

  /// When true, multiple files may be selected.
  final bool multiple;

  /// File extension hints displayed in the drop zone (e.g. `['.pdf', '.jpg']`).
  final List<String>? acceptedTypes;

  /// Maximum file size hint shown in UI (e.g. `10.0` → "Max 10 MB").
  final double? maxFileSizeMb;

  /// Currently selected files.
  final List<RdsUploadedFile> files;

  /// Called when the file list changes (additions or removals).
  final ValueChanged<List<RdsUploadedFile>>? onFilesChanged;

  /// Called when the user taps the "browse" link. Wire to a file-picker here.
  final VoidCallback? onBrowseTap;

  /// When true, all file chips show an indeterminate upload animation.
  final bool uploading;

  /// Per-filename upload progress (0.0–1.0). Overrides [uploading] per file.
  final Map<String, double>? uploadProgress;

  /// Helper text shown below the drop zone. Hidden when [errorText] is active.
  final String? supportText;

  /// Error text. When non-null and non-empty the field enters the error state.
  final String? errorText;

  /// Appends an asterisk to [label].
  final bool mandatory;

  /// Disables all interaction and dims the widget.
  final bool disabled;

  @override
  State<RdsFieldUploader> createState() => _RdsFieldUploaderState();
}

class _RdsFieldUploaderState extends State<RdsFieldUploader> {
  bool _isDragOver = false;

  void _removeFile(RdsUploadedFile file) {
    if (widget.onFilesChanged == null) return;
    final updated = List<RdsUploadedFile>.from(widget.files)..remove(file);
    widget.onFilesChanged!(updated);
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final bool hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final bool hasBelow =
        hasError || (widget.supportText != null && widget.supportText!.isNotEmpty);

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Text(
          widget.mandatory ? '${widget.label} *' : widget.label,
          style: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
        ),
        SizedBox(height: rds.space1),

        // Drop zone
        _DropZone(
          rds: rds,
          isDragOver: _isDragOver,
          hasError: hasError,
          disabled: widget.disabled,
          multiple: widget.multiple,
          acceptedTypes: widget.acceptedTypes,
          maxFileSizeMb: widget.maxFileSizeMb,
          showDropZone: widget.files.isEmpty || widget.multiple,
          onDragEnter: () {
            if (!widget.disabled) setState(() => _isDragOver = true);
          },
          onDragExit: () => setState(() => _isDragOver = false),
          onBrowseTap: widget.disabled ? null : widget.onBrowseTap,
        ),

        // File chips
        if (widget.files.isNotEmpty) ...[
          SizedBox(height: rds.space2),
          ...widget.files.map(
            (file) => Padding(
              padding: EdgeInsets.only(bottom: rds.space2),
              child: _FileChip(
                rds: rds,
                file: file,
                uploading: widget.uploading,
                progress: widget.uploadProgress?[file.name],
                onRemove: widget.disabled ? null : () => _removeFile(file),
              ),
            ),
          ),
        ],

        // Support / error text
        if (hasBelow) ...[
          SizedBox(height: rds.space1),
          Text(
            hasError ? widget.errorText! : widget.supportText!,
            style: rds.bodySmall.copyWith(
              color: hasError ? rds.danger : rds.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );

    if (widget.disabled) {
      content = Opacity(opacity: rds.opacityDisabled, child: content);
    }

    return Semantics(
      container: true,
      label: widget.mandatory ? '${widget.label} required' : widget.label,
      child: content,
    );
  }
}

// ---------------------------------------------------------------------------
// _DropZone
// ---------------------------------------------------------------------------

class _DropZone extends StatelessWidget {
  const _DropZone({
    required this.rds,
    required this.isDragOver,
    required this.hasError,
    required this.disabled,
    required this.multiple,
    required this.showDropZone,
    this.acceptedTypes,
    this.maxFileSizeMb,
    this.onDragEnter,
    this.onDragExit,
    this.onBrowseTap,
  });

  final RdsTheme rds;
  final bool isDragOver;
  final bool hasError;
  final bool disabled;
  final bool multiple;
  final bool showDropZone;
  final List<String>? acceptedTypes;
  final double? maxFileSizeMb;
  final VoidCallback? onDragEnter;
  final VoidCallback? onDragExit;
  final VoidCallback? onBrowseTap;

  @override
  Widget build(BuildContext context) {
    if (!showDropZone) return const SizedBox.shrink();

    final Color borderColor = hasError
        ? rds.danger
        : isDragOver
            ? rds.primary
            : rds.outline;

    final Color bgColor =
        isDragOver ? rds.primaryContainer : rds.surfaceContainer;

    // Build hint text
    final hints = <String>[];
    if (acceptedTypes != null && acceptedTypes!.isNotEmpty) {
      hints.add(acceptedTypes!.join(', '));
    }
    if (maxFileSizeMb != null) {
      hints.add('Max ${maxFileSizeMb!.toStringAsFixed(0)} MB');
    }
    final hintText = hints.isNotEmpty ? hints.join(' · ') : null;

    return DragTarget<Object>(
      onWillAcceptWithDetails: (_) {
        onDragEnter?.call();
        return !disabled;
      },
      onLeave: (_) => onDragExit?.call(),
      onAcceptWithDetails: (_) {
        onDragExit?.call();
        // File bytes are handled by the host app. This widget surfaces the
        // drag gesture so the host can intercept via platform channels.
      },
      builder: (context, candidateData, rejectedData) {
        return Semantics(
          button: true,
          label: multiple
              ? 'Drop files here or browse to upload'
              : 'Drop file here or browse to upload',
          child: GestureDetector(
            onTap: onBrowseTap,
            child: AnimatedContainer(
              duration: rds.durationStandard,
              curve: rds.curveStandard,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(rds.radiusMd),
                // No solid border here — the dashed border is painted by
                // _DashedBorderBox (CustomPaint) wrapping the child.
              ),
              child: _DashedBorderBox(
                color: borderColor,
                radius: rds.radiusMd,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: rds.space6,
                    horizontal: rds.space4,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        RdsIcons.upload,
                        size: RdsIconSize.lg,
                        color: isDragOver ? rds.primary : rds.onSurfaceMuted,
                      ),
                      SizedBox(height: rds.space2),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: rds.bodyMedium.copyWith(
                            color: rds.onSurfaceVariant,
                          ),
                          children: [
                            TextSpan(
                              text: multiple
                                  ? 'Drop files here or '
                                  : 'Drop file here or ',
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: GestureDetector(
                                onTap: onBrowseTap,
                                child: Text(
                                  'browse',
                                  style: rds.bodyMedium.copyWith(
                                    color: rds.primary,
                                    decoration: TextDecoration.underline,
                                    decorationColor: rds.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (hintText != null) ...[
                        SizedBox(height: rds.space1),
                        Text(
                          hintText,
                          style: rds.bodySmall.copyWith(
                            color: rds.onSurfaceMuted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// _DashedBorderBox
// ---------------------------------------------------------------------------

/// Paints a dashed rounded-rect border around [child].
class _DashedBorderBox extends StatelessWidget {
  const _DashedBorderBox({
    required this.child,
    required this.color,
    required this.radius,
  });

  final Widget child;
  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(color: color, radius: radius),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.75, 0.75, size.width - 1.5, size.height - 1.5),
      Radius.circular(radius),
    );

    // Draw dashed path along the rounded rect perimeter.
    const double dashLength = 6.0;
    const double gapLength = 4.0;
    const double step = dashLength + gapLength;

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashLength).clamp(0.0, metric.length);
        canvas.drawPath(
          metric.extractPath(distance, end),
          paint,
        );
        distance += step;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}

// ---------------------------------------------------------------------------
// _FileChip
// ---------------------------------------------------------------------------

/// A single row showing a selected file's name, size, an optional progress
/// bar, and a remove button.
class _FileChip extends StatelessWidget {
  const _FileChip({
    required this.rds,
    required this.file,
    required this.uploading,
    this.progress,
    this.onRemove,
  });

  final RdsTheme rds;
  final RdsUploadedFile file;

  /// Whether the uploading animation should be shown.
  final bool uploading;

  /// Deterministic progress override for this file (0.0–1.0). When null and
  /// [uploading] is true, an indeterminate indicator is shown.
  final double? progress;

  final VoidCallback? onRemove;

  bool get _showProgress => uploading || progress != null;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '${file.name}, ${file.formattedSize}'
          '${_showProgress ? ', uploading' : ''}',
      child: Container(
        decoration: BoxDecoration(
          color: rds.surface,
          border: Border.all(color: rds.outlineVariant),
          borderRadius: BorderRadius.circular(rds.radiusSm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: rds.space3,
                vertical: rds.space2,
              ),
              child: Row(
                children: [
                  // File name
                  Expanded(
                    child: Text(
                      file.name,
                      style: rds.bodyMedium.copyWith(color: rds.onSurface),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(width: rds.space3),
                  // File size
                  Text(
                    file.formattedSize,
                    style: rds.bodySmall.copyWith(color: rds.onSurfaceMuted),
                  ),
                  SizedBox(width: rds.space2),
                  // Remove button
                  Semantics(
                    button: true,
                    label: 'Remove ${file.name}',
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Icon(
                        RdsIcons.close,
                        size: RdsIconSize.md,
                        color: onRemove != null
                            ? rds.onSurfaceVariant
                            : rds.onSurfaceMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Progress bar
            if (_showProgress)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(rds.radiusSm),
                  bottomRight: Radius.circular(rds.radiusSm),
                ),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 3,
                  backgroundColor: rds.outlineVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(rds.primary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
