import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

// ---------------------------------------------------------------------------
// Component registration
// ---------------------------------------------------------------------------

final segmentedControlInputComponent = WidgetbookComponent(
  name: 'Segmented Control Input',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _playground),
    WidgetbookUseCase(name: 'Gallery', builder: _gallery),
  ],
);

// ---------------------------------------------------------------------------
// Demo segments (String-typed, reused across use cases)
// ---------------------------------------------------------------------------

const _demoSegments = <RdsSegment<String>>[
  RdsSegment(value: 'day', label: 'Day'),
  RdsSegment(value: 'week', label: 'Week'),
  RdsSegment(value: 'month', label: 'Month'),
];

// ---------------------------------------------------------------------------
// Playground
// ---------------------------------------------------------------------------

Widget _playground(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Time range',
  );
  final mandatory = context.knobs.boolean(
    label: 'Mandatory',
    initialValue: false,
  );
  final optional = context.knobs.boolean(
    label: 'Optional',
    initialValue: false,
  );
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );
  final errorTextRaw = context.knobs.string(
    label: 'Error text',
    initialValue: '',
  );
  final supportTextRaw = context.knobs.string(
    label: 'Support text',
    initialValue: 'Select the period you want to view.',
  );
  final selectionMode = context.knobs.list(
    label: 'Selection mode',
    options: [
      RdsButtonGroupSelectionMode.single,
      RdsButtonGroupSelectionMode.multi,
    ],
    initialOption: RdsButtonGroupSelectionMode.single,
    labelBuilder: (v) => v.name,
  );

  // Resolve nullable strings from knobs
  final errorText = errorTextRaw.isNotEmpty ? errorTextRaw : null;
  final supportText = supportTextRaw.isNotEmpty ? supportTextRaw : null;

  return Scaffold(
    backgroundColor: rds.surface,
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(rds.space6),
        child: StatefulBuilder(
          builder: (context, setState) {
            // Local selection state managed inside the builder.
            // We must hold this outside the builder to survive rebuilds, so
            // we use a ValueNotifier-style workaround via a closure variable.
            // StatefulBuilder provides setState which triggers a local rebuild.
            return _PlaygroundBody(
              label: label,
              mandatory: mandatory,
              optional: optional,
              disabled: disabled,
              errorText: errorText,
              supportText: supportText,
              selectionMode: selectionMode,
            );
          },
        ),
      ),
    ),
  );
}

/// Stateful inner widget for the Playground so that selection changes are
/// reflected without requiring a full Widgetbook rebuild.
class _PlaygroundBody extends StatefulWidget {
  const _PlaygroundBody({
    required this.label,
    required this.mandatory,
    required this.optional,
    required this.disabled,
    required this.errorText,
    required this.supportText,
    required this.selectionMode,
  });

  final String label;
  final bool mandatory;
  final bool optional;
  final bool disabled;
  final String? errorText;
  final String? supportText;
  final RdsButtonGroupSelectionMode selectionMode;

  @override
  State<_PlaygroundBody> createState() => _PlaygroundBodyState();
}

class _PlaygroundBodyState extends State<_PlaygroundBody> {
  Set<String> _selected = {'week'};

  @override
  Widget build(BuildContext context) {
    return RdsSegmentedControlInput<String>(
      label: widget.label,
      segments: _demoSegments,
      selectionMode: widget.selectionMode,
      selected: _selected,
      onChanged: widget.disabled ? null : (next) => setState(() => _selected = next),
      supportText: widget.supportText,
      errorText: widget.errorText,
      mandatory: widget.mandatory && !widget.optional,
      optional: widget.optional && !widget.mandatory,
      disabled: widget.disabled,
    );
  }
}

// ---------------------------------------------------------------------------
// Gallery
// ---------------------------------------------------------------------------

Widget _gallery(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Segmented Control Input Gallery',
            style: rds.headlineMedium.copyWith(color: rds.onSurface),
          ),
          SizedBox(height: rds.space8),

          // --- Enabled ---
          Text(
            'Enabled',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          _GalleryItem(
            label: 'Time range',
            supportText: 'Select the period you want to view.',
            disabled: false,
            errorText: null,
          ),
          SizedBox(height: rds.space6),

          // --- With mandatory indicator ---
          Text(
            'Mandatory',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          _GalleryItem(
            label: 'Time range',
            supportText: null,
            disabled: false,
            errorText: null,
            mandatory: true,
          ),
          SizedBox(height: rds.space6),

          // --- With optional indicator ---
          Text(
            'Optional',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          _GalleryItem(
            label: 'Time range',
            supportText: 'Leave blank to use the default view.',
            disabled: false,
            errorText: null,
            optional: true,
          ),
          SizedBox(height: rds.space6),

          // --- Error state ---
          Text(
            'Error',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          _GalleryItem(
            label: 'Time range',
            supportText: null,
            disabled: false,
            errorText: 'Please select a time range to continue.',
            mandatory: true,
          ),
          SizedBox(height: rds.space6),

          // --- Disabled ---
          Text(
            'Disabled',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          RdsSegmentedControlInput<String>(
            label: 'Time range',
            segments: _demoSegments,
            selected: const {'week'},
            onChanged: null,
            supportText: 'Selection is unavailable in this context.',
            disabled: true,
          ),
        ],
      ),
    ),
  );
}

/// Stateful helper for gallery items that need live selection state.
class _GalleryItem extends StatefulWidget {
  const _GalleryItem({
    required this.label,
    required this.supportText,
    required this.disabled,
    required this.errorText,
    this.mandatory = false,
    this.optional = false,
  });

  final String label;
  final String? supportText;
  final bool disabled;
  final String? errorText;
  final bool mandatory;
  final bool optional;

  @override
  State<_GalleryItem> createState() => _GalleryItemState();
}

class _GalleryItemState extends State<_GalleryItem> {
  Set<String> _selected = {'week'};

  @override
  Widget build(BuildContext context) {
    return RdsSegmentedControlInput<String>(
      label: widget.label,
      segments: _demoSegments,
      selected: _selected,
      onChanged:
          widget.disabled ? null : (next) => setState(() => _selected = next),
      supportText: widget.supportText,
      errorText: widget.errorText,
      mandatory: widget.mandatory,
      optional: widget.optional,
      disabled: widget.disabled,
    );
  }
}
