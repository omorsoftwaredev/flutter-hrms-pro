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

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =======================================================
          // HEADER
          // =======================================================

          Row(
            children: [
              const CircleAvatar(
                child: Icon(
                  Icons.security,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      permission.moduleName,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      data.roleName,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),
                  ],
                ),
              ),

              // ===================================================
              // MENU
              // ===================================================

              PopupMenuButton<String>(
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
                    child: Text('View'),
                  ),

                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),

                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // =======================================================
          // COMPANY
          // =======================================================

          Row(
            children: [
              const Icon(
                Icons.business,
                size: 18,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  data.companyName.isEmpty
                      ? '-'
                      : data.companyName,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // =======================================================
          // ROLE
          // =======================================================

          Row(
            children: [
              const Icon(
                Icons.badge_outlined,
                size: 18,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  data.roleName.isEmpty
                      ? '-'
                      : data.roleName,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // =======================================================
          // PERMISSIONS
          // =======================================================

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _permissionChip(
                'View',
                permission.canView,
              ),

              _permissionChip(
                'Create',
                permission.canCreate,
              ),

              _permissionChip(
                'Update',
                permission.canUpdate,
              ),

              _permissionChip(
                'Delete',
                permission.canDelete,
              ),

              _permissionChip(
                'Export',
                permission.canExport,
              ),

              _permissionChip(
                'Approve',
                permission.canApprove,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // =======================================================
          // STATUS
          // =======================================================

          Align(
            alignment: Alignment.centerRight,
            child: Chip(
              label: Text(
                isActive
                    ? 'Active'
                    : 'Inactive',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // PERMISSION CHIP
  // =============================================================

  Widget _permissionChip(
      String title,
      bool value,
      ) {
    return Chip(
      label: Text(title),
      avatar: Icon(
        value
            ? Icons.check_circle
            : Icons.cancel,
        size: 16,
        color: value
            ? Colors.green
            : Colors.red,
      ),
    );
  }
}