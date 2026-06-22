import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

final overlayComponent = WidgetbookComponent(
  name: 'Overlay',
  useCases: [
    WidgetbookUseCase(name: 'Right panel — launcher', builder: _rightPanelLauncher),
    WidgetbookUseCase(name: 'Modal — launcher', builder: _modalLauncher),
    WidgetbookUseCase(name: 'Right panel — shell preview', builder: _rightPanelShellPreview),
    WidgetbookUseCase(name: 'Modal — shell preview', builder: _modalShellPreview),
    WidgetbookUseCase(name: 'Right panel with header actions', builder: _rightPanelWithActions),
  ],
);

// ---------------------------------------------------------------------------
// Shared sample form body (mirrors the "Add To Timeline" screenshot)
// ---------------------------------------------------------------------------

Widget _sampleFormBody(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      RdsSegmentedControlInput<String>(
        label: 'Type',
        mandatory: true,
        segments: const [
          RdsSegment(value: 'intervention', label: 'Intervention'),
          RdsSegment(value: 'health_metric', label: 'Health Metric'),
          RdsSegment(value: 'event', label: 'Event'),
        ],
        selected: const {'intervention'},
        onChanged: (_) {},
      ),
      SizedBox(height: rds.space5),
      RdsTextField(
        label: 'Behavior Name',
        mandatory: true,
        onChanged: (_) {},
      ),
      SizedBox(height: rds.space5),
      RdsDateField(
        label: 'Start Date',
        mandatory: true,
        onChanged: (_) {},
      ),
      SizedBox(height: rds.space4),
      RdsCheckboxInput(
        label: 'Currently Ongoing',
        value: false,
        onChanged: (_) {},
      ),
      SizedBox(height: rds.space4),
      RdsDateField(
        label: 'End Date',
        mandatory: true,
        onChanged: (_) {},
      ),
      SizedBox(height: rds.space5),
      RdsTextArea(
        label: 'Comments',
        onChanged: (_) {},
      ),
    ],
  );
}

// ---------------------------------------------------------------------------
// Right panel — launcher (click to open live overlay)
// ---------------------------------------------------------------------------

Widget _rightPanelLauncher(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  return Container(
    color: rds.surfaceVariant,
    alignment: Alignment.center,
    child: RdsButton(
      label: 'Open Right Panel',
      variant: RdsButtonVariant.primary,
      onPressed: () {
        RdsRightPanel.show(
          context: context,
          title: 'Add To Timeline',
          body: _sampleFormBody(context),
          footerActions: [
            RdsButton(
              label: 'Add',
              variant: RdsButtonVariant.primary,
              onPressed: () => Navigator.of(context).pop(),
            ),
            RdsButton(
              label: 'Close',
              variant: RdsButtonVariant.text,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    ),
  );
}

// ---------------------------------------------------------------------------
// Modal — launcher
// ---------------------------------------------------------------------------

Widget _modalLauncher(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  return Container(
    color: rds.surfaceVariant,
    alignment: Alignment.center,
    child: RdsButton(
      label: 'Open Modal',
      variant: RdsButtonVariant.primary,
      onPressed: () {
        RdsModal.show(
          context: context,
          title: 'Onboard Member',
          body: _sampleFormBody(context),
          footerActions: [
            RdsButton(
              label: 'Done',
              variant: RdsButtonVariant.primary,
              onPressed: () => Navigator.of(context).pop(),
            ),
            RdsButton(
              label: 'Cancel',
              variant: RdsButtonVariant.text,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    ),
  );
}

// ---------------------------------------------------------------------------
// Right panel — static shell preview (shows the shell directly)
// ---------------------------------------------------------------------------

Widget _rightPanelShellPreview(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  return Row(
    children: [
      // Simulated scrim
      Expanded(
        child: Container(color: rds.scrim.withValues(alpha: 0.54)),
      ),
      // Panel
      SizedBox(
        width: 420,
        child: Material(
          color: rds.surface,
          child: RdsOverlayShell(
            title: 'Add To Timeline',
            body: _sampleFormBody(context),
            footerActions: [
              RdsButton(
                label: 'Add',
                variant: RdsButtonVariant.primary,
                onPressed: () {},
              ),
              RdsButton(
                label: 'Close',
                variant: RdsButtonVariant.text,
                onPressed: () {},
              ),
            ],
            onClose: () {},
          ),
        ),
      ),
    ],
  );
}

// ---------------------------------------------------------------------------
// Modal — static shell preview
// ---------------------------------------------------------------------------

Widget _modalShellPreview(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  return Container(
    color: rds.scrim.withValues(alpha: 0.54),
    alignment: Alignment.center,
    child: Container(
      width: 560,
      constraints: const BoxConstraints(maxHeight: 640),
      decoration: BoxDecoration(
        color: rds.surface,
        borderRadius: BorderRadius.circular(rds.radiusLg),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 32,
            offset: Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: RdsOverlayShell(
        title: 'Onboard Member',
        body: _sampleFormBody(context),
        footerActions: [
          RdsButton(
            label: 'Done',
            variant: RdsButtonVariant.primary,
            onPressed: () {},
          ),
          RdsButton(
            label: 'Cancel',
            variant: RdsButtonVariant.text,
            onPressed: () {},
          ),
        ],
        onClose: () {},
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Right panel with header actions
// ---------------------------------------------------------------------------

Widget _rightPanelWithActions(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Edit Vitals Differential',
  );

  return Container(
    color: rds.surfaceVariant,
    alignment: Alignment.center,
    child: RdsButton(
      label: 'Open Panel with Header Action',
      variant: RdsButtonVariant.primary,
      onPressed: () {
        RdsRightPanel.show(
          context: context,
          title: title,
          headerActions: [
            RdsButton(
              label: 'Preview',
              variant: RdsButtonVariant.outlined,
              onPressed: () {},
            ),
          ],
          body: _sampleFormBody(context),
          footerActions: [
            RdsButton(
              label: 'Save',
              variant: RdsButtonVariant.primary,
              onPressed: () => Navigator.of(context).pop(),
            ),
            RdsButton(
              label: 'Preview Changes',
              variant: RdsButtonVariant.outlined,
              onPressed: () {},
            ),
            RdsButton(
              label: 'Close',
              variant: RdsButtonVariant.text,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    ),
  );
}
