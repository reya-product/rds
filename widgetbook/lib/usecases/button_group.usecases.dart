import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

final buttonGroupComponent = WidgetbookComponent(
  name: 'Button Group',
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
    options: RdsButtonGroupSelectionMode.values,
    initialOption: RdsButtonGroupSelectionMode.single,
    labelBuilder: (v) => v.name,
  );
  final size = context.knobs.list(
    label: 'Size',
    options: RdsButtonSize.values,
    initialOption: RdsButtonSize.medium,
    labelBuilder: (v) => v.name,
  );
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );
  final showIcons = context.knobs.boolean(
    label: 'Show icons',
    initialValue: false,
  );

  // StatefulBuilder lets us manage selection state within the use case
  return Scaffold(
    backgroundColor: rds.surface,
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(rds.space6),
        child: _StatefulButtonGroup(
          selectionMode: selectionMode,
          size: size,
          disabled: disabled,
          showIcons: showIcons,
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
            'Button Group Gallery',
            style: rds.headlineMedium.copyWith(color: rds.onSurface),
          ),
          SizedBox(height: rds.space6),

          // No selection mode
          Text(
            'Selection mode: none (plain actions)',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          RdsButtonGroup(
            items: const [
              RdsButtonGroupItem(
                label: 'Copy',
                icon: RdsIcons.add,
                iconPosition: RdsButtonIconPosition.leading,
              ),
              RdsButtonGroupItem(
                label: 'Paste',
                icon: RdsIcons.edit,
                iconPosition: RdsButtonIconPosition.leading,
              ),
              RdsButtonGroupItem(
                label: 'Delete',
                icon: RdsIcons.delete,
                iconPosition: RdsButtonIconPosition.leading,
              ),
            ],
          ),
          SizedBox(height: rds.space6),

          // Single select
          Text(
            'Selection mode: single',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          _StatefulButtonGroup(
            selectionMode: RdsButtonGroupSelectionMode.single,
            size: RdsButtonSize.medium,
            disabled: false,
            showIcons: false,
          ),
          SizedBox(height: rds.space6),

          // Multi select
          Text(
            'Selection mode: multi',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          _StatefulButtonGroup(
            selectionMode: RdsButtonGroupSelectionMode.multi,
            size: RdsButtonSize.medium,
            disabled: false,
            showIcons: false,
          ),
          SizedBox(height: rds.space6),

          // Sizes
          Text(
            'Sizes',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          for (final size in RdsButtonSize.values) ...[
            Padding(
              padding: EdgeInsets.only(bottom: rds.space3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      size.name,
                      style: rds.bodySmall.copyWith(color: rds.onSurfaceMuted),
                    ),
                  ),
                  RdsButtonGroup(
                    size: size,
                    selectionMode: RdsButtonGroupSelectionMode.single,
                    selected: const {0},
                    items: const [
                      RdsButtonGroupItem(label: 'Day'),
                      RdsButtonGroupItem(label: 'Week'),
                      RdsButtonGroupItem(label: 'Month'),
                    ],
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: rds.space6),

          // Disabled
          Text(
            'Disabled',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          RdsButtonGroup(
            disabled: true,
            selectionMode: RdsButtonGroupSelectionMode.single,
            selected: const {1},
            items: const [
              RdsButtonGroupItem(label: 'Day'),
              RdsButtonGroupItem(label: 'Week'),
              RdsButtonGroupItem(label: 'Month'),
            ],
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Stateful helper for interactive demos
// ---------------------------------------------------------------------------

class _StatefulButtonGroup extends StatefulWidget {
  const _StatefulButtonGroup({
    required this.selectionMode,
    required this.size,
    required this.disabled,
    required this.showIcons,
  });

  final RdsButtonGroupSelectionMode selectionMode;
  final RdsButtonSize size;
  final bool disabled;
  final bool showIcons;

  @override
  State<_StatefulButtonGroup> createState() => _StatefulButtonGroupState();
}

class _StatefulButtonGroupState extends State<_StatefulButtonGroup> {
  Set<int> _selected = {0};

  List<RdsButtonGroupItem> get _items => [
        RdsButtonGroupItem(
          label: 'Day',
          icon: widget.showIcons ? RdsIcons.calendar : null,
          iconPosition:
              widget.showIcons ? RdsButtonIconPosition.leading : RdsButtonIconPosition.none,
        ),
        RdsButtonGroupItem(
          label: 'Week',
          icon: widget.showIcons ? RdsIcons.calendar : null,
          iconPosition:
              widget.showIcons ? RdsButtonIconPosition.leading : RdsButtonIconPosition.none,
        ),
        RdsButtonGroupItem(
          label: 'Month',
          icon: widget.showIcons ? RdsIcons.calendar : null,
          iconPosition:
              widget.showIcons ? RdsButtonIconPosition.leading : RdsButtonIconPosition.none,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return RdsButtonGroup(
      items: _items,
      selectionMode: widget.selectionMode,
      selected: _selected,
      size: widget.size,
      disabled: widget.disabled,
      onSelectionChanged: (next) => setState(() => _selected = next),
    );
  }
}
