// ---------------------------------------------------------------------------
// gen_slug.dart — generate a random 16-character prototype slug
//
// Usage:
//   dart run scripts/gen_slug.dart
//
// Output:
//   Slug : a8fK2mNpQrTvWxYz
//   URL  : /p/a8fK2mNpQrTvWxYz
//   Share: https://your-site.netlify.app/p/a8fK2mNpQrTvWxYz
//
// After generating, add an entry in prototypes/lib/registry.dart:
//
//   'a8fK2mNpQrTvWxYz': PrototypeEntry(
//     slug: 'a8fK2mNpQrTvWxYz',
//     name: 'My Feature',
//     description: 'Short description.',
//     createdAt: DateTime(2026, 7, 1),
//     builder: (ctx) => const MyFeatureScreen(),
//   ),
// ---------------------------------------------------------------------------

import 'dart:math';

void main(List<String> args) {
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final rand = Random.secure();
  final slug =
      List.generate(16, (_) => chars[rand.nextInt(chars.length)]).join();

  print('');
  print('  Slug : $slug');
  print('  URL  : /p/$slug');
  print('  Share: https://your-site.netlify.app/p/$slug');
  print('');
  print('  Add to prototypes/lib/registry.dart:');
  print('');
  print("  '$slug': PrototypeEntry(");
  print("    slug: '$slug',");
  print("    name: 'Feature Name',");
  print("    description: 'Short description.',");
  print(
      "    createdAt: DateTime(${DateTime.now().year}, ${DateTime.now().month}, ${DateTime.now().day}),");
  print('    builder: (ctx) => const MyFeatureScreen(),');
  print('  ),');
  print('');
}
