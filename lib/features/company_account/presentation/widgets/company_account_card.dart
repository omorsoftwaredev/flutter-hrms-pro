// ===============================================================
// Flutter HRMS Pro
// Company Account Card
//
// Version : 2.0.0
// ===============================================================

import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/company_account_entity.dart';

class CompanyAccountCard extends StatelessWidget {
  const CompanyAccountCard({
    super.key,
    required this.account,
    this.onView,
    this.onEdit,
    this.onToggleStatus,
    this.onDelete,
  });

  final CompanyAccountEntity account;

  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onToggleStatus;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                child: Text(
                  account.username.isEmpty
                      ? '?'
                      : account.username[0].toUpperCase(),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.username,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                    Text(
                      'Company Login Account',
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
                      account.isActive
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
              const Icon(Icons.business_outlined, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  account.companyName ?? '-',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(account.username),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.business_outlined, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(account.companyId),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.lock_outline, size: 18),
              const SizedBox(width: 8),
              Text(
                account.mustChangePassword
                    ? 'Password Change Required'
                    : 'Password OK',
              ),
            ],
          ),

          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerRight,
            child: Chip(
              label: Text(
                account.isActive
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