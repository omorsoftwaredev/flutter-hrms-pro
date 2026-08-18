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

    final screenWidth = MediaQuery.sizeOf(context).width;

    // =============================================================
    // RESPONSIVE
    // =============================================================

    final bool isCompact = screenWidth < 380;
    final bool isWide = screenWidth >= 700;

    final double cardPadding = isCompact
        ? 14
        : isWide
        ? 20
        : 16;

    final double avatarRadius = isCompact
        ? 23
        : isWide
        ? 29
        : 26;

    final double headerSpacing = isCompact ? 10 : 13;

    final double sectionSpacing = isCompact ? 14 : 18;

    // =============================================================
    // EMPLOYEE NAME
    // =============================================================

    final employeeName =
    account.employeeName?.trim().isNotEmpty == true
        ? account.employeeName!.trim()
        : 'Unknown Employee';

    // =============================================================
    // USERNAME
    // =============================================================

    final username =
    account.username.trim().isEmpty
        ? '-'
        : account.username.trim();

    // =============================================================
    // AVATAR TEXT
    // =============================================================

    final avatarText = username == '-'
        ? '?'
        : username.substring(0, 1).toUpperCase();

    // =============================================================
    // STATUS
    // =============================================================

    final bool isActive = account.isActive;
    final bool canLogin = account.canLogin;
    final bool isLocked = account.isLocked;

    // =============================================================
    // CARD
    // =============================================================

    return AppCard(
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =======================================================
            // HEADER
            // =======================================================

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ===================================================
                // AVATAR
                // ===================================================

                CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                  child: Text(
                    avatarText,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                SizedBox(width: headerSpacing),

                // ===================================================
                // EMPLOYEE + USERNAME
                // ===================================================

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employeeName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Icon(
                            Icons.alternate_email_rounded,
                            size: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              username,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 4),

                // ===================================================
                // MENU
                // ===================================================

                PopupMenuButton<String>(
                  tooltip: 'Account actions',
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: colorScheme.onSurfaceVariant,
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
                    // =================================================
                    // VIEW
                    // =================================================

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

                    // =================================================
                    // EDIT
                    // =================================================

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

                    // =================================================
                    // ACTIVE
                    // =================================================

                    PopupMenuItem<String>(
                      value: 'active',
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          isActive
                              ? Icons.toggle_on_rounded
                              : Icons.toggle_off_rounded,
                        ),
                        title: Text(
                          isActive
                              ? 'Deactivate'
                              : 'Activate',
                        ),
                      ),
                    ),

                    // =================================================
                    // LOGIN
                    // =================================================

                    PopupMenuItem<String>(
                      value: 'login',
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          canLogin
                              ? Icons.login_rounded
                              : Icons.login_outlined,
                        ),
                        title: Text(
                          canLogin
                              ? 'Disable Login'
                              : 'Enable Login',
                        ),
                      ),
                    ),

                    // =================================================
                    // LOCK
                    // =================================================

                    PopupMenuItem<String>(
                      value: 'lock',
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          isLocked
                              ? Icons.lock_open_rounded
                              : Icons.lock_outline_rounded,
                        ),
                        title: Text(
                          isLocked
                              ? 'Unlock'
                              : 'Lock',
                        ),
                      ),
                    ),

                    // =================================================
                    // DELETE
                    // =================================================

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

            SizedBox(height: sectionSpacing),

            // =======================================================
            // INFORMATION SECTION
            // =======================================================

            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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

                  const SizedBox(width: 24),

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
              height: isCompact ? 6 : 10,
            ),

            // =======================================================
            // DIVIDER
            // =======================================================

            Divider(
              height: 1,
              color: colorScheme.outlineVariant.withValues(
                alpha: 0.55,
              ),
            ),

            SizedBox(
              height: isCompact ? 12 : 16,
            ),

            // =======================================================
            // STATUS CHIPS
            // =======================================================

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // ===================================================
                // ACTIVE
                // ===================================================

                _statusChip(
                  context: context,
                  icon: isActive
                      ? Icons.check_circle_outline_rounded
                      : Icons.cancel_outlined,
                  label: isActive
                      ? 'Active'
                      : 'Inactive',
                  color: isActive
                      ? colorScheme.primary
                      : colorScheme.error,
                ),

                // ===================================================
                // LOGIN
                // ===================================================

                _statusChip(
                  context: context,
                  icon: canLogin
                      ? Icons.login_rounded
                      : Icons.login_outlined,
                  label: canLogin
                      ? 'Login Enabled'
                      : 'Login Disabled',
                  color: canLogin
                      ? colorScheme.secondary
                      : colorScheme.tertiary,
                ),

                // ===================================================
                // LOCK
                // ===================================================

                _statusChip(
                  context: context,
                  icon: isLocked
                      ? Icons.lock_outline_rounded
                      : Icons.lock_open_outlined,
                  label: isLocked
                      ? 'Locked'
                      : 'Unlocked',
                  color: isLocked
                      ? colorScheme.error
                      : colorScheme.primary,
                ),

                // ===================================================
                // FORCE PASSWORD CHANGE
                // ===================================================

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
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================================================
          // ICON CONTAINER
          // =========================================================

          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 17,
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(width: 9),

          // =========================================================
          // VALUE
          // =========================================================

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
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

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),

          const SizedBox(width: 6),

          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}