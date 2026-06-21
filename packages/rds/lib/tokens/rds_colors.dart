import 'package:flutter/material.dart';

/// All primitive color constants and semantic color roles for RDS.
///
/// Components must never reference these directly — they read semantic roles
/// through [RdsTheme]. Token files may reference each other.
abstract final class RdsColors {
  // ---------------------------------------------------------------------------
  // Neutral grays
  // ---------------------------------------------------------------------------

  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFF9FAFB);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral200 = Color(0xFFE5E7EB);
  static const Color neutral300 = Color(0xFFD1D5DB);
  static const Color neutral400 = Color(0xFF9CA3AF);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral600 = Color(0xFF4B5563);
  static const Color neutral700 = Color(0xFF374151);
  static const Color neutral800 = Color(0xFF1F2937);
  static const Color neutral900 = Color(0xFF111827);
  static const Color neutral950 = Color(0xFF030712);

  // ---------------------------------------------------------------------------
  // Brand — clinical teal-blue
  // ---------------------------------------------------------------------------

  static const Color brand50 = Color(0xFFEFF8F8);
  static const Color brand100 = Color(0xFFD0EEED);
  static const Color brand200 = Color(0xFFA2DCDB);
  static const Color brand300 = Color(0xFF6CC4C2);
  static const Color brand400 = Color(0xFF3EAAAA);
  static const Color brand500 = Color(0xFF2A9090);
  static const Color brand600 = Color(0xFF237878);
  static const Color brand700 = Color(0xFF1C6060);
  static const Color brand800 = Color(0xFF154848);
  static const Color brand900 = Color(0xFF0E3030);

  // ---------------------------------------------------------------------------
  // Danger — red
  // ---------------------------------------------------------------------------

  static const Color danger50 = Color(0xFFFEF2F2);
  static const Color danger100 = Color(0xFFFEE2E2);
  static const Color danger200 = Color(0xFFFECACA);
  static const Color danger300 = Color(0xFFFCA5A5);
  static const Color danger400 = Color(0xFFF87171);
  static const Color danger500 = Color(0xFFEF4444);
  static const Color danger600 = Color(0xFFDC2626);
  static const Color danger700 = Color(0xFFB91C1C);
  static const Color danger800 = Color(0xFF991B1B);
  static const Color danger900 = Color(0xFF7F1D1D);

  // ---------------------------------------------------------------------------
  // Warning — amber
  // ---------------------------------------------------------------------------

  static const Color warning50 = Color(0xFFFFFBEB);
  static const Color warning100 = Color(0xFFFEF3C7);
  static const Color warning200 = Color(0xFFFDE68A);
  static const Color warning300 = Color(0xFFFCD34D);
  static const Color warning400 = Color(0xFFFBBF24);
  static const Color warning500 = Color(0xFFF59E0B);
  static const Color warning600 = Color(0xFFD97706);
  static const Color warning700 = Color(0xFFB45309);
  static const Color warning800 = Color(0xFF92400E);
  static const Color warning900 = Color(0xFF78350F);

  // ---------------------------------------------------------------------------
  // Success — green
  // ---------------------------------------------------------------------------

  static const Color success50 = Color(0xFFF0FDF4);
  static const Color success100 = Color(0xFFDCFCE7);
  static const Color success200 = Color(0xFFBBF7D0);
  static const Color success300 = Color(0xFF86EFAC);
  static const Color success400 = Color(0xFF4ADE80);
  static const Color success500 = Color(0xFF22C55E);
  static const Color success600 = Color(0xFF16A34A);
  static const Color success700 = Color(0xFF15803D);
  static const Color success800 = Color(0xFF166534);
  static const Color success900 = Color(0xFF14532D);

  // ---------------------------------------------------------------------------
  // Muted pastel badge pairs (background + text)
  // ---------------------------------------------------------------------------

  static const Color badgeBlueBackground = Color(0xFFDBEAFE);
  static const Color badgeBlueText = Color(0xFF1D4ED8);

  static const Color badgePurpleBackground = Color(0xFFEDE9FE);
  static const Color badgePurpleText = Color(0xFF6D28D9);

  static const Color badgePinkBackground = Color(0xFFFCE7F3);
  static const Color badgePinkText = Color(0xFFBE185D);

  static const Color badgeOrangeBackground = Color(0xFFFFEDD5);
  static const Color badgeOrangeText = Color(0xFFC2410C);

  static const Color badgeYellowBackground = Color(0xFFFEF9C3);
  static const Color badgeYellowText = Color(0xFFA16207);

  static const Color badgeTealBackground = Color(0xFFCCFBF1);
  static const Color badgeTealText = Color(0xFF0F766E);

  static const Color badgeGreenBackground = Color(0xFFDCFCE7);
  static const Color badgeGreenText = Color(0xFF15803D);

  static const Color badgeRedBackground = Color(0xFFFEE2E2);
  static const Color badgeRedText = Color(0xFFB91C1C);

  static const Color badgeAmberBackground = Color(0xFFFEF3C7);
  static const Color badgeAmberText = Color(0xFFB45309);

  static const Color badgeNeutralBackground = Color(0xFFF3F4F6);
  static const Color badgeNeutralText = Color(0xFF374151);

  // ---------------------------------------------------------------------------
  // Light theme semantic roles
  // ---------------------------------------------------------------------------

  static const Color surfaceLight = neutral0;
  static const Color surfaceVariantLight = neutral50;
  static const Color surfaceContainerLight = neutral100;
  static const Color onSurfaceLight = neutral900;
  static const Color onSurfaceVariantLight = neutral600;
  static const Color onSurfaceMutedLight = neutral400;

  static const Color primaryLight = brand500;
  static const Color primaryContainerLight = brand50;
  static const Color onPrimaryLight = neutral0;
  static const Color onPrimaryContainerLight = brand700;

  static const Color outlineLight = neutral300;
  static const Color outlineVariantLight = neutral200;
  static const Color scrimLight = Color(0x66111827); // neutral-900 @ 40%

  static const Color dangerLight = danger600;
  static const Color dangerContainerLight = danger50;
  static const Color onDangerLight = neutral0;
  static const Color onDangerContainerLight = danger700;

  static const Color warningLight = warning600;
  static const Color warningContainerLight = warning50;
  static const Color onWarningLight = neutral0;
  static const Color onWarningContainerLight = warning800;

  static const Color successLight = success600;
  static const Color successContainerLight = success50;
  static const Color onSuccessLight = neutral0;
  static const Color onSuccessContainerLight = success700;

  static const Color neutralLight = neutral600;
  static const Color neutralContainerLight = neutral100;
  static const Color onNeutralContainerLight = neutral700;

  // ---------------------------------------------------------------------------
  // Dark theme semantic roles
  // ---------------------------------------------------------------------------

  static const Color surfaceDark = Color(0xFF0F1117);
  static const Color surfaceVariantDark = Color(0xFF1A1F2C);
  static const Color surfaceContainerDark = Color(0xFF242A36);
  static const Color onSurfaceDark = Color(0xFFE8EAED);
  static const Color onSurfaceVariantDark = Color(0xFF9AA0AC);
  static const Color onSurfaceMutedDark = Color(0xFF5C6370);

  static const Color primaryDark = brand400;
  static const Color primaryContainerDark = brand900;
  static const Color onPrimaryDark = neutral950;
  static const Color onPrimaryContainerDark = brand200;

  static const Color outlineDark = Color(0xFF3A3F4B);
  static const Color outlineVariantDark = Color(0xFF2D3240);
  static const Color scrimDark = Color(0x99000000); // black @ 60%

  static const Color dangerDark = danger400;
  static const Color dangerContainerDark = danger900;
  static const Color onDangerDark = neutral950;
  static const Color onDangerContainerDark = danger200;

  static const Color warningDark = warning400;
  static const Color warningContainerDark = warning900;
  static const Color onWarningDark = neutral950;
  static const Color onWarningContainerDark = warning200;

  static const Color successDark = success400;
  static const Color successContainerDark = success900;
  static const Color onSuccessDark = neutral950;
  static const Color onSuccessContainerDark = success200;

  static const Color neutralDark = Color(0xFF9AA0AC);
  static const Color neutralContainerDark = Color(0xFF242A36);
  static const Color onNeutralContainerDark = Color(0xFFCBD5E1);

  // ---------------------------------------------------------------------------
  // State layer opacities
  // ---------------------------------------------------------------------------

  static const double stateHoverOpacity = 0.08;
  static const double stateFocusOpacity = 0.12;
  static const double statePressedOpacity = 0.16;
  static const double stateDraggedOpacity = 0.16;
  static const double stateDisabledContainerOpacity = 0.12;
  static const double stateDisabledContentOpacity = 0.38;
}
