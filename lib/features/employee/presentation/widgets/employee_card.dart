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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // =============================================================
    // RESPONSIVE
    // =============================================================

    final screenWidth = MediaQuery.sizeOf(context).width;

    final avatarRadius = screenWidth < 360 ? 22.0 : 26.0;

    final headerSpacing = screenWidth < 360 ? 10.0 : 12.0;

    final sectionSpacing = screenWidth < 360 ? 12.0 : 16.0;

    // =============================================================
    // EMPLOYEE NAME
    // =============================================================

    final employeeName = employee.fullName.trim().isNotEmpty
        ? employee.fullName.trim()
        : employee.firstName.trim().isNotEmpty
        ? employee.firstName.trim()
        : 'Unknown Employee';

    // =============================================================
    // FIRST LETTER
    // =============================================================

    final firstLetter = employeeName.isNotEmpty
        ? employeeName.substring(0, 1).toUpperCase()
        : '?';

    // =============================================================
    // ACTIVE STATUS
    // =============================================================

    final isActive = employee.isActive;

    // =============================================================
    // STATUS COLOR
    // =============================================================

    final statusColor = isActive ? colorScheme.primary : colorScheme.error;

    final statusBackgroundColor = isActive
        ? colorScheme.primary.withValues(
            alpha: theme.brightness == Brightness.dark ? 0.18 : 0.10,
          )
        : colorScheme.error.withValues(
            alpha: theme.brightness == Brightness.dark ? 0.18 : 0.10,
          );

    final statusBorderColor = isActive
        ? colorScheme.primary.withValues(alpha: 0.25)
        : colorScheme.error.withValues(alpha: 0.25);

    // =============================================================
    // STATUS ICON
    // =============================================================

    final statusIcon = isActive ? Icons.check_circle : Icons.cancel;

    return AppCard(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===================================================
              // HEADER
              // ===================================================
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // =================================================
                  // EMPLOYEE PHOTO
                  // =================================================
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: colorScheme.primaryContainer,
                    backgroundImage:
                        employee.photoUrl != null &&
                            employee.photoUrl!.trim().isNotEmpty
                        ? NetworkImage(employee.photoUrl!.trim())
                        : null,
                    child:
                        employee.photoUrl == null ||
                            employee.photoUrl!.trim().isEmpty
                        ? Text(
                            firstLetter,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          )
                        : null,
                  ),

                  SizedBox(width: headerSpacing),

                  // =================================================
                  // EMPLOYEE NAME
                  // =================================================
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employeeName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        // ===========================================
                        // EMPLOYEE CODE
                        // ===========================================
                        if (employee.employeeCode != null &&
                            employee.employeeCode!.trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              employee.employeeCode!.trim(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // =================================================
                  // ACTION MENU
                  // =================================================
                  PopupMenuButton<String>(
                    tooltip: 'Employee actions',
                    icon: const Icon(Icons.more_vert),
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
                      // =============================================
                      // VIEW
                      // =============================================
                      const PopupMenuItem<String>(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility_outlined),
                            SizedBox(width: 12),
                            Text('View'),
                          ],
                        ),
                      ),

                      // =============================================
                      // EDIT
                      // =============================================
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined),
                            SizedBox(width: 12),
                            Text('Edit'),
                          ],
                        ),
                      ),

                      // =============================================
                      // ACTIVE / INACTIVE
                      // =============================================
                      PopupMenuItem<String>(
                        value: 'status',
                        child: Row(
                          children: [
                            Icon(
                              isActive
                                  ? Icons.toggle_on_outlined
                                  : Icons.toggle_off_outlined,
                            ),
                            const SizedBox(width: 12),
                            Text(isActive ? 'Deactivate' : 'Activate'),
                          ],
                        ),
                      ),

                      // =============================================
                      // DELETE
                      // =============================================
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline),
                            SizedBox(width: 12),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // ===================================================
              // INFORMATION SECTION
              // ===================================================
              SizedBox(height: sectionSpacing),

              // ===================================================
              // MOBILE
              // ===================================================
              if (employee.mobile != null && employee.mobile!.trim().isNotEmpty)
                _InfoRow(
                  icon: Icons.phone_outlined,
                  value: employee.mobile!.trim(),
                ),

              // ===================================================
              // EMAIL
              // ===================================================
              if (employee.email != null && employee.email!.trim().isNotEmpty)
                _InfoRow(
                  icon: Icons.email_outlined,
                  value: employee.email!.trim(),
                ),

              // ===================================================
              // EMPLOYEE STATUS
              // ===================================================
              if (employee.employeeStatus != null &&
                  employee.employeeStatus!.trim().isNotEmpty)
                _InfoRow(
                  icon: Icons.badge_outlined,
                  value: employee.employeeStatus!.trim(),
                ),

              // ===================================================
              // ACTIVE / INACTIVE STATUS
              // ===================================================
              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: statusBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusBorderColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // =============================================
                      // STATUS ICON
                      // =============================================
                      Icon(statusIcon, size: 16, color: statusColor),

                      const SizedBox(width: 6),

                      // =============================================
                      // STATUS TEXT
                      // =============================================
                      Text(
                        isActive ? 'Active' : 'Inactive',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ===================================================================
// INFO ROW
// ===================================================================

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================================================
          // ICON
          // =========================================================
          Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),

          const SizedBox(width: 8),

          // =========================================================
          // VALUE
          // =========================================================
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
