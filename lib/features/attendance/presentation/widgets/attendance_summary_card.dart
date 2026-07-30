import 'package:flutter/material.dart';

import '../../domain/entities/attendance_entity.dart';
import 'attendance_status_chip.dart';

class AttendanceSummaryCard extends StatelessWidget {
  final AttendanceEntity attendance;

  const AttendanceSummaryCard({
    super.key,
    required this.attendance,
  });

  Widget _item(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
      }) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _hours(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;

    return "${h}h ${m}m";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Row(
              children: [

                const Text(
                  "Attendance Summary",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                AttendanceStatusChip(
                  status: attendance.attendanceStatus,
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [

                _item(
                  context,
                  icon: Icons.schedule,
                  title: "Work",
                  value: _hours(
                    attendance.workMinutes,
                  ),
                ),

                _item(
                  context,
                  icon: Icons.timer,
                  title: "Late",
                  value:
                  "${attendance.lateMinutes}m",
                ),

                _item(
                  context,
                  icon: Icons.trending_up,
                  title: "OT",
                  value:
                  "${attendance.overtimeMinutes}m",
                ),

                _item(
                  context,
                  icon: Icons.logout,
                  title: "Early Exit",
                  value:
                  "${attendance.earlyExitMinutes}m",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}