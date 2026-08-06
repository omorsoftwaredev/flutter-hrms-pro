// ===============================================================
// Employee Account View Dialog
// ===============================================================

import 'package:flutter/material.dart';

import '../../domain/entities/employee_account_entity.dart';

Future<void> showEmployeeAccountDialog(
    BuildContext context,
    EmployeeAccountEntity account,
    ) {
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text(
          'Employee Account',
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              _item(
                "Company ID",
                account.companyId,
              ),

              _item(
                "Department ID",
                account.departmentId,
              ),

              _item(
                "Employee ID",
                account.employeeId,
              ),

              _item(
                "Username",
                account.username,
              ),

              _item(
                "Can Login",
                account.canLogin
                    ? "Yes"
                    : "No",
              ),

              _item(
                "Status",
                account.isActive
                    ? "Active"
                    : "Inactive",
              ),

              _item(
                "Account Locked",
                account.isLocked
                    ? "Yes"
                    : "No",
              ),

              _item(
                "Failed Login Attempts",
                account
                    .failedLoginAttempts
                    .toString(),
              ),

              _item(
                "Force Change Password",
                account
                    .forceChangePassword
                    ? "Yes"
                    : "No",
              ),

              _item(
                "Last Login",
                account.lastLoginAt == null
                    ? "-"
                    : account.lastLoginAt
                    .toString(),
              ),

              _item(
                "Password Changed",
                account.passwordChangedAt ==
                    null
                    ? "-"
                    : account
                    .passwordChangedAt
                    .toString(),
              ),

              _item(
                "Password Expire",
                account.passwordExpireAt ==
                    null
                    ? "-"
                    : account
                    .passwordExpireAt
                    .toString(),
              ),

              _item(
                "Account Locked At",
                account.accountLockedAt ==
                    null
                    ? "-"
                    : account
                    .accountLockedAt
                    .toString(),
              ),

              _item(
                "Created At",
                account.createdAt == null
                    ? "-"
                    : account.createdAt
                    .toString(),
              ),

              _item(
                "Updated At",
                account.updatedAt == null
                    ? "-"
                    : account.updatedAt
                    .toString(),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "OK",
            ),
          ),
        ],
      );
    },
  );
}

Widget _item(
    String title,
    String value,
    ) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 12,
    ),
    child: Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight:
            FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(value),
      ],
    ),
  );
}