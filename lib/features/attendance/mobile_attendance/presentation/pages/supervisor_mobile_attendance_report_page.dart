import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/supervisor_mobile_attendance_report_entity.dart';
import '../../domain/entities/supervisor_department_entity.dart';

import '../providers/supervisor_mobile_attendance_report_provider.dart';
import '../providers/supervisor_department_provider.dart';

//=================================================================
// SUPERVISOR MOBILE ATTENDANCE REPORT PAGE
//=================================================================
//
// FLOW:
//
// Supervisor
//     ↓
// Supervisor Attendance Report Page
//     ↓
// Load Assigned Departments
//     ↓
// Select Department
//     ↓
// Select Report Mode
//     ├── Today
//     └── Date Range
//     ↓
// Load Attendance Report
//
// IMPORTANT:
//
// departmentId is NOT passed through route.
//
// It is selected inside this page.
//=================================================================

class SupervisorMobileAttendanceReportPage extends ConsumerStatefulWidget {
  final String supervisorId;
  final String companyId;

  const SupervisorMobileAttendanceReportPage({
    super.key,
    required this.supervisorId,
    required this.companyId,
  });

  @override
  ConsumerState<SupervisorMobileAttendanceReportPage> createState() =>
      _SupervisorMobileAttendanceReportPageState();
}

//=================================================================
// REPORT MODE
//=================================================================

enum _SupervisorAttendanceReportMode { today, dateRange }

//=================================================================
// ATTENDANCE FILTER
//=================================================================

enum _SupervisorAttendanceFilter {
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

class _SupervisorAttendanceReportRow {
  final DateTime date;

  final SupervisorMobileAttendanceReportEntity? report;

  final bool isOffDay;

  final bool isAbsent;

  const _SupervisorAttendanceReportRow({
    required this.date,
    required this.report,
    required this.isOffDay,
    required this.isAbsent,
  });

  bool get hasAttendance => report != null;

  bool get isPresent => report?.isPresent ?? false;

  bool get isLate => report?.isLate ?? false;

  bool get isEarlyOut => report?.isEarlyOut ?? false;

  bool get isLeave => report?.attendanceStatus.trim().toUpperCase() == 'LEAVE';

  int get actualWorkMinutes => report?.actualWorkMinutes ?? 0;

  int get overtimeMinutes => report?.overtimeMinutes ?? 0;

  int get lateMinutes => report?.lateMinutes ?? 0;

  int get earlyLeaveMinutes => report?.earlyLeaveMinutes ?? 0;

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

class _SupervisorMobileAttendanceReportPageState
    extends ConsumerState<SupervisorMobileAttendanceReportPage> {
  late DateTime _fromDate;

  late DateTime _toDate;

  _SupervisorAttendanceReportMode _selectedMode =
      _SupervisorAttendanceReportMode.today;

  _SupervisorAttendanceFilter _selectedFilter = _SupervisorAttendanceFilter.all;

  //=================================================================
  // INIT
  //=================================================================

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    _fromDate = _dateOnly(now);

    _toDate = _dateOnly(now);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _loadSupervisorDepartments();
    });
  }

  //=================================================================
  // DATE ONLY
  //=================================================================

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  //=================================================================
  // LOAD SUPERVISOR DEPARTMENTS
  //=================================================================
  //
  // IMPORTANT:
  //
  // We load departments here.
  //
  // departmentId is NOT known before this.
  //=================================================================

  Future<void> _loadSupervisorDepartments() async {
    final departmentProvider = ref.read(supervisorDepartmentProvider);

    await departmentProvider.loadDepartments(
      supervisorId: widget.supervisorId,
      companyId: widget.companyId,
    );
  }

  //=================================================================
  // SELECT DEPARTMENT
  //=================================================================

  void _selectDepartment(SupervisorDepartmentEntity department) {
    final departmentProvider = ref.read(supervisorDepartmentProvider);

    departmentProvider.selectDepartment(department);

    setState(() {
      _selectedFilter = _SupervisorAttendanceFilter.all;
    });

    _loadReport();
  }

  //=================================================================
  // SELECT MODE
  //=================================================================

  void _selectMode(_SupervisorAttendanceReportMode mode) {
    final departmentProvider = ref.read(supervisorDepartmentProvider);

    if (departmentProvider.selectedDepartment == null) {
      _showDepartmentRequiredMessage();
      return;
    }

    setState(() {
      _selectedMode = mode;
      _selectedFilter = _SupervisorAttendanceFilter.all;
    });

    if (mode == _SupervisorAttendanceReportMode.today) {
      final today = _dateOnly(DateTime.now());

      setState(() {
        _fromDate = today;
        _toDate = today;
      });

      _loadReport();
      return;
    }

    if (mode == _SupervisorAttendanceReportMode.dateRange) {
      _loadReport();
    }
  }

  //=================================================================
  // SELECT CURRENT DAY
  //=================================================================

  void _selectToday() {
    final departmentProvider = ref.read(supervisorDepartmentProvider);

    if (departmentProvider.selectedDepartment == null) {
      _showDepartmentRequiredMessage();
      return;
    }

    final today = _dateOnly(DateTime.now());

    setState(() {
      _selectedMode = _SupervisorAttendanceReportMode.today;

      _fromDate = today;
      _toDate = today;

      _selectedFilter = _SupervisorAttendanceFilter.all;
    });

    _loadReport();
  }

  //=================================================================
  // SHOW DEPARTMENT REQUIRED
  //=================================================================

  void _showDepartmentRequiredMessage() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Please select a department first.')),
      );
  }

  //=================================================================
  // SELECT FROM DATE
  //=================================================================

  Future<void> _pickFromDate() async {
    final departmentProvider = ref.read(supervisorDepartmentProvider);

    if (departmentProvider.selectedDepartment == null) {
      _showDepartmentRequiredMessage();
      return;
    }

    final selected = await showDatePicker(
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
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('From date cannot be after To date.')),
        );

      return;
    }

    setState(() {
      _fromDate = _dateOnly(selected);
    });

    await _loadReport();
  }

  //=================================================================
  // SELECT TO DATE
  //=================================================================

  Future<void> _pickToDate() async {
    final departmentProvider = ref.read(supervisorDepartmentProvider);

    if (departmentProvider.selectedDepartment == null) {
      _showDepartmentRequiredMessage();
      return;
    }

    final selected = await showDatePicker(
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
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('To date cannot be before From date.')),
        );

      return;
    }

    setState(() {
      _toDate = _dateOnly(selected);
    });

    await _loadReport();
  }

  //=================================================================
  // LOAD REPORT
  //=================================================================
  //
  // Department must be selected first.
  //=================================================================

  Future<void> _loadReport() async {
    final departmentProvider = ref.read(supervisorDepartmentProvider);

    final selectedDepartment = departmentProvider.selectedDepartment;

    if (selectedDepartment == null) {
      return;
    }

    final departmentId = selectedDepartment.departmentId;

    if (departmentId.trim().isEmpty) {
      return;
    }

    await ref
        .read(supervisorMobileAttendanceReportProvider)
        .loadReportsAndSummary(
          supervisorId: widget.supervisorId,
          departmentId: departmentId,
          startDate: _fromDate,
          endDate: _toDate,
        );
  }

  //=================================================================
  // REFRESH
  //=================================================================

  Future<void> _refresh() async {
    final departmentProvider = ref.read(supervisorDepartmentProvider);

    final selectedDepartment = departmentProvider.selectedDepartment;

    if (selectedDepartment == null) {
      await _loadSupervisorDepartments();
      return;
    }

    await ref
        .read(supervisorMobileAttendanceReportProvider)
        .refresh(
          supervisorId: widget.supervisorId,
          departmentId: selectedDepartment.departmentId,
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
  // FORMAT SHORT DATE
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
    return date.weekday == DateTime.friday || date.weekday == DateTime.saturday;
  }

  //=================================================================
  // BUILD DATES
  //=================================================================

  List<DateTime> _buildDates() {
    final dates = <DateTime>[];

    var current = _dateOnly(_fromDate);

    final end = _dateOnly(_toDate);

    while (!current.isAfter(end)) {
      dates.add(current);

      current = current.add(const Duration(days: 1));
    }

    return dates;
  }

  //=================================================================
  // BUILD ROWS
  //=================================================================

  List<_SupervisorAttendanceReportRow> _buildRows(
    List<SupervisorMobileAttendanceReportEntity> reports,
  ) {
    final rows = <_SupervisorAttendanceReportRow>[];

    final groupedByDate =
        <String, List<SupervisorMobileAttendanceReportEntity>>{};

    for (final report in reports) {
      final key = _dateKey(report.attendanceDate);

      groupedByDate.putIfAbsent(key, () => []);

      groupedByDate[key]!.add(report);
    }

    for (final date in _buildDates()) {
      final key = _dateKey(date);

      final dateReports = groupedByDate[key];

      if (dateReports == null || dateReports.isEmpty) {
        final weekend = _isWeekend(date);

        rows.add(
          _SupervisorAttendanceReportRow(
            date: date,
            report: null,
            isOffDay: weekend,
            isAbsent: !weekend,
          ),
        );

        continue;
      }

      for (final report in dateReports) {
        final offDay = report.isHoliday || !report.isWorkingDay;

        rows.add(
          _SupervisorAttendanceReportRow(
            date: date,
            report: report,
            isOffDay: offDay,
            isAbsent: report.isAbsent,
          ),
        );
      }
    }

    return rows;
  }

  //=================================================================
  // FILTER ROWS
  //=================================================================

  List<_SupervisorAttendanceReportRow> _filterRows(
    List<_SupervisorAttendanceReportRow> rows,
  ) {
    switch (_selectedFilter) {
      case _SupervisorAttendanceFilter.all:
        return rows;

      case _SupervisorAttendanceFilter.present:
        return rows.where((row) {
          if (row.report == null) {
            return false;
          }

          if (row.isOffDay || row.isAbsent || row.isLeave) {
            return false;
          }

          return row.isPresent && !row.isLate && !row.isEarlyOut;
        }).toList();

      case _SupervisorAttendanceFilter.late:
        return rows.where((row) => row.isLate).toList();

      case _SupervisorAttendanceFilter.earlyOut:
        return rows.where((row) => row.isEarlyOut).toList();

      case _SupervisorAttendanceFilter.absent:
        return rows.where((row) => row.isAbsent && !row.isOffDay).toList();

      case _SupervisorAttendanceFilter.offDay:
        return rows.where((row) => row.isOffDay).toList();

      case _SupervisorAttendanceFilter.leave:
        return rows.where((row) => row.isLeave).toList();
    }
  }

  //=================================================================
  // FILTER LABEL
  //=================================================================

  String _filterLabel(_SupervisorAttendanceFilter filter) {
    switch (filter) {
      case _SupervisorAttendanceFilter.all:
        return 'All';

      case _SupervisorAttendanceFilter.present:
        return 'Present';

      case _SupervisorAttendanceFilter.late:
        return 'Late';

      case _SupervisorAttendanceFilter.earlyOut:
        return 'Early Out';

      case _SupervisorAttendanceFilter.absent:
        return 'Absent';

      case _SupervisorAttendanceFilter.offDay:
        return 'Off Day';

      case _SupervisorAttendanceFilter.leave:
        return 'Leave';
    }
  }

  //=================================================================
  // FILTER ICON
  //=================================================================

  IconData _filterIcon(_SupervisorAttendanceFilter filter) {
    switch (filter) {
      case _SupervisorAttendanceFilter.all:
        return Icons.dashboard_outlined;

      case _SupervisorAttendanceFilter.present:
        return Icons.check_circle_outline;

      case _SupervisorAttendanceFilter.late:
        return Icons.schedule_outlined;

      case _SupervisorAttendanceFilter.earlyOut:
        return Icons.logout_outlined;

      case _SupervisorAttendanceFilter.absent:
        return Icons.cancel_outlined;

      case _SupervisorAttendanceFilter.offDay:
        return Icons.weekend_outlined;

      case _SupervisorAttendanceFilter.leave:
        return Icons.event_busy_outlined;
    }
  }

  //=================================================================
  // STATUS COLOR
  //=================================================================

  Color _statusColor(BuildContext context, _SupervisorAttendanceReportRow row) {
    final scheme = Theme.of(context).colorScheme;

    if (row.isOffDay) {
      return scheme.secondary;
    }

    if (row.isAbsent) {
      return scheme.error;
    }

    if (row.isLeave) {
      return scheme.tertiary;
    }

    if (row.isLate && row.isEarlyOut) {
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
    _SupervisorAttendanceReportRow row,
  ) {
    return _statusColor(context, row).withValues(alpha: 0.10);
  }

  //=================================================================
  // TIME TO MINUTES
  //=================================================================

  int _timeToMinutes(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 0;
    }

    final parts = value.trim().split(':');

    if (parts.length < 2) {
      return 0;
    }

    final hour = int.tryParse(parts[0]) ?? 0;

    final minute = int.tryParse(parts[1]) ?? 0;

    return hour * 60 + minute;
  }

  //=================================================================
  // SHIFT WORKING MINUTES
  //=================================================================

  int _shiftWorkingMinutes(SupervisorMobileAttendanceReportEntity report) {
    final start = _timeToMinutes(report.shiftStartTime);

    final end = _timeToMinutes(report.shiftEndTime);

    if (start <= 0 || end <= 0) {
      return 0;
    }

    if (end >= start) {
      return end - start;
    }

    return (24 * 60 - start) + end;
  }

  //=================================================================
  // ACTUAL WORKING MINUTES
  //=================================================================

  int _actualWorkingMinutes(SupervisorMobileAttendanceReportEntity report) {
    final checkIn = report.checkInTime;

    final checkOut = report.checkOutTime;

    if (checkIn == null || checkOut == null) {
      return 0;
    }

    final difference = checkOut.difference(checkIn).inMinutes;

    return difference < 0 ? 0 : difference;
  }

  //=================================================================
  // OVERTIME
  //=================================================================

  int _calculateOvertime(int shiftMinutes, int actualMinutes) {
    if (shiftMinutes <= 0 || actualMinutes <= shiftMinutes) {
      return 0;
    }

    return actualMinutes - shiftMinutes;
  }

  //=================================================================
  // FORMAT DURATION
  //=================================================================

  String _formatDuration(int minutes) {
    if (minutes <= 0) {
      return '0h 0m';
    }

    final hours = minutes ~/ 60;

    final mins = minutes % 60;

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

  String _formatTime(DateTime? value) {
    if (value == null) {
      return '--';
    }

    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;

    final minute = value.minute.toString().padLeft(2, '0');

    final period = value.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  //=================================================================
  // BUILD
  //=================================================================

  @override
  Widget build(BuildContext context) {
    final reportProvider = ref.watch(supervisorMobileAttendanceReportProvider);

    final departmentProvider = ref.watch(supervisorDepartmentProvider);

    final selectedDepartment = departmentProvider.selectedDepartment;

    final rows = _buildRows(reportProvider.reports);

    final filteredRows = _filterRows(rows);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervisor Attendance Report'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: reportProvider.isBusy || departmentProvider.isLoading
                ? null
                : _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            final maxWidth = width >= 1200
                ? 1100.0
                : width >= 700
                ? 900.0
                : double.infinity;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  children: [
                    //=================================================
                    // DEPARTMENT SELECTOR
                    //=================================================
                    _buildDepartmentSelector(context, departmentProvider),

                    //=================================================
                    // REPORT MODE
                    //=================================================
                    _buildReportModeSelector(
                      context,
                      selectedDepartment,
                      reportProvider,
                    ),

                    //=================================================
                    // DATE RANGE
                    //=================================================
                    if (_selectedMode ==
                        _SupervisorAttendanceReportMode.dateRange)
                      _buildDateSelector(
                        context,
                        reportProvider,
                        selectedDepartment,
                      ),

                    //=================================================
                    // SUMMARY
                    //=================================================
                    if (selectedDepartment != null)
                      _buildSummary(context, reportProvider),

                    //=================================================
                    // FILTER
                    //=================================================
                    if (selectedDepartment != null) _buildFilters(context),

                    if (reportProvider.isLoading)
                      const LinearProgressIndicator(minHeight: 2),

                    if (departmentProvider.isLoading)
                      const LinearProgressIndicator(minHeight: 2),

                    if (departmentProvider.error != null)
                      _buildDepartmentError(context, departmentProvider.error!),

                    if (reportProvider.error != null)
                      _buildError(context, reportProvider.error!),

                    //=================================================
                    // REPORT LIST
                    //=================================================
                    Expanded(
                      child: selectedDepartment == null
                          ? _buildDepartmentEmptyState(context)
                          : RefreshIndicator(
                              onRefresh: _refresh,
                              child: filteredRows.isEmpty
                                  ? _buildEmptyState(context)
                                  : ListView.separated(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      padding: const EdgeInsets.fromLTRB(
                                        12,
                                        10,
                                        12,
                                        32,
                                      ),
                                      itemCount: filteredRows.length,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 10),
                                      itemBuilder: (context, index) {
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
  // DEPARTMENT SELECTOR
  //=================================================================

  Widget _buildDepartmentSelector(
    BuildContext context,
    SupervisorDepartmentProvider provider,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'Select Department',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  if (provider.isLoading)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              if (!provider.isLoading && provider.departments.isEmpty)
                Text(
                  'No departments are assigned to this supervisor.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              else
                DropdownButtonFormField<SupervisorDepartmentEntity>(
                  value: provider.selectedDepartment,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Department',
                    prefixIcon: const Icon(Icons.account_tree_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: provider.filteredDepartments.map((department) {
                    return DropdownMenuItem<SupervisorDepartmentEntity>(
                      value: department,
                      child: Text(
                        '${department.departmentName} '
                        '(${department.departmentCode})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: provider.isLoading
                      ? null
                      : (department) {
                          if (department == null) {
                            return;
                          }

                          _selectDepartment(department);
                        },
                ),
            ],
          ),
        ),
      ),
    );
  }

  //=================================================================
  // REPORT MODE SELECTOR
  //=================================================================

  Widget _buildReportModeSelector(
    BuildContext context,
    SupervisorDepartmentEntity? selectedDepartment,
    SupervisorMobileAttendanceReportProvider provider,
  ) {
    final theme = Theme.of(context);

    final departmentSelected = selectedDepartment != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 5),
      child: SegmentedButton<_SupervisorAttendanceReportMode>(
        segments: const [
          ButtonSegment<_SupervisorAttendanceReportMode>(
            value: _SupervisorAttendanceReportMode.today,
            icon: Icon(Icons.today_outlined),
            label: Text('Today'),
          ),
          ButtonSegment<_SupervisorAttendanceReportMode>(
            value: _SupervisorAttendanceReportMode.dateRange,
            icon: Icon(Icons.date_range_outlined),
            label: Text('Date Range'),
          ),
        ],
        selected: {_selectedMode},
        onSelectionChanged: provider.isBusy || !departmentSelected
            ? null
            : (selection) {
                if (selection.isEmpty) {
                  return;
                }

                _selectMode(selection.first);
              },
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          textStyle: WidgetStatePropertyAll(
            theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  //=================================================================
  // DATE SELECTOR
  //=================================================================

  Widget _buildDateSelector(
    BuildContext context,
    SupervisorMobileAttendanceReportProvider provider,
    SupervisorDepartmentEntity? selectedDepartment,
  ) {
    if (selectedDepartment == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 7, 12, 6),
      child: Row(
        children: [
          Expanded(
            child: _buildDateButton(
              context: context,
              label: 'From',
              date: _fromDate,
              onTap: provider.isBusy ? null : _pickFromDate,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildDateButton(
              context: context,
              label: 'To',
              date: _toDate,
              onTap: provider.isBusy ? null : _pickToDate,
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
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '$label ${_formatShortDate(date)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
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
  // SUMMARY
  //=================================================================

  Widget _buildSummary(
    BuildContext context,
    SupervisorMobileAttendanceReportProvider provider,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 7, 12, 5),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'Attendance Summary',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryItem(
                      context,
                      label: 'Total',
                      value: provider.totalReportCount.toString(),
                      icon: Icons.people_outline,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: _buildSummaryItem(
                      context,
                      label: 'Present',
                      value: provider.presentCount.toString(),
                      icon: Icons.check_circle_outline,
                      color: Colors.green.shade600,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: _buildSummaryItem(
                      context,
                      label: 'Absent',
                      value: provider.absentCount.toString(),
                      icon: Icons.cancel_outlined,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryItem(
                      context,
                      label: 'Late',
                      value: provider.lateCount.toString(),
                      icon: Icons.schedule_outlined,
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: _buildSummaryItem(
                      context,
                      label: 'Early Out',
                      value: provider.earlyOutCount.toString(),
                      icon: Icons.logout_outlined,
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: _buildSummaryItem(
                      context,
                      label: 'Leave',
                      value: provider.leaveCount.toString(),
                      icon: Icons.event_busy_outlined,
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //=================================================================
  // SUMMARY ITEM
  //=================================================================

  Widget _buildSummaryItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: color),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //=================================================================
  // FILTERS
  //=================================================================

  Widget _buildFilters(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        itemCount: _SupervisorAttendanceFilter.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 7),
        itemBuilder: (context, index) {
          final filter = _SupervisorAttendanceFilter.values[index];

          final selected = filter == _selectedFilter;

          return ChoiceChip(
            selected: selected,
            avatar: Icon(_filterIcon(filter), size: 16),
            label: Text(_filterLabel(filter)),
            labelStyle: TextStyle(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
            side: BorderSide(color: theme.colorScheme.outlineVariant),
            onSelected: (_) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          );
        },
      ),
    );
  }

  //=================================================================
  // DEPARTMENT EMPTY STATE
  //=================================================================

  Widget _buildDepartmentEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 360,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_tree_outlined,
                    size: 52,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Select a Department',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Please select a department first to view attendance.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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
  // DEPARTMENT ERROR
  //=================================================================

  Widget _buildDepartmentError(BuildContext context, String error) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: scheme.onErrorContainer, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: scheme.onErrorContainer),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {
              ref.read(supervisorDepartmentProvider).clearError();
            },
            icon: Icon(Icons.close, color: scheme.onErrorContainer, size: 19),
          ),
        ],
      ),
    );
  }

  //=================================================================
  // ERROR
  //=================================================================

  Widget _buildError(BuildContext context, String error) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: scheme.onErrorContainer, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: scheme.onErrorContainer),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {
              ref.read(supervisorMobileAttendanceReportProvider).clearError();
            },
            icon: Icon(Icons.close, color: scheme.onErrorContainer, size: 19),
          ),
        ],
      ),
    );
  }

  //=================================================================
  // EMPTY STATE
  //=================================================================

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 360,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy_outlined,
                    size: 52,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'No attendance records',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'No records match the selected filter or date range.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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
    _SupervisorAttendanceReportRow row,
  ) {
    final theme = Theme.of(context);

    final report = row.report;

    final statusColor = _statusColor(context, row);

    final statusBackground = _statusBackground(context, row);

    final shiftMinutes = report == null ? 0 : _shiftWorkingMinutes(report);

    final actualMinutes = report == null ? 0 : _actualWorkingMinutes(report);

    final hasWorkComparison =
        report != null &&
        shiftMinutes > 0 &&
        report.checkInTime != null &&
        report.checkOutTime != null;

    final actualIsLess = hasWorkComparison && actualMinutes < shiftMinutes;

    final actualIsEnough = hasWorkComparison && actualMinutes >= shiftMinutes;

    final overtimeMinutes = hasWorkComparison
        ? _calculateOvertime(shiftMinutes, actualMinutes)
        : 0;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13, 13, 13, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: theme.colorScheme.primaryContainer,
                            backgroundImage:
                                report?.employeeProfilePhoto != null &&
                                    report!.employeeProfilePhoto!
                                        .trim()
                                        .isNotEmpty
                                ? NetworkImage(report.employeeProfilePhoto!)
                                : null,
                            child:
                                report?.employeeProfilePhoto == null ||
                                    report!.employeeProfilePhoto!.trim().isEmpty
                                ? Icon(
                                    Icons.person_outline,
                                    size: 20,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  report?.employeeName?.trim().isNotEmpty ==
                                          true
                                      ? report!.employeeName!
                                      : 'Employee',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                if (report?.employeeCode?.trim().isNotEmpty ==
                                    true)
                                  Text(
                                    report!.employeeCode!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _dayName(row.date),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_monthName(row.date)} '
                        '${row.date.day}, '
                        '${row.date.year}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          row.status,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (report != null &&
                (report.departmentName != null ||
                    report.designationName != null ||
                    report.shiftName != null)) ...[
              const SizedBox(height: 11),
              _buildEmployeeInfo(context, report),
            ],
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildTimeColumn(
                    context: context,
                    icon: Icons.login_rounded,
                    title: 'In Time',
                    time: _formatTime(report?.checkInTime),
                    location: report?.checkInAddress,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _buildTimeColumn(
                    context: context,
                    icon: Icons.logout_rounded,
                    title: 'Out Time',
                    time: _formatTime(report?.checkOutTime),
                    location: report?.checkOutAddress,
                  ),
                ),
              ],
            ),
            if (hasWorkComparison) ...[
              const SizedBox(height: 11),
              _buildWorkDurationSection(
                context: context,
                shiftMinutes: shiftMinutes,
                actualMinutes: actualMinutes,
                overtimeMinutes: overtimeMinutes,
                actualIsLess: actualIsLess,
                actualIsEnough: actualIsEnough,
              ),
            ],
            if (report != null &&
                (report.lateMinutes > 0 || report.earlyLeaveMinutes > 0)) ...[
              const SizedBox(height: 10),
              _buildAttentionInfo(context, report),
            ],
          ],
        ),
      ),
    );
  }

  //=================================================================
  // EMPLOYEE INFO
  //=================================================================

  Widget _buildEmployeeInfo(
    BuildContext context,
    SupervisorMobileAttendanceReportEntity report,
  ) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: [
        if (report.departmentName != null &&
            report.departmentName!.trim().isNotEmpty)
          _buildInfoBadge(
            context: context,
            icon: Icons.business_outlined,
            text: report.departmentName!,
            color: theme.colorScheme.primary,
          ),
        if (report.designationName != null &&
            report.designationName!.trim().isNotEmpty)
          _buildInfoBadge(
            context: context,
            icon: Icons.badge_outlined,
            text: report.designationName!,
            color: theme.colorScheme.secondary,
          ),
        if (report.shiftName != null && report.shiftName!.trim().isNotEmpty)
          _buildInfoBadge(
            context: context,
            icon: Icons.schedule_outlined,
            text: report.shiftName!,
            color: theme.colorScheme.tertiary,
          ),
      ],
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
    final theme = Theme.of(context);

    final hasLocation = location != null && location.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.45,
        ),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: theme.colorScheme.primary),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (hasLocation) ...[
                  const SizedBox(height: 3),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          location!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  const SizedBox(height: 3),
                  Text(
                    '--',
                    maxLines: 1,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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
  // WORK DURATION
  //=================================================================

  Widget _buildWorkDurationSection({
    required BuildContext context,
    required int shiftMinutes,
    required int actualMinutes,
    required int overtimeMinutes,
    required bool actualIsLess,
    required bool actualIsEnough,
  }) {
    final theme = Theme.of(context);

    final actualColor = actualIsLess
        ? theme.colorScheme.error
        : Colors.green.shade600;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.35,
        ),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Work Duration',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDurationItem(
                  context: context,
                  label: 'Shift WH',
                  value: _formatDuration(shiftMinutes),
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _buildDurationItem(
                  context: context,
                  label: 'Actual AWH',
                  value: _formatDuration(actualMinutes),
                  color: actualColor,
                ),
              ),
            ],
          ),
          if (overtimeMinutes > 0) ...[
            const SizedBox(height: 7),
            _buildDurationItem(
              context: context,
              label: 'Overtime',
              value: _formatDuration(overtimeMinutes),
              color: Colors.green.shade600,
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
    final theme = Theme.of(context);

    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            maxLines: 1,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
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
    SupervisorMobileAttendanceReportEntity report,
  ) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: [
        if (report.lateMinutes > 0)
          _buildInfoBadge(
            context: context,
            icon: Icons.schedule_outlined,
            text: 'Late ${report.lateMinutes}m',
            color: theme.colorScheme.error,
          ),
        if (report.earlyLeaveMinutes > 0)
          _buildInfoBadge(
            context: context,
            icon: Icons.logout_outlined,
            text: 'Early Out ${report.earlyLeaveMinutes}m',
            color: theme.colorScheme.tertiary,
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
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 5),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
