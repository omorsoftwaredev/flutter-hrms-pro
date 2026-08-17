//===============================================================
// Employee Account View Page
//===============================================================

import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_tile.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/employee_account_entity.dart';

class EmployeeAccountViewPage extends StatelessWidget {
  const EmployeeAccountViewPage({super.key, required this.account});

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

  //=============================================================
  // CONTENT WIDTH
  //=============================================================

  double _contentWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= 1400) {
      return 1100;
    }

    if (width >= 1000) {
      return 900;
    }

    if (width >= 700) {
      return 700;
    }

    return double.infinity;
  }

  //=============================================================
  // HORIZONTAL PADDING
  //=============================================================

  double _horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= 1200) {
      return 32;
    }

    if (width >= 700) {
      return 24;
    }

    return 16;
  }

  //=============================================================
  // BUILD
  //=============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    final horizontalPadding = _horizontalPadding(context);

    return Scaffold(
      //=========================================================
      // APP BAR
      //=========================================================
      appBar: AppBar(title: const Text('Employee Account Details')),

      //=========================================================
      // BODY
      //=========================================================
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: _contentWidth(context),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                24,
              ),
              child: Column(
                children: [
                  //=================================================
                  // ACCOUNT HEADER
                  //=================================================
                  AppCard(
                    child: Column(
                      children: [
                        //=============================================
                        // ACCOUNT ICON
                        //=============================================
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: colorScheme.primaryContainer,
                          foregroundColor: colorScheme.onPrimaryContainer,
                          child: const Icon(
                            Icons.manage_accounts_rounded,
                            size: 42,
                          ),
                        ),

                        const SizedBox(height: 16),

                        //=============================================
                        // USERNAME
                        //=============================================
                        Text(
                          _displayValue(account.username),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 8),

                        //=============================================
                        // EMPLOYEE NAME
                        //=============================================
                        Text(
                          _displayValue(account.employeeName),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),

                        const SizedBox(height: 20),

                        //=============================================
                        // STATUS
                        //=============================================
                        AppStatusChip(isActive: account.isActive),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  //=================================================
                  // RELATION INFORMATION
                  //=================================================
                  AppCard(
                    child: Column(
                      children: [
                        AppDetailTile(
                          icon: Icons.business_rounded,
                          title: 'Company',
                          value: _displayValue(account.companyName),
                        ),

                        AppDetailTile(
                          icon: Icons.badge_rounded,
                          title: 'Company ID',
                          value: _displayValue(account.companyId),
                        ),

                        AppDetailTile(
                          icon: Icons.apartment_rounded,
                          title: 'Department',
                          value: _displayValue(account.departmentName),
                        ),

                        AppDetailTile(
                          icon: Icons.account_tree_rounded,
                          title: 'Department ID',
                          value: _displayValue(account.departmentId),
                        ),

                        AppDetailTile(
                          icon: Icons.person_rounded,
                          title: 'Employee',
                          value: _displayValue(account.employeeName),
                        ),

                        AppDetailTile(
                          icon: Icons.badge_outlined,
                          title: 'Employee ID',
                          value: _displayValue(account.employeeId),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  //=================================================
                  // ACCOUNT INFORMATION
                  //=================================================
                  AppCard(
                    child: Column(
                      children: [
                        AppDetailTile(
                          icon: Icons.person_outline_rounded,
                          title: 'Username',
                          value: _displayValue(account.username),
                        ),

                        AppDetailTile(
                          icon: Icons.login_rounded,
                          title: 'Login Permission',
                          value: account.canLogin ? 'Allowed' : 'Blocked',
                        ),

                        AppDetailTile(
                          icon: Icons.verified_user_rounded,
                          title: 'Account Status',
                          value: account.isActive ? 'Active' : 'Inactive',
                        ),

                        AppDetailTile(
                          icon: Icons.lock_outline_rounded,
                          title: 'Account Lock',
                          value: account.isLocked ? 'Locked' : 'Unlocked',
                        ),

                        AppDetailTile(
                          icon: Icons.warning_amber_rounded,
                          title: 'Failed Login Attempts',
                          value: account.failedLoginAttempts.toString(),
                        ),

                        AppDetailTile(
                          icon: Icons.password_rounded,
                          title: 'Force Change Password',
                          value: account.forceChangePassword ? 'Yes' : 'No',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  //=================================================
                  // LOGIN INFORMATION
                  //=================================================
                  AppCard(
                    child: Column(
                      children: [
                        AppDetailTile(
                          icon: Icons.login_rounded,
                          title: 'Last Login',
                          value: _formatDateTime(account.lastLoginAt),
                        ),

                        AppDetailTile(
                          icon: Icons.lan_rounded,
                          title: 'Last Login IP',
                          value: _displayValue(account.lastLoginIp),
                        ),

                        AppDetailTile(
                          icon: Icons.lock_clock_rounded,
                          title: 'Account Locked At',
                          value: _formatDateTime(account.accountLockedAt),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  //=================================================
                  // PASSWORD INFORMATION
                  //=================================================
                  AppCard(
                    child: Column(
                      children: [
                        AppDetailTile(
                          icon: Icons.password_rounded,
                          title: 'Password Changed',
                          value: _formatDateTime(account.passwordChangedAt),
                        ),

                        AppDetailTile(
                          icon: Icons.event_rounded,
                          title: 'Password Expire',
                          value: _formatDateTime(account.passwordExpireAt),
                        ),

                        AppDetailTile(
                          icon: Icons.key_rounded,
                          title: 'Password Reset Token',
                          value:
                              account.passwordResetToken == null ||
                                  account.passwordResetToken!.trim().isEmpty
                              ? '-'
                              : 'Available',
                        ),

                        AppDetailTile(
                          icon: Icons.timer_rounded,
                          title: 'Password Reset Expire',
                          value: _formatDateTime(account.passwordResetExpireAt),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  //=================================================
                  // AUDIT INFORMATION
                  //=================================================
                  AppCard(
                    child: Column(
                      children: [
                        AppDetailTile(
                          icon: Icons.person_add_rounded,
                          title: 'Created By',
                          value: _displayValue(account.createdBy),
                        ),

                        AppDetailTile(
                          icon: Icons.access_time_rounded,
                          title: 'Created At',
                          value: _formatDateTime(account.createdAt),
                        ),

                        AppDetailTile(
                          icon: Icons.edit_rounded,
                          title: 'Updated By',
                          value: _displayValue(account.updatedBy),
                        ),

                        AppDetailTile(
                          icon: Icons.update_rounded,
                          title: 'Updated At',
                          value: _formatDateTime(account.updatedAt),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  //=================================================
                  // CLOSE
                  //=================================================
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close_rounded),
                      label: const Text('Close'),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
