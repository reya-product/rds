import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

final listComponent = WidgetbookComponent(
  name: 'List',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _playground),
    WidgetbookUseCase(name: 'With dividers', builder: _withDividers),
    WidgetbookUseCase(name: 'Compact density', builder: _compactDensity),
    WidgetbookUseCase(name: 'All leading types', builder: _allLeadingTypes),
  ],
);

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _listCard({
  required BuildContext context,
  required Widget child,
}) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  return Card(
    elevation: 0,
    color: rds.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(rds.radiusMd),
      side: BorderSide(color: rds.outlineVariant),
    ),
    clipBehavior: Clip.antiAlias,
    child: child,
  );
}

List<RdsListItem> _buildDoctorItems({bool withTap = true}) {
  const doctors = [
    ('Dr. Sarah Chen', 'General Practice'),
    ('Dr. Marcus Lee', 'Cardiology'),
    ('Dr. Aisha Patel', 'Dermatology'),
    ('Dr. James Wright', 'Neurology'),
    ('Dr. Fatima Al-Rashid', 'Endocrinology'),
  ];
  return doctors
      .map(
        (d) => RdsListItem(
          primaryText: d.$1,
          supportingText: d.$2,
          leading: RdsListItemLeading.avatar,
          leadingAvatar: RdsAvatarConfig(
            type: RdsAvatarType.initials,
            name: d.$1,
          ),
          trailing: RdsListItemTrailing.icon,
          trailingIcon: RdsIcons.chevronRight,
          onTap: withTap ? () {} : null,
        ),
      )
      .toList();
}

// ---------------------------------------------------------------------------
// Playground
// ---------------------------------------------------------------------------

Widget _playground(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final showDividers = context.knobs.boolean(
    label: 'Show dividers',
    initialValue: false,
  );
  final density = context.knobs.list<RdsListDensity>(
    label: 'Density',
    options: RdsListDensity.values,
    initialOption: RdsListDensity.comfortable,
    labelBuilder: (v) => v.name,
  );

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'List',
            style: rds.titleSmall.copyWith(color: rds.onSurface),
          ),
          SizedBox(height: rds.space3),
          _listCard(
            context: context,
            child: RdsList(
              items: _buildDoctorItems(),
              showDividers: showDividers,
              density: density,
            ),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// With dividers
// ---------------------------------------------------------------------------

Widget _withDividers(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'With dividers',
            style: rds.titleSmall.copyWith(color: rds.onSurface),
          ),
          SizedBox(height: rds.space1),
          Text(
            'showDividers: true',
            style: rds.labelSmall.copyWith(color: rds.onSurfaceMuted),
          ),
          SizedBox(height: rds.space3),
          _listCard(
            context: context,
            child: RdsList(
              showDividers: true,
              items: _buildDoctorItems(),
            ),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Compact density
// ---------------------------------------------------------------------------

Widget _compactDensity(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compact density',
            style: rds.titleSmall.copyWith(color: rds.onSurface),
          ),
          SizedBox(height: rds.space1),
          Text(
            'density: RdsListDensity.compact',
            style: rds.labelSmall.copyWith(color: rds.onSurfaceMuted),
          ),
          SizedBox(height: rds.space3),
          _listCard(
            context: context,
            child: RdsList(
              showDividers: true,
              density: RdsListDensity.compact,
              items: _buildDoctorItems(),
            ),
          ),
          SizedBox(height: rds.space6),
          Text(
            'Comfortable density (default) for comparison',
            style: rds.labelSmall.copyWith(color: rds.onSurfaceMuted),
          ),
          SizedBox(height: rds.space3),
          _listCard(
            context: context,
            child: RdsList(
              showDividers: true,
              items: _buildDoctorItems(),
            ),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// All leading types
// ---------------------------------------------------------------------------

Widget _allLeadingTypes(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final items = [
    RdsListItem(
      primaryText: 'No leading',
      supportingText: 'RdsListItemLeading.none',
      leading: RdsListItemLeading.none,
      trailing: RdsListItemTrailing.icon,
      trailingIcon: RdsIcons.chevronRight,
      onTap: () {},
    ),
    RdsListItem(
      primaryText: 'Icon leading',
      supportingText: 'RdsListItemLeading.icon',
      leading: RdsListItemLeading.icon,
      leadingIcon: RdsIcons.user,
      trailing: RdsListItemTrailing.icon,
      trailingIcon: RdsIcons.chevronRight,
      onTap: () {},
    ),
    RdsListItem(
      primaryText: 'Avatar leading',
      supportingText: 'RdsListItemLeading.avatar',
      leading: RdsListItemLeading.avatar,
      leadingAvatar: const RdsAvatarConfig(
        type: RdsAvatarType.initials,
        name: 'Aisha Patel',
      ),
      trailing: RdsListItemTrailing.icon,
      trailingIcon: RdsIcons.chevronRight,
      onTap: () {},
    ),
    RdsListItem(
      primaryText: 'Checkbox leading',
      supportingText: 'RdsListItemLeading.checkbox',
      leading: RdsListItemLeading.checkbox,
      checkboxValue: true,
      onCheckboxChanged: (_) {},
      onTap: () {},
    ),
    RdsListItem(
      primaryText: 'Radio leading',
      supportingText: 'RdsListItemLeading.radio',
      leading: RdsListItemLeading.radio,
      radioValue: 'option',
      radioGroupValue: 'option',
      onRadioChanged: (_) {},
      onTap: () {},
    ),
    RdsListItem(
      primaryText: 'Toggle leading',
      supportingText: 'RdsListItemLeading.toggle',
      leading: RdsListItemLeading.toggle,
      toggleValue: true,
      onToggleChanged: (_) {},
      onTap: () {},
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
            'All leading types',
            style: rds.titleSmall.copyWith(color: rds.onSurface),
          ),
          SizedBox(height: rds.space1),
          Text(
            'Six items, one per RdsListItemLeading value',
            style: rds.labelSmall.copyWith(color: rds.onSurfaceMuted),
          ),
          SizedBox(height: rds.space3),
          _listCard(
            context: context,
            child: RdsList(
              showDividers: true,
              items: items,
            ),
          ),
        ],
      ),
    ),
  );
}
