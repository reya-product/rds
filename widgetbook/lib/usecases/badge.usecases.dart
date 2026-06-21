import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

final badgeComponent = WidgetbookComponent(
  name: 'Badge',
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
    initialValue: 'Badge',
  );
  final color = context.knobs.list<RdsBadgeColor>(
    label: 'Color',
    options: RdsBadgeColor.values,
    initialOption: RdsBadgeColor.teal,
    labelBuilder: (v) => v.name,
  );
  final size = context.knobs.list<RdsBadgeSize>(
    label: 'Size',
    options: RdsBadgeSize.values,
    initialOption: RdsBadgeSize.medium,
    labelBuilder: (v) => v.name,
  );
  final iconMode = context.knobs.list<RdsBadgeIconMode>(
    label: 'Icon mode',
    options: RdsBadgeIconMode.values,
    initialOption: RdsBadgeIconMode.none,
    labelBuilder: (v) => v.name,
  );

  return Scaffold(
    backgroundColor: rds.surface,
    body: Center(
      child: RdsBadge(
        label: label,
        color: color,
        size: size,
        iconMode: iconMode,
        icon: RdsIcons.check,
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
          // ---- All colors (medium size, no icon) ----
          Text('Colors — medium', style: rds.titleSmall.copyWith(color: rds.onSurface)),
          SizedBox(height: rds.space3),
          Wrap(
            spacing: rds.space2,
            runSpacing: rds.space2,
            children: RdsBadgeColor.values
                .map((c) => RdsBadge(
                      label: c.name,
                      color: c,
                      size: RdsBadgeSize.medium,
                    ))
                .toList(),
          ),

          SizedBox(height: rds.space6),

          // ---- Sizes ----
          Text('Sizes — neutral', style: rds.titleSmall.copyWith(color: rds.onSurface)),
          SizedBox(height: rds.space3),
          Wrap(
            spacing: rds.space2,
            runSpacing: rds.space2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: RdsBadgeSize.values
                .map((s) => RdsBadge(
                      label: s.name,
                      color: RdsBadgeColor.neutral,
                      size: s,
                    ))
                .toList(),
          ),

          SizedBox(height: rds.space6),

          // ---- Icon modes ----
          Text('Icon modes — blue, medium', style: rds.titleSmall.copyWith(color: rds.onSurface)),
          SizedBox(height: rds.space3),
          Wrap(
            spacing: rds.space2,
            runSpacing: rds.space2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              RdsBadge(
                label: 'No icon',
                color: RdsBadgeColor.blue,
                iconMode: RdsBadgeIconMode.none,
              ),
              RdsBadge(
                label: 'Leading icon',
                color: RdsBadgeColor.blue,
                iconMode: RdsBadgeIconMode.leading,
                icon: RdsIcons.check,
              ),
              RdsBadge(
                label: 'Icon only',
                color: RdsBadgeColor.blue,
                iconMode: RdsBadgeIconMode.iconOnly,
                icon: RdsIcons.info,
              ),
            ],
          ),

          SizedBox(height: rds.space6),

          // ---- Semantic colors all sizes ----
          Text('Semantic — all sizes', style: rds.titleSmall.copyWith(color: rds.onSurface)),
          SizedBox(height: rds.space3),
          for (final c in [RdsBadgeColor.danger, RdsBadgeColor.warning, RdsBadgeColor.success]) ...[
            Wrap(
              spacing: rds.space2,
              runSpacing: rds.space2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: RdsBadgeSize.values
                  .map((s) => RdsBadge(label: c.name, color: c, size: s))
                  .toList(),
            ),
            SizedBox(height: rds.space2),
          ],
        ],
      ),
    ),
  );
}
