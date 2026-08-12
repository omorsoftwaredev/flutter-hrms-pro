// ===============================================================
// Flutter HRMS Pro
// Department Form
//
// Company Owner Login Based
//
// Company ID:
// currentUserProvider → CurrentUser.companyId
//
// Company Owner কোনো Company Dropdown ব্যবহার করবে না.
// Company ID automatically logged-in session থেকে নেওয়া হবে.
//
// Version : 2.5.0
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
  //
  // companyId automatically currentUserProvider থেকে আসবে।
  //
  // Code automatically database trigger generate করবে।
  //
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
    // -----------------------------------------------------------
    // Validate Form
    // -----------------------------------------------------------

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // -----------------------------------------------------------
    // Get Logged-in User
    // -----------------------------------------------------------
    //
    // Company Owner login করার সময় AuthRepository:
    //
    // company_accounts
    //       ↓
    // company_id
    //       ↓
    // CurrentUser.companyId
    //       ↓
    // currentUserProvider
    //
    // এখান থেকেই Company ID নেওয়া হচ্ছে।
    //
    // -----------------------------------------------------------

    final user = ref.read(currentUserProvider);

    // -----------------------------------------------------------
    // User Check
    // -----------------------------------------------------------

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

    // -----------------------------------------------------------
    // Company ID Validation
    // -----------------------------------------------------------

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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // =====================================================
          // DEPARTMENT NAME
          // =====================================================

          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Department Name',
              hintText: 'Enter department name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.apartment_outlined,
              ),
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

          const SizedBox(height: 16),

          // =====================================================
          // DESCRIPTION
          // =====================================================

          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Enter department description',
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.description_outlined,
              ),
            ),
            maxLines: 3,
            textInputAction: TextInputAction.newline,
          ),

          const SizedBox(height: 16),

          // =====================================================
          // PHONE
          // =====================================================

          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone',
              hintText: 'Enter department phone',
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.phone_outlined,
              ),
            ),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 16),

          // =====================================================
          // EMAIL
          // =====================================================

          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter department email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.email_outlined,
              ),
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

          const SizedBox(height: 16),

          // =====================================================
          // LOCATION
          // =====================================================

          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Location',
              hintText: 'Enter department location',
              border: OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.location_on_outlined,
              ),
            ),
            textInputAction: TextInputAction.done,
          ),

          const SizedBox(height: 16),

          // =====================================================
          // ACTIVE STATUS
          // =====================================================

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Active',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text(
              'Enable or disable this department',
            ),
            value: _isActive,
            onChanged: widget.isLoading
                ? null
                : (value) {
              setState(() {
                _isActive = value;
              });
            },
          ),

          const SizedBox(height: 24),

          // =====================================================
          // SAVE BUTTON
          // =====================================================

          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed:
              widget.isLoading ? null : _save,
              child: widget.isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                'Save',
              ),
            ),
          ),
        ],
      ),
    );
  }
}