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
      backgroundColor: rds.surfaceContainer,
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
                  padding: const EdgeInsets.all(16),
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
          RdsButton(
            label: 'TEST BUTTON',
            variant: RdsButtonVariant.tonal,
            onPressed: () => RdsRightPanel.show(
              context: context,
              title: 'Fruits',
              body: const _FruitListBody(),
              footerActions: [],
            ),
          ),
          SizedBox(width: rds.space2),
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

class _LeftPanel extends StatefulWidget {
  const _LeftPanel({
    required this.selectedTab,
    required this.onTabChanged,
  });

  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  @override
  State<_LeftPanel> createState() => _LeftPanelState();
}

class _LeftPanelState extends State<_LeftPanel> {
  _ContactInfoData _info = _ContactInfoData(
    firstName: 'Juliana',
    middleName: '',
    lastName: 'Crain',
    dob: DateTime(1985, 8, 2),
    sexAssignedAtBirth: 'Female',
    preferredPronouns: 'She/Her',
    mobilePhone: '+1 718-479-7777',
    workPhone: '',
    email: 'juliana@gmail.com',
    streetAddress: '1444 Queens Ave',
    city: 'LA',
    state: 'California',
    zip: '',
  );

  Future<void> _openEditPanel(BuildContext context) async {
    final formKey = GlobalKey<_ContactInfoFormState>();

    final result = await RdsRightPanel.show<_ContactInfoData>(
      context: context,
      title: 'Edit Contact Information',
      body: _ContactInfoForm(key: formKey, initialData: _info),
      footerActions: [
        Builder(
          builder: (ctx) => RdsButton(
            label: 'CANCEL',
            variant: RdsButtonVariant.outlined,
            onPressed: () => Navigator.pop(ctx),
          ),
        ),
        Builder(
          builder: (ctx) => RdsButton(
            label: 'SAVE',
            onPressed: () =>
                Navigator.pop(ctx, formKey.currentState?.getData()),
          ),
        ),
      ],
    );

    if (result != null && mounted) {
      setState(() => _info = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return _ColumnShell(
      rds: rds,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: rds.space2),
          RdsContainerTabs(
            tabs: const [
              RdsTabItem(label: 'OVERVIEW'),
              RdsTabItem(label: 'MEMBERSHIP'),
              RdsTabItem(label: 'PMT & GIFT CARDS'),
              RdsTabItem(label: 'TEAM'),
            ],
            selectedIndex: widget.selectedTab,
            onChanged: widget.onTabChanged,
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
                    onAction: () => _openEditPanel(context),
                  ),
                  RdsLabelValueList(
                    items: [
                      RdsLabelValueItem(
                        label: 'FIRST NAME',
                        value: _info.firstName,
                      ),
                      RdsLabelValueItem(
                        label: 'MIDDLE NAME',
                        value: _info.middleName,
                      ),
                      RdsLabelValueItem(
                        label: 'LAST NAME',
                        value: _info.lastName,
                      ),
                      RdsLabelValueItem(
                        label: 'D.O.B',
                        value: _formatDate(_info.dob),
                      ),
                      RdsLabelValueItem(
                        label: 'SEX ASSIGNED AT BIRTH',
                        value: _info.sexAssignedAtBirth,
                      ),
                      RdsLabelValueItem(
                        label: 'PREFERRED PRONOUNS',
                        value: _info.preferredPronouns,
                      ),
                      RdsLabelValueItem(
                        label: 'MOBILE #',
                        value: _info.mobilePhone,
                        isLink: _info.mobilePhone.isNotEmpty,
                      ),
                      RdsLabelValueItem(
                        label: 'WORK PHONE #',
                        value: _info.workPhone,
                      ),
                      RdsLabelValueItem(
                        label: 'EMAIL',
                        value: _info.email,
                        isLink: _info.email.isNotEmpty,
                      ),
                      RdsLabelValueItem(
                        label: 'STREET ADDRESS',
                        value: _info.streetAddress,
                      ),
                      RdsLabelValueItem(label: 'CITY', value: _info.city),
                      RdsLabelValueItem(label: 'STATE', value: _info.state),
                      RdsLabelValueItem(label: 'ZIP', value: _info.zip),
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
          SizedBox(height: rds.space2),
          RdsContainerTabs(
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

class _RightPanel extends StatefulWidget {
  const _RightPanel({
    required this.selectedTab,
    required this.onTabChanged,
  });

  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  @override
  State<_RightPanel> createState() => _RightPanelState();
}

class _RightPanelState extends State<_RightPanel> {
  int _formsSubTab = 0; // 0 = ASSIGNED, 1 = SUBMITTED

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

  static const _submittedForms = [
    _FormData(name: 'MD Pre-Visit Form', date: '26 Jun 2026'),
    _FormData(name: 'Patient Suicide Severity Scale Questionnaire', date: '26 Jun 2026'),
    _FormData(name: 'Exercise Pre-Visit Form', date: '25 Jun 2026'),
    _FormData(name: 'MD Pre-Visit Form', date: '25 Jun 2026'),
    _FormData(name: 'MSQ Questionnaire', date: '25 Jun 2026'),
    _FormData(name: 'Diet ID Form', date: '25 Jun 2026'),
    _FormData(name: 'Member Registration Form', date: '25 Jun 2026'),
  ];

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return _ColumnShell(
      rds: rds,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: rds.space2),
          RdsContainerTabs(
            tabs: const [
              RdsTabItem(label: 'DOCUMENTS'),
              RdsTabItem(label: 'FORMS'),
              RdsTabItem(label: 'ENCOUNTERS'),
              RdsTabItem(label: 'CONSENTS'),
            ],
            selectedIndex: widget.selectedTab,
            onChanged: widget.onTabChanged,
          ),
          if (widget.selectedTab == 0) ...[
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
          ] else if (widget.selectedTab == 1) ...[
            RdsTabs(
              tabs: const [
                RdsTabItem(label: 'ASSIGNED'),
                RdsTabItem(label: 'SUBMITTED'),
              ],
              selectedIndex: _formsSubTab,
              onChanged: (i) => setState(() => _formsSubTab = i),
            ),
            if (_formsSubTab == 0) ...[
              RdsSubHeader(
                title: '0 Assigned',
                actionLabel: 'ASSIGN TO MEMBER',
                onAction: () {},
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'No forms to be filled currently',
                        style: rds.titleMedium.copyWith(color: rds.onSurface),
                      ),
                      SizedBox(height: rds.space1),
                      Text(
                        'All Assigned forms will appear here',
                        style: rds.bodyMedium.copyWith(
                          color: rds.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _submittedForms
                        .map(
                          (form) => _FormItem(
                            rds: rds,
                            name: form.name,
                            date: form.date,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ] else ...[
            const Expanded(child: SizedBox()),
          ],
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

// ---------------------------------------------------------------------------
// _FormData  — simple value object for forms list
// ---------------------------------------------------------------------------

class _FormData {
  const _FormData({required this.name, required this.date});

  final String name;
  final String date;
}

// ---------------------------------------------------------------------------
// _FormItem  — single row in the submitted-forms list
// ---------------------------------------------------------------------------

class _FormItem extends StatefulWidget {
  const _FormItem({required this.rds, required this.name, required this.date});

  final RdsTheme rds;
  final String name;
  final String date;

  @override
  State<_FormItem> createState() => _FormItemState();
}

class _FormItemState extends State<_FormItem> {
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
          decoration: BoxDecoration(
            color: _hovered
                ? rds.onSurface.withOpacity(rds.stateHover)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(color: rds.outlineVariant, width: 1),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: rds.space3,
            vertical: rds.space3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: rds.bodyMedium.copyWith(color: rds.primary),
              ),
              SizedBox(height: rds.space1),
              Text(
                widget.date,
                style: rds.bodySmall.copyWith(color: rds.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ContactInfoData  — editable contact info value object
// ---------------------------------------------------------------------------

class _ContactInfoData {
  _ContactInfoData({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.dob,
    required this.sexAssignedAtBirth,
    required this.preferredPronouns,
    required this.mobilePhone,
    required this.workPhone,
    required this.email,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.zip,
  });

  final String firstName;
  final String middleName;
  final String lastName;
  final DateTime? dob;
  final String sexAssignedAtBirth;
  final String preferredPronouns;
  final String mobilePhone;
  final String workPhone;
  final String email;
  final String streetAddress;
  final String city;
  final String state;
  final String zip;
}

String _formatDate(DateTime? date) {
  if (date == null) return '';
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
}

// ---------------------------------------------------------------------------
// _ContactInfoForm  — form body rendered inside RdsRightPanel
// ---------------------------------------------------------------------------

class _ContactInfoForm extends StatefulWidget {
  const _ContactInfoForm({super.key, required this.initialData});

  final _ContactInfoData initialData;

  @override
  State<_ContactInfoForm> createState() => _ContactInfoFormState();
}

class _ContactInfoFormState extends State<_ContactInfoForm> {
  late final TextEditingController _firstName;
  late final TextEditingController _middleName;
  late final TextEditingController _lastName;
  late final TextEditingController _mobile;
  late final TextEditingController _workPhone;
  late final TextEditingController _email;
  late final TextEditingController _street;
  late final TextEditingController _city;
  late final TextEditingController _zip;

  DateTime? _dob;
  String? _sex;
  String? _pronouns;
  String? _state;

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;
    _firstName = TextEditingController(text: d.firstName);
    _middleName = TextEditingController(text: d.middleName);
    _lastName = TextEditingController(text: d.lastName);
    _mobile = TextEditingController(text: d.mobilePhone);
    _workPhone = TextEditingController(text: d.workPhone);
    _email = TextEditingController(text: d.email);
    _street = TextEditingController(text: d.streetAddress);
    _city = TextEditingController(text: d.city);
    _zip = TextEditingController(text: d.zip);
    _dob = d.dob;
    _sex = d.sexAssignedAtBirth.isEmpty ? null : d.sexAssignedAtBirth;
    _pronouns = d.preferredPronouns.isEmpty ? null : d.preferredPronouns;
    _state = d.state.isEmpty ? null : d.state;
  }

  @override
  void dispose() {
    _firstName.dispose();
    _middleName.dispose();
    _lastName.dispose();
    _mobile.dispose();
    _workPhone.dispose();
    _email.dispose();
    _street.dispose();
    _city.dispose();
    _zip.dispose();
    super.dispose();
  }

  _ContactInfoData getData() => _ContactInfoData(
        firstName: _firstName.text,
        middleName: _middleName.text,
        lastName: _lastName.text,
        dob: _dob,
        sexAssignedAtBirth: _sex ?? '',
        preferredPronouns: _pronouns ?? '',
        mobilePhone: _mobile.text,
        workPhone: _workPhone.text,
        email: _email.text,
        streetAddress: _street.text,
        city: _city.text,
        state: _state ?? '',
        zip: _zip.text,
      );

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        RdsTextField(label: 'First name', controller: _firstName, mandatory: true),
        SizedBox(height: rds.space3),
        RdsTextField(label: 'Middle name', controller: _middleName),
        SizedBox(height: rds.space3),
        RdsTextField(label: 'Last name', controller: _lastName, mandatory: true),
        SizedBox(height: rds.space3),
        RdsDateField(
          label: 'Date of birth',
          value: _dob,
          onChanged: (d) => setState(() => _dob = d),
          maxDate: DateTime.now(),
        ),
        SizedBox(height: rds.space3),
        RdsDropdownField(
          label: 'Sex assigned at birth',
          value: _sex,
          items: const [
            RdsDropdownItem(value: 'Female', label: 'Female'),
            RdsDropdownItem(value: 'Male', label: 'Male'),
            RdsDropdownItem(value: 'Intersex', label: 'Intersex'),
            RdsDropdownItem(value: 'Prefer not to say', label: 'Prefer not to say'),
          ],
          onChanged: (v) => setState(() => _sex = v as String?),
        ),
        SizedBox(height: rds.space3),
        RdsDropdownField(
          label: 'Preferred pronouns',
          value: _pronouns,
          items: const [
            RdsDropdownItem(value: 'She/Her', label: 'She/Her'),
            RdsDropdownItem(value: 'He/Him', label: 'He/Him'),
            RdsDropdownItem(value: 'They/Them', label: 'They/Them'),
            RdsDropdownItem(value: 'Ze/Hir', label: 'Ze/Hir'),
            RdsDropdownItem(value: 'Prefer not to say', label: 'Prefer not to say'),
          ],
          onChanged: (v) => setState(() => _pronouns = v as String?),
        ),
        SizedBox(height: rds.space3),
        RdsTextField(label: 'Mobile phone', controller: _mobile),
        SizedBox(height: rds.space3),
        RdsTextField(label: 'Work phone', controller: _workPhone),
        SizedBox(height: rds.space3),
        RdsTextField(label: 'Email', controller: _email),
        SizedBox(height: rds.space3),
        RdsTextField(label: 'Street address', controller: _street),
        SizedBox(height: rds.space3),
        RdsTextField(label: 'City', controller: _city),
        SizedBox(height: rds.space3),
        RdsDropdownField(
          label: 'State',
          value: _state,
          searchable: true,
          items: _kUsStates
              .map((s) => RdsDropdownItem(value: s, label: s))
              .toList(),
          onChanged: (v) => setState(() => _state = v as String?),
        ),
        SizedBox(height: rds.space3),
        RdsTextField(label: 'ZIP code', controller: _zip),
      ],
    );
  }
}

const _kUsStates = [
  'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado',
  'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho',
  'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana',
  'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota',
  'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada',
  'New Hampshire', 'New Jersey', 'New Mexico', 'New York',
  'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon',
  'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota',
  'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington',
  'West Virginia', 'Wisconsin', 'Wyoming',
];

// ---------------------------------------------------------------------------
// _FruitListBody  — panel body for the Test Button
// ---------------------------------------------------------------------------

class _FruitListBody extends StatelessWidget {
  const _FruitListBody();

  static const _fruits = [
    (name: 'Apple', description: 'A crisp, sweet fruit rich in fibre and vitamin C, available in hundreds of varieties from tart Granny Smith to honeyed Fuji.'),
    (name: 'Mango', description: 'The king of tropical fruits — intensely sweet and fragrant with a smooth, buttery flesh and a fibrous stone at the centre.'),
    (name: 'Strawberry', description: 'A bright red berry with a juicy, tangy-sweet flavour and a high vitamin C content, best enjoyed fresh at peak ripeness.'),
    (name: 'Blueberry', description: 'Tiny dark-blue berries with a mild, sweet flavour and among the highest antioxidant levels of any common fruit.'),
    (name: 'Pineapple', description: 'A spiky tropical fruit with golden flesh that balances sharp acidity and intense sweetness, rich in the enzyme bromelain.'),
    (name: 'Peach', description: 'A stone fruit with soft, velvety skin and fragrant flesh that ranges from white to deep orange depending on the variety.'),
    (name: 'Watermelon', description: 'A large summer fruit with a crisp, water-rich flesh that is refreshing, lightly sweet, and over 90% water by weight.'),
    (name: 'Kiwi', description: 'A small egg-shaped fruit with bright green flesh, a tangy-sweet flavour, and more vitamin C per gram than an orange.'),
    (name: 'Banana', description: 'A creamy, starchy fruit that ripens from green to yellow, growing sweeter as starches convert to sugar over time.'),
    (name: 'Grape', description: 'Small, thin-skinned berries that grow in clusters and range from tart green varieties to rich, deeply flavoured black ones.'),
    (name: 'Papaya', description: 'A tropical fruit with sunset-orange flesh, a musky sweetness, and the enzyme papain that aids digestion.'),
    (name: 'Pomegranate', description: 'A leathery-skinned fruit filled with hundreds of jewel-like seeds, each bursting with a tart, ruby-red juice.'),
  ];

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _fruits.map((fruit) {
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: rds.space4,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: rds.outlineVariant, width: 1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fruit.name,
                style: rds.titleSmall.copyWith(color: rds.onSurface),
              ),
              SizedBox(height: rds.space1),
              Text(
                fruit.description,
                style: rds.bodySmall.copyWith(color: rds.onSurfaceVariant),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
