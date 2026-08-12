import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../../../../core/router/route_paths.dart';

import '../../../role/presentation/providers/role_provider.dart';

import '../../domain/entities/role_permissions_entity.dart';

import '../providers/role_permissions_provider.dart';
import '../widgets/role_permissions_form.dart';

class RolePermissionsFormPage extends ConsumerStatefulWidget {
  const RolePermissionsFormPage({
    super.key,
    this.permission,
  });

  final RolePermissionsEntity? permission;

  @override
  ConsumerState<RolePermissionsFormPage> createState() =>
      _RolePermissionsFormPageState();
}

class _RolePermissionsFormPageState
    extends ConsumerState<RolePermissionsFormPage> {
  bool get isEdit => widget.permission != null;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref
          .read(roleProvider.notifier)
          .loadRoles();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ===========================================================
    // CURRENT LOGGED-IN USER
    // ===========================================================

    final user = ref.watch(currentUserProvider);

    // ===========================================================
    // ROLE PERMISSION STATE
    // ===========================================================

    final state = ref.watch(
      rolePermissionsProvider,
    );

    // ===========================================================
    // USER VALIDATION
    // ===========================================================

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Role Permission'),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Logged-in user information is not available.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    // ===========================================================
    // CURRENT USER ID
    // ===========================================================

    final currentUserId = user.userId.trim();

    if (currentUserId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Role Permission'),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Logged-in user ID is not available.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    // ===========================================================
    // CURRENT COMPANY ID
    // ===========================================================
    //
    // CREATE:
    // CurrentUser.companyId
    //
    // EDIT:
    // Existing permission.companyId
    //
    // ===========================================================

    final companyId = isEdit
        ? widget.permission!.companyId.trim()
        : user.companyId.trim();

    // ===========================================================
    // COMPANY VALIDATION
    // ===========================================================

    if (companyId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Role Permission'),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Company information is not available for this account.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    // ===========================================================
    // DEBUG
    // ===========================================================

    debugPrint(
      '================================================',
    );

    debugPrint(
      'ROLE PERMISSION FORM',
    );

    debugPrint(
      'User ID       => $currentUserId',
    );

    debugPrint(
      'Login Name    => ${user.loginName}',
    );

    debugPrint(
      'User Type     => ${user.userType.name}',
    );

    debugPrint(
      'Company ID    => $companyId',
    );

    debugPrint(
      'Permission ID => ${widget.permission?.id}',
    );

    debugPrint(
      'Is Edit       => $isEdit',
    );

    debugPrint(
      '================================================',
    );

    // ===========================================================
    // PAGE
    // ===========================================================

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? 'Edit Permission'
              : 'Add Permission',
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: RolePermissionsForm(
            // ===================================================
            // COMPANY
            // ===================================================

            initialCompanyId: companyId,

            // ===================================================
            // ROLE
            // ===================================================

            initialRoleId:
            widget.permission?.roleId ?? '',

            // ===================================================
            // MODULE
            // ===================================================

            initialModuleName:
            widget.permission?.moduleName ?? '',

            // ===================================================
            // PERMISSIONS
            // ===================================================

            initialCanView:
            widget.permission?.canView ?? false,

            initialCanCreate:
            widget.permission?.canCreate ?? false,

            initialCanUpdate:
            widget.permission?.canUpdate ?? false,

            initialCanDelete:
            widget.permission?.canDelete ?? false,

            initialCanExport:
            widget.permission?.canExport ?? false,

            initialCanApprove:
            widget.permission?.canApprove ?? false,

            // ===================================================
            // LOADING
            // ===================================================

            isLoading: state.isSaving,

            // ===================================================
            // SUBMIT
            // ===================================================

            onSubmit: (
                submittedCompanyId,
                roleId,
                moduleName,
                canView,
                canCreate,
                canUpdate,
                canDelete,
                canExport,
                canApprove,
                ) async {
              // =================================================
              // COMPANY
              // =================================================
              //
              // Form থেকে companyId আসলেও আমরা সেটার উপর
              // নির্ভর করছি না।
              //
              // Page-এর validated companyId ব্যবহার করছি।
              //
              // =================================================

              final finalCompanyId = companyId;

              // =================================================
              // ROLE VALIDATION
              // =================================================

              final finalRoleId = roleId.trim();

              if (finalRoleId.isEmpty) {
                throw Exception(
                  'Role is required.',
                );
              }

              // =================================================
              // ENTITY
              // =================================================

              final entity = RolePermissionsEntity(
                // ------------------------------------------------
                // ID
                // ------------------------------------------------

                id: widget.permission?.id ?? '',

                // ------------------------------------------------
                // COMPANY
                // ------------------------------------------------

                companyId: finalCompanyId,

                // ------------------------------------------------
                // ROLE
                // ------------------------------------------------

                roleId: finalRoleId,

                // ------------------------------------------------
                // MODULE
                // ------------------------------------------------

                moduleName: moduleName.trim(),

                // ------------------------------------------------
                // PERMISSIONS
                // ------------------------------------------------

                canView: canView,

                canCreate: canCreate,

                canUpdate: canUpdate,

                canDelete: canDelete,

                canExport: canExport,

                canApprove: canApprove,

                // ------------------------------------------------
                // CREATED AT
                // ------------------------------------------------

                createdAt:
                widget.permission?.createdAt ??
                    DateTime.now(),

                // ------------------------------------------------
                // UPDATED AT
                // ------------------------------------------------

                updatedAt: DateTime.now(),

                // ------------------------------------------------
                // CREATED BY
                // ------------------------------------------------
                //
                // CREATE:
                // current logged-in user
                //
                // UPDATE:
                // original created_by preserve হবে।
                //
                // ------------------------------------------------

                createdBy: isEdit
                    ? widget.permission!.createdBy
                    : currentUserId,

                // ------------------------------------------------
                // UPDATED BY
                // ------------------------------------------------
                //
                // CREATE:
                // current logged-in user
                //
                // UPDATE:
                // current logged-in user
                //
                // ------------------------------------------------

                updatedBy: currentUserId,
              );

              // =================================================
              // DEBUG ENTITY
              // =================================================

              debugPrint(
                '============== ROLE PERMISSION SAVE ==============',
              );

              debugPrint(
                'Mode        => '
                    '${isEdit ? 'UPDATE' : 'CREATE'}',
              );

              debugPrint(
                'Permission  => ${entity.id}',
              );

              debugPrint(
                'Company ID  => ${entity.companyId}',
              );

              debugPrint(
                'Role ID     => ${entity.roleId}',
              );

              debugPrint(
                'Module      => ${entity.moduleName}',
              );

              debugPrint(
                'Created By  => ${entity.createdBy}',
              );

              debugPrint(
                'Updated By  => ${entity.updatedBy}',
              );

              debugPrint(
                '====================================================',
              );

              try {
                // =================================================
                // UPDATE
                // =================================================

                if (isEdit) {
                  await ref
                      .read(
                    rolePermissionsProvider
                        .notifier,
                  )
                      .updateRolePermission(
                    entity,
                  );
                }

                // =================================================
                // CREATE
                // =================================================

                else {
                  await ref
                      .read(
                    rolePermissionsProvider
                        .notifier,
                  )
                      .createRolePermission(
                    entity,
                  );
                }

                // =================================================
                // CONTEXT CHECK
                // =================================================

                if (!context.mounted) {
                  return;
                }

                // =================================================
                // SUCCESS MESSAGE
                // =================================================

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEdit
                          ? 'Permission updated successfully.'
                          : 'Permission created successfully.',
                    ),
                  ),
                );

                // =================================================
                // BACK TO LIST
                // =================================================

                context.go(
                  RoutePaths.rolePermissions,
                );
              } catch (e) {
                // =================================================
                // ERROR
                // =================================================

                debugPrint(
                  'Role Permission Save Error => $e',
                );

                if (!context.mounted) {
                  return;
                }

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      e.toString(),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}