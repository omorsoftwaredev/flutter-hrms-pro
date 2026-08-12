//===============================================================
// Employee Account Form Page
//===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../../domain/entities/employee_account_entity.dart';
import '../providers/employee_account_provider.dart';
import 'employee_account_form.dart';

class EmployeeAccountFormPage extends ConsumerWidget {
  const EmployeeAccountFormPage({
    super.key,
    this.account,
  });

  final EmployeeAccountEntity? account;

  bool get isEdit => account != null;

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    // ===========================================================
    // CURRENT LOGGED-IN USER
    // ===========================================================
    //
    // Application custom authentication ব্যবহার করা হচ্ছে।
    //
    // CurrentUser.userId:
    //   Developer       → developers.id
    //   Company Owner   → company_accounts.id
    //   Employee        → employee_accounts.id
    //   Supervisor      → employee_accounts.id
    //
    // ===========================================================

    final user = ref.watch(currentUserProvider);

    // ===========================================================
    // EMPLOYEE ACCOUNT STATE
    // ===========================================================

    final state = ref.watch(employeeAccountProvider);

    // ===========================================================
    // USER VALIDATION
    // ===========================================================

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            isEdit
                ? 'Edit Employee Account'
                : 'Create Employee Account',
          ),
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

    final String currentUserId = user.userId.trim();

    // ===========================================================
    // USER ID VALIDATION
    // ===========================================================

    if (currentUserId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            isEdit
                ? 'Edit Employee Account'
                : 'Create Employee Account',
          ),
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
    // CURRENT COMPANY ID
    // ===========================================================
    //
    // CREATE:
    // CurrentUser.companyId
    //
    // UPDATE:
    // Existing account-এর companyId নয়,
    // CurrentUser.companyId-ই authoritative।
    //
    // এতে অন্য company-এর account edit করার সুযোগ থাকবে না।
    //
    // ===========================================================

    final String companyId = user.companyId.trim();

    // ===========================================================
    // COMPANY ID VALIDATION
    // ===========================================================

    if (companyId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            isEdit
                ? 'Edit Employee Account'
                : 'Create Employee Account',
          ),
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
      'EMPLOYEE ACCOUNT FORM USER',
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
      'Account ID    => ${account?.id}',
    );

    debugPrint(
      'Account User  => ${account?.username}',
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
              ? 'Edit Employee Account'
              : 'Create Employee Account',
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: EmployeeAccountForm(
            // ===================================================
            // COMPANY
            // ===================================================
            //
            // Edit হলে existing company দেখাবে।
            // Create হলে CurrentUser company দেখাবে।
            //
            // Form থেকে companyId submit হলেও Page
            // validated companyId ব্যবহার করবে।
            //
            // ===================================================

            initialCompanyId:
            account?.companyId ?? companyId,

            // ===================================================
            // DEPARTMENT
            // ===================================================

            initialDepartmentId:
            account?.departmentId,

            // ===================================================
            // EMPLOYEE
            // ===================================================

            initialEmployeeId:
            account?.employeeId,

            // ===================================================
            // USERNAME
            // ===================================================

            initialUsername:
            account?.username ?? '',

            // ===================================================
            // PASSWORD
            // ===================================================
            //
            // Existing password কখনো form-এ load করা হচ্ছে না।
            //
            // Edit-এর সময় নতুন password দিলে update হবে।
            //
            // ===================================================

            initialPassword: '',

            // ===================================================
            // ACCOUNT STATUS
            // ===================================================

            initialCanLogin:
            account?.canLogin ?? true,

            initialIsActive:
            account?.isActive ?? true,

            initialIsLocked:
            account?.isLocked ?? false,

            // ===================================================
            // LOADING
            // ===================================================

            isLoading: state.isSaving,

            // ===================================================
            // SUBMIT
            // ===================================================

            onSubmit: (
                submittedCompanyId,
                departmentId,
                employeeId,
                username,
                password,
                canLogin,
                isActive,
                isLocked,
                ) async {
              // =================================================
              // IMPORTANT
              // =================================================
              //
              // Form থেকে companyId আসলেও সেটার উপর
              // নির্ভর করা হচ্ছে না।
              //
              // CurrentUser.companyId validated value ব্যবহার করা
              // হচ্ছে।
              //
              // =================================================

              final String finalCompanyId = companyId;

              // =================================================
              // PASSWORD
              // =================================================
              //
              // Create:
              // নতুন password ব্যবহার হবে।
              //
              // Edit:
              // password empty হলে existing passwordHash
              // preserve করা হবে।
              //
              // =================================================

              final String finalPasswordHash =
              password.trim().isNotEmpty
                  ? password.trim()
                  : (account?.passwordHash ?? '');

              // =================================================
              // ENTITY
              // =================================================

              final entity = EmployeeAccountEntity(
                // ------------------------------------------------
                // ID
                // ------------------------------------------------

                id: account?.id ?? '',

                // ------------------------------------------------
                // COMPANY
                // ------------------------------------------------

                companyId: finalCompanyId,

                // ------------------------------------------------
                // DEPARTMENT
                // ------------------------------------------------

                departmentId: departmentId,

                // ------------------------------------------------
                // EMPLOYEE
                // ------------------------------------------------

                employeeId: employeeId,

                // ------------------------------------------------
                // DISPLAY DATA
                // ------------------------------------------------
                //
                // এগুলো database insert/update-এ ব্যবহার হবে না।
                //
                // ------------------------------------------------

                employeeName:
                account?.employeeName,

                companyName:
                account?.companyName,

                departmentName:
                account?.departmentName,

                // ------------------------------------------------
                // ACCOUNT
                // ------------------------------------------------

                username: username.trim(),

                passwordHash:
                finalPasswordHash,

                canLogin: canLogin,

                isActive: isActive,

                isLocked: isLocked,

                // ------------------------------------------------
                // LOGIN DATA
                // ------------------------------------------------
                //
                // Existing values preserve করছি।
                //
                // ------------------------------------------------

                failedLoginAttempts:
                account?.failedLoginAttempts ?? 0,

                lastLoginAt:
                account?.lastLoginAt,

                lastLoginIp:
                account?.lastLoginIp,

                // ------------------------------------------------
                // PASSWORD DATA
                // ------------------------------------------------

                passwordChangedAt:
                account?.passwordChangedAt,

                passwordResetToken:
                account?.passwordResetToken,

                passwordResetExpireAt:
                account?.passwordResetExpireAt,

                forceChangePassword:
                account?.forceChangePassword ?? true,

                passwordExpireAt:
                account?.passwordExpireAt,

                accountLockedAt:
                account?.accountLockedAt,

                // ------------------------------------------------
                // CREATED BY
                // ------------------------------------------------
                //
                // CREATE:
                // Current logged-in user
                //
                // UPDATE:
                // Original createdBy preserve হবে।
                //
                // ------------------------------------------------

                createdBy: isEdit
                    ? account?.createdBy
                    : currentUserId,

                // ------------------------------------------------
                // CREATED AT
                // ------------------------------------------------
                //
                // Existing record হলে original value preserve।
                //
                // Create হলে temporary DateTime দেওয়া হচ্ছে।
                // Database default থাকলে repository payload-এ
                // এটি ব্যবহার করা হবে না।
                //
                // ------------------------------------------------

                createdAt:
                account?.createdAt ??
                    DateTime.now(),

                // ------------------------------------------------
                // UPDATED BY
                // ------------------------------------------------
                //
                // সবসময় current logged-in user।
                //
                // ------------------------------------------------

                updatedBy:
                currentUserId,

                // ------------------------------------------------
                // UPDATED AT
                // ------------------------------------------------

                updatedAt:
                DateTime.now(),
              );

              // =================================================
              // DEBUG ENTITY
              // =================================================

              debugPrint(
                '================ EMPLOYEE ACCOUNT SAVE ================',
              );

              debugPrint(
                'Mode          => '
                    '${isEdit ? 'UPDATE' : 'CREATE'}',
              );

              debugPrint(
                'Account ID    => ${entity.id}',
              );

              debugPrint(
                'Username      => ${entity.username}',
              );

              debugPrint(
                'Company ID    => ${entity.companyId}',
              );

              debugPrint(
                'Department ID => ${entity.departmentId}',
              );

              debugPrint(
                'Employee ID   => ${entity.employeeId}',
              );

              debugPrint(
                'Created By    => ${entity.createdBy}',
              );

              debugPrint(
                'Updated By    => ${entity.updatedBy}',
              );

              debugPrint(
                'Can Login     => ${entity.canLogin}',
              );

              debugPrint(
                'Is Active     => ${entity.isActive}',
              );

              debugPrint(
                'Is Locked     => ${entity.isLocked}',
              );

              debugPrint(
                '==========================================================',
              );

              // =================================================
              // SAVE
              // =================================================

              try {
                // =================================================
                // UPDATE
                // =================================================

                if (isEdit) {
                  await ref
                      .read(
                    employeeAccountProvider
                        .notifier,
                  )
                      .updateAccount(
                    entity,
                  );
                }

                // =================================================
                // CREATE
                // =================================================

                else {
                  await ref
                      .read(
                    employeeAccountProvider
                        .notifier,
                  )
                      .createAccount(
                    entity,
                  );
                }

                // =================================================
                // SUCCESS
                // =================================================

                if (!context.mounted) {
                  return;
                }

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEdit
                          ? 'Employee account updated successfully.'
                          : 'Employee account created successfully.',
                    ),
                  ),
                );

                // =================================================
                // BACK
                // =================================================

                context.pop(true);
              } catch (e) {
                // =================================================
                // ERROR
                // =================================================

                debugPrint(
                  'Employee Account Save Error => $e',
                );

                if (!context.mounted) {
                  return;
                }

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
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