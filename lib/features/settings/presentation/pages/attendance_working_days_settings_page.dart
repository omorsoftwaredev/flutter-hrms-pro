/// ===============================================================
/// Flutter HRMS Pro
///
/// Attendance - Working Days Settings
///
/// Version : 1.1.0
///
/// Features:
/// - Monday to Sunday
/// - Working day selection
/// - Responsive UI
/// - Select all working days
/// - Clear all
/// - Save action
/// - Full Theme Aware
/// - Light / Dark Theme Support
/// ===============================================================

import 'package:flutter/material.dart';

class AttendanceWorkingDaysSettingsPage extends StatefulWidget {
  const AttendanceWorkingDaysSettingsPage({
    super.key,
  });

  @override
  State<AttendanceWorkingDaysSettingsPage> createState() =>
      _AttendanceWorkingDaysSettingsPageState();
}

class _AttendanceWorkingDaysSettingsPageState
    extends State<AttendanceWorkingDaysSettingsPage> {
  // =============================================================
  // DAYS
  // =============================================================

  final List<_WorkingDay> _days = [
    _WorkingDay(
      key: 'monday',
      name: 'Monday',
      shortName: 'Mon',
    ),
    _WorkingDay(
      key: 'tuesday',
      name: 'Tuesday',
      shortName: 'Tue',
    ),
    _WorkingDay(
      key: 'wednesday',
      name: 'Wednesday',
      shortName: 'Wed',
    ),
    _WorkingDay(
      key: 'thursday',
      name: 'Thursday',
      shortName: 'Thu',
    ),
    _WorkingDay(
      key: 'friday',
      name: 'Friday',
      shortName: 'Fri',
    ),
    _WorkingDay(
      key: 'saturday',
      name: 'Saturday',
      shortName: 'Sat',
    ),
    _WorkingDay(
      key: 'sunday',
      name: 'Sunday',
      shortName: 'Sun',
    ),
  ];

  // =============================================================
  // DEFAULT
  // =============================================================

  @override
  void initState() {
    super.initState();

    // Default: Monday - Friday
    for (final day in _days) {
      day.isWorkingDay =
          day.key != 'saturday' && day.key != 'sunday';
    }
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,

        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Working Days',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            final isWide = constraints.maxWidth >= 700;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWide ? 850 : double.infinity,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 24 : 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // =========================================
                      // HEADER
                      // =========================================

                      _buildHeader(context),

                      const SizedBox(
                        height: 20,
                      ),

                      // =========================================
                      // WORKING DAYS CARD
                      // =========================================

                      _buildWorkingDaysCard(context),

                      const SizedBox(
                        height: 16,
                      ),

                      // =========================================
                      // INFORMATION
                      // =========================================

                      _buildInformationCard(context),

                      const SizedBox(
                        height: 24,
                      ),

                      // =========================================
                      // SAVE
                      // =========================================

                      _buildSaveButton(context),

                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // =============================================================
  // HEADER
  // =============================================================

  Widget _buildHeader(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final primarySoft =
    colorScheme.primary.withValues(alpha: 0.08);

    final primaryContainer =
        colorScheme.primaryContainer;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primarySoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================================================
          // ICON
          // =====================================================

          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              size: 29,
              color: colorScheme.onPrimaryContainer,
            ),
          ),

          const SizedBox(
            width: 15,
          ),

          // =====================================================
          // TEXT
          // =====================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Working Days',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  'Choose which days are considered working days for attendance.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // WORKING DAYS CARD
  // =============================================================

  Widget _buildWorkingDaysCard(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // =====================================================
          // TITLE
          // =====================================================

          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.work_outline_rounded,
                  color: colorScheme.onPrimaryContainer,
                  size: 21,
                ),
              ),

              const SizedBox(
                width: 11,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Working Week',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      '${_workingDayCount()} of 7 days selected',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 16,
          ),

          Divider(
            height: 1,
            color: colorScheme.outlineVariant,
          ),

          const SizedBox(
            height: 12,
          ),

          // =====================================================
          // QUICK ACTIONS
          // =====================================================

          Wrap(
            spacing: 4,
            runSpacing: 4,
            alignment: WrapAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: _selectMondayToFriday,
                icon: const Icon(
                  Icons.business_center_outlined,
                  size: 18,
                ),
                label: const Text(
                  'Mon - Fri',
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: _selectAllDays,
                    child: const Text(
                      'All',
                    ),
                  ),
                  TextButton(
                    onPressed: _clearAllDays,
                    child: const Text(
                      'Clear',
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(
            height: 4,
          ),

          // =====================================================
          // DAYS
          // =====================================================

          ..._days.map(
                (day) => _buildDayItem(
              context,
              day,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // DAY ITEM
  // =============================================================

  Widget _buildDayItem(
      BuildContext context,
      _WorkingDay day,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isSelected = day.isWorkingDay;

    final Color backgroundColor = isSelected
        ? colorScheme.primary.withValues(alpha: 0.07)
        : colorScheme.surfaceContainerHighest.withValues(
      alpha: 0.35,
    );

    final Color borderColor = isSelected
        ? colorScheme.primary.withValues(alpha: 0.25)
        : colorScheme.outlineVariant;

    final Color iconBackground = isSelected
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest;

    final Color iconForeground = isSelected
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 7,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            setState(() {
              day.isWorkingDay =
              !day.isWorkingDay;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 180,
            ),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: borderColor,
              ),
            ),
            child: Row(
              children: [
                // =================================================
                // DAY ICON
                // =================================================

                AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 180,
                  ),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    day.shortName,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: iconForeground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                // =================================================
                // DAY NAME
                // =================================================

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        day.name,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(
                        height: 2,
                      ),

                      Text(
                        isSelected
                            ? 'Working day'
                            : 'Non-working day',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                // =================================================
                // SWITCH
                // =================================================

                Switch(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      day.isWorkingDay = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // INFORMATION CARD
  // =============================================================

  Widget _buildInformationCard(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              size: 20,
              color: colorScheme.onPrimaryContainer,
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Text(
              'Working days are used by attendance calculations and related reports. Weekend and holiday rules can be configured separately.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SAVE BUTTON
  // =============================================================

  Widget _buildSaveButton(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton.icon(
        onPressed: () {
          final selectedDays = _days
              .where(
                (day) => day.isWorkingDay,
          )
              .map(
                (day) => day.key,
          )
              .toList();

          ScaffoldMessenger.of(context)
              .hideCurrentSnackBar();

          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor:
              colorScheme.inverseSurface,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(14),
              ),
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color:
                    colorScheme.onInverseSurface,
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child: Text(
                      'Working days selected: ${selectedDays.length}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                        colorScheme.onInverseSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        icon: const Icon(
          Icons.save_outlined,
        ),
        label: Text(
          'Save Working Days',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // WORKING DAY COUNT
  // =============================================================

  int _workingDayCount() {
    return _days
        .where(
          (day) => day.isWorkingDay,
    )
        .length;
  }

  // =============================================================
  // MONDAY - FRIDAY
  // =============================================================

  void _selectMondayToFriday() {
    setState(() {
      for (final day in _days) {
        day.isWorkingDay =
            day.key != 'saturday' &&
                day.key != 'sunday';
      }
    });
  }

  // =============================================================
  // ALL DAYS
  // =============================================================

  void _selectAllDays() {
    setState(() {
      for (final day in _days) {
        day.isWorkingDay = true;
      }
    });
  }

  // =============================================================
  // CLEAR
  // =============================================================

  void _clearAllDays() {
    setState(() {
      for (final day in _days) {
        day.isWorkingDay = false;
      }
    });
  }
}

// ===============================================================
// WORKING DAY MODEL
// ===============================================================

class _WorkingDay {
  _WorkingDay({
    required this.key,
    required this.name,
    required this.shortName,
    this.isWorkingDay = false,
  });

  final String key;
  final String name;
  final String shortName;

  bool isWorkingDay;
}