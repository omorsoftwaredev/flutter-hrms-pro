import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../../../../core/router/route_paths.dart';
import '../../domain/entities/department_entity.dart';
import '../providers/department_provider.dart';
import '../widgets/department_form.dart';

class DepartmentFormPage extends ConsumerWidget {
  const DepartmentFormPage({super.key, this.department});

  final DepartmentEntity? department;

  bool get isEdit => department != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ===========================================================
    // CURRENT LOGGED-IN USER
    // ===========================================================

    final user = ref.watch(currentUserProvider);

    // ===========================================================
    // DEPARTMENT STATE
    // ===========================================================

    final state = ref.watch(departmentProvider);

    // ===========================================================
    // USER VALIDATION
    // ===========================================================

    if (user == null) {
      return _buildErrorPage(
        context: context,
        title: isEdit ? 'Edit Department' : 'Add Department',
        message: 'Logged-in user information is not available.',
      );
    }

    // ===========================================================
    // CURRENT APPLICATION USER ID
    // ===========================================================

    final String currentUserId = user.userId.trim();

    if (currentUserId.isEmpty) {
      return _buildErrorPage(
        context: context,
        title: isEdit ? 'Edit Department' : 'Add Department',
        message: 'Logged-in user ID is not available.',
      );
    }

    // ===========================================================
    // COMPANY ID
    // ===========================================================

    final String companyId = isEdit
        ? department!.companyId.trim()
        : user.companyId.trim();

    // ===========================================================
    // COMPANY VALIDATION
    // ===========================================================

    if (companyId.isEmpty) {
      return _buildErrorPage(
        context: context,
        title: isEdit ? 'Edit Department' : 'Add Department',
        message: 'Company information is not available for this account.',
      );
    }

    // ===========================================================
    // DEBUG
    // ===========================================================

    debugPrint('================================================');

    debugPrint('DEPARTMENT FORM USER');

    debugPrint('User ID       => $currentUserId');

    debugPrint('Login Name    => ${user.loginName}');

    debugPrint('User Type     => ${user.userType.name}');

    debugPrint('Company ID    => $companyId');

    debugPrint('Department ID => ${department?.id}');

    debugPrint('Is Edit       => $isEdit');

    debugPrint('================================================');

    // ===========================================================
    // PAGE
    // ===========================================================

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // =========================================================
      // APP BAR
      // =========================================================
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,

        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RoutePaths.departments);
            }
          },
        ),

        title: Text(
          isEdit ? 'Edit Department' : 'Add Department',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            // ---------------------------------------------------
            // RESPONSIVE BREAKPOINTS
            // ---------------------------------------------------

            final bool isDesktop = width >= 1000;
            final bool isTablet = width >= 600;

            final double horizontalPadding = isDesktop
                ? 32
                : isTablet
                ? 24
                : 14;

            final double verticalPadding = isDesktop ? 28 : 20;

            // ---------------------------------------------------
            // RESPONSIVE FORM WIDTH
            // ---------------------------------------------------

            final double maxFormWidth = isDesktop
                ? 900
                : isTablet
                ? 760
                : 600;

            return GestureDetector(
              // -------------------------------------------------
              // Hide keyboard when tapping outside a field.
              // -------------------------------------------------
              onTap: () {
                FocusScope.of(context).unfocus();
              },

              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,

                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  verticalPadding,
                  horizontalPadding,

                  // Extra bottom space for keyboard / scrolling.
                  isDesktop ? 32 : 24,
                ),

                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxFormWidth),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // =======================================
                        // FORM HEADER
                        // =======================================
                        _buildPageHeader(context),

                        const SizedBox(height: 18),

                        // =======================================
                        // FORM
                        // =======================================
                        DepartmentForm(
                          initialName: department?.name ?? '',

                          initialDescription: department?.description ?? '',

                          initialPhone: department?.phone ?? '',

                          initialEmail: department?.email ?? '',

                          initialLocation: department?.location ?? '',

                          initialIsActive: department?.isActive ?? true,

                          isLoading: state.isSaving,

                          onSubmit:
                              (
                                submittedCompanyId,
                                name,
                                description,
                                phone,
                                email,
                                location,
                                isActive,
                              ) async {
                                // ===================================
                                // IMPORTANT
                                // ===================================
                                //
                                // Form থেকে companyId আসলেও
                                // validated page-level companyId
                                // ব্যবহার করছি.
                                //
                                // ===================================

                                final String finalCompanyId = companyId;

                                // ===================================
                                // ENTITY
                                // ===================================

                                final entity = DepartmentEntity(
                                  // ---------------------------------
                                  // ID
                                  // ---------------------------------
                                  id: department?.id ?? '',

                                  // ---------------------------------
                                  // COMPANY
                                  // ---------------------------------
                                  companyId: finalCompanyId,

                                  // ---------------------------------
                                  // DEPARTMENT
                                  // ---------------------------------
                                  name: name.trim(),

                                  description: description.trim(),

                                  phone: phone.trim(),

                                  email: email.trim(),

                                  location: location.trim(),

                                  isActive: isActive,

                                  // ---------------------------------
                                  // CREATED AT
                                  // ---------------------------------
                                  createdAt:
                                      department?.createdAt ?? DateTime.now(),

                                  // ---------------------------------
                                  // UPDATED AT
                                  // ---------------------------------
                                  updatedAt: DateTime.now(),

                                  // ---------------------------------
                                  // CREATED BY
                                  // ---------------------------------
                                  createdBy: isEdit
                                      ? department!.createdBy
                                      : currentUserId,

                                  // ---------------------------------
                                  // UPDATED BY
                                  // ---------------------------------
                                  updatedBy: currentUserId,
                                );

                                // ===================================
                                // DEBUG ENTITY
                                // ===================================

                                debugPrint(
                                  '================ DEPARTMENT SAVE ================',
                                );

                                debugPrint(
                                  'Mode        => '
                                  '${isEdit ? 'UPDATE' : 'CREATE'}',
                                );

                                debugPrint('Department  => ${entity.name}');

                                debugPrint(
                                  'Company ID  => ${entity.companyId}',
                                );

                                debugPrint(
                                  'Created By  => ${entity.createdBy}',
                                );

                                debugPrint(
                                  'Updated By  => ${entity.updatedBy}',
                                );

                                debugPrint(
                                  '==================================================',
                                );

                                try {
                                  // =================================
                                  // UPDATE
                                  // =================================

                                  if (isEdit) {
                                    await ref
                                        .read(departmentProvider.notifier)
                                        .updateDepartment(entity);

                                    if (!context.mounted) {
                                      return;
                                    }

                                    _showSuccessSnackBar(
                                      context,
                                      'Department updated successfully.',
                                    );
                                  }
                                  // =================================
                                  // CREATE
                                  // =================================
                                  else {
                                    await ref
                                        .read(departmentProvider.notifier)
                                        .createDepartment(entity);

                                    if (!context.mounted) {
                                      return;
                                    }

                                    _showSuccessSnackBar(
                                      context,
                                      'Department created successfully.',
                                    );
                                  }

                                  // =================================
                                  // RELOAD
                                  // =================================

                                  await ref
                                      .read(departmentProvider.notifier)
                                      .loadDepartments();

                                  // =================================
                                  // CONTEXT CHECK
                                  // =================================

                                  if (!context.mounted) {
                                    return;
                                  }

                                  // =================================
                                  // BACK TO LIST
                                  // =================================

                                  context.go(RoutePaths.departments);
                                } catch (e) {
                                  // =================================
                                  // ERROR DEBUG
                                  // =================================

                                  debugPrint('Department Save Error => $e');

                                  if (!context.mounted) {
                                    return;
                                  }

                                  _showErrorSnackBar(context, e.toString());
                                }
                              },
                        ),

                        // =======================================
                        // BOTTOM SPACE
                        // =======================================
                        const SizedBox(height: 20),
                      ],
                    ),
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
  // PAGE HEADER
  // =============================================================

  Widget _buildPageHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool editing = isEdit;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: editing
            ? colorScheme.secondaryContainer.withOpacity(.55)
            : colorScheme.primaryContainer.withOpacity(.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: editing
              ? colorScheme.secondary.withOpacity(.18)
              : colorScheme.primary.withOpacity(.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================================================
          // ICON
          // =====================================================
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: editing
                  ? colorScheme.secondary.withOpacity(.12)
                  : colorScheme.primary.withOpacity(.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              editing ? Icons.edit_note_rounded : Icons.apartment_rounded,
              size: 26,
              color: editing ? colorScheme.secondary : colorScheme.primary,
            ),
          ),

          const SizedBox(width: 13),

          // =====================================================
          // TEXT
          // =====================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  editing ? 'Edit Department' : 'Add Department',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  editing
                      ? 'Update the department information and settings.'
                      : 'Create a new department for your company.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // ERROR PAGE
  // =============================================================

  Widget _buildErrorPage({
    required BuildContext context,
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

        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RoutePaths.departments);
            }
          },
        ),

        title: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withOpacity(.55),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colorScheme.error.withOpacity(.20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: colorScheme.error.withOpacity(.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        size: 30,
                        color: colorScheme.error,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Unable to Open Department Form',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go(RoutePaths.departments);
                          }
                        },
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: const Text('Back to Departments'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // SUCCESS SNACKBAR
  // =============================================================

  void _showSuccessSnackBar(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: colorScheme.inverseSurface,
          elevation: 0,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: colorScheme.onInverseSurface,
                size: 20,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onInverseSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // =============================================================
  // ERROR SNACKBAR
  // =============================================================

  void _showErrorSnackBar(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: colorScheme.error,
          elevation: 0,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: colorScheme.onError,
                size: 20,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onError,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
