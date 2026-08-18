import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/designation_entity.dart';

class DesignationCard extends StatelessWidget {
  const DesignationCard({
    super.key,
    required this.designation,
    this.departmentName,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
    this.onView,
  });

  final DesignationEntity designation;

  final String? departmentName;

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

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double cardPadding = isDesktop
        ? 22
        : isTablet
        ? 20
        : 16;

    final double iconBoxSize = isDesktop
        ? 52
        : isTablet
        ? 50
        : 48;

    final double titleSize = isDesktop ? 19 : 18;

    final double sectionRadius = isDesktop ? 16 : 14;

    final bool isActive = designation.isActive;

    final String name = designation.name.trim().isEmpty
        ? 'Unnamed Designation'
        : designation.name.trim();


    final String salary = designation.baseSalary == 0
        ? '-'
        : designation.baseSalary.toStringAsFixed(2);

    final String description = designation.description.trim();

    final String department = departmentName?.trim().isNotEmpty == true
        ? departmentName!.trim()
        : 'Department not assigned';

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------------------------------------------
                // DESIGNATION ICON
                // ---------------------------------------------------

                Container(
                  width: iconBoxSize,
                  height: iconBoxSize,
                  decoration: BoxDecoration(
                    color: isActive
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(
                      isDesktop ? 16 : 14,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.badge_outlined,
                    size: isDesktop ? 25 : 23,
                    color: isActive
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(width: 13),

                // ---------------------------------------------------
                // DESIGNATION INFORMATION
                // ---------------------------------------------------

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // DEPARTMENT

                      Row(
                        children: [
                          Icon(
                            Icons.apartment_outlined,
                            size: 15,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              department,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
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

                // ---------------------------------------------------
                // MORE MENU
                // ---------------------------------------------------

                _buildMoreMenu(context),
              ],
            ),

            const SizedBox(height: 18),

            // =======================================================
            // DESIGNATION DETAILS
            // =======================================================

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(
                isDesktop
                    ? 14
                    : 13,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(sectionRadius),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                ),
              ),
              child: Column(
                children: [
                  // -------------------------------------------------
                  // GRADE
                  // -------------------------------------------------

                  _buildInfoRow(
                    context,
                    icon: Icons.sort_rounded,
                    title: 'Grade',
                    value: designation.grade.toString(),
                  ),

                  const SizedBox(height: 12),

                  // -------------------------------------------------
                  // BASE SALARY
                  // -------------------------------------------------

                  _buildInfoRow(
                    context,
                    icon: Icons.payments_outlined,
                    title: 'Base Salary',
                    value: salary,
                  ),
                ],
              ),
            ),

            // =======================================================
            // DESCRIPTION
            // =======================================================

            if (description.isNotEmpty) ...[
              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(
                  isDesktop ? 14 : 13,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(sectionRadius),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.description_outlined,
                        size: 18,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 14),

            // =======================================================
            // STATUS
            // =======================================================

            _buildStatusSection(
              context,
              isActive,
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // INFO ROW
  // ===============================================================

  Widget _buildInfoRow(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(11),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 18,
            color: colorScheme.onPrimaryContainer,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===============================================================
  // STATUS SECTION
  // ===============================================================

  Widget _buildStatusSection(
      BuildContext context,
      bool isActive,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final backgroundColor = isActive
        ? colorScheme.secondaryContainer
        : colorScheme.errorContainer;

    final foregroundColor = isActive
        ? colorScheme.onSecondaryContainer
        : colorScheme.onErrorContainer;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            isActive
                ? Icons.check_circle_outline_rounded
                : Icons.pause_circle_outline_rounded,
            size: 20,
            color: foregroundColor,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Designation Status',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: foregroundColor.withValues(
                      alpha: 0.75,
                    ),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  isActive
                      ? 'Active designation'
                      : 'Designation inactive',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          _buildStatusChip(
            context,
            isActive: isActive,
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // STATUS CHIP
  // ===============================================================

  Widget _buildStatusChip(
      BuildContext context, {
        required bool isActive,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final backgroundColor = isActive
        ? colorScheme.surface
        : colorScheme.surface;

    final foregroundColor = isActive
        ? colorScheme.primary
        : colorScheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(
          alpha: 0.75,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive
                ? Icons.check_rounded
                : Icons.close_rounded,
            size: 14,
            color: foregroundColor,
          ),

          const SizedBox(width: 5),

          Text(
            isActive ? 'Active' : 'Inactive',
            style: theme.textTheme.labelSmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // MORE MENU
  // ===============================================================

  Widget _buildMoreMenu(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isActive = designation.isActive;

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
              'Edit Designation',
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
              isActive
                  ? Icons.pause_circle_outline_rounded
                  : Icons.play_circle_outline_rounded,
            ),
            title: Text(
              isActive
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
              'Delete Designation',
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
}