import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

final compactTableComponent = WidgetbookComponent(
  name: 'Compact Table',
  useCases: [
    WidgetbookUseCase(name: 'Body weight log', builder: _bodyWeightLog),
    WidgetbookUseCase(name: 'Playground', builder: _playground),
    WidgetbookUseCase(name: 'Empty state', builder: _emptyState),
    WidgetbookUseCase(name: 'Striped rows', builder: _stripedRows),
    WidgetbookUseCase(name: 'Tappable rows', builder: _tappableRows),
    WidgetbookUseCase(name: 'No outline', builder: _noOutline),
  ],
);

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

class _WeightEntry {
  final String date;
  final String source;
  final String weight;
  final String bmi;
  const _WeightEntry(this.date, this.source, this.weight, this.bmi);
}

const _weightData = [
  _WeightEntry('Oct 15, 2023', 'At Center', '180 lbs', '22.20'),
  _WeightEntry('Aug 30, 2023', 'At Center', '179 lbs', '11'),
  _WeightEntry('Jul 04, 2023', 'Apple Kit', '182 lbs', '11'),
  _WeightEntry('May 16, 2023', 'Apple Kit', '180 lbs', '11'),
  _WeightEntry('Mar 25, 2023', 'At Center', '206 lbs', '1'),
  _WeightEntry('Mar 25, 2023', 'Apple Kit', '220 lbs', '11'),
];

List<RdsCompactTableColumn<_WeightEntry>> _weightColumns(RdsTheme rds) => [
      RdsCompactTableColumn(
        header: 'Date',
        flex: 3,
        cellBuilder: (ctx, row) => Text(
          row.date,
          style: rds.bodyMedium.copyWith(color: rds.onSurface),
        ),
      ),
      RdsCompactTableColumn(
        header: 'Source',
        flex: 2,
        cellBuilder: (ctx, row) => Text(
          row.source,
          style: rds.bodyMedium.copyWith(color: rds.onSurfaceMuted),
        ),
      ),
      RdsCompactTableColumn(
        header: 'Weight',
        flex: 2,
        cellBuilder: (ctx, row) => Text(
          row.weight,
          style: rds.bodyMedium.copyWith(
            color: rds.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      RdsCompactTableColumn(
        header: 'BMI',
        flex: 2,
        alignment: Alignment.centerRight,
        cellBuilder: (ctx, row) => Text(
          row.bmi,
          style: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
        ),
      ),
    ];

// ---------------------------------------------------------------------------
// Body weight log — mirrors the design screenshot
// ---------------------------------------------------------------------------

Widget _bodyWeightLog(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  return Container(
    color: rds.surfaceVariant,
    padding: EdgeInsets.all(rds.space6),
    child: RdsCompactTable<_WeightEntry>(
      columns: _weightColumns(rds),
      rows: _weightData,
    ),
  );
}

// ---------------------------------------------------------------------------
// Playground
// ---------------------------------------------------------------------------

Widget _playground(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final outlined = context.knobs.boolean(label: 'Outlined', initialValue: true);
  final striped = context.knobs.boolean(label: 'Striped', initialValue: false);
  final tappable = context.knobs.boolean(label: 'Tappable rows', initialValue: false);
  final showEmpty = context.knobs.boolean(label: 'Empty data', initialValue: false);
  final emptyMsg = context.knobs.string(
    label: 'Empty message',
    initialValue: 'No measurements recorded',
  );

  return Container(
    color: rds.surfaceVariant,
    padding: EdgeInsets.all(rds.space6),
    child: RdsCompactTable<_WeightEntry>(
      columns: _weightColumns(rds),
      rows: showEmpty ? [] : _weightData,
      outlined: outlined,
      striped: striped,
      onRowTap: tappable ? (_) {} : null,
      emptyMessage: emptyMsg,
    ),
  );
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

Widget _emptyState(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  return Container(
    color: rds.surfaceVariant,
    padding: EdgeInsets.all(rds.space6),
    child: RdsCompactTable<_WeightEntry>(
      columns: _weightColumns(rds),
      rows: const [],
      emptyMessage: 'No measurements recorded yet',
    ),
  );
}

// ---------------------------------------------------------------------------
// Striped rows
// ---------------------------------------------------------------------------

Widget _stripedRows(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  return Container(
    color: rds.surface,
    padding: EdgeInsets.all(rds.space6),
    child: RdsCompactTable<_WeightEntry>(
      columns: _weightColumns(rds),
      rows: _weightData,
      striped: true,
    ),
  );
}

// ---------------------------------------------------------------------------
// Tappable rows
// ---------------------------------------------------------------------------

Widget _tappableRows(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  return Container(
    color: rds.surfaceVariant,
    padding: EdgeInsets.all(rds.space6),
    child: RdsCompactTable<_WeightEntry>(
      columns: _weightColumns(rds),
      rows: _weightData,
      onRowTap: (_) {},
    ),
  );
}

// ---------------------------------------------------------------------------
// No outline (inline / embedded)
// ---------------------------------------------------------------------------

Widget _noOutline(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  return Container(
    color: rds.surface,
    padding: EdgeInsets.all(rds.space6),
    child: RdsCompactTable<_WeightEntry>(
      columns: _weightColumns(rds),
      rows: _weightData,
      outlined: false,
    ),
  );
}
