// ---------------------------------------------------------------------------
// RdsUploadedFile
// ---------------------------------------------------------------------------

/// Represents a single file that has been selected or uploaded.
///
/// This is a pure data class. Actual file bytes are intentionally omitted to
/// keep the model platform-neutral — callers pass bytes through their own
/// picker/IO layer and provide the metadata here.
///
/// ```dart
/// RdsUploadedFile(
///   name: 'blood-panel.pdf',
///   sizeBytes: 1_234_567,
///   mimeType: 'application/pdf',
/// )
/// ```
class RdsUploadedFile {
  const RdsUploadedFile({
    required this.name,
    required this.sizeBytes,
    this.mimeType,
  });

  /// Original filename including extension (e.g. `'report.pdf'`).
  final String name;

  /// File size in bytes. Used to compute [formattedSize].
  final int sizeBytes;

  /// MIME type string, e.g. `'image/jpeg'`. Optional — used for display only.
  final String? mimeType;

  /// Human-readable file size with appropriate unit (B / KB / MB).
  String get formattedSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  String toString() => 'RdsUploadedFile(name: $name, size: $formattedSize)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RdsUploadedFile &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          sizeBytes == other.sizeBytes &&
          mimeType == other.mimeType;

  @override
  int get hashCode => Object.hash(name, sizeBytes, mimeType);
}
