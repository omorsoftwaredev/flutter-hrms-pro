import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/current_user_provider.dart';
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
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    // ===========================================================
    // CURRENT LOGGED-IN USER
    // ===========================================================
    //
    // IMPORTANT:
    //
    // তোমার authentication custom table based:
    //
    // Developer       → developers.id
    // Company Owner   → company_accounts.id
    // Employee        → employee_accounts.id
    // Supervisor      → employee_accounts.id
    //
    // তাই এখানে Supabase Auth ব্যবহার করা হচ্ছে না।
    //
    // CurrentUser.userId-ই আমাদের application login user ID.
    //
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
      return Scaffold(
        appBar: AppBar(
          title: const Text('Department'),
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
    // CURRENT APPLICATION USER ID
    // ===========================================================
    //
    // Company Owner login করলে:
    //
    // company_accounts.id
    //        ↓
    // AuthRepository
    //        ↓
    // CurrentUser.userId
    //        ↓
    // created_by / updated_by
    //
    // ===========================================================

    final String currentUserId = user.userId.trim();

    // ===========================================================
    // USER ID VALIDATION
    // ===========================================================

    if (currentUserId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Department'),
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
    // COMPANY ID
    // ===========================================================
    //
    // CREATE:
    // CurrentUser.companyId
    //
    // EDIT:
    // Existing Department.companyId
    //
    // ===========================================================

    final String companyId = isEdit
        ? department!.companyId
        : user.companyId.trim();

    // ===========================================================
    // COMPANY ID VALIDATION
    // ===========================================================

    if (companyId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Department'),
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
      'DEPARTMENT FORM USER',
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
      'Department ID => ${department?.id}',
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
      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        title: Text(
          isEdit
              ? 'Edit Department'
              : 'Add Department',
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: DepartmentForm(
            // ===================================================
            // INITIAL NAME
            // ===================================================

            initialName:
            department?.name ?? '',

            // ===================================================
            // INITIAL DESCRIPTION
            // ===================================================

            initialDescription:
            department?.description ?? '',

            // ===================================================
            // INITIAL PHONE
            // ===================================================

            initialPhone:
            department?.phone ?? '',

            // ===================================================
            // INITIAL EMAIL
            // ===================================================

            initialEmail:
            department?.email ?? '',

            // ===================================================
            // INITIAL LOCATION
            // ===================================================

            initialLocation:
            department?.location ?? '',

            // ===================================================
            // INITIAL ACTIVE
            // ===================================================

            initialIsActive:
            department?.isActive ?? true,

            // ===================================================
            // LOADING
            // ===================================================

            isLoading: state.isSaving,

            // ===================================================
            // SUBMIT
            // ===================================================

            onSubmit: (
                submittedCompanyId,
                name,
                description,
                phone,
                email,
                location,
                isActive,
                ) async {
              // =================================================
              // IMPORTANT
              // =================================================
              //
              // Form থেকে companyId আসলেও আমরা সেটার উপর
              // নির্ভর করছি না।
              //
              // Page-এর validated companyId ব্যবহার করছি।
              //
              // =================================================

              final String finalCompanyId =
                  companyId;

              // =================================================
              // ENTITY
              // =================================================

              final entity = DepartmentEntity(
                // ------------------------------------------------
                // ID
                // ------------------------------------------------

                id: department?.id ?? '',

                // ------------------------------------------------
                // COMPANY
                // ------------------------------------------------

                companyId: finalCompanyId,

                // ------------------------------------------------
                // DEPARTMENT
                // ------------------------------------------------

                name: name.trim(),

                description:
                description.trim(),

                phone: phone.trim(),

                email: email.trim(),

                location:
                location.trim(),

                isActive: isActive,

                // ------------------------------------------------
                // CREATED AT
                // ------------------------------------------------
                //
                // Database default now() ব্যবহার করবে CREATE-এর
                // সময়।
                //
                // Existing record edit করলে original value
                // preserve করছি।
                //
                // ------------------------------------------------

                createdAt:
                department?.createdAt ??
                    DateTime.now(),

                // ------------------------------------------------
                // UPDATED AT
                // ------------------------------------------------
                //
                // Database trigger:
                //
                // fn_set_updated_at()
                //
                // automatically update করবে।
                //
                // ------------------------------------------------

                updatedAt:
                DateTime.now(),

                // ------------------------------------------------
                // CREATED BY
                // ------------------------------------------------
                //
                // CREATE:
                //
                // company_accounts.id
                // অথবা login করা user-এর application ID
                //
                // UPDATE:
                //
                // Original created_by কখনো পরিবর্তন হবে না।
                //
                // ------------------------------------------------

                createdBy: isEdit
                    ? department!.createdBy
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

                updatedBy:
                currentUserId,
              );

              // =================================================
              // DEBUG ENTITY
              // =================================================

              debugPrint(
                '================ DEPARTMENT SAVE ================',
              );

              debugPrint(
                'Mode        => '
                    '${isEdit ? 'UPDATE' : 'CREATE'}',
              );

              debugPrint(
                'Department  => ${entity.name}',
              );

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
                // =================================================
                // UPDATE
                // =================================================

                if (isEdit) {
                  await ref
                      .read(
                    departmentProvider
                        .notifier,
                  )
                      .updateDepartment(
                    entity,
                  );

                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Department updated successfully.',
                      ),
                    ),
                  );
                }

                // =================================================
                // CREATE
                // =================================================

                else {
                  await ref
                      .read(
                    departmentProvider
                        .notifier,
                  )
                      .createDepartment(
                    entity,
                  );

                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Department created successfully.',
                      ),
                    ),
                  );
                }

                // =================================================
                // RELOAD
                // =================================================

                await ref
                    .read(
                  departmentProvider.notifier,
                )
                    .loadDepartments();

                // =================================================
                // CONTEXT CHECK
                // =================================================

                if (!context.mounted) {
                  return;
                }

                // =================================================
                // BACK TO DEPARTMENT LIST
                // =================================================

                context.go(
                  RoutePaths.departments,
                );
              } catch (e) {
                // =================================================
                // ERROR
                // =================================================

                debugPrint(
                  'Department Save Error => $e',
                );

                if (!context.mounted) {
                  return;
                }

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    backgroundColor:
                    Colors.red,
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