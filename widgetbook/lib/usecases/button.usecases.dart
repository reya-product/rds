import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

final buttonComponent = WidgetbookComponent(
  name: 'Button',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _playground),
    WidgetbookUseCase(name: 'Gallery', builder: _gallery),
    WidgetbookUseCase(name: 'States', builder: _states),
    WidgetbookUseCase(name: 'Icon positions', builder: _iconPositions),
  ],
);

// ---------------------------------------------------------------------------
// Playground
// ---------------------------------------------------------------------------

Widget _playground(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final variant = context.knobs.list(
    label: 'Variant',
    options: RdsButtonVariant.values,
    initialOption: RdsButtonVariant.primary,
    labelBuilder: (v) => v.name,
  );
  final tone = context.knobs.list(
    label: 'Tone',
    options: RdsButtonTone.values,
    initialOption: RdsButtonTone.defaultTone,
    labelBuilder: (v) => v.name,
  );
  final iconPosition = context.knobs.list(
    label: 'Icon position',
    options: RdsButtonIconPosition.values,
    initialOption: RdsButtonIconPosition.none,
    labelBuilder: (v) => v.name,
  );
  final size = context.knobs.list(
    label: 'Size',
    options: RdsButtonSize.values,
    initialOption: RdsButtonSize.medium,
    labelBuilder: (v) => v.name,
  );
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Button',
  );
  final loading = context.knobs.boolean(
    label: 'Loading',
    initialValue: false,
  );
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );
  final fullWidth = context.knobs.boolean(
    label: 'Full width',
    initialValue: false,
  );

  return Scaffold(
    backgroundColor: rds.surface,
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(rds.space6),
        child: RdsButton(
          label: label,
          variant: variant,
          tone: tone,
          iconPosition: iconPosition,
          icon: iconPosition != RdsButtonIconPosition.none ? RdsIcons.add : null,
          size: size,
          loading: loading,
          disabled: disabled,
          fullWidth: fullWidth,
          onPressed: disabled ? null : () {},
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Gallery — all variants × tones × sizes
// ---------------------------------------------------------------------------

Widget _gallery(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  const variants = RdsButtonVariant.values;
  const tones = RdsButtonTone.values;
  const sizes = RdsButtonSize.values;

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Button Gallery',
            style: rds.headlineMedium.copyWith(color: rds.onSurface),
          ),
          SizedBox(height: rds.space6),
          // Variants × Tones
          for (final tone in tones) ...[
            Text(
              'Tone: ${tone.name}',
              style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
            ),
            SizedBox(height: rds.space3),
            Wrap(
              spacing: rds.space3,
              runSpacing: rds.space3,
              children: [
                for (final variant in variants)
                  RdsButton(
                    label: variant.name,
                    variant: variant,
                    tone: tone,
                    onPressed: () {},
                  ),
              ],
            ),
            SizedBox(height: rds.space5),
          ],
          // Sizes
          Text(
            'Sizes',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          Wrap(
            spacing: rds.space3,
            runSpacing: rds.space3,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final size in sizes)
                RdsButton(
                  label: size.name,
                  size: size,
                  onPressed: () {},
                ),
            ],
          ),
          SizedBox(height: rds.space5),
          // With icons
          Text(
            'With icons — leading',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          Wrap(
            spacing: rds.space3,
            runSpacing: rds.space3,
            children: [
              for (final variant in variants)
                RdsButton(
                  label: variant.name,
                  variant: variant,
                  icon: RdsIcons.add,
                  iconPosition: RdsButtonIconPosition.leading,
                  onPressed: () {},
                ),
            ],
          ),
          SizedBox(height: rds.space5),
          // Icon only
          Text(
            'Icon only',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          Wrap(
            spacing: rds.space3,
            runSpacing: rds.space3,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final variant in variants)
                RdsButton(
                  label: variant.name,
                  variant: variant,
                  icon: RdsIcons.edit,
                  iconPosition: RdsButtonIconPosition.iconOnly,
                  onPressed: () {},
                ),
            ],
          ),
          SizedBox(height: rds.space5),
          // Disabled & loading
          Text(
            'Disabled & Loading',
            style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space3),
          Wrap(
            spacing: rds.space3,
            runSpacing: rds.space3,
            children: [
              RdsButton(
                label: 'Disabled',
                disabled: true,
                onPressed: () {},
              ),
              RdsButton(
                label: 'Loading',
                loading: true,
                onPressed: null,
              ),
              RdsButton(
                label: 'Tonal disabled',
                variant: RdsButtonVariant.tonal,
                disabled: true,
                onPressed: () {},
              ),
              RdsButton(
                label: 'Tonal loading',
                variant: RdsButtonVariant.tonal,
                loading: true,
                onPressed: null,
              ),
              RdsButton(
                label: 'Outlined disabled',
                variant: RdsButtonVariant.outlined,
                disabled: true,
                onPressed: () {},
              ),
              RdsButton(
                label: 'Text disabled',
                variant: RdsButtonVariant.text,
                disabled: true,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// States — single variant demonstrating all states
// ---------------------------------------------------------------------------

Widget _states(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Button States',
            style: rds.headlineMedium.copyWith(color: rds.onSurface),
          ),
          SizedBox(height: rds.space2),
          Text(
            'Interact with the buttons to see hover/press states.',
            style: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
          ),
          SizedBox(height: rds.space6),
          for (final variant in RdsButtonVariant.values) ...[
            Text(
              variant.name,
              style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
            ),
            SizedBox(height: rds.space3),
            Wrap(
              spacing: rds.space3,
              runSpacing: rds.space3,
              children: [
                RdsButton(
                  label: 'Enabled',
                  variant: variant,
                  onPressed: () {},
                ),
                RdsButton(
                  label: 'Disabled',
                  variant: variant,
                  disabled: true,
                  onPressed: () {},
                ),
                RdsButton(
                  label: 'Loading',
                  variant: variant,
                  loading: true,
                  onPressed: null,
                ),
                RdsButton(
                  label: 'Danger',
                  variant: variant,
                  tone: RdsButtonTone.danger,
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: rds.space5),
          ],
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Icon positions
// ---------------------------------------------------------------------------

Widget _iconPositions(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Icon positions',
            style: rds.headlineMedium.copyWith(color: rds.onSurface),
          ),
          SizedBox(height: rds.space6),
          for (final position in RdsButtonIconPosition.values) ...[
            Text(
              position.name,
              style: rds.titleSmall.copyWith(color: rds.onSurfaceVariant),
            ),
            SizedBox(height: rds.space3),
            Wrap(
              spacing: rds.space3,
              runSpacing: rds.space3,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final size in RdsButtonSize.values)
                  RdsButton(
                    label: 'Button (${size.name})',
                    icon: RdsIcons.add,
                    iconPosition: position,
                    size: size,
                    onPressed: () {},
                  ),
              ],
            ),
            SizedBox(height: rds.space5),
          ],
        ],
      ),
    ),
  );
}
