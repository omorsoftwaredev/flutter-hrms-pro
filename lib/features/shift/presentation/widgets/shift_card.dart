import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/shift_entity.dart';

class ShiftCard extends StatelessWidget {
  const ShiftCard({
    super.key,
    required this.shift,
    this.companyName,
    this.onEdit,
    this.onDelete,
  });

  final ShiftEntity shift;

  final String? companyName;

  final VoidCallback? onEdit;

  final VoidCallback? onDelete;

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
    return AppCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
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

                    Text(
                      shift.code,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit?.call();
                      break;

                    case 'delete':
                      onDelete?.call();
                      break;
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

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

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 18,
              ),

              const SizedBox(width: 8),

              Text(
                '${shift.startTime}  →  ${shift.endTime}',
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.free_breakfast,
                size: 18,
              ),

              const SizedBox(width: 8),

              Text(
                'Break : ${shift.breakMinutes} min',
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.event,
                size: 18,
              ),

              const SizedBox(width: 8),

              Text(
                'Weekly Off : ${_weekDay(shift.weeklyOffDay)}',
              ),
            ],
          ),

          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                label: Text(
                  shift.isNightShift
                      ? 'Night'
                      : 'Day',
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