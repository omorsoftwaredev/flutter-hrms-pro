import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final state = ref.watch(employeeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? 'Edit Employee'
              : 'Add Employee',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: EmployeeForm(
            initialCompanyId: employee?.companyId,
            initialDepartmentId: employee?.departmentId,
            initialDesignationId: employee?.designationId,
            initialShiftId: employee?.shiftId,
            initialRoleId: employee?.roleId,

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
            employee?.employmentType ??
                'Permanent',

            initialEmployeeStatus:
            employee?.employeeStatus ??
                'Active',

            initialBasicSalary:
            employee?.basicSalary ?? 0,

            initialIsActive:
            employee?.isActive ?? true,

            isLoading: state.isSaving,

            onSubmit: (
                companyId,
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
              final entity = EmployeeEntity(
                id: employee?.id ?? '',

                companyId: companyId,
                departmentId: departmentId,
                designationId: designationId,
                shiftId: shiftId,
                roleId: roleId,

                employeeCode: employeeCode,
                cardNo: cardNo,

                firstName: firstName,
                lastName: lastName,
                fullName: fullName,

                mobile: mobile,
                email: email,
                gender: gender,

                employmentType: employmentType,
                employeeStatus: employeeStatus,

                basicSalary: basicSalary,

                isActive: isActive,

                createdAt:
                employee?.createdAt ??
                    DateTime.now(),

                updatedAt: DateTime.now(),
              );

              try {
                if (isEdit) {
                  await ref
                      .read(
                    employeeProvider.notifier,
                  )
                      .updateEmployee(entity);
                } else {
                  await ref
                      .read(
                    employeeProvider.notifier,
                  )
                      .createEmployee(entity);
                }

                if (context.mounted) {
                  context.pop(true);
                }
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