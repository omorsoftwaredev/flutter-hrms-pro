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
        border: Border.all(
          color: foregroundColor.withValues(
            alpha: 0.15,
          ),
        ),
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
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
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
      icon: Icon(
        Icons.more_vert_rounded,
        color: colorScheme.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
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
        PopupMenuItem<String>(
          value: 'view',
          child: Row(
            children: [
              Icon(
                Icons.visibility_outlined,
                size: 20,
                color: colorScheme.onSurface,
              ),
              const SizedBox(width: 10),
              Text(
                'View Details',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: 20,
                color: colorScheme.onSurface,
              ),
              const SizedBox(width: 10),
              Text(
                'Edit Account',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        PopupMenuItem<String>(
          value: 'status',
          child: Row(
            children: [
              Icon(
                account.isActive
                    ? Icons.pause_circle_outline_rounded
                    : Icons.play_circle_outline_rounded,
                size: 20,
                color: colorScheme.onSurface,
              ),
              const SizedBox(width: 10),
              Text(
                account.isActive
                    ? 'Deactivate'
                    : 'Activate',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const PopupMenuDivider(),

        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline_rounded,
                size: 20,
                color: colorScheme.error,
              ),
              const SizedBox(width: 10),
              Text(
                'Delete Account',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ===========================================================
    // RESPONSIVE
    // ===========================================================

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double cardPadding = isDesktop
        ? 22
        : isTablet
        ? 20
        : 16;

    final double titleSize = isDesktop
        ? 19
        : 18;

    final double avatarSize = isDesktop
        ? 48
        : 46;

    final double avatarTextSize = isDesktop
        ? 21
        : 20;

    final double statusIconBoxSize = isDesktop
        ? 38
        : 36;

    // ===========================================================
    // DATA
    // ===========================================================

    final username = account.username.trim().isEmpty
        ? 'Unknown User'
        : account.username.trim();

    final companyName =
    account.companyName?.trim().isNotEmpty == true
        ? account.companyName!.trim()
        : 'Company not assigned';

    final avatarLetter = username.isNotEmpty
        ? username[0].toUpperCase()
        : '?';

    // ===========================================================
    // STATUS COLORS
    // ===========================================================

    final Color statusBackground = account.isActive
        ? colorScheme.secondaryContainer
        : colorScheme.errorContainer;

    final Color statusForeground = account.isActive
        ? colorScheme.onSecondaryContainer
        : colorScheme.onErrorContainer;

    return AppCard(
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // HEADER
            // =====================================================

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // -------------------------------------------------
                // AVATAR
                // -------------------------------------------------

                Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    avatarLetter,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: avatarTextSize,
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // -------------------------------------------------
                // ACCOUNT INFORMATION
                // -------------------------------------------------

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          Icon(
                            Icons.business_outlined,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),

                          const SizedBox(width: 6),

                          Expanded(
                            child: Text(
                              companyName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color:
                                colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
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

            const SizedBox(height: 14),

            // =====================================================
            // DIVIDER
            // =====================================================

            Divider(
              height: 1,
              color: colorScheme.outlineVariant,
            ),

            const SizedBox(height: 14),

            // =====================================================
            // ACCOUNT STATUS
            // =====================================================

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(
                isDesktop ? 14 : 13,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                ),
              ),
              child: Row(
                children: [
                  // ------------------------------------------------
                  // STATUS ICON
                  // ------------------------------------------------

                  Container(
                    width: statusIconBoxSize,
                    height: statusIconBoxSize,
                    decoration: BoxDecoration(
                      color: statusBackground,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      account.isActive
                          ? Icons.check_circle_outline_rounded
                          : Icons.pause_circle_outline_rounded,
                      size: 19,
                      color: statusForeground,
                    ),
                  ),

                  const SizedBox(width: 11),

                  // ------------------------------------------------
                  // STATUS TEXT
                  // ------------------------------------------------

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Status',
                          style:
                          theme.textTheme.labelSmall?.copyWith(
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
                          style:
                          theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // ------------------------------------------------
                  // STATUS CHIP
                  // ------------------------------------------------

                  _buildStatusChip(
                    context,
                    icon: account.isActive
                        ? Icons.check_rounded
                        : Icons.close_rounded,
                    label: account.isActive
                        ? 'Active'
                        : 'Inactive',
                    backgroundColor: statusBackground,
                    foregroundColor: statusForeground,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}