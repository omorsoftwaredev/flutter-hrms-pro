/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Card
///
/// Version : 2.0.0
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

  String _value(String key) {
    final value = supervisor[key];
    if (value == null) return '-';

    final text = value.toString().trim();
    return text.isEmpty ? '-' : text;
  }

  @override
  Widget build(BuildContext context) {
    final name = _value('employee_name');
    final employeeCode = _value('employee_code');
    final status = _value('status');

    final isActive =
        status.toLowerCase() == 'active' ||
            status == '-';

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: Colors.black12,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF673AB7)
                      .withOpacity(.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.supervisor_account_outlined,
                  color: Color(0xFF673AB7),
                  size: 27,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Employee Code: $employeeCode',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.green.withOpacity(.08)
                            : Colors.red.withOpacity(.08),
                        borderRadius:
                        BorderRadius.circular(20),
                      ),
                      child: Text(
                        isActive ? 'Active' : status,
                        style: TextStyle(
                          color: isActive
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit?.call();
                  }

                  if (value == 'delete') {
                    onDelete?.call();
                  }
                },
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}