import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/department_entity.dart';

class DepartmentCard extends StatelessWidget {
  const DepartmentCard({
    super.key,
    required this.department,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
  });

  final DepartmentEntity department;

  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isActive = department.isActive;

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

    final double titleSize = isDesktop
        ? 19
        : 18;

    final double headerIconSize = isDesktop
        ? 22
        : 21;

    final double infoIconSize = isDesktop
        ? 19
        : 18;

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
                // DEPARTMENT ICON
                // ---------------------------------------------------

                Container(
                  width: isDesktop ? 46 : 44,
                  height: isDesktop ? 46 : 44,
                  decoration: BoxDecoration(
                    color: isActive
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.apartment_outlined,
                    size: headerIconSize,
                    color: isActive
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(width: 12),

                // ---------------------------------------------------
                // DEPARTMENT NAME
                // ---------------------------------------------------

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        department.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Department',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // ---------------------------------------------------
                // MENU
                // ---------------------------------------------------

                PopupMenuButton<String>(
                  tooltip: 'Department actions',

                  icon: const Icon(
                    Icons.more_vert_rounded,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
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
                    // =============================================
                    // VIEW
                    // =============================================

                    const PopupMenuItem<String>(
                      value: 'view',
                      child: Row(
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                          ),
                          SizedBox(width: 10),
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
                          Icon(
                            Icons.edit_outlined,
                          ),
                          SizedBox(width: 10),
                          Text('Edit'),
                        ],
                      ),
                    ),

                    // =============================================
                    // STATUS
                    // =============================================

                    PopupMenuItem<String>(
                      value: 'status',
                      child: Row(
                        children: [
                          Icon(
                            isActive
                                ? Icons.pause_circle_outline_rounded
                                : Icons.check_circle_outline_rounded,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            isActive
                                ? 'Deactivate'
                                : 'Activate',
                          ),
                        ],
                      ),
                    ),

                    const PopupMenuDivider(),

                    // =============================================
                    // DELETE
                    // =============================================

                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            color: colorScheme.error,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Delete',
                            style: TextStyle(
                              color: colorScheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            Divider(
              height: 1,
              color: colorScheme.outlineVariant,
            ),

            const SizedBox(height: 14),

            // =======================================================
            // DESCRIPTION
            // =======================================================

            _infoRow(
              context,
              icon: Icons.description_outlined,
              value: department.description.isEmpty
                  ? '-'
                  : department.description,
              maxLines: 3,
            ),

            const SizedBox(height: 10),

            // =======================================================
            // PHONE
            // =======================================================

            _infoRow(
              context,
              icon: Icons.phone_outlined,
              value: department.phone.isEmpty
                  ? '-'
                  : department.phone,
              maxLines: 1,
            ),

            const SizedBox(height: 10),

            // =======================================================
            // EMAIL
            // =======================================================

            _infoRow(
              context,
              icon: Icons.email_outlined,
              value: department.email.isEmpty
                  ? '-'
                  : department.email,
              maxLines: 1,
            ),

            const SizedBox(height: 10),

            // =======================================================
            // LOCATION
            // =======================================================

            _infoRow(
              context,
              icon: Icons.location_on_outlined,
              value: department.location.isEmpty
                  ? '-'
                  : department.location,
              maxLines: 2,
            ),

            const SizedBox(height: 16),

            // =======================================================
            // STATUS
            // =======================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? colorScheme.secondaryContainer
                    : colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: isActive
                      ? colorScheme.onSecondaryContainer
                      .withValues(alpha: 0.10)
                      : colorScheme.onErrorContainer
                      .withValues(alpha: 0.10),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isActive
                          ? colorScheme.onSecondaryContainer
                          .withValues(alpha: 0.10)
                          : colorScheme.onErrorContainer
                          .withValues(alpha: 0.10),
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      isActive
                          ? Icons.check_circle_outline_rounded
                          : Icons.cancel_outlined,
                      size: 19,
                      color: isActive
                          ? colorScheme.onSecondaryContainer
                          : colorScheme.onErrorContainer,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Department Status',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isActive
                                ? colorScheme
                                .onSecondaryContainer
                                .withValues(alpha: 0.75)
                                : colorScheme
                                .onErrorContainer
                                .withValues(alpha: 0.75),
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          isActive
                              ? 'Active department'
                              : 'Department inactive',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isActive
                                ? colorScheme.onSecondaryContainer
                                : colorScheme.onErrorContainer,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // -------------------------------------------------
                  // STATUS LABEL
                  // -------------------------------------------------

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? colorScheme.onSecondaryContainer
                          .withValues(alpha: 0.10)
                          : colorScheme.onErrorContainer
                          .withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      isActive
                          ? 'Active'
                          : 'Inactive',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isActive
                            ? colorScheme.onSecondaryContainer
                            : colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // INFO ROW
  // ===============================================================

  Widget _infoRow(
      BuildContext context, {
        required IconData icon,
        required String value,
        required int maxLines,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;

    final double iconSize = isDesktop ? 19 : 18;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: iconSize,
            color: colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 7,
            ),
            child: Text(
              value,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}