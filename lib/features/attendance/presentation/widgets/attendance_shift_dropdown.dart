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

    return DropdownButtonFormField<ShiftEntity>(
      value: value,
      isExpanded: true,

      style: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
      ),

      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: colorScheme.onSurfaceVariant,
      ),

      decoration: InputDecoration(
        labelText: 'Shift',
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),

        prefixIcon: Icon(
          Icons.schedule_outlined,
          color: colorScheme.onSurfaceVariant,
        ),

        filled: true,

        fillColor: colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.35),

        contentPadding: EdgeInsets.symmetric(
          horizontal: isDesktop
              ? 16
              : isTablet
              ? 14
              : 12,
          vertical: isDesktop
              ? 16
              : isTablet
              ? 14
              : 12,
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
      ),

      items: shifts
          .map(
            (e) => DropdownMenuItem<ShiftEntity>(
          value: e,
          child: Text(
            e.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
      )
          .toList(),

      onChanged: onChanged,
    );
  }
}