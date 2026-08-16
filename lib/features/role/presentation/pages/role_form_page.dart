import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/role_entity.dart';
import '../providers/role_provider.dart';
import '../widgets/role_form.dart';

class RoleFormPage extends ConsumerWidget {
  const RoleFormPage({
    super.key,
    this.role,
  });

  final RoleEntity? role;

  bool get isEdit => role != null;

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final state = ref.watch(roleProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),

        title: Text(
          isEdit
              ? 'Edit Role'
              : 'Add Role',
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
          builder: (
              context,
              constraints,
              ) {
            final double width =
                constraints.maxWidth;

            // ===================================================
            // RESPONSIVE BREAKPOINTS
            // ===================================================

            final bool isDesktop =
                width >= 1000;

            final bool isTablet =
                width >= 600;

            final double horizontalPadding =
            isDesktop
                ? 32
                : isTablet
                ? 24
                : 14;

            final double maxContentWidth =
            isDesktop
                ? 700
                : 760;

            return SingleChildScrollView(
              physics:
              const AlwaysScrollableScrollPhysics(),

              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                32,
              ),

              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth:
                    maxContentWidth,
                  ),

                  child: RoleForm(
                    // =================================================
                    // INITIAL VALUES
                    // =================================================

                    initialRoleName:
                    role?.roleName ?? '',

                    initialDescription:
                    role?.description ?? '',

                    initialIsActive:
                    role?.isActive ?? true,

                    isLoading:
                    state.isSaving,

                    // =================================================
                    // SUBMIT
                    // =================================================

                    onSubmit: (
                        roleName,
                        description,
                        isActive,
                        ) async {
                      // ===============================================
                      // ENTITY
                      // ===============================================

                      final entity = RoleEntity(
                        id: role?.id ?? '',

                        // ---------------------------------------------
                        // COMPANY SCOPE
                        //
                        // Existing role:
                        //     existing companyId preserve হবে।
                        //
                        // Create:
                        //     companyId manually দেওয়া হচ্ছে না।
                        //
                        // Provider / Repository:
                        //     CurrentUser.companyId অনুযায়ী
                        //     company scope handle করবে।
                        // ---------------------------------------------

                        companyId:
                        role?.companyId ?? '',

                        roleName:
                        roleName,

                        description:
                        description,

                        isActive:
                        isActive,

                        createdAt:
                        role?.createdAt ??
                            DateTime.now(),

                        updatedAt:
                        role?.updatedAt,

                        createdBy:
                        role?.createdBy,

                        updatedBy:
                        role?.updatedBy,
                      );

                      try {
                        // =============================================
                        // UPDATE
                        // =============================================

                        if (isEdit) {
                          await ref
                              .read(
                            roleProvider
                                .notifier,
                          )
                              .updateRole(
                            entity,
                          );
                        }

                        // =============================================
                        // CREATE
                        // =============================================

                        else {
                          await ref
                              .read(
                            roleProvider
                                .notifier,
                          )
                              .createRole(
                            entity,
                          );
                        }

                        if (!context.mounted) {
                          return;
                        }

                        // =============================================
                        // RELOAD ROLE LIST
                        // =============================================

                        await ref
                            .read(
                          roleProvider
                              .notifier,
                        )
                            .loadRoles();

                        if (!context.mounted) {
                          return;
                        }

                        // =============================================
                        // SUCCESS MESSAGE
                        // =============================================

                        final message = isEdit
                            ? 'Role updated successfully.'
                            : 'Role created successfully.';

                        ScaffoldMessenger.of(
                          context,
                        )
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              behavior:
                              SnackBarBehavior.fixed,
                              backgroundColor:
                              colorScheme
                                  .inverseSurface,
                              elevation: 0,
                              duration:
                              const Duration(
                                seconds: 3,
                              ),
                              content: Row(
                                children: [
                                  Icon(
                                    Icons
                                        .check_circle_outline_rounded,
                                    size: 20,
                                    color: colorScheme
                                        .onInverseSurface,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      message,
                                      style: theme
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                        color: colorScheme
                                            .onInverseSurface,
                                        fontWeight:
                                        FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                        // =============================================
                        // BACK TO ROLE LIST
                        // =============================================

                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/roles');
                        }
                      } catch (e) {
                        if (!context.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(
                          context,
                        )
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              behavior:
                              SnackBarBehavior.fixed,
                              backgroundColor:
                              colorScheme.error,
                              content: Text(
                                e.toString(),
                                style: TextStyle(
                                  color: colorScheme
                                      .onError,
                                ),
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
}