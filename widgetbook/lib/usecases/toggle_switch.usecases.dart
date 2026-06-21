import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

/// Top-level [WidgetbookComponent] for the Toggle Switch.
/// Register this in T1 Atoms in [main.dart]:
///   `toggleSwitchComponent`
final toggleSwitchComponent = WidgetbookComponent(
  name: 'Toggle Switch',
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
    final value =
        context.knobs.boolean(label: 'On', initialValue: false);
    final disabled =
        context.knobs.boolean(label: 'Disabled', initialValue: false);
    final readOnly =
        context.knobs.boolean(label: 'Read Only', initialValue: false);

    return Center(
      child: RdsToggleSwitch(
        value: value,
        disabled: disabled,
        readOnly: readOnly,
        onChanged: disabled || readOnly ? null : (_) {},
        semanticLabel: 'Playground toggle',
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
      'Off': () =>
          RdsToggleSwitch(value: false, onChanged: (_) {}),
      'On': () =>
          RdsToggleSwitch(value: true, onChanged: (_) {}),
      'Read-only off': () => const RdsToggleSwitch(value: false, readOnly: true),
      'Read-only on': () => const RdsToggleSwitch(value: true, readOnly: true),
      'Disabled off': () =>
          const RdsToggleSwitch(value: false, disabled: true),
      'Disabled on': () =>
          const RdsToggleSwitch(value: true, disabled: true),
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
