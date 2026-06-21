import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// RDS icon aliases.
///
/// All icons are from Material Symbols — Outlined variant, weight 300.
/// Use [RdsIconSize] for the [size] parameter when rendering these icons.
///
/// Icon-only interactive elements MUST have a [Tooltip] with the action label
/// and a [Semantics] node with the appropriate label.
abstract final class RdsIcons {
  // ---------------------------------------------------------------------------
  // Navigation / directional
  // ---------------------------------------------------------------------------

  static const IconData arrowDown = Symbols.arrow_downward;
  static const IconData arrowUp = Symbols.arrow_upward;
  static const IconData chevronRight = Symbols.chevron_right;
  static const IconData chevronLeft = Symbols.chevron_left;
  static const IconData chevronDown = Symbols.keyboard_arrow_down;
  static const IconData chevronUp = Symbols.keyboard_arrow_up;
  static const IconData expand = Symbols.expand_more;
  static const IconData collapse = Symbols.expand_less;

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  static const IconData check = Symbols.check;
  static const IconData close = Symbols.close;
  static const IconData add = Symbols.add;
  static const IconData remove = Symbols.remove;
  static const IconData edit = Symbols.edit;
  static const IconData delete = Symbols.delete;
  static const IconData more = Symbols.more_horiz;
  static const IconData upload = Symbols.upload;
  static const IconData download = Symbols.download;
  static const IconData search = Symbols.search;
  static const IconData filter = Symbols.filter_list;
  static const IconData sort = Symbols.sort;

  // ---------------------------------------------------------------------------
  // Status / feedback
  // ---------------------------------------------------------------------------

  static const IconData info = Symbols.info;
  static const IconData warning = Symbols.warning;
  static const IconData error = Symbols.error;
  static const IconData success = Symbols.check_circle;

  // ---------------------------------------------------------------------------
  // Content / UI
  // ---------------------------------------------------------------------------

  static const IconData calendar = Symbols.calendar_today;
  static const IconData time = Symbols.schedule;
  static const IconData settings = Symbols.settings;
  static const IconData user = Symbols.person;
  static const IconData notification = Symbols.notifications;
  static const IconData eye = Symbols.visibility;
  static const IconData eyeOff = Symbols.visibility_off;
}
