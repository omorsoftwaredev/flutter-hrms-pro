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
                radius: 26,
                backgroundImage:
                employee.photoUrl != null &&
                    employee.photoUrl!.isNotEmpty
                    ? NetworkImage(employee.photoUrl!)
                    : null,
                child:
                employee.photoUrl == null ||
                    employee.photoUrl!.isEmpty
                    ? Text(
                  employee.fullName.isEmpty
                      ? '?'
                      : employee.fullName[0].toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
                    : null,
              ),

              const SizedBox(width: 12),

              // =====================================================
              // NAME
              // =====================================================

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),

              // =====================================================
              // MENU
              // =====================================================

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
                      employee.isActive
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

          // =========================================================
          // MOBILE
          // =========================================================

          if (employee.mobile != null &&
              employee.mobile!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.phone,
                    size: 18,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      employee.mobile!,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

          // =========================================================
          // EMAIL
          // =========================================================

          if (employee.email != null &&
              employee.email!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.email_outlined,
                    size: 18,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      employee.email!,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

          // =========================================================
          // EMPLOYEE STATUS
          // =========================================================

          if (employee.employeeStatus != null &&
              employee.employeeStatus!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.badge_outlined,
                    size: 18,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      employee.employeeStatus!,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

          // =========================================================
          // ACTIVE / INACTIVE
          // =========================================================

          Align(
            alignment: Alignment.centerRight,
            child: Chip(
              backgroundColor: employee.isActive
                  ? Colors.green.shade100
                  : Colors.red.shade100,
              label: Text(
                employee.isActive
                    ? 'Active'
                    : 'Inactive',
                style: TextStyle(
                  color: employee.isActive
                      ? Colors.green.shade900
                      : Colors.red.shade900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}