import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/company_entity.dart';

class CompanyCard extends StatelessWidget {
  const CompanyCard({
    super.key,
    required this.company,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
  });

  final CompanyEntity company;

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
              CircleAvatar(
                backgroundColor: company.isActive
                    ? Colors.green.shade100
                    : Colors.grey.shade300,
                child: Icon(
                  Icons.business,
                  color: company.isActive
                      ? Colors.green
                      : Colors.grey,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      company.code,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
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
                          company.isActive
                              ? Icons.block
                              : Icons.check_circle_outline,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          company.isActive
                              ? 'Deactivate'
                              : 'Activate',
                        ),
                      ],
                    ),
                  ),

                  const PopupMenuDivider(),

                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.red,
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

          Row(
            children: [
              const Icon(
                Icons.email_outlined,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(company.email),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(company.phone),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(company.address),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerRight,
            child: Chip(
              avatar: Icon(
                company.isActive
                    ? Icons.check_circle
                    : Icons.cancel,
                size: 18,
                color: company.isActive
                    ? Colors.green
                    : Colors.red,
              ),
              label: Text(
                company.isActive
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