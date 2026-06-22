import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:rds/rds.dart';

final checkboxInputComponent = WidgetbookComponent(
  name: 'Checkbox Input',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _playground),
    WidgetbookUseCase(name: 'Gallery', builder: _gallery),
  ],
);

Widget _playground(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final label =
      context.knobs.string(label: 'Label', initialValue: 'I agree to the terms and conditions');
  final supportText =
      context.knobs.string(label: 'Support text', initialValue: '');
  final linkText =
      context.knobs.string(label: 'Link text', initialValue: 'View terms');
  final errorText =
      context.knobs.string(label: 'Error text', initialValue: '');
  final disabled = context.knobs.boolean(label: 'Disabled', initialValue: false);
  final readOnly = context.knobs.boolean(label: 'Read only', initialValue: false);

  return Scaffold(
    backgroundColor: rds.surface,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: EdgeInsets.all(rds.space6),
          child: StatefulBuilder(
            builder: (ctx, setState) {
              bool? value = false;
              return RdsCheckboxInput(
                label: label,
                value: value,
                onChanged: disabled ? null : (v) => setState(() => value = v),
                supportText: supportText.isEmpty ? null : supportText,
                linkText: linkText.isEmpty ? null : linkText,
                onLinkTap: linkText.isEmpty ? null : () {},
                errorText: errorText.isEmpty ? null : errorText,
                disabled: disabled,
                readOnly: readOnly,
              );
            },
          ),
        ),
      ),
    ),
  );
}

Widget _gallery(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(rds.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Checkbox Input States',
              style: rds.headlineMedium.copyWith(color: rds.onSurface)),
          SizedBox(height: rds.space6),
          _GalleryItem(
            label: 'Simple — unchecked',
            description: 'Default unselected state',
            value: false,
          ),
          SizedBox(height: rds.space4),
          _GalleryItem(
            label: 'Simple — checked',
            description: 'Default selected state',
            value: true,
          ),
          SizedBox(height: rds.space4),
          _GalleryItem(
            label: 'With support text and link',
            description: 'Rich variant with description and action link',
            value: false,
            supportText:
                'We send one email per week with the latest health updates.',
            linkText: 'View sample email',
          ),
          SizedBox(height: rds.space4),
          _GalleryItemStatic(
            label: 'Error state',
            description: 'Required field not checked',
            value: false,
            errorText: 'You must agree to the terms to continue.',
          ),
          SizedBox(height: rds.space4),
          _GalleryItemStatic(
            label: 'Disabled — unchecked',
            description: 'Cannot be interacted with',
            value: false,
            disabled: true,
          ),
          SizedBox(height: rds.space4),
          _GalleryItemStatic(
            label: 'Disabled — checked',
            description: 'Pre-selected, cannot be changed',
            value: true,
            disabled: true,
          ),
          SizedBox(height: rds.space4),
          _GalleryItemStatic(
            label: 'Read only — checked',
            description: 'Value visible but not editable',
            value: true,
            readOnly: true,
          ),
        ],
      ),
    ),
  );
}

class _GalleryItem extends StatefulWidget {
  final String label;
  final String description;
  final bool value;
  final String? supportText;
  final String? linkText;

  const _GalleryItem({
    required this.label,
    required this.description,
    required this.value,
    this.supportText,
    this.linkText,
  });

  @override
  State<_GalleryItem> createState() => _GalleryItemState();
}

class _GalleryItemState extends State<_GalleryItem> {
  late bool? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return _GalleryCard(
      description: widget.description,
      child: RdsCheckboxInput(
        label: widget.label,
        value: _value,
        onChanged: (v) => setState(() => _value = v),
        supportText: widget.supportText,
        linkText: widget.linkText,
        onLinkTap: widget.linkText != null ? () {} : null,
      ),
    );
  }
}

class _GalleryItemStatic extends StatelessWidget {
  final String label;
  final String description;
  final bool? value;
  final String? errorText;
  final bool disabled;
  final bool readOnly;

  const _GalleryItemStatic({
    required this.label,
    required this.description,
    required this.value,
    this.errorText,
    this.disabled = false,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return _GalleryCard(
      description: description,
      child: RdsCheckboxInput(
        label: label,
        value: value,
        onChanged: disabled ? null : (_) {},
        errorText: errorText,
        disabled: disabled,
        readOnly: readOnly,
      ),
    );
  }
}

class _GalleryCard extends StatelessWidget {
  final String description;
  final Widget child;

  const _GalleryCard({required this.description, required this.child});

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
          Text(description,
              style: rds.labelSmall.copyWith(color: rds.onSurfaceMuted)),
          SizedBox(height: rds.space3),
          child,
        ],
      ),
    );
  }
}
