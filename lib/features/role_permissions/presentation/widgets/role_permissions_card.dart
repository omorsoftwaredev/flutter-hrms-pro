import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/role_permissions_view_entity.dart';

class RolePermissionsCard extends StatelessWidget {
  const RolePermissionsCard({
    super.key,
    required this.data,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
  });

  final RolePermissionsViewEntity data;

  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleStatus;

  @override
  Widget build(BuildContext context) {
    final permission = data.permission;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // =============================================================
    // ACTIVE STATUS
    // =============================================================

    final isActive =
        permission.canView ||
            permission.canCreate ||
            permission.canUpdate ||
            permission.canDelete ||
            permission.canExport ||
            permission.canApprove;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final bool isSmall = width < 360;
        final bool isCompact = width < 480;
        final bool isWide = width >= 700;

        final double horizontalPadding = isSmall
            ? 12
            : isCompact
            ? 14
            : isWide
            ? 20
            : 16;

        final double verticalPadding = isSmall
            ? 14
            : isWide
            ? 18
            : 16;

        final double avatarRadius = isSmall
            ? 21
            : isCompact
            ? 23
            : 25;

        return AppCard(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =================================================
                // HEADER
                // =================================================

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withValues(
                          alpha: 0.10,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: avatarRadius,
                        backgroundColor:
                        colorScheme.primaryContainer,
                        foregroundColor:
                        colorScheme.onPrimaryContainer,
                        child: Icon(
                          Icons.security_outlined,
                          size: isSmall
                              ? 20
                              : isCompact
                              ? 22
                              : 24,
                        ),
                      ),
                    ),

                    SizedBox(
                      width: isSmall ? 10 : 12,
                    ),

                    // =================================================
                    // MODULE + ROLE
                    // =================================================

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            permission.moduleName.isEmpty
                                ? '-'
                                : permission.moduleName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.1,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Row(
                            children: [
                              Icon(
                                Icons.badge_outlined,
                                size: 14,
                                color:
                                colorScheme.onSurfaceVariant,
                              ),

                              const SizedBox(width: 5),

                              Expanded(
                                child: Text(
                                  data.roleName.isEmpty
                                      ? '-'
                                      : data.roleName,
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style:
                                  textTheme.bodySmall?.copyWith(
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

                    const SizedBox(width: 4),

                    // =================================================
                    // MENU
                    // =================================================

                    PopupMenuButton<String>(
                      tooltip: 'More options',

                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: colorScheme.onSurfaceVariant,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(14),
                      ),

                      onSelected: (value) {
                        switch (value) {
                          case 'view':
                            onView?.call();
                            break;

                          case 'edit':
                            onEdit?.call();
                            break;

                          case 'delete':
                            onDelete?.call();
                            break;
                        }
                      },

                      itemBuilder: (_) => [
                        const PopupMenuItem(
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

                        const PopupMenuItem(
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

                        PopupMenuItem(
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(
                  height: isSmall ? 14 : 18,
                ),

                // =================================================
                // DIVIDER
                // =================================================

                Divider(
                  height: 1,
                  color: colorScheme.outlineVariant
                      .withValues(alpha: 0.55),
                ),

                SizedBox(
                  height: isSmall ? 14 : 16,
                ),

                // =================================================
                // ROLE INFORMATION
                // =================================================

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmall ? 10 : 12,
                    vertical: isSmall ? 9 : 10,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.40),
                    borderRadius:
                    BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.outlineVariant
                          .withValues(alpha: 0.45),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color:
                          colorScheme.primaryContainer,
                          borderRadius:
                          BorderRadius.circular(9),
                        ),
                        child: Icon(
                          Icons.badge_outlined,
                          size: 18,
                          color:
                          colorScheme.onPrimaryContainer,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Role',
                              style:
                              textTheme.labelSmall?.copyWith(
                                color: colorScheme
                                    .onSurfaceVariant,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 2),

                            Text(
                              data.roleName.isEmpty
                                  ? '-'
                                  : data.roleName,
                              maxLines: 2,
                              overflow:
                              TextOverflow.ellipsis,
                              style:
                              textTheme.bodyMedium?.copyWith(
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: isSmall ? 14 : 18,
                ),

                // =================================================
                // PERMISSIONS TITLE
                // =================================================

                Row(
                  children: [
                    Icon(
                      Icons.security_outlined,
                      size: 18,
                      color: colorScheme.primary,
                    ),

                    const SizedBox(width: 7),

                    Text(
                      'Permissions',
                      style:
                      textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // =================================================
                // PERMISSIONS
                // =================================================

                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    _permissionChip(
                      context,
                      title: 'View',
                      value: permission.canView,
                    ),

                    _permissionChip(
                      context,
                      title: 'Create',
                      value: permission.canCreate,
                    ),

                    _permissionChip(
                      context,
                      title: 'Update',
                      value: permission.canUpdate,
                    ),

                    _permissionChip(
                      context,
                      title: 'Delete',
                      value: permission.canDelete,
                    ),

                    _permissionChip(
                      context,
                      title: 'Export',
                      value: permission.canExport,
                    ),

                    _permissionChip(
                      context,
                      title: 'Approve',
                      value: permission.canApprove,
                    ),
                  ],
                ),

                SizedBox(
                  height: isSmall ? 14 : 18,
                ),

                // =================================================
                // STATUS
                // =================================================

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Permission Status',
                        style:
                        textTheme.labelMedium?.copyWith(
                          color:
                          colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    _buildStatusChip(
                      context,
                      isActive,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =============================================================
  // PERMISSION CHIP
  // =============================================================

  Widget _permissionChip(
      BuildContext context, {
        required String title,
        required bool value,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color color = value
        ? colorScheme.primary
        : colorScheme.error;

    final Color backgroundColor = value
        ? colorScheme.primaryContainer
        .withValues(alpha: 0.55)
        : colorScheme.errorContainer
        .withValues(alpha: 0.45);

    final Color foregroundColor = value
        ? colorScheme.onPrimaryContainer
        : colorScheme.onErrorContainer;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            value
                ? Icons.check_circle_outline_rounded
                : Icons.cancel_outlined,
            size: 16,
            color: color,
          ),

          const SizedBox(width: 6),

          Text(
            title,
            style:
            theme.textTheme.labelMedium?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
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
      BuildContext context,
      bool isActive,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color statusColor = isActive
        ? colorScheme.primary
        : colorScheme.error;

    final Color backgroundColor = isActive
        ? colorScheme.primaryContainer
        : colorScheme.errorContainer;

    final Color foregroundColor = isActive
        ? colorScheme.onPrimaryContainer
        : colorScheme.onErrorContainer;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive
                ? Icons.check_circle_outline_rounded
                : Icons.cancel_outlined,
            size: 17,
            color: statusColor,
          ),

          const SizedBox(width: 6),

          Text(
            isActive ? 'Active' : 'Inactive',
            style:
            theme.textTheme.labelMedium?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}