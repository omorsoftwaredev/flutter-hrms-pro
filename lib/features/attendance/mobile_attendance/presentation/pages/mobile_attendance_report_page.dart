import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/mobile_attendance_report_entity.dart';
import '../providers/mobile_attendance_report_provider.dart';

//=================================================================
// MOBILE ATTENDANCE REPORT PAGE
//=================================================================

class MobileAttendanceReportPage extends ConsumerStatefulWidget {
  final String employeeId;

  const MobileAttendanceReportPage({
    super.key,
    required this.employeeId,
  });

  @override
  ConsumerState<MobileAttendanceReportPage> createState() =>
      _MobileAttendanceReportPageState();
}

//=================================================================
// ATTENDANCE FILTER
//=================================================================

enum _AttendanceFilter {
  all,
  present,
  late,
  earlyOut,
  absent,
  offDay,
  leave,
}

//=================================================================
// REPORT ROW
//=================================================================

class _AttendanceReportRow {
  final DateTime date;
  final MobileAttendanceReportEntity? report;
  final bool isOffDay;
  final bool isAbsent;

  const _AttendanceReportRow({
    required this.date,
    required this.report,
    required this.isOffDay,
    required this.isAbsent,
  });

  bool get hasAttendance => report != null;

  bool get isPresent =>
      report?.isPresent ?? false;

  bool get isLate =>
      report?.isLate ?? false;

  bool get isEarlyOut =>
      report?.isEarlyOut ?? false;

  bool get isLeave =>
      report?.attendanceStatus
          .toUpperCase() ==
          'LEAVE';

  int get actualWorkMinutes =>
      report?.actualWorkMinutes ?? 0;

  int get overtimeMinutes =>
      report?.overtimeMinutes ?? 0;

  int get lateMinutes =>
      report?.lateMinutes ?? 0;

  int get earlyLeaveMinutes =>
      report?.earlyLeaveMinutes ?? 0;

  String get status {
    if (isOffDay) {
      return 'OFF DAY';
    }

    if (isAbsent) {
      return 'ABSENT';
    }

    if (isLeave) {
      return 'LEAVE';
    }

    if (report == null) {
      return 'ABSENT';
    }

    if (isLate && isEarlyOut) {
      return 'LATE & EARLY OUT';
    }

    if (isLate) {
      return 'LATE';
    }

    if (isEarlyOut) {
      return 'EARLY OUT';
    }

    return report!.reportStatus;
  }
}

//=================================================================
// PAGE STATE
//=================================================================

class _MobileAttendanceReportPageState
    extends ConsumerState<MobileAttendanceReportPage> {
  late DateTime _fromDate;
  late DateTime _toDate;

  _AttendanceFilter _selectedFilter =
      _AttendanceFilter.all;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    _fromDate = DateTime(
      now.year,
      now.month,
      1,
    );

    _toDate = DateTime(
      now.year,
      now.month + 1,
      0,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ref
          .read(mobileAttendanceReportProvider)
          .loadReportsAndSummary(
        employeeId: widget.employeeId,
        startDate: _fromDate,
        endDate: _toDate,
      );
    });
  }

  //=================================================================
  // DATE ONLY
  //=================================================================

  DateTime _dateOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  //=================================================================
  // DATE KEY
  //=================================================================

  String _dateKey(DateTime date) {
    final value = _dateOnly(date);

    return '${value.year}-'
        '${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')}';
  }

  //=================================================================
  // FORMAT DATE
  //=================================================================

  String _formatDate(DateTime date) {
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day.toString().padLeft(2, '0')} '
        '${months[date.month - 1]} '
        '${date.year}';
  }

  //=================================================================
  // FORMAT DATE SHORT
  //=================================================================

  String _formatShortDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  //=================================================================
  // DAY NAME
  //=================================================================

  String _dayName(DateTime date) {
    const days = <String>[
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return days[date.weekday - 1];
  }

  //=================================================================
  // MONTH NAME
  //=================================================================

  String _monthName(DateTime date) {
    const months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[date.month - 1];
  }

  //=================================================================
  // WEEKEND
  //=================================================================

  bool _isWeekend(DateTime date) {
    return date.weekday == DateTime.friday ||
        date.weekday == DateTime.saturday;
  }

  //=================================================================
  // BUILD ALL DATES
  //=================================================================

  List<DateTime> _buildDates() {
    final dates = <DateTime>[];

    var current = _dateOnly(_fromDate);
    final end = _dateOnly(_toDate);

    while (!current.isAfter(end)) {
      dates.add(current);

      current = current.add(
        const Duration(days: 1),
      );
    }

    return dates;
  }

  //=================================================================
  // BUILD ROWS
  //=================================================================

  List<_AttendanceReportRow> _buildRows(
      List<MobileAttendanceReportEntity> reports,
      ) {
    final reportMap =
    <String, MobileAttendanceReportEntity>{};

    for (final report in reports) {
      final key = _dateKey(
        report.attendanceDate,
      );

      reportMap[key] = report;
    }

    final rows = <_AttendanceReportRow>[];

    for (final date in _buildDates()) {
      final report =
      reportMap[_dateKey(date)];

      if (report != null) {
        final offDay =
            report.isHoliday ||
                !report.isWorkingDay;

        rows.add(
          _AttendanceReportRow(
            date: date,
            report: report,
            isOffDay: offDay,
            isAbsent: report.isAbsent,
          ),
        );

        continue;
      }

      final weekend =
      _isWeekend(date);

      rows.add(
        _AttendanceReportRow(
          date: date,
          report: null,
          isOffDay: weekend,
          isAbsent: !weekend,
        ),
      );
    }

    return rows;
  }

  //=================================================================
  // FILTER ROWS
  //=================================================================

  List<_AttendanceReportRow> _filterRows(
      List<_AttendanceReportRow> rows,
      ) {
    switch (_selectedFilter) {
      case _AttendanceFilter.all:
        return rows;

      case _AttendanceFilter.present:
        return rows.where((row) {
          if (row.report == null) {
            return false;
          }

          if (row.isOffDay ||
              row.isAbsent ||
              row.isLeave) {
            return false;
          }

          return row.isPresent &&
              !row.isLate &&
              !row.isEarlyOut;
        }).toList();

      case _AttendanceFilter.late:
        return rows.where((row) {
          return row.isLate;
        }).toList();

      case _AttendanceFilter.earlyOut:
        return rows.where((row) {
          return row.isEarlyOut;
        }).toList();

      case _AttendanceFilter.absent:
        return rows.where((row) {
          return row.isAbsent &&
              !row.isOffDay;
        }).toList();

      case _AttendanceFilter.offDay:
        return rows.where((row) {
          return row.isOffDay;
        }).toList();

      case _AttendanceFilter.leave:
        return rows.where((row) {
          return row.isLeave;
        }).toList();
    }
  }

  //=================================================================
  // PICK FROM DATE
  //=================================================================

  Future<void> _pickFromDate() async {
    final selected =
    await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Select From Date',
    );

    if (selected == null) {
      return;
    }

    if (selected.isAfter(_toDate)) {
      return;
    }

    setState(() {
      _fromDate = _dateOnly(selected);
    });

    await _reload();
  }

  //=================================================================
  // PICK TO DATE
  //=================================================================

  Future<void> _pickToDate() async {
    final selected =
    await showDatePicker(
      context: context,
      initialDate: _toDate,
      firstDate: _fromDate,
      lastDate: DateTime(2100),
      helpText: 'Select To Date',
    );

    if (selected == null) {
      return;
    }

    if (selected.isBefore(_fromDate)) {
      return;
    }

    setState(() {
      _toDate = _dateOnly(selected);
    });

    await _reload();
  }

  //=================================================================
  // CURRENT MONTH
  //=================================================================

  Future<void> _selectCurrentMonth() async {
    final now = DateTime.now();

    setState(() {
      _fromDate = DateTime(
        now.year,
        now.month,
        1,
      );

      _toDate = DateTime(
        now.year,
        now.month + 1,
        0,
      );

      _selectedFilter =
          _AttendanceFilter.all;
    });

    await _reload();
  }

  //=================================================================
  // RELOAD
  //=================================================================

  Future<void> _reload() async {
    await ref
        .read(mobileAttendanceReportProvider)
        .loadReportsAndSummary(
      employeeId: widget.employeeId,
      startDate: _fromDate,
      endDate: _toDate,
    );
  }

  //=================================================================
  // FILTER LABEL
  //=================================================================

  String _filterLabel(
      _AttendanceFilter filter,
      ) {
    switch (filter) {
      case _AttendanceFilter.all:
        return 'All';

      case _AttendanceFilter.present:
        return 'Present';

      case _AttendanceFilter.late:
        return 'Late';

      case _AttendanceFilter.earlyOut:
        return 'Early Out';

      case _AttendanceFilter.absent:
        return 'Absent';

      case _AttendanceFilter.offDay:
        return 'Off Day';

      case _AttendanceFilter.leave:
        return 'Leave';
    }
  }

  //=================================================================
  // FILTER ICON
  //=================================================================

  IconData _filterIcon(
      _AttendanceFilter filter,
      ) {
    switch (filter) {
      case _AttendanceFilter.all:
        return Icons.dashboard_outlined;

      case _AttendanceFilter.present:
        return Icons.check_circle_outline;

      case _AttendanceFilter.late:
        return Icons.schedule_outlined;

      case _AttendanceFilter.earlyOut:
        return Icons.logout_outlined;

      case _AttendanceFilter.absent:
        return Icons.cancel_outlined;

      case _AttendanceFilter.offDay:
        return Icons.weekend_outlined;

      case _AttendanceFilter.leave:
        return Icons.event_busy_outlined;
    }
  }

  //=================================================================
  // STATUS COLOR
  //=================================================================

  Color _statusColor(
      BuildContext context,
      _AttendanceReportRow row,
      ) {
    final scheme =
        Theme.of(context).colorScheme;

    if (row.isOffDay) {
      return scheme.secondary;
    }

    if (row.isAbsent) {
      return scheme.error;
    }

    if (row.isLeave) {
      return scheme.tertiary;
    }

    if (row.isLate &&
        row.isEarlyOut) {
      return scheme.tertiary;
    }

    if (row.isLate) {
      return scheme.error;
    }

    if (row.isEarlyOut) {
      return scheme.tertiary;
    }

    return scheme.primary;
  }

  //=================================================================
  // STATUS BACKGROUND
  //=================================================================

  Color _statusBackground(
      BuildContext context,
      _AttendanceReportRow row,
      ) {
    return _statusColor(
      context,
      row,
    ).withValues(
      alpha: 0.10,
    );
  }

  //=================================================================
  // TIME TO MINUTES
  //=================================================================

  int _timeToMinutes(
      String? value,
      ) {
    if (value == null ||
        value.trim().isEmpty) {
      return 0;
    }

    final parts =
    value.trim().split(':');

    if (parts.length < 2) {
      return 0;
    }

    final hour =
        int.tryParse(parts[0]) ?? 0;

    final minute =
        int.tryParse(parts[1]) ?? 0;

    return hour * 60 + minute;
  }

  //=================================================================
  // SHIFT WORKING MINUTES
  //=================================================================

  int _shiftWorkingMinutes(
      MobileAttendanceReportEntity report,
      ) {
    final start =
    _timeToMinutes(
      report.shiftStartTime,
    );

    final end =
    _timeToMinutes(
      report.shiftEndTime,
    );

    if (start <= 0 ||
        end <= 0) {
      return 0;
    }

    if (end >= start) {
      return end - start;
    }

    return (24 * 60 - start) + end;
  }

  //=================================================================
  // ACTUAL WORKING MINUTES
  //
  // AWH = CHECK IN -> CHECK OUT
  // Break is intentionally NOT deducted.
  //=================================================================

  int _actualWorkingMinutes(
      MobileAttendanceReportEntity report,
      ) {
    final checkIn =
        report.checkInTime;

    final checkOut =
        report.checkOutTime;

    if (checkIn == null ||
        checkOut == null) {
      return 0;
    }

    final difference =
        checkOut.difference(
          checkIn,
        ).inMinutes;

    return difference < 0
        ? 0
        : difference;
  }

  //=================================================================
  // OVERTIME
  //
  // Overtime = AWH - WH
  // Only positive difference is overtime.
  //=================================================================

  int _calculateOvertime(
      int shiftMinutes,
      int actualMinutes,
      ) {
    if (shiftMinutes <= 0 ||
        actualMinutes <= shiftMinutes) {
      return 0;
    }

    return actualMinutes -
        shiftMinutes;
  }

  //=================================================================
  // FORMAT DURATION
  //=================================================================

  String _formatDuration(
      int minutes,
      ) {
    if (minutes <= 0) {
      return '0h 0m';
    }

    final hours =
        minutes ~/ 60;

    final mins =
        minutes % 60;

    if (hours == 0) {
      return '${mins}m';
    }

    if (mins == 0) {
      return '${hours}h';
    }

    return '${hours}h ${mins}m';
  }

  //=================================================================
  // FORMAT TIME
  //=================================================================

  String _formatTime(
      DateTime? value,
      ) {
    if (value == null) {
      return '--';
    }

    final hour =
    value.hour % 12 == 0
        ? 12
        : value.hour % 12;

    final minute =
    value.minute
        .toString()
        .padLeft(2, '0');

    final period =
    value.hour >= 12
        ? 'PM'
        : 'AM';

    return '$hour:$minute $period';
  }

  //=================================================================
  // BUILD
  //=================================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    final provider =
    ref.watch(
      mobileAttendanceReportProvider,
    );

    final rows =
    _buildRows(
      provider.reports,
    );

    final filteredRows =
    _filterRows(rows);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance Report',
        ),
        actions: [
          IconButton(
            tooltip: 'Current Month',
            onPressed: provider.isBusy
                ? null
                : _selectCurrentMonth,
            icon: const Icon(
              Icons.calendar_month_outlined,
            ),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: provider.isBusy
                ? null
                : () async {
              await ref
                  .read(
                mobileAttendanceReportProvider,
              )
                  .refresh(
                employeeId:
                widget.employeeId,
              );
            },
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            final width =
                constraints.maxWidth;

            final maxWidth =
            width >= 1200
                ? 1100.0
                : width >= 700
                ? 900.0
                : double.infinity;

            return Center(
              child: ConstrainedBox(
                constraints:
                BoxConstraints(
                  maxWidth: maxWidth,
                ),
                child: Column(
                  children: [
                    _buildDateSelector(
                      context,
                      provider,
                    ),

                    _buildFilters(
                      context,
                    ),

                    if (provider.isLoading)
                      const LinearProgressIndicator(
                        minHeight: 2,
                      ),

                    if (provider.error != null)
                      _buildError(
                        context,
                        provider.error!,
                      ),

                    Expanded(
                      child:
                      RefreshIndicator(
                        onRefresh: () {
                          return ref
                              .read(
                            mobileAttendanceReportProvider,
                          )
                              .refresh(
                            employeeId:
                            widget.employeeId,
                          );
                        },
                        child:
                        filteredRows.isEmpty
                            ? _buildEmptyState(
                          context,
                        )
                            : ListView.separated(
                          physics:
                          const AlwaysScrollableScrollPhysics(),
                          padding:
                          const EdgeInsets.fromLTRB(
                            12,
                            10,
                            12,
                            32,
                          ),
                          itemCount:
                          filteredRows.length,
                          separatorBuilder:
                              (
                              context,
                              index,
                              ) =>
                          const SizedBox(
                            height: 10,
                          ),
                          itemBuilder:
                              (
                              context,
                              index,
                              ) {
                            return _buildAttendanceCard(
                              context,
                              filteredRows[index],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  //=================================================================
  // DATE SELECTOR
  //=================================================================

  Widget _buildDateSelector(
      BuildContext context,
      MobileAttendanceReportProvider provider,
      ) {
    final theme =
    Theme.of(context);

    return Padding(
      padding:
      const EdgeInsets.fromLTRB(
        12,
        12,
        12,
        6,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDateButton(
              context: context,
              label: 'From',
              date: _fromDate,
              onTap: provider.isBusy
                  ? null
                  : _pickFromDate,
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          Expanded(
            child: _buildDateButton(
              context: context,
              label: 'To',
              date: _toDate,
              onTap: provider.isBusy
                  ? null
                  : _pickToDate,
            ),
          ),

          const SizedBox(
            width: 6,
          ),

          IconButton(
            tooltip:
            'Current Month',
            onPressed: provider.isBusy
                ? null
                : _selectCurrentMonth,
            style:
            IconButton.styleFrom(
              backgroundColor:
              theme.colorScheme
                  .surfaceContainerHighest,
              minimumSize:
              const Size(
                42,
                42,
              ),
              padding:
              EdgeInsets.zero,
            ),
            icon: const Icon(
              Icons.calendar_month_outlined,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  //=================================================================
  // DATE BUTTON
  //=================================================================

  Widget _buildDateButton({
    required BuildContext context,
    required String label,
    required DateTime date,
    required VoidCallback? onTap,
  }) {
    final theme =
    Theme.of(context);

    return Material(
      color: theme
          .colorScheme
          .surfaceContainerHighest,
      borderRadius:
      BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(10),
        child: Padding(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 9,
          ),
          child: Row(
            children: [
              Icon(
                Icons
                    .calendar_today_outlined,
                size: 16,
                color:
                theme.colorScheme
                    .primary,
              ),

              const SizedBox(
                width: 6,
              ),

              Expanded(
                child: Text(
                  '$label ${_formatShortDate(date)}',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .labelMedium
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //=================================================================
  // FILTERS
  //=================================================================

  Widget _buildFilters(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection:
        Axis.horizontal,
        physics:
        const BouncingScrollPhysics(),
        padding:
        const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 5,
        ),
        itemCount:
        _AttendanceFilter
            .values
            .length,
        separatorBuilder:
            (context, index) =>
        const SizedBox(
          width: 7,
        ),
        itemBuilder:
            (context, index) {
          final filter =
          _AttendanceFilter
              .values[index];

          final selected =
              filter ==
                  _selectedFilter;

          return ChoiceChip(
            selected: selected,
            avatar: Icon(
              _filterIcon(filter),
              size: 16,
            ),
            label: Text(
              _filterLabel(filter),
            ),
            labelStyle: TextStyle(
              fontWeight: selected
                  ? FontWeight.w700
                  : FontWeight.w500,
            ),
            side: BorderSide(
              color: theme
                  .colorScheme
                  .outlineVariant,
            ),
            onSelected: (_) {
              setState(() {
                _selectedFilter =
                    filter;
              });
            },
          );
        },
      ),
    );
  }

  //=================================================================
  // ERROR
  //=================================================================

  Widget _buildError(
      BuildContext context,
      String error,
      ) {
    final scheme =
        Theme.of(context)
            .colorScheme;

    return Container(
      width: double.infinity,
      margin:
      const EdgeInsets.fromLTRB(
        12,
        6,
        12,
        4,
      ),
      padding:
      const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration:
      BoxDecoration(
        color:
        scheme.errorContainer,
        borderRadius:
        BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color:
            scheme.onErrorContainer,
            size: 20,
          ),

          const SizedBox(
            width: 8,
          ),

          Expanded(
            child: Text(
              error,
              maxLines: 2,
              overflow:
              TextOverflow.ellipsis,
              style: TextStyle(
                color:
                scheme.onErrorContainer,
              ),
            ),
          ),

          IconButton(
            visualDensity:
            VisualDensity.compact,
            onPressed: () {
              ref
                  .read(
                mobileAttendanceReportProvider,
              )
                  .clearError();
            },
            icon: Icon(
              Icons.close,
              color:
              scheme.onErrorContainer,
              size: 19,
            ),
          ),
        ],
      ),
    );
  }

  //=================================================================
  // EMPTY STATE
  //=================================================================

  Widget _buildEmptyState(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 360,
          child: Center(
            child: Padding(
              padding:
              const EdgeInsets.all(
                24,
              ),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment
                    .center,
                children: [
                  Icon(
                    Icons
                        .event_busy_outlined,
                    size: 52,
                    color: theme
                        .colorScheme
                        .outline,
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  Text(
                    'No attendance records',
                    style: theme
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(
                    'No records match the selected filter.',
                    textAlign:
                    TextAlign.center,
                    style: theme
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                      color: theme
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  //=================================================================
  // ATTENDANCE CARD
  //=================================================================

  Widget _buildAttendanceCard(
      BuildContext context,
      _AttendanceReportRow row,
      ) {
    final theme =
    Theme.of(context);

    final report = row.report;

    final statusColor =
    _statusColor(
      context,
      row,
    );

    final statusBackground =
    _statusBackground(
      context,
      row,
    );

    final shiftMinutes =
    report == null
        ? 0
        : _shiftWorkingMinutes(
      report,
    );

    final actualMinutes =
    report == null
        ? 0
        : _actualWorkingMinutes(
      report,
    );

    final hasWorkComparison =
        report != null &&
            shiftMinutes > 0 &&
            report.checkInTime != null &&
            report.checkOutTime != null;

    final actualIsLess =
        hasWorkComparison &&
            actualMinutes <
                shiftMinutes;

    final actualIsEnough =
        hasWorkComparison &&
            actualMinutes >=
                shiftMinutes;

    final overtimeMinutes =
    hasWorkComparison
        ? _calculateOvertime(
      shiftMinutes,
      actualMinutes,
    )
        : 0;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior:
      Clip.antiAlias,
      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(
          16,
        ),
        side: BorderSide(
          color: theme
              .colorScheme
              .outlineVariant
              .withValues(
            alpha: 0.55,
          ),
        ),
      ),
      child: Padding(
        padding:
        const EdgeInsets.fromLTRB(
          13,
          13,
          13,
          12,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            //=========================================================
            // DATE + STATUS
            //=========================================================

            Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        _dayName(row.date),
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: theme
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                          color: theme
                              .colorScheme
                              .onSurfaceVariant,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),

                      const SizedBox(
                        height: 2,
                      ),

                      Text(
                        '${_monthName(row.date)} '
                            '${row.date.day}, '
                            '${row.date.year}',
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: theme
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      // STATUS ONLY ONCE
                      Container(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration:
                        BoxDecoration(
                          color:
                          statusBackground,
                          borderRadius:
                          BorderRadius
                              .circular(
                            20,
                          ),
                        ),
                        child: Text(
                          row.status,
                          maxLines: 1,
                          overflow:
                          TextOverflow
                              .ellipsis,
                          style: theme
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                            color:
                            statusColor,
                            fontWeight:
                            FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            //=========================================================
            // IN / OUT
            //=========================================================

            Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Expanded(
                  child:
                  _buildTimeColumn(
                    context: context,
                    icon:
                    Icons.login_rounded,
                    title: 'In Time',
                    time:
                    _formatTime(
                      report?.checkInTime,
                    ),
                    location:
                    report
                        ?.checkInAddress,
                  ),
                ),

                const SizedBox(
                  width: 9,
                ),

                Expanded(
                  child:
                  _buildTimeColumn(
                    context: context,
                    icon:
                    Icons.logout_rounded,
                    title: 'Out Time',
                    time:
                    _formatTime(
                      report?.checkOutTime,
                    ),
                    location:
                    report
                        ?.checkOutAddress,
                  ),
                ),
              ],
            ),

            //=========================================================
            // WORK DURATION
            //=========================================================

            if (hasWorkComparison) ...[
              const SizedBox(
                height: 11,
              ),

              _buildWorkDurationSection(
                context: context,
                shiftMinutes:
                shiftMinutes,
                actualMinutes:
                actualMinutes,
                overtimeMinutes:
                overtimeMinutes,
                actualIsLess:
                actualIsLess,
                actualIsEnough:
                actualIsEnough,
              ),
            ],

            //=========================================================
            // LATE / EARLY
            //=========================================================

            if (report != null &&
                (report.lateMinutes > 0 ||
                    report
                        .earlyLeaveMinutes >
                        0)) ...[
              const SizedBox(
                height: 10,
              ),

              _buildAttentionInfo(
                context,
                report,
              ),
            ],
          ],
        ),
      ),
    );
  }

  //=================================================================
  // TIME COLUMN
  //=================================================================

  Widget _buildTimeColumn({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String time,
    required String? location,
  }) {
    final theme =
    Theme.of(context);

    final hasLocation =
        location != null &&
            location.trim().isNotEmpty;

    return Container(
      padding:
      const EdgeInsets.all(10),
      decoration:
      BoxDecoration(
        color: theme
            .colorScheme
            .surfaceContainerHighest
            .withValues(
          alpha: 0.45,
        ),
        borderRadius:
        BorderRadius.circular(11),
        border: Border.all(
          color: theme
              .colorScheme
              .outlineVariant
              .withValues(
            alpha: 0.35,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 19,
            color:
            theme.colorScheme
                .primary,
          ),

          const SizedBox(
            width: 7,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .labelSmall
                      ?.copyWith(
                    color: theme
                        .colorScheme
                        .onSurfaceVariant,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  time,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),

                // LOCATION UNDER TIME
                if (hasLocation) ...[
                  const SizedBox(
                    height: 3,
                  ),

                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Icon(
                        Icons
                            .location_on_outlined,
                        size: 13,
                        color: theme
                            .colorScheme
                            .onSurfaceVariant,
                      ),

                      const SizedBox(
                        width: 3,
                      ),

                      Expanded(
                        child: Text(
                          location!,
                          maxLines: 2,
                          overflow:
                          TextOverflow
                              .ellipsis,
                          style: theme
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                            color: theme
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  const SizedBox(
                    height: 3,
                  ),

                  Text(
                    '--',
                    maxLines: 1,
                    style: theme
                        .textTheme
                        .labelSmall
                        ?.copyWith(
                      color: theme
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  //=================================================================
  // WORK DURATION SECTION
  //=================================================================

  Widget _buildWorkDurationSection({
    required BuildContext context,
    required int shiftMinutes,
    required int actualMinutes,
    required int overtimeMinutes,
    required bool actualIsLess,
    required bool actualIsEnough,
  }) {
    final theme =
    Theme.of(context);

    final actualColor =
    actualIsLess
        ? theme.colorScheme.error
        : Colors.green.shade600;

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(10),
      decoration:
      BoxDecoration(
        color: theme
            .colorScheme
            .surfaceContainerHighest
            .withValues(
          alpha: 0.35,
        ),
        borderRadius:
        BorderRadius.circular(11),
        border: Border.all(
          color: theme
              .colorScheme
              .outlineVariant
              .withValues(
            alpha: 0.35,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            'Work Duration',
            style: theme
                .textTheme
                .labelLarge
                ?.copyWith(
              fontWeight:
              FontWeight.w800,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Row(
            children: [
              Expanded(
                child:
                _buildDurationItem(
                  context: context,
                  label:
                  'Shift WH',
                  value:
                  _formatDuration(
                    shiftMinutes,
                  ),
                  color: theme
                      .colorScheme
                      .onSurface,
                ),
              ),

              const SizedBox(
                width: 7,
              ),

              Expanded(
                child:
                _buildDurationItem(
                  context: context,
                  label:
                  'Actual AWH',
                  value:
                  _formatDuration(
                    actualMinutes,
                  ),
                  color:
                  actualColor,
                ),
              ),
            ],
          ),

          if (overtimeMinutes >
              0) ...[
            const SizedBox(
              height: 7,
            ),

            _buildDurationItem(
              context: context,
              label: 'Overtime',
              value:
              _formatDuration(
                overtimeMinutes,
              ),
              color:
              Colors.green.shade600,
              fullWidth: true,
            ),
          ],
        ],
      ),
    );
  }

  //=================================================================
  // DURATION ITEM
  //=================================================================

  Widget _buildDurationItem({
    required BuildContext context,
    required String label,
    required String value,
    required Color color,
    bool fullWidth = false,
  }) {
    final theme =
    Theme.of(context);

    return Container(
      width: fullWidth
          ? double.infinity
          : null,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration:
      BoxDecoration(
        color:
        theme.colorScheme.surface,
        borderRadius:
        BorderRadius.circular(9),
        border: Border.all(
          color: theme
              .colorScheme
              .outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style: theme
                  .textTheme
                  .labelSmall
                  ?.copyWith(
                color: theme
                    .colorScheme
                    .onSurfaceVariant,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(
            width: 6,
          ),

          Text(
            value,
            maxLines: 1,
            style: theme
                .textTheme
                .labelMedium
                ?.copyWith(
              color: color,
              fontWeight:
              FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  //=================================================================
  // ATTENTION INFO
  //=================================================================

  Widget _buildAttentionInfo(
      BuildContext context,
      MobileAttendanceReportEntity report,
      ) {
    final theme =
    Theme.of(context);

    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: [
        if (report.lateMinutes > 0)
          _buildInfoBadge(
            context: context,
            icon:
            Icons.schedule_outlined,
            text:
            'Late ${report.lateMinutes}m',
            color:
            theme.colorScheme.error,
          ),

        if (report.earlyLeaveMinutes >
            0)
          _buildInfoBadge(
            context: context,
            icon:
            Icons.logout_outlined,
            text:
            'Early Out ${report.earlyLeaveMinutes}m',
            color:
            theme.colorScheme.tertiary,
          ),
      ],
    );
  }

  //=================================================================
  // INFO BADGE
  //=================================================================

  Widget _buildInfoBadge({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color color,
  }) {
    final theme =
    Theme.of(context);

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration:
      BoxDecoration(
        color: color.withValues(
          alpha: 0.10,
        ),
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: color,
          ),

          const SizedBox(
            width: 5,
          ),

          Text(
            text,
            style: theme
                .textTheme
                .labelSmall
                ?.copyWith(
              color: color,
              fontWeight:
              FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}