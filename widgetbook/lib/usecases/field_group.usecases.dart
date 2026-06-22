import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

// ignore_for_file: avoid_redundant_argument_values

// ---------------------------------------------------------------------------
// fieldGroupComponent
// ---------------------------------------------------------------------------

final fieldGroupComponent = WidgetbookComponent(
  name: 'Field Group',
  useCases: [
    WidgetbookUseCase(
      name: 'Phone number',
      builder: _phoneNumberUseCase,
    ),
    WidgetbookUseCase(
      name: 'Weight with unit',
      builder: _weightUseCase,
    ),
    WidgetbookUseCase(
      name: 'With error',
      builder: _errorUseCase,
    ),
  ],
);

// ---------------------------------------------------------------------------
// Phone number use case
// ---------------------------------------------------------------------------
//
// Left: a mock country-code "dropdown" (styled Container — the real
// CountryDropdown atom isn't built yet).
// Right: RdsTextField for the mobile number.

Widget _phoneNumberUseCase(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  return _GroupScaffold(
    child: RdsFieldGroup(
      label: 'Phone number',
      mandatory: true,
      supportText: 'Include country code.',
      leftFlex: 2,
      rightFlex: 3,
      leftChild: _MockCountryDropdown(rds: rds),
      rightChild: RdsTextField(
        label: 'Mobile number',
        placeholder: '07700 900000',
        inputType: RdsTextFieldInputType.integer,
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Weight with unit use case
// ---------------------------------------------------------------------------
//
// Left: RdsTextField for a float value.
// Right: a mock unit-picker dropdown.

Widget _weightUseCase(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  return _GroupScaffold(
    child: RdsFieldGroup(
      label: 'Weight',
      supportText: 'Enter your current weight.',
      leftFlex: 3,
      rightFlex: 2,
      leftChild: RdsTextField(
        label: 'Value',
        placeholder: '75.5',
        inputType: RdsTextFieldInputType.float,
      ),
      rightChild: _MockUnitDropdown(rds: rds),
    ),
  );
}

// ---------------------------------------------------------------------------
// Error state use case
// ---------------------------------------------------------------------------

Widget _errorUseCase(BuildContext context) {
  final rds = Theme.of(context).extension<RdsTheme>()!;
  return _GroupScaffold(
    child: RdsFieldGroup(
      label: 'Phone number',
      mandatory: true,
      errorText: 'Please enter a valid mobile number.',
      leftFlex: 2,
      rightFlex: 3,
      leftChild: _MockCountryDropdown(rds: rds),
      rightChild: RdsTextField(
        label: 'Mobile number',
        placeholder: '07700 900000',
        inputType: RdsTextFieldInputType.integer,
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Shared scaffold
// ---------------------------------------------------------------------------

class _GroupScaffold extends StatelessWidget {
  const _GroupScaffold({required this.child});

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
// Mock country-code dropdown
// ---------------------------------------------------------------------------
//
// Styled to look like a dropdown field cell. Real internationalisation /
// country-flag support is handled by the host app.

class _MockCountryDropdown extends StatefulWidget {
  const _MockCountryDropdown({required this.rds});

  final RdsTheme rds;

  @override
  State<_MockCountryDropdown> createState() => _MockCountryDropdownState();
}

class _MockCountryDropdownState extends State<_MockCountryDropdown> {
  String _selected = '+1';

  static const _options = ['+1', '+44', '+49', '+61', '+91'];

  @override
  Widget build(BuildContext context) {
    final rds = widget.rds;
    return PopupMenuButton<String>(
      initialValue: _selected,
      onSelected: (v) => setState(() => _selected = v),
      itemBuilder: (_) => _options
          .map(
            (code) => PopupMenuItem<String>(
              value: code,
              child: Text(code, style: rds.bodyMedium.copyWith(color: rds.onSurface)),
            ),
          )
          .toList(),
      child: Semantics(
        button: true,
        label: 'Country code, currently $_selected',
        child: Container(
          color: rds.surface,
          padding: EdgeInsets.symmetric(
            horizontal: rds.space3,
            vertical: rds.space3,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selected,
                style: rds.bodyMedium.copyWith(color: rds.onSurface),
              ),
              Icon(
                RdsIcons.chevronDown,
                size: RdsIconSize.md,
                color: rds.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Mock unit dropdown
// ---------------------------------------------------------------------------

class _MockUnitDropdown extends StatefulWidget {
  const _MockUnitDropdown({required this.rds});

  final RdsTheme rds;

  @override
  State<_MockUnitDropdown> createState() => _MockUnitDropdownState();
}

class _MockUnitDropdownState extends State<_MockUnitDropdown> {
  String _selected = 'kg';

  static const _options = ['kg', 'lb', 'st'];

  @override
  Widget build(BuildContext context) {
    final rds = widget.rds;
    return PopupMenuButton<String>(
      initialValue: _selected,
      onSelected: (v) => setState(() => _selected = v),
      itemBuilder: (_) => _options
          .map(
            (unit) => PopupMenuItem<String>(
              value: unit,
              child: Text(unit, style: rds.bodyMedium.copyWith(color: rds.onSurface)),
            ),
          )
          .toList(),
      child: Semantics(
        button: true,
        label: 'Unit, currently $_selected',
        child: Container(
          color: rds.surface,
          padding: EdgeInsets.symmetric(
            horizontal: rds.space3,
            vertical: rds.space3,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selected,
                style: rds.bodyMedium.copyWith(color: rds.onSurface),
              ),
              Icon(
                RdsIcons.chevronDown,
                size: RdsIconSize.md,
                color: rds.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
