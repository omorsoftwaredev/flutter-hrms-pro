import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_tile.dart';
import '../../../../core/widgets/app_status_chip.dart';

import '../../domain/entities/shift_entity.dart';

class ShiftViewPage extends StatelessWidget {
  const ShiftViewPage({
    super.key,
    required this.shift,
  });

  final ShiftEntity shift;

  String _weekDay(int? day) {
    switch (day) {
      case 0:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 36,
                  child: Icon(
                    Icons.schedule,
                    size: 40,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  shift.name,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall,
                ),

                const SizedBox(height: 6),

                Text(
                  shift.code,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),

                const SizedBox(height: 16),

                AppStatusChip(
                  isActive: shift.isActive,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          AppCard(
            child: Column(
              children: [
                AppDetailTile(
                  title: 'Company ID',
                  value: shift.companyId,
                ),

                AppDetailTile(
                  title: 'Code',
                  value: shift.code,
                ),

                AppDetailTile(
                  title: 'Shift Name',
                  value: shift.name,
                ),

                AppDetailTile(
                  title: 'Description',
                  value: shift.description.isEmpty
                      ? '-'
                      : shift.description,
                ),

                AppDetailTile(
                  title: 'Start Time',
                  value: shift.startTime,
                ),

                AppDetailTile(
                  title: 'End Time',
                  value: shift.endTime,
                ),

                AppDetailTile(
                  title: 'Break Time',
                  value:
                  '${shift.breakMinutes} Minutes',
                ),

                AppDetailTile(
                  title: 'Grace In',
                  value:
                  '${shift.graceInMinutes} Minutes',
                ),

                AppDetailTile(
                  title: 'Grace Out',
                  value:
                  '${shift.graceOutMinutes} Minutes',
                ),

                AppDetailTile(
                  title: 'Late After',
                  value:
                  '${shift.lateAfterMinutes} Minutes',
                ),

                AppDetailTile(
                  title: 'Half Day After',
                  value:
                  '${shift.halfDayAfterMinutes} Minutes',
                ),

                AppDetailTile(
                  title: 'Weekly Off',
                  value:
                  _weekDay(shift.weeklyOffDay),
                ),

                AppDetailTile(
                  title: 'Night Shift',
                  value: shift.isNightShift
                      ? 'Yes'
                      : 'No',
                ),

                AppDetailTile(
                  title: 'Flexible Shift',
                  value: shift.isFlexible
                      ? 'Yes'
                      : 'No',
                ),

                AppDetailTile(
                  title: 'Created At',
                  value:
                  shift.createdAt.toString(),
                ),

                AppDetailTile(
                  title: 'Updated At',
                  value:
                  shift.updatedAt.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}