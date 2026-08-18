import 'package:flutter/material.dart';

class AttendanceFilterDialog extends StatefulWidget {
  final String? selectedStatus;

  const AttendanceFilterDialog({
    super.key,
    this.selectedStatus,
  });

  @override
  State<AttendanceFilterDialog> createState() =>
      _AttendanceFilterDialogState();
}

class _AttendanceFilterDialogState
    extends State<AttendanceFilterDialog> {
  late String? status;

  @override
  void initState() {
    super.initState();
    status = widget.selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double horizontalPadding = isDesktop
        ? 28
        : isTablet
        ? 24
        : 20;

    return AlertDialog(
      icon: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(.10),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.filter_alt_outlined,
          color: colorScheme.primary,
          size: 26,
        ),
      ),

      title: Text(
        'Filter Attendance',
        textAlign: TextAlign.center,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
      ),

      contentPadding: EdgeInsets.fromLTRB(
        horizontalPadding,
        8,
        horizontalPadding,
        8,
      ),

      content: SizedBox(
        width: isDesktop
            ? 420
            : double.maxFinite,
        child: DropdownButtonFormField<String>(
          value: status,
          isExpanded: true,

          decoration: InputDecoration(
            labelText: 'Status',
            hintText: 'Select attendance status',
            prefixIcon: const Icon(
              Icons.event_available_outlined,
            ),

            filled: true,
            fillColor: colorScheme.surfaceContainerHighest
                .withOpacity(.35),

            contentPadding:
            const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 15,
            ),

            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(14),
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(14),
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(14),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 1.5,
              ),
            ),
          ),

          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: colorScheme.onSurfaceVariant,
          ),

          items: const [
            DropdownMenuItem(
              value: 'PRESENT',
              child: Text('Present'),
            ),
            DropdownMenuItem(
              value: 'ABSENT',
              child: Text('Absent'),
            ),
            DropdownMenuItem(
              value: 'LATE',
              child: Text('Late'),
            ),
            DropdownMenuItem(
              value: 'LEAVE',
              child: Text('Leave'),
            ),
            DropdownMenuItem(
              value: 'HALF_DAY',
              child: Text('Half Day'),
            ),
            DropdownMenuItem(
              value: 'HOLIDAY',
              child: Text('Holiday'),
            ),
          ],

          onChanged: (value) {
            setState(() {
              status = value;
            });
          },
        ),
      ),

      actionsPadding: EdgeInsets.fromLTRB(
        horizontalPadding,
        8,
        horizontalPadding,
        16,
      ),

      actions: [
        Row(
          children: [
            // =====================================================
            // CANCEL
            // =====================================================

            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  minimumSize:
                  const Size.fromHeight(46),
                  foregroundColor:
                  colorScheme.onSurface,
                  side: BorderSide(
                    color: colorScheme.outline,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // =====================================================
            // APPLY
            // =====================================================

            Expanded(
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    status,
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor:
                  colorScheme.primary,
                  foregroundColor:
                  colorScheme.onPrimary,
                  elevation: 0,
                  minimumSize:
                  const Size.fromHeight(46),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}