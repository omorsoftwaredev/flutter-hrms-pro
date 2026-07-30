import 'package:flutter/material.dart';

import '../../domain/entities/attendance_entity.dart';

class ShiftInfoCard extends StatelessWidget {
  final AttendanceEntity attendance;

  const ShiftInfoCard({
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

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) {
      return "--";
    }

    return time;
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

                Icon(Icons.schedule),

                SizedBox(width: 8),

                Text(
                  "Shift Information",
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
              "Shift Name",
              attendance.shiftName ?? "--",
            ),

            _item(
              "Shift Start",
              _formatTime(attendance.shiftStart),
            ),

            _item(
              "Shift End",
              _formatTime(attendance.shiftEnd),
            ),

            _item(
              "Work Minutes",
              "${attendance.workMinutes} Minutes",
            ),

            _item(
              "Late Minutes",
              "${attendance.lateMinutes} Minutes",
            ),

            _item(
              "Overtime",
              "${attendance.overtimeMinutes} Minutes",
            ),

            _item(
              "Early Exit",
              "${attendance.earlyExitMinutes} Minutes",
            ),
          ],
        ),
      ),
    );
  }
}