import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

final tooltipComponent = WidgetbookComponent(
  name: 'Tooltip',
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

  final message = context.knobs.string(
    label: 'Message',
    initialValue: 'Hover or long-press me',
  );
  final placement = context.knobs.list<RdsTooltipPlacement>(
    label: 'Placement',
    options: RdsTooltipPlacement.values,
    initialOption: RdsTooltipPlacement.top,
    labelBuilder: (v) => v.name,
  );
  final trigger = context.knobs.list<RdsTooltipTrigger>(
    label: 'Trigger',
    options: RdsTooltipTrigger.values,
    initialOption: RdsTooltipTrigger.hover,
    labelBuilder: (v) => v.name,
  );
  final waitMs = context.knobs.double.input(
    label: 'Wait duration (ms)',
    initialValue: 500,
  );

  return Scaffold(
    backgroundColor: rds.surface,
    body: Center(
      child: RdsTooltip(
        message: message,
        placement: placement,
        trigger: trigger,
        waitDuration: Duration(milliseconds: waitMs.toInt()),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: rds.space4,
            vertical: rds.space3,
          ),
          decoration: BoxDecoration(
            color: rds.primaryContainer,
            borderRadius: BorderRadius.circular(rds.radiusMd),
          ),
          child: Text(
            'Tooltip target',
            style: rds.labelMedium.copyWith(color: rds.onPrimaryContainer),
          ),
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

  const placements = [
    RdsTooltipPlacement.top,
    RdsTooltipPlacement.bottom,
    RdsTooltipPlacement.left,
    RdsTooltipPlacement.right,
    RdsTooltipPlacement.topStart,
    RdsTooltipPlacement.topEnd,
    RdsTooltipPlacement.bottomStart,
    RdsTooltipPlacement.bottomEnd,
  ];

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All placements — hover or long-press each target',
            style: rds.titleSmall.copyWith(color: rds.onSurface),
          ),
          SizedBox(height: rds.space4),
          Wrap(
            spacing: rds.space4,
            runSpacing: rds.space6,
            children: placements
                .map((p) => _PlacementDemo(placement: p, rds: rds))
                .toList(),
          ),
          SizedBox(height: rds.space8),
          Text('Trigger modes', style: rds.titleSmall.copyWith(color: rds.onSurface)),
          SizedBox(height: rds.space4),
          Wrap(
            spacing: rds.space4,
            runSpacing: rds.space4,
            children: RdsTooltipTrigger.values
                .map((t) => RdsTooltip(
                      message: '${t.name} trigger',
                      trigger: t,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: rds.space4,
                          vertical: rds.space2,
                        ),
                        decoration: BoxDecoration(
                          color: rds.surfaceContainer,
                          borderRadius: BorderRadius.circular(rds.radiusMd),
                          border: Border.all(color: rds.outline),
                        ),
                        child: Text(
                          t.name,
                          style: rds.labelMedium.copyWith(color: rds.onSurface),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    ),
  );
}

class _PlacementDemo extends StatelessWidget {
  final RdsTooltipPlacement placement;
  final RdsTheme rds;

  const _PlacementDemo({required this.placement, required this.rds});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RdsTooltip(
          message: placement.name,
          placement: placement,
          child: Container(
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: rds.primaryContainer,
              borderRadius: BorderRadius.circular(rds.radiusMd),
            ),
            alignment: Alignment.center,
            child: Text(
              placement.name,
              style: rds.labelSmall.copyWith(color: rds.onPrimaryContainer),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
