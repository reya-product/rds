import 'package:flutter/material.dart';
import 'package:rds/rds.dart';

// ---------------------------------------------------------------------------
// DemoFeature
//
// A sample clickthrough prototype: "Onboard Member" flow.
// Replace this file with a real feature screen when building for customers.
//
// This is registered in registry.dart under the 'demo0000000000demo' slug.
// ---------------------------------------------------------------------------

class DemoFeature extends StatefulWidget {
  const DemoFeature({super.key});

  @override
  State<DemoFeature> createState() => _DemoFeatureState();
}

class _DemoFeatureState extends State<DemoFeature> {
  bool _modalOpen = false;

  @override
  Widget build(BuildContext context) {
    final rds = Theme.of(context).extension<RdsTheme>()!;

    // The prototype fills the entire screen — no AppBar, no nav.
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
                // ---- Context header ----
                Text(
                  'Member Management',
                  style: rds.headlineMedium.copyWith(color: rds.onSurface),
                ),
                SizedBox(height: rds.space1),
                Text(
                  'Add new members to the Reya platform.',
                  style: rds.bodyMedium.copyWith(color: rds.onSurfaceVariant),
                ),
                SizedBox(height: rds.space8),

                // ---- CTA card ----
                Container(
                  padding: EdgeInsets.all(rds.space6),
                  decoration: BoxDecoration(
                    color: rds.surface,
                    borderRadius: BorderRadius.circular(rds.radiusLg),
                    border: Border.all(color: rds.outlineVariant),
                    boxShadow: RdsShadows.shadowSm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          RdsBadge(
                            label: 'Onboarding',
                            color: RdsBadgeColor.primary,
                          ),
                          const Spacer(),
                          RdsBadge(label: '0 members', color: RdsBadgeColor.neutral),
                        ],
                      ),
                      SizedBox(height: rds.space4),
                      Text(
                        'Onboard a new member',
                        style: rds.titleMedium.copyWith(color: rds.onSurface),
                      ),
                      SizedBox(height: rds.space1),
                      Text(
                        'Enter their details to create a profile and send them an invite.',
                        style: rds.bodySmall.copyWith(color: rds.onSurfaceVariant),
                      ),
                      SizedBox(height: rds.space5),
                      RdsButton(
                        label: 'Onboard Member',
                        variant: RdsButtonVariant.primary,
                        icon: RdsIcons.add,
                        onPressed: () {
                          RdsModal.show(
                            context: context,
                            title: 'Onboard Member',
                            body: const _OnboardForm(),
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

                SizedBox(height: rds.space4),

                // ---- Hint ----
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      RdsIcons.info,
                      size: RdsIconSize.sm,
                      color: rds.onSurfaceMuted,
                    ),
                    SizedBox(width: rds.space1),
                    Text(
                      'Demo prototype — tap "Onboard Member" to interact.',
                      style: rds.labelSmall.copyWith(color: rds.onSurfaceMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _OnboardForm — form body used inside the RdsModal
// ---------------------------------------------------------------------------

class _OnboardForm extends StatefulWidget {
  const _OnboardForm();

  @override
  State<_OnboardForm> createState() => _OnboardFormState();
}

class _OnboardFormState extends State<_OnboardForm> {
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
          inputType: RdsTextFieldInputType.phone,
          onChanged: (_) {},
        ),
        SizedBox(height: rds.space4),
        RdsTextField(
          label: 'Email',
          mandatory: true,
          inputType: RdsTextFieldInputType.email,
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
