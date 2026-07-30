import 'package:flutter/material.dart';

import '../../domain/entities/attendance_entity.dart';

class EmployeeAvatarCard extends StatelessWidget {
  final AttendanceEntity attendance;

  const EmployeeAvatarCard({
    super.key,
    required this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            CircleAvatar(
              radius: 42,
              child: Text(
                attendance.attendanceNo.isNotEmpty
                    ? attendance.attendanceNo[0]
                    : "?",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              attendance.attendanceNo,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              attendance.employeeId ?? "--",
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [

                Chip(
                  avatar: const Icon(
                    Icons.badge,
                    size: 18,
                  ),
                  label: Text(
                    attendance.attendanceStatus,
                  ),
                ),

                Chip(
                  avatar: const Icon(
                    Icons.calendar_today,
                    size: 18,
                  ),
                  label: Text(
                    attendance.attendanceDate
                        .toString()
                        .split(' ')
                        .first,
                  ),
                ),

                if (attendance.shiftName != null)
                  Chip(
                    avatar: const Icon(
                      Icons.access_time,
                      size: 18,
                    ),
                    label: Text(
                      attendance.shiftName!,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}