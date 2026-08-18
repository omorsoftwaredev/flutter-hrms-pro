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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double radius = isDesktop
        ? 14
        : isTablet
        ? 13
        : 12;

    return DropdownButtonFormField<EmployeeEntity>(
      value: value,
      isExpanded: true,

      decoration: InputDecoration(
        labelText: 'Employee',
        hintText: 'Select employee',
        prefixIcon: const Icon(
          Icons.person_outline_rounded,
        ),

        filled: true,
        fillColor: colorScheme.surfaceContainerHighest
            .withOpacity(.35),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1.5,
          ),
        ),
      ),

      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: colorScheme.onSurfaceVariant,
      ),

      items: employees
          .map(
            (employee) => DropdownMenuItem<EmployeeEntity>(
          value: employee,
          child: Text(
            employee.fullName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      )
          .toList(),

      onChanged: onChanged,

      validator: (selectedEmployee) {
        if (selectedEmployee == null) {
          return 'Please select employee';
        }

        return null;
      },
    );
  }
}