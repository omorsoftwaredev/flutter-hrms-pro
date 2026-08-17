// ===============================================================
// Employee Account View Dialog
// Theme + Responsive Version
// ===============================================================

import 'package:flutter/material.dart';

import '../../domain/entities/employee_account_entity.dart';

Future<void> showEmployeeAccountDialog(
  BuildContext context,
  EmployeeAccountEntity account,
) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  final screenWidth = MediaQuery.sizeOf(context).width;

  final dialogWidth = screenWidth >= 1000
      ? 720.0
      : screenWidth >= 600
      ? 600.0
      : screenWidth * 0.92;

  return showDialog<void>(
    context: context,
    builder: (_) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: screenWidth < 600 ? 12 : 24,
          vertical: 24,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: dialogWidth,
            maxHeight: MediaQuery.sizeOf(context).height * 0.88,
          ),
          child: Padding(
            padding: EdgeInsets.all(screenWidth < 600 ? 16 : 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // =================================================
                // HEADER
                // =================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: screenWidth < 600 ? 24 : 28,
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      child: Icon(
                        Icons.manage_accounts_rounded,
                        size: screenWidth < 600 ? 26 : 30,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.username.isEmpty
                                ? 'Employee Account'
                                : account.username,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            account.employeeName?.isNotEmpty == true
                                ? account.employeeName!
                                : 'Unknown Employee',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    IconButton(
                      tooltip: 'Close',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Divider(height: 1),

                const SizedBox(height: 16),

                // =================================================
                // CONTENT
                // =================================================
                Flexible(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // =========================================
                        // EMPLOYEE INFORMATION
                        // =========================================
                        _sectionTitle(
                          context,
                          'Employee Information',
                          Icons.badge_outlined,
                        ),

                        _item(
                          context,
                          'Employee Name',
                          account.employeeName?.isNotEmpty == true
                              ? account.employeeName!
                              : '-',
                        ),

                        _item(context, 'Employee ID', account.employeeId),

                        _item(
                          context,
                          'Company',
                          account.companyName?.isNotEmpty == true
                              ? account.companyName!
                              : '-',
                        ),

                        _item(context, 'Company ID', account.companyId),

                        _item(
                          context,
                          'Department',
                          account.departmentName?.isNotEmpty == true
                              ? account.departmentName!
                              : '-',
                        ),

                        _item(context, 'Department ID', account.departmentId),

                        const SizedBox(height: 8),

                        // =========================================
                        // ACCOUNT INFORMATION
                        // =========================================
                        _sectionTitle(
                          context,
                          'Account Information',
                          Icons.manage_accounts_outlined,
                        ),

                        _item(context, 'Username', account.username),

                        _item(
                          context,
                          'Login Permission',
                          account.canLogin ? 'Allowed' : 'Blocked',
                        ),

                        _item(
                          context,
                          'Account Status',
                          account.isActive ? 'Active' : 'Inactive',
                        ),

                        _item(
                          context,
                          'Account Lock',
                          account.isLocked ? 'Locked' : 'Unlocked',
                        ),

                        _item(
                          context,
                          'Failed Login Attempts',
                          account.failedLoginAttempts.toString(),
                        ),

                        _item(
                          context,
                          'Force Change Password',
                          account.forceChangePassword ? 'Yes' : 'No',
                        ),

                        const SizedBox(height: 8),

                        // =========================================
                        // LOGIN INFORMATION
                        // =========================================
                        _sectionTitle(
                          context,
                          'Login Information',
                          Icons.login_outlined,
                        ),

                        _item(
                          context,
                          'Last Login',
                          account.lastLoginAt?.toString() ?? '-',
                        ),

                        _item(
                          context,
                          'Last Login IP',
                          account.lastLoginIp ?? '-',
                        ),

                        const SizedBox(height: 8),

                        // =========================================
                        // PASSWORD INFORMATION
                        // =========================================
                        _sectionTitle(
                          context,
                          'Password Information',
                          Icons.password_outlined,
                        ),

                        _item(
                          context,
                          'Password Changed',
                          account.passwordChangedAt?.toString() ?? '-',
                        ),

                        _item(
                          context,
                          'Password Expire',
                          account.passwordExpireAt?.toString() ?? '-',
                        ),

                        const SizedBox(height: 8),

                        // =========================================
                        // SECURITY INFORMATION
                        // =========================================
                        _sectionTitle(
                          context,
                          'Security Information',
                          Icons.security_outlined,
                        ),

                        _item(
                          context,
                          'Account Locked At',
                          account.accountLockedAt?.toString() ?? '-',
                        ),

                        const SizedBox(height: 8),

                        // =========================================
                        // AUDIT INFORMATION
                        // =========================================
                        _sectionTitle(
                          context,
                          'Audit Information',
                          Icons.history_outlined,
                        ),

                        _item(context, 'Created By', account.createdBy ?? '-'),

                        _item(
                          context,
                          'Created At',
                          account.createdAt.toString(),
                        ),

                        _item(context, 'Updated By', account.updatedBy ?? '-'),

                        _item(
                          context,
                          'Updated At',
                          account.updatedAt?.toString() ?? '-',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // =================================================
                // ACTION
                // =================================================
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
              ],
            ),
          ),
        ),
      );
    },
  );
}

// ===============================================================
// SECTION TITLE
// ===============================================================

Widget _sectionTitle(BuildContext context, String title, IconData icon) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return Padding(
    padding: const EdgeInsets.only(top: 4, bottom: 12),
    child: Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
        ),
      ],
    ),
  );
}

// ===============================================================
// ITEM
// ===============================================================

Widget _item(BuildContext context, String title, String value) {
  final theme = Theme.of(context);

  final displayValue = value.trim().isEmpty ? '-' : value.trim();

  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.35,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 4),

          SelectableText(
            displayValue,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}
