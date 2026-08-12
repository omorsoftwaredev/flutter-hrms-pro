import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/role_entity.dart';

class RoleCard extends StatelessWidget {
  const RoleCard({
    super.key,
    required this.role,
    this.companyName,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
  });

  final RoleEntity role;

  final String? companyName;

  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleStatus;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // =====================================================
          // HEADER
          // =====================================================

          Row(
            children: [
              const CircleAvatar(
                child: Icon(
                  Icons.admin_panel_settings,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      role.roleName,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
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
                      role.isActive
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

          const SizedBox(
            height: 16,
          ),

          // =====================================================
          // COMPANY
          // =====================================================

          Row(
            children: [
              const Icon(
                Icons.business,
                size: 18,
              ),

              const SizedBox(
                width: 8,
              ),

              Expanded(
                child: Text(
                  companyName ?? '-',
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          // =====================================================
          // DESCRIPTION
          // =====================================================

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.description_outlined,
                size: 18,
              ),

              const SizedBox(
                width: 8,
              ),

              Expanded(
                child: Text(
                  role.description.isEmpty
                      ? '-'
                      : role.description,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 16,
          ),

          // =====================================================
          // STATUS
          // =====================================================

          Align(
            alignment:
            Alignment.centerRight,
            child: Chip(
              label: Text(
                role.isActive
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