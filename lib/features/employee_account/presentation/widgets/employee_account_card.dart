import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/employee_account_entity.dart';

class EmployeeAccountCard extends StatelessWidget {
  const EmployeeAccountCard({
    super.key,
    required this.account,
    this.onView,
    required this.onEdit,
    required this.onDelete,
    this.onToggleActive,
    this.onToggleCanLogin,
    this.onToggleLock,
  });

  final EmployeeAccountEntity account;

  final VoidCallback? onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  final VoidCallback? onToggleActive;
  final VoidCallback? onToggleCanLogin;
  final VoidCallback? onToggleLock;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                child: Text(
                  account.username.isEmpty
                      ? '?'
                      : account.username[0].toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.employeeName?.isNotEmpty == true
                          ? account.employeeName!
                          : 'Unknown Employee',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    const SizedBox(height: 2),

                    Text(
                      account.username,
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
                      onEdit();
                      break;

                    case 'active':
                      onToggleActive?.call();
                      break;

                    case 'login':
                      onToggleCanLogin?.call();
                      break;

                    case 'lock':
                      onToggleLock?.call();
                      break;

                    case 'delete':
                      onDelete();
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
                    value: 'active',
                    child: Text(
                      account.isActive
                          ? 'Deactivate'
                          : 'Activate',
                    ),
                  ),
                  PopupMenuItem(
                    value: 'login',
                    child: Text(
                      account.canLogin
                          ? 'Disable Login'
                          : 'Enable Login',
                    ),
                  ),
                  PopupMenuItem(
                    value: 'lock',
                    child: Text(
                      account.isLocked
                          ? 'Unlock'
                          : 'Lock',
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

          _infoRow(
            Icons.person_outline,
            '${account.employeeName ?? "Unknown"}',
          ),

          _infoRow(
            Icons.business,
            '${account.companyName ?? "Unknown Company"}',
          ),

          _infoRow(
            Icons.apartment,
            '${account.departmentName ?? "Unknown Department"}',
          ),

          _infoRow(
            Icons.account_circle_outlined,
            account.username,
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                backgroundColor: account.isActive
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                label: Text(
                  account.isActive
                      ? 'Active'
                      : 'Inactive',
                ),
              ),

              Chip(
                backgroundColor: account.canLogin
                    ? Colors.blue.shade100
                    : Colors.orange.shade100,
                label: Text(
                  account.canLogin
                      ? 'Login Enabled'
                      : 'Login Disabled',
                ),
              ),

              Chip(
                backgroundColor: account.isLocked
                    ? Colors.red.shade100
                    : Colors.green.shade100,
                label: Text(
                  account.isLocked
                      ? 'Locked'
                      : 'Unlocked',
                ),
              ),

              if (account.forceChangePassword)
                Chip(
                  backgroundColor: Colors.amber.shade100,
                  label: const Text(
                    'Change Password',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
      IconData icon,
      String text,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}