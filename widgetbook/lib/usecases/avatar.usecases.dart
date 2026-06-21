import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

final avatarComponent = WidgetbookComponent(
  name: 'Avatar',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _playground),
    WidgetbookUseCase(name: 'Gallery', builder: _gallery),
  ],
);

// ---------------------------------------------------------------------------
// Playground
// ---------------------------------------------------------------------------

Widget _playground(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final type = context.knobs.list<RdsAvatarType>(
    label: 'Type',
    options: RdsAvatarType.values,
    initialOption: RdsAvatarType.initials,
    labelBuilder: (v) => v.name,
  );
  final size = context.knobs.list<RdsAvatarSize>(
    label: 'Size',
    options: RdsAvatarSize.values,
    initialOption: RdsAvatarSize.md,
    labelBuilder: (v) => v.name,
  );
  final name = context.knobs.string(
    label: 'Name',
    initialValue: 'Jane Doe',
  );
  final imageUrl = context.knobs.string(
    label: 'Image URL',
    initialValue: 'https://i.pravatar.cc/150?img=5',
  );
  final showBackground = context.knobs.boolean(
    label: 'Show background',
    initialValue: true,
  );

  return Scaffold(
    backgroundColor: rds.surface,
    body: Center(
      child: RdsAvatar(
        type: type,
        name: name.isEmpty ? null : name,
        imageUrl: imageUrl.isEmpty ? null : imageUrl,
        icon: RdsIcons.user,
        size: size,
        showBackground: showBackground,
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Gallery
// ---------------------------------------------------------------------------

Widget _gallery(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  const sizes = RdsAvatarSize.values;
  const types = RdsAvatarType.values;

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Types × Sizes grid ----
          Text('All types × all sizes', style: rds.titleSmall.copyWith(color: rds.onSurface)),
          SizedBox(height: rds.space4),
          Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            children: [
              // Header row — size labels
              TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: rds.space4, bottom: rds.space2),
                    child: Text(
                      '',
                      style: rds.labelSmall.copyWith(color: rds.onSurfaceMuted),
                    ),
                  ),
                  ...sizes.map((s) => Padding(
                        padding: EdgeInsets.only(right: rds.space4, bottom: rds.space2),
                        child: Text(
                          s.name,
                          style: rds.labelSmall.copyWith(color: rds.onSurfaceMuted),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ],
              ),
              // Data rows — one per type
              ...types.map((t) => TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: rds.space4, bottom: rds.space4),
                        child: Text(
                          t.name,
                          style: rds.labelSmall.copyWith(color: rds.onSurfaceMuted),
                        ),
                      ),
                      ...sizes.map((s) => Padding(
                            padding: EdgeInsets.only(right: rds.space4, bottom: rds.space4),
                            child: Center(
                              child: RdsAvatar(
                                type: t,
                                name: 'Jane Doe',
                                imageUrl: 'https://i.pravatar.cc/150?img=5',
                                icon: RdsIcons.user,
                                size: s,
                              ),
                            ),
                          )),
                    ],
                  )),
            ],
          ),

          SizedBox(height: rds.space6),

          // ---- Show background on/off ----
          Text('Show background', style: rds.titleSmall.copyWith(color: rds.onSurface)),
          SizedBox(height: rds.space3),
          Wrap(
            spacing: rds.space4,
            runSpacing: rds.space4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _labelledAvatar(
                rds,
                'on',
                RdsAvatar(
                  type: RdsAvatarType.initials,
                  name: 'Jane Doe',
                  size: RdsAvatarSize.md,
                  showBackground: true,
                ),
              ),
              _labelledAvatar(
                rds,
                'off',
                RdsAvatar(
                  type: RdsAvatarType.initials,
                  name: 'Jane Doe',
                  size: RdsAvatarSize.md,
                  showBackground: false,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _labelledAvatar(RdsTheme rds, String label, Widget avatar) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      avatar,
      SizedBox(height: rds.space1),
      Text(label, style: rds.labelSmall.copyWith(color: rds.onSurfaceMuted)),
    ],
  );
}
