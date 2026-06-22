import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

final dropdownFieldComponent = WidgetbookComponent(
  name: 'Dropdown Field',
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
];

Widget _playground(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Health focus',
  );
  final placeholder = context.knobs.string(
    label: 'Placeholder',
    initialValue: 'Select...',
  );
  final mandatory = context.knobs.boolean(
    label: 'Mandatory',
    initialValue: false,
  );
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );
  final searchable = context.knobs.boolean(
    label: 'Searchable',
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
      dynamic selected;
      return Container(
        color: rds.surface,
        padding: EdgeInsets.all(rds.space6),
        child: StatefulBuilder(
          builder: (context, setInnerState) {
            return RdsDropdownField(
              label: label,
              items: _items,
              value: selected,
              onChanged: disabled ? null : (v) => setInnerState(() => selected = v),
              placeholder: placeholder,
              mandatory: mandatory,
              disabled: disabled,
              searchable: searchable,
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
      RdsDropdownField(
        label: 'Health focus',
        items: _items,
        onChanged: (_) {},
      ),
    ),
    (
      'With value selected',
      RdsDropdownField(
        label: 'Health focus',
        items: _items,
        value: 'sleep',
        onChanged: (_) {},
      ),
    ),
    (
      'Mandatory',
      RdsDropdownField(
        label: 'Health focus',
        items: _items,
        mandatory: true,
        onChanged: (_) {},
      ),
    ),
    (
      'With support text',
      RdsDropdownField(
        label: 'Health focus',
        items: _items,
        supportText: 'Select the primary health goal for this patient',
        onChanged: (_) {},
      ),
    ),
    (
      'Error state',
      RdsDropdownField(
        label: 'Health focus',
        items: _items,
        errorText: 'Please select a health focus area',
        onChanged: (_) {},
      ),
    ),
    (
      'Searchable',
      RdsDropdownField(
        label: 'Health focus',
        items: _items,
        searchable: true,
        onChanged: (_) {},
      ),
    ),
    (
      'Disabled',
      RdsDropdownField(
        label: 'Health focus',
        items: _items,
        disabled: true,
      ),
    ),
    (
      'Disabled with value',
      RdsDropdownField(
        label: 'Health focus',
        items: _items,
        value: 'cardio',
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
