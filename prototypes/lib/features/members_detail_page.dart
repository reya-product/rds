import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:rds/rds.dart';

// ---------------------------------------------------------------------------
// MembersDetailPage
//
// Full-screen prototype for the "Member's Detail" view.
// Three-column layout: member info (left), appointments (centre), documents
// (right) — all independently scrollable.
// ---------------------------------------------------------------------------

class MembersDetailPage extends StatefulWidget {
  const MembersDetailPage({super.key});

  @override
  State<MembersDetailPage> createState() => _MembersDetailPageState();
}

class _MembersDetailPageState extends State<MembersDetailPage> {
  int _leftTab = 0;
  int _centerTab = 0;
  int _rightTab = 0;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1440),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Tile bar ──────────────────────────────────────────────────
              _TileBar(rds: rds),

              // ── Page header ───────────────────────────────────────────────
              _PageHeader(rds: rds),

              // ── Three-column body ─────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Left column
                      Expanded(
                        child: _LeftPanel(
                          selectedTab: _leftTab,
                          onTabChanged: (i) => setState(() => _leftTab = i),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Centre column
                      Expanded(
                        child: _MiddlePanel(
                          selectedTab: _centerTab,
                          onTabChanged: (i) => setState(() => _centerTab = i),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Right column
                      Expanded(
                        child: _RightPanel(
                          selectedTab: _rightTab,
                          onTabChanged: (i) => setState(() => _rightTab = i),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _TileBar  (56px, white, bottom border)
// ---------------------------------------------------------------------------

class _TileBar extends StatelessWidget {
  const _TileBar({required this.rds});

  final RdsTheme rds;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: rds.surface,
        border: Border(bottom: BorderSide(color: rds.outlineVariant, width: 1)),
      ),
      padding: EdgeInsets.symmetric(horizontal: rds.space4),
      child: Row(
        children: [
          // Avatar + name
          RdsAvatar(
            type: RdsAvatarType.initials,
            name: 'Juliana Crain',
            size: RdsAvatarSize.sm,
            onEdit: () {},
          ),
          SizedBox(width: rds.space3),
          Text(
            'Juliana Crain, 38Y, F',
            style: rds.titleSmall.copyWith(color: rds.onSurface),
          ),

          const Spacer(),

          // MEDICAL DASHBOARD text link
          _TextLink(
            label: 'MEDICAL DASHBOARD',
            rds: rds,
            onTap: () {},
          ),
          Container(
            width: 1,
            height: 20,
            color: rds.outlineVariant,
            margin: EdgeInsets.symmetric(horizontal: rds.space3),
          ),

          // ATHENA PROFILE text link with open-in-new icon
          _TextLink(
            label: 'ATHENA PROFILE',
            trailingIcon: Symbols.open_in_new,
            rds: rds,
            onTap: () {},
          ),
          SizedBox(width: rds.space2),

          // Close icon button
          Tooltip(
            message: 'Close',
            child: IconButton(
              icon: Icon(
                RdsIcons.close,
                size: RdsIconSize.md,
                color: rds.onSurfaceVariant,
              ),
              onPressed: () {},
              splashRadius: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _PageHeader  (64px, white, bottom border)
// ---------------------------------------------------------------------------

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.rds});

  final RdsTheme rds;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: rds.surface,
        border: Border(bottom: BorderSide(color: rds.outlineVariant, width: 1)),
      ),
      padding: EdgeInsets.symmetric(horizontal: rds.space4),
      child: Row(
        children: [
          Text(
            "Member's Detail Page",
            style: rds.headlineSmall.copyWith(
              color: rds.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // SCHEDULE/BUY tonal button
          RdsButton(
            label: 'SCHEDULE/BUY',
            variant: RdsButtonVariant.tonal,
            onPressed: () {},
          ),
          SizedBox(width: rds.space2),
          // More vert icon button
          Tooltip(
            message: 'More options',
            child: IconButton(
              icon: Icon(
                Symbols.more_vert,
                size: RdsIconSize.md,
                color: rds.onSurfaceVariant,
              ),
              onPressed: () {},
              splashRadius: 20,
            ),
          ),
          // Cart icon button with "1" badge overlay
          Stack(
            clipBehavior: Clip.none,
            children: [
              Tooltip(
                message: 'Cart',
                child: IconButton(
                  icon: Icon(
                    Symbols.shopping_cart,
                    size: RdsIconSize.md,
                    color: rds.onSurfaceVariant,
                  ),
                  onPressed: () {},
                  splashRadius: 20,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: rds.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '1',
                    style: rds.labelSmall.copyWith(
                      color: rds.onPrimary,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _LeftPanel
// ---------------------------------------------------------------------------

class _LeftPanel extends StatelessWidget {
  const _LeftPanel({
    required this.selectedTab,
    required this.onTabChanged,
  });

  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return _ColumnShell(
      rds: rds,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RdsContainerTabs(
            tabs: const [
              RdsTabItem(label: 'OVERVIEW'),
              RdsTabItem(label: 'MEMBERSHIP'),
              RdsTabItem(label: 'PMT & GIFT CARDS'),
              RdsTabItem(label: 'TEAM'),
            ],
            selectedIndex: selectedTab,
            onChanged: onTabChanged,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Contact Information
                  RdsSubHeader(
                    title: 'Contact Information',
                    actionLabel: 'EDIT',
                    onAction: () {},
                  ),
                  RdsLabelValueList(
                    items: const [
                      RdsLabelValueItem(label: 'FIRST NAME', value: 'Juliana'),
                      RdsLabelValueItem(label: 'MIDDLE NAME'),
                      RdsLabelValueItem(label: 'LAST NAME', value: 'Crain'),
                      RdsLabelValueItem(label: 'D.O.B', value: '02 Aug 1985'),
                      RdsLabelValueItem(
                        label: 'SEX ASSIGNED AT BIRTH',
                        value: 'Female',
                      ),
                      RdsLabelValueItem(
                        label: 'PREFERRED PRONOUNS',
                        value: 'She/ Her',
                      ),
                      RdsLabelValueItem(
                        label: 'MOBILE #',
                        value: '+1 718-479-7777',
                        isLink: true,
                      ),
                      RdsLabelValueItem(label: 'WORK PHONE #'),
                      RdsLabelValueItem(
                        label: 'EMAIL',
                        value: 'juliana@gmail.com',
                        isLink: true,
                      ),
                      RdsLabelValueItem(
                        label: 'STREET ADDRESS',
                        value: '1444 Queens Ave',
                      ),
                      RdsLabelValueItem(label: 'CITY', value: 'LA'),
                      RdsLabelValueItem(
                        label: 'STATE',
                        value: 'California',
                      ),
                      RdsLabelValueItem(label: 'ZIP'),
                    ],
                  ),
                  SizedBox(height: rds.space2),
                  // Emergency Contact
                  RdsSubHeader(
                    title: 'Emergency Contact',
                    actionLabel: 'EDIT',
                    onAction: () {},
                  ),
                  RdsLabelValueList(
                    items: const [
                      RdsLabelValueItem(
                        label: 'NAME',
                        value: 'Rick Finneran',
                      ),
                      RdsLabelValueItem(
                        label: 'RELATIONSHIP',
                        value: 'Spouse',
                      ),
                      RdsLabelValueItem(
                        label: 'PHONE #',
                        value: '+1 718-479-7796',
                        isLink: true,
                      ),
                    ],
                  ),
                  SizedBox(height: rds.space4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _MiddlePanel
// ---------------------------------------------------------------------------

class _MiddlePanel extends StatelessWidget {
  const _MiddlePanel({
    required this.selectedTab,
    required this.onTabChanged,
  });

  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return _ColumnShell(
      rds: rds,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RdsTabs(
            tabs: const [
              RdsTabItem(label: '2 UPCOMING'),
              RdsTabItem(label: 'PAST'),
              RdsTabItem(label: '1 REMINDER'),
            ],
            selectedIndex: selectedTab,
            onChanged: onTabChanged,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── First appointment group ──────────────────────────────
                  Row(
                    children: [
                      Text(
                        'Today - 08:00 AM',
                        style: rds.bodyMedium.copyWith(
                          color: rds.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: rds.space2),
                      RdsBadge(
                        label: 'IN 15m',
                        color: RdsBadgeColor.warning,
                        size: RdsBadgeSize.small,
                      ),
                    ],
                  ),
                  SizedBox(height: rds.space2),
                  _AppointmentCard(
                    rds: rds,
                    badgeLabel: 'IN PERSON VISIT',
                    avatarName: 'Lisa McDowell',
                    appointmentTitle: '30 min - Physical Therapist',
                    providerName: 'Lisa McDowell',
                    showCancelAndNoShow: true,
                  ),
                  SizedBox(height: rds.space4),

                  // ── Second appointment group ─────────────────────────────
                  Text(
                    'Wed, 29 Aug - 04:00 PM',
                    style: rds.bodyMedium.copyWith(
                      color: rds.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: rds.space2),
                  _AppointmentCard(
                    rds: rds,
                    badgeLabel: 'IN PERSON ASSESSMENT',
                    avatarName: 'Dexa Scan',
                    appointmentTitle: '15 min - Dexa Scan',
                    providerName: null,
                    showCancelAndNoShow: false,
                  ),
                  SizedBox(height: rds.space4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _RightPanel
// ---------------------------------------------------------------------------

class _RightPanel extends StatelessWidget {
  const _RightPanel({
    required this.selectedTab,
    required this.onTabChanged,
  });

  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  static const _documents = [
    _DocumentData(name: 'Care Plan', count: '2'),
    _DocumentData(name: 'Love.Life Assessment', count: '3'),
    _DocumentData(name: 'Lab Report'),
    _DocumentData(name: 'Invoice'),
    _DocumentData(name: 'Consent Form'),
    _DocumentData(name: 'Referral'),
    _DocumentData(name: 'Discharge Summary'),
    _DocumentData(name: 'CT Scan'),
    _DocumentData(name: 'Ultrasound'),
  ];

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return _ColumnShell(
      rds: rds,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RdsContainerTabs(
            tabs: const [
              RdsTabItem(label: 'DOCUMENTS'),
              RdsTabItem(label: 'FORMS'),
            ],
            selectedIndex: selectedTab,
            onChanged: onTabChanged,
          ),
          RdsSubHeader(
            title: 'Documents Repository',
            actionLabel: 'UPLOAD NEW',
            onAction: () {},
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: rds.space3,
              vertical: rds.space2,
            ),
            child: RdsSearchBar(
              placeholder: 'Search documents…',
              onChanged: (_) {},
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _documents
                    .map(
                      (doc) => _DocumentItem(
                        rds: rds,
                        name: doc.name,
                        count: doc.count,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _AppointmentCard
// ---------------------------------------------------------------------------

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({
    required this.rds,
    required this.badgeLabel,
    required this.avatarName,
    required this.appointmentTitle,
    required this.providerName,
    required this.showCancelAndNoShow,
  });

  final RdsTheme rds;
  final String badgeLabel;
  final String avatarName;
  final String appointmentTitle;
  final String? providerName;
  final bool showCancelAndNoShow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: rds.surface,
        border: Border.all(color: rds.outlineVariant, width: 1),
        borderRadius: BorderRadius.circular(rds.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top row: badge + chevron
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: rds.space3,
              vertical: rds.space2,
            ),
            child: Row(
              children: [
                RdsBadge(
                  label: badgeLabel,
                  color: RdsBadgeColor.neutral,
                  size: RdsBadgeSize.small,
                ),
                const Spacer(),
                Icon(
                  RdsIcons.chevronDown,
                  size: RdsIconSize.md,
                  color: rds.onSurfaceVariant,
                ),
              ],
            ),
          ),

          // Provider / appointment info row
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: rds.space3,
              vertical: rds.space2,
            ),
            child: Row(
              children: [
                RdsAvatar(
                  type: RdsAvatarType.initials,
                  name: avatarName,
                  size: RdsAvatarSize.sm,
                ),
                SizedBox(width: rds.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointmentTitle,
                        style: rds.bodyMedium.copyWith(
                          color: rds.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (providerName != null)
                        Text(
                          providerName!,
                          style: rds.bodySmall.copyWith(
                            color: rds.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, thickness: 1, color: rds.outlineVariant),

          // Action buttons row
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: rds.space3,
              vertical: rds.space1,
            ),
            child: Row(
              children: [
                _AppointmentAction(label: 'Reschedule', rds: rds),
                _ActionSeparator(rds: rds),
                _AppointmentAction(label: 'Cancel', rds: rds),
                if (showCancelAndNoShow) ...[
                  _ActionSeparator(rds: rds),
                  _AppointmentAction(label: 'No Show', rds: rds),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _AppointmentAction  — small text button in primary colour
// ---------------------------------------------------------------------------

class _AppointmentAction extends StatefulWidget {
  const _AppointmentAction({required this.label, required this.rds});

  final String label;
  final RdsTheme rds;

  @override
  State<_AppointmentAction> createState() => _AppointmentActionState();
}

class _AppointmentActionState extends State<_AppointmentAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final rds = widget.rds;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: rds.space2,
            vertical: rds.space2,
          ),
          child: Text(
            widget.label,
            style: rds.labelMedium.copyWith(
              color: _hovered
                  ? rds.primary.withOpacity(0.8)
                  : rds.primary,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ActionSeparator — thin vertical rule between action buttons
// ---------------------------------------------------------------------------

class _ActionSeparator extends StatelessWidget {
  const _ActionSeparator({required this.rds});

  final RdsTheme rds;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 14,
      color: rds.outlineVariant,
    );
  }
}

// ---------------------------------------------------------------------------
// _DocumentItem
// ---------------------------------------------------------------------------

class _DocumentItem extends StatefulWidget {
  const _DocumentItem({
    required this.rds,
    required this.name,
    this.count,
  });

  final RdsTheme rds;
  final String name;
  final String? count;

  @override
  State<_DocumentItem> createState() => _DocumentItemState();
}

class _DocumentItemState extends State<_DocumentItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final rds = widget.rds;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: _hovered
                ? rds.onSurface.withOpacity(rds.stateHover)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(color: rds.outlineVariant, width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Optional count badge circle
              if (widget.count != null) ...[
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: rds.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.count!,
                    style: rds.labelSmall.copyWith(
                      color: rds.onPrimary,
                      fontSize: 10,
                    ),
                  ),
                ),
                SizedBox(width: rds.space2),
              ] else ...[
                // Placeholder to align text consistently
                const SizedBox(width: 28),
              ],
              Expanded(
                child: Text(
                  widget.name,
                  style: rds.bodyMedium.copyWith(color: rds.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                RdsIcons.chevronRight,
                size: RdsIconSize.md,
                color: rds.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ColumnShell  — white card with border + rounded corners wrapping a column
// ---------------------------------------------------------------------------

class _ColumnShell extends StatelessWidget {
  const _ColumnShell({required this.rds, required this.child});

  final RdsTheme rds;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: rds.surface,
        borderRadius: BorderRadius.circular(rds.radiusMd),
        border: Border.all(color: rds.outlineVariant, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// _TextLink  — inline text that looks like a hyperlink
// ---------------------------------------------------------------------------

class _TextLink extends StatefulWidget {
  const _TextLink({
    required this.label,
    required this.rds,
    this.trailingIcon,
    this.onTap,
  });

  final String label;
  final RdsTheme rds;
  final IconData? trailingIcon;
  final VoidCallback? onTap;

  @override
  State<_TextLink> createState() => _TextLinkState();
}

class _TextLinkState extends State<_TextLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final rds = widget.rds;
    final color = _hovered
        ? rds.primary.withOpacity(0.8)
        : rds.primary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: rds.labelMedium.copyWith(color: color),
            ),
            if (widget.trailingIcon != null) ...[
              SizedBox(width: rds.space1),
              Icon(widget.trailingIcon, size: 14, color: color),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _DocumentData  — simple value object for document list
// ---------------------------------------------------------------------------

class _DocumentData {
  const _DocumentData({required this.name, this.count});

  final String name;
  final String? count;
}
