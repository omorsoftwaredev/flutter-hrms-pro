// ============================================================================
// Flutter HRMS Pro
// Company Supervisor Today Mobile Attendance Report Page
//
// Version : 13.0.0
//
// Purpose:
// - Show today's mobile attendance report
// - Filter by company + supervisor + department
// - Show employee attendance
// - Show Check In / Check Out
// - Show Actual Time
// - Show Shift Start Time
// - Show Shift End Time
// - Show Check-in / Check-out Location
// - Calculate AH / WH / OT
// - Calculate Present / Absent / Late / Early Out
// - Calculate combined LATE + EARLY OUT
// - Handle OFF DAY / HOLIDAY / LEAVE
// - Material 3
// - Responsive Mobile / Tablet / Desktop
//
// SUMMARY STATUS RULE:
// - PRESENT
// - ABSENT
// - LATE
// - EARLY OUT
// - LATE + EARLY OUT
// - LEAVE
// - OFF DAY
// - HOLIDAY
//
// IMPORTANT:
// If employee is both LATE and EARLY OUT:
// - Do NOT count in Late
// - Do NOT count in Early Out
// - Count ONLY in Late + Early Out
//
// EXACT TIME FIELDS:
//   actualTime
//   shiftStartTime
//   shiftEndTime
//
// ATTENDANCE FIELDS:
//   checkInTime
//   checkOutTime
//   attendanceDate
//   checkInLocation
//   checkOutLocation
//   employeeName
//   employeeCode
//   attendanceStatus
//   graceInMinutes
//   graceOutMinutes
//   isAbsent
//
// NO candidate-field detection.
// NO raw JSON printing.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/providers/company_supervisor_mobile_attendance_report_provider.dart';

// ============================================================================
// PAGE
// ============================================================================

class TodayDetailsAttendanceReportPage
    extends ConsumerStatefulWidget {
  const TodayDetailsAttendanceReportPage({
    super.key,
    required this.companyId,
    required this.supervisorId,
    required this.supervisorName,
    required this.departmentId,
    required this.departmentName,
  });

  final String companyId;
  final String supervisorId;
  final String supervisorName;
  final String departmentId;
  final String departmentName;

  @override
  ConsumerState<TodayDetailsAttendanceReportPage> createState() =>
      _CompanySupervisorTodayAttendanceReportPageState();
}

// ============================================================================
// STATE
// ============================================================================

class _CompanySupervisorTodayAttendanceReportPageState
    extends ConsumerState<TodayDetailsAttendanceReportPage> {
  // ==========================================================================
  // INIT
  // ==========================================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTodayReport();
    });
  }

  // ==========================================================================
  // LOAD
  // ==========================================================================

  Future<void> _loadTodayReport() async {
    final provider = ref.read(companySupervisorMobileAttendanceReportProvider);

    await provider.loadTodayReports(
      companyId: widget.companyId,
      supervisorId: widget.supervisorId,
      departmentId: widget.departmentId,
    );
  }

  // ==========================================================================
  // REFRESH
  // ==========================================================================

  Future<void> _refresh() async {
    final provider = ref.read(companySupervisorMobileAttendanceReportProvider);

    await provider.refreshTodayReports(
      companyId: widget.companyId,
      supervisorId: widget.supervisorId,
      departmentId: widget.departmentId,
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(companySupervisorMobileAttendanceReportProvider);

    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Today Attendance'),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: provider.isBusy ? null : _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _buildBody(context, theme, provider),
      ),
    );
  }

  // ==========================================================================
  // BODY
  // ==========================================================================

  Widget _buildBody(
    BuildContext context,
    ThemeData theme,
    CompanySupervisorMobileAttendanceReportProvider provider,
  ) {
    if (provider.isLoading && !provider.hasTodayReports) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && !provider.hasTodayReports) {
      return _buildError(theme, provider.error!);
    }

    if (!provider.hasTodayReports) {
      return _buildEmpty(theme);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth >= 1000;
        final bool isTablet = constraints.maxWidth >= 650;

        final double horizontalPadding = isDesktop
            ? 28
            : isTablet
            ? 20
            : 12;

        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            12,
            horizontalPadding,
            30,
          ),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(theme, provider),
                    const SizedBox(height: 10),
                    _buildSummary(
                      theme,
                      provider,
                      isDesktop: isDesktop,
                      isTablet: isTablet,
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle(theme, provider.todayReports.length),
                    const SizedBox(height: 8),
                    if (isDesktop)
                      _buildDesktopList(theme, provider)
                    else
                      _buildMobileList(theme, provider),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================================
  // HEADER
  // ==========================================================================

  Widget _buildHeader(
    ThemeData theme,
    CompanySupervisorMobileAttendanceReportProvider provider,
  ) {
    final DateTime today = DateTime.now();

    final String dateText =
        '${today.day} ${_monthName(today.month)} ${today.year}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.surfaceContainerLow,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.fact_check_rounded,
              color: theme.colorScheme.onPrimary,
              size: 23,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today Attendance',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dateText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.supervisorName} • ${widget.departmentName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          if (provider.isRefreshing)
            const SizedBox(
              width: 19,
              height: 19,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SUMMARY
  //
  // IMPORTANT:
  //
  // If status = LATE + EARLY OUT:
  // - Late count = 0 for this employee
  // - Early Out count = 0 for this employee
  // - Late + Early Out count = 1
  //
  // This keeps the summary mutually exclusive.
  // ==========================================================================

  Widget _buildSummary(
      ThemeData theme,
      CompanySupervisorMobileAttendanceReportProvider provider, {
        required bool isDesktop,
        required bool isTablet,
      }) {
    final int total = provider.todayReports.length;

    final int present = _countStatus(provider, 'PRESENT');

    final int absent = _countStatus(provider, 'ABSENT');

    final int late = _countStatus(provider, 'LATE');

    final int earlyOut = _countStatus(provider, 'EARLY OUT');

    final int lateAndEarlyOut =
    _countStatus(provider, 'LATE + EARLY OUT');

    final int leave = _countStatus(provider, 'LEAVE');

    final int offDay = _countStatus(provider, 'OFF DAY');

    final int holiday = _countStatus(provider, 'HOLIDAY');

    final List<_SummaryItem> items = [
      _SummaryItem(
        title: 'Total',
        value: total,
        icon: Icons.groups_rounded,
        color: theme.colorScheme.primary,
      ),
      _SummaryItem(
        title: 'Present',
        value: present,
        icon: Icons.check_circle_rounded,
        color: theme.colorScheme.primary,
      ),
      _SummaryItem(
        title: 'Absent',
        value: absent,
        icon: Icons.cancel_rounded,
        color: theme.colorScheme.error,
      ),
      _SummaryItem(
        title: 'Late',
        value: late,
        icon: Icons.schedule_rounded,
        color: theme.colorScheme.tertiary,
      ),
      _SummaryItem(
        title: 'Early Out',
        value: earlyOut,
        icon: Icons.logout_rounded,
        color: theme.colorScheme.secondary,
      ),
      _SummaryItem(
        title: 'Late + Early Out',
        value: lateAndEarlyOut,
        icon: Icons.warning_amber_rounded,
        color: Colors.deepOrange,
      ),
      _SummaryItem(
        title: 'Leave',
        value: leave,
        icon: Icons.event_busy_rounded,
        color: theme.colorScheme.tertiary,
      ),
      _SummaryItem(
        title: 'Off Day',
        value: offDay,
        icon: Icons.weekend_rounded,
        color: theme.colorScheme.secondary,
      ),
      _SummaryItem(
        title: 'Holiday',
        value: holiday,
        icon: Icons.celebration_rounded,
        color: theme.colorScheme.tertiary,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ==================================================================
          // SUMMARY HEADER
          // ==================================================================

          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.analytics_rounded,
                  size: 18,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attendance Summary',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Today overview',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // --------------------------------------------------------------
              // EMPLOYEE COUNT
              // --------------------------------------------------------------

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.people_alt_rounded,
                      size: 14,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$total Employees',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          Divider(
            height: 1,
            color: theme.colorScheme.outlineVariant,
          ),

          const SizedBox(height: 11),

          // ==================================================================
          // COMPACT STATISTICS
          // ==================================================================

          LayoutBuilder(
            builder: (context, constraints) {
              final double width = constraints.maxWidth;

              final int columns;

              if (isDesktop) {
                columns = 5;
              } else if (isTablet) {
                columns = 3;
              } else if (width >= 500) {
                columns = 3;
              } else {
                columns = 2;
              }

              const double spacing = 7;

              final double itemWidth =
                  (width - ((columns - 1) * spacing)) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: items.map((item) {
                  return SizedBox(
                    width: itemWidth,
                    child: _buildSummaryItem(
                      theme,
                      item,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SUMMARY ITEM
  // ==========================================================================


  Widget _buildSummaryItem(
      ThemeData theme,
      _SummaryItem item,
      ) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 34,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          // ------------------------------------------------------------------
          // ICON
          // ------------------------------------------------------------------

          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              item.icon,
              size: 15,
              color: item.color,
            ),
          ),

          // ------------------------------------------------------------------
          // TEXT
          // ------------------------------------------------------------------

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${item.value}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    color: item.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SECTION TITLE
  // ==========================================================================

  Widget _buildSectionTitle(ThemeData theme, int count) {
    return Row(
      children: [
        Icon(
          Icons.people_alt_rounded,
          size: 19,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            'Attendance Details',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            '$count Employees',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // MOBILE LIST
  // ==========================================================================

  Widget _buildMobileList(
    ThemeData theme,
    CompanySupervisorMobileAttendanceReportProvider provider,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.todayReports.length,
      separatorBuilder: (_, __) {
        return const SizedBox(height: 10);
      },
      itemBuilder: (context, index) {
        return _buildAttendanceCard(theme, provider.todayReports[index], index);
      },
    );
  }

  // ==========================================================================
  // ATTENDANCE CARD
  // ==========================================================================

  Widget _buildAttendanceCard(ThemeData theme, dynamic report, int index) {
    final String status = _getCalculatedStatus(report);

    final Color statusColor = _getStatusColor(theme, status);

    final bool isAbsent =
        status.toLowerCase() == 'absent';

    final bool isHoliday =
        status.toLowerCase() == 'holiday';

    final bool isLeave =
        status.toLowerCase() == 'leave';

    final bool hideAttendanceDetails =
        isAbsent || isHoliday || isLeave;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            height: 4,
            color: statusColor,
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    _buildNumberAvatar(theme, index),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildEmployeeIdentity(
                        theme,
                        report,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                _buildStatusBadge(theme, report),

                // =====================================================
                // ABSENT / HOLIDAY / LEAVE হলে নিচের অংশ দেখাবে না
                // =====================================================

                if (!hideAttendanceDetails) ...[
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailCell(
                          theme,
                          icon: Icons.login_rounded,
                          label: 'Check In',
                          value: _getCheckInTime(report),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: _buildDetailCell(
                          theme,
                          icon: Icons.logout_rounded,
                          label: 'Check Out',
                          value: _getCheckOutTime(report),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  _buildActualWorkingOvertimeRow(
                    theme,
                    _getShiftStartTime(report),
                    _getShiftEndTime(report),
                    _getCheckInTime(report),
                    _getCheckOutTime(report),
                  ),

                  const SizedBox(height: 10),

                  _buildLocationSection(
                    theme,
                    report,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // COMPACT TIME ITEM
  // ==========================================================================

  Widget _buildCompactTimeItem(
    ThemeData theme, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: theme.colorScheme.primary),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // TIME DIVIDER
  // ==========================================================================

  Widget _buildTimeDivider(ThemeData theme) {
    return Container(
      width: 1,
      height: 29,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      color: theme.colorScheme.outlineVariant,
    );
  }

  // ==========================================================================
  // LOCATION SECTION
  // ==========================================================================

  Widget _buildLocationSection(ThemeData theme, dynamic report) {
    final String checkInAddress = _getCheckInLocation(report);
    final String checkOutAddress = _getCheckOutLocation(report);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 9, 12, 7),
            child: Row(
              children: [
                Container(
                  width: 31,
                  height: 31,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    size: 16,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Attendance Location',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
          _buildLocationRow(
            theme,
            label: 'Check-in Address',
            value: checkInAddress,
            icon: Icons.login_rounded,
            color: theme.colorScheme.primary,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Divider(height: 1, color: theme.colorScheme.outlineVariant),
          ),
          _buildLocationRow(
            theme,
            label: 'Check-out Address',
            value: checkOutAddress,
            icon: Icons.logout_rounded,
            color: theme.colorScheme.secondary,
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // LOCATION ROW
  // ==========================================================================

  Widget _buildLocationRow(
    ThemeData theme, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // NUMBER AVATAR
  // ==========================================================================

  Widget _buildNumberAvatar(ThemeData theme, int index) {
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${index + 1}',
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  // ==========================================================================
  // EMPLOYEE IDENTITY
  // ==========================================================================

  Widget _buildEmployeeIdentity(ThemeData theme, dynamic report) {
    final String name = _getEmployeeName(report);
    final String code = _getEmployeeCode(report);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        if (code.isNotEmpty) ...[
          const SizedBox(height: 3),
          Text(
            code,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  // ==========================================================================
  // DATE
  // ==========================================================================

  Widget _buildDateLine(ThemeData theme, dynamic report) {
    return Row(
      children: [
        Icon(
          Icons.calendar_month_rounded,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Text(
          _getAttendanceDate(report),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // DETAIL CELL
  // ==========================================================================

  Widget _buildDetailCell(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: theme.colorScheme.primary),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
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

  // ==========================================================================
  // STATUS BADGE
  // ==========================================================================

  Widget _buildStatusBadge(ThemeData theme, dynamic report) {
    final String status = _getCalculatedStatus(report);

    final Color color = _getStatusColor(theme, status);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 150),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color.withValues(alpha: 0.20)),
        ),
        child: Text(
          status.isEmpty ? 'UNKNOWN' : status,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // DESKTOP LIST
  // ==========================================================================

  Widget _buildDesktopList(
    ThemeData theme,
    CompanySupervisorMobileAttendanceReportProvider provider,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildDesktopHeader(theme),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.todayReports.length,
            separatorBuilder: (_, __) {
              return Divider(
                height: 1,
                color: theme.colorScheme.outlineVariant,
              );
            },
            itemBuilder: (context, index) {
              return _buildDesktopRow(
                theme,
                provider.todayReports[index],
                index,
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // DESKTOP HEADER
  // ==========================================================================

  Widget _buildDesktopHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      color: theme.colorScheme.surfaceContainerLow,
      child: Row(
        children: [
          const SizedBox(width: 42),
          const SizedBox(width: 12),
          Expanded(flex: 3, child: _tableHeader(theme, 'Employee')),
          Expanded(flex: 2, child: _tableHeader(theme, 'Status')),
          Expanded(flex: 2, child: _tableHeader(theme, 'Check In')),
          Expanded(flex: 2, child: _tableHeader(theme, 'Check Out')),
          Expanded(flex: 4, child: _tableHeader(theme, 'Actual / Shift')),
          Expanded(flex: 4, child: _tableHeader(theme, 'Check-in Address')),
          Expanded(flex: 4, child: _tableHeader(theme, 'Check-out Address')),
        ],
      ),
    );
  }

  // ==========================================================================
  // DESKTOP ROW
  // ==========================================================================

  Widget _buildDesktopRow(ThemeData theme, dynamic report, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          _buildNumberAvatar(theme, index),
          const SizedBox(width: 12),
          Expanded(flex: 3, child: _buildEmployeeIdentity(theme, report)),
          Expanded(flex: 2, child: _buildStatusBadge(theme, report)),
          Expanded(
            flex: 2,
            child: Text(
              _getCheckInTime(report),
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _getCheckOutTime(report),
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(flex: 4, child: _buildDesktopAttendanceTime(theme, report)),
          Expanded(
            flex: 4,
            child: _buildDesktopLocation(
              theme,
              _getCheckInLocation(report),
              Icons.login_rounded,
              theme.colorScheme.primary,
            ),
          ),
          Expanded(
            flex: 4,
            child: _buildDesktopLocation(
              theme,
              _getCheckOutLocation(report),
              Icons.logout_rounded,
              theme.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // DESKTOP ATTENDANCE TIME
  // ==========================================================================

  Widget _buildDesktopAttendanceTime(ThemeData theme, dynamic report) {
    final String actualTime = _getActualTime(report);
    final String shiftStartTime = _getShiftStartTime(report);
    final String shiftEndTime = _getShiftEndTime(report);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDesktopTimeValue(theme, 'Actual', actualTime),
        const SizedBox(height: 3),
        _buildDesktopTimeValue(
          theme,
          'Shift',
          '$shiftStartTime - $shiftEndTime',
        ),
      ],
    );
  }

  // ==========================================================================
  // DESKTOP TIME VALUE
  // ==========================================================================

  Widget _buildDesktopTimeValue(ThemeData theme, String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 45,
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // DESKTOP LOCATION
  // ==========================================================================

  Widget _buildDesktopLocation(
    ThemeData theme,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // COUNT STATUS
  //
  // IMPORTANT:
  //
  // This method is now MUTUALLY EXCLUSIVE.
  //
  // LATE + EARLY OUT does NOT contribute to:
  // - LATE
  // - EARLY OUT
  //
  // It contributes only to:
  // - LATE + EARLY OUT
  // ==========================================================================

  int _countStatus(
    CompanySupervisorMobileAttendanceReportProvider provider,
    String status,
  ) {
    int count = 0;

    final String normalizedStatus = _normalizeStatus(status);

    for (final dynamic report in provider.todayReports) {
      final String currentStatus = _getCalculatedStatus(report);

      if (currentStatus == normalizedStatus) {
        count++;
      }
    }

    return count;
  }

  // ==========================================================================
  // CALCULATED ATTENDANCE STATUS
  //
  // BUSINESS RULE
  //
  // 1. OFFDAY / OFF DAY -> OFF DAY
  // 2. HOLIDAY          -> HOLIDAY
  // 3. LEAVE            -> LEAVE
  // 4. isAbsent         -> ABSENT
  // 5. NO CHECK-IN + NO CHECK-OUT -> ABSENT
  // 6. Check-in exists  -> Present/Late calculation
  // 7. Check-out exists -> Early Out calculation
  //
  // COMBINED:
  //
  // isLate && isEarlyOut
  //       -> LATE + EARLY OUT
  //
  // This status is mutually exclusive with LATE and EARLY OUT.
  // ==========================================================================

  String _getCalculatedStatus(dynamic report) {
    try {
      final String sourceStatus = _normalizeStatus(report.attendanceStatus);

      // ----------------------------------------------------------------------
      // EXPLICIT NON-WORKING / SPECIAL STATUS
      // ----------------------------------------------------------------------

      if (_isOffDayStatus(sourceStatus)) {
        return 'OFF DAY';
      }

      if (sourceStatus == 'HOLIDAY') {
        return 'HOLIDAY';
      }

      if (sourceStatus == 'LEAVE') {
        return 'LEAVE';
      }

      // ----------------------------------------------------------------------
      // ABSENT FLAG
      // ----------------------------------------------------------------------

      if (report.isAbsent == true) {
        return 'ABSENT';
      }

      // ----------------------------------------------------------------------
      // PUNCHES
      // ----------------------------------------------------------------------

      final DateTime? checkIn = _toDateTime(report.checkInTime);

      final DateTime? checkOut = _toDateTime(report.checkOutTime);

      final bool hasCheckIn = checkIn != null;

      final bool hasCheckOut = checkOut != null;

      // ----------------------------------------------------------------------
      // NO PUNCH
      // ----------------------------------------------------------------------

      if (!hasCheckIn && !hasCheckOut) {
        return 'ABSENT';
      }

      // ----------------------------------------------------------------------
      // SHIFT
      // ----------------------------------------------------------------------

      final String shiftStart = _getShiftStartTime(report);

      final String shiftEnd = _getShiftEndTime(report);

      final int graceIn = _safeGrace(report.graceInMinutes);

      final int graceOut = _safeGrace(report.graceOutMinutes);

      final DateTime referenceDate = checkIn ?? checkOut ?? DateTime.now();

      final DateTime? shiftStartDate = _parseTimeAgainstDate(
        shiftStart,
        referenceDate,
      );

      final DateTime? shiftEndDate = _parseTimeAgainstDate(
        shiftEnd,
        checkOut ?? checkIn ?? referenceDate,
      );

      bool isLate = false;
      bool isEarlyOut = false;

      // ----------------------------------------------------------------------
      // LATE
      // ----------------------------------------------------------------------

      if (checkIn != null && shiftStartDate != null) {
        final DateTime allowedCheckIn = shiftStartDate.add(
          Duration(minutes: graceIn),
        );

        isLate = checkIn.isAfter(allowedCheckIn);
      }

      // ----------------------------------------------------------------------
      // EARLY OUT
      // ----------------------------------------------------------------------

      if (checkOut != null && shiftEndDate != null) {
        final DateTime allowedCheckOut = shiftEndDate.subtract(
          Duration(minutes: graceOut),
        );

        isEarlyOut = checkOut.isBefore(allowedCheckOut);
      }

      // ----------------------------------------------------------------------
      // COMBINED STATUS
      // ----------------------------------------------------------------------

      if (isLate && isEarlyOut) {
        return 'LATE + EARLY OUT';
      }

      if (isLate) {
        return 'LATE';
      }

      if (isEarlyOut) {
        return 'EARLY OUT';
      }

      // ----------------------------------------------------------------------
      // VALID PUNCH EXISTS
      // ----------------------------------------------------------------------

      return 'PRESENT';
    } catch (_) {
      // Never incorrectly show PRESENT if calculation fails.
      return 'ABSENT';
    }
  }

  // ==========================================================================
  // OFF DAY STATUS
  // ==========================================================================

  bool _isOffDayStatus(String status) {
    return status == 'OFFDAY' ||
        status == 'OFF DAY' ||
        status == 'WEEK OFF' ||
        status == 'WEEKOFF' ||
        status == 'WEEKEND' ||
        status == 'DAY OFF';
  }

  // ==========================================================================
  // NORMALIZE STATUS
  // ==========================================================================

  String _normalizeStatus(dynamic value) {
    if (value == null) {
      return '';
    }

    final String result = value.toString().trim().toUpperCase();

    if (result.isEmpty || result == 'NULL') {
      return '';
    }

    return result
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  // ==========================================================================
  // SAFE GRACE
  // ==========================================================================

  int _safeGrace(dynamic value) {
    if (value is int) {
      return value < 0 ? 0 : value;
    }

    if (value is num) {
      final int result = value.toInt();

      return result < 0 ? 0 : result;
    }

    final int result = int.tryParse(value?.toString() ?? '') ?? 0;

    return result < 0 ? 0 : result;
  }

  // ==========================================================================
  // STATUS COLOR
  // ==========================================================================

  Color _getStatusColor(ThemeData theme, String status) {
    switch (status.trim().toUpperCase()) {
      case 'PRESENT':
        return theme.colorScheme.primary;

      case 'ABSENT':
        return theme.colorScheme.error;

      case 'LATE':
        return theme.colorScheme.tertiary;

      case 'LATE + EARLY OUT':
        return Colors.deepOrange;

      case 'EARLY OUT':
        return theme.colorScheme.secondary;

      case 'LEAVE':
        return theme.colorScheme.secondary;

      case 'OFF DAY':
        return theme.colorScheme.secondary;

      case 'HOLIDAY':
        return theme.colorScheme.tertiary;

      default:
        return theme.colorScheme.outline;
    }
  }

  // ==========================================================================
  // EMPLOYEE NAME
  // ==========================================================================

  String _getEmployeeName(dynamic report) {
    try {
      final dynamic value = report.employeeName;

      if (value == null) {
        return 'Employee';
      }

      final String result = value.toString().trim();

      if (result.isEmpty || result.toLowerCase() == 'null') {
        return 'Employee';
      }

      return result;
    } catch (_) {
      return 'Employee';
    }
  }

  // ==========================================================================
  // EMPLOYEE CODE
  // ==========================================================================

  String _getEmployeeCode(dynamic report) {
    try {
      final dynamic value = report.employeeCode;

      if (value == null) {
        return '';
      }

      final String result = value.toString().trim();

      if (result.isEmpty || result.toLowerCase() == 'null') {
        return '';
      }

      return result;
    } catch (_) {
      return '';
    }
  }

  // ==========================================================================
  // ATTENDANCE DATE
  // ==========================================================================

  String _getAttendanceDate(dynamic report) {
    try {
      final dynamic value = report.attendanceDate;

      if (value == null) {
        return _formatDate(DateTime.now());
      }

      if (value is DateTime) {
        return _formatDate(value);
      }

      final String raw = value.toString().trim();

      if (raw.isEmpty || raw.toLowerCase() == 'null') {
        return _formatDate(DateTime.now());
      }

      final DateTime? parsed = DateTime.tryParse(raw);

      if (parsed != null) {
        return _formatDate(parsed);
      }

      return raw;
    } catch (_) {
      return _formatDate(DateTime.now());
    }
  }

  // ==========================================================================
  // CHECK IN
  // ==========================================================================

  String _getCheckInTime(dynamic report) {
    try {
      return _formatTimeValue(report.checkInTime);
    } catch (_) {
      return '--';
    }
  }

  // ==========================================================================
  // CHECK OUT
  // ==========================================================================

  String _getCheckOutTime(dynamic report) {
    try {
      return _formatTimeValue(report.checkOutTime);
    } catch (_) {
      return '--';
    }
  }

  // ==========================================================================
  // ACTUAL TIME
  // ==========================================================================

  String _getActualTime(dynamic report) {
    try {
      return _formatTimeValue(report.actualTime);
    } catch (_) {
      return '--';
    }
  }

  // ==========================================================================
  // SHIFT START
  // ==========================================================================

  String _getShiftStartTime(dynamic report) {
    try {
      return _formatTimeValue(report.shiftStartTime);
    } catch (_) {
      return '--';
    }
  }

  // ==========================================================================
  // SHIFT END
  // ==========================================================================

  String _getShiftEndTime(dynamic report) {
    try {
      return _formatTimeValue(report.shiftEndTime);
    } catch (_) {
      return '--';
    }
  }

  // ==========================================================================
  // CHECK-IN LOCATION
  // ==========================================================================

  String _getCheckInLocation(dynamic report) {
    try {
      return _formatTextValue(report.checkInLocation);
    } catch (_) {
      return '--';
    }
  }

  // ==========================================================================
  // CHECK-OUT LOCATION
  // ==========================================================================

  String _getCheckOutLocation(dynamic report) {
    try {
      return _formatTextValue(report.checkOutLocation);
    } catch (_) {
      return '--';
    }
  }

  // ==========================================================================
  // TEXT FORMAT
  // ==========================================================================

  String _formatTextValue(dynamic value) {
    if (value == null) {
      return '--';
    }

    final String result = value.toString().trim();

    if (result.isEmpty || result.toLowerCase() == 'null') {
      return '--';
    }

    return result;
  }

  // ==========================================================================
  // TIME FORMAT
  // ==========================================================================

  String _formatTimeValue(dynamic value) {
    if (value == null) {
      return '--';
    }

    if (value is DateTime) {
      return _formatTime(value);
    }

    final String raw = value.toString().trim();

    if (raw.isEmpty || raw.toLowerCase() == 'null') {
      return '--';
    }

    final DateTime? parsed = DateTime.tryParse(raw);

    if (parsed != null) {
      return _formatTime(parsed);
    }

    final RegExp timePattern = RegExp(r'^(\d{1,2}):(\d{2})(?::(\d{2}))?$');

    final Match? match = timePattern.firstMatch(raw);

    if (match != null) {
      final int hour = int.tryParse(match.group(1) ?? '') ?? -1;

      final int minute = int.tryParse(match.group(2) ?? '') ?? -1;

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return raw;
      }

      final DateTime time = DateTime(2026, 1, 1, hour, minute);

      return _formatTime(time);
    }

    return raw;
  }

  // ==========================================================================
  // FORMAT TIME
  // ==========================================================================

  String _formatTime(DateTime value) {
    final int hour = value.hour;

    final int minute = value.minute;

    final String period = hour >= 12 ? 'PM' : 'AM';

    final int displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  // ==========================================================================
  // TO DATETIME
  // ==========================================================================

  DateTime? _toDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    final String raw = value.toString().trim();

    if (raw.isEmpty || raw.toLowerCase() == 'null') {
      return null;
    }

    return DateTime.tryParse(raw);
  }

  // ==========================================================================
  // PARSE TIME AGAINST DATE
  // ==========================================================================

  DateTime? _parseTimeAgainstDate(String value, DateTime referenceDate) {
    if (value == '--' || value.trim().isEmpty) {
      return null;
    }

    final String raw = value.trim();

    final RegExp twelveHourPattern = RegExp(
      r'^(\d{1,2}):(\d{2})\s*(AM|PM)$',
      caseSensitive: false,
    );

    final Match? twelveMatch = twelveHourPattern.firstMatch(raw);

    if (twelveMatch != null) {
      int hour = int.tryParse(twelveMatch.group(1) ?? '') ?? -1;

      final int minute = int.tryParse(twelveMatch.group(2) ?? '') ?? -1;

      final String period = (twelveMatch.group(3) ?? '').toUpperCase();

      if (hour < 1 || hour > 12 || minute < 0 || minute > 59) {
        return null;
      }

      if (period == 'AM') {
        if (hour == 12) {
          hour = 0;
        }
      } else {
        if (hour != 12) {
          hour += 12;
        }
      }

      return DateTime(
        referenceDate.year,
        referenceDate.month,
        referenceDate.day,
        hour,
        minute,
      );
    }

    final RegExp twentyFourHourPattern = RegExp(
      r'^(\d{1,2}):(\d{2})(?::(\d{2}))?$',
    );

    final Match? twentyFourMatch = twentyFourHourPattern.firstMatch(raw);

    if (twentyFourMatch != null) {
      final int hour = int.tryParse(twentyFourMatch.group(1) ?? '') ?? -1;

      final int minute = int.tryParse(twentyFourMatch.group(2) ?? '') ?? -1;

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return null;
      }

      return DateTime(
        referenceDate.year,
        referenceDate.month,
        referenceDate.day,
        hour,
        minute,
      );
    }

    return null;
  }

  // ==========================================================================
  // FORMAT DATE
  // ==========================================================================

  String _formatDate(DateTime value) {
    return '${value.day} ${_monthName(value.month)} ${value.year}';
  }

  // ==========================================================================
  // TABLE HEADER
  // ==========================================================================

  Widget _tableHeader(ThemeData theme, String text) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  // ==========================================================================
  // ERROR
  // ==========================================================================

  Widget _buildError(ThemeData theme, String message) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 90),
        Icon(
          Icons.error_outline_rounded,
          size: 64,
          color: theme.colorScheme.error,
        ),
        const SizedBox(height: 18),
        Text(
          'Unable to load attendance',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 22),
        Center(
          child: FilledButton.icon(
            onPressed: _loadTodayReport,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // EMPTY
  // ==========================================================================

  Widget _buildEmpty(ThemeData theme) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 90),
        Icon(
          Icons.event_available_rounded,
          size: 68,
          color: theme.colorScheme.outline,
        ),
        const SizedBox(height: 18),
        Text(
          'No Attendance Records',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'No mobile attendance records were found for today.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 22),
        Center(
          child: OutlinedButton.icon(
            onPressed: _loadTodayReport,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Refresh'),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // MONTH
  // ==========================================================================

  String _monthName(int month) {
    const List<String> months = [
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

    if (month < 1 || month > 12) {
      return '';
    }

    return months[month - 1];
  }
}

// ============================================================================
// AH / WH / OT ROW
//
// AH = Shift Start -> Shift End
// WH = Check-in -> Check-out
// OT = WH - AH
// ============================================================================

Widget _buildActualWorkingOvertimeRow(
  ThemeData theme,
  String? shiftStartTime,
  String? shiftEndTime,
  String? checkInTime,
  String? checkOutTime,
) {
  final String actualHours = _calculateShiftDuration(
    shiftStartTime,
    shiftEndTime,
  );

  final String workingHours = _calculateAttendanceDuration(
    checkInTime,
    checkOutTime,
  );

  final String overtimeHours = _calculateOvertime(
    shiftStartTime,
    shiftEndTime,
    checkInTime,
    checkOutTime,
  );

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
    decoration: BoxDecoration(
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: theme.colorScheme.outlineVariant),
    ),
    child: Row(
      children: [
        Expanded(
          child: _buildCompactTimeItemGlobal(
            theme,
            label: 'AH',
            value: actualHours,
            icon: Icons.timer_outlined,
          ),
        ),
        _buildTimeDividerGlobal(theme),
        Expanded(
          child: _buildCompactTimeItemGlobal(
            theme,
            label: 'WH',
            value: workingHours,
            icon: Icons.work_history_outlined,
          ),
        ),
        _buildTimeDividerGlobal(theme),
        Expanded(
          child: _buildCompactTimeItemGlobal(
            theme,
            label: 'OT',
            value: overtimeHours,
            icon: Icons.more_time_rounded,
          ),
        ),
      ],
    ),
  );
}

// ============================================================================
// GLOBAL COMPACT TIME ITEM
// ============================================================================

Widget _buildCompactTimeItemGlobal(
  ThemeData theme, {
  required String label,
  required String value,
  required IconData icon,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.primary),
          const SizedBox(width: 3),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w900,
              fontSize: 10,
            ),
          ),
        ],
      ),
      const SizedBox(height: 3),
      Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w900,
          fontSize: 11,
        ),
      ),
    ],
  );
}

// ============================================================================
// GLOBAL DIVIDER
// ============================================================================

Widget _buildTimeDividerGlobal(ThemeData theme) {
  return Container(
    width: 1,
    height: 29,
    margin: const EdgeInsets.symmetric(horizontal: 3),
    color: theme.colorScheme.outlineVariant,
  );
}

// ============================================================================
// AH
// ============================================================================

String _calculateShiftDuration(String? startTime, String? endTime) {
  final DateTime? start = _parseTimeString(startTime);

  final DateTime? end = _parseTimeString(endTime);

  if (start == null || end == null) {
    return '--';
  }

  int minutes = end.difference(start).inMinutes;

  if (minutes < 0) {
    minutes += 24 * 60;
  }

  return _formatMinutes(minutes);
}

// ============================================================================
// WH
// ============================================================================

String _calculateAttendanceDuration(String? checkInTime, String? checkOutTime) {
  final DateTime? start = _parseTimeString(checkInTime);

  final DateTime? end = _parseTimeString(checkOutTime);

  if (start == null || end == null) {
    return '--';
  }

  int minutes = end.difference(start).inMinutes;

  if (minutes < 0) {
    minutes += 24 * 60;
  }

  return _formatMinutes(minutes);
}

// ============================================================================
// OT
// ============================================================================

String _calculateOvertime(
  String? shiftStartTime,
  String? shiftEndTime,
  String? checkInTime,
  String? checkOutTime,
) {
  final DateTime? shiftStart = _parseTimeString(shiftStartTime);

  final DateTime? shiftEnd = _parseTimeString(shiftEndTime);

  final DateTime? checkIn = _parseTimeString(checkInTime);

  final DateTime? checkOut = _parseTimeString(checkOutTime);

  if (shiftStart == null ||
      shiftEnd == null ||
      checkIn == null ||
      checkOut == null) {
    return '--';
  }

  int shiftMinutes = shiftEnd.difference(shiftStart).inMinutes;

  int attendanceMinutes = checkOut.difference(checkIn).inMinutes;

  if (shiftMinutes < 0) {
    shiftMinutes += 24 * 60;
  }

  if (attendanceMinutes < 0) {
    attendanceMinutes += 24 * 60;
  }

  final int overtimeMinutes = attendanceMinutes - shiftMinutes;

  if (overtimeMinutes <= 0) {
    return '0h';
  }

  return _formatMinutes(overtimeMinutes);
}

// ============================================================================
// PARSE TIME
// ============================================================================

DateTime? _parseTimeString(String? value) {
  if (value == null) {
    return null;
  }

  final String raw = value.trim();

  if (raw.isEmpty || raw == '--') {
    return null;
  }

  final RegExp twelveHourPattern = RegExp(
    r'^(\d{1,2}):(\d{2})\s*(AM|PM)$',
    caseSensitive: false,
  );

  final Match? twelveMatch = twelveHourPattern.firstMatch(raw);

  if (twelveMatch != null) {
    int hour = int.tryParse(twelveMatch.group(1) ?? '') ?? -1;

    final int minute = int.tryParse(twelveMatch.group(2) ?? '') ?? -1;

    final String period = (twelveMatch.group(3) ?? '').toUpperCase();

    if (hour < 1 || hour > 12 || minute < 0 || minute > 59) {
      return null;
    }

    if (period == 'AM') {
      if (hour == 12) {
        hour = 0;
      }
    } else {
      if (hour != 12) {
        hour += 12;
      }
    }

    return DateTime(2000, 1, 1, hour, minute);
  }

  final RegExp twentyFourHourPattern = RegExp(
    r'^(\d{1,2}):(\d{2})(?::(\d{2}))?$',
  );

  final Match? twentyFourMatch = twentyFourHourPattern.firstMatch(raw);

  if (twentyFourMatch != null) {
    final int hour = int.tryParse(twentyFourMatch.group(1) ?? '') ?? -1;

    final int minute = int.tryParse(twentyFourMatch.group(2) ?? '') ?? -1;

    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }

    return DateTime(2000, 1, 1, hour, minute);
  }

  return null;
}

// ============================================================================
// FORMAT MINUTES
// ============================================================================

String _formatMinutes(int totalMinutes) {
  if (totalMinutes <= 0) {
    return '0h';
  }

  final int hours = totalMinutes ~/ 60;

  final int minutes = totalMinutes % 60;

  if (minutes == 0) {
    return '${hours}h';
  }

  return '${hours}h ${minutes}m';
}

// ============================================================================
// SUMMARY MODEL
// ============================================================================

class _SummaryItem {
  const _SummaryItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final int value;
  final IconData icon;
  final Color color;
}
