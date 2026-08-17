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
  const EmployeeAccountFormPage({super.key, this.account});

  final EmployeeAccountEntity? account;

  bool get isEdit => account != null;

  //=============================================================
  // PAGE TITLE
  //=============================================================

  String _pageTitle() {
    return isEdit ? 'Edit Employee Account' : 'Create Employee Account';
  }

  //=============================================================
  // ERROR PAGE
  //=============================================================

  Widget _errorPage(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(_pageTitle())),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: colorScheme.error,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          }
                        },
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: const Text('Go Back'),
                      ),
                    ),
                  ],
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
    //=============================================================
    // CURRENT LOGGED-IN USER
    //=============================================================

    final user = ref.watch(currentUserProvider);

    //=============================================================
    // EMPLOYEE ACCOUNT STATE
    //=============================================================

    final state = ref.watch(employeeAccountProvider);

    //=============================================================
    // USER VALIDATION
    //=============================================================

    if (user == null) {
      return _errorPage(
        context,
        'Logged-in user information is not available.',
      );
    }

    //=============================================================
    // CURRENT APPLICATION USER ID
    //=============================================================

    final String currentUserId = user.userId.trim();

    //=============================================================
    // USER ID VALIDATION
    //=============================================================

    if (currentUserId.isEmpty) {
      return _errorPage(context, 'Logged-in user ID is not available.');
    }

    //=============================================================
    // CURRENT COMPANY ID
    //=============================================================
    //
    // CurrentUser.companyId is authoritative.
    //
    // অন্য company-এর account edit করার সুযোগ থাকবে না।
    //
    //=============================================================

    final String companyId = user.companyId.trim();

    //=============================================================
    // COMPANY ID VALIDATION
    //=============================================================

    if (companyId.isEmpty) {
      return _errorPage(
        context,
        'Company information is not available for this account.',
      );
    }

    //=============================================================
    // DEBUG
    //=============================================================

    debugPrint('================================================');

    debugPrint('EMPLOYEE ACCOUNT FORM USER');

    debugPrint('User ID       => $currentUserId');

    debugPrint('Login Name    => ${user.loginName}');

    debugPrint('User Type     => ${user.userType.name}');

    debugPrint('Company ID    => $companyId');

    debugPrint('Account ID    => ${account?.id}');

    debugPrint('Account User  => ${account?.username}');

    debugPrint('Is Edit       => $isEdit');

    debugPrint('================================================');

    //=============================================================
    // PAGE
    //=============================================================

    return Scaffold(
      //===========================================================
      // APP BAR
      //===========================================================
      appBar: AppBar(title: Text(_pageTitle())),

      //===========================================================
      // BODY
      //===========================================================
      body: SafeArea(
        child: EmployeeAccountForm(
          //=======================================================
          // COMPANY
          //=======================================================
          initialCompanyId: account?.companyId ?? companyId,

          //=======================================================
          // DEPARTMENT
          //=======================================================
          initialDepartmentId: account?.departmentId,

          //=======================================================
          // EMPLOYEE
          //=======================================================
          initialEmployeeId: account?.employeeId,

          //=======================================================
          // USERNAME
          //=======================================================
          initialUsername: account?.username ?? '',

          //=======================================================
          // PASSWORD
          //=======================================================
          //
          // Existing password কখনো load করা হবে না।
          //
          //=======================================================
          initialPassword: '',

          //=======================================================
          // ACCOUNT STATUS
          //=======================================================
          initialCanLogin: account?.canLogin ?? true,

          initialIsActive: account?.isActive ?? true,

          initialIsLocked: account?.isLocked ?? false,

          //=======================================================
          // LOADING
          //=======================================================
          isLoading: state.isSaving,

          //=======================================================
          // SUBMIT
          //=======================================================
          onSubmit:
              (
                submittedCompanyId,
                departmentId,
                employeeId,
                username,
                password,
                canLogin,
                isActive,
                isLocked,
              ) async {
                //=====================================================
                // IMPORTANT
                //=====================================================
                //
                // Form থেকে submittedCompanyId আসলেও
                // সেটার উপর নির্ভর করা হচ্ছে না।
                //
                // CurrentUser.companyId ব্যবহার করা হচ্ছে।
                //
                //=====================================================

                final String finalCompanyId = companyId;

                //=====================================================
                // PASSWORD
                //=====================================================
                //
                // Create:
                // নতুন password ব্যবহার হবে।
                //
                // Edit:
                // password empty হলে existing passwordHash preserve।
                //
                //=====================================================

                final String finalPasswordHash = password.trim().isNotEmpty
                    ? password.trim()
                    : (account?.passwordHash ?? '');

                //=====================================================
                // ENTITY
                //=====================================================

                final entity = EmployeeAccountEntity(
                  //===================================================
                  // ID
                  //===================================================
                  id: account?.id ?? '',

                  //===================================================
                  // COMPANY
                  //===================================================
                  companyId: finalCompanyId,

                  //===================================================
                  // DEPARTMENT
                  //===================================================
                  departmentId: departmentId,

                  //===================================================
                  // EMPLOYEE
                  //===================================================
                  employeeId: employeeId,

                  //===================================================
                  // DISPLAY DATA
                  //===================================================
                  employeeName: account?.employeeName,

                  companyName: account?.companyName,

                  departmentName: account?.departmentName,

                  //===================================================
                  // ACCOUNT
                  //===================================================
                  username: username.trim(),

                  passwordHash: finalPasswordHash,

                  canLogin: canLogin,

                  isActive: isActive,

                  isLocked: isLocked,

                  //===================================================
                  // LOGIN DATA
                  //===================================================
                  failedLoginAttempts: account?.failedLoginAttempts ?? 0,

                  lastLoginAt: account?.lastLoginAt,

                  lastLoginIp: account?.lastLoginIp,

                  //===================================================
                  // PASSWORD DATA
                  //===================================================
                  passwordChangedAt: account?.passwordChangedAt,

                  passwordResetToken: account?.passwordResetToken,

                  passwordResetExpireAt: account?.passwordResetExpireAt,

                  forceChangePassword: account?.forceChangePassword ?? true,

                  passwordExpireAt: account?.passwordExpireAt,

                  accountLockedAt: account?.accountLockedAt,

                  //===================================================
                  // CREATED BY
                  //===================================================
                  createdBy: isEdit ? account?.createdBy : currentUserId,

                  //===================================================
                  // CREATED AT
                  //===================================================
                  createdAt: account?.createdAt ?? DateTime.now(),

                  //===================================================
                  // UPDATED BY
                  //===================================================
                  updatedBy: currentUserId,

                  //===================================================
                  // UPDATED AT
                  //===================================================
                  updatedAt: DateTime.now(),
                );

                //=====================================================
                // DEBUG ENTITY
                //=====================================================

                debugPrint(
                  '================ EMPLOYEE ACCOUNT SAVE ================',
                );

                debugPrint(
                  'Mode          => '
                  '${isEdit ? 'UPDATE' : 'CREATE'}',
                );

                debugPrint('Account ID    => ${entity.id}');

                debugPrint('Username      => ${entity.username}');

                debugPrint('Company ID    => ${entity.companyId}');

                debugPrint('Department ID => ${entity.departmentId}');

                debugPrint('Employee ID   => ${entity.employeeId}');

                debugPrint('Created By    => ${entity.createdBy}');

                debugPrint('Updated By    => ${entity.updatedBy}');

                debugPrint('Can Login     => ${entity.canLogin}');

                debugPrint('Is Active     => ${entity.isActive}');

                debugPrint('Is Locked     => ${entity.isLocked}');

                debugPrint(
                  '==========================================================',
                );

                //=====================================================
                // SAVE
                //=====================================================

                try {
                  //===================================================
                  // UPDATE
                  //===================================================

                  if (isEdit) {
                    await ref
                        .read(employeeAccountProvider.notifier)
                        .updateAccount(entity);
                  }
                  //===================================================
                  // CREATE
                  //===================================================
                  else {
                    await ref
                        .read(employeeAccountProvider.notifier)
                        .createAccount(entity);
                  }

                  //===================================================
                  // SUCCESS
                  //===================================================

                  if (!context.mounted) {
                    return;
                  }

                  final theme = Theme.of(context);

                  final colorScheme = theme.colorScheme;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: colorScheme.inverseSurface,
                      content: Text(
                        isEdit
                            ? 'Employee account updated successfully.'
                            : 'Employee account created successfully.',
                        style: TextStyle(color: colorScheme.onInverseSurface),
                      ),
                    ),
                  );

                  //===================================================
                  // BACK
                  //===================================================

                  context.pop(true);
                } catch (e) {
                  //===================================================
                  // ERROR
                  //===================================================

                  debugPrint('Employee Account Save Error => $e');

                  if (!context.mounted) {
                    return;
                  }

                  final theme = Theme.of(context);

                  final colorScheme = theme.colorScheme;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: colorScheme.error,
                      content: Text(
                        e.toString(),
                        style: TextStyle(color: colorScheme.onError),
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
