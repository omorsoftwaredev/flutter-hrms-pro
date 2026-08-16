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
  const RolePermissionsFormPage({super.key, this.permission});

  final RolePermissionsEntity? permission;

  @override
  ConsumerState<RolePermissionsFormPage> createState() =>
      _RolePermissionsFormPageState();
}

class _RolePermissionsFormPageState
    extends ConsumerState<RolePermissionsFormPage> {
  bool get isEdit => widget.permission != null;

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(roleProvider.notifier).loadRoles();
    });
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    final state = ref.watch(rolePermissionsProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ===========================================================
    // USER VALIDATION
    // ===========================================================

    if (user == null) {
      return _buildErrorPage(
        context,
        title: 'Role Permission',
        message: 'Logged-in user information is not available.',
      );
    }

    // ===========================================================
    // CURRENT USER ID
    // ===========================================================

    final currentUserId = user.userId.trim();

    if (currentUserId.isEmpty) {
      return _buildErrorPage(
        context,
        title: 'Role Permission',
        message: 'Logged-in user ID is not available.',
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
    // No company list/query.
    //
    // ===========================================================

    final companyId = isEdit
        ? widget.permission!.companyId.trim()
        : user.companyId.trim();

    // ===========================================================
    // COMPANY VALIDATION
    // ===========================================================

    if (companyId.isEmpty) {
      return _buildErrorPage(
        context,
        title: 'Role Permission',
        message: 'Company information is not available for this account.',
      );
    }

    // ===========================================================
    // DEBUG
    // ===========================================================

    debugPrint('================================================');

    debugPrint('ROLE PERMISSION FORM');

    debugPrint('User ID       => $currentUserId');

    debugPrint('Login Name    => ${user.loginName}');

    debugPrint('User Type     => ${user.userType.name}');

    debugPrint('Company ID    => $companyId');

    debugPrint('Permission ID => ${widget.permission?.id}');

    debugPrint('Is Edit       => $isEdit');

    debugPrint('================================================');

    // ===========================================================
    // RESPONSIVE
    // ===========================================================

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // ===========================================================
      // APP BAR
      // ===========================================================
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,

        title: Text(
          isEdit ? 'Edit Permission' : 'Add Permission',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RoutePaths.rolePermissions);
            }
          },
        ),
      ),

      // ===========================================================
      // BODY
      // ===========================================================
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            // =====================================================
            // BREAKPOINTS
            // =====================================================

            final bool isDesktop = width >= 1000;

            final bool isTablet = width >= 600;

            final double horizontalPadding = isDesktop
                ? 32
                : isTablet
                ? 24
                : 14;

            final double maxContentWidth = isDesktop ? 900 : 760;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),

              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                32,
              ),

              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),

                  child: RolePermissionsForm(
                    // =================================================
                    // COMPANY
                    // =================================================
                    //
                    // Company list নেই।
                    //
                    // Login করা user-এর companyId ব্যবহার হচ্ছে।
                    //
                    // =================================================
                    initialCompanyId: companyId,

                    // =================================================
                    // ROLE
                    // =================================================
                    initialRoleId: widget.permission?.roleId ?? '',

                    // =================================================
                    // MODULE
                    // =================================================
                    initialModuleName: widget.permission?.moduleName ?? '',

                    // =================================================
                    // PERMISSIONS
                    // =================================================
                    initialCanView: widget.permission?.canView ?? false,

                    initialCanCreate: widget.permission?.canCreate ?? false,

                    initialCanUpdate: widget.permission?.canUpdate ?? false,

                    initialCanDelete: widget.permission?.canDelete ?? false,

                    initialCanExport: widget.permission?.canExport ?? false,

                    initialCanApprove: widget.permission?.canApprove ?? false,

                    // =================================================
                    // LOADING
                    // =================================================
                    isLoading: state.isSaving,

                    // =================================================
                    // SUBMIT
                    // =================================================
                    onSubmit:
                        (
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
                          // ===============================================
                          // COMPANY
                          // ===============================================
                          //
                          // Form থেকে companyId আসলেও সেটার উপর
                          // নির্ভর করছি না।
                          //
                          // Validated login companyId ব্যবহার করছি।
                          //
                          // ===============================================

                          final finalCompanyId = companyId;

                          // ===============================================
                          // ROLE VALIDATION
                          // ===============================================

                          final finalRoleId = roleId.trim();

                          if (finalRoleId.isEmpty) {
                            throw Exception('Role is required.');
                          }

                          // ===============================================
                          // ENTITY
                          // ===============================================

                          final entity = RolePermissionsEntity(
                            // ---------------------------------------------
                            // ID
                            // ---------------------------------------------
                            id: widget.permission?.id ?? '',

                            // ---------------------------------------------
                            // COMPANY
                            // ---------------------------------------------
                            companyId: finalCompanyId,

                            // ---------------------------------------------
                            // ROLE
                            // ---------------------------------------------
                            roleId: finalRoleId,

                            // ---------------------------------------------
                            // MODULE
                            // ---------------------------------------------
                            moduleName: moduleName.trim(),

                            // ---------------------------------------------
                            // PERMISSIONS
                            // ---------------------------------------------
                            canView: canView,

                            canCreate: canCreate,

                            canUpdate: canUpdate,

                            canDelete: canDelete,

                            canExport: canExport,

                            canApprove: canApprove,

                            // ---------------------------------------------
                            // CREATED AT
                            // ---------------------------------------------
                            createdAt:
                                widget.permission?.createdAt ?? DateTime.now(),

                            // ---------------------------------------------
                            // UPDATED AT
                            // ---------------------------------------------
                            updatedAt: DateTime.now(),

                            // ---------------------------------------------
                            // CREATED BY
                            // ---------------------------------------------
                            //
                            // CREATE:
                            // current logged-in user
                            //
                            // UPDATE:
                            // original created_by preserve হবে।
                            //
                            // ---------------------------------------------
                            createdBy: isEdit
                                ? widget.permission!.createdBy
                                : currentUserId,

                            // ---------------------------------------------
                            // UPDATED BY
                            // ---------------------------------------------
                            //
                            // CREATE:
                            // current logged-in user
                            //
                            // UPDATE:
                            // current logged-in user
                            //
                            // ---------------------------------------------
                            updatedBy: currentUserId,
                          );

                          // ===============================================
                          // DEBUG ENTITY
                          // ===============================================

                          debugPrint(
                            '============== ROLE PERMISSION SAVE ==============',
                          );

                          debugPrint(
                            'Mode        => '
                            '${isEdit ? 'UPDATE' : 'CREATE'}',
                          );

                          debugPrint('Permission  => ${entity.id}');

                          debugPrint('Company ID  => ${entity.companyId}');

                          debugPrint('Role ID     => ${entity.roleId}');

                          debugPrint('Module      => ${entity.moduleName}');

                          debugPrint('Created By  => ${entity.createdBy}');

                          debugPrint('Updated By  => ${entity.updatedBy}');

                          debugPrint(
                            '====================================================',
                          );

                          try {
                            // =============================================
                            // UPDATE
                            // =============================================

                            if (isEdit) {
                              await ref
                                  .read(rolePermissionsProvider.notifier)
                                  .updateRolePermission(entity);
                            }
                            // =============================================
                            // CREATE
                            // =============================================
                            else {
                              await ref
                                  .read(rolePermissionsProvider.notifier)
                                  .createRolePermission(entity);
                            }

                            // =============================================
                            // CONTEXT CHECK
                            // =============================================

                            if (!context.mounted) {
                              return;
                            }

                            // =============================================
                            // SUCCESS MESSAGE
                            // =============================================

                            ScaffoldMessenger.of(context).hideCurrentSnackBar();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: colorScheme.inverseSurface,
                                elevation: 0,
                                behavior: SnackBarBehavior.fixed,
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline_rounded,
                                      size: 20,
                                      color: colorScheme.onInverseSurface,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        isEdit
                                            ? 'Permission updated successfully.'
                                            : 'Permission created successfully.',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color:
                                                  colorScheme.onInverseSurface,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );

                            // =============================================
                            // BACK TO LIST
                            // =============================================

                            context.go(RoutePaths.rolePermissions);
                          } catch (e) {
                            // =============================================
                            // ERROR
                            // =============================================

                            debugPrint('Role Permission Save Error => $e');

                            if (!context.mounted) {
                              return;
                            }

                            ScaffoldMessenger.of(context).hideCurrentSnackBar();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: colorScheme.error,
                                behavior: SnackBarBehavior.fixed,
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline_rounded,
                                      size: 20,
                                      color: colorScheme.onError,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        e.toString(),
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: colorScheme.onError,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // =============================================================
  // ERROR PAGE
  // =============================================================

  Widget _buildErrorPage(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        title: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.account_circle_outlined,
                    size: 56,
                    color: colorScheme.onSurfaceVariant,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
