import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../../../../core/router/route_paths.dart';
import '../../domain/entities/employee_entity.dart';
import '../providers/employee_provider.dart';
import '../widgets/employee_form.dart';

class EmployeeFormPage extends ConsumerWidget {
  const EmployeeFormPage({
    super.key,
    this.employee,
  });

  final EmployeeEntity? employee;

  bool get isEdit => employee != null;

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    // ===========================================================
    // CURRENT LOGGED-IN USER
    // ===========================================================

    final user = ref.watch(currentUserProvider);

    // ===========================================================
    // EMPLOYEE STATE
    // ===========================================================

    final state = ref.watch(employeeProvider);

    // ===========================================================
    // USER VALIDATION
    // ===========================================================

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Employee'),
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
          title: const Text('Employee'),
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

    final companyId = isEdit
        ? (employee?.companyId ?? '').trim()
        : user.companyId.trim();

    if (companyId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Employee'),
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

    debugPrint('==============================================');
    debugPrint('EMPLOYEE FORM');
    debugPrint('Mode          => ${isEdit ? 'UPDATE' : 'CREATE'}');
    debugPrint('User ID       => $currentUserId');
    debugPrint('Login Name    => ${user.loginName}');
    debugPrint('User Type     => ${user.userType.name}');
    debugPrint('Company ID    => $companyId');
    debugPrint('Employee ID   => ${employee?.id}');
    debugPrint('Employee Code => ${employee?.employeeCode}');
    debugPrint('==============================================');

    // ===========================================================
    // PAGE
    // ===========================================================

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Employee' : 'Add Employee',
        ),
      ),

      // IMPORTANT:
      // EmployeeForm already contains ListView.
      // তাই এখানে আর SingleChildScrollView ব্যবহার করা যাবে না.
      body: SafeArea(
        child: EmployeeForm(
          initialCompanyId:
          employee?.companyId ?? companyId,

          initialDepartmentId:
          employee?.departmentId,

          initialDesignationId:
          employee?.designationId,

          initialShiftId:
          employee?.shiftId,

          initialRoleId:
          employee?.roleId,

          initialEmployeeCode:
          employee?.employeeCode ?? '',

          initialCardNo:
          employee?.cardNo ?? '',

          initialFirstName:
          employee?.firstName ?? '',

          initialLastName:
          employee?.lastName ?? '',

          initialFullName:
          employee?.fullName ?? '',

          initialGender:
          employee?.gender ?? 'Male',

          initialMobile:
          employee?.mobile ?? '',

          initialEmail:
          employee?.email ?? '',

          initialEmploymentType:
          employee?.employmentType ?? 'Permanent',

          initialEmployeeStatus:
          employee?.employeeStatus ?? 'Active',

          initialBasicSalary:
          employee?.basicSalary ?? 0,

          initialIsActive:
          employee?.isActive ?? true,

          isLoading:
          state.isSaving,

          // =====================================================
          // SUBMIT
          // =====================================================

          onSubmit: (
              submittedCompanyId,
              departmentId,
              designationId,
              shiftId,
              roleId,
              employeeCode,
              cardNo,
              firstName,
              lastName,
              fullName,
              mobile,
              email,
              gender,
              employmentType,
              employeeStatus,
              basicSalary,
              isActive,
              ) async {
            // ===================================================
            // FINAL COMPANY ID
            // ===================================================

            final finalCompanyId = companyId;

            // ===================================================
            // ENTITY
            // ===================================================

            final entity = EmployeeEntity(
              id: employee?.id ?? '',

              companyId: finalCompanyId,

              departmentId: departmentId,

              designationId: designationId,

              shiftId: shiftId,

              roleId: roleId,

              cardNo: cardNo.trim(),

              firstName: firstName.trim(),

              lastName: lastName?.trim(),

              fullName: fullName.trim(),

              gender: gender?.trim(),

              dateOfBirth:
              employee?.dateOfBirth,

              bloodGroup:
              employee?.bloodGroup,

              religion:
              employee?.religion,

              nationality:
              employee?.nationality,

              maritalStatus:
              employee?.maritalStatus,

              mobile: mobile?.trim(),

              email: email?.trim(),

              emergencyContactName:
              employee?.emergencyContactName,

              emergencyContactMobile:
              employee?.emergencyContactMobile,

              presentAddress:
              employee?.presentAddress,

              permanentAddress:
              employee?.permanentAddress,

              joiningDate:
              employee?.joiningDate,

              confirmationDate:
              employee?.confirmationDate,

              employmentType:
              employmentType?.trim(),

              employeeStatus:
              employeeStatus?.trim(),

              nidNo:
              employee?.nidNo,

              passportNo:
              employee?.passportNo,

              basicSalary:
              basicSalary,

              photoUrl:
              employee?.photoUrl,

              signatureUrl:
              employee?.signatureUrl,

              isActive:
              isActive,

              createdAt:
              employee?.createdAt ??
                  DateTime.now(),

              updatedAt:
              DateTime.now(),

              userId:
              employee?.userId,

              createdBy: isEdit
                  ? employee?.createdBy
                  : currentUserId,

              updatedBy:
              currentUserId,

              lastLoginAt:
              employee?.lastLoginAt,
            );

            // ===================================================
            // DEBUG
            // ===================================================

            debugPrint(
              '============= EMPLOYEE SAVE =============',
            );

            debugPrint(
              'Mode          => '
                  '${isEdit ? 'UPDATE' : 'CREATE'}',
            );

            debugPrint(
              'Employee ID   => ${entity.id}',
            );

            debugPrint(
              'Employee Code => ${entity.employeeCode}',
            );

            debugPrint(
              'Name          => ${entity.fullName}',
            );

            debugPrint(
              'Company ID    => ${entity.companyId}',
            );

            debugPrint(
              'Department ID => ${entity.departmentId}',
            );

            debugPrint(
              'Designation ID=> ${entity.designationId}',
            );

            debugPrint(
              'Shift ID      => ${entity.shiftId}',
            );

            debugPrint(
              'Role ID       => ${entity.roleId}',
            );

            debugPrint(
              'Created By    => ${entity.createdBy}',
            );

            debugPrint(
              'Updated By    => ${entity.updatedBy}',
            );

            debugPrint(
              '==========================================',
            );

            // ===================================================
            // SAVE
            // ===================================================

            try {
              if (isEdit) {
                await ref
                    .read(employeeProvider.notifier)
                    .updateEmployee(entity);

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Employee updated successfully.',
                    ),
                  ),
                );
              } else {
                await ref
                    .read(employeeProvider.notifier)
                    .createEmployee(entity);

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Employee created successfully.',
                    ),
                  ),
                );
              }

              // =================================================
              // RELOAD
              // =================================================

              await ref
                  .read(employeeProvider.notifier)
                  .loadEmployees();

              if (!context.mounted) return;

              // =================================================
              // BACK TO LIST
              // =================================================

              context.go(
                RoutePaths.employees,
              );
            } catch (e) {
              debugPrint(
                'Employee Save Error => $e',
              );

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
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
    );
  }
}