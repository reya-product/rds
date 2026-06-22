import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

final subHeaderComponent = WidgetbookComponent(
  name: 'Sub Header',
  useCases: [
    WidgetbookUseCase(
      name: 'Title only',
      builder: (context) {
        final title = context.knobs.string(
          label: 'Title',
          initialValue: 'Contact Information',
        );
        return _SubHeaderPreview(
          child: RdsSubHeader(title: title),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Title + action',
      builder: (context) {
        final title = context.knobs.string(
          label: 'Title',
          initialValue: 'Contact Information',
        );
        final action = context.knobs.string(
          label: 'Action label',
          initialValue: 'EDIT',
        );
        final enabled = context.knobs.boolean(
          label: 'Action enabled',
          initialValue: true,
        );
        return _SubHeaderPreview(
          child: RdsSubHeader(
            title: title,
            actionLabel: action.isEmpty ? null : action,
            onAction: enabled ? () {} : null,
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'In context — stacked sections',
      builder: (context) => _SubHeaderStackedPreview(),
    ),
  ],
);

class _SubHeaderPreview extends StatelessWidget {
  const _SubHeaderPreview({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Padding(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [child],
      ),
    );
  }
}

class _SubHeaderStackedPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Padding(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RdsSubHeader(
            title: 'Contact Information',
            actionLabel: 'EDIT',
            onAction: () {},
          ),
          SizedBox(height: rds.space4),
          RdsSubHeader(
            title: 'Membership Details',
            actionLabel: 'VIEW ALL',
            onAction: () {},
          ),
          SizedBox(height: rds.space4),
          RdsSubHeader(title: 'Activity Log'),
          SizedBox(height: rds.space4),
          RdsSubHeader(
            title: 'Payment Methods',
            actionLabel: 'ADD',
            onAction: null,
          ),
        ],
      ),
    );
  }
}
