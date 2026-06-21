import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

// ---------------------------------------------------------------------------
// Demo data
// ---------------------------------------------------------------------------

const _demoTabs = [
  RdsTabItem(label: 'Overview', icon: RdsIcons.user),
  RdsTabItem(label: 'Lab Results', icon: RdsIcons.info),
  RdsTabItem(label: 'Schedule', icon: RdsIcons.calendar),
  RdsTabItem(label: 'Notes', icon: RdsIcons.edit),
  RdsTabItem(label: 'Disabled', icon: RdsIcons.error, disabled: true),
];

// ---------------------------------------------------------------------------
// Widgetbook component
// ---------------------------------------------------------------------------

final tabsComponent = WidgetbookComponent(
  name: 'Tabs',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final variant = context.knobs.list(
          label: 'Variant',
          options: RdsTabVariant.values,
          initialOption: RdsTabVariant.primary,
          labelBuilder: (v) => v.name,
        );
        final iconMode = context.knobs.list(
          label: 'Icon mode',
          options: RdsTabIconMode.values,
          initialOption: RdsTabIconMode.none,
          labelBuilder: (v) => v.name,
        );
        final selectedIndex = context.knobs.int.input(
          label: 'Selected index',
          initialValue: 0,
        );

        final rds = Theme.of(context).extension<RdsTheme>()!;

        return Scaffold(
          backgroundColor: rds.surface,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RdsTabs(
                tabs: _demoTabs,
                selectedIndex: selectedIndex.clamp(0, _demoTabs.length - 1),
                onChanged: (_) {},
                variant: variant,
                iconMode: iconMode,
              ),
              SizedBox(height: rds.space6),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: rds.space6),
                child: Text(
                  'Tab ${selectedIndex.clamp(0, _demoTabs.length - 1) + 1} content area',
                  style: rds.bodyLarge.copyWith(color: rds.onSurface),
                ),
              ),
            ],
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Gallery',
      builder: (context) => _TabsGallery(),
    ),
  ],
);

// ---------------------------------------------------------------------------
// Gallery widget
// ---------------------------------------------------------------------------

class _TabsGallery extends StatefulWidget {
  @override
  State<_TabsGallery> createState() => _TabsGalleryState();
}

class _TabsGalleryState extends State<_TabsGallery> {
  int _primarySelected = 0;
  int _secondarySelected = 0;
  int _primaryIconSelected = 0;
  int _secondaryIconSelected = 0;
  int _primaryIconOnlySelected = 0;
  int _secondaryIconOnlySelected = 0;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    final sections = [
      _GallerySection(
        title: 'Primary — labels only',
        child: RdsTabs(
          tabs: _demoTabs,
          selectedIndex: _primarySelected,
          onChanged: (i) => setState(() => _primarySelected = i),
          variant: RdsTabVariant.primary,
          iconMode: RdsTabIconMode.none,
        ),
      ),
      _GallerySection(
        title: 'Primary — leading icons',
        child: RdsTabs(
          tabs: _demoTabs,
          selectedIndex: _primaryIconSelected,
          onChanged: (i) => setState(() => _primaryIconSelected = i),
          variant: RdsTabVariant.primary,
          iconMode: RdsTabIconMode.leading,
        ),
      ),
      _GallerySection(
        title: 'Primary — icon only',
        child: RdsTabs(
          tabs: _demoTabs,
          selectedIndex: _primaryIconOnlySelected,
          onChanged: (i) => setState(() => _primaryIconOnlySelected = i),
          variant: RdsTabVariant.primary,
          iconMode: RdsTabIconMode.iconOnly,
        ),
      ),
      _GallerySection(
        title: 'Secondary — labels only',
        child: RdsTabs(
          tabs: _demoTabs,
          selectedIndex: _secondarySelected,
          onChanged: (i) => setState(() => _secondarySelected = i),
          variant: RdsTabVariant.secondary,
          iconMode: RdsTabIconMode.none,
        ),
      ),
      _GallerySection(
        title: 'Secondary — leading icons',
        child: RdsTabs(
          tabs: _demoTabs,
          selectedIndex: _secondaryIconSelected,
          onChanged: (i) => setState(() => _secondaryIconSelected = i),
          variant: RdsTabVariant.secondary,
          iconMode: RdsTabIconMode.leading,
        ),
      ),
      _GallerySection(
        title: 'Secondary — icon only',
        child: RdsTabs(
          tabs: _demoTabs,
          selectedIndex: _secondaryIconOnlySelected,
          onChanged: (i) => setState(() => _secondaryIconOnlySelected = i),
          variant: RdsTabVariant.secondary,
          iconMode: RdsTabIconMode.iconOnly,
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(rds.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tabs — Gallery',
              style: rds.headlineMedium.copyWith(color: rds.onSurface),
            ),
            SizedBox(height: rds.space2),
            Text(
              'All variants and icon modes. Tap tabs to see selection state.',
              style: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
            ),
            SizedBox(height: rds.space6),
            ...sections,
          ],
        ),
      ),
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Padding(
      padding: EdgeInsets.only(bottom: rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space2),
          Container(
            decoration: BoxDecoration(
              color: rds.surface,
              borderRadius: BorderRadius.circular(rds.radiusMd),
              border: Border.all(color: rds.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: child,
          ),
        ],
      ),
    );
  }
}
