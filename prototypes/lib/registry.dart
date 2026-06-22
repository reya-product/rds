import 'package:flutter/widgets.dart';

import 'features/demo_feature.dart';
import 'features/members_detail_page.dart';

// ---------------------------------------------------------------------------
// PrototypeEntry
// ---------------------------------------------------------------------------

/// A single registered feature prototype.
class PrototypeEntry {
  /// The 16-character random slug used in the shareable URL.
  /// Generate one with: dart run scripts/gen_slug.dart
  final String slug;

  /// Human-readable name shown on the index page.
  final String name;

  /// Short description shown on the index page.
  final String description;

  /// When this prototype was first published.
  final DateTime createdAt;

  /// Builds the full-screen prototype widget.
  final WidgetBuilder builder;

  const PrototypeEntry({
    required this.slug,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.builder,
  });
}

// ---------------------------------------------------------------------------
// Registry
//
// HOW TO ADD A NEW PROTOTYPE:
//
//  1. Create your feature screen in lib/features/my_feature.dart
//  2. Run: dart run scripts/gen_slug.dart
//     Copy the generated slug.
//  3. Add an entry below with the slug, name, description, and builder.
//  4. git push — Netlify auto-deploys in ~2 minutes.
//  5. Share the URL with your customer:
//     https://your-site.netlify.app/p/<slug>
// ---------------------------------------------------------------------------

class PrototypeRegistry {
  PrototypeRegistry._();

  /// All registered prototypes, keyed by slug.
  static final Map<String, PrototypeEntry> _entries = {
    // -----------------------------------------------------------------------
    // DEMO — replace or keep as a reference
    // -----------------------------------------------------------------------
    'demo0000000000demo': PrototypeEntry(
      slug: 'demo0000000000demo',
      name: 'Demo: Onboard Member',
      description: 'Sample prototype demonstrating the overlay + form pattern.',
      createdAt: DateTime(2026, 6, 22),
      builder: (ctx) => const DemoFeature(),
    ),

    // -----------------------------------------------------------------------
    // Member's Detail Page — 2026-06-23
    // -----------------------------------------------------------------------
    'mbr_detail_v1_2606': PrototypeEntry(
      slug: 'mbr_detail_v1_2606',
      name: "Member's Detail Page",
      description:
          'Three-column member profile: contact info, upcoming appointments, and documents repository.',
      createdAt: DateTime(2026, 6, 23),
      builder: (ctx) => const MembersDetailPage(),
    ),

    // -----------------------------------------------------------------------
    // ADD YOUR PROTOTYPES HERE
    // -----------------------------------------------------------------------
    // 'a8fK2mNpQrTvWxYz': PrototypeEntry(
    //   slug: 'a8fK2mNpQrTvWxYz',
    //   name: 'Patient Timeline',
    //   description: 'Add/edit timeline entries from the patient detail view.',
    //   createdAt: DateTime(2026, 7, 1),
    //   builder: (ctx) => const PatientTimelineFeature(),
    // ),
  };

  /// Returns the entry for [slug], or null if not registered.
  static PrototypeEntry? find(String slug) => _entries[slug];

  /// All entries in insertion order (newest last).
  static List<PrototypeEntry> get all => _entries.values.toList();
}
