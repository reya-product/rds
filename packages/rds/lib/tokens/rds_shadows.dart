import 'package:flutter/material.dart';

/// RDS shadow / elevation scale.
///
/// Elevation is expressed through shadow only — no color-tinting.
/// Use the shadow token that matches the component's elevation level.
abstract final class RdsShadows {
  static const List<BoxShadow> shadowNone = [];

  static const List<BoxShadow> shadowXs = [
    BoxShadow(
      color: Color(0x0D000000), // rgba(0,0,0,0.05)
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x1A000000), // rgba(0,0,0,0.10)
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
    BoxShadow(
      color: Color(0x0F000000), // rgba(0,0,0,0.06)
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x12000000), // rgba(0,0,0,0.07)
      offset: Offset(0, 4),
      blurRadius: 6,
    ),
    BoxShadow(
      color: Color(0x0F000000), // rgba(0,0,0,0.06)
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x1A000000), // rgba(0,0,0,0.10)
      offset: Offset(0, 10),
      blurRadius: 15,
    ),
    BoxShadow(
      color: Color(0x0D000000), // rgba(0,0,0,0.05)
      offset: Offset(0, 4),
      blurRadius: 6,
    ),
  ];

  static const List<BoxShadow> shadowXl = [
    BoxShadow(
      color: Color(0x1A000000), // rgba(0,0,0,0.10)
      offset: Offset(0, 20),
      blurRadius: 25,
    ),
    BoxShadow(
      color: Color(0x0A000000), // rgba(0,0,0,0.04)
      offset: Offset(0, 10),
      blurRadius: 10,
    ),
  ];
}
