import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

// Toast types are re-exported from rds.dart once the Wiring pass adds:
//   export 'components/toast/rds_toast_widget.dart';
//   export 'components/toast/rds_toast.dart';

/// Top-level [WidgetbookComponent] for the Toast.
/// Register this in T1 Atoms in [main.dart]:
///   `toastComponent`
final toastComponent = WidgetbookComponent(
  name: 'Toast',
  useCases: [
    _playground,
    _gallery,
  ],
);

// ---------------------------------------------------------------------------
// Playground — all knobs (shows RdsToastWidget directly, not overlay)
// ---------------------------------------------------------------------------

final _playground = WidgetbookUseCase(
  name: 'Playground',
  builder: (context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    final variant = context.knobs.list<RdsToastVariant>(
      label: 'Variant',
      options: RdsToastVariant.values,
      initialOption: RdsToastVariant.success,
      labelBuilder: (v) => v.name,
    );
    final dismissMode = context.knobs.list<RdsDismissMode>(
      label: 'Dismiss mode',
      options: RdsDismissMode.values,
      initialOption: RdsDismissMode.auto,
      labelBuilder: (v) => v.name,
    );
    final message = context.knobs.string(
      label: 'Message',
      initialValue: 'Action completed successfully.',
    );
    final showTitle =
        context.knobs.boolean(label: 'Show title', initialValue: false);
    final title = context.knobs.string(
      label: 'Title',
      initialValue: 'Success',
    );
    final showAction =
        context.knobs.boolean(label: 'Show action', initialValue: false);
    final actionLabel = context.knobs.string(
      label: 'Action label',
      initialValue: 'Undo',
    );
    final showLink =
        context.knobs.boolean(label: 'Show link', initialValue: false);
    final linkLabel = context.knobs.string(
      label: 'Link label',
      initialValue: 'View details',
    );

    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(rds.space6),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: RdsToastWidget(
              variant: variant,
              message: message,
              title: showTitle ? title : null,
              dismissMode: dismissMode,
              action: showAction
                  ? RdsToastAction(
                      label: actionLabel,
                      onPressed: () {},
                    )
                  : null,
              link: showLink
                  ? RdsToastLink(
                      label: linkLabel,
                      url: 'https://example.com',
                    )
                  : null,
              onDismiss: dismissMode == RdsDismissMode.manual ? () {} : null,
            ),
          ),
        ),
      ),
    );
  },
);

// ---------------------------------------------------------------------------
// Gallery — all 4 variants
// ---------------------------------------------------------------------------

final _gallery = WidgetbookUseCase(
  name: 'Gallery',
  builder: (context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    final items = [
      (
        RdsToastVariant.success,
        'Changes saved',
        'Your profile has been updated.',
      ),
      (
        RdsToastVariant.danger,
        'Error',
        'Failed to save changes. Please try again.',
      ),
      (
        RdsToastVariant.warning,
        'Warning',
        'Your session will expire in 5 minutes.',
      ),
      (
        RdsToastVariant.neutral,
        null,
        'New version available. Refresh to update.',
      ),
    ];

    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(rds.space6),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: items
                  .map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: rds.space4),
                      child: RdsToastWidget(
                        variant: item.$1,
                        title: item.$2,
                        message: item.$3,
                        dismissMode: RdsDismissMode.manual,
                        onDismiss: () {},
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  },
);
