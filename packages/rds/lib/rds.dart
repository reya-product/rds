/// RDS — Reya Design System
///
/// The single import for all RDS tokens, themes, and components.
///
/// ```dart
/// import 'package:rds/rds.dart';
/// ```
library rds;

// ---------------------------------------------------------------------------
// Tokens
// ---------------------------------------------------------------------------

export 'tokens/rds_colors.dart';
export 'tokens/rds_typography.dart';
export 'tokens/rds_spacing.dart';
export 'tokens/rds_radius.dart';
export 'tokens/rds_shadows.dart';
export 'tokens/rds_motion.dart';
export 'tokens/rds_opacity.dart';
export 'tokens/rds_icons.dart';
export 'tokens/rds_icon_size.dart';

// ---------------------------------------------------------------------------
// Theme
// ---------------------------------------------------------------------------

export 'theme/rds_theme_data.dart';
export 'theme/rds_theme.dart';
export 'theme/rds_themes.dart';

// ---------------------------------------------------------------------------
// Components — T1 Atoms (wired 2026-06-22)
// ---------------------------------------------------------------------------

// Button family
export 'components/button/rds_button.dart';
export 'components/button_group/rds_button_group.dart';
export 'components/segmented_buttons/rds_segmented_buttons.dart';

// Badge, Avatar, Tooltip, Input Chip
export 'components/badge/rds_badge.dart';
export 'components/avatar/rds_avatar.dart';
export 'components/tooltip/rds_tooltip.dart';
export 'components/input_chip/rds_input_chip.dart';

// Checkbox, Radio, Toggle, Toast
export 'components/checkbox/rds_checkbox.dart';
export 'components/radio/rds_radio.dart';
export 'components/toggle_switch/rds_toggle_switch.dart';
export 'components/toast/rds_toast_widget.dart';
export 'components/toast/rds_toast.dart';

// Tabs
export 'components/tabs/rds_tab_item.dart';
export 'components/tabs/rds_tabs.dart';
export 'components/vertical_tabs/rds_vertical_tab_item.dart';
export 'components/vertical_tabs/rds_vertical_tabs.dart';

// Date / Time pickers
export 'components/date_picker/rds_picker_models.dart';
export 'components/date_picker/rds_date_picker.dart';
export 'components/date_picker/rds_date_range_picker.dart';
export 'components/date_picker/rds_date_time_picker.dart';
export 'components/date_picker/rds_time_picker.dart';

// Base fields
export 'components/text_field/rds_text_field.dart';
export 'components/text_field/rds_text_area.dart';
export 'components/text_field/rds_password_field.dart';
export 'components/text_field/rds_search_bar.dart';

// ---------------------------------------------------------------------------
// Components — T2a Molecules (wired 2026-06-22)
// ---------------------------------------------------------------------------

export 'components/segmented_control_input/rds_segmented_control_input.dart';
export 'components/checkbox_input/rds_checkbox_input.dart';
export 'components/date_field/rds_date_field.dart';
export 'components/date_field/rds_time_field.dart';
export 'components/date_field/rds_date_time_field.dart';
export 'components/list_item/rds_list_item.dart';
export 'components/list_item/rds_list_item_config.dart';
export 'components/field_group/rds_field_group.dart';
export 'components/field_uploader/rds_field_uploader.dart';
export 'components/field_uploader/rds_uploaded_file.dart';

// ---------------------------------------------------------------------------
// Components — T2b List-based (wired 2026-06-22)
// ---------------------------------------------------------------------------

export 'components/dropdown_popup/rds_dropdown_popup.dart';
export 'components/dropdown_popup/rds_dropdown_item.dart';
export 'components/list/rds_list.dart';
export 'components/list_inputs/rds_list_input_item.dart';
export 'components/list_inputs/rds_multi_select_list_input.dart';
export 'components/list_inputs/rds_single_select_list_input.dart';
export 'components/list_inputs/rds_toggle_list_input.dart';

// ---------------------------------------------------------------------------
// Components — T3 Organisms (wired 2026-06-22)
// ---------------------------------------------------------------------------

export 'components/card/rds_card.dart';
export 'components/card/rds_card_action.dart';
export 'components/dropdown_field/rds_dropdown_field.dart';
export 'components/combobox_field/rds_combobox_field.dart';
export 'components/table/rds_compact_table.dart';
