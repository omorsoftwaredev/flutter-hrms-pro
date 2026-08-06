//===============================================================
// Employee Account View Page
//===============================================================

import 'package:flutter/material.dart';

import '../../domain/entities/employee_account_entity.dart';

class EmployeeAccountViewPage extends StatelessWidget {
  const EmployeeAccountViewPage({
    super.key,
    required this.account,
  });

  final EmployeeAccountEntity account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employee Account Details',
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                _item(
                  'Company ID',
                  account.companyId,
                ),

                _item(
                  'Department ID',
                  account.departmentId,
                ),

                _item(
                  'Employee ID',
                  account.employeeId,
                ),

                _item(
                  'Username',
                  account.username,
                ),

                _item(
                  'Login Permission',
                  account.canLogin
                      ? 'Allowed'
                      : 'Blocked',
                ),

                _item(
                  'Account Status',
                  account.isActive
                      ? 'Active'
                      : 'Inactive',
                ),

                _item(
                  'Account Lock',
                  account.isLocked
                      ? 'Locked'
                      : 'Unlocked',
                ),

                _item(
                  'Failed Login',
                  account.failedLoginAttempts
                      .toString(),
                ),

                _item(
                  'Force Change Password',
                  account.forceChangePassword
                      ? 'Yes'
                      : 'No',
                ),

                _item(
                  'Last Login',
                  account.lastLoginAt == null
                      ? '-'
                      : account.lastLoginAt.toString(),
                ),

                _item(
                  'Last Login IP',
                  account.lastLoginIp ?? '-',
                ),

                _item(
                  'Password Changed',
                  account.passwordChangedAt ==
                      null
                      ? '-'
                      : account.passwordChangedAt
                      .toString(),
                ),

                _item(
                  'Password Expire',
                  account.passwordExpireAt ==
                      null
                      ? '-'
                      : account.passwordExpireAt
                      .toString(),
                ),

                _item(
                  'Account Locked At',
                  account.accountLockedAt ==
                      null
                      ? '-'
                      : account.accountLockedAt
                      .toString(),
                ),

                _item(
                  'Created At',
                  account.createdAt.toString(),
                ),

                _item(
                  'Updated At',
                  account.updatedAt == null
                      ? '-'
                      : account.updatedAt
                      .toString(),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Close',
                    ),
                  ),
                ),
              ],
            ),
          ),
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
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),

          const Divider(),

        ],
      ),
    );
  }
}