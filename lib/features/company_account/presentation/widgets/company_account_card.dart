// ===============================================================
// Flutter HRMS Pro
// Company Account Card
//
// Clean + Professional HRMS UI
// Responsive + Theme Aware
// Mobile / Tablet / Desktop
//
// Version : 4.0.0
// ===============================================================

import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/company_account_entity.dart';

class CompanyAccountCard extends StatelessWidget {
  const CompanyAccountCard({
    super.key,
    required this.account,
    this.onView,
    this.onEdit,
    this.onToggleStatus,
    this.onDelete,
  });

  final CompanyAccountEntity account;

  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onToggleStatus;
  final VoidCallback? onDelete;

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final username = account.username.trim().isEmpty
        ? 'Unknown User'
        : account.username.trim();

    final companyName =
    account.companyName?.trim().isNotEmpty == true
        ? account.companyName!.trim()
        : 'Company not assigned';

    final avatarLetter =
    username.isNotEmpty
        ? username[0].toUpperCase()
        : '?';

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // HEADER
            // =====================================================

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------------------------------------------------
                // AVATAR
                // -------------------------------------------------

                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    avatarLetter,
                    style:
                    theme.textTheme.titleLarge?.copyWith(
                      color:
                      colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // -------------------------------------------------
                // ACCOUNT INFORMATION
                // -------------------------------------------------

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // USERNAME

                      Text(
                        username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                        theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // COMPANY

                      Row(
                        children: [
                          Icon(
                            Icons.business_outlined,
                            size: 15,
                            color:
                            colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              companyName,
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(
                                color: colorScheme
                                    .onSurfaceVariant,
                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // -------------------------------------------------
                // MORE MENU
                // -------------------------------------------------

                _buildMoreMenu(context),
              ],
            ),

            const SizedBox(height: 18),

            // =====================================================
            // ACCOUNT STATUS
            // =====================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                ),
              ),
              child: Row(
                children: [
                  // STATUS ICON

                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: account.isActive
                          ? colorScheme.secondaryContainer
                          : colorScheme.errorContainer,
                      borderRadius:
                      BorderRadius.circular(11),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      account.isActive
                          ? Icons.check_circle_outline_rounded
                          : Icons.pause_circle_outline_rounded,
                      size: 19,
                      color: account.isActive
                          ? colorScheme
                          .onSecondaryContainer
                          : colorScheme.onErrorContainer,
                    ),
                  ),

                  const SizedBox(width: 11),

                  // STATUS TEXT

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Status',
                          style: theme
                              .textTheme.labelSmall
                              ?.copyWith(
                            color:
                            colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          account.isActive
                              ? 'Active account'
                              : 'Account inactive',
                          style: theme
                              .textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // STATUS CHIP

                  _buildStatusChip(
                    context,
                    icon: account.isActive
                        ? Icons.check_rounded
                        : Icons.close_rounded,
                    label: account.isActive
                        ? 'Active'
                        : 'Inactive',
                    backgroundColor: account.isActive
                        ? colorScheme.secondaryContainer
                        : colorScheme.errorContainer,
                    foregroundColor: account.isActive
                        ? colorScheme.onSecondaryContainer
                        : colorScheme.onErrorContainer,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

          ],
        ),
      ),
    );
  }

  // =============================================================
  // MORE MENU
  // =============================================================

  Widget _buildMoreMenu(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopupMenuButton<String>(
      tooltip: 'More options',

      icon: const Icon(
        Icons.more_vert_rounded,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      onSelected: (value) {
        switch (value) {
          case 'view':
            onView?.call();
            break;

          case 'edit':
            onEdit?.call();
            break;

          case 'status':
            onToggleStatus?.call();
            break;

          case 'delete':
            onDelete?.call();
            break;
        }
      },

      itemBuilder: (_) => [
        // ---------------------------------------------------------
        // VIEW
        // ---------------------------------------------------------

        const PopupMenuItem<String>(
          value: 'view',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.visibility_outlined,
            ),
            title: Text(
              'View Details',
            ),
          ),
        ),

        // ---------------------------------------------------------
        // EDIT
        // ---------------------------------------------------------

        const PopupMenuItem<String>(
          value: 'edit',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.edit_outlined,
            ),
            title: Text(
              'Edit Account',
            ),
          ),
        ),

        // ---------------------------------------------------------
        // STATUS
        // ---------------------------------------------------------

        PopupMenuItem<String>(
          value: 'status',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              account.isActive
                  ? Icons.pause_circle_outline_rounded
                  : Icons.play_circle_outline_rounded,
            ),
            title: Text(
              account.isActive
                  ? 'Deactivate'
                  : 'Activate',
            ),
          ),
        ),

        const PopupMenuDivider(),

        // ---------------------------------------------------------
        // DELETE
        // ---------------------------------------------------------

        PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.delete_outline_rounded,
              color: colorScheme.error,
            ),
            title: Text(
              'Delete Account',
              style: TextStyle(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // STATUS CHIP
  // =============================================================

  Widget _buildStatusChip(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color backgroundColor,
        required Color foregroundColor,
      }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: foregroundColor,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}