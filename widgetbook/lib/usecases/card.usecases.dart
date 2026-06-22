import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

final cardComponent = WidgetbookComponent(
  name: 'Card',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _playground),
    WidgetbookUseCase(name: 'Patient summary card', builder: _patientSummaryCard),
    WidgetbookUseCase(name: 'Metric card', builder: _metricCard),
    WidgetbookUseCase(name: 'Image card', builder: _imageCard),
    WidgetbookUseCase(name: 'Gallery', builder: _gallery),
  ],
);

// ---------------------------------------------------------------------------
// Playground
// ---------------------------------------------------------------------------

Widget _playground(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final elevation = context.knobs.list<RdsCardElevation>(
    label: 'Elevation',
    options: RdsCardElevation.values,
    initialOption: RdsCardElevation.low,
    labelBuilder: (v) => v.name,
  );
  final outlined = context.knobs.boolean(
    label: 'Outlined',
    initialValue: true,
  );
  final onTapEnabled = context.knobs.boolean(
    label: 'onTap enabled',
    initialValue: false,
  );
  final selected = context.knobs.boolean(
    label: 'Selected',
    initialValue: false,
  );
  final bodyType = context.knobs.list<RdsCardBodyType>(
    label: 'Body type',
    options: RdsCardBodyType.values,
    initialOption: RdsCardBodyType.listItems,
    labelBuilder: (v) => v.name,
  );
  final headerLeading = context.knobs.list<RdsCardHeaderLeading>(
    label: 'Header leading',
    options: RdsCardHeaderLeading.values,
    initialOption: RdsCardHeaderLeading.avatar,
    labelBuilder: (v) => v.name,
  );
  final headerTrailing = context.knobs.list<RdsCardHeaderTrailing>(
    label: 'Header trailing',
    options: RdsCardHeaderTrailing.values,
    initialOption: RdsCardHeaderTrailing.iconButton,
    labelBuilder: (v) => v.name,
  );

  return StatefulBuilder(
    builder: (context, setState) {
      return Scaffold(
        backgroundColor: rds.surfaceVariant,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(rds.space6),
          child: RdsCard(
            elevation: elevation,
            outlined: outlined,
            onTap: onTapEnabled ? () {} : null,
            selected: selected,
            headerLeading: headerLeading,
            headerLeadingAvatar: const RdsAvatarConfig(
              type: RdsAvatarType.initials,
              name: 'Jane Doe',
            ),
            headerLeadingBadge: const RdsBadgeConfig(
              label: 'Active',
              color: RdsBadgeColor.teal,
            ),
            headerPrimaryText: 'Card title',
            headerSecondaryText: 'Supporting subtitle text',
            headerTrailing: headerTrailing,
            headerTrailingBadge: const RdsBadgeConfig(
              label: 'New',
              color: RdsBadgeColor.blue,
            ),
            headerTrailingIcon: RdsIcons.more,
            onHeaderTrailingTap: () {},
            bodyType: bodyType,
            bodyItems: [
              const RdsListItem(
                primaryText: 'Heart rate',
                supportingText: '72 bpm · Normal',
                leading: RdsListItemLeading.icon,
                leadingIcon: RdsIcons.info,
              ),
              const RdsListItem(
                primaryText: 'Blood pressure',
                supportingText: '120 / 80 mmHg',
                leading: RdsListItemLeading.icon,
                leadingIcon: RdsIcons.info,
              ),
              const RdsListItem(
                primaryText: 'Blood glucose',
                supportingText: '5.4 mmol/L · Normal',
                leading: RdsListItemLeading.icon,
                leadingIcon: RdsIcons.info,
              ),
            ],
            bodyImageUrl:
                'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800',
            bodyImageHeight: 200,
            footerActions: [
              RdsCardAction(
                label: 'View details',
                icon: RdsIcons.eye,
                onPressed: () {},
              ),
              RdsCardAction(
                label: 'Edit',
                icon: RdsIcons.edit,
                onPressed: () {},
              ),
            ],
          ),
        ),
      );
    },
  );
}

// ---------------------------------------------------------------------------
// Patient summary card
// ---------------------------------------------------------------------------

Widget _patientSummaryCard(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: RdsCard(
        elevation: RdsCardElevation.low,
        outlined: true,
        // Header
        headerLeading: RdsCardHeaderLeading.avatar,
        headerLeadingAvatar: const RdsAvatarConfig(
          type: RdsAvatarType.initials,
          name: 'Sarah Mitchell',
          size: RdsAvatarSize.md,
        ),
        headerPrimaryText: 'Sarah Mitchell',
        headerSecondaryText: 'Patient · Age 42 · F',
        headerTrailing: RdsCardHeaderTrailing.iconButton,
        headerTrailingIcon: RdsIcons.more,
        onHeaderTrailingTap: () {},
        // Body — vitals list
        bodyType: RdsCardBodyType.listItems,
        bodyItems: [
          RdsListItem(
            overline: 'CARDIOVASCULAR',
            primaryText: 'Heart rate',
            supportingText: '72 bpm · Resting',
            leading: RdsListItemLeading.icon,
            leadingIcon: RdsIcons.success,
            trailing: RdsListItemTrailing.icon,
            trailingIcon: RdsIcons.chevronRight,
            onTap: () {},
          ),
          RdsListItem(
            overline: 'CARDIOVASCULAR',
            primaryText: 'Blood pressure',
            supportingText: '128 / 82 mmHg · Slightly elevated',
            leading: RdsListItemLeading.icon,
            leadingIcon: RdsIcons.warning,
            trailing: RdsListItemTrailing.icon,
            trailingIcon: RdsIcons.chevronRight,
            onTap: () {},
          ),
          RdsListItem(
            overline: 'METABOLIC',
            primaryText: 'Blood glucose (fasting)',
            supportingText: '5.1 mmol/L · Normal',
            leading: RdsListItemLeading.icon,
            leadingIcon: RdsIcons.success,
            trailing: RdsListItemTrailing.icon,
            trailingIcon: RdsIcons.chevronRight,
            onTap: () {},
          ),
        ],
        // Footer — actions
        footerActions: [
          RdsCardAction(
            label: 'View details',
            icon: RdsIcons.eye,
            variant: RdsButtonVariant.text,
            onPressed: () {},
          ),
          RdsCardAction(
            label: 'Message',
            icon: RdsIcons.notification,
            variant: RdsButtonVariant.text,
            onPressed: () {},
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Metric card
// ---------------------------------------------------------------------------

Widget _metricCard(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: Center(
      padding: EdgeInsets.all(rds.space6),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: RdsCard(
          elevation: RdsCardElevation.low,
          outlined: true,
          // No header — metric displayed in body
          bodyContent: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '98.4°F',
                style: rds.displaySmall.copyWith(color: rds.onSurface),
              ),
              SizedBox(height: rds.space1),
              Text(
                'Body Temperature',
                style: rds.bodySmall.copyWith(color: rds.onSurfaceVariant),
              ),
              SizedBox(height: rds.space3),
              RdsBadge(
                label: 'Normal',
                color: RdsBadgeColor.success,
                size: RdsBadgeSize.medium,
              ),
            ],
          ),
          footerActions: [
            RdsCardAction(
              label: 'View history',
              icon: RdsIcons.arrowDown,
              variant: RdsButtonVariant.text,
              onPressed: () {},
            ),
          ],
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Image card
// ---------------------------------------------------------------------------

Widget _imageCard(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: RdsCard(
        elevation: RdsCardElevation.low,
        outlined: true,
        // Header
        headerPrimaryText: 'Longevity Clinic — San Francisco',
        headerSecondaryText: 'Facility overview',
        headerTrailing: RdsCardHeaderTrailing.badge,
        headerTrailingBadge: const RdsBadgeConfig(
          label: 'Open',
          color: RdsBadgeColor.success,
        ),
        // Body — full-bleed image
        bodyType: RdsCardBodyType.image,
        bodyImageUrl:
            'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=800',
        bodyImageHeight: 220,
        // Footer
        footerActions: [
          RdsCardAction(
            label: 'View location',
            icon: RdsIcons.search,
            variant: RdsButtonVariant.text,
            onPressed: () {},
          ),
          RdsCardAction(
            label: 'Book visit',
            icon: RdsIcons.calendar,
            variant: RdsButtonVariant.tonal,
            onPressed: () {},
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Gallery
// ---------------------------------------------------------------------------

Widget _gallery(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final items = <({String label, RdsCard card})>[
    (
      label: 'Elevated (no outline)',
      card: RdsCard(
        elevation: RdsCardElevation.medium,
        outlined: false,
        headerPrimaryText: 'Elevated card',
        headerSecondaryText: 'shadow-md, no border',
        bodyItems: [
          const RdsListItem(primaryText: 'Data row one', supportingText: 'Details here'),
          const RdsListItem(primaryText: 'Data row two', supportingText: 'More details'),
        ],
        footerActions: [
          RdsCardAction(
            label: 'Action',
            variant: RdsButtonVariant.text,
            onPressed: () {},
          ),
        ],
      ),
    ),
    (
      label: 'Outlined flat',
      card: RdsCard(
        elevation: RdsCardElevation.none,
        outlined: true,
        headerPrimaryText: 'Flat outlined card',
        headerSecondaryText: 'No shadow, 1px border',
        bodyItems: [
          const RdsListItem(primaryText: 'Data row one', supportingText: 'Details here'),
          const RdsListItem(primaryText: 'Data row two', supportingText: 'More details'),
        ],
        footerActions: [
          RdsCardAction(
            label: 'Action',
            variant: RdsButtonVariant.text,
            onPressed: () {},
          ),
        ],
      ),
    ),
    (
      label: 'Selected',
      card: RdsCard(
        elevation: RdsCardElevation.low,
        outlined: true,
        selected: true,
        headerLeading: RdsCardHeaderLeading.avatar,
        headerLeadingAvatar: const RdsAvatarConfig(
          type: RdsAvatarType.initials,
          name: 'Alex Kim',
        ),
        headerPrimaryText: 'Selected card',
        headerSecondaryText: 'primaryContainer background',
        bodyItems: [
          const RdsListItem(
            primaryText: 'Selected state active',
            supportingText: 'Background tinted with primaryContainer',
          ),
        ],
        footerActions: [
          RdsCardAction(
            label: 'Action',
            variant: RdsButtonVariant.text,
            onPressed: () {},
          ),
        ],
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
            'Card variants — gallery',
            style: rds.titleSmall.copyWith(color: rds.onSurface),
          ),
          SizedBox(height: rds.space4),
          for (final item in items) ...[
            Text(
              item.label,
              style: rds.labelSmall.copyWith(color: rds.onSurfaceMuted),
            ),
            SizedBox(height: rds.space2),
            item.card,
            SizedBox(height: rds.space5),
          ],
        ],
      ),
    ),
  );
}
