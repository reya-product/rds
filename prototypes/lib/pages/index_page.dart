import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rds/rds.dart';

import '../auth.dart';
import '../registry.dart';

// ---------------------------------------------------------------------------
// IndexPage — authenticated list of all prototypes
// ---------------------------------------------------------------------------

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    final entries = PrototypeRegistry.all.reversed.toList();

    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      appBar: AppBar(
        backgroundColor: rds.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Row(
          children: [
            Text(
              'Reya',
              style: rds.titleLarge.copyWith(
                color: rds.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: rds.space2),
            Text(
              'Prototype Library',
              style: rds.titleMedium.copyWith(color: rds.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              signOut();
              context.go('/');
            },
            child: Text(
              'Sign out',
              style: rds.labelMedium.copyWith(color: rds.onSurfaceVariant),
            ),
          ),
          SizedBox(width: rds.space2),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: rds.outlineVariant),
        ),
      ),
      body: entries.isEmpty
          ? _EmptyState(rds: rds)
          : ListView.separated(
              padding: EdgeInsets.all(rds.space6),
              itemCount: entries.length,
              separatorBuilder: (_, __) => SizedBox(height: rds.space3),
              itemBuilder: (context, index) =>
                  _PrototypeCard(entry: entries[index]),
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// _PrototypeCard
// ---------------------------------------------------------------------------

class _PrototypeCard extends StatelessWidget {
  final PrototypeEntry entry;

  const _PrototypeCard({required this.entry});

  String _formatDate(DateTime dt) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month]} ${dt.day}, ${dt.year}';
  }

  String _shareUrl(BuildContext context) {
    final uri = Uri.base;
    return '${uri.scheme}://${uri.host}${uri.port != 80 && uri.port != 443 ? ':${uri.port}' : ''}/p/${entry.slug}';
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Container(
      decoration: BoxDecoration(
        color: rds.surface,
        borderRadius: BorderRadius.circular(rds.radiusMd),
        border: Border.all(color: rds.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(rds.radiusMd),
        onTap: () => context.go('/p/${entry.slug}'),
        child: Padding(
          padding: EdgeInsets.all(rds.space5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name + open arrow
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.name,
                      style: rds.titleMedium.copyWith(color: rds.onSurface),
                    ),
                  ),
                  Icon(
                    RdsIcons.chevronRight,
                    size: RdsIconSize.md,
                    color: rds.onSurfaceMuted,
                  ),
                ],
              ),
              SizedBox(height: rds.space1),

              // Description
              Text(
                entry.description,
                style: rds.bodySmall.copyWith(color: rds.onSurfaceVariant),
              ),
              SizedBox(height: rds.space4),

              // Metadata row
              Row(
                children: [
                  // Date
                  Icon(
                    RdsIcons.calendar,
                    size: RdsIconSize.sm,
                    color: rds.onSurfaceMuted,
                  ),
                  SizedBox(width: rds.space1),
                  Text(
                    _formatDate(entry.createdAt),
                    style: rds.labelSmall.copyWith(color: rds.onSurfaceMuted),
                  ),
                  const Spacer(),

                  // Copy link button
                  _CopyLinkButton(url: _shareUrl(context)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _CopyLinkButton
// ---------------------------------------------------------------------------

class _CopyLinkButton extends StatefulWidget {
  final String url;
  const _CopyLinkButton({required this.url});

  @override
  State<_CopyLinkButton> createState() => _CopyLinkButtonState();
}

class _CopyLinkButtonState extends State<_CopyLinkButton> {
  bool _copied = false;

  void _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.url));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return GestureDetector(
      onTap: _copy,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _copied ? RdsIcons.check : RdsIcons.more,
            size: RdsIconSize.sm,
            color: _copied ? rds.success : rds.primary,
          ),
          SizedBox(width: rds.space1),
          Text(
            _copied ? 'Copied!' : 'Copy link',
            style: rds.labelSmall.copyWith(
              color: _copied ? rds.success : rds.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _EmptyState
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  final RdsTheme rds;
  const _EmptyState({required this.rds});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(RdsIcons.add, size: 48, color: rds.onSurfaceMuted),
          SizedBox(height: rds.space4),
          Text(
            'No prototypes yet',
            style: rds.titleMedium.copyWith(color: rds.onSurface),
          ),
          SizedBox(height: rds.space2),
          Text(
            'Add entries to lib/registry.dart to get started.',
            style: rds.bodyMedium.copyWith(color: rds.onSurfaceMuted),
          ),
        ],
      ),
    );
  }
}
