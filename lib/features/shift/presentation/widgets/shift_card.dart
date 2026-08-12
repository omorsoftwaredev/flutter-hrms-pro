import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/shift_entity.dart';

class ShiftCard extends StatelessWidget {
  const ShiftCard({
    super.key,
    required this.shift,
    this.companyName,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
  });

  final ShiftEntity shift;

  final String? companyName;

  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleStatus;

  // =============================================================
  // WEEK DAY
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
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =======================================================
          // HEADER
          // =======================================================

          Row(
            children: [
              const CircleAvatar(
                child: Icon(
                  Icons.schedule,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      shift.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'view':
                      onView?.call();
                      break;

                    case 'edit':
                      onEdit?.call();
                      break;

                    case 'status':
                      onToggleStatus?.call();
                      break;

                    case 'delete':
                      onDelete?.call();
                      break;
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Text('View'),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 'status',
                    child: Text(
                      shift.isActive
                          ? 'Deactivate'
                          : 'Activate',
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // =======================================================
          // COMPANY
          // =======================================================

          Row(
            children: [
              const Icon(
                Icons.business,
                size: 18,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  companyName ?? '-',
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // =======================================================
          // SHIFT CODE
          // =======================================================

          Row(
            children: [
              const Icon(
                Icons.tag,
                size: 18,
              ),

            ],
          ),

          const SizedBox(height: 10),

          // =======================================================
          // SHIFT TIME
          // =======================================================

          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 18,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  '${shift.startTime} → ${shift.endTime}',
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // =======================================================
          // BREAK
          // =======================================================

          Row(
            children: [
              const Icon(
                Icons.free_breakfast,
                size: 18,
              ),

              const SizedBox(width: 8),

              Text(
                'Break : ${shift.breakMinutes} Minutes',
              ),
            ],
          ),

          const SizedBox(height: 10),

          // =======================================================
          // WEEKLY OFF
          // =======================================================

          Row(
            children: [
              const Icon(
                Icons.event,
                size: 18,
              ),

              const SizedBox(width: 8),

              Text(
                'Weekly Off : '
                    '${_weekDay(shift.weeklyOffDay)}',
              ),
            ],
          ),

          // =======================================================
          // DESCRIPTION
          // =======================================================

          if (shift.description.isNotEmpty) ...[
            const SizedBox(height: 12),

            Text(
              shift.description,
            ),
          ],

          const SizedBox(height: 16),

          // =======================================================
          // SHIFT TYPE / STATUS
          // =======================================================

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                label: Text(
                  shift.isNightShift
                      ? 'Night Shift'
                      : 'Day Shift',
                ),
              ),

              Chip(
                label: Text(
                  shift.isFlexible
                      ? 'Flexible'
                      : 'Fixed',
                ),
              ),

              Chip(
                backgroundColor:
                shift.isActive
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                label: Text(
                  shift.isActive
                      ? 'Active'
                      : 'Inactive',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}