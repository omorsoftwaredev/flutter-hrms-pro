/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Assignment Table
///
/// Version : 2.0.0
/// ===============================================================

import 'package:flutter/material.dart';

class SupervisorAssignmentTable
    extends StatelessWidget {
  final List<Map<String, dynamic>> assignments;
  final List<Map<String, dynamic>> unassignedDepartments;

  final ValueChanged<Map<String, dynamic>>?
  onUnassign;

  final ValueChanged<Map<String, dynamic>>?
  onAssign;

  const SupervisorAssignmentTable({
    super.key,
    required this.assignments,
    this.unassignedDepartments = const [],
    this.onUnassign,
    this.onAssign,
  });

  String _value(
      Map<String, dynamic> data,
      String key,
      ) {
    final value = data[key];

    if (value == null) {
      return '-';
    }

    final text = value.toString().trim();

    return text.isEmpty ? '-' : text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        // =====================================================
        // ASSIGNED
        // =====================================================

        const Text(
          'Assigned Departments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        _buildAssignedTable(),

        const SizedBox(height: 28),

        // =====================================================
        // UNASSIGNED
        // =====================================================

        const Text(
          'Unassigned Departments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        _buildUnassignedList(),
      ],
    );
  }

  Widget _buildAssignedTable() {
    if (assignments.isEmpty) {
      return _emptyCard(
        'No department assignment found',
      );
    }

    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(
              label: Text('Supervisor'),
            ),
            DataColumn(
              label: Text('Department'),
            ),
            DataColumn(
              label: Text('Status'),
            ),
            DataColumn(
              label: Text('Action'),
            ),
          ],
          rows: assignments.map(
                (assignment) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      _value(
                        assignment,
                        'supervisor_name',
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      _value(
                        assignment,
                        'department_name',
                      ),
                    ),
                  ),
                  const DataCell(
                    Text(
                      'Assigned',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                  DataCell(
                    IconButton(
                      tooltip: 'Unassign',
                      icon: const Icon(
                        Icons.link_off_outlined,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        onUnassign?.call(
                          assignment,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  Widget _buildUnassignedList() {
    if (unassignedDepartments.isEmpty) {
      return _emptyCard(
        'All departments are assigned',
      );
    }

    return Column(
      children: unassignedDepartments.map(
            (department) {
          final name = _value(
            department,
            'name',
          );

          return Card(
            margin:
            const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(
                  Icons.apartment_outlined,
                ),
              ),
              title: Text(name),
              subtitle: const Text(
                'No supervisor assigned',
              ),
              trailing: ElevatedButton.icon(
                onPressed: () {
                  onAssign?.call(
                    department,
                  );
                },
                icon: const Icon(
                  Icons.link,
                  size: 18,
                ),
                label: const Text('Assign'),
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _emptyCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: Colors.black12,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}