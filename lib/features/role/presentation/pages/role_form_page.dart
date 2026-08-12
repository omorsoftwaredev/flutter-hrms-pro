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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          isEdit
              ? 'Edit Role'
              : 'Add Role',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: RoleForm(
            // ===================================================
            // INITIAL VALUES
            // ===================================================

            initialRoleName:
            role?.roleName ?? '',

            initialDescription:
            role?.description ?? '',

            initialIsActive:
            role?.isActive ?? true,

            isLoading:
            state.isSaving,

            // ===================================================
            // SUBMIT
            // ===================================================

            onSubmit: (
                roleName,
                description,
                isActive,
                ) async {
              final entity = RoleEntity(
                id: role?.id ?? '',

                // -----------------------------------------------
                // Company ID
                //
                // Existing role হলে existing companyId থাকবে।
                // Create হলে repository/provider current company
                // scope অনুযায়ী handle করবে।
                // -----------------------------------------------

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
                // ===============================================
                // UPDATE
                // ===============================================

                if (isEdit) {
                  await ref
                      .read(
                    roleProvider.notifier,
                  )
                      .updateRole(
                    entity,
                  );
                }

                // ===============================================
                // CREATE
                // ===============================================

                else {
                  await ref
                      .read(
                    roleProvider.notifier,
                  )
                      .createRole(
                    entity,
                  );
                }

                if (!context.mounted) {
                  return;
                }

                // ===============================================
                // RELOAD ROLE LIST
                // ===============================================

                await ref
                    .read(
                  roleProvider.notifier,
                )
                    .loadRoles();

                if (!context.mounted) {
                  return;
                }

                // ===============================================
                // BACK TO ROLE LIST
                // ===============================================

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
                ).showSnackBar(
                  SnackBar(
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