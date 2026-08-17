import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/employee_account_entity.dart';

class EmployeeAccountCard extends StatelessWidget {
  const EmployeeAccountCard({
    super.key,
    required this.account,
    this.onView,
    required this.onEdit,
    required this.onDelete,
    this.onToggleActive,
    this.onToggleCanLogin,
    this.onToggleLock,
  });

  final EmployeeAccountEntity account;

  final VoidCallback? onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  final VoidCallback? onToggleActive;
  final VoidCallback? onToggleCanLogin;
  final VoidCallback? onToggleLock;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final isWide = MediaQuery.sizeOf(context).width >= 600;

    final employeeName =
    account.employeeName?.trim().isNotEmpty == true
        ? account.employeeName!.trim()
        : 'Unknown Employee';

    final username =
    account.username.trim().isEmpty
        ? '-'
        : account.username.trim();

    final avatarText =
    username == '-'
        ? '?'
        : username.substring(0, 1).toUpperCase();

    return AppCard(
      child: Padding(
        padding: EdgeInsets.all(
          isWide ? 20 : 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // HEADER
            // =====================================================

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: isWide ? 28 : 26,
                  backgroundColor:
                  colorScheme.primaryContainer,
                  foregroundColor:
                  colorScheme.onPrimaryContainer,
                  child: Text(
                    avatarText,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                SizedBox(
                  width: isWide ? 14 : 12,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        employeeName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                        textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color:
                          colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 4),

                // =================================================
                // MENU
                // =================================================

                PopupMenuButton<String>(
                  tooltip: 'Account actions',
                  icon: const Icon(
                    Icons.more_vert_rounded,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'view':
                        onView?.call();
                        break;

                      case 'edit':
                        onEdit();
                        break;

                      case 'active':
                        onToggleActive?.call();
                        break;

                      case 'login':
                        onToggleCanLogin?.call();
                        break;

                      case 'lock':
                        onToggleLock?.call();
                        break;

                      case 'delete':
                        onDelete();
                        break;
                    }
                  },
                  itemBuilder: (_) => [
                    // ===========================================
                    // VIEW
                    // ===========================================

                    const PopupMenuItem<String>(
                      value: 'view',
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.visibility_outlined,
                        ),
                        title: Text('View'),
                      ),
                    ),

                    // ===========================================
                    // EDIT
                    // ===========================================

                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.edit_outlined,
                        ),
                        title: Text('Edit'),
                      ),
                    ),

                    // ===========================================
                    // ACTIVE / DEACTIVE
                    // ===========================================

                    PopupMenuItem<String>(
                      value: 'active',
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          account.isActive
                              ? Icons.toggle_on_rounded
                              : Icons.toggle_off_rounded,
                        ),
                        title: Text(
                          account.isActive
                              ? 'Deactivate'
                              : 'Activate',
                        ),
                      ),
                    ),

                    // ===========================================
                    // LOGIN
                    // ===========================================

                    PopupMenuItem<String>(
                      value: 'login',
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          account.canLogin
                              ? Icons.login_rounded
                              : Icons.login_outlined,
                        ),
                        title: Text(
                          account.canLogin
                              ? 'Disable Login'
                              : 'Enable Login',
                        ),
                      ),
                    ),

                    // ===========================================
                    // LOCK
                    // ===========================================

                    PopupMenuItem<String>(
                      value: 'lock',
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          account.isLocked
                              ? Icons.lock_open_rounded
                              : Icons.lock_outline_rounded,
                        ),
                        title: Text(
                          account.isLocked
                              ? 'Unlock'
                              : 'Lock',
                        ),
                      ),
                    ),

                    // ===========================================
                    // DELETE
                    // ===========================================

                    PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.delete_outline_rounded,
                          color: colorScheme.error,
                        ),
                        title: Text(
                          'Delete',
                          style: TextStyle(
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(
              height: isWide ? 20 : 16,
            ),

            // =====================================================
            // INFORMATION
            // =====================================================

            if (isWide)
              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _infoRow(
                          context,
                          Icons.person_outline_rounded,
                          account.employeeName
                              ?.trim()
                              .isNotEmpty ==
                              true
                              ? account.employeeName!
                              : account.employeeId,
                        ),

                        _infoRow(
                          context,
                          Icons.business_outlined,
                          account.companyName
                              ?.trim()
                              .isNotEmpty ==
                              true
                              ? account.companyName!
                              : account.companyId,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: Column(
                      children: [
                        _infoRow(
                          context,
                          Icons.apartment_outlined,
                          account.departmentName
                              ?.trim()
                              .isNotEmpty ==
                              true
                              ? account.departmentName!
                              : account.departmentId,
                        ),

                        _infoRow(
                          context,
                          Icons.account_circle_outlined,
                          username,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _infoRow(
                    context,
                    Icons.person_outline_rounded,
                    account.employeeName
                        ?.trim()
                        .isNotEmpty ==
                        true
                        ? account.employeeName!
                        : account.employeeId,
                  ),

                  _infoRow(
                    context,
                    Icons.business_outlined,
                    account.companyName
                        ?.trim()
                        .isNotEmpty ==
                        true
                        ? account.companyName!
                        : account.companyId,
                  ),

                  _infoRow(
                    context,
                    Icons.apartment_outlined,
                    account.departmentName
                        ?.trim()
                        .isNotEmpty ==
                        true
                        ? account.departmentName!
                        : account.departmentId,
                  ),

                  _infoRow(
                    context,
                    Icons.account_circle_outlined,
                    username,
                  ),
                ],
              ),

            SizedBox(
              height: isWide ? 12 : 8,
            ),

            // =====================================================
            // STATUS CHIPS
            // =====================================================

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // =================================================
                // ACTIVE
                // =================================================

                _statusChip(
                  context: context,
                  icon: account.isActive
                      ? Icons.check_circle_outline_rounded
                      : Icons.cancel_outlined,
                  label: account.isActive
                      ? 'Active'
                      : 'Inactive',
                  color: account.isActive
                      ? colorScheme.primary
                      : colorScheme.error,
                ),

                // =================================================
                // LOGIN
                // =================================================

                _statusChip(
                  context: context,
                  icon: account.canLogin
                      ? Icons.login_rounded
                      : Icons.login_outlined,
                  label: account.canLogin
                      ? 'Login Enabled'
                      : 'Login Disabled',
                  color: account.canLogin
                      ? colorScheme.secondary
                      : colorScheme.tertiary,
                ),

                // =================================================
                // LOCK
                // =================================================

                _statusChip(
                  context: context,
                  icon: account.isLocked
                      ? Icons.lock_outline_rounded
                      : Icons.lock_open_outlined,
                  label: account.isLocked
                      ? 'Locked'
                      : 'Unlocked',
                  color: account.isLocked
                      ? colorScheme.error
                      : colorScheme.primary,
                ),

                // =================================================
                // FORCE PASSWORD CHANGE
                // =================================================

                if (account.forceChangePassword)
                  _statusChip(
                    context: context,
                    icon: Icons.password_rounded,
                    label: 'Change Password',
                    color: colorScheme.tertiary,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // INFO ROW
  // =============================================================

  Widget _infoRow(
      BuildContext context,
      IconData icon,
      String text,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final value =
    text.trim().isEmpty ? '-' : text.trim();

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // STATUS CHIP
  // =============================================================

  Widget _statusChip({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Chip(
      avatar: Icon(
        icon,
        size: 17,
        color: color,
      ),
      label: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: color.withValues(
        alpha: 0.10,
      ),
      side: BorderSide(
        color: color.withValues(
          alpha: 0.20,
        ),
      ),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize:
      MaterialTapTargetSize.shrinkWrap,
    );
  }
}