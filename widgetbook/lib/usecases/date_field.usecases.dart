import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:rds/rds.dart';

// ---------------------------------------------------------------------------
// Date Field
// ---------------------------------------------------------------------------

final dateFieldComponent = WidgetbookComponent(
  name: 'Date Field',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _datePlayground),
    WidgetbookUseCase(name: 'States gallery', builder: _dateGallery),
  ],
);

Widget _datePlayground(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  final label = context.knobs.string(label: 'Label', initialValue: 'Date of birth');
  final placeholder =
      context.knobs.string(label: 'Placeholder', initialValue: 'DD/MM/YYYY');
  final mandatory = context.knobs.boolean(label: 'Mandatory', initialValue: false);
  final disabled = context.knobs.boolean(label: 'Disabled', initialValue: false);
  final readOnly = context.knobs.boolean(label: 'Read only', initialValue: false);
  final errorText = context.knobs.string(label: 'Error text', initialValue: '');
  final supportText =
      context.knobs.string(label: 'Support text', initialValue: '');

  return Scaffold(
    backgroundColor: rds.surface,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: EdgeInsets.all(rds.space6),
          child: StatefulBuilder(
            builder: (ctx, setState) {
              DateTime? value;
              return RdsDateField(
                label: label,
                value: value,
                onChanged: disabled ? null : (d) => setState(() => value = d),
                placeholder: placeholder,
                mandatory: mandatory,
                disabled: disabled,
                readOnly: readOnly,
                errorText: errorText.isEmpty ? null : errorText,
                supportText: supportText.isEmpty ? null : supportText,
              );
            },
          ),
        ),
      ),
    ),
  );
}

Widget _dateGallery(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Date Field States',
              style: rds.headlineMedium.copyWith(color: rds.onSurface)),
          SizedBox(height: rds.space6),
          _FieldStateCard(
            label: 'Enabled — empty',
            child: RdsDateField(label: 'Date of birth', onChanged: (_) {}),
          ),
          SizedBox(height: rds.space4),
          _FieldStateCard(
            label: 'Filled',
            child: RdsDateField(
              label: 'Date of birth',
              value: DateTime(1990, 6, 15),
              onChanged: (_) {},
            ),
          ),
          SizedBox(height: rds.space4),
          _FieldStateCard(
            label: 'Error',
            child: RdsDateField(
              label: 'Date of birth',
              errorText: 'Date is required.',
              onChanged: (_) {},
            ),
          ),
          SizedBox(height: rds.space4),
          _FieldStateCard(
            label: 'Disabled',
            child: const RdsDateField(label: 'Date of birth'),
          ),
          SizedBox(height: rds.space4),
          _FieldStateCard(
            label: 'Read only',
            child: RdsDateField(
              label: 'Date of birth',
              value: DateTime(1990, 6, 15),
              readOnly: true,
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Time Field
// ---------------------------------------------------------------------------

final timeFieldComponent = WidgetbookComponent(
  name: 'Time Field',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _timePlayground),
    WidgetbookUseCase(name: 'States gallery', builder: _timeGallery),
  ],
);

Widget _timePlayground(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  final label =
      context.knobs.string(label: 'Label', initialValue: 'Appointment time');
  final use24h =
      context.knobs.boolean(label: '24-hour format', initialValue: true);
  final mandatory = context.knobs.boolean(label: 'Mandatory', initialValue: false);
  final disabled = context.knobs.boolean(label: 'Disabled', initialValue: false);
  final readOnly = context.knobs.boolean(label: 'Read only', initialValue: false);
  final errorText = context.knobs.string(label: 'Error text', initialValue: '');

  return Scaffold(
    backgroundColor: rds.surface,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: EdgeInsets.all(rds.space6),
          child: StatefulBuilder(
            builder: (ctx, setState) {
              TimeOfDay? value;
              return RdsTimeField(
                label: label,
                value: value,
                onChanged: disabled ? null : (t) => setState(() => value = t),
                use24HourFormat: use24h,
                mandatory: mandatory,
                disabled: disabled,
                readOnly: readOnly,
                errorText: errorText.isEmpty ? null : errorText,
              );
            },
          ),
        ),
      ),
    ),
  );
}

Widget _timeGallery(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Time Field States',
              style: rds.headlineMedium.copyWith(color: rds.onSurface)),
          SizedBox(height: rds.space6),
          _FieldStateCard(
            label: 'Enabled — empty',
            child: RdsTimeField(label: 'Appointment time', onChanged: (_) {}),
          ),
          SizedBox(height: rds.space4),
          _FieldStateCard(
            label: 'Filled (24h)',
            child: RdsTimeField(
              label: 'Appointment time',
              value: const TimeOfDay(hour: 14, minute: 30),
              onChanged: (_) {},
            ),
          ),
          SizedBox(height: rds.space4),
          _FieldStateCard(
            label: 'Filled (12h AM/PM)',
            child: RdsTimeField(
              label: 'Appointment time',
              value: const TimeOfDay(hour: 14, minute: 30),
              use24HourFormat: false,
              onChanged: (_) {},
            ),
          ),
          SizedBox(height: rds.space4),
          _FieldStateCard(
            label: 'Error',
            child: RdsTimeField(
              label: 'Appointment time',
              errorText: 'Time is required.',
              onChanged: (_) {},
            ),
          ),
          SizedBox(height: rds.space4),
          _FieldStateCard(
            label: 'Disabled',
            child: const RdsTimeField(label: 'Appointment time'),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Date-Time Field
// ---------------------------------------------------------------------------

final dateTimeFieldComponent = WidgetbookComponent(
  name: 'Date-Time Field',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _dateTimePlayground),
    WidgetbookUseCase(name: 'States gallery', builder: _dateTimeGallery),
  ],
);

Widget _dateTimePlayground(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  final label =
      context.knobs.string(label: 'Label', initialValue: 'Appointment');
  final use24h =
      context.knobs.boolean(label: '24-hour format', initialValue: true);
  final mandatory = context.knobs.boolean(label: 'Mandatory', initialValue: false);
  final disabled = context.knobs.boolean(label: 'Disabled', initialValue: false);
  final readOnly = context.knobs.boolean(label: 'Read only', initialValue: false);
  final errorText = context.knobs.string(label: 'Error text', initialValue: '');

  return Scaffold(
    backgroundColor: rds.surface,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: EdgeInsets.all(rds.space6),
          child: StatefulBuilder(
            builder: (ctx, setState) {
              DateTime? value;
              return RdsDateTimeField(
                label: label,
                value: value,
                onChanged: disabled ? null : (dt) => setState(() => value = dt),
                use24HourFormat: use24h,
                mandatory: mandatory,
                disabled: disabled,
                readOnly: readOnly,
                errorText: errorText.isEmpty ? null : errorText,
              );
            },
          ),
        ),
      ),
    ),
  );
}

Widget _dateTimeGallery(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  final filled = DateTime(2025, 3, 14, 9, 30);

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Date-Time Field States',
              style: rds.headlineMedium.copyWith(color: rds.onSurface)),
          SizedBox(height: rds.space6),
          _FieldStateCard(
            label: 'Enabled — empty',
            child: RdsDateTimeField(label: 'Appointment', onChanged: (_) {}),
          ),
          SizedBox(height: rds.space4),
          _FieldStateCard(
            label: 'Filled',
            child: RdsDateTimeField(
                label: 'Appointment', value: filled, onChanged: (_) {}),
          ),
          SizedBox(height: rds.space4),
          _FieldStateCard(
            label: 'Error',
            child: RdsDateTimeField(
              label: 'Appointment',
              errorText: 'Appointment date & time is required.',
              onChanged: (_) {},
            ),
          ),
          SizedBox(height: rds.space4),
          _FieldStateCard(
            label: 'Disabled',
            child: const RdsDateTimeField(label: 'Appointment'),
          ),
          SizedBox(height: rds.space4),
          _FieldStateCard(
            label: 'Read only',
            child: RdsDateTimeField(
              label: 'Appointment',
              value: filled,
              readOnly: true,
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Shared gallery helpers
// ---------------------------------------------------------------------------

class _FieldStateCard extends StatelessWidget {
  final String label;
  final Widget child;

  const _FieldStateCard({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Container(
      decoration: BoxDecoration(
        color: rds.surface,
        borderRadius: BorderRadius.circular(rds.radiusMd),
        border: Border.all(color: rds.outlineVariant),
      ),
      padding: EdgeInsets.all(rds.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: rds.labelSmall.copyWith(color: rds.onSurfaceMuted)),
          SizedBox(height: rds.space3),
          child,
        ],
      ),
    );
  }
}
