import 'package:flutter/material.dart';

import '../../domain/entities/employee_entity.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onEdit,
    required this.onDelete,
  });

  final EmployeeEntity employee;

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage:
                employee.photoUrl != null &&
                    employee.photoUrl!.isNotEmpty
                    ? NetworkImage(
                  employee.photoUrl!,
                )
                    : null,
                child:
                employee.photoUrl == null ||
                    employee.photoUrl!.isEmpty
                    ? Text(
                  employee.fullName
                      .substring(0, 1)
                      .toUpperCase(),
                  style:
                  const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 20,
                  ),
                )
                    : null,
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.fullName,
                      style:
                      const TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      employee.employeeCode,
                      style:
                      TextStyle(
                        color: Colors
                            .grey.shade700,
                      ),
                    ),

                    if (employee.mobile !=
                        null &&
                        employee.mobile!
                            .isNotEmpty)
                      Padding(
                        padding:
                        const EdgeInsets.only(
                          top: 4,
                        ),
                        child: Text(
                          employee.mobile!,
                        ),
                      ),

                    if (employee.email !=
                        null &&
                        employee.email!
                            .isNotEmpty)
                      Padding(
                        padding:
                        const EdgeInsets.only(
                          top: 2,
                        ),
                        child: Text(
                          employee.email!,
                          overflow:
                          TextOverflow
                              .ellipsis,
                        ),
                      ),

                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (employee.employeeStatus !=
                            null &&
                            employee
                                .employeeStatus!
                                .isNotEmpty)
                          Chip(
                            label: Text(
                              employee
                                  .employeeStatus!,
                            ),
                          ),

                        Chip(
                          label: Text(
                            employee.isActive
                                ? 'Active'
                                : 'Inactive',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  }

                  if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading:
                      Icon(Icons.edit),
                      title: Text('Edit'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading:
                      Icon(Icons.delete),
                      title: Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}