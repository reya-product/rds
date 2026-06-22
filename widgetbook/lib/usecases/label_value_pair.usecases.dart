import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

final labelValuePairComponent = WidgetbookComponent(
  name: 'Label Value Pair',
  useCases: [
    WidgetbookUseCase(
      name: 'Single row',
      builder: (context) {
        final label = context.knobs.string(
          label: 'Label',
          initialValue: 'FIRST NAME',
        );
        final value = context.knobs.string(
          label: 'Value (empty = dash)',
          initialValue: 'Juliana',
        );
        final isLink = context.knobs.boolean(
          label: 'Is link',
          initialValue: false,
        );
        final showDivider = context.knobs.boolean(
          label: 'Show divider',
          initialValue: true,
        );
        final rds = Theme.of(context).extension<RdsTheme>()!;
        return Padding(
          padding: EdgeInsets.all(rds.space6),
          child: RdsLabelValuePair(
            label: label,
            value: value.isEmpty ? null : value,
            isLink: isLink,
            onTap: isLink ? () {} : null,
            showDivider: showDivider,
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Contact information list',
      builder: (context) {
        final rds = Theme.of(context).extension<RdsTheme>()!;
        return SingleChildScrollView(
          padding: EdgeInsets.all(rds.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RdsSubHeader(
                title: 'Contact Information',
                actionLabel: 'EDIT',
                onAction: () {},
              ),
              RdsLabelValueList(
                items: const [
                  RdsLabelValueItem(label: 'FIRST NAME', value: 'Juliana'),
                  RdsLabelValueItem(label: 'MIDDLE NAME'),
                  RdsLabelValueItem(label: 'LAST NAME', value: 'Crain'),
                  RdsLabelValueItem(label: 'D.O.B', value: '02 Aug 1985'),
                  RdsLabelValueItem(
                      label: 'SEX ASSIGNED AT BIRTH', value: 'Female'),
                  RdsLabelValueItem(
                      label: 'PREFERRED PRONOUNS', value: 'She/ Her'),
                  RdsLabelValueItem(
                    label: 'MOBILE #',
                    value: '+1 718-479-7777',
                    isLink: true,
                    onTap: null,
                  ),
                  RdsLabelValueItem(label: 'WORK PHONE #'),
                ],
              ),
            ],
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Empty / null values',
      builder: (context) {
        final rds = Theme.of(context).extension<RdsTheme>()!;
        return Padding(
          padding: EdgeInsets.all(rds.space4),
          child: const RdsLabelValueList(
            items: [
              RdsLabelValueItem(label: 'FIELD WITH VALUE', value: 'Some text'),
              RdsLabelValueItem(label: 'NULL VALUE'),
              RdsLabelValueItem(label: 'EMPTY STRING', value: ''),
              RdsLabelValueItem(label: 'ANOTHER VALUE', value: 'Present'),
            ],
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Link values',
      builder: (context) {
        final rds = Theme.of(context).extension<RdsTheme>()!;
        return Padding(
          padding: EdgeInsets.all(rds.space4),
          child: RdsLabelValueList(
            items: [
              RdsLabelValueItem(
                label: 'MOBILE #',
                value: '+1 718-479-7777',
                isLink: true,
                onTap: () {},
              ),
              RdsLabelValueItem(
                label: 'EMAIL',
                value: 'juliana.crain@example.com',
                isLink: true,
                onTap: () {},
              ),
              RdsLabelValueItem(
                label: 'WORK PHONE #',
                value: '+1 212-555-0100',
                isLink: true,
                onTap: () {},
              ),
              const RdsLabelValueItem(label: 'FAX'),
            ],
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Long labels & values',
      builder: (context) {
        final rds = Theme.of(context).extension<RdsTheme>()!;
        return Padding(
          padding: EdgeInsets.all(rds.space4),
          child: const RdsLabelValueList(
            items: [
              RdsLabelValueItem(
                label: 'SEX ASSIGNED AT BIRTH',
                value: 'Prefer not to say',
              ),
              RdsLabelValueItem(
                label: 'EMERGENCY CONTACT NAME',
                value: 'Jonathan Crain-Whitmore',
              ),
              RdsLabelValueItem(
                label: 'HOME ADDRESS',
                value: '742 Evergreen Terrace, Springfield, IL 62704',
              ),
              RdsLabelValueItem(label: 'SECONDARY ADDRESS'),
            ],
          ),
        );
      },
    ),
  ],
);
