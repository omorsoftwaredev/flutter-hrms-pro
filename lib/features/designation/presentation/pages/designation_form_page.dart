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
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final state = ref.watch(designationProvider);

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
              ? 'Edit Designation'
              : 'Add Designation',
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: DesignationForm(
            // =====================================================
            // INITIAL VALUES
            // =====================================================

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

            // =====================================================
            // SUBMIT
            // =====================================================
            //
            // Company ID নেই
            // Code নেই
            //
            // Company ID:
            //     CurrentUser.companyId
            //
            // Code:
            //     Database trigger
            //
            // =====================================================

            onSubmit: (
                name,
                description,
                grade,
                displayOrder,
                baseSalary,
                isActive,
                ) async {
              final entity =
              DesignationEntity(
                id: designation?.id ?? '',

                // -------------------------------------------------
                // IMPORTANT
                //
                // এখানে companyId manually দেওয়া হচ্ছে না।
                //
                // Provider/Notifier CurrentUser.companyId
                // থেকে company scope করবে।
                //
                // -------------------------------------------------

                companyId:
                designation?.companyId ?? '',

                name: name,

                description: description,

                grade: grade,

                displayOrder: displayOrder,

                baseSalary: baseSalary,

                isActive: isActive,

                createdAt:
                designation?.createdAt ??
                    DateTime.now(),

                updatedAt:
                designation?.updatedAt,
              );

              try {
                // =================================================
                // UPDATE
                // =================================================

                if (isEdit) {
                  await ref
                      .read(
                    designationProvider
                        .notifier,
                  )
                      .updateDesignation(
                    entity,
                  );
                }

                // =================================================
                // CREATE
                // =================================================

                else {
                  await ref
                      .read(
                    designationProvider
                        .notifier,
                  )
                      .createDesignation(
                    entity,
                  );
                }

                if (!context.mounted) {
                  return;
                }

                // =================================================
                // RELOAD LIST
                // =================================================

                await ref
                    .read(
                  designationProvider
                      .notifier,
                )
                    .loadDesignations();

                if (!context.mounted) {
                  return;
                }

                // =================================================
                // BACK TO DESIGNATION LIST
                // =================================================
                //
                // push না করে pop করছি।
                //
                // কারণ Add/Edit page থেকে list page-এ এসেছি।
                //
                // এতে duplicate list page তৈরি হবে না।
                //
                // =================================================

                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(
                    '/designations',
                  );
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