import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';

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
        title: Text(
          isEdit
              ? 'Edit Role'
              : 'Add Role',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: RoleForm(
            initialCompanyId:
            role?.companyId ?? '',

            initialRoleCode:
            role?.roleCode ?? '',

            initialRoleName:
            role?.roleName ?? '',

            initialDescription:
            role?.description ?? '',

            initialIsActive:
            role?.isActive ?? true,

            isLoading:
            state.isSaving,

            onSubmit: (
                companyId,
                roleCode,
                roleName,
                description,
                isActive,
                ) async {
              final entity = RoleEntity(
                id: role?.id ?? '',
                companyId: companyId,
                roleCode: roleCode,
                roleName: roleName,
                description: description,
                isActive: isActive,
                createdAt:
                role?.createdAt ??
                    DateTime.now(),
                updatedAt:
                DateTime.now(),
              );

              try {
                if (isEdit) {
                  await ref
                      .read(
                    roleProvider.notifier,
                  )
                      .updateRole(entity);
                } else {
                  await ref
                      .read(
                    roleProvider.notifier,
                  )
                      .createRole(entity);
                }

                if (!context.mounted) return;

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      isEdit
                          ? 'Role updated successfully.'
                          : 'Role created successfully.',
                    ),
                  ),
                );

                context.go(
                  RoutePaths.roles,
                );
              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context)
                    .showSnackBar(
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