// ===============================================================
// Flutter HRMS Pro
// Role Permissions Form
//
// Company Owner Login Based
//
// Company ID:
// currentUserProvider → CurrentUser.companyId
//
// Company Owner কোনো Company Dropdown ব্যবহার করবে না.
//
// Role:
// Selected Company-এর roles থেকে automatically filter হবে.
//
// Version : 2.5.0
// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../../../role/presentation/providers/role_provider.dart';

class RolePermissionsForm extends ConsumerStatefulWidget {
  const RolePermissionsForm({
    super.key,

    this.initialCompanyId = '',
    this.initialRoleId = '',

    this.initialModuleName = '',

    this.initialCanView = false,
    this.initialCanCreate = false,
    this.initialCanUpdate = false,
    this.initialCanDelete = false,
    this.initialCanExport = false,
    this.initialCanApprove = false,

    this.isLoading = false,

    required this.onSubmit,
  });

  // =============================================================
  // INITIAL VALUES
  // =============================================================

  final String initialCompanyId;

  final String initialRoleId;

  final String initialModuleName;

  final bool initialCanView;
  final bool initialCanCreate;
  final bool initialCanUpdate;
  final bool initialCanDelete;
  final bool initialCanExport;
  final bool initialCanApprove;

  final bool isLoading;

  // =============================================================
  // SUBMIT
  // =============================================================

  final Future<void> Function(
      String companyId,
      String roleId,
      String moduleName,
      bool canView,
      bool canCreate,
      bool canUpdate,
      bool canDelete,
      bool canExport,
      bool canApprove,
      ) onSubmit;

  @override
  ConsumerState<RolePermissionsForm> createState() =>
      _RolePermissionsFormState();
}

// ===============================================================
// STATE
// ===============================================================

class _RolePermissionsFormState
    extends ConsumerState<RolePermissionsForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _moduleController;

  String? _roleId;

  bool _canView = false;
  bool _canCreate = false;
  bool _canUpdate = false;
  bool _canDelete = false;
  bool _canExport = false;
  bool _canApprove = false;

  // =============================================================
  // INIT STATE
  // =============================================================

  @override
  void initState() {
    super.initState();

    _roleId = widget.initialRoleId.isEmpty
        ? null
        : widget.initialRoleId;

    _moduleController = TextEditingController(
      text: widget.initialModuleName,
    );

    _canView = widget.initialCanView;
    _canCreate = widget.initialCanCreate;
    _canUpdate = widget.initialCanUpdate;
    _canDelete = widget.initialCanDelete;
    _canExport = widget.initialCanExport;
    _canApprove = widget.initialCanApprove;
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    _moduleController.dispose();

    super.dispose();
  }

  // =============================================================
  // SAVE
  // =============================================================

  Future<void> _save() async {
    // -----------------------------------------------------------
    // FORM VALIDATION
    // -----------------------------------------------------------

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // -----------------------------------------------------------
    // CURRENT LOGGED-IN USER
    // -----------------------------------------------------------

    final user = ref.read(currentUserProvider);

    // -----------------------------------------------------------
    // USER VALIDATION
    // -----------------------------------------------------------

    if (user == null) {
      _showError(
        'Current user information not found.',
      );

      return;
    }

    // -----------------------------------------------------------
    // COMPANY ID
    // -----------------------------------------------------------
    //
    // Company Owner:
    //
    // company_accounts.id
    //        ↓
    // AuthRepository
    //        ↓
    // CurrentUser.companyId
    //        ↓
    // currentUserProvider
    //
    // Company dropdown ব্যবহার করা হচ্ছে না।
    //
    // -----------------------------------------------------------

    final companyId = user.companyId.trim();

    // -----------------------------------------------------------
    // COMPANY ID VALIDATION
    // -----------------------------------------------------------

    if (companyId.isEmpty) {
      _showError(
        'Company ID not found for the logged-in account.',
      );

      return;
    }

    // -----------------------------------------------------------
    // ROLE VALIDATION
    // -----------------------------------------------------------

    if (_roleId == null || _roleId!.trim().isEmpty) {
      _showError(
        'Please select role.',
      );

      return;
    }

    // -----------------------------------------------------------
    // SUBMIT
    // -----------------------------------------------------------

    await widget.onSubmit(
      companyId,
      _roleId!,
      _moduleController.text.trim(),
      _canView,
      _canCreate,
      _canUpdate,
      _canDelete,
      _canExport,
      _canApprove,
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
  // PERMISSION SWITCH
  // =============================================================

  Widget permissionSwitch(
      String title,
      bool value,
      ValueChanged<bool> onChanged,
      ) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      value: value,
      onChanged: widget.isLoading
          ? null
          : onChanged,
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    // -----------------------------------------------------------
    // CURRENT USER
    // -----------------------------------------------------------

    final user = ref.watch(currentUserProvider);

    // -----------------------------------------------------------
    // COMPANY ID
    // -----------------------------------------------------------

    final companyId = user?.companyId.trim() ?? '';

    // -----------------------------------------------------------
    // ROLE STATE
    // -----------------------------------------------------------

    final roleState = ref.watch(roleProvider);

    // -----------------------------------------------------------
    // COMPANY-SPECIFIC ROLES
    // -----------------------------------------------------------

    final filteredRoles = roleState.roles
        .where(
          (role) => role.companyId == companyId,
    )
        .toList();

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // ===================================================
            // ROLE
            // ===================================================

            DropdownButtonFormField<String>(
              value: _roleId,
              decoration: const InputDecoration(
                labelText: 'Select Role',
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.badge_outlined,
                ),
              ),
              items: filteredRoles
                  .map(
                    (role) => DropdownMenuItem<String>(
                  value: role.id,
                  child: Text(
                    role.roleName,
                  ),
                ),
              )
                  .toList(),
              onChanged:
              widget.isLoading ||
                  companyId.isEmpty
                  ? null
                  : (value) {
                setState(() {
                  _roleId = value;
                });
              },
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Role is required';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // ===================================================
            // MODULE NAME
            // ===================================================

            TextFormField(
              controller: _moduleController,
              enabled: !widget.isLoading,
              decoration: const InputDecoration(
                labelText: 'Module Name',
                hintText: 'Enter module name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.extension_outlined,
                ),
              ),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Module name is required';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // ===================================================
            // PERMISSIONS
            // ===================================================

            permissionSwitch(
              'View',
              _canView,
                  (value) {
                setState(() {
                  _canView = value;
                });
              },
            ),

            permissionSwitch(
              'Create',
              _canCreate,
                  (value) {
                setState(() {
                  _canCreate = value;
                });
              },
            ),

            permissionSwitch(
              'Update',
              _canUpdate,
                  (value) {
                setState(() {
                  _canUpdate = value;
                });
              },
            ),

            permissionSwitch(
              'Delete',
              _canDelete,
                  (value) {
                setState(() {
                  _canDelete = value;
                });
              },
            ),

            permissionSwitch(
              'Export',
              _canExport,
                  (value) {
                setState(() {
                  _canExport = value;
                });
              },
            ),

            permissionSwitch(
              'Approve',
              _canApprove,
                  (value) {
                setState(() {
                  _canApprove = value;
                });
              },
            ),

            const SizedBox(height: 24),

            // ===================================================
            // SAVE / UPDATE
            // ===================================================

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
                    : Text(
                  widget.initialModuleName.isEmpty
                      ? 'Save'
                      : 'Update',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}