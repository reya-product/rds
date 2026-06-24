import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

// ---------------------------------------------------------------------------
// T3 Organisms — wired 2026-06-22
import 'usecases/card.usecases.dart';
import 'usecases/dropdown_field.usecases.dart';
import 'usecases/combobox_field.usecases.dart';
import 'usecases/compact_table.usecases.dart';
import 'usecases/overlay.usecases.dart';

// T2b List-based — wired 2026-06-22
import 'usecases/dropdown_popup.usecases.dart';
import 'usecases/list.usecases.dart';
import 'usecases/list_inputs.usecases.dart';

// T3 Organisms — forms
import 'usecases/onboard_member_form.usecases.dart';

// T2a Molecules — wired 2026-06-22
import 'usecases/page_header.usecases.dart';
import 'usecases/segmented_control_input.usecases.dart';
import 'usecases/checkbox_input.usecases.dart';
import 'usecases/date_field.usecases.dart';
import 'usecases/list_item.usecases.dart';
import 'usecases/field_group.usecases.dart';
import 'usecases/field_uploader.usecases.dart';

// T1 Atoms — wired 2026-06-22
// ---------------------------------------------------------------------------
import 'usecases/button.usecases.dart';
import 'usecases/button_group.usecases.dart';
import 'usecases/segmented_buttons.usecases.dart';
import 'usecases/badge.usecases.dart';
import 'usecases/avatar.usecases.dart';
import 'usecases/tooltip.usecases.dart';
import 'usecases/input_chip.usecases.dart';
import 'usecases/checkbox.usecases.dart';
import 'usecases/radio.usecases.dart';
import 'usecases/toggle_switch.usecases.dart';
import 'usecases/toast.usecases.dart';
import 'usecases/tabs.usecases.dart';
import 'usecases/vertical_tabs.usecases.dart';
import 'usecases/container_tabs.usecases.dart';
import 'usecases/sub_header.usecases.dart';
import 'usecases/label_value_pair.usecases.dart';
import 'usecases/date_picker.usecases.dart';
import 'usecases/text_field.usecases.dart';

void main() => runApp(const RdsWidgetbook());

class RdsWidgetbook extends StatelessWidget {
  const RdsWidgetbook({super.key});

  // Provide the light RDS theme at the app root so use-case builders always
  // have a non-null RdsTheme extension even before ThemeAddon applies its
  // selection (Widgetbook 3.8+ changed when addons wrap the canvas context).
  static final _defaultTheme = RdsBrandThemes.reya.buildThemeData(Brightness.light);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _defaultTheme,
      child: Widgetbook.material(
      // ignore: avoid_redundant_argument_values
      directories: [
        WidgetbookComponent(
          name: '_Canvas test',
          useCases: [
            WidgetbookUseCase(
              name: 'Red box',
              builder: (context) => Container(
                color: const Color(0xFFE53935),
                width: 200,
                height: 200,
                alignment: Alignment.center,
                child: const Text('Canvas works', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
        WidgetbookFolder(
          name: 'Foundation',
          children: [
            WidgetbookComponent(
              name: 'Color palette',
              useCases: [
                WidgetbookUseCase(
                  name: 'Semantic roles — light',
                  builder: (context) => const _ColorPalettePreview(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Type scale',
              useCases: [
                WidgetbookUseCase(
                  name: 'All styles',
                  builder: (context) => const _TypeScalePreview(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'Spacing',
              useCases: [
                WidgetbookUseCase(
                  name: 'Scale',
                  builder: (context) => const _SpacingPreview(),
                ),
              ],
            ),
          ],
        ),
        WidgetbookFolder(
          name: 'T1 Atoms',
          children: [
            WidgetbookFolder(
              name: 'Buttons',
              children: [
                buttonComponent,
                buttonGroupComponent,
                segmentedButtonsComponent,
              ],
            ),
            WidgetbookFolder(
              name: 'Display',
              children: [
                badgeComponent,
                avatarComponent,
                tooltipComponent,
                inputChipComponent,
                subHeaderComponent,
              ],
            ),
            WidgetbookFolder(
              name: 'Controls',
              children: [
                checkboxComponent,
                radioComponent,
                toggleSwitchComponent,
                toastComponent,
              ],
            ),
            WidgetbookFolder(
              name: 'Navigation',
              children: [
                tabsComponent,
                verticalTabsComponent,
                containerTabsComponent,
              ],
            ),
            WidgetbookFolder(
              name: 'Date & Time',
              children: [
                datePickerComponent,
              ],
            ),
            WidgetbookFolder(
              name: 'Fields',
              children: [
                textFieldComponent,
                textAreaComponent,
                passwordFieldComponent,
                searchBarComponent,
              ],
            ),
          ],
        ),
        WidgetbookFolder(
          name: 'T2a Molecules',
          children: [
            WidgetbookFolder(
              name: 'Headers',
              children: [
                pageHeaderComponent,
              ],
            ),
            WidgetbookFolder(
              name: 'Form inputs',
              children: [
                segmentedControlInputComponent,
                checkboxInputComponent,
                dateFieldComponent,
                timeFieldComponent,
                dateTimeFieldComponent,
                fieldGroupComponent,
                fieldUploaderComponent,
              ],
            ),
            WidgetbookFolder(
              name: 'List',
              children: [
                listItemComponent,
              ],
            ),
          ],
        ),
        WidgetbookFolder(
          name: 'T2b List-based',
          children: [
            WidgetbookFolder(
              name: 'Popups & lists',
              children: [
                dropdownPopupComponent,
                listComponent,
              ],
            ),
            WidgetbookFolder(
              name: 'List inputs',
              children: [
                multiSelectListInputComponent,
                singleSelectListInputComponent,
                toggleListInputComponent,
              ],
            ),
          ],
        ),
        WidgetbookFolder(
          name: 'T3 Organisms',
          children: [
            WidgetbookFolder(
              name: 'Content',
              children: [
                cardComponent,
              ],
            ),
            WidgetbookFolder(
              name: 'Data',
              children: [
                compactTableComponent,
                labelValuePairComponent,
              ],
            ),
            WidgetbookFolder(
              name: 'Overlays',
              children: [
                overlayComponent,
              ],
            ),
            WidgetbookFolder(
              name: 'Form inputs',
              children: [
                dropdownFieldComponent,
                comboboxFieldComponent,
                onboardMemberFormComponent,
              ],
            ),
          ],
        ),
      ],
      addons: [
        ThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Reya · Light',
              data: RdsBrandThemes.reya.buildThemeData(Brightness.light),
            ),
            WidgetbookTheme(
              name: 'Reya · Dark',
              data: RdsBrandThemes.reya.buildThemeData(Brightness.dark),
            ),
            WidgetbookTheme(
              name: 'IHL · Light',
              data: RdsBrandThemes.ihl.buildThemeData(Brightness.light),
            ),
            WidgetbookTheme(
              name: 'IHL · Dark',
              data: RdsBrandThemes.ihl.buildThemeData(Brightness.dark),
            ),
          ],
          themeBuilder: (context, theme, child) {
            return Theme(data: theme, child: child);
          },
        ),
      ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Foundation preview widgets
// ---------------------------------------------------------------------------

class _ColorPalettePreview extends StatelessWidget {
  const _ColorPalettePreview();

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    final roles = <(String, Color, Color)>[
      // Surfaces
      ('surface', rds.surface, rds.onSurface),
      ('surface-variant', rds.surfaceVariant, rds.onSurface),
      ('surface-container', rds.surfaceContainer, rds.onSurface),
      ('surface-container-low', rds.surfaceContainerLow, rds.onSurface),
      ('surface-container-high', rds.surfaceContainerHigh, rds.onSurface),
      ('surface-bright', rds.surfaceBright, rds.onSurface),
      ('surface-emphasized', rds.surfaceContainerEmphasized, rds.inverseOnSurface),
      // Primary
      ('primary', rds.primary, rds.onPrimary),
      ('primary-container', rds.primaryContainer, rds.onPrimaryContainer),
      ('primary-variant', rds.primaryVariant, rds.onPrimaryContainer),
      // Semantic
      ('danger', rds.danger, rds.onDanger),
      ('danger-container', rds.dangerContainer, rds.onDangerContainer),
      ('warning', rds.warning, rds.onWarning),
      ('warning-container', rds.warningContainer, rds.onWarningContainer),
      ('success', rds.success, rds.onSuccess),
      ('success-container', rds.successContainer, rds.onSuccessContainer),
      ('neutral', rds.neutral, Colors.white),
      ('neutral-container', rds.neutralContainer, rds.onNeutralContainer),
      // Outline
      ('outline', rds.outline, rds.onSurface),
      ('outline-variant', rds.outlineVariant, rds.onSurface),
      ('outline-lowest', rds.outlineLowest, rds.onSurface),
      // Extra containers
      ('mandatory-container', rds.mandatoryContainer, rds.onSurface),
      ('pink-container', rds.pinkContainer, rds.onSurface),
      ('purple-container', rds.purpleContainer, rds.onSurface),
      ('blue-container', rds.blueContainer, rds.onSurface),
      ('yellow-container', rds.yellowContainer, rds.onSurface),
      // Icon colors
      ('icon-on-bg', rds.iconOnBackground, Colors.white),
      ('icon-neutral', rds.iconNeutral, Colors.white),
      ('icon-error', rds.iconError, Colors.white),
      ('icon-warning', rds.iconWarning, Colors.white),
      ('icon-success', rds.iconSuccess, Colors.white),
      ('icon-blue', rds.iconBlue, Colors.white),
      ('icon-purple', rds.iconPurple, Colors.white),
      ('icon-pink', rds.iconPink, Colors.white),
      ('icon-yellow', rds.iconYellow, Colors.white),
      // Graph
      ('graph-primary', rds.graphPrimary, Colors.white),
      ('graph-secondary', rds.graphSecondary, Colors.white),
    ];

    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(rds.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Semantic Color Roles',
              style: rds.headlineMedium.copyWith(color: rds.onSurface),
            ),
            SizedBox(height: rds.space2),
            Text(
              'All components read these semantic roles — never raw hex values.',
              style: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
            ),
            SizedBox(height: rds.space6),
            Wrap(
              spacing: rds.space3,
              runSpacing: rds.space3,
              children: roles
                  .map((r) => _ColorChip(name: r.$1, background: r.$2, text: r.$3))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  final String name;
  final Color background;
  final Color text;

  const _ColorChip({
    required this.name,
    required this.background,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Container(
      width: 148,
      height: 76,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(rds.radiusMd),
        border: Border.all(color: Colors.black12),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: rds.space2),
      child: Text(
        name,
        style: TextStyle(
          color: text,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
      ),
    );
  }
}

class _TypeScalePreview extends StatelessWidget {
  const _TypeScalePreview();

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    final styles = <(String, TextStyle)>[
      ('display-large', rds.displayLarge),
      ('display-medium', rds.displayMedium),
      ('display-small', rds.displaySmall),
      ('headline-large', rds.headlineLarge),
      ('headline-medium', rds.headlineMedium),
      ('headline-small', rds.headlineSmall),
      ('title-large', rds.titleLarge),
      ('title-medium', rds.titleMedium),
      ('title-small', rds.titleSmall),
      ('body-large', rds.bodyLarge),
      ('body-medium', rds.bodyMedium),
      ('body-small', rds.bodySmall),
      ('label-large', rds.labelLarge),
      ('label-medium', rds.labelMedium),
      ('label-small', rds.labelSmall),
    ];

    return Scaffold(
      backgroundColor: rds.surface,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(rds.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: styles.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: rds.space4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    child: Text(
                      entry.$1,
                      style: rds.bodySmall.copyWith(
                        color: rds.onSurfaceMuted,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'The quick brown fox',
                      style: entry.$2.copyWith(color: rds.onSurface),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SpacingPreview extends StatelessWidget {
  const _SpacingPreview();

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    final tokens = <(String, double)>[
      ('space-0', rds.space0),
      ('space-1 · 4px', rds.space1),
      ('space-2 · 8px', rds.space2),
      ('space-3 · 12px', rds.space3),
      ('space-4 · 16px', rds.space4),
      ('space-5 · 20px', rds.space5),
      ('space-6 · 24px', rds.space6),
      ('space-8 · 32px', rds.space8),
      ('space-10 · 40px', rds.space10),
      ('space-12 · 48px', rds.space12),
      ('space-16 · 64px', rds.space16),
    ];

    return Scaffold(
      backgroundColor: rds.surface,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(rds.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spacing Scale',
              style: rds.headlineMedium.copyWith(color: rds.onSurface),
            ),
            SizedBox(height: rds.space2),
            Text(
              'Base unit: 4px. All values are multiples of 4.',
              style: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
            ),
            SizedBox(height: rds.space6),
            ...tokens.map((t) {
              return Padding(
                padding: EdgeInsets.only(bottom: rds.space3),
                child: Row(
                  children: [
                    SizedBox(
                      width: 140,
                      child: Text(
                        t.$1,
                        style: rds.bodySmall.copyWith(
                          color: rds.onSurfaceMuted,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    Container(
                      width: t.$2.clamp(2.0, 200.0),
                      height: 20,
                      decoration: BoxDecoration(
                        color: rds.primaryContainer,
                        borderRadius: BorderRadius.circular(rds.radiusXs),
                        border: Border.all(color: rds.primary.withOpacity(0.4)),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
