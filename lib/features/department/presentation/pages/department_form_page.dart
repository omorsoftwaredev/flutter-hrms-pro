import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../domain/entities/department_entity.dart';
import '../providers/department_provider.dart';
import '../widgets/department_form.dart';

class DepartmentFormPage extends ConsumerWidget {
  const DepartmentFormPage({
    super.key,
    this.department,
  });

  final DepartmentEntity? department;

  bool get isEdit => department != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("DepartmentFormPage Opened");
    final state = ref.watch(departmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? 'Edit Department'
              : 'Add Department',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: DepartmentForm(
            initialCompanyId:
            department?.companyId ?? '',
            initialCode:
            department?.code ?? '',
            initialName:
            department?.name ?? '',
            initialDescription:
            department?.description ?? '',
            initialManagerName:
            department?.managerName ?? '',
            initialPhone:
            department?.phone ?? '',
            initialEmail:
            department?.email ?? '',
            initialLocation:
            department?.location ?? '',
            initialIsActive:
            department?.isActive ?? true,
            isLoading: state.isSaving,
            onSubmit: (
                companyId,
                code,
                name,
                description,
                managerName,
                phone,
                email,
                location,
                isActive,
                ) async {
              final entity = DepartmentEntity(
                id: department?.id ?? '',
                companyId: companyId,
                code: code,
                name: name,
                description: description,
                managerName: managerName,
                phone: phone,
                email: email,
                location: location,
                isActive: isActive,
                createdAt:
                department?.createdAt ??
                    DateTime.now(),
                updatedAt: DateTime.now(),
              );

              try {
                if (isEdit) {
                  await ref
                      .read(
                    departmentProvider.notifier,
                  )
                      .updateDepartment(entity);

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Department updated successfully.',
                      ),
                    ),
                  );
                } else {
                  await ref
                      .read(
                    departmentProvider.notifier,
                  )
                      .createDepartment(entity);

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Department created successfully.',
                      ),
                    ),
                  );
                }

                if (!context.mounted) return;

                await ref
                    .read(
                  departmentProvider.notifier,
                )
                    .loadDepartments();

                context.push(
                  RoutePaths.departments,
                );
              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context)
                    .showSnackBar(
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