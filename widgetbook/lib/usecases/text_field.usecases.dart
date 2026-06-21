import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

// ignore_for_file: avoid_redundant_argument_values

// ---------------------------------------------------------------------------
// RdsTextField component
// ---------------------------------------------------------------------------

final textFieldComponent = WidgetbookComponent(
  name: 'Text Field',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final label = context.knobs.string(
          label: 'Label',
          initialValue: 'Email address',
        );
        final placeholder = context.knobs.string(
          label: 'Placeholder',
          initialValue: 'you@example.com',
        );
        final supportTextRaw = context.knobs.string(
          label: 'Support text',
          initialValue: "We'll never share your email.",
        );
        final errorTextRaw = context.knobs.string(
          label: 'Error text',
          initialValue: '',
        );
        final disabled = context.knobs.boolean(
          label: 'Disabled',
          initialValue: false,
        );
        final readOnly = context.knobs.boolean(
          label: 'Read only',
          initialValue: false,
        );
        final mandatory = context.knobs.boolean(
          label: 'Mandatory',
          initialValue: false,
        );
        final optional = context.knobs.boolean(
          label: 'Optional',
          initialValue: false,
        );
        final inputType = context.knobs.list(
          label: 'Input type',
          options: RdsTextFieldInputType.values,
          initialOption: RdsTextFieldInputType.characters,
          labelBuilder: (v) => v.name,
        );

        return _FieldScaffold(
          child: RdsTextField(
            label: label,
            placeholder: placeholder.isNotEmpty ? placeholder : null,
            supportText: supportTextRaw.isNotEmpty ? supportTextRaw : null,
            errorText: errorTextRaw.isNotEmpty ? errorTextRaw : null,
            disabled: disabled,
            readOnly: readOnly,
            mandatory: mandatory,
            optional: optional,
            inputType: inputType,
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'States gallery',
      builder: (context) => const _TextFieldStatesGallery(),
    ),
  ],
);

// ---------------------------------------------------------------------------
// RdsTextArea component
// ---------------------------------------------------------------------------

final textAreaComponent = WidgetbookComponent(
  name: 'Text Area',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final label = context.knobs.string(
          label: 'Label',
          initialValue: 'Clinical notes',
        );
        final placeholder = context.knobs.string(
          label: 'Placeholder',
          initialValue: 'Enter your observations here…',
        );
        final supportTextRaw = context.knobs.string(
          label: 'Support text',
          initialValue: 'Maximum 500 characters.',
        );
        final errorTextRaw = context.knobs.string(
          label: 'Error text',
          initialValue: '',
        );
        final disabled = context.knobs.boolean(
          label: 'Disabled',
          initialValue: false,
        );
        final readOnly = context.knobs.boolean(
          label: 'Read only',
          initialValue: false,
        );
        final mandatory = context.knobs.boolean(
          label: 'Mandatory',
          initialValue: false,
        );
        final minLines = context.knobs.double.slider(
          label: 'Min lines',
          initialValue: 3,
          min: 1,
          max: 8,
          divisions: 7,
        );
        final showMaxLength = context.knobs.boolean(
          label: 'Show max length (500)',
          initialValue: false,
        );

        return _FieldScaffold(
          child: RdsTextArea(
            label: label,
            placeholder: placeholder.isNotEmpty ? placeholder : null,
            supportText: supportTextRaw.isNotEmpty ? supportTextRaw : null,
            errorText: errorTextRaw.isNotEmpty ? errorTextRaw : null,
            disabled: disabled,
            readOnly: readOnly,
            mandatory: mandatory,
            minLines: minLines.toInt().clamp(1, 20),
            maxLength: showMaxLength ? 500 : null,
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'States gallery',
      builder: (context) => const _TextAreaStatesGallery(),
    ),
  ],
);

// ---------------------------------------------------------------------------
// RdsPasswordField component
// ---------------------------------------------------------------------------

final passwordFieldComponent = WidgetbookComponent(
  name: 'Password Field',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final label = context.knobs.string(
          label: 'Label',
          initialValue: 'Password',
        );
        final placeholder = context.knobs.string(
          label: 'Placeholder',
          initialValue: 'Enter your password',
        );
        final supportTextRaw = context.knobs.string(
          label: 'Support text',
          initialValue: 'Minimum 8 characters.',
        );
        final errorTextRaw = context.knobs.string(
          label: 'Error text',
          initialValue: '',
        );
        final disabled = context.knobs.boolean(
          label: 'Disabled',
          initialValue: false,
        );
        final readOnly = context.knobs.boolean(
          label: 'Read only',
          initialValue: false,
        );
        final mandatory = context.knobs.boolean(
          label: 'Mandatory',
          initialValue: false,
        );

        return _FieldScaffold(
          child: RdsPasswordField(
            label: label,
            placeholder: placeholder.isNotEmpty ? placeholder : null,
            supportText: supportTextRaw.isNotEmpty ? supportTextRaw : null,
            errorText: errorTextRaw.isNotEmpty ? errorTextRaw : null,
            disabled: disabled,
            readOnly: readOnly,
            mandatory: mandatory,
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'States gallery',
      builder: (context) => const _PasswordFieldStatesGallery(),
    ),
  ],
);

// ---------------------------------------------------------------------------
// RdsSearchBar component
// ---------------------------------------------------------------------------

final searchBarComponent = WidgetbookComponent(
  name: 'Search Bar',
  useCases: [
    WidgetbookUseCase(
      name: 'Playground',
      builder: (context) {
        final placeholder = context.knobs.string(
          label: 'Placeholder',
          initialValue: 'Search patients…',
        );
        final disabled = context.knobs.boolean(
          label: 'Disabled',
          initialValue: false,
        );

        return _FieldScaffold(
          child: RdsSearchBar(
            placeholder: placeholder,
            disabled: disabled,
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'States gallery',
      builder: (context) => const _SearchBarStatesGallery(),
    ),
  ],
);

// ---------------------------------------------------------------------------
// Shared scaffold
// ---------------------------------------------------------------------------

class _FieldScaffold extends StatelessWidget {
  const _FieldScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(rds.space8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// State demo widget (static visual states, no live focus possible)
// ---------------------------------------------------------------------------

class _StateDemoRow extends StatelessWidget {
  const _StateDemoRow({required this.stateLabel, required this.field});

  final String stateLabel;
  final Widget field;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;
    return Padding(
      padding: EdgeInsets.only(bottom: rds.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stateLabel,
            style: rds.labelMedium.copyWith(color: rds.onSurfaceMuted),
          ),
          SizedBox(height: rds.space2),
          field,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TextField states gallery
// ---------------------------------------------------------------------------

class _TextFieldStatesGallery extends StatelessWidget {
  const _TextFieldStatesGallery();

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(rds.space8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Text Field — States',
                style: rds.titleLarge.copyWith(color: rds.onSurface),
              ),
              SizedBox(height: rds.space6),
              _StateDemoRow(
                stateLabel: 'Enabled (empty)',
                field: const RdsTextField(
                  label: 'Label',
                  placeholder: 'Placeholder text',
                  supportText: 'Helper text',
                ),
              ),
              _StateDemoRow(
                stateLabel: 'Enabled (filled)',
                field: RdsTextField(
                  label: 'Label',
                  controller: TextEditingController(text: 'Filled value'),
                  supportText: 'Helper text',
                ),
              ),
              _StateDemoRow(
                stateLabel: 'Focused (simulated — primary border 2px)',
                field: _FocusedFieldDemo(
                  child: const RdsTextField(
                    label: 'Label',
                    placeholder: 'Placeholder text',
                  ),
                ),
              ),
              _StateDemoRow(
                stateLabel: 'Error',
                field: RdsTextField(
                  label: 'Label',
                  controller: TextEditingController(text: 'bad@'),
                  errorText: 'Enter a valid email address.',
                ),
              ),
              _StateDemoRow(
                stateLabel: 'Disabled',
                field: const RdsTextField(
                  label: 'Label',
                  placeholder: 'Placeholder text',
                  disabled: true,
                  supportText: 'This field is disabled.',
                ),
              ),
              _StateDemoRow(
                stateLabel: 'Read only',
                field: RdsTextField(
                  label: 'Label',
                  controller: TextEditingController(text: 'Read-only value'),
                  readOnly: true,
                  supportText: 'This field cannot be edited.',
                ),
              ),
              _StateDemoRow(
                stateLabel: 'Mandatory',
                field: const RdsTextField(
                  label: 'Label',
                  placeholder: 'Required field',
                  mandatory: true,
                ),
              ),
              _StateDemoRow(
                stateLabel: 'With leading icon',
                field: const RdsTextField(
                  label: 'Email',
                  placeholder: 'you@example.com',
                  leadingIcon: RdsIcons.user,
                ),
              ),
              _StateDemoRow(
                stateLabel: 'Integer input type',
                field: const RdsTextField(
                  label: 'Age',
                  placeholder: '25',
                  inputType: RdsTextFieldInputType.integer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TextArea states gallery
// ---------------------------------------------------------------------------

class _TextAreaStatesGallery extends StatelessWidget {
  const _TextAreaStatesGallery();

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(rds.space8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Text Area — States',
                style: rds.titleLarge.copyWith(color: rds.onSurface),
              ),
              SizedBox(height: rds.space6),
              _StateDemoRow(
                stateLabel: 'Enabled (empty)',
                field: const RdsTextArea(
                  label: 'Clinical notes',
                  placeholder: 'Enter your observations…',
                  supportText: 'Maximum 500 characters.',
                ),
              ),
              _StateDemoRow(
                stateLabel: 'Enabled (filled)',
                field: RdsTextArea(
                  label: 'Clinical notes',
                  controller: TextEditingController(
                    text: 'Patient presents with mild fatigue and elevated cortisol levels consistent with adrenal stress.',
                  ),
                ),
              ),
              _StateDemoRow(
                stateLabel: 'With character counter',
                field: RdsTextArea(
                  label: 'Notes',
                  controller: TextEditingController(text: 'Some notes here.'),
                  maxLength: 200,
                ),
              ),
              _StateDemoRow(
                stateLabel: 'Error',
                field: RdsTextArea(
                  label: 'Clinical notes',
                  controller: TextEditingController(text: 'x'),
                  errorText: 'Notes must be at least 10 characters.',
                ),
              ),
              _StateDemoRow(
                stateLabel: 'Disabled',
                field: const RdsTextArea(
                  label: 'Clinical notes',
                  placeholder: 'Not available',
                  disabled: true,
                ),
              ),
              _StateDemoRow(
                stateLabel: 'Read only',
                field: RdsTextArea(
                  label: 'Clinical notes',
                  controller: TextEditingController(
                    text: 'This is a read-only note that cannot be edited.',
                  ),
                  readOnly: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PasswordField states gallery
// ---------------------------------------------------------------------------

class _PasswordFieldStatesGallery extends StatelessWidget {
  const _PasswordFieldStatesGallery();

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(rds.space8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password Field — States',
                style: rds.titleLarge.copyWith(color: rds.onSurface),
              ),
              SizedBox(height: rds.space6),
              _StateDemoRow(
                stateLabel: 'Enabled (empty)',
                field: const RdsPasswordField(
                  label: 'Password',
                  placeholder: 'Enter your password',
                  supportText: 'Minimum 8 characters.',
                ),
              ),
              _StateDemoRow(
                stateLabel: 'Enabled (filled — obscured)',
                field: RdsPasswordField(
                  label: 'Password',
                  controller: TextEditingController(text: 'myP@ssword123'),
                  supportText: 'Minimum 8 characters.',
                ),
              ),
              _StateDemoRow(
                stateLabel: 'Mandatory',
                field: const RdsPasswordField(
                  label: 'Password',
                  placeholder: 'Enter your password',
                  mandatory: true,
                ),
              ),
              _StateDemoRow(
                stateLabel: 'Error',
                field: RdsPasswordField(
                  label: 'Password',
                  controller: TextEditingController(text: 'short'),
                  errorText: 'Password must be at least 8 characters.',
                ),
              ),
              _StateDemoRow(
                stateLabel: 'Disabled',
                field: const RdsPasswordField(
                  label: 'Password',
                  placeholder: 'Enter your password',
                  disabled: true,
                ),
              ),
              _StateDemoRow(
                stateLabel: 'Read only',
                field: RdsPasswordField(
                  label: 'Password',
                  controller: TextEditingController(text: 'hidden-value'),
                  readOnly: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SearchBar states gallery
// ---------------------------------------------------------------------------

class _SearchBarStatesGallery extends StatelessWidget {
  const _SearchBarStatesGallery();

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Scaffold(
      backgroundColor: rds.surfaceVariant,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(rds.space8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search Bar — States',
                style: rds.titleLarge.copyWith(color: rds.onSurface),
              ),
              SizedBox(height: rds.space6),
              _StateDemoRow(
                stateLabel: 'Empty (surfaceContainer bg)',
                field: const RdsSearchBar(
                  placeholder: 'Search patients…',
                ),
              ),
              _StateDemoRow(
                stateLabel: 'With content (shows clear button)',
                field: RdsSearchBar(
                  placeholder: 'Search patients…',
                  controller: TextEditingController(text: 'John Doe'),
                ),
              ),
              _StateDemoRow(
                stateLabel: 'Disabled',
                field: const RdsSearchBar(
                  placeholder: 'Search patients…',
                  disabled: true,
                ),
              ),
              _StateDemoRow(
                stateLabel: 'Focused (simulated — primary border, surface bg)',
                field: _FocusedSearchDemo(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Focused state visual simulation helpers
// ---------------------------------------------------------------------------

/// Wraps a field in an auto-focusing container to simulate the focused border
/// state in a static gallery view.
class _FocusedFieldDemo extends StatefulWidget {
  const _FocusedFieldDemo({required this.child});

  final Widget child;

  @override
  State<_FocusedFieldDemo> createState() => _FocusedFieldDemoState();
}

class _FocusedFieldDemoState extends State<_FocusedFieldDemo> {
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Schedule focus after the first frame so the tree is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RdsTextField(
      label: 'Label',
      placeholder: 'Focused state',
      focusNode: _focus,
    );
  }
}

/// Focused simulation for the search bar.
class _FocusedSearchDemo extends StatefulWidget {
  @override
  State<_FocusedSearchDemo> createState() => _FocusedSearchDemoState();
}

class _FocusedSearchDemoState extends State<_FocusedSearchDemo> {
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RdsSearchBar(
      placeholder: 'Search patients…',
      focusNode: _focus,
    );
  }
}
