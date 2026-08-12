import 'package:flutter/material.dart';

import '../../../employee/domain/entities/employee_entity.dart';

class AttendanceEmployeeDropdown extends StatelessWidget {
  final List<EmployeeEntity> employees;
  final EmployeeEntity? value;
  final ValueChanged<EmployeeEntity?> onChanged;

  const AttendanceEmployeeDropdown({
    super.key,
    required this.employees,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<EmployeeEntity>(
      value: value,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Employee',
        border: OutlineInputBorder(),
      ),
      items: employees
          .map(
            (e) => DropdownMenuItem(
          value: e,
          child: Text(
            '${e.fullName}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      )
          .toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Please select employee';
        }
        return null;
      },
    );
  }
}