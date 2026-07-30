import 'package:flutter/material.dart';

import '../../../shift/domain/entities/shift_entity.dart';

class AttendanceShiftDropdown extends StatelessWidget {
  final List<ShiftEntity> shifts;
  final ShiftEntity? value;
  final ValueChanged<ShiftEntity?> onChanged;

  const AttendanceShiftDropdown({
    super.key,
    required this.shifts,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ShiftEntity>(
      value: value,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Shift',
        border: OutlineInputBorder(),
      ),
      items: shifts
          .map(
            (e) => DropdownMenuItem(
          value: e,
          child: Text(e.name),
        ),
      )
          .toList(),
      onChanged: onChanged,
    );
  }
}