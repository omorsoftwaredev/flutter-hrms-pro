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
  final screenWidth = MediaQuery.sizeOf(context).width;

  final isSmallScreen = screenWidth < 400;
  final isMobile = screenWidth < 600;
  final isWideScreen = screenWidth >= 900;

  final dialogWidth = isWideScreen
      ? 720.0
      : screenWidth >= 600
      ? 600.0
      : screenWidth * 0.94;

  final horizontalPadding = isSmallScreen
      ? 14.0
      : isMobile
      ? 18.0
      : 24.0;

  return showDialog<void>(
    context: context,
    builder: (_) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final textTheme = theme.textTheme;

      return Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 10 : 20,
          vertical: 20,
        ),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isSmallScreen ? 18 : 22,
          ),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: dialogWidth,
            maxHeight:
            MediaQuery.sizeOf(context).height * 0.90,
          ),
          child: Padding(
            padding: EdgeInsets.all(
              horizontalPadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // =================================================
                // HEADER
                // =================================================

                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.center,
                  children: [
                    // =============================================
                    // ACCOUNT ICON
                    // =============================================

                    Container(
                      width: isSmallScreen ? 50 : 58,
                      height: isSmallScreen ? 50 : 58,
                      decoration: BoxDecoration(
                        color:
                        colorScheme.primaryContainer,
                        borderRadius:
                        BorderRadius.circular(
                          isSmallScreen ? 14 : 16,
                        ),
                        border: Border.all(
                          color:
                          colorScheme.primary
                              .withValues(
                            alpha: 0.10,
                          ),
                        ),
                      ),
                      child: Icon(
                        Icons.manage_accounts_rounded,
                        size: isSmallScreen ? 25 : 29,
                        color: colorScheme
                            .onPrimaryContainer,
                      ),
                    ),

                    SizedBox(
                      width: isSmallScreen ? 10 : 14,
                    ),

                    // =============================================
                    // TITLE / EMPLOYEE
                    // =============================================

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.username.isEmpty
                                ? 'Employee Account'
                                : account.username,
                            maxLines: 2,
                            overflow:
                            TextOverflow.ellipsis,
                            style: textTheme.titleLarge
                                ?.copyWith(
                              fontWeight:
                              FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            account.employeeName
                                ?.isNotEmpty ==
                                true
                                ? account.employeeName!
                                : 'Unknown Employee',
                            maxLines: 2,
                            overflow:
                            TextOverflow.ellipsis,
                            style: textTheme.bodyMedium
                                ?.copyWith(
                              color: colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      width: 6,
                    ),

                    // =============================================
                    // CLOSE ICON
                    // =============================================

                    IconButton(
                      tooltip: 'Close',
                      visualDensity:
                      VisualDensity.compact,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 18,
                ),

                // =================================================
                // HEADER DIVIDER
                // =================================================

                Divider(
                  height: 1,
                  color: colorScheme.outlineVariant
                      .withValues(
                    alpha: 0.45,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                // =================================================
                // CONTENT
                // =================================================

                Flexible(
                  child: SingleChildScrollView(
                    physics:
                    const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
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
                          account.employeeName
                              ?.isNotEmpty ==
                              true
                              ? account.employeeName!
                              : '-',
                        ),

                        _item(
                          context,
                          'Employee ID',
                          account.employeeId,
                        ),

                        _item(
                          context,
                          'Company',
                          account.companyName
                              ?.isNotEmpty ==
                              true
                              ? account.companyName!
                              : '-',
                        ),

                        _item(
                          context,
                          'Company ID',
                          account.companyId,
                        ),

                        _item(
                          context,
                          'Department',
                          account.departmentName
                              ?.isNotEmpty ==
                              true
                              ? account.departmentName!
                              : '-',
                        ),

                        _item(
                          context,
                          'Department ID',
                          account.departmentId,
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        // =========================================
                        // ACCOUNT INFORMATION
                        // =========================================

                        _sectionTitle(
                          context,
                          'Account Information',
                          Icons.manage_accounts_outlined,
                        ),

                        _item(
                          context,
                          'Username',
                          account.username,
                        ),

                        _item(
                          context,
                          'Login Permission',
                          account.canLogin
                              ? 'Allowed'
                              : 'Blocked',
                        ),

                        _item(
                          context,
                          'Account Status',
                          account.isActive
                              ? 'Active'
                              : 'Inactive',
                        ),

                        _item(
                          context,
                          'Account Lock',
                          account.isLocked
                              ? 'Locked'
                              : 'Unlocked',
                        ),

                        _item(
                          context,
                          'Failed Login Attempts',
                          account.failedLoginAttempts
                              .toString(),
                        ),

                        _item(
                          context,
                          'Force Change Password',
                          account.forceChangePassword
                              ? 'Yes'
                              : 'No',
                        ),

                        const SizedBox(
                          height: 6,
                        ),

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
                          account.lastLoginAt
                              ?.toString() ??
                              '-',
                        ),

                        _item(
                          context,
                          'Last Login IP',
                          account.lastLoginIp ??
                              '-',
                        ),

                        const SizedBox(
                          height: 6,
                        ),

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
                          account.passwordChangedAt
                              ?.toString() ??
                              '-',
                        ),

                        _item(
                          context,
                          'Password Expire',
                          account.passwordExpireAt
                              ?.toString() ??
                              '-',
                        ),

                        const SizedBox(
                          height: 6,
                        ),

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
                          account.accountLockedAt
                              ?.toString() ??
                              '-',
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        // =========================================
                        // AUDIT INFORMATION
                        // =========================================

                        _sectionTitle(
                          context,
                          'Audit Information',
                          Icons.history_outlined,
                        ),

                        _item(
                          context,
                          'Created By',
                          account.createdBy ?? '-',
                        ),

                        _item(
                          context,
                          'Created At',
                          account.createdAt.toString(),
                        ),

                        _item(
                          context,
                          'Updated By',
                          account.updatedBy ?? '-',
                        ),

                        _item(
                          context,
                          'Updated At',
                          account.updatedAt
                              ?.toString() ??
                              '-',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 14,
                ),

                // =================================================
                // CLOSE ACTION
                // =================================================

                SizedBox(
                  width: double.infinity,
                  height: isSmallScreen ? 46 : 48,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                    label: const Text(
                      'Close',
                    ),
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

Widget _sectionTitle(
    BuildContext context,
    String title,
    IconData icon,
    ) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return Padding(
    padding: const EdgeInsets.only(
      top: 4,
      bottom: 10,
    ),
    child: Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer
                .withValues(
              alpha: 0.65,
            ),
            borderRadius:
            BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 19,
            color:
            colorScheme.onPrimaryContainer,
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleSmall
                ?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
              letterSpacing: 0.1,
            ),
          ),
        ),

        const SizedBox(
          width: 8,
        ),

        Expanded(
          flex: 2,
          child: Divider(
            color: colorScheme.outlineVariant
                .withValues(
              alpha: 0.35,
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

Widget _item(
    BuildContext context,
    String title,
    String value,
    ) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  final displayValue =
  value.trim().isEmpty ? '-' : value.trim();

  return Padding(
    padding: const EdgeInsets.only(
      bottom: 10,
    ),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: colorScheme
            .surfaceContainerHighest
            .withValues(
          alpha: 0.32,
        ),
        borderRadius:
        BorderRadius.circular(11),
        border: Border.all(
          color: colorScheme.outlineVariant
              .withValues(
            alpha: 0.22,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium
                ?.copyWith(
              fontWeight: FontWeight.w600,
              color:
              colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          SelectableText(
            displayValue,
            style: theme.textTheme.bodyMedium
                ?.copyWith(
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        ],
      ),
    ),
  );
}