import 'package:flutter/material.dart';

import '../../../../core/validators/app_validator.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_checkbox.dart';
import '../../../../core/widgets/app_text_field.dart';

class CompanyForm extends StatefulWidget {
  const CompanyForm({
    super.key,

    // -----------------------------------------------------------
    // BASIC
    // -----------------------------------------------------------

    this.initialName,
    this.initialEmail,
    this.initialPhone,
    this.initialWebsite,

    // -----------------------------------------------------------
    // CONTACT
    // -----------------------------------------------------------

    this.initialAddress,
    this.initialContactPerson,

    // -----------------------------------------------------------
    // ADDITIONAL
    // -----------------------------------------------------------

    this.initialLogoUrl,

    // -----------------------------------------------------------
    // LEGAL
    // -----------------------------------------------------------

    this.initialTaxNumber,
    this.initialRegistrationNumber,

    // -----------------------------------------------------------
    // NOTES
    // -----------------------------------------------------------

    this.initialNotes,

    // -----------------------------------------------------------
    // STATUS
    // -----------------------------------------------------------

    this.initialIsActive = true,

    // -----------------------------------------------------------
    // CALLBACK
    // -----------------------------------------------------------

    required this.onSubmit,

    this.isLoading = false,
  });

  // =============================================================
  // INITIAL VALUES
  // =============================================================

  final String? initialName;
  final String? initialEmail;
  final String? initialPhone;
  final String? initialWebsite;

  final String? initialAddress;
  final String? initialContactPerson;

  final String? initialLogoUrl;

  final String? initialTaxNumber;
  final String? initialRegistrationNumber;

  final String? initialNotes;

  final bool initialIsActive;

  // =============================================================
  // STATE
  // =============================================================

  final bool isLoading;

  // =============================================================
  // SUBMIT
  // =============================================================

  final Future<void> Function(
      String name,
      String email,
      String phone,
      String website,
      String address,
      String contactPerson,
      String logoUrl,
      String taxNumber,
      String registrationNumber,
      String notes,
      bool isActive,
      ) onSubmit;

  @override
  State<CompanyForm> createState() => _CompanyFormState();
}

// =================================================================
// STATE
// =================================================================

class _CompanyFormState extends State<CompanyForm> {
  // =============================================================
  // FORM
  // =============================================================

  final _formKey = GlobalKey<FormState>();

  // =============================================================
  // CONTROLLERS
  // =============================================================

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _websiteController;
  late final TextEditingController _addressController;
  late final TextEditingController _contactPersonController;
  late final TextEditingController _logoUrlController;
  late final TextEditingController _taxNumberController;
  late final TextEditingController _registrationNumberController;
  late final TextEditingController _notesController;

  // =============================================================
  // STATUS
  // =============================================================

  late bool _isActive;

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.initialName ?? '',
    );

    _emailController = TextEditingController(
      text: widget.initialEmail ?? '',
    );

    _phoneController = TextEditingController(
      text: widget.initialPhone ?? '',
    );

    _websiteController = TextEditingController(
      text: widget.initialWebsite ?? '',
    );

    _addressController = TextEditingController(
      text: widget.initialAddress ?? '',
    );

    _contactPersonController = TextEditingController(
      text: widget.initialContactPerson ?? '',
    );

    _logoUrlController = TextEditingController(
      text: widget.initialLogoUrl ?? '',
    );

    _taxNumberController = TextEditingController(
      text: widget.initialTaxNumber ?? '',
    );

    _registrationNumberController =
        TextEditingController(
          text: widget.initialRegistrationNumber ?? '',
        );

    _notesController = TextEditingController(
      text: widget.initialNotes ?? '',
    );

    _isActive = widget.initialIsActive;
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _contactPersonController.dispose();
    _logoUrlController.dispose();
    _taxNumberController.dispose();
    _registrationNumberController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  // =============================================================
  // SUBMIT
  // =============================================================

  Future<void> _submit() async {
    if (widget.isLoading) {
      return;
    }

    FocusScope.of(context).unfocus();

    final form = _formKey.currentState;

    if (form == null) {
      return;
    }

    if (!form.validate()) {
      return;
    }

    await widget.onSubmit(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _phoneController.text.trim(),
      _websiteController.text.trim(),
      _addressController.text.trim(),
      _contactPersonController.text.trim(),
      _logoUrlController.text.trim(),
      _taxNumberController.text.trim(),
      _registrationNumberController.text.trim(),
      _notesController.text.trim(),
      _isActive,
    );
  }

  // =============================================================
  // SECTION HEADER
  // =============================================================

  Widget _sectionHeader({
    required BuildContext context,
    required IconData icon,
    required String title,
    required double iconSize,
    required double titleSize,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: iconSize + 20,
          height: iconSize + 20,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(
              alpha: 0.10,
            ),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: colorScheme.primary,
          ),
        ),

        const SizedBox(width: 10),

        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: titleSize,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  // =============================================================
  // SECTION DIVIDER
  // =============================================================

  Widget _divider(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(context)
          .colorScheme
          .outlineVariant,
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double cardPadding = isDesktop
        ? 22
        : isTablet
        ? 20
        : 16;

    final double titleSize = isDesktop
        ? 19
        : 18;

    final double sectionIconSize = isDesktop
        ? 21
        : 20;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // =====================================================
          // BASIC INFORMATION
          // =====================================================

          _sectionHeader(
            context: context,
            icon: Icons.business_outlined,
            title: 'Basic Information',
            iconSize: sectionIconSize,
            titleSize: titleSize,
          ),

          const SizedBox(height: 14),

          _divider(context),

          const SizedBox(height: 16),

          // =====================================================
          // COMPANY NAME
          // =====================================================

          AppTextField(
            controller: _nameController,
            label: 'Company Name',
            prefixIcon: Icons.business_outlined,
            validator: (value) => AppValidator.required(
              value,
              field: 'Company Name',
            ),
          ),

          const SizedBox(height: 16),

          // =====================================================
          // EMAIL
          // =====================================================

          AppTextField(
            controller: _emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: AppValidator.email,
          ),

          const SizedBox(height: 16),

          // =====================================================
          // PHONE
          // =====================================================

          AppTextField(
            controller: _phoneController,
            label: 'Phone',
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone_outlined,
            validator: AppValidator.phone,
          ),

          const SizedBox(height: 16),

          // =====================================================
          // WEBSITE
          // =====================================================

          AppTextField(
            controller: _websiteController,
            label: 'Website',
            keyboardType: TextInputType.url,
            prefixIcon: Icons.language_outlined,
          ),

          const SizedBox(height: 24),

          // =====================================================
          // CONTACT INFORMATION
          // =====================================================

          _sectionHeader(
            context: context,
            icon: Icons.contact_page_outlined,
            title: 'Contact Information',
            iconSize: sectionIconSize,
            titleSize: titleSize,
          ),

          const SizedBox(height: 14),

          _divider(context),

          const SizedBox(height: 16),

          // =====================================================
          // CONTACT PERSON
          // =====================================================

          AppTextField(
            controller: _contactPersonController,
            label: 'Contact Person',
            prefixIcon: Icons.person_outline,
          ),

          const SizedBox(height: 16),

          // =====================================================
          // ADDRESS
          // =====================================================

          AppTextField(
            controller: _addressController,
            label: 'Address',
            maxLines: 3,
            prefixIcon: Icons.location_on_outlined,
          ),

          const SizedBox(height: 24),

          // =====================================================
          // ADDITIONAL INFORMATION
          // =====================================================

          _sectionHeader(
            context: context,
            icon: Icons.folder_outlined,
            title: 'Additional Information',
            iconSize: sectionIconSize,
            titleSize: titleSize,
          ),

          const SizedBox(height: 14),

          _divider(context),

          const SizedBox(height: 16),

          // =====================================================
          // LOGO URL
          // =====================================================

          AppTextField(
            controller: _logoUrlController,
            label: 'Logo URL',
            keyboardType: TextInputType.url,
            prefixIcon: Icons.image_outlined,
          ),

          const SizedBox(height: 24),

          // =====================================================
          // LEGAL INFORMATION
          // =====================================================

          _sectionHeader(
            context: context,
            icon: Icons.gavel_outlined,
            title: 'Legal Information',
            iconSize: sectionIconSize,
            titleSize: titleSize,
          ),

          const SizedBox(height: 14),

          _divider(context),

          const SizedBox(height: 16),

          // =====================================================
          // TAX NUMBER
          // =====================================================

          AppTextField(
            controller: _taxNumberController,
            label: 'Tax Number',
            prefixIcon: Icons.receipt_long_outlined,
          ),

          const SizedBox(height: 16),

          // =====================================================
          // REGISTRATION NUMBER
          // =====================================================

          AppTextField(
            controller: _registrationNumberController,
            label: 'Registration Number',
            prefixIcon: Icons.badge_outlined,
          ),

          const SizedBox(height: 24),

          // =====================================================
          // NOTES
          // =====================================================

          _sectionHeader(
            context: context,
            icon: Icons.notes_outlined,
            title: 'Notes',
            iconSize: sectionIconSize,
            titleSize: titleSize,
          ),

          const SizedBox(height: 14),

          _divider(context),

          const SizedBox(height: 16),

          AppTextField(
            controller: _notesController,
            label: 'Notes',
            maxLines: 4,
            prefixIcon: Icons.notes_outlined,
          ),

          const SizedBox(height: 14),

          // =====================================================
          // ACTIVE COMPANY
          // =====================================================

          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colorScheme.outlineVariant,
              ),
            ),
            child: AppCheckbox(
              title: 'Active Company',
              value: _isActive,
              onChanged: widget.isLoading
                  ? (_) {}
                  : (value) {
                if (!mounted) {
                  return;
                }

                setState(() {
                  _isActive = value ?? true;
                });
              },
            ),
          ),

          const SizedBox(height: 30),

          // =====================================================
          // SAVE BUTTON
          // =====================================================

          AppButton(
            text: 'Save Company',
            icon: Icons.save_outlined,
            isLoading: widget.isLoading,
            onPressed: _submit,
          ),

          const SizedBox(height: 10),

          // =====================================================
          // HELPER TEXT
          // =====================================================

          Center(
            child: Text(
              'All company information will be securely saved.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}