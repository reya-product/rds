import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

final dropdownPopupComponent = WidgetbookComponent(
  name: 'Dropdown Popup',
  useCases: [
    WidgetbookUseCase(name: 'Playground', builder: _playground),
    WidgetbookUseCase(name: 'With icons', builder: _withIcons),
    WidgetbookUseCase(name: 'Searchable', builder: _searchable),
    WidgetbookUseCase(name: 'Long list', builder: _longList),
  ],
);

// ---------------------------------------------------------------------------
// Demo items
// ---------------------------------------------------------------------------

const _demoItems = [
  RdsDropdownItem(
    value: 'general',
    label: 'General Practice',
    supportingText: 'Primary care',
  ),
  RdsDropdownItem(
    value: 'cardiology',
    label: 'Cardiology',
    supportingText: 'Heart & circulatory',
  ),
  RdsDropdownItem(
    value: 'dermatology',
    label: 'Dermatology',
    supportingText: 'Skin conditions',
  ),
  RdsDropdownItem(
    value: 'endocrinology',
    label: 'Endocrinology',
    supportingText: 'Hormones & metabolism',
  ),
  RdsDropdownItem(
    value: 'gastro',
    label: 'Gastroenterology',
    supportingText: 'Digestive system',
  ),
  RdsDropdownItem(
    value: 'neurology',
    label: 'Neurology',
    supportingText: 'Brain & nervous system',
  ),
  RdsDropdownItem(
    value: 'oncology',
    label: 'Oncology',
    supportingText: 'Cancer care',
    disabled: true,
  ),
  RdsDropdownItem(
    value: 'orthopedics',
    label: 'Orthopedics',
    supportingText: 'Bones & joints',
  ),
];

const _demoItemsWithIcons = [
  RdsDropdownItem(
    value: 'patient',
    label: 'Patient',
    leadingIcon: RdsIcons.user,
  ),
  RdsDropdownItem(
    value: 'clinician',
    label: 'Clinician',
    leadingIcon: RdsIcons.settings,
  ),
  RdsDropdownItem(
    value: 'coordinator',
    label: 'Care Coordinator',
    leadingIcon: RdsIcons.info,
  ),
  RdsDropdownItem(
    value: 'admin',
    label: 'Administrator',
    leadingIcon: RdsIcons.edit,
  ),
  RdsDropdownItem(
    value: 'viewer',
    label: 'Read-only Viewer',
    leadingIcon: RdsIcons.search,
    disabled: true,
  ),
];

List<RdsDropdownItem> _buildLongList() {
  const names = [
    'Dr. Sarah Chen',
    'Dr. Marcus Lee',
    'Dr. Aisha Patel',
    'Dr. James Wright',
    'Dr. Fatima Al-Rashid',
    'Dr. Lucas Oliveira',
    'Dr. Mei-Ling Zhou',
    'Dr. David Okonkwo',
    'Dr. Priya Sharma',
    'Dr. Carlos Mendes',
    'Dr. Ingrid Larsen',
    'Dr. Yuki Tanaka',
    'Dr. Amara Diallo',
    'Dr. Ethan Kowalski',
    'Dr. Sofia Reyes',
    'Dr. Noah Bergström',
    'Dr. Layla Hassan',
    'Dr. Kofi Mensah',
    'Dr. Natasha Ivanova',
    'Dr. Ben Nakamura',
  ];
  return names
      .map(
        (name) => RdsDropdownItem(
          value: name.toLowerCase().replaceAll(' ', '_'),
          label: name,
          supportingText: 'General Practice',
        ),
      )
      .toList();
}

// ---------------------------------------------------------------------------
// Playground
// ---------------------------------------------------------------------------

Widget _playground(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  final showDividers = context.knobs.boolean(
    label: 'Show dividers',
    initialValue: false,
  );
  final searchable = context.knobs.boolean(
    label: 'Searchable',
    initialValue: false,
  );
  final maxHeight = context.knobs.double.slider(
    label: 'Max height',
    initialValue: 320,
    min: 160,
    max: 480,
  );

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(rds.space6),
        child: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dropdown Popup',
                style: rds.titleSmall.copyWith(color: rds.onSurface),
              ),
              SizedBox(height: rds.space3),
              _PlaygroundPopup(
                items: _demoItems,
                showDividers: showDividers,
                searchable: searchable,
                maxHeight: maxHeight,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Stateful helper for the playground so selectedValues updates correctly.
class _PlaygroundPopup extends StatefulWidget {
  final List<RdsDropdownItem> items;
  final bool showDividers;
  final bool searchable;
  final double maxHeight;

  const _PlaygroundPopup({
    required this.items,
    required this.showDividers,
    required this.searchable,
    required this.maxHeight,
  });

  @override
  State<_PlaygroundPopup> createState() => _PlaygroundPopupState();
}

class _PlaygroundPopupState extends State<_PlaygroundPopup> {
  final Set<dynamic> _selected = {};

  @override
  Widget build(BuildContext context) {
    return RdsDropdownPopup(
      items: widget.items,
      selectedValues: _selected,
      onItemSelected: (v) {
        setState(() {
          if (_selected.contains(v)) {
            _selected.remove(v);
          } else {
            _selected.add(v);
          }
        });
      },
      showDividers: widget.showDividers,
      searchable: widget.searchable,
      maxHeight: widget.maxHeight,
    );
  }
}

// ---------------------------------------------------------------------------
// With icons
// ---------------------------------------------------------------------------

Widget _withIcons(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(rds.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'With icons',
              style: rds.titleSmall.copyWith(color: rds.onSurface),
            ),
            SizedBox(height: rds.space3),
            SizedBox(
              width: 280,
              child: _WithIconsPopup(items: _demoItemsWithIcons),
            ),
          ],
        ),
      ),
    ),
  );
}

class _WithIconsPopup extends StatefulWidget {
  final List<RdsDropdownItem> items;

  const _WithIconsPopup({required this.items});

  @override
  State<_WithIconsPopup> createState() => _WithIconsPopupState();
}

class _WithIconsPopupState extends State<_WithIconsPopup> {
  dynamic _selected = 'patient';

  @override
  Widget build(BuildContext context) {
    return RdsDropdownPopup(
      items: widget.items,
      selectedValues: {_selected},
      onItemSelected: (v) => setState(() => _selected = v),
      showDividers: true,
    );
  }
}

// ---------------------------------------------------------------------------
// Searchable
// ---------------------------------------------------------------------------

Widget _searchable(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(rds.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Searchable',
              style: rds.titleSmall.copyWith(color: rds.onSurface),
            ),
            SizedBox(height: rds.space3),
            SizedBox(
              width: 320,
              child: _SearchablePopup(items: _demoItems),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SearchablePopup extends StatefulWidget {
  final List<RdsDropdownItem> items;

  const _SearchablePopup({required this.items});

  @override
  State<_SearchablePopup> createState() => _SearchablePopupState();
}

class _SearchablePopupState extends State<_SearchablePopup> {
  final Set<dynamic> _selected = {};

  @override
  Widget build(BuildContext context) {
    return RdsDropdownPopup(
      items: widget.items,
      selectedValues: _selected,
      onItemSelected: (v) {
        setState(() {
          if (_selected.contains(v)) {
            _selected.remove(v);
          } else {
            _selected.add(v);
          }
        });
      },
      searchable: true,
      showDividers: true,
      maxHeight: 360,
    );
  }
}

// ---------------------------------------------------------------------------
// Long list (scrolling)
// ---------------------------------------------------------------------------

Widget _longList(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;

  return Scaffold(
    backgroundColor: rds.surfaceVariant,
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(rds.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Long list (20 items — scroll to see more)',
              style: rds.titleSmall.copyWith(color: rds.onSurface),
            ),
            SizedBox(height: rds.space3),
            SizedBox(
              width: 320,
              child: _LongListPopup(items: _buildLongList()),
            ),
          ],
        ),
      ),
    ),
  );
}

class _LongListPopup extends StatefulWidget {
  final List<RdsDropdownItem> items;

  const _LongListPopup({required this.items});

  @override
  State<_LongListPopup> createState() => _LongListPopupState();
}

class _LongListPopupState extends State<_LongListPopup> {
  dynamic _selected;

  @override
  Widget build(BuildContext context) {
    return RdsDropdownPopup(
      items: widget.items,
      selectedValues: _selected != null ? {_selected} : {},
      onItemSelected: (v) => setState(() => _selected = v),
      showDividers: false,
      maxHeight: 320,
    );
  }
}
