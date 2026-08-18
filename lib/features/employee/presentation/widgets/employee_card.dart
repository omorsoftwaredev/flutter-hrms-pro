// ===============================================================
// Flutter HRMS Pro
// Employee Card
//
// Clean + Professional HRMS UI
// Responsive + Theme Aware
// Mobile / Tablet / Desktop
//
// Based on CompanyAccountCard UI Experience
// ===============================================================

import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/employee_entity.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    super.key,
    required this.employee,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
  });

  final EmployeeEntity employee;

  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleStatus;

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // =============================================================
    // RESPONSIVE
    // =============================================================

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double cardPadding = isDesktop
        ? 22
        : isTablet
        ? 20
        : 16;

    final double avatarSize = isDesktop
        ? 56
        : isTablet
        ? 54
        : 52;

    final double headerSpacing = isDesktop
        ? 14
        : isTablet
        ? 13
        : 12;

    final double sectionSpacing = isDesktop
        ? 18
        : isTablet
        ? 17
        : 16;

    // =============================================================
    // EMPLOYEE NAME
    // =============================================================

    final String employeeName =
    employee.fullName.trim().isNotEmpty
        ? employee.fullName.trim()
        : 'Unknown Employee';

    // =============================================================
    // FIRST LETTER
    // =============================================================

    final String avatarLetter = employeeName.isNotEmpty
        ? employeeName.substring(0, 1).toUpperCase()
        : '?';

    // =============================================================
    // STATUS
    // =============================================================

    final bool isActive = employee.isActive;

    final Color statusBackgroundColor = isActive
        ? colorScheme.secondaryContainer
        : colorScheme.errorContainer;

    final Color statusForegroundColor = isActive
        ? colorScheme.onSecondaryContainer
        : colorScheme.onErrorContainer;

    final IconData statusIcon = isActive
        ? Icons.check_circle_outline_rounded
        : Icons.pause_circle_outline_rounded;

    // =============================================================
    // PHOTO AVAILABLE
    // =============================================================

    final bool hasPhoto =
        employee.photoUrl != null &&
            employee.photoUrl!.trim().isNotEmpty;

    // =============================================================
    // BUILD
    // =============================================================

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------------------------------------------------
                // EMPLOYEE AVATAR
                // -------------------------------------------------

                Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(
                      isDesktop ? 17 : 16,
                    ),
                    image: hasPhoto
                        ? DecorationImage(
                      image: NetworkImage(
                        employee.photoUrl!.trim(),
                      ),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: hasPhoto
                      ? null
                      : Text(
                    avatarLetter,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color:
                      colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                SizedBox(width: headerSpacing),

                // -------------------------------------------------
                // EMPLOYEE INFORMATION
                // -------------------------------------------------

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // EMPLOYEE NAME

                      Text(
                        employeeName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                        theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
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

            SizedBox(height: sectionSpacing),

            // =====================================================
            // INFORMATION CARD
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
              child: Column(
                children: [
                  // ------------------------------------------------
                  // MOBILE
                  // ------------------------------------------------

                  if (employee.mobile != null &&
                      employee.mobile!.trim().isNotEmpty)
                    _buildInfoRow(
                      context,
                      icon: Icons.phone_outlined,
                      title: 'Mobile',
                      value: employee.mobile!.trim(),
                    ),

                  // ------------------------------------------------
                  // EMAIL
                  // ------------------------------------------------

                  if (employee.email != null &&
                      employee.email!.trim().isNotEmpty)
                    _buildInfoRow(
                      context,
                      icon: Icons.email_outlined,
                      title: 'Email',
                      value: employee.email!.trim(),
                    ),


                  // ------------------------------------------------
                  // EMPTY STATE
                  // ------------------------------------------------

                  if ((employee.mobile == null ||
                      employee.mobile!
                          .trim()
                          .isEmpty) &&
                      (employee.email == null ||
                          employee.email!
                              .trim()
                              .isEmpty) &&
                      (employee.employeeStatus == null ||
                          employee.employeeStatus!
                              .trim()
                              .isEmpty))
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color:
                          colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'No additional information',
                          style: theme
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // =====================================================
            // ACCOUNT STATUS
            // =====================================================

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(
                isDesktop ? 13 : 12,
              ),
              decoration: BoxDecoration(
                color: statusBackgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  // STATUS ICON

                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: statusForegroundColor
                          .withValues(alpha: 0.12),
                      borderRadius:
                      BorderRadius.circular(11),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      statusIcon,
                      size: 19,
                      color: statusForegroundColor,
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
                          'Employee Status',
                          style: theme
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                            color: statusForegroundColor
                                .withValues(alpha: 0.75),
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isActive
                              ? 'Active employee'
                              : 'Employee inactive',
                          style: theme
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            color:
                            statusForegroundColor,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // STATUS CHIP

                  _buildStatusChip(
                    context,
                    icon: isActive
                        ? Icons.check_rounded
                        : Icons.close_rounded,
                    label:
                    isActive ? 'Active' : 'Inactive',
                    backgroundColor:
                    statusForegroundColor
                        .withValues(alpha: 0.14),
                    foregroundColor:
                    statusForegroundColor,
                  ),
                ],
              ),
            ),
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
      tooltip: 'Employee actions',

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
              'Edit Employee',
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
              employee.isActive
                  ? Icons.pause_circle_outline_rounded
                  : Icons.play_circle_outline_rounded,
            ),
            title: Text(
              employee.isActive
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
              'Delete Employee',
              style: theme.textTheme.bodyMedium?.copyWith(
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
  // INFO ROW
  // =============================================================

  Widget _buildInfoRow(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICON

          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 17,
              color: colorScheme.onPrimaryContainer,
            ),
          ),

          const SizedBox(width: 10),

          // INFORMATION

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                  theme.textTheme.labelSmall?.copyWith(
                    color:
                    colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                  theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
            style:
            theme.textTheme.labelSmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}