// ===============================================================
// Flutter HRMS Pro
// Department Form
//
// Company Owner Login Based
//
// Company ID:
// currentUserProvider → CurrentUser.companyId
//
// Design:
// Theme Aware
// Responsive Sizing
// Professional HRMS UI
// Existing Layout Preserved
//
// Version : 3.0.0
// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/current_user_provider.dart';

class DepartmentForm extends ConsumerStatefulWidget {
  const DepartmentForm({
    super.key,
    this.initialName = '',
    this.initialDescription = '',
    this.initialPhone = '',
    this.initialEmail = '',
    this.initialLocation = '',
    this.initialIsActive = true,
    this.isLoading = false,
    required this.onSubmit,
  });

  // =============================================================
  // INITIAL VALUES
  // =============================================================

  final String initialName;
  final String initialDescription;
  final String initialPhone;
  final String initialEmail;
  final String initialLocation;
  final bool initialIsActive;

  final bool isLoading;

  // =============================================================
  // SUBMIT
  // =============================================================

  final Future<void> Function(
      String companyId,
      String name,
      String description,
      String phone,
      String email,
      String location,
      bool isActive,
      ) onSubmit;

  @override
  ConsumerState<DepartmentForm> createState() =>
      _DepartmentFormState();
}

// ===============================================================
// STATE
// ===============================================================

class _DepartmentFormState
    extends ConsumerState<DepartmentForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _locationController;

  late bool _isActive;

  // =============================================================
  // INIT STATE
  // =============================================================

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.initialName,
    );

    _descriptionController = TextEditingController(
      text: widget.initialDescription,
    );

    _phoneController = TextEditingController(
      text: widget.initialPhone,
    );

    _emailController = TextEditingController(
      text: widget.initialEmail,
    );

    _locationController = TextEditingController(
      text: widget.initialLocation,
    );

    _isActive = widget.initialIsActive;
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();

    super.dispose();
  }

  // =============================================================
  // SAVE
  // =============================================================

  Future<void> _save() async {
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

    // -----------------------------------------------------------
    // Get Logged-in User
    // -----------------------------------------------------------

    final user = ref.read(currentUserProvider);

    if (user == null) {
      _showError(
        'Current user information not found.',
      );

      return;
    }

    // -----------------------------------------------------------
    // Company ID
    // -----------------------------------------------------------

    final companyId = user.companyId.trim();

    if (companyId.isEmpty) {
      _showError(
        'Company ID not found for the logged-in account.',
      );

      return;
    }

    // -----------------------------------------------------------
    // Submit
    // -----------------------------------------------------------

    await widget.onSubmit(
      companyId,
      _nameController.text.trim(),
      _descriptionController.text.trim(),
      _phoneController.text.trim(),
      _emailController.text.trim(),
      _locationController.text.trim(),
      _isActive,
    );
  }

  // =============================================================
  // ERROR MESSAGE
  // =============================================================

  void _showError(String message) {
    if (!mounted) {
      return;
    }

    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.error,
      ),
    );
  }

  // =============================================================
  // INPUT DECORATION
  // =============================================================

  InputDecoration _decoration({
    required BuildContext context,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(
        icon,
        size: 21,
      ),

      filled: true,
      fillColor: colorScheme.surfaceContainerLow,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: colorScheme.error,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: colorScheme.error,
          width: 1.5,
        ),
      ),

      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),

      hintStyle: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant.withValues(
          alpha: 0.65,
        ),
      ),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
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

    final double fieldSpacing = isDesktop
        ? 18
        : isTablet
        ? 17
        : 16;

    final double buttonHeight = isDesktop
        ? 52
        : 50;

    final double iconSize = isDesktop
        ? 22
        : 21;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // =====================================================
          // DEPARTMENT NAME
          // =====================================================

          TextFormField(
            controller: _nameController,
            enabled: !widget.isLoading,
            decoration: _decoration(
              context: context,
              label: 'Department Name',
              hint: 'Enter department name',
              icon: Icons.apartment_outlined,
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Department name is required';
              }

              return null;
            },
          ),

          SizedBox(height: fieldSpacing),

          // =====================================================
          // DESCRIPTION
          // =====================================================

          TextFormField(
            controller: _descriptionController,
            enabled: !widget.isLoading,
            decoration: _decoration(
              context: context,
              label: 'Description',
              hint: 'Enter department description',
              icon: Icons.description_outlined,
            ),
            maxLines: 3,
            textInputAction: TextInputAction.newline,
          ),

          SizedBox(height: fieldSpacing),

          // =====================================================
          // PHONE
          // =====================================================

          TextFormField(
            controller: _phoneController,
            enabled: !widget.isLoading,
            decoration: _decoration(
              context: context,
              label: 'Phone',
              hint: 'Enter department phone',
              icon: Icons.phone_outlined,
            ),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),

          SizedBox(height: fieldSpacing),

          // =====================================================
          // EMAIL
          // =====================================================

          TextFormField(
            controller: _emailController,
            enabled: !widget.isLoading,
            decoration: _decoration(
              context: context,
              label: 'Email',
              hint: 'Enter department email',
              icon: Icons.email_outlined,
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              final email = value?.trim() ?? '';

              if (email.isEmpty) {
                return null;
              }

              final emailRegex = RegExp(
                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
              );

              if (!emailRegex.hasMatch(email)) {
                return 'Enter a valid email address';
              }

              return null;
            },
          ),

          SizedBox(height: fieldSpacing),

          // =====================================================
          // LOCATION
          // =====================================================

          TextFormField(
            controller: _locationController,
            enabled: !widget.isLoading,
            decoration: _decoration(
              context: context,
              label: 'Location',
              hint: 'Enter department location',
              icon: Icons.location_on_outlined,
            ),
            textInputAction: TextInputAction.done,
          ),

          SizedBox(height: fieldSpacing),

          // =====================================================
          // ACTIVE STATUS
          // =====================================================

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 16 : 14,
              vertical: isDesktop ? 12 : 10,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: colorScheme.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: isDesktop ? 42 : 40,
                  height: isDesktop ? 42 : 40,
                  decoration: BoxDecoration(
                    color: _isActive
                        ? colorScheme.secondaryContainer
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    _isActive
                        ? Icons.check_circle_outline_rounded
                        : Icons.pause_circle_outline_rounded,
                    size: iconSize,
                    color: _isActive
                        ? colorScheme.onSecondaryContainer
                        : colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Department',
                        style:
                        theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        _isActive
                            ? 'This department is currently active'
                            : 'This department is currently inactive',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                        theme.textTheme.bodySmall?.copyWith(
                          color:
                          colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Switch(
                  value: _isActive,
                  onChanged: widget.isLoading
                      ? null
                      : (value) {
                    if (!mounted) {
                      return;
                    }

                    setState(() {
                      _isActive = value;
                    });
                  },
                ),
              ],
            ),
          ),

          SizedBox(
            height: isDesktop ? 28 : 24,
          ),

          // =====================================================
          // SAVE BUTTON
          // =====================================================

          SizedBox(
            width: double.infinity,
            height: buttonHeight,
            child: FilledButton.icon(
              onPressed:
              widget.isLoading ? null : _save,
              icon: widget.isLoading
                  ? SizedBox(
                width: isDesktop ? 21 : 20,
                height: isDesktop ? 21 : 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.onPrimary,
                ),
              )
                  : Icon(
                Icons.save_outlined,
                size: iconSize,
              ),
              label: Text(
                widget.isLoading
                    ? 'Saving...'
                    : 'Save Department',
                style:
                theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                disabledBackgroundColor:
                colorScheme.surfaceContainerHighest,
                disabledForegroundColor:
                colorScheme.onSurfaceVariant,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // =====================================================
          // HELPER TEXT
          // =====================================================

          Text(
            'Department information will be securely saved.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}