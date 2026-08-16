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

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================================================
          // HEADER
          // =========================================================
          Row(
            children: [
              // -----------------------------------------------------
              // DEPARTMENT ICON
              // -----------------------------------------------------
              CircleAvatar(
                backgroundColor: isActive
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.apartment,
                  color: isActive
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(width: 12),

              // -----------------------------------------------------
              // DEPARTMENT NAME
              // -----------------------------------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      department.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // -----------------------------------------------------
              // MENU
              // -----------------------------------------------------
              PopupMenuButton<String>(
                tooltip: 'Department actions',

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
                  // ===============================================
                  // VIEW
                  // ===============================================
                  const PopupMenuItem<String>(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility_outlined),
                        SizedBox(width: 10),
                        Text('View'),
                      ],
                    ),
                  ),

                  // ===============================================
                  // EDIT
                  // ===============================================
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ],
                    ),
                  ),

                  // ===============================================
                  // STATUS
                  // ===============================================
                  PopupMenuItem<String>(
                    value: 'status',
                    child: Row(
                      children: [
                        Icon(
                          isActive ? Icons.block : Icons.check_circle_outline,
                        ),
                        const SizedBox(width: 10),
                        Text(isActive ? 'Deactivate' : 'Activate'),
                      ],
                    ),
                  ),

                  const PopupMenuDivider(),

                  // ===============================================
                  // DELETE
                  // ===============================================
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: colorScheme.error),
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

          // =========================================================
          // DESCRIPTION
          // =========================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.description_outlined,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  department.description.isEmpty ? '-' : department.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // =========================================================
          // PHONE
          // =========================================================
          Row(
            children: [
              Icon(
                Icons.phone_outlined,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  department.phone.isEmpty ? '-' : department.phone,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // =========================================================
          // EMAIL
          // =========================================================
          Row(
            children: [
              Icon(
                Icons.email_outlined,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  department.email.isEmpty ? '-' : department.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // =========================================================
          // LOCATION
          // =========================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  department.location.isEmpty ? '-' : department.location,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // =========================================================
          // STATUS
          // =========================================================
          Align(
            alignment: Alignment.centerRight,
            child: Chip(
              avatar: Icon(
                isActive ? Icons.check_circle : Icons.cancel,
                size: 18,
                color: isActive ? colorScheme.primary : colorScheme.error,
              ),
              label: Text(isActive ? 'Active' : 'Inactive'),
            ),
          ),
        ],
      ),
    );
  }
}
