import 'package:flutter/foundation.dart';

// ---------------------------------------------------------------------------
// In-memory auth state
//
// This is intentionally client-side only — it resets on page refresh.
// The goal is friction (prevent a customer from stumbling onto the index),
// not cryptographic security. The prototype index is internal-only.
// ---------------------------------------------------------------------------

/// Change this to your desired index password.
const String kIndexPassword = 'reyads2026';

/// Notifier for whether the current session has authenticated to the index.
/// Listened to by the router so redirects update reactively.
final authNotifier = ValueNotifier<bool>(false);

/// Mark the session as authenticated.
void signIn() => authNotifier.value = true;

/// Clear the session.
void signOut() => authNotifier.value = false;
