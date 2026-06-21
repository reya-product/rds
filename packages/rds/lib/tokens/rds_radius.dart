import 'package:flutter/material.dart';

/// RDS border-radius scale.
///
/// Use [double] variants when you need a raw radius value.
/// Use [BorderRadius] variants for convenience in [BoxDecoration] and [ShapeBorder].
abstract final class RdsRadius {
  // ---------------------------------------------------------------------------
  // Raw double values
  // ---------------------------------------------------------------------------

  static const double radiusNone = 0;
  static const double radiusXs = 2;
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radius2xl = 24;
  static const double radiusFull = 9999;

  // ---------------------------------------------------------------------------
  // BorderRadius convenience values
  // ---------------------------------------------------------------------------

  static const BorderRadius borderRadiusNone = BorderRadius.zero;

  static const BorderRadius borderRadiusXs = BorderRadius.all(
    Radius.circular(radiusXs),
  );

  static const BorderRadius borderRadiusSm = BorderRadius.all(
    Radius.circular(radiusSm),
  );

  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(radiusMd),
  );

  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(radiusLg),
  );

  static const BorderRadius borderRadiusXl = BorderRadius.all(
    Radius.circular(radiusXl),
  );

  static const BorderRadius borderRadius2xl = BorderRadius.all(
    Radius.circular(radius2xl),
  );

  static const BorderRadius borderRadiusFull = BorderRadius.all(
    Radius.circular(radiusFull),
  );
}
