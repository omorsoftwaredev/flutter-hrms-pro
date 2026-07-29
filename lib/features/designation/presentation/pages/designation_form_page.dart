import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/designation_entity.dart';
import '../providers/designation_provider.dart';
import '../widgets/designation_form.dart';

class DesignationFormPage extends ConsumerWidget {
  const DesignationFormPage({
    super.key,
    this.designation,
  });

  final DesignationEntity? designation;

  bool get isEdit => designation != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(designationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? 'Edit Designation'
              : 'Add Designation',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: DesignationForm(
            initialCompanyId:
            designation?.companyId ?? '',

            initialCode:
            designation?.code ?? '',

            initialName:
            designation?.name ?? '',

            initialDescription:
            designation?.description ?? '',

            initialGrade:
            designation?.grade ?? 1,

            initialDisplayOrder:
            designation?.displayOrder ?? 0,

            initialBaseSalary:
            designation?.baseSalary ?? 0,

            initialIsActive:
            designation?.isActive ?? true,

            isLoading: state.isSaving,

            onSubmit: (
                companyId,
                code,
                name,
                description,
                grade,
                displayOrder,
                baseSalary,
                isActive,
                ) async {
              final entity = DesignationEntity(
                id: designation?.id ?? '',
                companyId: companyId,
                code: code,
                name: name,
                description: description,
                grade: grade,
                displayOrder: displayOrder,
                baseSalary: baseSalary,
                isActive: isActive,
                createdAt:
                designation?.createdAt ??
                    DateTime.now(),
                updatedAt: DateTime.now(),
              );

              try {
                if (isEdit) {
                  await ref
                      .read(
                    designationProvider
                        .notifier,
                  )
                      .updateDesignation(
                    entity,
                  );
                } else {
                  await ref
                      .read(
                    designationProvider
                        .notifier,
                  )
                      .createDesignation(
                    entity,
                  );
                }

                if (context.mounted) {
                  context.go(
                    '/dashboard/designations',
                  );
                }
              } catch (e) {
                if (context.mounted) {
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
              }
            },
          ),
        ),
      ),
    );
  }
}