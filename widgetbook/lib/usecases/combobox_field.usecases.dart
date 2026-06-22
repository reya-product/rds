import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

final comboboxFieldComponent = WidgetbookComponent(
  name: 'Combobox Field',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _playground),
    WidgetbookUseCase(name: 'States gallery', builder: _statesGallery),
  ],
);

// ---------------------------------------------------------------------------
// Playground
// ---------------------------------------------------------------------------

const _items = [
  RdsDropdownItem(value: 'cardio', label: 'Cardiovascular health'),
  RdsDropdownItem(value: 'sleep', label: 'Sleep quality'),
  RdsDropdownItem(value: 'nutrition', label: 'Nutrition & diet'),
  RdsDropdownItem(value: 'mental', label: 'Mental wellbeing'),
  RdsDropdownItem(value: 'mobility', label: 'Mobility & flexibility'),
  RdsDropdownItem(value: 'strength', label: 'Strength & conditioning'),
  RdsDropdownItem(value: 'weight', label: 'Weight management'),
  RdsDropdownItem(value: 'longevity', label: 'Longevity optimisation'),
];

Widget _playground(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Health focus areas',
  );
  final placeholder = context.knobs.string(
    label: 'Placeholder',
    initialValue: 'Search...',
  );
  final mandatory = context.knobs.boolean(
    label: 'Mandatory',
    initialValue: false,
  );
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );
  final supportText = context.knobs.stringOrNull(
    label: 'Support text',
    initialValue: null,
  );
  final errorText = context.knobs.stringOrNull(
    label: 'Error text',
    initialValue: null,
  );

  return StatefulBuilder(
    builder: (context, setState) {
      Set<dynamic> selected = {};
      return Container(
        color: rds.surface,
        padding: EdgeInsets.all(rds.space6),
        child: StatefulBuilder(
          builder: (context, setInnerState) {
            return RdsComboboxField(
              label: label,
              items: _items,
              selected: selected,
              onChanged: disabled ? null : (v) => setInnerState(() => selected = v),
              placeholder: placeholder,
              mandatory: mandatory,
              disabled: disabled,
              supportText: supportText,
              errorText: errorText,
            );
          },
        ),
      );
    },
  );
}

// ---------------------------------------------------------------------------
// States gallery
// ---------------------------------------------------------------------------

Widget _statesGallery(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final states = <(String, Widget)>[
    (
      'Empty (no selection)',
      RdsComboboxField(
        label: 'Health focus areas',
        items: _items,
        onChanged: (_) {},
      ),
    ),
    (
      'Pre-selected values',
      RdsComboboxField(
        label: 'Health focus areas',
        items: _items,
        selected: {'cardio', 'sleep', 'nutrition'},
        onChanged: (_) {},
      ),
    ),
    (
      'Mandatory',
      RdsComboboxField(
        label: 'Health focus areas',
        items: _items,
        mandatory: true,
        onChanged: (_) {},
      ),
    ),
    (
      'With support text',
      RdsComboboxField(
        label: 'Health focus areas',
        items: _items,
        supportText: 'Select all areas relevant to this patient',
        onChanged: (_) {},
      ),
    ),
    (
      'Error state',
      RdsComboboxField(
        label: 'Health focus areas',
        items: _items,
        errorText: 'Please select at least one area',
        onChanged: (_) {},
      ),
    ),
    (
      'Max selections (2)',
      RdsComboboxField(
        label: 'Health focus areas',
        items: _items,
        maxSelections: 2,
        supportText: 'Choose up to 2 areas',
        onChanged: (_) {},
      ),
    ),
    (
      'Disabled',
      RdsComboboxField(
        label: 'Health focus areas',
        items: _items,
        disabled: true,
      ),
    ),
    (
      'Disabled with values',
      RdsComboboxField(
        label: 'Health focus areas',
        items: _items,
        selected: {'cardio', 'sleep'},
        disabled: true,
      ),
    ),
  ];

  return Container(
    color: rds.surfaceVariant,
    child: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (label, widget) in states) ...[
            Text(
              label,
              style: rds.bodySmall.copyWith(
                color: rds.onSurfaceMuted,
                fontFamily: 'monospace',
              ),
            ),
            SizedBox(height: rds.space2),
            widget,
            SizedBox(height: rds.space5),
          ],
        ],
      ),
    ),
  );
}
