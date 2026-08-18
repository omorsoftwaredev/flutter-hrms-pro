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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = ref.read(currentUserProvider);

    if (user == null) {
      _showError(
        'Current user information not found.',
      );

      return;
    }

    final companyId = user.companyId.trim();

    if (companyId.isEmpty) {
      _showError(
        'Company ID not found for the logged-in account.',
      );

      return;
    }

    if (_roleId == null || _roleId!.trim().isEmpty) {
      _showError(
        'Please select role.',
      );

      return;
    }

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
      BuildContext context, {
        required IconData icon,
        required String title,
        required String description,
        required bool value,
        required ValueChanged<bool> onChanged,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: value
            ? colorScheme.primaryContainer.withValues(
          alpha: 0.38,
        )
            : colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.38,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: value
              ? colorScheme.primary.withValues(
            alpha: 0.25,
          )
              : colorScheme.outlineVariant.withValues(
            alpha: 0.55,
          ),
        ),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 3,
        ),
        secondary: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: value
                ? colorScheme.primary.withValues(
              alpha: 0.12,
            )
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: 21,
            color: value
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        value: value,
        onChanged: widget.isLoading
            ? null
            : onChanged,
      ),
    );
  }

  // =============================================================
  // SECTION HEADER
  // =============================================================

  Widget _sectionHeader(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: colorScheme.onPrimaryContainer,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final screenWidth = MediaQuery.sizeOf(context).width;

    final isSmallScreen = screenWidth < 400;
    final isWideScreen = screenWidth >= 700;

    final user = ref.watch(currentUserProvider);

    final companyId = user?.companyId.trim() ?? '';

    final roleState = ref.watch(roleProvider);

    final filteredRoles = roleState.roles
        .where(
          (role) => role.companyId == companyId,
    )
        .toList();

    final horizontalPadding = isSmallScreen
        ? 14.0
        : isWideScreen
        ? 22.0
        : 18.0;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===================================================
            // HEADER
            // ===================================================

            _sectionHeader(
              context,
              icon: Icons.security_outlined,
              title: 'Role Permissions',
              subtitle:
              'Assign module access and permissions to the selected role.',
            ),

            SizedBox(
              height: isSmallScreen ? 18 : 22,
            ),

            // ===================================================
            // ROLE & MODULE CARD
            // ===================================================

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(
                horizontalPadding,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(
                    alpha: 0.55,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // =============================================
                  // BASIC INFORMATION HEADER
                  // =============================================

                  Row(
                    children: [
                      Icon(
                        Icons.tune_rounded,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Permission Details',
                        style:
                        theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // =============================================
                  // ROLE
                  // =============================================

                  DropdownButtonFormField<String>(
                    value: _roleId,
                    decoration: InputDecoration(
                      labelText: 'Select Role',
                      hintText: 'Choose a role',
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color:
                          colorScheme.outlineVariant,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.badge_outlined,
                      ),
                      filled: true,
                      fillColor:
                      colorScheme.surface,
                    ),
                    items: filteredRoles
                        .map(
                          (role) =>
                          DropdownMenuItem<String>(
                            value: role.id,
                            child: Text(
                              role.roleName,
                              overflow:
                              TextOverflow.ellipsis,
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

                  // =============================================
                  // MODULE NAME
                  // =============================================

                  TextFormField(
                    controller: _moduleController,
                    enabled: !widget.isLoading,
                    decoration: InputDecoration(
                      labelText: 'Module Name',
                      hintText:
                      'Enter module name',
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color:
                          colorScheme.outlineVariant,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.extension_outlined,
                      ),
                      filled: true,
                      fillColor:
                      colorScheme.surface,
                    ),
                    textInputAction:
                    TextInputAction.next,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Module name is required';
                      }

                      return null;
                    },
                  ),
                ],
              ),
            ),

            SizedBox(
              height: isSmallScreen ? 20 : 24,
            ),

            // ===================================================
            // PERMISSION SECTION
            // ===================================================

            _sectionHeader(
              context,
              icon: Icons.admin_panel_settings_outlined,
              title: 'Access Permissions',
              subtitle:
              'Enable or disable individual permissions for this role.',
            ),

            SizedBox(
              height: isSmallScreen ? 14 : 18,
            ),

            // ===================================================
            // PERMISSION LIST
            // ===================================================

            if (isWideScreen)
              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        permissionSwitch(
                          context,
                          icon: Icons.visibility_outlined,
                          title: 'View',
                          description:
                          'Allow viewing records',
                          value: _canView,
                          onChanged: (value) {
                            setState(() {
                              _canView = value;
                            });
                          },
                        ),
                        permissionSwitch(
                          context,
                          icon: Icons.add_circle_outline_rounded,
                          title: 'Create',
                          description:
                          'Allow creating records',
                          value: _canCreate,
                          onChanged: (value) {
                            setState(() {
                              _canCreate = value;
                            });
                          },
                        ),
                        permissionSwitch(
                          context,
                          icon: Icons.edit_outlined,
                          title: 'Update',
                          description:
                          'Allow updating records',
                          value: _canUpdate,
                          onChanged: (value) {
                            setState(() {
                              _canUpdate = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      children: [
                        permissionSwitch(
                          context,
                          icon: Icons.delete_outline_rounded,
                          title: 'Delete',
                          description:
                          'Allow deleting records',
                          value: _canDelete,
                          onChanged: (value) {
                            setState(() {
                              _canDelete = value;
                            });
                          },
                        ),
                        permissionSwitch(
                          context,
                          icon: Icons.file_download_outlined,
                          title: 'Export',
                          description:
                          'Allow exporting data',
                          value: _canExport,
                          onChanged: (value) {
                            setState(() {
                              _canExport = value;
                            });
                          },
                        ),
                        permissionSwitch(
                          context,
                          icon: Icons.verified_outlined,
                          title: 'Approve',
                          description:
                          'Allow approving requests',
                          value: _canApprove,
                          onChanged: (value) {
                            setState(() {
                              _canApprove = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  permissionSwitch(
                    context,
                    icon: Icons.visibility_outlined,
                    title: 'View',
                    description:
                    'Allow viewing records',
                    value: _canView,
                    onChanged: (value) {
                      setState(() {
                        _canView = value;
                      });
                    },
                  ),
                  permissionSwitch(
                    context,
                    icon: Icons.add_circle_outline_rounded,
                    title: 'Create',
                    description:
                    'Allow creating records',
                    value: _canCreate,
                    onChanged: (value) {
                      setState(() {
                        _canCreate = value;
                      });
                    },
                  ),
                  permissionSwitch(
                    context,
                    icon: Icons.edit_outlined,
                    title: 'Update',
                    description:
                    'Allow updating records',
                    value: _canUpdate,
                    onChanged: (value) {
                      setState(() {
                        _canUpdate = value;
                      });
                    },
                  ),
                  permissionSwitch(
                    context,
                    icon: Icons.delete_outline_rounded,
                    title: 'Delete',
                    description:
                    'Allow deleting records',
                    value: _canDelete,
                    onChanged: (value) {
                      setState(() {
                        _canDelete = value;
                      });
                    },
                  ),
                  permissionSwitch(
                    context,
                    icon: Icons.file_download_outlined,
                    title: 'Export',
                    description:
                    'Allow exporting data',
                    value: _canExport,
                    onChanged: (value) {
                      setState(() {
                        _canExport = value;
                      });
                    },
                  ),
                  permissionSwitch(
                    context,
                    icon: Icons.verified_outlined,
                    title: 'Approve',
                    description:
                    'Allow approving requests',
                    value: _canApprove,
                    onChanged: (value) {
                      setState(() {
                        _canApprove = value;
                      });
                    },
                  ),
                ],
              ),

            SizedBox(
              height: isSmallScreen ? 18 : 24,
            ),

            // ===================================================
            // SUMMARY
            // ===================================================

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(
                isSmallScreen ? 14 : 16,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer
                    .withValues(alpha: 0.35),
                borderRadius:
                BorderRadius.circular(14),
                border: Border.all(
                  color: colorScheme.primary
                      .withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Selected permissions will be assigned to the selected role.',
                      style:
                      theme.textTheme.bodySmall?.copyWith(
                        color:
                        colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: isSmallScreen ? 20 : 24,
            ),

            // ===================================================
            // SAVE / UPDATE
            // ===================================================

            SizedBox(
              width: double.infinity,
              height: isSmallScreen ? 50 : 52,
              child: FilledButton.icon(
                onPressed:
                widget.isLoading ? null : _save,
                icon: widget.isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : Icon(
                  widget.initialModuleName
                      .isEmpty
                      ? Icons.save_outlined
                      : Icons
                      .system_update_alt_outlined,
                ),
                label: Text(
                  widget.initialModuleName.isEmpty
                      ? 'Save Permissions'
                      : 'Update Permissions',
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}