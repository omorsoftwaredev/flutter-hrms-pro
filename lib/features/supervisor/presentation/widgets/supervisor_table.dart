/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Table
///
/// Version : 4.0.0
/// ===============================================================

import 'package:flutter/material.dart';

class SupervisorTable extends StatelessWidget {
  final List<Map<String, dynamic>> supervisors;

  // =============================================================
  // CALLBACKS
  // =============================================================

  final ValueChanged<Map<String, dynamic>>? onToggleStatus;
  final ValueChanged<Map<String, dynamic>>? onDelete;

  const SupervisorTable({
    super.key,
    required this.supervisors,
    this.onToggleStatus,
    this.onDelete,
  });

  // =============================================================
  // NESTED MAP
  // =============================================================

  Map<String, dynamic>? _nestedMap(
      Map<String, dynamic> data,
      String key,
      ) {
    final value = data[key];

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  // =============================================================
  // EMPLOYEE NAME
  // =============================================================

  String _employeeName(
      Map<String, dynamic> supervisor,
      ) {
    final employee = _nestedMap(
      supervisor,
      'employees',
    );

    if (employee == null) {
      return '-';
    }

    final fullName =
    employee['full_name']
        ?.toString()
        .trim();

    if (fullName != null &&
        fullName.isNotEmpty) {
      return fullName;
    }

    final firstName =
        employee['first_name']
            ?.toString()
            .trim() ??
            '';

    final lastName =
        employee['last_name']
            ?.toString()
            .trim() ??
            '';

    final name =
    '$firstName $lastName'.trim();

    return name.isEmpty ? '-' : name;
  }

  // =============================================================
  // DEPARTMENT NAME
  // =============================================================

  String _departmentName(
      Map<String, dynamic> supervisor,
      ) {
    final department = _nestedMap(
      supervisor,
      'departments',
    );

    if (department == null) {
      return '-';
    }

    final name =
    department['name']
        ?.toString()
        .trim();

    if (name == null || name.isEmpty) {
      return '-';
    }

    return name;
  }

  // =============================================================
  // STATUS
  // =============================================================

  bool _isActive(
      Map<String, dynamic> supervisor,
      ) {
    return supervisor['is_active'] == true;
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    if (supervisors.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(18),
          border: Border.all(
            color: Colors.black12,
          ),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.supervisor_account_outlined,
              size: 45,
              color: Colors.black38,
            ),
            SizedBox(height: 10),
            Text(
              'No supervisors found',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(
        bottom: 90,
      ),
      itemCount: supervisors.length,
      separatorBuilder: (
          context,
          index,
          ) =>
      const SizedBox(height: 12),
      itemBuilder: (
          context,
          index,
          ) {
        final supervisor =
        supervisors[index];

        final employeeName =
        _employeeName(
          supervisor,
        );

        final departmentName =
        _departmentName(
          supervisor,
        );

        final isActive =
        _isActive(
          supervisor,
        );

        final supervisorId =
        supervisor['id']?.toString();

        final hasId =
            supervisorId != null &&
                supervisorId.isNotEmpty;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(18),
            border: Border.all(
              color: Colors.black12,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding:
            const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                // =================================================
                // TOP
                // =================================================

                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    // AVATAR
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.green.withValues(
                          alpha: 0.10,
                        )
                            : Colors.red.withValues(
                          alpha: 0.10,
                        ),
                        borderRadius:
                        BorderRadius.circular(
                          14,
                        ),
                      ),
                      child: Icon(
                        Icons
                            .supervisor_account_outlined,
                        color: isActive
                            ? Colors.green
                            : Colors.red,
                        size: 27,
                      ),
                    ),

                    const SizedBox(width: 13),

                    // EMPLOYEE
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            employeeName,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style:
                            const TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          Row(
                            children: [
                              const Icon(
                                Icons
                                    .business_outlined,
                                size: 15,
                                color:
                                Colors.black45,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  departmentName,
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow
                                      .ellipsis,
                                  style:
                                  const TextStyle(
                                    fontSize: 13,
                                    color:
                                    Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // STATUS
                    Container(
                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration:
                      BoxDecoration(
                        color: isActive
                            ? Colors.green.withValues(
                          alpha: 0.10,
                        )
                            : Colors.red.withValues(
                          alpha: 0.10,
                        ),
                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: Row(
                        mainAxisSize:
                        MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration:
                            BoxDecoration(
                              shape:
                              BoxShape.circle,
                              color: isActive
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            isActive
                                ? 'Active'
                                : 'Inactive',
                            style: TextStyle(
                              color: isActive
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 12,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                const Divider(
                  height: 1,
                  color: Colors.black12,
                ),

                const SizedBox(height: 14),

                // =================================================
                // ACTIONS
                // =================================================

                Row(
                  children: [
                    // TOGGLE
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: hasId &&
                            onToggleStatus != null
                            ? () {
                          onToggleStatus!(
                            supervisor,
                          );
                        }
                            : null,
                        icon: Icon(
                          isActive
                              ? Icons
                              .toggle_on_outlined
                              : Icons
                              .toggle_off_outlined,
                          size: 22,
                        ),
                        label: Text(
                          isActive
                              ? 'Deactivate'
                              : 'Activate',
                        ),
                        style:
                        OutlinedButton.styleFrom(
                          foregroundColor: isActive
                              ? Colors.orange
                              : Colors.green,
                          side: BorderSide(
                            color: isActive
                                ? Colors.orange
                                : Colors.green,
                          ),
                          padding:
                          const EdgeInsets
                              .symmetric(
                            vertical: 12,
                          ),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // DELETE
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: hasId &&
                            onDelete != null
                            ? () {
                          onDelete!(
                            supervisor,
                          );
                        }
                            : null,
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 21,
                        ),
                        label: const Text(
                          'Delete',
                        ),
                        style:
                        OutlinedButton.styleFrom(
                          foregroundColor:
                          Colors.red,
                          side:
                          const BorderSide(
                            color: Colors.red,
                          ),
                          padding:
                          const EdgeInsets
                              .symmetric(
                            vertical: 12,
                          ),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}