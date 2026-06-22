import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

// ignore_for_file: avoid_redundant_argument_values

// ---------------------------------------------------------------------------
// fieldUploaderComponent
// ---------------------------------------------------------------------------

final fieldUploaderComponent = WidgetbookComponent(
  name: 'Field Uploader',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: _playgroundUseCase,
    ),
    WidgetbookUseCase(
      name: 'Single file — empty',
      builder: _singleEmptyUseCase,
    ),
    WidgetbookUseCase(
      name: 'Single file — with file',
      builder: _singleWithFileUseCase,
    ),
    WidgetbookUseCase(
      name: 'Multiple files',
      builder: _multipleFilesUseCase,
    ),
    WidgetbookUseCase(
      name: 'Uploading',
      builder: _uploadingUseCase,
    ),
    WidgetbookUseCase(
      name: 'Error',
      builder: _errorUseCase,
    ),
  ],
);

// ---------------------------------------------------------------------------
// Playground
// ---------------------------------------------------------------------------

Widget _playgroundUseCase(BuildContext context) {
  final multiple = context.knobs.boolean(
    label: 'Multiple',
    initialValue: false,
  );
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );
  final mandatory = context.knobs.boolean(
    label: 'Mandatory',
    initialValue: false,
  );
  final errorTextRaw = context.knobs.string(
    label: 'Error text',
    initialValue: '',
  );
  final supportTextRaw = context.knobs.string(
    label: 'Support text',
    initialValue: 'PDF or image. Max 10 MB.',
  );

  return _UploaderScaffold(
    builder: (files, setFiles) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RdsFieldUploader(
          label: 'Upload document',
          multiple: multiple,
          disabled: disabled,
          mandatory: mandatory,
          errorText: errorTextRaw.isNotEmpty ? errorTextRaw : null,
          supportText: supportTextRaw.isNotEmpty ? supportTextRaw : null,
          files: files,
          onFilesChanged: setFiles,
          onBrowseTap: () {
            // In Widgetbook, simulate a "browse" tap by adding a mock file.
            setFiles([
              ...files,
              RdsUploadedFile(
                name: 'document_${files.length + 1}.pdf',
                sizeBytes: 1_234_567,
                mimeType: 'application/pdf',
              ),
            ]);
          },
        ),
        const SizedBox(height: 16),
        _AddMockFileButton(
          onTap: () => setFiles([
            ...files,
            RdsUploadedFile(
              name: 'mock_file_${files.length + 1}.pdf',
              sizeBytes: (files.length + 1) * 345_678,
              mimeType: 'application/pdf',
            ),
          ]),
        ),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// Single file — empty
// ---------------------------------------------------------------------------

Widget _singleEmptyUseCase(BuildContext context) {
  return _UploaderScaffold(
    builder: (files, setFiles) => RdsFieldUploader(
      label: 'Upload report',
      supportText: 'PDF only. Max 5 MB.',
      acceptedTypes: const ['.pdf'],
      maxFileSizeMb: 5,
      files: files,
      onFilesChanged: setFiles,
    ),
  );
}

// ---------------------------------------------------------------------------
// Single file — with file
// ---------------------------------------------------------------------------

Widget _singleWithFileUseCase(BuildContext context) {
  return _UploaderScaffold(
    initialFiles: const [
      RdsUploadedFile(
        name: 'blood_panel_results.pdf',
        sizeBytes: 1_258_291,
        mimeType: 'application/pdf',
      ),
    ],
    builder: (files, setFiles) => RdsFieldUploader(
      label: 'Upload report',
      supportText: 'PDF only. Max 5 MB.',
      acceptedTypes: const ['.pdf'],
      maxFileSizeMb: 5,
      files: files,
      onFilesChanged: setFiles,
    ),
  );
}

// ---------------------------------------------------------------------------
// Multiple files
// ---------------------------------------------------------------------------

Widget _multipleFilesUseCase(BuildContext context) {
  return _UploaderScaffold(
    initialFiles: const [
      RdsUploadedFile(
        name: 'annual_report.pdf',
        sizeBytes: 2_097_152,
        mimeType: 'application/pdf',
      ),
      RdsUploadedFile(
        name: 'photo_id.jpg',
        sizeBytes: 347_890,
        mimeType: 'image/jpeg',
      ),
    ],
    builder: (files, setFiles) => RdsFieldUploader(
      label: 'Supporting documents',
      multiple: true,
      mandatory: true,
      supportText: 'PDF or image. Max 10 MB each.',
      acceptedTypes: const ['.pdf', '.jpg', '.png'],
      maxFileSizeMb: 10,
      files: files,
      onFilesChanged: setFiles,
    ),
  );
}

// ---------------------------------------------------------------------------
// Uploading
// ---------------------------------------------------------------------------

Widget _uploadingUseCase(BuildContext context) {
  return _StaticScaffold(
    child: RdsFieldUploader(
      label: 'Uploading in progress',
      multiple: true,
      uploading: true,
      uploadProgress: const {
        'document.pdf': 0.65,
        'photo.jpg': 0.30,
      },
      files: const [
        RdsUploadedFile(
          name: 'document.pdf',
          sizeBytes: 1_200_000,
          mimeType: 'application/pdf',
        ),
        RdsUploadedFile(
          name: 'photo.jpg',
          sizeBytes: 347_890,
          mimeType: 'image/jpeg',
        ),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// Error
// ---------------------------------------------------------------------------

Widget _errorUseCase(BuildContext context) {
  return _StaticScaffold(
    child: RdsFieldUploader(
      label: 'Upload report',
      mandatory: true,
      errorText: 'File exceeds the maximum size of 5 MB.',
      files: const [
        RdsUploadedFile(
          name: 'large_scan.pdf',
          sizeBytes: 8_388_608,
          mimeType: 'application/pdf',
        ),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// Shared scaffolds
// ---------------------------------------------------------------------------

/// Stateful scaffold that manages a files list and passes it to [builder].
class _UploaderScaffold extends StatefulWidget {
  const _UploaderScaffold({
    required this.builder,
    this.initialFiles = const [],
  });

  final List<RdsUploadedFile> initialFiles;
  final Widget Function(
    List<RdsUploadedFile> files,
    ValueChanged<List<RdsUploadedFile>> setFiles,
  ) builder;

  @override
  State<_UploaderScaffold> createState() => _UploaderScaffoldState();
}

class _UploaderScaffoldState extends State<_UploaderScaffold> {
  late List<RdsUploadedFile> _files;

  @override
  void initState() {
    super.initState();
    _files = List<RdsUploadedFile>.from(widget.initialFiles);
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(rds.space8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: widget.builder(
              _files,
              (updated) => setState(() => _files = updated),
            ),
          ),
        ),
      ),
    );
  }
}

/// Static (non-stateful) scaffold for fixed-state use cases.
class _StaticScaffold extends StatelessWidget {
  const _StaticScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(rds.space8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _AddMockFileButton
// ---------------------------------------------------------------------------

/// A simple outlined button used in the Playground to add fake files without
/// a real file picker.
class _AddMockFileButton extends StatelessWidget {
  const _AddMockFileButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Semantics(
      button: true,
      label: 'Add mock file',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: rds.space4,
            vertical: rds.space2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: rds.outline),
            borderRadius: BorderRadius.circular(rds.radiusSm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(RdsIcons.add, size: RdsIconSize.md, color: rds.onSurfaceVariant),
              SizedBox(width: rds.space1),
              Text(
                'Add mock file',
                style: rds.labelLarge.copyWith(color: rds.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
