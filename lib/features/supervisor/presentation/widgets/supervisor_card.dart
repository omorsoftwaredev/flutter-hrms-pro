/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Card
///
/// Version : 3.0.0
///
/// Features:
/// - Theme aware
/// - Responsive layout
/// - Dark mode support
/// - Modern HRMS UI
/// - Existing callbacks preserved
/// ===============================================================

import 'package:flutter/material.dart';

class SupervisorCard extends StatelessWidget {
  final Map<String, dynamic> supervisor;

  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const SupervisorCard({
    super.key,
    required this.supervisor,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  // =============================================================
  // VALUE
  // =============================================================

  String _value(String key) {
    final value = supervisor[key];

    if (value == null) {
      return '-';
    }

    final text = value.toString().trim();

    return text.isEmpty ? '-' : text;
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final name = _value('employee_name');
    final employeeCode = _value('employee_code');
    final status = _value('status');

    final isActive = status.toLowerCase() == 'active' || status == '-';

    final statusColor = isActive ? colorScheme.primary : colorScheme.error;

    final statusBackground = statusColor.withValues(alpha: 0.10);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.18)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 420;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // HEADER
                  // =================================================
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // =============================================
                      // AVATAR
                      // =============================================
                      Container(
                        width: isCompact ? 46 : 52,
                        height: isCompact ? 46 : 52,
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.supervisor_account_outlined,
                          color: colorScheme.primary,
                          size: isCompact ? 24 : 27,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // =============================================
                      // EMPLOYEE INFO
                      // =============================================
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Row(
                              children: [
                                Icon(
                                  Icons.badge_outlined,
                                  size: 15,
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.55,
                                  ),
                                ),

                                const SizedBox(width: 5),

                                Expanded(
                                  child: Text(
                                    employeeCode == '-'
                                        ? 'Employee Code: -'
                                        : 'Employee Code: '
                                              '$employeeCode',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.60),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // =============================================
                      // MENU
                      // =============================================
                      PopupMenuButton<String>(
                        tooltip: 'More options',
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
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(Icons.edit_outlined),
                                title: Text('Edit'),
                              ),
                            ),

                            PopupMenuItem<String>(
                              value: 'delete',
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(
                                  Icons.delete_outline,
                                  color: colorScheme.error,
                                ),
                                title: Text(
                                  'Delete',
                                  style: TextStyle(color: colorScheme.error),
                                ),
                              ),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // =================================================
                  // STATUS
                  // =================================================
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: statusColor,
                              ),
                            ),

                            const SizedBox(width: 6),

                            Text(
                              isActive ? 'Active' : status,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Optional supervisor indicator
                      Icon(
                        Icons.supervisor_account_outlined,
                        size: 18,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.35,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // =================================================
                  // DIVIDER
                  // =================================================
                  Divider(
                    height: 1,
                    color: colorScheme.outline.withValues(alpha: 0.15),
                  ),

                  const SizedBox(height: 14),

                  // =================================================
                  // ACTIONS
                  // =================================================
                  if (isCompact)
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit_outlined, size: 19),
                            label: const Text('Edit Supervisor'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: onDelete,
                            icon: Icon(
                              Icons.delete_outline,
                              size: 19,
                              color: colorScheme.error,
                            ),
                            label: Text(
                              'Delete',
                              style: TextStyle(color: colorScheme.error),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorScheme.error,
                              side: BorderSide(
                                color: colorScheme.error.withValues(alpha: 0.5),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit_outlined, size: 19),
                            label: const Text('Edit Supervisor'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onDelete,
                            icon: Icon(
                              Icons.delete_outline,
                              size: 19,
                              color: colorScheme.error,
                            ),
                            label: Text(
                              'Delete',
                              style: TextStyle(color: colorScheme.error),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorScheme.error,
                              side: BorderSide(
                                color: colorScheme.error.withValues(alpha: 0.5),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
