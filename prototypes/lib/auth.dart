import 'package:flutter/foundation.dart';

// ---------------------------------------------------------------------------
// In-memory auth state
//
// This is intentionally client-side only — it resets on page refresh.
// The goal is friction (prevent a customer from stumbling onto the index),
// not cryptographic security. The prototype index is internal-only.
// ---------------------------------------------------------------------------

/// True when the app is built for the staging environment (--dart-define=STAGING=true).
/// Staging skips the password gate — the URL itself is the access barrier.
const bool kIsStaging = bool.fromEnvironment('STAGING', defaultValue: false);

/// Change this to your desired index password.
const String kIndexPassword = 'reya123456';

/// Notifier for whether the current session has authenticated to the index.
/// Listened to by the router so redirects update reactively.
/// Starts as `true` on staging so the gate is bypassed.
final authNotifier = ValueNotifier<bool>(kIsStaging);

/// Mark the session as authenticated.
void signIn() => authNotifier.value = true;

/// Clear the session.
void signOut() => authNotifier.value = false;
