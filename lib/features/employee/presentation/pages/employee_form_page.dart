import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../../../../core/router/route_paths.dart';
import '../../domain/entities/employee_entity.dart';
import '../providers/employee_provider.dart';
import '../widgets/employee_form.dart';

class EmployeeFormPage extends ConsumerWidget {
  const EmployeeFormPage({super.key, this.employee});

  final EmployeeEntity? employee;

  bool get isEdit => employee != null;

  // ===========================================================
  // RESPONSIVE HORIZONTAL PADDING
  // ===========================================================

  double _horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= 1200) {
      return 40;
    }

    if (width >= 800) {
      return 28;
    }

    return 16;
  }

  // ===========================================================
  // RESPONSIVE CONTENT WIDTH
  // ===========================================================

  double _contentMaxWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= 1400) {
      return 1200;
    }

    if (width >= 1000) {
      return 1000;
    }

    return double.infinity;
  }

  // ===========================================================
  // VALIDATION MESSAGE
  // ===========================================================

  Widget _messagePage(BuildContext context, {required String message}) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Employee')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(_horizontalPadding(context)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 42,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      return _messagePage(
        context,
        message: 'Logged-in user information is not available.',
      );
    }

    // ===========================================================
    // CURRENT USER ID
    // ===========================================================

    final currentUserId = user.userId.trim();

    if (currentUserId.isEmpty) {
      return _messagePage(
        context,
        message: 'Logged-in user ID is not available.',
      );
    }

    // ===========================================================
    // COMPANY ID
    // ===========================================================

    final companyId = isEdit
        ? (employee?.companyId ?? '').trim()
        : user.companyId.trim();

    if (companyId.isEmpty) {
      return _messagePage(
        context,
        message: 'Company information is not available for this account.',
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

    debugPrint('==============================================');

    // ===========================================================
    // RESPONSIVE VALUES
    // ===========================================================

    final horizontalPadding = _horizontalPadding(context);

    final maxWidth = _contentMaxWidth(context);

    // ===========================================================
    // PAGE
    // ===========================================================

    return Scaffold(
      // ===========================================================
      // APP BAR
      // ===========================================================
      appBar: AppBar(title: Text(isEdit ? 'Edit Employee' : 'Add Employee')),

      // ===========================================================
      // BODY
      // ===========================================================
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: EmployeeForm(
                // =================================================
                // COMPANY
                // =================================================
                initialCompanyId: employee?.companyId ?? companyId,

                // =================================================
                // ORGANIZATION
                // =================================================
                initialDepartmentId: employee?.departmentId,

                initialDesignationId: employee?.designationId,

                initialShiftId: employee?.shiftId,

                initialRoleId: employee?.roleId,

                // =================================================
                // BASIC INFORMATION
                // =================================================

                initialCardNo: employee?.cardNo ?? '',

                initialFullName: employee?.fullName ?? '',

                // =================================================
                // PERSONAL
                // =================================================
                initialGender: employee?.gender ?? 'Male',

                // =================================================
                // CONTACT
                // =================================================
                initialMobile: employee?.mobile ?? '',

                initialEmail: employee?.email ?? '',

                // =================================================
                // EMPLOYMENT
                // =================================================
                initialEmploymentType: employee?.employmentType ?? 'Permanent',

                initialEmployeeStatus: employee?.employeeStatus ?? 'Active',

                initialBasicSalary: employee?.basicSalary ?? 0,

                initialIsActive: employee?.isActive ?? true,

                // =================================================
                // LOADING
                // =================================================
                isLoading: state.isSaving,

                // =================================================
                // SUBMIT
                // =================================================
                onSubmit:
                    (
                      submittedCompanyId,
                      departmentId,
                      designationId,
                      shiftId,
                      roleId,
                      cardNo,
                      fullName,
                      mobile,
                      email,
                      gender,
                      employmentType,
                      employeeStatus,
                      basicSalary,
                      isActive,
                    ) async {
                      // =================================================
                      // FINAL COMPANY ID
                      // =================================================

                      final finalCompanyId = companyId;

                      // =================================================
                      // ENTITY
                      // =================================================

                      final entity = EmployeeEntity(
                        id: employee?.id ?? '',

                        companyId: finalCompanyId,

                        departmentId: departmentId,

                        designationId: designationId,

                        shiftId: shiftId,

                        roleId: roleId,

                        cardNo: cardNo.trim(),

                        fullName: fullName.trim(),

                        gender: gender?.trim(),

                        dateOfBirth: employee?.dateOfBirth,

                        bloodGroup: employee?.bloodGroup,

                        religion: employee?.religion,

                        nationality: employee?.nationality,

                        maritalStatus: employee?.maritalStatus,

                        mobile: mobile?.trim(),

                        email: email?.trim(),

                        emergencyContactName: employee?.emergencyContactName,

                        emergencyContactMobile:
                            employee?.emergencyContactMobile,

                        presentAddress: employee?.presentAddress,

                        permanentAddress: employee?.permanentAddress,

                        joiningDate: employee?.joiningDate,

                        confirmationDate: employee?.confirmationDate,

                        employmentType: employmentType?.trim(),

                        employeeStatus: employeeStatus?.trim(),

                        nidNo: employee?.nidNo,

                        passportNo: employee?.passportNo,

                        basicSalary: basicSalary,

                        photoUrl: employee?.photoUrl,

                        signatureUrl: employee?.signatureUrl,

                        isActive: isActive,

                        createdAt: employee?.createdAt ?? DateTime.now(),

                        updatedAt: DateTime.now(),

                        userId: employee?.userId,

                        createdBy: isEdit ? employee?.createdBy : currentUserId,

                        updatedBy: currentUserId,

                        lastLoginAt: employee?.lastLoginAt,
                      );

                      // =================================================
                      // DEBUG
                      // =================================================

                      debugPrint('============= EMPLOYEE SAVE =============');

                      debugPrint(
                        'Mode          => '
                        '${isEdit ? 'UPDATE' : 'CREATE'}',
                      );

                      debugPrint('Employee ID   => ${entity.id}');


                      debugPrint(
                        'Name          => '
                        '${entity.fullName}',
                      );

                      debugPrint(
                        'Company ID    => '
                        '${entity.companyId}',
                      );

                      debugPrint(
                        'Department ID => '
                        '${entity.departmentId}',
                      );

                      debugPrint(
                        'Designation ID=> '
                        '${entity.designationId}',
                      );

                      debugPrint(
                        'Shift ID      => '
                        '${entity.shiftId}',
                      );

                      debugPrint(
                        'Role ID       => '
                        '${entity.roleId}',
                      );

                      debugPrint(
                        'Created By    => '
                        '${entity.createdBy}',
                      );

                      debugPrint(
                        'Updated By    => '
                        '${entity.updatedBy}',
                      );

                      debugPrint('==========================================');

                      // =================================================
                      // SAVE
                      // =================================================

                      try {
                        if (isEdit) {
                          await ref
                              .read(employeeProvider.notifier)
                              .updateEmployee(entity);

                          if (!context.mounted) {
                            return;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Employee updated successfully.'),
                            ),
                          );
                        } else {
                          await ref
                              .read(employeeProvider.notifier)
                              .createEmployee(entity);

                          if (!context.mounted) {
                            return;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Employee created successfully.'),
                            ),
                          );
                        }

                        // ===============================================
                        // RELOAD
                        // ===============================================

                        await ref
                            .read(employeeProvider.notifier)
                            .loadEmployees();

                        if (!context.mounted) {
                          return;
                        }

                        // ===============================================
                        // BACK TO LIST
                        // ===============================================

                        context.go(RoutePaths.employees);
                      } catch (e) {
                        debugPrint('Employee Save Error => $e');

                        if (!context.mounted) {
                          return;
                        }

                        final colorScheme = Theme.of(context).colorScheme;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: colorScheme.error,
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
