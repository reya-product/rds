# Avatar

> A circular visual identifier for a person, organisation, or entity — shown as a photo, icon, or name initials.

---

## When to use / when not to use

**Use when:**
- Representing a person in a list, card, comment thread, or navigation header.
- Providing a visual anchor for an entity where a photo may not be available (initials or icon fallback).
- Showing the current user's identity in an app bar or profile menu.

**Do not use when:**
- You need to display a brand logo or product image — use a plain `Image` widget instead.
- The image is decorative and conveys no identity information — omit it for accessibility.
- You need a square or rounded-square crop — `RdsAvatar` is always circular.

---

## Anatomy

```
    ┌───────┐
   /  photo  \
  │  or icon  │
   \  or AB  /
    └───────┘
       1
   [background]
       2
```

| Part | Description |
|---|---|
| 1. Content | The primary visual: a network image, a centred icon, or up to 2 initials characters. |
| 2. Background | A solid circle fill. Controlled by `backgroundColor` and `showBackground`. |

---

## Variants

| Variant | Visual description | When to use |
|---|---|---|
| Image (`type: image`) | Circular crop of a network image; icon fallback on error. | When a user profile photo is available. |
| Icon (`type: icon`) | An icon centred on a background circle. | Generic user, role, or entity with no photo and no name. |
| Initials (`type: initials`) | Up to 2 letters derived from the `name` string, centred on a background. | When a name is available but no photo is set. |

---

## Configs (props)

| Prop | Type | Default | Description |
|---|---|---|---|
| `type` | `RdsAvatarType` | required | `image`, `icon`, or `initials`. |
| `imageUrl` | `String?` | `null` | Network image URL. Used when `type` is `image`. |
| `icon` | `IconData?` | `null` | Icon data. Used when `type` is `icon`. |
| `name` | `String?` | `null` | Full name string. Used when `type` is `initials`; also sets the semantic label. |
| `size` | `RdsAvatarSize` | `RdsAvatarSize.md` | Physical diameter of the avatar. |
| `backgroundColor` | `Color?` | `null` (uses `primaryContainer`) | Custom fill color. |
| `showBackground` | `bool` | `true` | When `false` the circle background is transparent. |

---

## States

| State | Trigger | Visual change | Token |
|---|---|---|---|
| Default | Always | Circular content. | — |
| Image error | Network load failure | Falls back to `RdsIcons.user` icon. | — |

Avatar is non-interactive — it has no hover, focus, press, or disabled states.

---

## Sizes

| Size | Diameter | Icon size | Text style |
|---|---|---|---|
| `xs` | 24px | 12px | `label-small` |
| `sm` | 32px | 16px | `label-medium` |
| `md` | 40px | 20px | `label-medium` |
| `lg` | 48px | 24px | `label-large` |
| `xl` | 64px | 32px | `title-medium` |
| `xxl` | 80px | 40px | `title-medium` |

---

## Tokens used

**Colors**
- `color-primary-container` — default background fill when `backgroundColor` is null
- `color-on-primary-container` — default content color (icon / initials) on default background
- `color-on-primary` — content color when a custom `backgroundColor` is provided

**Typography**
- `label-small` — initials text at `xs`
- `label-medium` — initials text at `sm` / `md`
- `label-large` — initials text at `lg`
- `title-medium` — initials text at `xl` / `xxl`

---

## Behavior & interaction

### Mouse / touch
- Not interactive by itself. Wrap in `GestureDetector` or `InkWell` at the call-site if tap is needed.

### Keyboard
- Not focusable. Wrap in a focusable widget at call-site if keyboard navigation is required.

### Focus management
- No internal focus management.

### Animation
- None on the avatar itself. Image loads asynchronously; a smooth fade-in can be added at call-site.

---

## Accessibility

- **Semantics:** `Semantics(label: name, image: true)` is applied. The `name` prop, if present, is announced as the accessible label. Falls back to generic "Profile image" / "User avatar" / "Avatar" strings.
- **Min touch target:** Not applicable — avatar is non-interactive by default.
- **Contrast:** The default `primaryContainer` / `onPrimaryContainer` pair meets WCAG AA. Custom `backgroundColor` values are the caller's responsibility to verify.
- **Screen reader:** The accessible label is read when the avatar is encountered in the semantic tree.
- **Keyboard:** No keyboard interaction.

---

## Content guidelines

- **Name initials:** First letter of first word + first letter of last word. Single-word names use the first letter only. Both letters are upper-cased.
- **Image URL:** Prefer a square or near-square source image for clean circular crops. Landscape images will be center-cropped.
- **Alt text:** Pass the person's full `name` whenever available, even for image type, so screen readers can announce it.

---

## Composition

**Uses:**
- Primitive — no RDS dependencies.

**Used by:**
- `RdsListItem` — person or entity identity in list rows.
- `RdsCard` — author or assignee display.
- App navigation bar — current user identity.

---

## Flutter API

### Widget class
`RdsAvatar`

### Constructor
```dart
const RdsAvatar({
  super.key,
  required RdsAvatarType type,
  String? imageUrl,
  IconData? icon,
  String? name,
  RdsAvatarSize size = RdsAvatarSize.md,
  Color? backgroundColor,
  bool showBackground = true,
});
```

### Public enums

```dart
enum RdsAvatarType { image, icon, initials }

enum RdsAvatarSize { xs, sm, md, lg, xl, xxl }
```

### Example usage

```dart
// Photo avatar
RdsAvatar(
  type: RdsAvatarType.image,
  imageUrl: 'https://example.com/dr-chen.jpg',
  name: 'Dr Chen',
  size: RdsAvatarSize.lg,
)

// Initials avatar with custom color
RdsAvatar(
  type: RdsAvatarType.initials,
  name: 'Jane Doe',
  size: RdsAvatarSize.md,
  backgroundColor: const Color(0xFF6CC4C2),
)

// Generic icon avatar
RdsAvatar(
  type: RdsAvatarType.icon,
  icon: RdsIcons.user,
  size: RdsAvatarSize.sm,
)
```

---

## Widgetbook

### Use cases

| Use case name | Description |
|---|---|
| `Playground` | All props exposed as knobs; preview updates live. |
| `Gallery` | All six sizes × all three types shown in a grid. |

### Knobs

| Knob | Type | Maps to prop | Options |
|---|---|---|---|
| `Type` | `list` | `type` | `image`, `icon`, `initials` |
| `Size` | `list` | `size` | `xs`, `sm`, `md`, `lg`, `xl`, `xxl` |
| `Name` | `string` | `name` | — |
| `Image URL` | `string` | `imageUrl` | — |
| `Show background` | `boolean` | `showBackground` | `true` / `false` |

---

## Do / Don't

| Do | Don't |
|---|---|
| Always pass `name` when displaying a person — it is used as the accessible label. | Don't leave `name` null for person avatars; screen readers will announce a generic "Avatar". |
| Use `showBackground: false` on light surfaces where the background fill feels heavy. | Don't use transparent backgrounds when initials or icons have insufficient contrast against the page surface. |
| Use `initials` type as the fallback when an image fails to load by catching the error at the call-site. | Don't display a broken image icon without any fallback state. |
| Pair the avatar with a visible name label in dense lists for sighted users. | Don't rely solely on the avatar to identify a person in interactive lists. |
