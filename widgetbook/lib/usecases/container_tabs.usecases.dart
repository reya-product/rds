import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:material_symbols_icons/symbols.dart';

final containerTabsComponent = WidgetbookComponent(
  name: 'Container Tabs',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => _ContainerTabsDemo(
        iconMode: context.knobs.list(
          label: 'Icon mode',
          options: RdsTabIconMode.values,
          labelBuilder: (v) => v.name,
          initialOption: RdsTabIconMode.none,
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Many tabs (scrollable)',
      builder: (context) => _ContainerTabsManyDemo(),
    ),
    WidgetbookUseCase(
      name: 'With disabled tab',
      builder: (context) => _ContainerTabsDisabledDemo(),
    ),
  ],
);

class _ContainerTabsDemo extends StatefulWidget {
  const _ContainerTabsDemo({required this.iconMode});
  final RdsTabIconMode iconMode;

  @override
  State<_ContainerTabsDemo> createState() => _ContainerTabsDemoState();
}

class _ContainerTabsDemoState extends State<_ContainerTabsDemo> {
  int _index = 0;

  static const _tabs = [
    RdsTabItem(label: 'Overview', icon: Symbols.dashboard),
    RdsTabItem(label: 'Membership', icon: Symbols.group),
    RdsTabItem(label: 'Pmt & Gift Cards', icon: Symbols.credit_card),
    RdsTabItem(label: 'Team', icon: Symbols.people),
  ];

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Padding(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RdsContainerTabs(
            tabs: _tabs,
            selectedIndex: _index,
            onChanged: (i) => setState(() => _index = i),
            iconMode: widget.iconMode,
          ),
          SizedBox(height: rds.space4),
          Text(
            'Selected: ${_tabs[_index].label}',
            style: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _ContainerTabsManyDemo extends StatefulWidget {
  @override
  State<_ContainerTabsManyDemo> createState() => _ContainerTabsManyDemoState();
}

class _ContainerTabsManyDemoState extends State<_ContainerTabsManyDemo> {
  int _index = 0;

  static const _tabs = [
    RdsTabItem(label: 'Overview'),
    RdsTabItem(label: 'Membership'),
    RdsTabItem(label: 'Pmt & Gift Cards'),
    RdsTabItem(label: 'Team'),
    RdsTabItem(label: 'Analytics'),
    RdsTabItem(label: 'Settings'),
    RdsTabItem(label: 'Audit Log'),
  ];

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Padding(
      padding: EdgeInsets.all(rds.space6),
      child: RdsContainerTabs(
        tabs: _tabs,
        selectedIndex: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _ContainerTabsDisabledDemo extends StatefulWidget {
  @override
  State<_ContainerTabsDisabledDemo> createState() =>
      _ContainerTabsDisabledDemoState();
}

class _ContainerTabsDisabledDemoState
    extends State<_ContainerTabsDisabledDemo> {
  int _index = 0;

  static const _tabs = [
    RdsTabItem(label: 'Overview'),
    RdsTabItem(label: 'Membership'),
    RdsTabItem(label: 'Restricted', disabled: true),
    RdsTabItem(label: 'Team'),
  ];

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Padding(
      padding: EdgeInsets.all(rds.space6),
      child: RdsContainerTabs(
        tabs: _tabs,
        selectedIndex: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}
