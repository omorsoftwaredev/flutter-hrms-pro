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

    // =============================================================
    // ACTIVE STATUS
    // =============================================================
    //
    // কোনো একটি permission allowed থাকলে Active.
    //
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

        final bool isCompact = width < 420;

        final double cardHorizontalPadding = isCompact ? 14 : 16;

        final double avatarRadius = isCompact ? 22 : 24;

        return AppCard(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: cardHorizontalPadding,
              vertical: 4,
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
                    CircleAvatar(
                      radius: avatarRadius,
                      child: Icon(
                        Icons.security_outlined,
                        size: isCompact ? 21 : 23,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            permission.moduleName.isEmpty
                                ? '-'
                                : permission.moduleName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            data.roleName.isEmpty ? '-' : data.roleName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // =============================================
                    // MENU
                    // =============================================
                    PopupMenuButton<String>(
                      tooltip: 'More options',

                      icon: const Icon(Icons.more_vert_rounded),

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
                              Icon(Icons.visibility_outlined),
                              SizedBox(width: 10),
                              Text('View'),
                            ],
                          ),
                        ),

                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined),
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
                                Icons.delete_outline,
                                color: colorScheme.error,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Delete',
                                style: TextStyle(color: colorScheme.error),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // =================================================
                // ROLE
                // =================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.badge_outlined,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        data.roleName.isEmpty ? '-' : data.roleName,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // =================================================
                // PERMISSIONS
                // =================================================
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
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

                const SizedBox(height: 16),

                // =================================================
                // STATUS
                // =================================================
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildStatusChip(context, isActive),
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

    final Color iconColor = value ? colorScheme.primary : colorScheme.error;

    return Chip(
      avatar: Icon(
        value ? Icons.check_circle_outline : Icons.cancel_outlined,
        size: 16,
        color: iconColor,
      ),
      label: Text(
        title,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      side: BorderSide(color: colorScheme.outlineVariant),
    );
  }

  // =============================================================
  // STATUS CHIP
  // =============================================================

  Widget _buildStatusChip(BuildContext context, bool isActive) {
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // =======================================================
          // ACTIVE / INACTIVE ICON
          // =======================================================
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
            style: theme.textTheme.labelMedium?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
