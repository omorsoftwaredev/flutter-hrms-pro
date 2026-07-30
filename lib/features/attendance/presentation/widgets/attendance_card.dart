import 'package:flutter/material.dart';

import '../../domain/entities/attendance_entity.dart';
import 'attendance_status_chip.dart';

class AttendanceCard extends StatelessWidget {
  final AttendanceEntity attendance;

  final VoidCallback? onTap;

  final VoidCallback? onEdit;

  final VoidCallback? onDelete;

  const AttendanceCard({
    super.key,
    required this.attendance,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: InkWell(
        onTap: onTap,

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      attendance.attendanceNo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),

                  AttendanceStatusChip(
                    status:
                    attendance.attendanceStatus,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                attendance.shiftName ?? '',
              ),

              const SizedBox(height: 6),

              Text(
                attendance.attendanceDate
                    .toString()
                    .split(' ')
                    .first,
              ),

              const Divider(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      attendance.checkInTime ==
                          null
                          ? '--'
                          : attendance
                          .checkInTime
                          .toString(),
                    ),
                  ),

                  Expanded(
                    child: Text(
                      attendance.checkOutTime ==
                          null
                          ? '--'
                          : attendance
                          .checkOutTime
                          .toString(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon:
                    const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon:
                    const Icon(Icons.delete),
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