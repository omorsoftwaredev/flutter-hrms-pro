//===============================================================
// Employee Account View Page
//===============================================================

import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_tile.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/employee_account_entity.dart';

class EmployeeAccountViewPage extends StatelessWidget {
  const EmployeeAccountViewPage({
    super.key,
    required this.account,
  });

  final EmployeeAccountEntity account;

  //=============================================================
  // DATE FORMAT
  //=============================================================

  String _formatDateTime(DateTime? value) {
    if (value == null) {
      return '-';
    }

    return value.toLocal().toString();
  }

  //=============================================================
  // DISPLAY VALUE
  //=============================================================

  String _displayValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '-';
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //=========================================================
      // APP BAR
      //=========================================================

      appBar: AppBar(
        title: const Text(
          'Employee Account Details',
        ),
      ),

      //=========================================================
      // BODY
      //=========================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //===================================================
            // ACCOUNT HEADER
            //===================================================

            AppCard(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(
                      Icons.manage_accounts,
                      size: 42,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    account.username,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _displayValue(account.employeeName),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  AppStatusChip(
                    isActive: account.isActive,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //===================================================
            // RELATION INFORMATION
            //===================================================

            AppCard(
              child: Column(
                children: [
                  AppDetailTile(
                    icon: Icons.business,
                    title: 'Company',
                    value: _displayValue(
                      account.companyName,
                    ),
                  ),

                  AppDetailTile(
                    icon: Icons.business_center,
                    title: 'Company ID',
                    value: account.companyId,
                  ),

                  AppDetailTile(
                    icon: Icons.apartment,
                    title: 'Department',
                    value: _displayValue(
                      account.departmentName,
                    ),
                  ),

                  AppDetailTile(
                    icon: Icons.apartment,
                    title: 'Department ID',
                    value: account.departmentId,
                  ),

                  AppDetailTile(
                    icon: Icons.person,
                    title: 'Employee',
                    value: _displayValue(
                      account.employeeName,
                    ),
                  ),

                  AppDetailTile(
                    icon: Icons.badge,
                    title: 'Employee ID',
                    value: account.employeeId,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //===================================================
            // ACCOUNT INFORMATION
            //===================================================

            AppCard(
              child: Column(
                children: [
                  AppDetailTile(
                    icon: Icons.person_outline,
                    title: 'Username',
                    value: account.username,
                  ),

                  AppDetailTile(
                    icon: Icons.login,
                    title: 'Login Permission',
                    value: account.canLogin
                        ? 'Allowed'
                        : 'Blocked',
                  ),

                  AppDetailTile(
                    icon: Icons.verified_user,
                    title: 'Account Status',
                    value: account.isActive
                        ? 'Active'
                        : 'Inactive',
                  ),

                  AppDetailTile(
                    icon: Icons.lock_outline,
                    title: 'Account Lock',
                    value: account.isLocked
                        ? 'Locked'
                        : 'Unlocked',
                  ),

                  AppDetailTile(
                    icon: Icons.warning_amber,
                    title: 'Failed Login Attempts',
                    value: account.failedLoginAttempts
                        .toString(),
                  ),

                  AppDetailTile(
                    icon: Icons.password,
                    title: 'Force Change Password',
                    value: account.forceChangePassword
                        ? 'Yes'
                        : 'No',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //===================================================
            // LOGIN INFORMATION
            //===================================================

            AppCard(
              child: Column(
                children: [
                  AppDetailTile(
                    icon: Icons.login,
                    title: 'Last Login',
                    value: _formatDateTime(
                      account.lastLoginAt,
                    ),
                  ),

                  AppDetailTile(
                    icon: Icons.lan,
                    title: 'Last Login IP',
                    value: _displayValue(
                      account.lastLoginIp,
                    ),
                  ),

                  AppDetailTile(
                    icon: Icons.lock_clock,
                    title: 'Account Locked At',
                    value: _formatDateTime(
                      account.accountLockedAt,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //===================================================
            // PASSWORD INFORMATION
            //===================================================

            AppCard(
              child: Column(
                children: [
                  AppDetailTile(
                    icon: Icons.password,
                    title: 'Password Changed',
                    value: _formatDateTime(
                      account.passwordChangedAt,
                    ),
                  ),

                  AppDetailTile(
                    icon: Icons.event,
                    title: 'Password Expire',
                    value: _formatDateTime(
                      account.passwordExpireAt,
                    ),
                  ),

                  AppDetailTile(
                    icon: Icons.key,
                    title: 'Password Reset Token',
                    value: account.passwordResetToken == null ||
                        account.passwordResetToken!
                            .trim()
                            .isEmpty
                        ? '-'
                        : 'Available',
                  ),

                  AppDetailTile(
                    icon: Icons.timer,
                    title: 'Password Reset Expire',
                    value: _formatDateTime(
                      account.passwordResetExpireAt,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //===================================================
            // AUDIT INFORMATION
            //===================================================

            AppCard(
              child: Column(
                children: [
                  AppDetailTile(
                    icon: Icons.person_add,
                    title: 'Created By',
                    value: _displayValue(
                      account.createdBy,
                    ),
                  ),

                  AppDetailTile(
                    icon: Icons.access_time,
                    title: 'Created At',
                    value: _formatDateTime(
                      account.createdAt,
                    ),
                  ),

                  AppDetailTile(
                    icon: Icons.edit,
                    title: 'Updated By',
                    value: _displayValue(
                      account.updatedBy,
                    ),
                  ),

                  AppDetailTile(
                    icon: Icons.update,
                    title: 'Updated At',
                    value: _formatDateTime(
                      account.updatedAt,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            //===================================================
            // CLOSE
            //===================================================

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
                label: const Text('Close'),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}