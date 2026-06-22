import 'package:flutter/material.dart';
import 'package:rds/rds.dart';

import '../registry.dart';

// ---------------------------------------------------------------------------
// ViewerPage — full-screen prototype shell
//
// Renders the feature widget with NO navigation chrome. The feature itself
// is responsible for its own layout. There is no back button, app bar,
// drawer, or any other navigation affordance visible to the customer.
// ---------------------------------------------------------------------------

class ViewerPage extends StatelessWidget {
  final String slug;
  const ViewerPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final entry = PrototypeRegistry.find(slug);

    if (entry == null) return _PrototypeNotFound(slug: slug);

    // Render the feature full-screen inside the RDS-themed Material shell.
    // No Scaffold, no AppBar, no nav — just the prototype widget.
    return entry.builder(context);
  }
}

// ---------------------------------------------------------------------------
// _PrototypeNotFound
// ---------------------------------------------------------------------------

class _PrototypeNotFound extends StatelessWidget {
  final String slug;
  const _PrototypeNotFound({required this.slug});

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: EdgeInsets.all(rds.space6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  RdsIcons.error,
                  size: 48,
                  color: rds.onSurfaceMuted,
                ),
                SizedBox(height: rds.space4),
                Text(
                  'Prototype not found',
                  style: rds.headlineSmall.copyWith(color: rds.onSurface),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: rds.space2),
                Text(
                  'The link you followed may have expired or been updated.\nPlease contact your Reya representative for a fresh link.',
                  style: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
