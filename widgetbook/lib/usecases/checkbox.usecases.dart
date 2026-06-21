import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

/// Top-level [WidgetbookComponent] for the Checkbox.
/// Register this in T1 Atoms in [main.dart]:
///   `checkboxComponent`
final checkboxComponent = WidgetbookComponent(
  name: 'Checkbox',
  useCases: [
    _playground,
    _gallery,
  ],
);

// ---------------------------------------------------------------------------
// Playground — all knobs
// ---------------------------------------------------------------------------

final _playground = WidgetbookUseCase(
  name: 'Playground',
  builder: (context) {
    final valueStr = context.knobs.list<String>(
      label: 'Value',
      options: const ['checked', 'unchecked', 'indeterminate'],
      initialOption: 'unchecked',
      labelBuilder: (v) => v,
    );
    final disabled =
        context.knobs.boolean(label: 'Disabled', initialValue: false);
    final readOnly =
        context.knobs.boolean(label: 'Read Only', initialValue: false);
    final error =
        context.knobs.boolean(label: 'Error', initialValue: false);

    bool? value;
    if (valueStr == 'checked') value = true;
    if (valueStr == 'unchecked') value = false;
    if (valueStr == 'indeterminate') value = null;

    return Center(
      child: RdsCheckbox(
        value: value,
        disabled: disabled,
        readOnly: readOnly,
        error: error,
        onChanged: disabled || readOnly ? null : (_) {},
        semanticLabel: 'Playground checkbox',
      ),
    );
  },
);

// ---------------------------------------------------------------------------
// Gallery — all states in a grid
// ---------------------------------------------------------------------------

final _gallery = WidgetbookUseCase(
  name: 'Gallery',
  builder: (context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    final states = <String, Widget Function()>{
      'Unchecked': () => RdsCheckbox(value: false, onChanged: (_) {}),
      'Checked': () => RdsCheckbox(value: true, onChanged: (_) {}),
      'Indeterminate': () => RdsCheckbox(value: null, onChanged: (_) {}),
      'Error unchecked': () =>
          RdsCheckbox(value: false, error: true, onChanged: (_) {}),
      'Error checked': () =>
          RdsCheckbox(value: true, error: true, onChanged: (_) {}),
      'Read-only off': () => const RdsCheckbox(value: false, readOnly: true),
      'Read-only on': () => const RdsCheckbox(value: true, readOnly: true),
      'Disabled off': () => const RdsCheckbox(value: false, disabled: true),
      'Disabled on': () => const RdsCheckbox(value: true, disabled: true),
    };

    return Scaffold(
      backgroundColor: rds.surface,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(rds.space6),
        child: Wrap(
          spacing: rds.space6,
          runSpacing: rds.space6,
          children: states.entries
              .map(
                (e) => _LabeledTile(
                  label: e.key,
                  child: e.value(),
                  rds: rds,
                ),
              )
              .toList(),
        ),
      ),
    );
  },
);

// ---------------------------------------------------------------------------
// Shared utility
// ---------------------------------------------------------------------------

class _LabeledTile extends StatelessWidget {
  const _LabeledTile({
    required this.label,
    required this.child,
    required this.rds,
  });

  final String label;
  final Widget child;
  final RdsTheme rds;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        SizedBox(height: rds.space2),
        Text(
          label,
          style: rds.labelSmall.copyWith(color: rds.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
