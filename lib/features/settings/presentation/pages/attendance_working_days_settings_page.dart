/// ===============================================================
/// Flutter HRMS Pro
///
/// Attendance - Working Days Settings
///
/// Version : 1.0.0
///
/// Features:
/// - Monday to Sunday
/// - Working day selection
/// - Responsive UI
/// - Select all working days
/// - Clear all
/// - Save action
/// ===============================================================

import 'package:flutter/material.dart';

class AttendanceWorkingDaysSettingsPage
    extends StatefulWidget {
  const AttendanceWorkingDaysSettingsPage({
    super.key,
  });

  @override
  State<AttendanceWorkingDaysSettingsPage>
  createState() =>
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
          day.key != 'saturday' &&
              day.key != 'sunday';
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
      backgroundColor:
      theme.scaffoldBackgroundColor,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor:
        theme.scaffoldBackgroundColor,
        foregroundColor:
        colorScheme.onSurface,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Working Days',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
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
            final isWide =
                constraints.maxWidth >= 700;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWide
                      ? 850
                      : double.infinity,
                ),

                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                    isWide ? 24 : 16,
                    vertical: 16,
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      // =========================================
                      // HEADER
                      // =========================================

                      _buildHeader(
                        context,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // =========================================
                      // WORKING DAYS CARD
                      // =========================================

                      _buildWorkingDaysCard(
                        context,
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      // =========================================
                      // INFORMATION
                      // =========================================

                      _buildInformationCard(
                        context,
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      // =========================================
                      // SAVE
                      // =========================================

                      _buildSaveButton(
                        context,
                      ),

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

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: colorScheme.primary
            .withOpacity(0.08),

        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,

            decoration: BoxDecoration(
              color: colorScheme.primary
                  .withOpacity(0.12),

              borderRadius:
              BorderRadius.circular(16),
            ),

            child: Icon(
              Icons.calendar_month_outlined,
              size: 30,
              color:
              colorScheme.primary,
            ),
          ),

          const SizedBox(
            width: 15,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  'Working Days',
                  style: theme
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  'Choose which days are considered working days for attendance.',
                  style: theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color: colorScheme
                        .onSurface
                        .withOpacity(
                      0.65,
                    ),
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

      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: theme.cardColor,

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color: theme.dividerColor
              .withOpacity(0.5),
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
              Icon(
                Icons.work_outline,
                color:
                colorScheme.primary,
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Working Week',
                      style: theme
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      '${_workingDayCount()} of 7 days selected',
                      style: theme
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        color: colorScheme
                            .onSurface
                            .withOpacity(
                          0.60,
                        ),
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

          const Divider(
            height: 1,
          ),

          const SizedBox(
            height: 12,
          ),

          // =====================================================
          // QUICK ACTIONS
          // =====================================================

          Row(
            children: [
              TextButton.icon(
                onPressed:
                _selectMondayToFriday,
                icon: const Icon(
                  Icons.business_center_outlined,
                  size: 18,
                ),
                label: const Text(
                  'Mon - Fri',
                ),
              ),

              const Spacer(),

              TextButton(
                onPressed:
                _selectAllDays,
                child: const Text(
                  'All',
                ),
              ),

              TextButton(
                onPressed:
                _clearAllDays,
                child: const Text(
                  'Clear',
                ),
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

    return InkWell(
      borderRadius:
      BorderRadius.circular(14),

      onTap: () {
        setState(() {
          day.isWorkingDay =
          !day.isWorkingDay;
        });
      },

      child: Container(
        width: double.infinity,

        margin:
        const EdgeInsets.only(
          bottom: 6,
        ),

        padding:
        const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),

        decoration: BoxDecoration(
          color: day.isWorkingDay
              ? colorScheme.primary
              .withOpacity(0.07)
              : Colors.transparent,

          borderRadius:
          BorderRadius.circular(14),

          border: Border.all(
            color: day.isWorkingDay
                ? colorScheme.primary
                .withOpacity(0.25)
                : theme.dividerColor
                .withOpacity(0.35),
          ),
        ),

        child: Row(
          children: [
            // ===================================================
            // DAY ICON
            // ===================================================

            Container(
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: day.isWorkingDay
                    ? colorScheme.primary
                    .withOpacity(0.12)
                    : colorScheme
                    .surfaceContainerHighest,

                borderRadius:
                BorderRadius.circular(
                  12,
                ),
              ),

              child: Center(
                child: Text(
                  day.shortName,
                  style: TextStyle(
                    color: day.isWorkingDay
                        ? colorScheme
                        .primary
                        : colorScheme
                        .onSurface
                        .withOpacity(
                      0.60,
                    ),
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(
              width: 12,
            ),

            // ===================================================
            // DAY NAME
            // ===================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    day.name,
                    style: theme
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 2,
                  ),

                  Text(
                    day.isWorkingDay
                        ? 'Working day'
                        : 'Non-working day',
                    style: theme
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color: colorScheme
                          .onSurface
                          .withOpacity(
                        0.55,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ===================================================
            // SWITCH
            // ===================================================

            Switch(
              value:
              day.isWorkingDay,

              onChanged: (value) {
                setState(() {
                  day.isWorkingDay =
                      value;
                });
              },
            ),
          ],
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

      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: colorScheme
            .surfaceContainerHighest
            .withOpacity(0.45),

        borderRadius:
        BorderRadius.circular(16),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Icon(
            Icons.info_outline,
            size: 21,
            color:
            colorScheme.primary,
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Text(
              'Working days are used by attendance calculations and related reports. Weekend and holiday rules can be configured separately.',
              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                height: 1.4,
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
    final primary =
        Theme.of(context)
            .colorScheme
            .primary;

    return SizedBox(
      width: double.infinity,
      height: 50,

      child: ElevatedButton.icon(
        onPressed: () {
          final selectedDays =
          _days
              .where(
                (day) =>
            day.isWorkingDay,
          )
              .map(
                (day) => day.key,
          )
              .toList();

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(
              content: Text(
                'Working days selected: ${selectedDays.length}',
              ),
            ),
          );
        },

        icon: const Icon(
          Icons.save_outlined,
        ),

        label: const Text(
          'Save Working Days',
          style: TextStyle(
            fontSize: 14,
            fontWeight:
            FontWeight.w600,
          ),
        ),

        style:
        ElevatedButton.styleFrom(
          backgroundColor:
          primary,
          foregroundColor:
          Colors.white,
          elevation: 0,

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              10,
            ),
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