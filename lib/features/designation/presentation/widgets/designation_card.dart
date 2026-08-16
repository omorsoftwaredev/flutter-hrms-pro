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

    final bool isActive = designation.isActive;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================================================
          // HEADER
          // =========================================================
          Row(
            children: [
              CircleAvatar(
                backgroundColor: isActive
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.badge_outlined,
                  color: isActive
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      designation.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // =====================================================
              // MENU
              // =====================================================
              PopupMenuButton<String>(
                tooltip: 'More options',
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
                    value: 'status',
                    child: Row(
                      children: [
                        Icon(
                          isActive
                              ? Icons.block
                              : Icons.check_circle_outline,
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

          const SizedBox(height: 16),

          // =========================================================
          // GRADE
          // =========================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.sort,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  'Grade : ${designation.grade}',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // =========================================================
          // BASE SALARY
          // =========================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.payments_outlined,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  designation.baseSalary == 0
                      ? '-'
                      : designation.baseSalary.toStringAsFixed(2),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),

          // =========================================================
          // DESCRIPTION
          // =========================================================
          if (designation.description.isNotEmpty) ...[
            const SizedBox(height: 12),

            Text(
              designation.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],

          const SizedBox(height: 16),

          // =========================================================
          // STATUS
          // =========================================================
          Align(
            alignment: Alignment.centerRight,
            child: Chip(
              avatar: Icon(
                isActive
                    ? Icons.check_circle
                    : Icons.cancel,
                size: 18,
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.error,
              ),
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
}