import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/designation_entity.dart';

class DesignationCard extends StatelessWidget {
  const DesignationCard({
    super.key,
    required this.designation,
    this.companyName,
    this.departmentName,
    this.onEdit,
    this.onDelete,
  });

  final DesignationEntity designation;

  final String? companyName;
  final String? departmentName;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                child: Icon(
                  Icons.badge_outlined,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      designation.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),

                    const SizedBox(height: 2),

                    Text(
                      designation.code,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit?.call();
                      break;

                    case 'delete':
                      onDelete?.call();
                      break;
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem(
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
              const Icon(
                Icons.business,
                size: 18,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  companyName ?? '-',
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),


          Row(
            children: [
              const Icon(
                Icons.sort,
                size: 18,
              ),

              const SizedBox(width: 8),

              Text(
                'Grade : ${designation.grade}',
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.payments_outlined,
                size: 18,
              ),

              const SizedBox(width: 8),

              Text(
                designation.baseSalary == 0
                    ? '-'
                    : designation.baseSalary
                    .toStringAsFixed(2),
              ),
            ],
          ),

          if (designation.description
              .isNotEmpty) ...[
            const SizedBox(height: 12),

            Text(
              designation.description,
            ),
          ],

          const SizedBox(height: 16),

          Align(
            alignment:
            Alignment.centerRight,
            child: Chip(
              label: Text(
                designation.isActive
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