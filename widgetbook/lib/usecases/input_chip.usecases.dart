import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

final inputChipComponent = WidgetbookComponent(
  name: 'Input Chip',
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

  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Cardiology',
  );
  final iconMode = context.knobs.list<RdsChipIconMode>(
    label: 'Icon mode',
    options: RdsChipIconMode.values,
    initialOption: RdsChipIconMode.none,
    labelBuilder: (v) => v.name,
  );
  final selected = context.knobs.boolean(
    label: 'Selected',
    initialValue: false,
  );
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );

  return Scaffold(
    backgroundColor: rds.surface,
    body: Center(
      // The chip is stateless in the playground — use the knob to toggle selected.
      child: RdsInputChip(
        label: label,
        iconMode: iconMode,
        icon: RdsIcons.calendar,
        selected: selected,
        disabled: disabled,
        onChanged: (_) {},
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
          // ---- Icon modes × selected/unselected ----
          Text('Icon modes × selection state', style: rds.titleSmall.copyWith(color: rds.onSurface)),
          SizedBox(height: rds.space3),
          Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            children: [
              TableRow(
                children: [
                  _headerCell(rds, ''),
                  _headerCell(rds, 'Unselected'),
                  _headerCell(rds, 'Selected'),
                  _headerCell(rds, 'Disabled'),
                ],
              ),
              ...RdsChipIconMode.values.map((mode) => TableRow(
                    children: [
                      _headerCell(rds, mode.name),
                      _chipCell(RdsInputChip(
                        label: 'Option',
                        iconMode: mode,
                        icon: RdsIcons.calendar,
                        selected: false,
                        onChanged: (_) {},
                      )),
                      _chipCell(RdsInputChip(
                        label: 'Option',
                        iconMode: mode,
                        icon: RdsIcons.calendar,
                        selected: true,
                        onChanged: (_) {},
                      )),
                      _chipCell(RdsInputChip(
                        label: 'Option',
                        iconMode: mode,
                        icon: RdsIcons.calendar,
                        selected: false,
                        disabled: true,
                        onChanged: null,
                      )),
                    ],
                  )),
            ],
          ),

          SizedBox(height: rds.space6),

          // ---- Interactive filter bar example ----
          Text('Interactive filter bar', style: rds.titleSmall.copyWith(color: rds.onSurface)),
          SizedBox(height: rds.space2),
          Text(
            'Click chips to toggle.',
            style: rds.bodySmall.copyWith(color: rds.onSurfaceMuted),
          ),
          SizedBox(height: rds.space3),
          const _FilterBarDemo(),
        ],
      ),
    ),
  );
}

Widget _headerCell(RdsTheme rds, String text) {
  return Padding(
    padding: EdgeInsets.only(right: rds.space4, bottom: rds.space2),
    child: Text(
      text,
      style: rds.labelSmall.copyWith(color: rds.onSurfaceMuted),
    ),
  );
}

Widget _chipCell(Widget chip) {
  return Padding(
    padding: const EdgeInsets.only(right: 16, bottom: 8),
    child: chip,
  );
}

// ---------------------------------------------------------------------------
// Interactive filter bar demo
// ---------------------------------------------------------------------------

class _FilterBarDemo extends StatefulWidget {
  const _FilterBarDemo();

  @override
  State<_FilterBarDemo> createState() => _FilterBarDemoState();
}

class _FilterBarDemoState extends State<_FilterBarDemo> {
  final List<String> _options = [
    'Cardiology',
    'Neurology',
    'Oncology',
    'Endocrinology',
    'Dermatology',
    'Today',
    'This week',
    'Active',
  ];

  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Wrap(
      spacing: rds.space2,
      runSpacing: rds.space2,
      children: _options
          .map((option) => RdsInputChip(
                label: option,
                selected: _selected.contains(option),
                onChanged: (value) {
                  setState(() {
                    if (value) {
                      _selected.add(option);
                    } else {
                      _selected.remove(option);
                    }
                  });
                },
              ))
          .toList(),
    );
  }
}
