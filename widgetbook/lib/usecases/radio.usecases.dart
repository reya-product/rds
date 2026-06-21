import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

/// Top-level [WidgetbookComponent] for the Radio button.
/// Register this in T1 Atoms in [main.dart]:
///   `radioComponent`
final radioComponent = WidgetbookComponent(
  name: 'Radio',
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
    final selected =
        context.knobs.boolean(label: 'Selected', initialValue: false);
    final disabled =
        context.knobs.boolean(label: 'Disabled', initialValue: false);
    final readOnly =
        context.knobs.boolean(label: 'Read Only', initialValue: false);
    final error =
        context.knobs.boolean(label: 'Error', initialValue: false);

    return Center(
      child: RdsRadio<String>(
        value: 'option_a',
        groupValue: selected ? 'option_a' : 'option_b',
        disabled: disabled,
        readOnly: readOnly,
        error: error,
        onChanged: disabled || readOnly ? null : (_) {},
        semanticLabel: 'Playground radio',
      ),
    );
  },
);

// ---------------------------------------------------------------------------
// Gallery — all states
// ---------------------------------------------------------------------------

final _gallery = WidgetbookUseCase(
  name: 'Gallery',
  builder: (context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    final states = <String, Widget Function()>{
      'Unselected': () => RdsRadio<String>(
            value: 'a',
            groupValue: 'b',
            onChanged: (_) {},
          ),
      'Selected': () => RdsRadio<String>(
            value: 'a',
            groupValue: 'a',
            onChanged: (_) {},
          ),
      'Error unselected': () => RdsRadio<String>(
            value: 'a',
            groupValue: 'b',
            error: true,
            onChanged: (_) {},
          ),
      'Error selected': () => RdsRadio<String>(
            value: 'a',
            groupValue: 'a',
            error: true,
            onChanged: (_) {},
          ),
      'Read-only off': () => const RdsRadio<String>(
            value: 'a',
            groupValue: 'b',
            readOnly: true,
          ),
      'Read-only on': () => const RdsRadio<String>(
            value: 'a',
            groupValue: 'a',
            readOnly: true,
          ),
      'Disabled off': () => const RdsRadio<String>(
            value: 'a',
            groupValue: 'b',
            disabled: true,
          ),
      'Disabled on': () => const RdsRadio<String>(
            value: 'a',
            groupValue: 'a',
            disabled: true,
          ),
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
