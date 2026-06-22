import 'package:go_router/go_router.dart';

import 'auth.dart';
import 'pages/gate_page.dart';
import 'pages/index_page.dart';
import 'pages/not_found_page.dart';
import 'pages/viewer_page.dart';

// ---------------------------------------------------------------------------
// Routes
//
//  /           → GatePage (password gate — internal team only)
//  /index      → IndexPage (list of all prototypes — requires auth)
//  /p/:slug    → ViewerPage (full-screen prototype — PUBLIC, no auth needed)
//  anything    → NotFoundPage
// ---------------------------------------------------------------------------

final router = GoRouter(
  // Re-evaluate redirects whenever auth state changes.
  refreshListenable: authNotifier,

  redirect: (context, state) {
    final authed = authNotifier.value;
    final location = state.matchedLocation;

    // The index requires authentication.
    if (location == '/index' && !authed) return '/';

    // Once authenticated, visiting the gate redirects to the index.
    if (location == '/' && authed) return '/index';

    // /p/:slug routes are always public — no redirect.
    return null;
  },

  errorBuilder: (context, state) => const NotFoundPage(),

  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const GatePage(),
    ),
    GoRoute(
      path: '/index',
      builder: (context, state) => const IndexPage(),
    ),
    GoRoute(
      path: '/p/:slug',
      builder: (context, state) {
        final slug = state.pathParameters['slug']!;
        return ViewerPage(slug: slug);
      },
    ),
  ],
);
