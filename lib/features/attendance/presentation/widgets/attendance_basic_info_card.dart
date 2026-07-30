import 'package:flutter/material.dart';

import '../../domain/entities/attendance_entity.dart';
import 'attendance_status_chip.dart';

class AttendanceBasicInfoCard extends StatelessWidget {
  final AttendanceEntity attendance;

  const AttendanceBasicInfoCard({
    super.key,
    required this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _row(
              "Attendance No",
              attendance.attendanceNo,
            ),

            _divider(),

            _row(
              "Date",
              attendance.attendanceDate
                  .toString()
                  .split(" ")
                  .first,
            ),

            _divider(),

            _row(
              "Shift",
              attendance.shiftName ?? "--",
            ),

            _divider(),

            _row(
              "Check In",
              attendance.checkInTime == null
                  ? "--"
                  : attendance.checkInTime.toString(),
            ),

            _divider(),

            _row(
              "Check Out",
              attendance.checkOutTime == null
                  ? "--"
                  : attendance.checkOutTime.toString(),
            ),

            _divider(),

            Row(
              children: [
                const Text(
                  "Status",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                AttendanceStatusChip(
                  status: attendance.attendanceStatus,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => const Divider(height: 22);

  Widget _row(String title, String value) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            value,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}