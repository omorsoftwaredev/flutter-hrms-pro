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
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                child: Icon(Icons.apartment),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      department.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      department.code,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
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
                    child: Text('View'),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 'status',
                    child: Text(
                      department.isActive
                          ? 'Deactivate'
                          : 'Activate',
                    ),
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

          Row(
            children: [
              const Icon(Icons.description_outlined, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  department.description.isEmpty
                      ? '-'
                      : department.description,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.person_outline, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  department.managerName.isEmpty
                      ? 'No Manager'
                      : department.managerName,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.phone, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  department.phone.isEmpty
                      ? '-'
                      : department.phone,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.email_outlined, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  department.email.isEmpty
                      ? '-'
                      : department.email,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  department.location.isEmpty
                      ? '-'
                      : department.location,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerRight,
            child: Chip(
              label: Text(
                department.isActive
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