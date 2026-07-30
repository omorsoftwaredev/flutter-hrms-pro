import 'package:flutter/material.dart';

import '../../domain/entities/attendance_entity.dart';

class CompanyInfoCard extends StatelessWidget {
  final AttendanceEntity attendance;

  const CompanyInfoCard({
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
            width: 130,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const Text(": "),

          Expanded(
            child: Text(value),
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

                Icon(Icons.business),

                SizedBox(width: 8),

                Text(
                  "Organization Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            _item(
              "Company ID",
              attendance.companyId ?? "--",
            ),

            _item(
              "Department ID",
              attendance.departmentId ?? "--",
            ),

            _item(
              "Designation ID",
              attendance.designationId ?? "--",
            ),

            _item(
              "Shift ID",
              attendance.shiftId ?? "--",
            ),

            _item(
              "Employee ID",
              attendance.employeeId ?? "--",
            ),
          ],
        ),
      ),
    );
  }
}