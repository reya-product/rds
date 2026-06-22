import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:rds/rds.dart';

// ---------------------------------------------------------------------------
// Shared demo data
// ---------------------------------------------------------------------------

const _demoItems = [
  RdsListInputItem(
    value: 'cardio',
    label: 'Cardiovascular health',
    supportingText: 'Heart rate, blood pressure',
  ),
  RdsListInputItem(
    value: 'sleep',
    label: 'Sleep quality',
    supportingText: 'Duration, cycles',
  ),
  RdsListInputItem(
    value: 'nutrition',
    label: 'Nutrition tracking',
  ),
  RdsListInputItem(
    value: 'stress',
    label: 'Stress management',
  ),
  RdsListInputItem(
    value: 'fitness',
    label: 'Fitness goals',
    disabled: true,
  ),
];

// ---------------------------------------------------------------------------
// Multi-select List Input
// ---------------------------------------------------------------------------

final multiSelectListInputComponent = WidgetbookComponent(
  name: 'Multi-select List',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _multiPlayground),
    WidgetbookUseCase(name: 'Gallery', builder: _multiGallery),
  ],
);

Widget _multiPlayground(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final showDividers =
      context.knobs.boolean(label: 'Show dividers', initialValue: false);
  final bordered =
      context.knobs.boolean(label: 'Bordered', initialValue: false);
  final mandatory =
      context.knobs.boolean(label: 'Mandatory', initialValue: false);
  final errorText =
      context.knobs.string(label: 'Error text', initialValue: '');
  final disabled =
      context.knobs.boolean(label: 'Disabled', initialValue: false);

  return Scaffold(
    backgroundColor: rds.surface,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: EdgeInsets.all(rds.space6),
          child: StatefulBuilder(
            builder: (ctx, setState) {
              var selected = <String>{};
              return RdsMultiSelectListInput<String>(
                label: 'Health goals',
                items: _demoItems,
                selected: selected,
                onChanged: disabled
                    ? null
                    : (s) => setState(() => selected = s),
                showDividers: showDividers,
                bordered: bordered,
                mandatory: mandatory,
                errorText: errorText.isEmpty ? null : errorText,
              );
            },
          ),
        ),
      ),
    ),
  );
}

Widget _multiGallery(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Multi-select List Input',
            style: rds.headlineMedium.copyWith(color: rds.onSurface),
          ),
          SizedBox(height: rds.space6),
          _GalleryCard(
            description: 'Enabled — no selection',
            child: _MultiSelectDemo(selected: const {}),
          ),
          SizedBox(height: rds.space4),
          _GalleryCard(
            description: 'With selections',
            child: _MultiSelectDemo(selected: const {'cardio', 'sleep'}),
          ),
          SizedBox(height: rds.space4),
          _GalleryCard(
            description: 'With dividers and bordered',
            child: _MultiSelectDemo(
              selected: const {'nutrition'},
              showDividers: true,
              bordered: true,
            ),
          ),
          SizedBox(height: rds.space4),
          _GalleryCard(
            description: 'Error state',
            child: RdsMultiSelectListInput<String>(
              label: 'Health goals',
              items: _demoItems,
              selected: const {},
              onChanged: (_) {},
              errorText: 'Please select at least one health goal.',
              mandatory: true,
            ),
          ),
          SizedBox(height: rds.space4),
          _GalleryCard(
            description: 'Disabled (onChanged: null)',
            child: RdsMultiSelectListInput<String>(
              label: 'Health goals',
              items: _demoItems,
              selected: const {'sleep'},
              onChanged: null,
            ),
          ),
        ],
      ),
    ),
  );
}

/// Stateful helper for interactive gallery demos.
class _MultiSelectDemo extends StatefulWidget {
  final Set<String> selected;
  final bool showDividers;
  final bool bordered;

  const _MultiSelectDemo({
    required this.selected,
    this.showDividers = false,
    this.bordered = false,
  });

  @override
  State<_MultiSelectDemo> createState() => _MultiSelectDemoState();
}

class _MultiSelectDemoState extends State<_MultiSelectDemo> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    return RdsMultiSelectListInput<String>(
      label: 'Health goals',
      items: _demoItems,
      selected: _selected,
      onChanged: (s) => setState(() => _selected = s),
      showDividers: widget.showDividers,
      bordered: widget.bordered,
    );
  }
}

// ---------------------------------------------------------------------------
// Single-select List Input
// ---------------------------------------------------------------------------

final singleSelectListInputComponent = WidgetbookComponent(
  name: 'Single-select List',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _singlePlayground),
    WidgetbookUseCase(name: 'Gallery', builder: _singleGallery),
  ],
);

Widget _singlePlayground(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final showDividers =
      context.knobs.boolean(label: 'Show dividers', initialValue: false);
  final bordered =
      context.knobs.boolean(label: 'Bordered', initialValue: false);
  final mandatory =
      context.knobs.boolean(label: 'Mandatory', initialValue: false);
  final errorText =
      context.knobs.string(label: 'Error text', initialValue: '');
  final disabled =
      context.knobs.boolean(label: 'Disabled', initialValue: false);

  return Scaffold(
    backgroundColor: rds.surface,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: EdgeInsets.all(rds.space6),
          child: StatefulBuilder(
            builder: (ctx, setState) {
              String? selected;
              return RdsSingleSelectListInput<String>(
                label: 'Primary health goal',
                items: _demoItems,
                selected: selected,
                onChanged: disabled
                    ? null
                    : (v) => setState(() => selected = v),
                showDividers: showDividers,
                bordered: bordered,
                mandatory: mandatory,
                errorText: errorText.isEmpty ? null : errorText,
              );
            },
          ),
        ),
      ),
    ),
  );
}

Widget _singleGallery(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Single-select List Input',
            style: rds.headlineMedium.copyWith(color: rds.onSurface),
          ),
          SizedBox(height: rds.space6),
          _GalleryCard(
            description: 'Enabled — no selection',
            child: _SingleSelectDemo(selected: null),
          ),
          SizedBox(height: rds.space4),
          _GalleryCard(
            description: 'With selection',
            child: _SingleSelectDemo(selected: 'cardio'),
          ),
          SizedBox(height: rds.space4),
          _GalleryCard(
            description: 'With dividers and bordered',
            child: _SingleSelectDemo(
              selected: 'sleep',
              showDividers: true,
              bordered: true,
            ),
          ),
          SizedBox(height: rds.space4),
          _GalleryCard(
            description: 'Error state',
            child: RdsSingleSelectListInput<String>(
              label: 'Primary health goal',
              items: _demoItems,
              selected: null,
              onChanged: (_) {},
              errorText: 'Please select a health goal.',
              mandatory: true,
            ),
          ),
          SizedBox(height: rds.space4),
          _GalleryCard(
            description: 'Disabled (onChanged: null)',
            child: RdsSingleSelectListInput<String>(
              label: 'Primary health goal',
              items: _demoItems,
              selected: 'nutrition',
              onChanged: null,
            ),
          ),
        ],
      ),
    ),
  );
}

class _SingleSelectDemo extends StatefulWidget {
  final String? selected;
  final bool showDividers;
  final bool bordered;

  const _SingleSelectDemo({
    required this.selected,
    this.showDividers = false,
    this.bordered = false,
  });

  @override
  State<_SingleSelectDemo> createState() => _SingleSelectDemoState();
}

class _SingleSelectDemoState extends State<_SingleSelectDemo> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return RdsSingleSelectListInput<String>(
      label: 'Primary health goal',
      items: _demoItems,
      selected: _selected,
      onChanged: (v) => setState(() => _selected = v),
      showDividers: widget.showDividers,
      bordered: widget.bordered,
    );
  }
}

// ---------------------------------------------------------------------------
// Toggle List Input
// ---------------------------------------------------------------------------

final toggleListInputComponent = WidgetbookComponent(
  name: 'Toggle List',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _togglePlayground),
    WidgetbookUseCase(name: 'Gallery', builder: _toggleGallery),
  ],
);

Widget _togglePlayground(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final showDividers =
      context.knobs.boolean(label: 'Show dividers', initialValue: true);
  final bordered =
      context.knobs.boolean(label: 'Bordered', initialValue: false);
  final mandatory =
      context.knobs.boolean(label: 'Mandatory', initialValue: false);
  final errorText =
      context.knobs.string(label: 'Error text', initialValue: '');
  final disabled =
      context.knobs.boolean(label: 'Disabled', initialValue: false);

  return Scaffold(
    backgroundColor: rds.surface,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: EdgeInsets.all(rds.space6),
          child: StatefulBuilder(
            builder: (ctx, setState) {
              var selected = <String>{};
              return RdsToggleListInput<String>(
                label: 'Health tracking',
                items: _demoItems,
                selected: selected,
                onChanged: disabled
                    ? null
                    : (s) => setState(() => selected = s),
                showDividers: showDividers,
                bordered: bordered,
                mandatory: mandatory,
                errorText: errorText.isEmpty ? null : errorText,
              );
            },
          ),
        ),
      ),
    ),
  );
}

Widget _toggleGallery(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Toggle List Input',
            style: rds.headlineMedium.copyWith(color: rds.onSurface),
          ),
          SizedBox(height: rds.space6),
          _GalleryCard(
            description: 'Enabled — nothing toggled on',
            child: _ToggleDemo(selected: const {}),
          ),
          SizedBox(height: rds.space4),
          _GalleryCard(
            description: 'With toggles on',
            child: _ToggleDemo(selected: const {'cardio', 'sleep'}),
          ),
          SizedBox(height: rds.space4),
          _GalleryCard(
            description: 'No dividers + bordered',
            child: _ToggleDemo(
              selected: const {'nutrition'},
              showDividers: false,
              bordered: true,
            ),
          ),
          SizedBox(height: rds.space4),
          _GalleryCard(
            description: 'Error state',
            child: RdsToggleListInput<String>(
              label: 'Health tracking',
              items: _demoItems,
              selected: const {},
              onChanged: (_) {},
              errorText: 'Please enable at least one tracking category.',
              mandatory: true,
            ),
          ),
          SizedBox(height: rds.space4),
          _GalleryCard(
            description: 'Disabled (onChanged: null)',
            child: RdsToggleListInput<String>(
              label: 'Health tracking',
              items: _demoItems,
              selected: const {'sleep'},
              onChanged: null,
            ),
          ),
        ],
      ),
    ),
  );
}

class _ToggleDemo extends StatefulWidget {
  final Set<String> selected;
  final bool showDividers;
  final bool bordered;

  const _ToggleDemo({
    required this.selected,
    this.showDividers = true,
    this.bordered = false,
  });

  @override
  State<_ToggleDemo> createState() => _ToggleDemoState();
}

class _ToggleDemoState extends State<_ToggleDemo> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    return RdsToggleListInput<String>(
      label: 'Health tracking',
      items: _demoItems,
      selected: _selected,
      onChanged: (s) => setState(() => _selected = s),
      showDividers: widget.showDividers,
      bordered: widget.bordered,
    );
  }
}

// ---------------------------------------------------------------------------
// Shared gallery card
// ---------------------------------------------------------------------------

class _GalleryCard extends StatelessWidget {
  final String description;
  final Widget child;

  const _GalleryCard({required this.description, required this.child});

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Container(
      decoration: BoxDecoration(
        color: rds.surface,
        borderRadius: BorderRadius.circular(rds.radiusMd),
        border: Border.all(color: rds.outlineVariant),
      ),
      padding: EdgeInsets.all(rds.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: rds.labelSmall.copyWith(color: rds.onSurfaceMuted),
          ),
          SizedBox(height: rds.space3),
          child,
        ],
      ),
    );
  }
}
