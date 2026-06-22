import 'package:flutter/material.dart';
import '../../theme/rds_theme.dart';
import '../../tokens/rds_icon_size.dart';
import '../../tokens/rds_icons.dart';
import '../button_group/rds_button_group.dart';

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

/// A single segment within [RdsSegmentedButtons].
class RdsSegment<T> {
  const RdsSegment({
    required this.value,
    required this.label,
    this.icon,
    this.disabled = false,
  });

  /// The value used to identify this segment in the [selected] set.
  final T value;

  /// Text label shown in the segment.
  final String label;

  /// Optional icon for this segment.
  final IconData? icon;

  /// Whether this specific segment is disabled.
  final bool disabled;
}

// ---------------------------------------------------------------------------
// RdsSegmentedButtons
// ---------------------------------------------------------------------------

/// An outlined segmented control for single or multi-select scenarios.
///
/// The entire row shares a single rounded border ([color-outline],
/// [radius-md]). Internal vertical dividers separate segments.
/// Selected segments are filled with [color-primary-container] with
/// [color-on-primary-container] text/icon. A check icon is prepended to
/// selected segments when [showCheckmark] is true (default).
///
/// ```dart
/// RdsSegmentedButtons<String>(
///   segments: const [
///     RdsSegment(value: 'day',   label: 'Day'),
///     RdsSegment(value: 'week',  label: 'Week'),
///     RdsSegment(value: 'month', label: 'Month'),
///   ],
///   selected: {'week'},
///   onSelectionChanged: (next) => setState(() => _selected = next),
/// )
/// ```
class RdsSegmentedButtons<T> extends StatelessWidget {
  const RdsSegmentedButtons({
    super.key,
    required this.segments,
    this.selectionMode = RdsButtonGroupSelectionMode.single,
    required this.selected,
    this.onSelectionChanged,
    this.showIcons = true,
    this.showCheckmark = true,
    this.disabled = false,
  });

  /// The ordered list of segments to render.
  final List<RdsSegment<T>> segments;

  /// Single or multi-select. [RdsButtonGroupSelectionMode.none] is not
  /// meaningful for segmented buttons and behaves like [single].
  final RdsButtonGroupSelectionMode selectionMode;

  /// The set of currently selected segment values.
  final Set<T> selected;

  /// Called when the selection changes.
  final ValueChanged<Set<T>>? onSelectionChanged;

  /// Whether to render the segment's [RdsSegment.icon] when present.
  final bool showIcons;

  /// Whether to show a checkmark icon prefix on selected segments.
  final bool showCheckmark;

  /// Disables the entire control.
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Semantics(
      label: 'Segmented buttons',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(rds.radiusMd),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: rds.outline, width: 1),
            borderRadius: BorderRadius.circular(rds.radiusMd),
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(segments.length, (index) {
                final segment = segments[index];
                final isSelected = selected.contains(segment.value);
                final isDisabled = disabled || segment.disabled;
                final isLast = index == segments.length - 1;

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _RdsSegmentItem<T>(
                      segment: segment,
                      isSelected: isSelected,
                      isDisabled: isDisabled,
                      showIcons: showIcons,
                      showCheckmark: showCheckmark,
                      onTap: isDisabled ? null : () => _handleTap(segment.value),
                    ),
                    if (!isLast)
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: rds.outline,
                      ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(T value) {
    if (onSelectionChanged == null) return;

    Set<T> next;
    switch (selectionMode) {
      case RdsButtonGroupSelectionMode.none:
      case RdsButtonGroupSelectionMode.single:
        next = {value};
        break;
      case RdsButtonGroupSelectionMode.multi:
        next = Set<T>.from(selected);
        if (next.contains(value)) {
          next.remove(value);
        } else {
          next.add(value);
        }
        break;
    }
    onSelectionChanged!(next);
  }
}

// ---------------------------------------------------------------------------
// Internal segment item
// ---------------------------------------------------------------------------

class _RdsSegmentItem<T> extends StatefulWidget {
  const _RdsSegmentItem({
    required this.segment,
    required this.isSelected,
    required this.isDisabled,
    required this.showIcons,
    required this.showCheckmark,
    required this.onTap,
  });

  final RdsSegment<T> segment;
  final bool isSelected;
  final bool isDisabled;
  final bool showIcons;
  final bool showCheckmark;
  final VoidCallback? onTap;

  @override
  State<_RdsSegmentItem<T>> createState() => _RdsSegmentItemState<T>();
}

class _RdsSegmentItemState<T> extends State<_RdsSegmentItem<T>> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _isInteractive => !widget.isDisabled && widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final animDuration = reducedMotion ? rds.durationInstant : rds.durationStandard;

    // ---- colors ----
    final Color fillColor =
        widget.isSelected ? rds.primaryContainer : Colors.transparent;
    final Color contentColor =
        widget.isSelected ? rds.onPrimaryContainer : rds.onSurface;

    // ---- state layer ----
    double stateOpacity = 0.0;
    if (_isInteractive) {
      if (_pressed) {
        stateOpacity = rds.statePressed;
      } else if (_focused) {
        stateOpacity = rds.stateFocus;
      } else if (_hovered) {
        stateOpacity = rds.stateHover;
      }
    }

    // ---- content ----
    final List<Widget> rowChildren = [];

    // Checkmark for selected state
    if (widget.isSelected && widget.showCheckmark) {
      rowChildren.add(
        Icon(RdsIcons.check, size: RdsIconSize.md, color: contentColor),
      );
      rowChildren.add(SizedBox(width: rds.space1));
    }

    // Segment icon (if present and showIcons)
    if (widget.showIcons && widget.segment.icon != null) {
      rowChildren.add(
        Icon(widget.segment.icon, size: RdsIconSize.md, color: contentColor),
      );
      rowChildren.add(SizedBox(width: rds.space1));
    }

    // Label
    rowChildren.add(
      Text(
        widget.segment.label,
        style: rds.labelLarge.copyWith(color: contentColor),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: rowChildren,
    );

    // ---- build segment ----
    Widget segmentBody = AnimatedContainer(
      duration: animDuration,
      curve: rds.curveStandard,
      constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
      padding: EdgeInsets.symmetric(
        horizontal: rds.space4,
        vertical: rds.space2,
      ),
      decoration: BoxDecoration(color: fillColor),
      child: Stack(
        alignment: Alignment.center,
        children: [
          content,
          if (stateOpacity > 0)
            Positioned.fill(
              child: AnimatedOpacity(
                duration: animDuration,
                curve: rds.curveStandard,
                opacity: stateOpacity,
                child: ColoredBox(color: contentColor),
              ),
            ),
        ],
      ),
    );

    if (widget.isDisabled) {
      segmentBody = Opacity(opacity: rds.opacityDisabled, child: segmentBody);
    }

    return Semantics(
      label: widget.segment.label,
      button: true,
      selected: widget.isSelected,
      enabled: _isInteractive,
      child: MouseRegion(
        cursor:
            _isInteractive ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) {
          if (_isInteractive) setState(() => _hovered = true);
        },
        onExit: (_) => setState(() {
          _hovered = false;
          _pressed = false;
        }),
        child: GestureDetector(
          onTapDown: (_) {
            if (_isInteractive) setState(() => _pressed = true);
          },
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: _isInteractive ? widget.onTap : null,
          child: Focus(
            onFocusChange: (hasFocus) => setState(() => _focused = hasFocus),
            child: segmentBody,
          ),
        ),
      ),
    );
  }
}
