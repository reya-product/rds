import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

final pageHeaderComponent = WidgetbookComponent(
  name: 'Page Header',
  useCases: [
    // -----------------------------------------------------------------------
    // Example 1 — 64px page header: title + tonal action + icon buttons
    // -----------------------------------------------------------------------
    WidgetbookUseCase(
      name: 'Example 1 — Page header (64px)',
      builder: (context) {
        final title = context.knobs.string(
          label: 'Title',
          initialValue: 'Patient Record',
        );
        final actionLabel = context.knobs.string(
          label: 'Action button label',
          initialValue: 'ADD NOTE',
        );
        final rds = Theme.of(context).extension<RdsTheme>()!;
        return _HeaderPreview(
          child: RdsPageHeader(
            height: 64,
            title: title,
            actions: [
              IconButton(
                icon: Icon(RdsIcons.search, size: 20, color: rds.onSurface),
                onPressed: () {},
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: Icon(RdsIcons.filter, size: 20, color: rds.onSurface),
                onPressed: () {},
                visualDensity: VisualDensity.compact,
              ),
              SizedBox(width: rds.space1),
              RdsButton(
                label: actionLabel,
                variant: RdsButtonVariant.tonal,
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    ),

    // -----------------------------------------------------------------------
    // Example 2 — Tile Bar (56px): logo + patient info + badge + icon buttons
    //             Avatar with edit toggle
    // -----------------------------------------------------------------------
    WidgetbookUseCase(
      name: 'Example 2 — Tile bar with avatar edit',
      builder: (context) {
        final patientName = context.knobs.string(
          label: 'Patient name',
          initialValue: 'Juliana Crain',
        );
        final patientInfo = context.knobs.string(
          label: 'Patient info',
          initialValue: '38Y, F, She/Her/Hers',
        );
        final badgeLabel = context.knobs.string(
          label: 'Badge label',
          initialValue: 'CONCIERGE +2',
        );
        final showEditBadge = context.knobs.boolean(
          label: 'Avatar: show edit badge',
          initialValue: true,
        );
        final rds = Theme.of(context).extension<RdsTheme>()!;
        return _HeaderPreview(
          child: RdsPageHeader(
            leading: RdsAvatar(
              type: RdsAvatarType.initials,
              name: patientName,
              size: RdsAvatarSize.sm,
              onEdit: showEditBadge ? () {} : null,
            ),
            title: patientName,
            subtitle: patientInfo,
            badge: badgeLabel.isEmpty
                ? null
                : Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: rds.space2,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: rds.primaryContainer,
                      borderRadius: BorderRadius.circular(rds.radiusSm),
                    ),
                    child: Text(
                      badgeLabel,
                      style: rds.labelSmall.copyWith(
                        color: rds.onPrimaryContainer,
                      ),
                    ),
                  ),
            actions: [
              IconButton(
                icon: Icon(RdsIcons.notification, size: 20, color: rds.onSurface),
                onPressed: () {},
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: Icon(RdsIcons.settings, size: 20, color: rds.onSurface),
                onPressed: () {},
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        );
      },
    ),

    // -----------------------------------------------------------------------
    // Example 3 — Global Header (56px): logo + patient ID + text buttons +
    //             icon buttons + tonal action + profile icon
    // -----------------------------------------------------------------------
    WidgetbookUseCase(
      name: 'Example 3 — Global header',
      builder: (context) {
        final patientName = context.knobs.string(
          label: 'Patient name',
          initialValue: 'Juliana Crain · #PT-2024-0042',
        );
        final rds = Theme.of(context).extension<RdsTheme>()!;
        return _HeaderPreview(
          child: RdsPageHeader(
            leading: _LogoPlaceholder(),
            title: patientName,
            actions: [
              _TextHeaderButton(label: 'OVERVIEW', rds: rds, onTap: () {}),
              _TextHeaderButton(label: 'TIMELINE', rds: rds, onTap: () {}),
              _TextHeaderButton(label: 'DOCUMENTS', rds: rds, onTap: () {}),
              SizedBox(width: rds.space1),
              IconButton(
                icon: Icon(RdsIcons.search, size: 20, color: rds.onSurface),
                onPressed: () {},
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: Icon(RdsIcons.notification, size: 20, color: rds.onSurface),
                onPressed: () {},
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: Icon(RdsIcons.settings, size: 20, color: rds.onSurface),
                onPressed: () {},
                visualDensity: VisualDensity.compact,
              ),
              SizedBox(width: rds.space1),
              RdsButton(
                label: 'END VISIT',
                variant: RdsButtonVariant.tonal,
                onPressed: () {},
              ),
              SizedBox(width: rds.space2),
              RdsAvatar(
                type: RdsAvatarType.initials,
                name: 'Dr Smith',
                size: RdsAvatarSize.sm,
              ),
            ],
          ),
        );
      },
    ),

    // -----------------------------------------------------------------------
    // Interactive knobs playground
    // -----------------------------------------------------------------------
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final title = context.knobs.string(
          label: 'Title',
          initialValue: 'Page Title',
        );
        final subtitle = context.knobs.string(
          label: 'Subtitle (empty = hidden)',
          initialValue: '',
        );
        final showLeading = context.knobs.boolean(
          label: 'Show leading avatar',
          initialValue: false,
        );
        final showBadge = context.knobs.boolean(
          label: 'Show badge',
          initialValue: false,
        );
        final height = context.knobs.double.slider(
          label: 'Height',
          initialValue: 56,
          min: 48,
          max: 80,
        );
        final rds = Theme.of(context).extension<RdsTheme>()!;
        return _HeaderPreview(
          child: RdsPageHeader(
            height: height,
            leading: showLeading
                ? RdsAvatar(
                    type: RdsAvatarType.initials,
                    name: title,
                    size: RdsAvatarSize.sm,
                  )
                : null,
            title: title,
            subtitle: subtitle.isEmpty ? null : subtitle,
            badge: showBadge
                ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: rds.space2,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: rds.primaryContainer,
                      borderRadius: BorderRadius.circular(rds.radiusSm),
                    ),
                    child: Text(
                      'BADGE',
                      style: rds.labelSmall
                          .copyWith(color: rds.onPrimaryContainer),
                    ),
                  )
                : null,
            actions: [
              IconButton(
                icon: Icon(RdsIcons.search, size: 20, color: rds.onSurface),
                onPressed: () {},
                visualDensity: VisualDensity.compact,
              ),
              RdsButton(
                label: 'ACTION',
                variant: RdsButtonVariant.tonal,
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    ),
  ],
);

// ---------------------------------------------------------------------------
// Local helpers
// ---------------------------------------------------------------------------

class _HeaderPreview extends StatelessWidget {
  const _HeaderPreview({required this.child});
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

class _TextHeaderButton extends StatefulWidget {
  const _TextHeaderButton({
    required this.label,
    required this.rds,
    required this.onTap,
  });
  final String label;
  final RdsTheme rds;
  final VoidCallback onTap;

  @override
  State<_TextHeaderButton> createState() => _TextHeaderButtonState();
}

class _TextHeaderButtonState extends State<_TextHeaderButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.rds.space2),
          child: Text(
            widget.label,
            style: widget.rds.labelMedium.copyWith(
              color: _hovered
                  ? widget.rds.primary
                  : widget.rds.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: rds.primaryContainer,
        borderRadius: BorderRadius.circular(rds.radiusSm),
      ),
      alignment: Alignment.center,
      child: Text(
        'IHL',
        style: rds.labelSmall.copyWith(color: rds.onPrimaryContainer),
      ),
    );
  }
}
