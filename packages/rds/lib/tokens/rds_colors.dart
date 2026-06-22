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
  // Reya brand — purple / violet
  // ---------------------------------------------------------------------------

  static const Color reyaPurple900 = Color(0xFF150C29);
  static const Color reyaPurple800 = Color(0xFF3A00B8);
  static const Color reyaPurple700 = Color(0xFF493375);
  static const Color reyaPurple600 = Color(0xFF6A4CA9);
  static const Color reyaPurple400 = Color(0xFFA592CE);
  static const Color reyaPurple300 = Color(0xFFA699C4);
  static const Color reyaPurple200 = Color(0xFFE3DBF5);

  // ---------------------------------------------------------------------------
  // Legacy brand teal — kept for badge color compatibility
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
  // Reya light semantic roles
  // ---------------------------------------------------------------------------

  static const Color surfaceLight = Color(0xFFFBFBFB);
  static const Color surfaceVariantLight = Color(0xFFE3E3E3);
  static const Color surfaceContainerLight = Color(0xFFEFEFEF);
  static const Color onSurfaceLight = Color(0xFF1C1C1C);
  static const Color onSurfaceVariantLight = Color(0xFF5F5F5F);
  static const Color onSurfaceMutedLight = Color(0xFF7B7B7B);

  static const Color primaryLight = reyaPurple600;
  static const Color primaryContainerLight = reyaPurple300;
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onPrimaryContainerLight = reyaPurple900;

  static const Color outlineLight = Color(0xFF787878);
  static const Color outlineVariantLight = Color(0xFFC7C7C7);
  static const Color scrimLight = Color(0x661C1C1C);

  static const Color dangerLight = Color(0xFFBA1A1A);
  static const Color dangerContainerLight = Color(0xFFFFE2DE);
  static const Color onDangerLight = Color(0xFFFFFFFF);
  static const Color onDangerContainerLight = Color(0xFFBA1A1A);

  static const Color warningLight = Color(0xFFAD6430);
  static const Color warningContainerLight = Color(0xFFFADECA);
  static const Color onWarningLight = Color(0xFFFFFFFF);
  static const Color onWarningContainerLight = Color(0xFFAD6430);

  static const Color successLight = Color(0xFF0D871D);
  static const Color successContainerLight = Color(0xFFDCEDDC);
  static const Color onSuccessLight = Color(0xFFFFFFFF);
  static const Color onSuccessContainerLight = Color(0xFF0D871D);

  static const Color neutralLight = Color(0xFF596561);
  static const Color neutralContainerLight = Color(0xFFE9E9E9);
  static const Color onNeutralContainerLight = reyaPurple900;

  // ---------------------------------------------------------------------------
  // Reya dark semantic roles
  // ---------------------------------------------------------------------------

  static const Color surfaceDark = Color(0xFF2E2E2E);
  static const Color surfaceVariantDark = Color(0xFF454545);
  static const Color surfaceContainerDark = Color(0xFF4A4A4A);
  static const Color onSurfaceDark = Color(0xFFFCFCFC);
  static const Color onSurfaceVariantDark = Color(0xFFADADAD);
  static const Color onSurfaceMutedDark = Color(0xFFACACAC);

  static const Color primaryDark = reyaPurple400;
  static const Color primaryContainerDark = reyaPurple800;
  static const Color onPrimaryDark = Color(0xFF232323);
  static const Color onPrimaryContainerDark = Color(0xFFFCFCFC);

  static const Color outlineDark = Color(0xFFF3F3F3);
  static const Color outlineVariantDark = Color(0xFF545454);
  static const Color scrimDark = Color(0x99000000);

  static const Color dangerDark = Color(0xFFFF453A);
  static const Color dangerContainerDark = Color(0xFF700E00);
  static const Color onDangerDark = Color(0xFF232323);
  static const Color onDangerContainerDark = Color(0xFFFF453A);

  static const Color warningDark = Color(0xFFFFA601);
  static const Color warningContainerDark = Color(0xFFA84F10);
  static const Color onWarningDark = Color(0xFF232323);
  static const Color onWarningContainerDark = Color(0xFFFFA601);

  static const Color successDark = Color(0xFF34C761);
  static const Color successContainerDark = Color(0xFF3E793E);
  static const Color onSuccessDark = Color(0xFF232323);
  static const Color onSuccessContainerDark = Color(0xFF34C761);

  static const Color neutralDark = Color(0xFF908F93);
  static const Color neutralContainerDark = Color(0xFF737373);
  static const Color onNeutralContainerDark = Color(0xFFFCFCFC);

  // ---------------------------------------------------------------------------
  // Icon / shape colors (theme-independent)
  // ---------------------------------------------------------------------------

  static const Color iconError = Color(0xFFE96363);
  static const Color iconWarning = Color(0xFFEF7015);
  static const Color iconSuccess = Color(0xFF6FA05A);
  static const Color iconBlue = Color(0xFF5E98BC);
  static const Color iconPurple = Color(0xFF9E7BC5);
  static const Color iconPink = Color(0xFFD765A1);
  static const Color iconYellow = Color(0xFFB78F01);

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
