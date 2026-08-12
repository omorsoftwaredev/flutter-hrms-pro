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

  // =============================================================
  // WEEKLY OFF DAY
  // =============================================================

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

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shift Details',
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // =======================================================
          // HEADER
          // =======================================================

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
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall,
                ),

                const SizedBox(height: 16),

                AppStatusChip(
                  isActive: shift.isActive,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // =======================================================
          // BASIC INFORMATION
          // =======================================================

          AppCard(
            child: Column(
              children: [
                AppDetailTile(
                  title: 'Company ID',
                  value: shift.companyId,
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
              ],
            ),
          ),

          const SizedBox(height: 16),

          // =======================================================
          // SHIFT TIMING
          // =======================================================

          AppCard(
            child: Column(
              children: [
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
                  title: 'Weekly Off',
                  value:
                  _weekDay(shift.weeklyOffDay),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // =======================================================
          // ATTENDANCE RULES
          // =======================================================

          AppCard(
            child: Column(
              children: [
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
              ],
            ),
          ),

          const SizedBox(height: 16),

          // =======================================================
          // SHIFT TYPE
          // =======================================================

          AppCard(
            child: Column(
              children: [
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
                  title: 'Status',
                  value: shift.isActive
                      ? 'Active'
                      : 'Inactive',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // =======================================================
          // AUDIT INFORMATION
          // =======================================================

          AppCard(
            child: Column(
              children: [
                AppDetailTile(
                  title: 'Created At',
                  value:
                  shift.createdAt.toString(),
                ),

                AppDetailTile(
                  title: 'Updated At',
                  value:
                  shift.updatedAt?.toString() ?? '-',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}