import 'package:flutter/material.dart';

import '../../domain/entities/attendance_entity.dart';

class EmployeeInfoCard extends StatelessWidget {
  final AttendanceEntity attendance;

  const EmployeeInfoCard({
    super.key,
    required this.attendance,
  });

  Widget _item(
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [

          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const Text(": "),

          Expanded(
            child: Text(
              value,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Card(

      child: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Row(

              children: [

                Icon(Icons.person),

                SizedBox(width: 8),

                Text(
                  "Employee Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            _item(
              "Employee ID",
              attendance.employeeId ?? "--",
            ),

            _item(
              "Department",
              attendance.departmentId ?? "--",
            ),

            _item(
              "Designation",
              attendance.designationId ?? "--",
            ),

            _item(
              "Shift",
              attendance.shiftName ?? "--",
            ),

            _item(
              "Attendance No",
              attendance.attendanceNo,
            ),
          ],
        ),
      ),
    );
  }
}