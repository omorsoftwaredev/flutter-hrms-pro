//===============================================================
// Employee Account Form Page
//===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/employee_account_entity.dart';
import '../providers/employee_account_provider.dart';
import 'employee_account_form.dart';

class EmployeeAccountFormPage extends ConsumerWidget {
  const EmployeeAccountFormPage({super.key, this.account});

  final EmployeeAccountEntity? account;

  bool get isEdit => account != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeeAccountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Employee Account' : 'Create Employee Account',
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: EmployeeAccountForm(
            initialCompanyId: account?.companyId,

            initialDepartmentId: account?.departmentId,

            initialEmployeeId: account?.employeeId,

            initialUsername: account?.username ?? '',

            initialPassword: '',

            initialCanLogin: account?.canLogin ?? true,

            initialIsActive: account?.isActive ?? true,

            initialIsLocked: account?.isLocked ?? false,

            isLoading: state.isSaving,

            onSubmit:
                (
                  companyId,
                  departmentId,
                  employeeId,
                  username,
                  password,
                  canLogin,
                  isActive,
                  isLocked,
                ) async {
                  final entity = EmployeeAccountEntity(
                    id: account?.id ?? '',

                    companyId: companyId,

                    departmentId: departmentId,

                    employeeId: employeeId,

                    username: username,

                    passwordHash: password,

                    canLogin: canLogin,

                    isActive: isActive,

                    isLocked: isLocked,

                    failedLoginAttempts: account?.failedLoginAttempts ?? 0,

                    lastLoginAt: account?.lastLoginAt,

                    lastLoginIp: account?.lastLoginIp,

                    passwordChangedAt: account?.passwordChangedAt,

                    passwordResetToken: account?.passwordResetToken,

                    passwordResetExpireAt: account?.passwordResetExpireAt,

                    forceChangePassword: account?.forceChangePassword ?? true,

                    passwordExpireAt: account?.passwordExpireAt,

                    accountLockedAt: account?.accountLockedAt,

                    createdBy: account?.createdBy,

                    createdAt: account?.createdAt ?? DateTime.now(),

                    updatedBy: account?.updatedBy,

                    updatedAt: DateTime.now(),
                  );

                  try {
                    if (isEdit) {
                      await ref
                          .read(employeeAccountProvider.notifier)
                          .updateAccount(entity);
                    } else {
                      await ref
                          .read(employeeAccountProvider.notifier)
                          .createAccount(entity);
                    }

                    if (context.mounted) {
                      context.pop(true);
                    }
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
          ),
        ),
      ),
    );
  }
}
