import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rds/rds.dart';

// ---------------------------------------------------------------------------
// NotFoundPage — catch-all for unknown routes
// ---------------------------------------------------------------------------

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '404',
              style: rds.displayLarge.copyWith(
                color: rds.outlineVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: rds.space2),
            Text(
              'Page not found',
              style: rds.titleLarge.copyWith(color: rds.onSurface),
            ),
            SizedBox(height: rds.space6),
            RdsButton(
              label: 'Go home',
              variant: RdsButtonVariant.outlined,
              onPressed: () => context.go('/'),
            ),
          ],
        ),
      ),
    );
  }
}
