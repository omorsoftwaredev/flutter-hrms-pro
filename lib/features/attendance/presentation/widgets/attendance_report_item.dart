import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/attendance_report_model.dart';
import '../../domain/entities/attendance_report_entity.dart';

class AttendanceReportItem extends StatelessWidget {
  const AttendanceReportItem({
    super.key,
    required this.item,
  });

  final AttendanceReportModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9FF),
        borderRadius:
        BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: _buildDateSection(),
          ),

          Expanded(
            child: _buildTimeSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat(
            'dd-MMM-yy',
          ).format(item.date),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          item.statusText,
          style: TextStyle(
            fontSize: 17,
            fontStyle: FontStyle.italic,
            color: _statusColor(item.status),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSection() {
    if (item.status ==
        AttendanceReportStatus.dayOff ||
        item.status ==
            AttendanceReportStatus.absent ||
        item.status ==
            AttendanceReportStatus.leave ||
        item.status ==
            AttendanceReportStatus.holiday) {
      return Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: const [
          Text(
            '-',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 14),
          Text(
            '-',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _timeRow(
          label: 'In',
          time: item.checkInTime,
          address: item.checkInAddress,
          suffix: 'Entry',
        ),

        const SizedBox(height: 10),

        _timeRow(
          label: 'Out',
          time: item.checkOutTime,
          address: item.checkOutAddress,
          suffix: 'Exit',
        ),
      ],
    );
  }

  Widget _timeRow({
    required String label,
    required DateTime? time,
    required String? address,
    required String suffix,
  }) {
    final timeText = time == null
        ? '-'
        : DateFormat(
      'hh:mm a',
    ).format(time.toLocal());

    final location =
    address == null ||
        address.trim().isEmpty
        ? '-'
        : address;

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 15,
        ),
        children: [
          TextSpan(
            text: '$label : $timeText - ',
          ),
          TextSpan(
            text: '$location - $suffix',
          ),
        ],
      ),
    );
  }

  Color _statusColor(
      AttendanceReportStatus status,
      ) {
    switch (status) {
      case AttendanceReportStatus.present:
        return Colors.green;

      case AttendanceReportStatus.late:
        return Colors.red;

      case AttendanceReportStatus.absent:
        return Colors.red;

      case AttendanceReportStatus.leave:
        return Colors.orange;

      case AttendanceReportStatus.dayOff:
        return Colors.grey;

      case AttendanceReportStatus.holiday:
        return Colors.blue;
    }
  }
}