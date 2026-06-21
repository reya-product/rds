import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

final segmentedButtonsComponent = WidgetbookComponent(
  name: 'Segmented Buttons',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _playground),
    WidgetbookUseCase(name: 'Gallery', builder: _gallery),
  ],
);

// ---------------------------------------------------------------------------
// Playground
// ---------------------------------------------------------------------------

Widget _playground(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final selectionMode = context.knobs.list(
    label: 'Selection mode',
    options: [
      RdsButtonGroupSelectionMode.single,
      RdsButtonGroupSelectionMode.multi,
    ],
    initialOption: RdsButtonGroupSelectionMode.single,
    labelBuilder: (v) => v.name,
  );
  final showIcons = context.knobs.boolean(
    label: 'Show icons',
    initialValue: true,
  );
  final showCheckmark = context.knobs.boolean(
    label: 'Show checkmark',
    initialValue: true,
  );
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );

  return Scaffold(
    backgroundColor: rds.surface,
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(rds.space6),
        child: _StatefulSegmented(
          selectionMode: selectionMode,
          showIcons: showIcons,
          showCheckmark: showCheckmark,
          disabled: disabled,
        ),
      ),
    ),
  );
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
            'Segmented Buttons Gallery',
            style: rds.headlineMedium.copyWith(color: rds.onSurface),
          ),
          SizedBox(height: rds.space6),

          // Single select — no icons
          Text(
            'Single select — labels only',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          _StatefulSegmented(
            selectionMode: RdsButtonGroupSelectionMode.single,
            showIcons: false,
            showCheckmark: true,
            disabled: false,
          ),
          SizedBox(height: rds.space6),

          // Single select — with icons
          Text(
            'Single select — with icons',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          _StatefulSegmented(
            selectionMode: RdsButtonGroupSelectionMode.single,
            showIcons: true,
            showCheckmark: true,
            disabled: false,
          ),
          SizedBox(height: rds.space6),

          // Multi select
          Text(
            'Multi select',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          _StatefulSegmented(
            selectionMode: RdsButtonGroupSelectionMode.multi,
            showIcons: true,
            showCheckmark: true,
            disabled: false,
          ),
          SizedBox(height: rds.space6),

          // No checkmark
          Text(
            'Without checkmark',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          _StatefulSegmented(
            selectionMode: RdsButtonGroupSelectionMode.single,
            showIcons: false,
            showCheckmark: false,
            disabled: false,
          ),
          SizedBox(height: rds.space6),

          // Disabled
          Text(
            'Disabled',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          RdsSegmentedButtons<String>(
            segments: const [
              RdsSegment(value: '7d', label: '7 days'),
              RdsSegment(value: '30d', label: '30 days'),
              RdsSegment(value: '90d', label: '90 days'),
            ],
            selected: const {'30d'},
            disabled: true,
          ),
          SizedBox(height: rds.space6),

          // Two segments
          Text(
            'Two segments',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          _StatefulSegmentedTwo(),
          SizedBox(height: rds.space6),

          // Individual segment disabled
          Text(
            'Individual segment disabled',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          RdsSegmentedButtons<String>(
            segments: const [
              RdsSegment(value: 'active', label: 'Active'),
              RdsSegment(value: 'pending', label: 'Pending', disabled: true),
              RdsSegment(value: 'archived', label: 'Archived'),
            ],
            selected: const {'active'},
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Stateful helpers
// ---------------------------------------------------------------------------

class _StatefulSegmented extends StatefulWidget {
  const _StatefulSegmented({
    required this.selectionMode,
    required this.showIcons,
    required this.showCheckmark,
    required this.disabled,
  });

  final RdsButtonGroupSelectionMode selectionMode;
  final bool showIcons;
  final bool showCheckmark;
  final bool disabled;

  @override
  State<_StatefulSegmented> createState() => _StatefulSegmentedState();
}

class _StatefulSegmentedState extends State<_StatefulSegmented> {
  Set<String> _selected = {'30d'};

  List<RdsSegment<String>> get _segments => [
        RdsSegment(
          value: '7d',
          label: '7 days',
          icon: widget.showIcons ? RdsIcons.calendar : null,
        ),
        RdsSegment(
          value: '30d',
          label: '30 days',
          icon: widget.showIcons ? RdsIcons.calendar : null,
        ),
        RdsSegment(
          value: '90d',
          label: '90 days',
          icon: widget.showIcons ? RdsIcons.calendar : null,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return RdsSegmentedButtons<String>(
      segments: _segments,
      selectionMode: widget.selectionMode,
      selected: _selected,
      showIcons: widget.showIcons,
      showCheckmark: widget.showCheckmark,
      disabled: widget.disabled,
      onSelectionChanged: (next) => setState(() => _selected = next),
    );
  }
}

class _StatefulSegmentedTwo extends StatefulWidget {
  @override
  State<_StatefulSegmentedTwo> createState() => _StatefulSegmentedTwoState();
}

class _StatefulSegmentedTwoState extends State<_StatefulSegmentedTwo> {
  Set<String> _selected = {'list'};

  @override
  Widget build(BuildContext context) {
    return RdsSegmentedButtons<String>(
      segments: const [
        RdsSegment(value: 'list', label: 'List', icon: RdsIcons.filter),
        RdsSegment(value: 'grid', label: 'Grid', icon: RdsIcons.sort),
      ],
      selected: _selected,
      showIcons: true,
      onSelectionChanged: (next) => setState(() => _selected = next),
    );
  }
}
