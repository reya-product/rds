import 'package:flutter/material.dart';
import 'package:rds/rds.dart';
import 'package:widgetbook/widgetbook.dart';

final onboardMemberFormComponent = WidgetbookComponent(
  name: 'Onboard Member Form',
  useCases: [
    WidgetbookUseCase(
      name: 'In modal',
      builder: (context) {
        final rds = Theme.of(context).extension<RdsTheme>()!;
        return Scaffold(
          backgroundColor: rds.surfaceVariant,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: EdgeInsets.all(rds.space6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RdsButton(
                      label: 'Onboard Member',
                      variant: RdsButtonVariant.primary,
                      icon: RdsIcons.add,
                      onPressed: () {
                        RdsModal.show(
                          context: context,
                          title: 'Onboard Member',
                          body: const _OnboardMemberForm(),
                          footerActions: [
                            RdsButton(
                              label: 'Done',
                              variant: RdsButtonVariant.primary,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            RdsButton(
                              label: 'Cancel',
                              variant: RdsButtonVariant.text,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Form only',
      builder: (context) {
        final rds = Theme.of(context).extension<RdsTheme>()!;
        return SingleChildScrollView(
          padding: EdgeInsets.all(rds.space6),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: const _OnboardMemberForm(),
          ),
        );
      },
    ),
  ],
);

// ---------------------------------------------------------------------------
// Form widget (shared between usecases)
// ---------------------------------------------------------------------------

class _OnboardMemberForm extends StatefulWidget {
  const _OnboardMemberForm();

  @override
  State<_OnboardMemberForm> createState() => _OnboardMemberFormState();
}

class _OnboardMemberFormState extends State<_OnboardMemberForm> {
  String? _gender;

  static const _genderItems = [
    RdsDropdownItem(value: 'male', label: 'Male'),
    RdsDropdownItem(value: 'female', label: 'Female'),
    RdsDropdownItem(value: 'non_binary', label: 'Non-binary'),
    RdsDropdownItem(value: 'prefer_not', label: 'Prefer not to say'),
  ];

  static const _pronounItems = [
    RdsDropdownItem(value: 'he_him', label: 'He / Him'),
    RdsDropdownItem(value: 'she_her', label: 'She / Her'),
    RdsDropdownItem(value: 'they_them', label: 'They / Them'),
    RdsDropdownItem(value: 'prefer_not', label: 'Prefer not to say'),
  ];

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RdsTextField(
          label: 'First Name',
          mandatory: true,
          onChanged: (_) {},
        ),
        SizedBox(height: rds.space4),
        RdsTextField(
          label: 'Last Name',
          mandatory: true,
          onChanged: (_) {},
        ),
        SizedBox(height: rds.space4),
        RdsTextField(
          label: 'Mobile #',
          mandatory: true,
          inputType: RdsTextFieldInputType.number,
          onChanged: (_) {},
        ),
        SizedBox(height: rds.space4),
        RdsTextField(
          label: 'Email',
          mandatory: true,
          onChanged: (_) {},
        ),
        SizedBox(height: rds.space6),
        Text(
          'Sex Assigned At Birth',
          style: rds.titleSmall.copyWith(color: rds.onSurface),
        ),
        SizedBox(height: rds.space3),
        RdsDropdownField(
          label: 'Gender',
          items: _genderItems,
          value: _gender,
          onChanged: (v) => setState(() => _gender = v as String?),
        ),
        SizedBox(height: rds.space4),
        RdsDropdownField(
          label: 'Preferred Pronouns',
          items: _pronounItems,
          onChanged: (_) {},
        ),
      ],
    );
  }
}
