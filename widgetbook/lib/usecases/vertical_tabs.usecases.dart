import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

// ---------------------------------------------------------------------------
// Demo data
// ---------------------------------------------------------------------------

const _mainItems = [
  RdsVerticalTabItem(label: 'Dashboard', icon: RdsIcons.info),
  RdsVerticalTabItem(label: 'Patients', icon: RdsIcons.user),
  RdsVerticalTabItem(label: 'Schedule', icon: RdsIcons.calendar),
  RdsVerticalTabItem(label: 'Reports', icon: RdsIcons.sort, badge: '3'),
  RdsVerticalTabItem(label: 'Disabled', icon: RdsIcons.error, disabled: true),
];

const _bottomItems = [
  RdsVerticalTabItem(label: 'Settings', icon: RdsIcons.settings),
];

// ---------------------------------------------------------------------------
// Widgetbook component
// ---------------------------------------------------------------------------

final verticalTabsComponent = WidgetbookComponent(
  name: 'Vertical Tabs',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final collapsed = context.knobs.boolean(
          label: 'Collapsed',
          initialValue: false,
        );
        final iconMode = context.knobs.list(
          label: 'Icon mode',
          options: RdsVerticalTabIconMode.values,
          initialOption: RdsVerticalTabIconMode.withLabels,
          labelBuilder: (v) => v.name,
        );
        final selectedIndex = context.knobs.int.input(
          label: 'Selected index',
          initialValue: 0,
        );

        final rds = Theme.of(context).extension<RdsTheme>()!;

        return Scaffold(
          backgroundColor: rds.surfaceVariant,
          body: Row(
            children: [
              RdsVerticalTabs(
                items: _mainItems,
                selectedIndex: selectedIndex.clamp(0, _mainItems.length - 1),
                onChanged: (_) {},
                iconMode: iconMode,
                collapsed: collapsed,
                dividerAfterIndices: const [3],
                bottomItems: _bottomItems,
                bottomSelectedIndex: null,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(rds.space6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Content area',
                        style: rds.headlineMedium.copyWith(color: rds.onSurface),
                      ),
                      SizedBox(height: rds.space2),
                      Text(
                        'Selected item: ${_mainItems[selectedIndex.clamp(0, _mainItems.length - 1)].label}',
                        style: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Gallery',
      builder: (context) => _VerticalTabsGallery(),
    ),
  ],
);

// ---------------------------------------------------------------------------
// Gallery widget
// ---------------------------------------------------------------------------

class _VerticalTabsGallery extends StatefulWidget {
  @override
  State<_VerticalTabsGallery> createState() => _VerticalTabsGalleryState();
}

class _VerticalTabsGalleryState extends State<_VerticalTabsGallery> {
  int _expandedSelected = 0;
  int _collapsedSelected = 1;
  int _labelsOnlySelected = 2;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(rds.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vertical Tabs — Gallery',
              style: rds.headlineMedium.copyWith(color: rds.onSurface),
            ),
            SizedBox(height: rds.space2),
            Text(
              'All modes: expanded, collapsed, labels only.',
              style: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
            ),
            SizedBox(height: rds.space6),

            // Row of three side-by-side nav strip previews
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _NavPreview(
                  title: 'Expanded (withLabels)',
                  child: RdsVerticalTabs(
                    items: _mainItems,
                    selectedIndex: _expandedSelected,
                    onChanged: (i) => setState(() => _expandedSelected = i),
                    iconMode: RdsVerticalTabIconMode.withLabels,
                    collapsed: false,
                    dividerAfterIndices: const [3],
                    bottomItems: _bottomItems,
                    bottomSelectedIndex: null,
                  ),
                ),
                SizedBox(width: rds.space6),
                _NavPreview(
                  title: 'Collapsed (iconOnly)',
                  child: RdsVerticalTabs(
                    items: _mainItems,
                    selectedIndex: _collapsedSelected,
                    onChanged: (i) => setState(() => _collapsedSelected = i),
                    iconMode: RdsVerticalTabIconMode.iconOnly,
                    collapsed: true,
                    dividerAfterIndices: const [3],
                    bottomItems: _bottomItems,
                    bottomSelectedIndex: null,
                  ),
                ),
                SizedBox(width: rds.space6),
                _NavPreview(
                  title: 'Labels only',
                  child: RdsVerticalTabs(
                    items: _mainItems,
                    selectedIndex: _labelsOnlySelected,
                    onChanged: (i) => setState(() => _labelsOnlySelected = i),
                    iconMode: RdsVerticalTabIconMode.labelsOnly,
                    collapsed: false,
                    dividerAfterIndices: const [3],
                    bottomItems: _bottomItems,
                    bottomSelectedIndex: null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NavPreview extends StatelessWidget {
  const _NavPreview({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
        ),
        SizedBox(height: rds.space2),
        SizedBox(
          height: 360,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(rds.radiusMd),
            child: child,
          ),
        ),
      ],
    );
  }
}
