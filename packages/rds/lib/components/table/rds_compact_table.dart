import 'package:flutter/material.dart';

import '../../theme/rds_theme.dart';

// ---------------------------------------------------------------------------
// Column definition
// ---------------------------------------------------------------------------

/// Defines a single column in an [RdsCompactTable].
class RdsCompactTableColumn<T> {
  /// Header label. Rendered uppercase in the header row.
  final String header;

  /// Builds the cell widget for a given row value.
  final Widget Function(BuildContext context, T row) cellBuilder;

  /// Relative width weight. Behaves like [Expanded.flex].
  /// Defaults to 1 (equal columns). Set higher to make a column wider.
  final int flex;

  /// Aligns the cell widget (and header label) within the column.
  /// Defaults to [Alignment.centerLeft].
  final Alignment alignment;

  const RdsCompactTableColumn({
    required this.header,
    required this.cellBuilder,
    this.flex = 1,
    this.alignment = Alignment.centerLeft,
  });
}

// ---------------------------------------------------------------------------
// RdsCompactTable
// ---------------------------------------------------------------------------

/// A data table optimised for dense, read-only tabular content.
///
/// Renders a sticky header row with uppercase column labels followed by
/// horizontally-divided data rows. Column widths are proportional (flex).
///
/// ## Usage
/// ```dart
/// RdsCompactTable<WeightEntry>(
///   columns: [
///     RdsCompactTableColumn(
///       header: 'Date',
///       flex: 3,
///       cellBuilder: (ctx, row) {
///         final rds = Theme.of(ctx).extension<RdsTheme>()!;
///         return Text(row.date, style: rds.bodyMedium.copyWith(color: rds.onSurface));
///       },
///     ),
///     RdsCompactTableColumn(
///       header: 'Weight',
///       flex: 2,
///       cellBuilder: (ctx, row) {
///         final rds = Theme.of(ctx).extension<RdsTheme>()!;
///         return Text(
///           row.weight,
///           style: rds.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: rds.onSurface),
///         );
///       },
///     ),
///     RdsCompactTableColumn(
///       header: 'BMI',
///       flex: 2,
///       alignment: Alignment.centerRight,
///       cellBuilder: (ctx, row) {
///         final rds = Theme.of(ctx).extension<RdsTheme>()!;
///         return Text(row.bmi, style: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant));
///       },
///     ),
///   ],
///   rows: weightHistory,
/// )
/// ```
class RdsCompactTable<T> extends StatelessWidget {
  /// Column definitions, in display order (left to right).
  final List<RdsCompactTableColumn<T>> columns;

  /// Data rows to display.
  final List<T> rows;

  /// Draws a 1px [RdsTheme.outline] border and [RdsTheme.radiusLg] rounded
  /// corners around the table. Defaults to true.
  final bool outlined;

  /// Applies alternating `surfaceVariant` tint to odd-indexed rows.
  final bool striped;

  /// Makes rows tappable. When non-null, each row wraps in an [InkWell].
  final void Function(T row)? onRowTap;

  /// Message shown when [rows] is empty.
  final String emptyMessage;

  const RdsCompactTable({
    super.key,
    required this.columns,
    required this.rows,
    this.outlined = true,
    this.striped = false,
    this.onRowTap,
    this.emptyMessage = 'No data',
  });

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _TableHeader<T>(columns: columns, rds: rds),
        Divider(height: 1, thickness: 1, color: rds.outline),
        if (rows.isEmpty)
          _EmptyState(message: emptyMessage, rds: rds)
        else
          for (int i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, thickness: 1, color: rds.outlineVariant),
            _TableRow<T>(
              columns: columns,
              row: rows[i],
              index: i,
              striped: striped,
              onTap: onRowTap != null ? () => onRowTap!(rows[i]) : null,
              rds: rds,
            ),
          ],
      ],
    );

    if (!outlined) return body;

    return Container(
      decoration: BoxDecoration(
        color: rds.surface,
        borderRadius: BorderRadius.circular(rds.radiusLg),
        border: Border.all(color: rds.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: body,
    );
  }
}

// ---------------------------------------------------------------------------
// Private: header row
// ---------------------------------------------------------------------------

class _TableHeader<T> extends StatelessWidget {
  final List<RdsCompactTableColumn<T>> columns;
  final RdsTheme rds;

  const _TableHeader({required this.columns, required this.rds});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: rds.surfaceVariant,
      padding: EdgeInsets.symmetric(horizontal: rds.space4),
      child: Row(
        children: columns
            .map(
              (col) => Expanded(
                flex: col.flex,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: rds.space4),
                  child: Align(
                    alignment: col.alignment,
                    child: Text(
                      col.header.toUpperCase(),
                      style: rds.labelSmall.copyWith(
                        color: rds.onSurfaceVariant,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private: data row
// ---------------------------------------------------------------------------

class _TableRow<T> extends StatelessWidget {
  final List<RdsCompactTableColumn<T>> columns;
  final T row;
  final int index;
  final bool striped;
  final VoidCallback? onTap;
  final RdsTheme rds;

  const _TableRow({
    required this.columns,
    required this.row,
    required this.index,
    required this.striped,
    required this.onTap,
    required this.rds,
  });

  @override
  Widget build(BuildContext context) {
    // Striped: odd rows get a faint surface-variant tint
    final bgColor =
        striped && index.isOdd ? rds.surfaceVariant.withValues(alpha: 0.4) : rds.surface;

    final cells = Padding(
      padding: EdgeInsets.symmetric(horizontal: rds.space4),
      child: Row(
        children: columns
            .map(
              (col) => Expanded(
                flex: col.flex,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: rds.space5),
                  child: Align(
                    alignment: col.alignment,
                    child: col.cellBuilder(context, row),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );

    if (onTap == null) {
      return ColoredBox(color: bgColor, child: cells);
    }

    return Material(
      color: bgColor,
      child: InkWell(
        onTap: onTap,
        overlayColor: WidgetStatePropertyAll(rds.onSurface.withValues(alpha: 0.06)),
        child: cells,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private: empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  final String message;
  final RdsTheme rds;

  const _EmptyState({required this.message, required this.rds});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: rds.surface,
      child: Padding(
        padding: EdgeInsets.all(rds.space8),
        child: Center(
          child: Text(
            message,
            style: rds.bodyMedium.copyWith(color: rds.onSurfaceMuted),
          ),
        ),
      ),
    );
  }
}
