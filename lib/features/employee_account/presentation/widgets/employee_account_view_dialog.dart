// ===============================================================
// Employee Account View Dialog
// ===============================================================

import 'package:flutter/material.dart';

import '../../domain/entities/employee_account_entity.dart';

Future<void> showEmployeeAccountDialog(
    BuildContext context,
    EmployeeAccountEntity account,
    ) {
  return showDialog<void>(
    context: context,
    builder: (_) {
      return AlertDialog(
        icon: const CircleAvatar(
          radius: 28,
          child: Icon(
            Icons.manage_accounts,
            size: 30,
          ),
        ),

        title: Text(
          account.username,
          textAlign: TextAlign.center,
        ),

        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _sectionTitle('Employee Information'),

              _item(
                'Employee Name',
                account.employeeName?.isNotEmpty == true
                    ? account.employeeName!
                    : '-',
              ),

              _item(
                'Employee ID',
                account.employeeId,
              ),

              _item(
                'Company',
                account.companyName?.isNotEmpty == true
                    ? account.companyName!
                    : '-',
              ),

              _item(
                'Company ID',
                account.companyId,
              ),

              _item(
                'Department',
                account.departmentName?.isNotEmpty == true
                    ? account.departmentName!
                    : '-',
              ),

              _item(
                'Department ID',
                account.departmentId,
              ),

              const SizedBox(height: 8),

              _sectionTitle('Account Information'),

              _item(
                'Username',
                account.username,
              ),

              _item(
                'Login Permission',
                account.canLogin ? 'Allowed' : 'Blocked',
              ),

              _item(
                'Account Status',
                account.isActive ? 'Active' : 'Inactive',
              ),

              _item(
                'Account Lock',
                account.isLocked ? 'Locked' : 'Unlocked',
              ),

              _item(
                'Failed Login Attempts',
                account.failedLoginAttempts.toString(),
              ),

              _item(
                'Force Change Password',
                account.forceChangePassword ? 'Yes' : 'No',
              ),

              const SizedBox(height: 8),

              _sectionTitle('Login Information'),

              _item(
                'Last Login',
                account.lastLoginAt?.toString() ?? '-',
              ),

              _item(
                'Last Login IP',
                account.lastLoginIp ?? '-',
              ),

              const SizedBox(height: 8),

              _sectionTitle('Password Information'),

              _item(
                'Password Changed',
                account.passwordChangedAt?.toString() ?? '-',
              ),

              _item(
                'Password Expire',
                account.passwordExpireAt?.toString() ?? '-',
              ),

              const SizedBox(height: 8),

              _sectionTitle('Security Information'),

              _item(
                'Account Locked At',
                account.accountLockedAt?.toString() ?? '-',
              ),

              const SizedBox(height: 8),

              _sectionTitle('Audit Information'),

              _item(
                'Created By',
                account.createdBy ?? '-',
              ),

              _item(
                'Created At',
                account.createdAt.toString(),
              ),

              _item(
                'Updated By',
                account.updatedBy ?? '-',
              ),

              _item(
                'Updated At',
                account.updatedAt?.toString() ?? '-',
              ),
            ],
          ),
        ),

        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

Widget _sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(
      top: 4,
      bottom: 10,
    ),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          value.isEmpty ? '-' : value,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 8),

        const Divider(
          height: 1,
        ),
      ],
    ),
  );
}