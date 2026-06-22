import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

final listItemComponent = WidgetbookComponent(
  name: 'List Item',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _playground),
    WidgetbookUseCase(name: 'Leading variants', builder: _leadingVariants),
    WidgetbookUseCase(name: 'Trailing variants', builder: _trailingVariants),
    WidgetbookUseCase(name: 'Badge positions', builder: _badgePositions),
    WidgetbookUseCase(name: 'States', builder: _states),
  ],
);

// ---------------------------------------------------------------------------
// Playground
// ---------------------------------------------------------------------------

Widget _playground(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final leading = context.knobs.list<RdsListItemLeading>(
    label: 'Leading',
    options: RdsListItemLeading.values,
    initialOption: RdsListItemLeading.none,
    labelBuilder: (v) => v.name,
  );
  final trailing = context.knobs.list<RdsListItemTrailing>(
    label: 'Trailing',
    options: RdsListItemTrailing.values,
    initialOption: RdsListItemTrailing.none,
    labelBuilder: (v) => v.name,
  );
  final badgePosition = context.knobs.list<RdsListItemBadgePosition>(
    label: 'Badge position',
    options: RdsListItemBadgePosition.values,
    initialOption: RdsListItemBadgePosition.none,
    labelBuilder: (v) => v.name,
  );
  final primaryText = context.knobs.string(
    label: 'Primary text',
    initialValue: 'List item label',
  );
  final overlineRaw = context.knobs.string(
    label: 'Overline (empty = none)',
    initialValue: '',
  );
  final supportingRaw = context.knobs.string(
    label: 'Supporting text (empty = none)',
    initialValue: 'Secondary description text',
  );
  final selected = context.knobs.boolean(
    label: 'Selected',
    initialValue: false,
  );
  final enabled = context.knobs.boolean(
    label: 'Enabled',
    initialValue: true,
  );

  final overline = overlineRaw.isEmpty ? null : overlineRaw;
  final supporting = supportingRaw.isEmpty ? null : supportingRaw;

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(rds.space6),
        child: Card(
          elevation: 0,
          color: rds.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(rds.radiusMd),
            side: BorderSide(color: rds.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: RdsListItem(
            primaryText: primaryText,
            overline: overline,
            supportingText: supporting,
            leading: leading,
            trailing: trailing,
            badgePosition: badgePosition,
            badge: badgePosition != RdsListItemBadgePosition.none
                ? const RdsBadgeConfig(
                    label: 'New',
                    color: RdsBadgeColor.teal,
                  )
                : null,
            leadingIcon: RdsIcons.user,
            leadingAvatar: const RdsAvatarConfig(
              type: RdsAvatarType.initials,
              name: 'Jane Doe',
            ),
            trailingIcon: RdsIcons.chevronRight,
            trailingAvatar: const RdsAvatarConfig(
              type: RdsAvatarType.initials,
              name: 'JD',
            ),
            checkboxValue: false,
            toggleValue: false,
            radioValue: 'a',
            radioGroupValue: null,
            selected: selected,
            enabled: enabled,
            onTap: enabled ? () {} : null,
          ),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Leading variants
// ---------------------------------------------------------------------------

Widget _leadingVariants(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final variants = <(RdsListItemLeading, String, String)>[
    (RdsListItemLeading.none, 'None', 'No leading widget'),
    (RdsListItemLeading.icon, 'Icon', 'Leading icon in the slot'),
    (RdsListItemLeading.avatar, 'Avatar', 'User avatar in the slot'),
    (RdsListItemLeading.checkbox, 'Checkbox', 'Tristate checkbox in the slot'),
    (RdsListItemLeading.radio, 'Radio', 'Radio button in the slot'),
    (RdsListItemLeading.toggle, 'Toggle', 'Toggle switch in the slot'),
  ];

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leading variants',
            style: rds.titleSmall.copyWith(color: rds.onSurface),
          ),
          SizedBox(height: rds.space3),
          Card(
            elevation: 0,
            color: rds.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(rds.radiusMd),
              side: BorderSide(color: rds.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: variants.map((entry) {
                final (type, label, supporting) = entry;
                return Column(
                  children: [
                    RdsListItem(
                      primaryText: label,
                      supportingText: supporting,
                      leading: type,
                      leadingIcon: RdsIcons.settings,
                      leadingAvatar: const RdsAvatarConfig(
                        type: RdsAvatarType.initials,
                        name: 'Jane Doe',
                      ),
                      checkboxValue: false,
                      radioValue: 'a',
                      radioGroupValue: null,
                      toggleValue: false,
                      onTap: () {},
                    ),
                    if (entry != variants.last)
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: rds.outlineVariant,
                        indent: rds.space4,
                        endIndent: rds.space4,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Trailing variants
// ---------------------------------------------------------------------------

Widget _trailingVariants(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final variants = <(RdsListItemTrailing, String, String)>[
    (RdsListItemTrailing.none, 'None', 'No trailing widget'),
    (RdsListItemTrailing.icon, 'Icon', 'Trailing icon in the slot'),
    (RdsListItemTrailing.avatar, 'Avatar', 'User avatar in the slot'),
    (RdsListItemTrailing.checkbox, 'Checkbox', 'Tristate checkbox in the slot'),
    (RdsListItemTrailing.radio, 'Radio', 'Radio button in the slot'),
    (RdsListItemTrailing.toggle, 'Toggle', 'Toggle switch in the slot'),
  ];

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trailing variants',
            style: rds.titleSmall.copyWith(color: rds.onSurface),
          ),
          SizedBox(height: rds.space3),
          Card(
            elevation: 0,
            color: rds.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(rds.radiusMd),
              side: BorderSide(color: rds.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: variants.map((entry) {
                final (type, label, supporting) = entry;
                return Column(
                  children: [
                    RdsListItem(
                      primaryText: label,
                      supportingText: supporting,
                      trailing: type,
                      trailingIcon: RdsIcons.chevronRight,
                      trailingAvatar: const RdsAvatarConfig(
                        type: RdsAvatarType.initials,
                        name: 'JD',
                        size: RdsAvatarSize.sm,
                      ),
                      checkboxValue: false,
                      radioValue: 'a',
                      radioGroupValue: null,
                      toggleValue: false,
                      onTap: () {},
                    ),
                    if (entry != variants.last)
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: rds.outlineVariant,
                        indent: rds.space4,
                        endIndent: rds.space4,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Badge positions
// ---------------------------------------------------------------------------

Widget _badgePositions(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  const badge = RdsBadgeConfig(
    label: 'New',
    color: RdsBadgeColor.teal,
    size: RdsBadgeSize.small,
  );

  final positions = <(RdsListItemBadgePosition, String)>[
    (RdsListItemBadgePosition.none, 'None — no badge rendered'),
    (
      RdsListItemBadgePosition.aboveOverline,
      'Above overline — badge is first element'
    ),
    (
      RdsListItemBadgePosition.belowPrimaryAboveSupporting,
      'Between primary and supporting'
    ),
    (RdsListItemBadgePosition.belowSupporting, 'Below supporting text'),
  ];

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Badge positions',
            style: rds.titleSmall.copyWith(color: rds.onSurface),
          ),
          SizedBox(height: rds.space3),
          Card(
            elevation: 0,
            color: rds.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(rds.radiusMd),
              side: BorderSide(color: rds.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: positions.map((entry) {
                final (pos, desc) = entry;
                return Column(
                  children: [
                    RdsListItem(
                      overline: 'Category',
                      primaryText: pos.name,
                      supportingText: desc,
                      leading: RdsListItemLeading.icon,
                      leadingIcon: RdsIcons.info,
                      badgePosition: pos,
                      badge: pos != RdsListItemBadgePosition.none
                          ? badge
                          : null,
                    ),
                    if (entry != positions.last)
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: rds.outlineVariant,
                        indent: rds.space4,
                        endIndent: rds.space4,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

Widget _states(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  Widget stateCard(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: rds.labelSmall.copyWith(color: rds.onSurfaceMuted)),
        SizedBox(height: rds.space2),
        Card(
          elevation: 0,
          color: rds.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(rds.radiusMd),
            side: BorderSide(color: rds.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
        SizedBox(height: rds.space5),
      ],
    );
  }

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('States', style: rds.titleSmall.copyWith(color: rds.onSurface)),
          SizedBox(height: rds.space4),

          // Enabled (default)
          stateCard(
            'ENABLED',
            RdsListItem(
              primaryText: 'Enabled item',
              supportingText: 'Normal interactive state',
              leading: RdsListItemLeading.icon,
              leadingIcon: RdsIcons.user,
              trailing: RdsListItemTrailing.icon,
              trailingIcon: RdsIcons.chevronRight,
              onTap: () {},
            ),
          ),

          // Selected
          stateCard(
            'SELECTED',
            RdsListItem(
              primaryText: 'Selected item',
              overline: 'Category',
              supportingText: 'Background is primaryContainer; overline and icon tinted primary',
              leading: RdsListItemLeading.icon,
              leadingIcon: RdsIcons.check,
              trailing: RdsListItemTrailing.icon,
              trailingIcon: RdsIcons.chevronRight,
              selected: true,
              onTap: () {},
            ),
          ),

          // Disabled
          stateCard(
            'DISABLED',
            RdsListItem(
              primaryText: 'Disabled item',
              supportingText: 'Opacity reduced; no interaction',
              leading: RdsListItemLeading.icon,
              leadingIcon: RdsIcons.user,
              trailing: RdsListItemTrailing.toggle,
              toggleValue: false,
              enabled: false,
            ),
          ),

          // Hover simulation (focused border)
          stateCard(
            'HOVER / PRESS SIMULATION',
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: rds.primary.withOpacity(0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(rds.radiusMd),
              ),
              child: RdsListItem(
                primaryText: 'Hover / press me',
                supportingText: 'State overlay visible on pointer interaction',
                leading: RdsListItemLeading.avatar,
                leadingAvatar: const RdsAvatarConfig(
                  type: RdsAvatarType.initials,
                  name: 'Jane Doe',
                ),
                trailing: RdsListItemTrailing.icon,
                trailingIcon: RdsIcons.chevronRight,
                onTap: () {},
              ),
            ),
          ),

          // No text slots
          stateCard(
            'MINIMAL (primaryText only)',
            RdsListItem(primaryText: 'Just a label'),
          ),

          // Multi-line
          stateCard(
            'THREE-LINE (overline + primary + supporting)',
            RdsListItem(
              overline: 'Appointment',
              primaryText: 'Annual wellness check-up',
              supportingText: 'Dr. Amanda Shah · Mon 9 Jun 2026, 10:00 AM',
              leading: RdsListItemLeading.avatar,
              leadingAvatar: const RdsAvatarConfig(
                type: RdsAvatarType.initials,
                name: 'Amanda Shah',
              ),
              trailing: RdsListItemTrailing.icon,
              trailingIcon: RdsIcons.chevronRight,
              badgePosition: RdsListItemBadgePosition.aboveOverline,
              badge: const RdsBadgeConfig(
                label: 'Confirmed',
                color: RdsBadgeColor.success,
                size: RdsBadgeSize.small,
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
    ),
  );
}
