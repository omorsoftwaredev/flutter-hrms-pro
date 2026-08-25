// ============================================================================
// Flutter HRMS Pro
// Company Supervisor Datewise Mobile Attendance Report Page
//
// Version : Final
//
// Scope:
// - Company
// - Supervisor
// - Department
// - Selected Employee
// - Date Range
//
// IMPORTANT:
// This page does NOT modify the supervisor-scoped implementation.
//
// Report loading:
// - Provider loads company + supervisor + department date-range reports.
// - This page filters the loaded reports by widget.employeeId.
// - Therefore existing provider method signature remains unchanged.
//
// STATUS:
// - PRESENT
// - ABSENT
// - LATE
// - EARLY OUT
// - LATE + EARLY OUT
// - LEAVE
// - OFF DAY
// - HOLIDAY
//
// IMPORTANT STATUS RULE:
// If employee is both LATE and EARLY OUT:
// - Late count = 0
// - Early Out count = 0
// - Late + Early Out count = 1
//
// EXACT TIME FIELDS:
// - actualTime
// - shiftStartTime
// - shiftEndTime
//
// ATTENDANCE FIELDS:
// - checkInTime
// - checkOutTime
// - attendanceDate
// - checkInLocation
// - checkOutLocation
// - employeeName
// - employeeCode
// - attendanceStatus
// - graceInMinutes
// - graceOutMinutes
// - isAbsent
//
// NO candidate-field detection.
// NO raw JSON printing.
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/company_supervisor_mobile_attendance_report_entity.dart';
import '../providers/company_supervisor_mobile_attendance_report_provider.dart';

// ============================================================================
// PAGE
// ============================================================================

class DatewiseDetailsAttendanceReportPage extends ConsumerStatefulWidget {
  const DatewiseDetailsAttendanceReportPage({
    super.key,
    required this.companyId,
    required this.supervisorId,
    required this.supervisorName,
    required this.departmentId,
    required this.departmentName,
    required this.fromDate,
    required this.toDate,
  });

  final String companyId;
  final String supervisorId;
  final String supervisorName;

  final String departmentId;
  final String departmentName;



  final DateTime fromDate;
  final DateTime toDate;

  @override
  ConsumerState<DatewiseDetailsAttendanceReportPage> createState() =>
      _DatewiseDetailsAttendanceReportPageState();
}

// ============================================================================
// STATE
// ============================================================================

class _DatewiseDetailsAttendanceReportPageState
    extends ConsumerState<DatewiseDetailsAttendanceReportPage> {

  String? employeeId;
  String? employeeName;
  // ==========================================================================
  // INIT
  // ==========================================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReport();
    });
  }

  // ==========================================================================
  // LOAD REPORT
  // ==========================================================================

  Future<void> _loadReport() async {
    final provider =
    ref.read(companySupervisorMobileAttendanceReportProvider);

    await provider.loadReportsByDateRange(
      companyId: widget.companyId,
      supervisorId: widget.supervisorId,
      startDate: widget.fromDate,
      endDate: widget.toDate,
      departmentId: widget.departmentId,
    );
  }

  // ==========================================================================
  // REFRESH
  // ==========================================================================

  Future<void> _refresh() async {
    final provider =
    ref.read(companySupervisorMobileAttendanceReportProvider);

    await provider.loadReportsByDateRange(
      companyId: widget.companyId,
      supervisorId: widget.supervisorId,
      startDate: widget.fromDate,
      endDate: widget.toDate,
      departmentId: widget.departmentId,
    );
  }

  // ==========================================================================
  // SELECTED EMPLOYEE REPORTS
  //
  // Provider returns department-level records.
  // This page displays only the selected employee.
  //
  // We intentionally use the entity's employeeId directly.
  // ==========================================================================

  List<CompanySupervisorMobileAttendanceReportEntity>
  _getSelectedEmployeeReports(
      CompanySupervisorMobileAttendanceReportProvider provider,
      ) {
    return provider.reports;
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final provider =
    ref.watch(companySupervisorMobileAttendanceReportProvider);

    final ThemeData theme =
    Theme.of(context);

    final List<CompanySupervisorMobileAttendanceReportEntity> reports =
    _getSelectedEmployeeReports(provider);

    return Scaffold(
      backgroundColor:
      theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Datewise Attendance',
        ),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed:
            provider.isBusy
                ? null
                : _refresh,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _buildBody(
          context,
          theme,
          provider,
          reports,
        ),
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
      List<CompanySupervisorMobileAttendanceReportEntity> reports,
      ) {
    if (provider.isLoading &&
        !provider.hasReports) {
      return ListView(
        physics:
        AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 180),
          Center(
            child:
            CircularProgressIndicator(),
          ),
        ],
      );
    }

    if (provider.error != null &&
        !provider.hasReports) {
      return _buildError(
        theme,
        provider.error!,
      );
    }

    if (provider.hasReports &&
        reports.isEmpty &&
        !provider.isLoading) {
      return _buildNoEmployeeRecords(
        theme,
      );
    }

    if (reports.isEmpty) {
      return _buildEmpty(
        theme,
      );
    }

    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final bool isDesktop =
            constraints.maxWidth >= 1000;

        final bool isTablet =
            constraints.maxWidth >= 650;

        final double horizontalPadding =
        isDesktop
            ? 28
            : isTablet
            ? 20
            : 12;

        return ListView(
          physics:
          const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            12,
            horizontalPadding,
            30,
          ),
          children: [
            Center(
              child: ConstrainedBox(
                constraints:
                const BoxConstraints(
                  maxWidth: 1400,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(
                      theme,
                      provider,
                    ),
                    const SizedBox(height: 10),
                    _buildDateRangeInfo(
                      theme,
                    ),
                    const SizedBox(height: 10),
                    _buildSummary(
                      theme,
                      reports,
                      isDesktop:
                      isDesktop,
                      isTablet:
                      isTablet,
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle(
                      theme,
                      reports.length,
                    ),
                    const SizedBox(height: 8),
                    if (isDesktop)
                      _buildDesktopList(
                        theme,
                        reports,
                      )
                    else
                      _buildMobileList(
                        theme,
                        reports,
                      ),
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
    return Container(
      padding:
      const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.surfaceContainerLow,
          ],
          begin:
          Alignment.topLeft,
          end:
          Alignment.bottomRight,
        ),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color:
          theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration:
            BoxDecoration(
              color:
              theme.colorScheme.primary,
              borderRadius:
              BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.date_range_rounded,
              color:
              theme.colorScheme.onPrimary,
              size: 23,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Datewise Attendance',
                  style: theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_formatDate(widget.fromDate)} - '
                      '${_formatDate(widget.toDate)}',
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: theme
                        .colorScheme
                        .onSurfaceVariant,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                      '${widget.departmentName}',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .labelMedium
                      ?.copyWith(
                    color: theme
                        .colorScheme
                        .primary,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          if (provider.isRefreshing)
            const SizedBox(
              width: 19,
              height: 19,
              child:
              CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
        ],
      ),
    );
  }

  // ==========================================================================
  // EMPLOYEE INFO
  // ==========================================================================
  //
  // Widget _buildEmployeeInfo(
  //     ThemeData theme,
  //     List<CompanySupervisorMobileAttendanceReportEntity> reports,
  //     ) {
  //   final String employeeCode =
  //   reports.isNotEmpty
  //       ? _getEmployeeCode(
  //     reports.first,
  //   )
  //       : '';
  //
  //   return Container(
  //     padding:
  //     const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color:
  //       theme.colorScheme.surfaceContainerLow,
  //       borderRadius:
  //       BorderRadius.circular(16),
  //       border: Border.all(
  //         color:
  //         theme.colorScheme.outlineVariant,
  //       ),
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 38,
  //           height: 38,
  //           decoration:
  //           BoxDecoration(
  //             color:
  //             theme.colorScheme.primaryContainer,
  //             borderRadius:
  //             BorderRadius.circular(11),
  //           ),
  //           child: Icon(
  //             Icons.person_rounded,
  //             size: 20,
  //             color: theme
  //                 .colorScheme
  //                 .onPrimaryContainer,
  //           ),
  //         ),
  //         const SizedBox(width: 9),
  //       ],
  //     ),
  //   );
  // }

  // ==========================================================================
  // DATE RANGE INFO
  // ==========================================================================

  Widget _buildDateRangeInfo(
      ThemeData theme,
      ) {
    final int days =
        _dateRangeDays;

    return Container(
      padding:
      const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
        theme.colorScheme.surfaceContainerLow,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color:
          theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration:
            BoxDecoration(
              color:
              theme.colorScheme.primaryContainer,
              borderRadius:
              BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.calendar_month_rounded,
              size: 18,
              color: theme
                  .colorScheme
                  .onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Date Range',
                  style: theme
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  '${_formatDate(widget.fromDate)} → '
                      '${_formatDate(widget.toDate)}',
                  style: theme
                      .textTheme
                      .labelSmall
                      ?.copyWith(
                    color: theme
                        .colorScheme
                        .onSurfaceVariant,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 6,
            ),
            decoration:
            BoxDecoration(
              color:
              theme.colorScheme.primaryContainer,
              borderRadius:
              BorderRadius.circular(30),
            ),
            child: Text(
              '$days Day${days == 1 ? '' : 's'}',
              style: theme
                  .textTheme
                  .labelSmall
                  ?.copyWith(
                color: theme
                    .colorScheme
                    .onPrimaryContainer,
                fontWeight:
                FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // DATE RANGE DAYS
  // ==========================================================================

  int get _dateRangeDays {
    final DateTime start =
    DateTime(
      widget.fromDate.year,
      widget.fromDate.month,
      widget.fromDate.day,
    );

    final DateTime end =
    DateTime(
      widget.toDate.year,
      widget.toDate.month,
      widget.toDate.day,
    );

    final int days =
        end.difference(start).inDays + 1;

    return days < 1
        ? 1
        : days;
  }

  // ==========================================================================
  // SUMMARY
  // ==========================================================================

  Widget _buildSummary(
      ThemeData theme,
      List<CompanySupervisorMobileAttendanceReportEntity>
      reports, {
        required bool isDesktop,
        required bool isTablet,
      }) {
    final int total =
        reports.length;

    final int present =
    _countStatus(
      reports,
      'PRESENT',
    );

    final int absent =
    _countStatus(
      reports,
      'ABSENT',
    );

    final int late =
    _countStatus(
      reports,
      'LATE',
    );

    final int earlyOut =
    _countStatus(
      reports,
      'EARLY OUT',
    );

    final int lateAndEarlyOut =
    _countStatus(
      reports,
      'LATE + EARLY OUT',
    );

    final int leave =
    _countStatus(
      reports,
      'LEAVE',
    );

    final int offDay =
    _countStatus(
      reports,
      'OFF DAY',
    );

    final int holiday =
    _countStatus(
      reports,
      'HOLIDAY',
    );

    final List<_SummaryItem> items = [
      _SummaryItem(
        title: 'Total',
        value: total,
        icon:
        Icons.groups_rounded,
        color:
        theme.colorScheme.primary,
      ),
      _SummaryItem(
        title: 'Present',
        value: present,
        icon:
        Icons.check_circle_rounded,
        color:
        theme.colorScheme.primary,
      ),
      _SummaryItem(
        title: 'Absent',
        value: absent,
        icon:
        Icons.cancel_rounded,
        color:
        theme.colorScheme.error,
      ),
      _SummaryItem(
        title: 'Late',
        value: late,
        icon:
        Icons.schedule_rounded,
        color:
        theme.colorScheme.tertiary,
      ),
      _SummaryItem(
        title: 'Early Out',
        value: earlyOut,
        icon:
        Icons.logout_rounded,
        color:
        theme.colorScheme.secondary,
      ),
      _SummaryItem(
        title: 'Late + Early Out',
        value: lateAndEarlyOut,
        icon:
        Icons.warning_amber_rounded,
        color:
        Colors.deepOrange,
      ),
      _SummaryItem(
        title: 'Leave',
        value: leave,
        icon:
        Icons.event_busy_rounded,
        color:
        theme.colorScheme.tertiary,
      ),
      _SummaryItem(
        title: 'Off Day',
        value: offDay,
        icon:
        Icons.weekend_rounded,
        color:
        theme.colorScheme.secondary,
      ),
      _SummaryItem(
        title: 'Holiday',
        value: holiday,
        icon:
        Icons.celebration_rounded,
        color:
        theme.colorScheme.tertiary,
      ),
    ];

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
        theme.colorScheme.surfaceContainerLow,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color:
          theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration:
                BoxDecoration(
                  color:
                  theme.colorScheme.primaryContainer,
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.analytics_rounded,
                  size: 18,
                  color: theme
                      .colorScheme
                      .onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attendance Summary',
                      style: theme
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                        fontWeight:
                        FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Selected dept date range overview',
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
                  ],
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration:
                BoxDecoration(
                  color:
                  theme.colorScheme.primaryContainer,
                  borderRadius:
                  BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    Icon(
                      Icons
                          .assignment_turned_in_rounded,
                      size: 14,
                      color: theme
                          .colorScheme
                          .onPrimaryContainer,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$total Records',
                      style: theme
                          .textTheme
                          .labelSmall
                          ?.copyWith(
                        color: theme
                            .colorScheme
                            .onPrimaryContainer,
                        fontWeight:
                        FontWeight.w900,
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
            color:
            theme.colorScheme.outlineVariant,
          ),
          const SizedBox(height: 11),
          LayoutBuilder(
            builder:
                (context, constraints) {
              final double width =
                  constraints.maxWidth;

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
                  (width -
                      ((columns - 1) *
                          spacing)) /
                      columns;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children:
                items.map((item) {
                  return SizedBox(
                    width:
                    itemWidth,
                    child:
                    _buildSummaryItem(
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
      constraints:
      const BoxConstraints(
        minHeight: 34,
      ),
      padding:
      const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 8,
      ),
      decoration:
      BoxDecoration(
        color:
        theme.colorScheme.surface,
        borderRadius:
        BorderRadius.circular(11),
        border: Border.all(
          color:
          theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration:
            BoxDecoration(
              color:
              item.color.withValues(
                alpha: 0.10,
              ),
              borderRadius:
              BorderRadius.circular(8),
            ),
            child: Icon(
              item.icon,
              size: 15,
              color: item.color,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    item.title,
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
                      FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  '${item.value}',
                  style: theme
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w900,
                    fontSize: 12,
                    color:
                    item.color,
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

  Widget _buildSectionTitle(
      ThemeData theme,
      int count,
      ) {
    return Row(
      children: [
        Icon(
          Icons.people_alt_rounded,
          size: 19,
          color:
          theme.colorScheme.primary,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            'Attendance Details',
            style: theme
                .textTheme
                .titleMedium
                ?.copyWith(
              fontWeight:
              FontWeight.w900,
            ),
          ),
        ),
        Container(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 4,
          ),
          decoration:
          BoxDecoration(
            color:
            theme.colorScheme.primaryContainer,
            borderRadius:
            BorderRadius.circular(30),
          ),
          child: Text(
            '$count Records',
            style: theme
                .textTheme
                .labelSmall
                ?.copyWith(
              color: theme
                  .colorScheme
                  .onPrimaryContainer,
              fontWeight:
              FontWeight.w800,
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
      List<CompanySupervisorMobileAttendanceReportEntity>
      reports,
      ) {
    return ListView.separated(
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),
      itemCount: reports.length,
      separatorBuilder:
          (_, __) =>
      const SizedBox(
        height: 10,
      ),
      itemBuilder:
          (context, index) {
        return _buildAttendanceCard(
          theme,
          reports[index],
          index,
        );
      },
    );
  }

  // ==========================================================================
  // ATTENDANCE CARD
  // ==========================================================================

  Widget _buildAttendanceCard(
      ThemeData theme,
      CompanySupervisorMobileAttendanceReportEntity
      report,
      int index,
      ) {
    final String status =
    _getCalculatedStatus(
      report,
    );

    final Color statusColor =
    _getStatusColor(
      theme,
      status,
    );

    final bool hideAttendanceDetails =
        status == 'ABSENT' ||
            status == 'HOLIDAY' ||
            status == 'LEAVE' ||
            status == 'OFF DAY';

    return Container(
      decoration:
      BoxDecoration(
        color:
        theme.colorScheme.surface,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color:
          theme.colorScheme.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: theme
                .colorScheme
                .shadow
                .withValues(
              alpha: 0.04,
            ),
            blurRadius: 12,
            offset:
            const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior:
      Clip.antiAlias,
      child: Column(
        children: [
          Container(
            height: 4,
            color: statusColor,
          ),
          Padding(
            padding:
            const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    _buildNumberAvatar(
                      theme,
                      index,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child:
                      _buildEmployeeIdentity(
                        theme,
                        report,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                _buildDateLine(
                  theme,
                  report,
                ),
                const SizedBox(
                  height: 12,
                ),
                _buildStatusBadge(
                  theme,
                  report,
                ),
                if (!hideAttendanceDetails) ...[
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:
                        _buildDetailCell(
                          theme,
                          icon:
                          Icons.login_rounded,
                          label:
                          'Check In',
                          value:
                          _getCheckInTime(
                            report,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child:
                        _buildDetailCell(
                          theme,
                          icon:
                          Icons.logout_rounded,
                          label:
                          'Check Out',
                          value:
                          _getCheckOutTime(
                            report,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildActualWorkingOvertimeRow(
                    theme,
                    _getShiftStartTime(
                      report,
                    ),
                    _getShiftEndTime(
                      report,
                    ),
                    _getCheckInTime(
                      report,
                    ),
                    _getCheckOutTime(
                      report,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildTimeInformation(
                    theme,
                    report,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
  // TIME INFORMATION
  // ==========================================================================

  Widget _buildTimeInformation(
      ThemeData theme,
      CompanySupervisorMobileAttendanceReportEntity
      report,
      ) {
    return Container(
      padding:
      const EdgeInsets.all(10),
      decoration:
      BoxDecoration(
        color:
        theme.colorScheme.surfaceContainerLow,
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color:
          theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          _buildInfoLine(
            theme,
            'Actual Time',
            _getActualTime(
              report,
            ),
            Icons.timer_rounded,
          ),
          const SizedBox(
            height: 7,
          ),
          _buildInfoLine(
            theme,
            'Shift Start',
            _getShiftStartTime(
              report,
            ),
            Icons.login_rounded,
          ),
          const SizedBox(
            height: 7,
          ),
          _buildInfoLine(
            theme,
            'Shift End',
            _getShiftEndTime(
              report,
            ),
            Icons.logout_rounded,
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // INFO LINE
  // ==========================================================================

  Widget _buildInfoLine(
      ThemeData theme,
      String label,
      String value,
      IconData icon,
      ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color:
          theme.colorScheme.primary,
        ),
        const SizedBox(width: 7),
        SizedBox(
          width: 85,
          child: Text(
            label,
            style: theme
                .textTheme
                .labelSmall
                ?.copyWith(
              color: theme
                  .colorScheme
                  .onSurfaceVariant,
              fontWeight:
              FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              fontWeight:
              FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // LOCATION SECTION
  // ==========================================================================

  Widget _buildLocationSection(
      ThemeData theme,
      CompanySupervisorMobileAttendanceReportEntity
      report,
      ) {
    return Container(
      decoration:
      BoxDecoration(
        color:
        theme.colorScheme.surfaceContainerLow,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color:
          theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding:
            const EdgeInsets.fromLTRB(
              12,
              9,
              12,
              7,
            ),
            child: Row(
              children: [
                Container(
                  width: 31,
                  height: 31,
                  decoration:
                  BoxDecoration(
                    color: theme
                        .colorScheme
                        .secondaryContainer,
                    borderRadius:
                    BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    size: 16,
                    color: theme
                        .colorScheme
                        .onSecondaryContainer,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    'Attendance Location',
                    style: theme
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                      fontWeight:
                      FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color:
            theme.colorScheme.outlineVariant,
          ),
          _buildLocationRow(
            theme,
            label:
            'Check-in Address',
            value:
            _getCheckInLocation(
              report,
            ),
            icon:
            Icons.login_rounded,
            color:
            theme.colorScheme.primary,
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Divider(
              height: 1,
              color:
              theme.colorScheme.outlineVariant,
            ),
          ),
          _buildLocationRow(
            theme,
            label:
            'Check-out Address',
            value:
            _getCheckOutLocation(
              report,
            ),
            icon:
            Icons.logout_rounded,
            color:
            theme.colorScheme.secondary,
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
      padding:
      const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 31,
            height: 31,
            decoration:
            BoxDecoration(
              color:
              color.withValues(
                alpha: 0.10,
              ),
              borderRadius:
              BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme
                      .textTheme
                      .labelSmall
                      ?.copyWith(
                    color: theme
                        .colorScheme
                        .onSurfaceVariant,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  value,
                  maxLines: 4,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w700,
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

  Widget _buildNumberAvatar(
      ThemeData theme,
      int index,
      ) {
    return Container(
      width: 38,
      height: 38,
      alignment:
      Alignment.center,
      decoration:
      BoxDecoration(
        color:
        theme.colorScheme.primaryContainer,
        borderRadius:
        BorderRadius.circular(12),
      ),
      child: Text(
        '${index + 1}',
        style: theme
            .textTheme
            .labelMedium
            ?.copyWith(
          color: theme
              .colorScheme
              .onPrimaryContainer,
          fontWeight:
          FontWeight.w900,
        ),
      ),
    );
  }

  // ==========================================================================
  // EMPLOYEE IDENTITY
  // ==========================================================================

  Widget _buildEmployeeIdentity(
      ThemeData theme,
      CompanySupervisorMobileAttendanceReportEntity
      report,
      ) {
    final String? name =
    _getEmployeeName(report);

    final String code =
    _getEmployeeCode(report);

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          name!,
          maxLines: 1,
          overflow:
          TextOverflow.ellipsis,
          style: theme
              .textTheme
              .titleSmall
              ?.copyWith(
            fontWeight:
            FontWeight.w900,
          ),
        ),
        if (code.isNotEmpty) ...[
          const SizedBox(height: 3),
          Text(
            code,
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
        ],
      ],
    );
  }

  // ==========================================================================
  // DATE LINE
  // ==========================================================================

  Widget _buildDateLine(
      ThemeData theme,
      CompanySupervisorMobileAttendanceReportEntity
      report,
      ) {
    return Row(
      children: [
        Icon(
          Icons.calendar_month_rounded,
          size: 16,
          color: theme
              .colorScheme
              .onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Text(
          _getAttendanceDate(report),
          style: theme
              .textTheme
              .labelSmall
              ?.copyWith(
            color: theme
                .colorScheme
                .onSurfaceVariant,
            fontWeight:
            FontWeight.w700,
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
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      decoration:
      BoxDecoration(
        color:
        theme.colorScheme.surface,
        borderRadius:
        BorderRadius.circular(11),
        border: Border.all(
          color:
          theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 17,
            color:
            theme.colorScheme.primary,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .labelSmall
                      ?.copyWith(
                    fontSize: 9,
                    color: theme
                        .colorScheme
                        .onSurfaceVariant,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w900,
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

  Widget _buildStatusBadge(
      ThemeData theme,
      CompanySupervisorMobileAttendanceReportEntity
      report,
      ) {
    final String status =
    _getCalculatedStatus(report);

    final Color color =
    _getStatusColor(
      theme,
      status,
    );

    return Center(
      child: Container(
        constraints:
        const BoxConstraints(
          maxWidth: 190,
        ),
        padding:
        const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 6,
        ),
        decoration:
        BoxDecoration(
          color:
          color.withValues(
            alpha: 0.10,
          ),
          borderRadius:
          BorderRadius.circular(30),
          border: Border.all(
            color:
            color.withValues(
              alpha: 0.20,
            ),
          ),
        ),
        child: Text(
          status.isEmpty
              ? 'UNKNOWN'
              : status,
          maxLines: 1,
          overflow:
          TextOverflow.ellipsis,
          style: theme
              .textTheme
              .labelSmall
              ?.copyWith(
            color: color,
            fontWeight:
            FontWeight.w900,
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
      List<CompanySupervisorMobileAttendanceReportEntity>
      reports,
      ) {
    return Container(
      decoration:
      BoxDecoration(
        color:
        theme.colorScheme.surface,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color:
          theme.colorScheme.outlineVariant,
        ),
      ),
      clipBehavior:
      Clip.antiAlias,
      child: Column(
        children: [
          _buildDesktopHeader(
            theme,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(),
            itemCount:
            reports.length,
            separatorBuilder:
                (_, __) {
              return Divider(
                height: 1,
                color: theme
                    .colorScheme
                    .outlineVariant,
              );
            },
            itemBuilder:
                (context, index) {
              return _buildDesktopRow(
                theme,
                reports[index],
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

  Widget _buildDesktopHeader(
      ThemeData theme,
      ) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 13,
      ),
      color:
      theme.colorScheme.surfaceContainerLow,
      child: Row(
        children: [
          const SizedBox(
            width: 42,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            flex: 3,
            child: _tableHeader(
              theme,
              'Employee',
            ),
          ),
          Expanded(
            flex: 2,
            child: _tableHeader(
              theme,
              'Date',
            ),
          ),
          Expanded(
            flex: 2,
            child: _tableHeader(
              theme,
              'Status',
            ),
          ),
          Expanded(
            flex: 2,
            child: _tableHeader(
              theme,
              'Check In',
            ),
          ),
          Expanded(
            flex: 2,
            child: _tableHeader(
              theme,
              'Check Out',
            ),
          ),
          Expanded(
            flex: 4,
            child: _tableHeader(
              theme,
              'Actual / Shift',
            ),
          ),
          Expanded(
            flex: 4,
            child: _tableHeader(
              theme,
              'Check-in Address',
            ),
          ),
          Expanded(
            flex: 4,
            child: _tableHeader(
              theme,
              'Check-out Address',
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // DESKTOP ROW
  // ==========================================================================

  Widget _buildDesktopRow(
      ThemeData theme,
      CompanySupervisorMobileAttendanceReportEntity
      report,
      int index,
      ) {
    final String status =
    _getCalculatedStatus(
      report,
    );

    final bool hideAttendanceDetails =
        status == 'ABSENT' ||
            status == 'HOLIDAY' ||
            status == 'LEAVE' ||
            status == 'OFF DAY';

    return Padding(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 13,
      ),
      child: Row(
        children: [
          _buildNumberAvatar(
            theme,
            index,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            flex: 3,
            child:
            _buildEmployeeIdentity(
              theme,
              report,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _getAttendanceDate(
                report,
              ),
              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child:
            _buildStatusBadge(
              theme,
              report,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              hideAttendanceDetails
                  ? '--'
                  : _getCheckInTime(
                report,
              ),
              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              hideAttendanceDetails
                  ? '--'
                  : _getCheckOutTime(
                report,
              ),
              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child:
            hideAttendanceDetails
                ? const Text('--')
                : _buildDesktopAttendanceTime(
              theme,
              report,
            ),
          ),
          Expanded(
            flex: 4,
            child:
            hideAttendanceDetails
                ? const Text('--')
                : _buildDesktopLocation(
              theme,
              _getCheckInLocation(
                report,
              ),
              Icons.login_rounded,
              theme.colorScheme.primary,
            ),
          ),
          Expanded(
            flex: 4,
            child:
            hideAttendanceDetails
                ? const Text('--')
                : _buildDesktopLocation(
              theme,
              _getCheckOutLocation(
                report,
              ),
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

  Widget _buildDesktopAttendanceTime(
      ThemeData theme,
      CompanySupervisorMobileAttendanceReportEntity
      report,
      ) {
    final String actualTime =
    _getActualTime(report);

    final String shiftStartTime =
    _getShiftStartTime(report);

    final String shiftEndTime =
    _getShiftEndTime(report);

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _buildDesktopTimeValue(
          theme,
          'Actual',
          actualTime,
        ),
        const SizedBox(height: 3),
        _buildDesktopTimeValue(
          theme,
          'Shift',
          '$shiftStartTime - '
              '$shiftEndTime',
        ),
      ],
    );
  }

  // ==========================================================================
  // DESKTOP TIME VALUE
  // ==========================================================================

  Widget _buildDesktopTimeValue(
      ThemeData theme,
      String label,
      String value,
      ) {
    return Row(
      children: [
        SizedBox(
          width: 45,
          child: Text(
            label,
            style: theme
                .textTheme
                .labelSmall
                ?.copyWith(
              color: theme
                  .colorScheme
                  .primary,
              fontWeight:
              FontWeight.w900,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              fontWeight:
              FontWeight.w800,
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
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            maxLines: 3,
            overflow:
            TextOverflow.ellipsis,
            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              color: theme
                  .colorScheme
                  .onSurfaceVariant,
              fontWeight:
              FontWeight.w600,
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
  // MUTUALLY EXCLUSIVE.
  // ==========================================================================

  int _countStatus(
      List<CompanySupervisorMobileAttendanceReportEntity>
      reports,
      String status,
      ) {
    final String normalizedStatus =
    _normalizeStatus(status);

    int count = 0;

    for (final report in reports) {
      final String currentStatus =
      _getCalculatedStatus(
        report,
      );

      if (currentStatus ==
          normalizedStatus) {
        count++;
      }
    }

    return count;
  }

  // ==========================================================================
  // CALCULATED STATUS
  // ==========================================================================

  String _getCalculatedStatus(
      CompanySupervisorMobileAttendanceReportEntity
      report,
      ) {
    try {
      final String sourceStatus =
      _normalizeStatus(
        report.attendanceStatus,
      );

      // ----------------------------------------------------------------------
      // OFF DAY
      // ----------------------------------------------------------------------

      if (_isOffDayStatus(
        sourceStatus,
      )) {
        return 'OFF DAY';
      }

      // ----------------------------------------------------------------------
      // HOLIDAY
      // ----------------------------------------------------------------------

      if (sourceStatus ==
          'HOLIDAY') {
        return 'HOLIDAY';
      }

      // ----------------------------------------------------------------------
      // LEAVE
      // ----------------------------------------------------------------------

      if (sourceStatus ==
          'LEAVE') {
        return 'LEAVE';
      }

      // ----------------------------------------------------------------------
      // ABSENT
      // ----------------------------------------------------------------------

      if (report.isAbsent ==
          true) {
        return 'ABSENT';
      }

      final DateTime? checkIn =
      _toDateTime(
        report.checkInTime,
      );

      final DateTime? checkOut =
      _toDateTime(
        report.checkOutTime,
      );

      final bool hasCheckIn =
          checkIn != null;

      final bool hasCheckOut =
          checkOut != null;

      if (!hasCheckIn &&
          !hasCheckOut) {
        return 'ABSENT';
      }

      // ----------------------------------------------------------------------
      // SHIFT
      // ----------------------------------------------------------------------

      final String shiftStart =
      _getShiftStartTime(
        report,
      );

      final String shiftEnd =
      _getShiftEndTime(
        report,
      );

      final int graceIn =
      _safeGrace(
        report.graceInMinutes,
      );

      final int graceOut =
      _safeGrace(
        report.graceOutMinutes,
      );

      final DateTime referenceDate =
          checkIn ??
              checkOut ??
              DateTime.now();

      final DateTime? shiftStartDate =
      _parseTimeAgainstDate(
        shiftStart,
        referenceDate,
      );

      final DateTime? shiftEndDate =
      _parseTimeAgainstDate(
        shiftEnd,
        checkOut ??
            checkIn ??
            referenceDate,
      );

      bool isLate = false;
      bool isEarlyOut = false;

      // ----------------------------------------------------------------------
      // LATE
      // ----------------------------------------------------------------------

      if (checkIn != null &&
          shiftStartDate != null) {
        final DateTime allowedCheckIn =
        shiftStartDate.add(
          Duration(
            minutes: graceIn,
          ),
        );

        isLate =
            checkIn.isAfter(
              allowedCheckIn,
            );
      }

      // ----------------------------------------------------------------------
      // EARLY OUT
      // ----------------------------------------------------------------------

      if (checkOut != null &&
          shiftEndDate != null) {
        final DateTime allowedCheckOut =
        shiftEndDate.subtract(
          Duration(
            minutes: graceOut,
          ),
        );

        isEarlyOut =
            checkOut.isBefore(
              allowedCheckOut,
            );
      }

      // ----------------------------------------------------------------------
      // BOTH
      // ----------------------------------------------------------------------

      if (isLate &&
          isEarlyOut) {
        return 'LATE + EARLY OUT';
      }

      // ----------------------------------------------------------------------
      // LATE ONLY
      // ----------------------------------------------------------------------

      if (isLate) {
        return 'LATE';
      }

      // ----------------------------------------------------------------------
      // EARLY OUT ONLY
      // ----------------------------------------------------------------------

      if (isEarlyOut) {
        return 'EARLY OUT';
      }

      // ----------------------------------------------------------------------
      // PRESENT
      // ----------------------------------------------------------------------

      return 'PRESENT';
    } catch (_) {
      return 'ABSENT';
    }
  }

  // ==========================================================================
  // OFF DAY
  // ==========================================================================

  bool _isOffDayStatus(
      String status,
      ) {
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

  String _normalizeStatus(
      dynamic value,
      ) {
    if (value == null) {
      return '';
    }

    final String result =
    value.toString().trim().toUpperCase();

    if (result.isEmpty ||
        result == 'NULL') {
      return '';
    }

    return result
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .replaceAll(
      RegExp(r'\s+'),
      ' ',
    )
        .trim();
  }

  // ==========================================================================
  // SAFE GRACE
  // ==========================================================================

  int _safeGrace(
      dynamic value,
      ) {
    if (value is int) {
      return value < 0
          ? 0
          : value;
    }

    if (value is num) {
      final int result =
      value.toInt();

      return result < 0
          ? 0
          : result;
    }

    final int result =
        int.tryParse(
          value?.toString() ?? '',
        ) ??
            0;

    return result < 0
        ? 0
        : result;
  }

  // ==========================================================================
  // STATUS COLOR
  // ==========================================================================

  Color _getStatusColor(
      ThemeData theme,
      String status,
      ) {
    switch (
    status.trim().toUpperCase()) {
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
  // EMPLOYEE ID
  // ==========================================================================

  String _getReportEmployeeId(
      CompanySupervisorMobileAttendanceReportEntity
      report,
      ) {
    return report.employeeId
        .toString()
        .trim();
  }

  // ==========================================================================
  // EMPLOYEE NAME
  // ==========================================================================

  String? _getEmployeeName(
      CompanySupervisorMobileAttendanceReportEntity
      report,
      ) {
    final String result =
    report.employeeName
        .toString()
        .trim();

    if (result.isEmpty ||
        result.toLowerCase() ==
            'null') {
      return employeeName!
          .trim()
          .isEmpty
          ? 'Employee'
          : employeeName;
    }

    return result;
  }

  // ==========================================================================
  // EMPLOYEE CODE
  // ==========================================================================

  String _getEmployeeCode(
      CompanySupervisorMobileAttendanceReportEntity
      report,
      ) {
    final String result =
    report.employeeCode
        .toString()
        .trim();

    if (result.isEmpty ||
        result.toLowerCase() ==
            'null') {
      return '';
    }

    return result;
  }

  // ==========================================================================
  // ATTENDANCE DATE
  // ==========================================================================

  String _getAttendanceDate(
      CompanySupervisorMobileAttendanceReportEntity
      report,
      ) {
    final dynamic value =
        report.attendanceDate;

    if (value == null) {
      return _formatDate(
        DateTime.now(),
      );
    }

    if (value is DateTime) {
      return _formatDate(
        value,
      );
    }

    final String raw =
    value.toString().trim();

    if (raw.isEmpty ||
        raw.toLowerCase() ==
            'null') {
      return _formatDate(
        DateTime.now(),
      );
    }

    final DateTime? parsed =
    DateTime.tryParse(raw);

    if (parsed != null) {
      return _formatDate(
        parsed,
      );
    }

    return raw;
  }

  // ==========================================================================
  // CHECK IN
  // ==========================================================================

  String _getCheckInTime(
      CompanySupervisorMobileAttendanceReportEntity
      report,
      ) {
    return _formatTimeValue(
      report.checkInTime,
    );
  }

  // ==========================================================================
  // CHECK OUT
  // ==========================================================================

  String _getCheckOutTime(
      CompanySupervisorMobileAttendanceReportEntity
      report,
      ) {
    return _formatTimeValue(
      report.checkOutTime,
    );
  }

  // ==========================================================================
  // ACTUAL TIME
  // ==========================================================================

  String _getActualTime(
      dynamic report,
      ) {
    try {
      final String shiftStart =
      _getShiftStartTime(report);

      final String shiftEnd =
      _getShiftEndTime(report);

      return _calculateShiftDuration(
        shiftStart,
        shiftEnd,
      );
    } catch (_) {
      return '--';
    }
  }
  // ==========================================================================
  // SHIFT START
  // ==========================================================================

  String _getShiftStartTime(
      CompanySupervisorMobileAttendanceReportEntity
      report,
      ) {
    return _formatTimeValue(
      report.shiftStartTime,
    );
  }

  // ==========================================================================
  // SHIFT END
  // ==========================================================================

  String _getShiftEndTime(
      CompanySupervisorMobileAttendanceReportEntity
      report,
      ) {
    return _formatTimeValue(
      report.shiftEndTime,
    );
  }

  // ==========================================================================
  // CHECK-IN LOCATION
  // ==========================================================================

  String _getCheckInLocation(
      CompanySupervisorMobileAttendanceReportEntity
      report,
      ) {
    return _formatTextValue(
      report.checkInLocation,
    );
  }

  // ==========================================================================
  // CHECK-OUT LOCATION
  // ==========================================================================

  String _getCheckOutLocation(
      CompanySupervisorMobileAttendanceReportEntity
      report,
      ) {
    return _formatTextValue(
      report.checkOutLocation,
    );
  }

  // ==========================================================================
  // TEXT VALUE
  // ==========================================================================

  String _formatTextValue(
      dynamic value,
      ) {
    if (value == null) {
      return '--';
    }

    final String result =
    value.toString().trim();

    if (result.isEmpty ||
        result.toLowerCase() ==
            'null') {
      return '--';
    }

    return result;
  }

  // ==========================================================================
  // TIME VALUE
  // ==========================================================================

  String _formatTimeValue(
      dynamic value,
      ) {
    if (value == null) {
      return '--';
    }

    if (value is DateTime) {
      return _formatTime(value);
    }

    final String raw =
    value.toString().trim();

    if (raw.isEmpty ||
        raw.toLowerCase() ==
            'null') {
      return '--';
    }

    final DateTime? parsed =
    DateTime.tryParse(raw);

    if (parsed != null) {
      return _formatTime(parsed);
    }

    final RegExp pattern =
    RegExp(
      r'^(\d{1,2}):(\d{2})(?::(\d{2}))?$',
    );

    final Match? match =
    pattern.firstMatch(raw);

    if (match != null) {
      final int hour =
          int.tryParse(
            match.group(1) ?? '',
          ) ??
              -1;

      final int minute =
          int.tryParse(
            match.group(2) ?? '',
          ) ??
              -1;

      if (hour < 0 ||
          hour > 23 ||
          minute < 0 ||
          minute > 59) {
        return raw;
      }

      return _formatTime(
        DateTime(
          2026,
          1,
          1,
          hour,
          minute,
        ),
      );
    }

    return raw;
  }

  // ==========================================================================
  // FORMAT TIME
  // ==========================================================================

  String _formatTime(
      DateTime value,
      ) {
    final int hour =
        value.hour;

    final int minute =
        value.minute;

    final String period =
    hour >= 12
        ? 'PM'
        : 'AM';

    final int displayHour =
    hour % 12 == 0
        ? 12
        : hour % 12;

    return '$displayHour:'
        '${minute.toString().padLeft(2, '0')} '
        '$period';
  }

  // ==========================================================================
  // TO DATETIME
  // ==========================================================================

  DateTime? _toDateTime(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    final String raw =
    value.toString().trim();

    if (raw.isEmpty ||
        raw.toLowerCase() ==
            'null') {
      return null;
    }

    return DateTime.tryParse(
      raw,
    );
  }

  // ==========================================================================
  // PARSE TIME AGAINST DATE
  // ==========================================================================

  DateTime? _parseTimeAgainstDate(
      String value,
      DateTime referenceDate,
      ) {
    if (value == '--' ||
        value.trim().isEmpty) {
      return null;
    }

    final String raw =
    value.trim();

    final RegExp twelveHourPattern =
    RegExp(
      r'^(\d{1,2}):(\d{2})\s*(AM|PM)$',
      caseSensitive: false,
    );

    final Match? twelveMatch =
    twelveHourPattern.firstMatch(
      raw,
    );

    if (twelveMatch != null) {
      int hour =
          int.tryParse(
            twelveMatch.group(1) ?? '',
          ) ??
              -1;

      final int minute =
          int.tryParse(
            twelveMatch.group(2) ?? '',
          ) ??
              -1;

      final String period =
      (twelveMatch.group(3) ?? '')
          .toUpperCase();

      if (hour < 1 ||
          hour > 12 ||
          minute < 0 ||
          minute > 59) {
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

    final RegExp twentyFourHourPattern =
    RegExp(
      r'^(\d{1,2}):(\d{2})(?::(\d{2}))?$',
    );

    final Match? twentyFourMatch =
    twentyFourHourPattern.firstMatch(
      raw,
    );

    if (twentyFourMatch != null) {
      final int hour =
          int.tryParse(
            twentyFourMatch.group(1) ?? '',
          ) ??
              -1;

      final int minute =
          int.tryParse(
            twentyFourMatch.group(2) ?? '',
          ) ??
              -1;

      if (hour < 0 ||
          hour > 23 ||
          minute < 0 ||
          minute > 59) {
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

  String _formatDate(
      DateTime value,
      ) {
    return '${value.day} '
        '${_monthName(value.month)} '
        '${value.year}';
  }

  // ==========================================================================
  // TABLE HEADER
  // ==========================================================================

  Widget _tableHeader(
      ThemeData theme,
      String text,
      ) {
    return Text(
      text,
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
        FontWeight.w900,
      ),
    );
  }

  // ==========================================================================
  // ERROR
  // ==========================================================================

  Widget _buildError(
      ThemeData theme,
      String message,
      ) {
    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(),
      padding:
      const EdgeInsets.all(24),
      children: [
        const SizedBox(
          height: 90,
        ),
        Icon(
          Icons.error_outline_rounded,
          size: 64,
          color:
          theme.colorScheme.error,
        ),
        const SizedBox(
          height: 18,
        ),
        Text(
          'Unable to load attendance',
          textAlign:
          TextAlign.center,
          style: theme
              .textTheme
              .titleLarge
              ?.copyWith(
            fontWeight:
            FontWeight.w900,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          message,
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
        const SizedBox(
          height: 22,
        ),
        Center(
          child:
          FilledButton.icon(
            onPressed:
            _loadReport,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
            label: const Text(
              'Try Again',
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // EMPTY
  // ==========================================================================

  Widget _buildEmpty(
      ThemeData theme,
      ) {
    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(),
      padding:
      const EdgeInsets.all(24),
      children: [
        const SizedBox(
          height: 90,
        ),
        Icon(
          Icons.event_available_rounded,
          size: 68,
          color:
          theme.colorScheme.outline,
        ),
        const SizedBox(
          height: 18,
        ),
        Text(
          'No Attendance Records',
          textAlign:
          TextAlign.center,
          style: theme
              .textTheme
              .titleLarge
              ?.copyWith(
            fontWeight:
            FontWeight.w900,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'No mobile attendance records were found for the selected date range.',
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
        const SizedBox(
          height: 22,
        ),
        Center(
          child:
          OutlinedButton.icon(
            onPressed:
            _loadReport,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
            label: const Text(
              'Refresh',
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // NO SELECTED EMPLOYEE RECORDS
  // ==========================================================================

  Widget _buildNoEmployeeRecords(
      ThemeData theme,
      ) {
    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(),
      padding:
      const EdgeInsets.all(24),
      children: [
        const SizedBox(
          height: 80,
        ),
        Icon(
          Icons.person_off_rounded,
          size: 68,
          color:
          theme.colorScheme.outline,
        ),
        const SizedBox(
          height: 18,
        ),
        Text(
          'No Records For Selected Employee',
          textAlign:
          TextAlign.center,
          style: theme
              .textTheme
              .titleLarge
              ?.copyWith(
            fontWeight:
            FontWeight.w900,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          '${employeeName} has no attendance records in the selected date range.',
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
        const SizedBox(
          height: 22,
        ),
        Center(
          child:
          OutlinedButton.icon(
            onPressed:
            _loadReport,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
            label: const Text(
              'Refresh',
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // MONTH NAME
  // ==========================================================================

  String _monthName(
      int month,
      ) {
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

    if (month < 1 ||
        month > 12) {
      return '';
    }

    return months[month - 1];
  }
}

// ============================================================================
// AH / WH / OT
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
  final String actualHours =
  _calculateShiftDuration(
    shiftStartTime,
    shiftEndTime,
  );

  final String workingHours =
  _calculateAttendanceDuration(
    checkInTime,
    checkOutTime,
  );

  final String overtimeHours =
  _calculateOvertime(
    shiftStartTime,
    shiftEndTime,
    checkInTime,
    checkOutTime,
  );

  return Container(
    width: double.infinity,
    padding:
    const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 9,
    ),
    decoration:
    BoxDecoration(
      color: theme
          .colorScheme
          .surfaceContainerLow,
      borderRadius:
      BorderRadius.circular(12),
      border: Border.all(
        color: theme
            .colorScheme
            .outlineVariant,
      ),
    ),
    child: Row(
      children: [
        Expanded(
          child:
          _buildCompactTimeItemGlobal(
            theme,
            label: 'AH',
            value: actualHours,
            icon:
            Icons.timer_outlined,
          ),
        ),
        _buildTimeDividerGlobal(
          theme,
        ),
        Expanded(
          child:
          _buildCompactTimeItemGlobal(
            theme,
            label: 'WH',
            value: workingHours,
            icon:
            Icons.work_history_outlined,
          ),
        ),
        _buildTimeDividerGlobal(
          theme,
        ),
        Expanded(
          child:
          _buildCompactTimeItemGlobal(
            theme,
            label: 'OT',
            value: overtimeHours,
            icon:
            Icons.more_time_rounded,
          ),
        ),
      ],
    ),
  );
}

// ============================================================================
// COMPACT TIME ITEM
// ============================================================================

Widget _buildCompactTimeItemGlobal(
    ThemeData theme, {
      required String label,
      required String value,
      required IconData icon,
    }) {
  return Column(
    mainAxisSize:
    MainAxisSize.min,
    children: [
      Row(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 14,
            color:
            theme.colorScheme.primary,
          ),
          const SizedBox(
            width: 3,
          ),
          Text(
            label,
            style: theme
                .textTheme
                .labelSmall
                ?.copyWith(
              color: theme
                  .colorScheme
                  .primary,
              fontWeight:
              FontWeight.w900,
              fontSize: 10,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 3,
      ),
      Text(
        value,
        maxLines: 1,
        overflow:
        TextOverflow.ellipsis,
        textAlign:
        TextAlign.center,
        style: theme
            .textTheme
            .bodySmall
            ?.copyWith(
          fontWeight:
          FontWeight.w900,
          fontSize: 11,
        ),
      ),
    ],
  );
}

// ============================================================================
// TIME DIVIDER
// ============================================================================

Widget _buildTimeDividerGlobal(
    ThemeData theme,
    ) {
  return Container(
    width: 1,
    height: 29,
    margin:
    const EdgeInsets.symmetric(
      horizontal: 3,
    ),
    color:
    theme.colorScheme.outlineVariant,
  );
}

// ============================================================================
// AH
// ============================================================================

String _calculateShiftDuration(
    String? startTime,
    String? endTime,
    ) {
  final DateTime? start =
  _parseTimeString(
    startTime,
  );

  final DateTime? end =
  _parseTimeString(
    endTime,
  );

  if (start == null ||
      end == null) {
    return '--';
  }

  int minutes =
      end.difference(
        start,
      ).inMinutes;

  if (minutes < 0) {
    minutes += 24 * 60;
  }

  return _formatMinutes(
    minutes,
  );
}

// ============================================================================
// WH
// ============================================================================

String _calculateAttendanceDuration(
    String? checkInTime,
    String? checkOutTime,
    ) {
  final DateTime? start =
  _parseTimeString(
    checkInTime,
  );

  final DateTime? end =
  _parseTimeString(
    checkOutTime,
  );

  if (start == null ||
      end == null) {
    return '--';
  }

  int minutes =
      end.difference(
        start,
      ).inMinutes;

  if (minutes < 0) {
    minutes += 24 * 60;
  }

  return _formatMinutes(
    minutes,
  );
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
  final DateTime? shiftStart =
  _parseTimeString(
    shiftStartTime,
  );

  final DateTime? shiftEnd =
  _parseTimeString(
    shiftEndTime,
  );

  final DateTime? checkIn =
  _parseTimeString(
    checkInTime,
  );

  final DateTime? checkOut =
  _parseTimeString(
    checkOutTime,
  );

  if (shiftStart == null ||
      shiftEnd == null ||
      checkIn == null ||
      checkOut == null) {
    return '--';
  }

  int shiftMinutes =
      shiftEnd
          .difference(
        shiftStart,
      )
          .inMinutes;

  int attendanceMinutes =
      checkOut
          .difference(
        checkIn,
      )
          .inMinutes;

  if (shiftMinutes < 0) {
    shiftMinutes += 24 * 60;
  }

  if (attendanceMinutes < 0) {
    attendanceMinutes += 24 * 60;
  }

  final int overtimeMinutes =
      attendanceMinutes -
          shiftMinutes;

  if (overtimeMinutes <= 0) {
    return '0h';
  }

  return _formatMinutes(
    overtimeMinutes,
  );
}

// ============================================================================
// PARSE TIME
// ============================================================================

DateTime? _parseTimeString(
    String? value,
    ) {
  if (value == null) {
    return null;
  }

  final String raw =
  value.trim();

  if (raw.isEmpty ||
      raw == '--') {
    return null;
  }

  final RegExp twelveHourPattern =
  RegExp(
    r'^(\d{1,2}):(\d{2})\s*(AM|PM)$',
    caseSensitive: false,
  );

  final Match? twelveMatch =
  twelveHourPattern.firstMatch(
    raw,
  );

  if (twelveMatch != null) {
    int hour =
        int.tryParse(
          twelveMatch.group(1) ?? '',
        ) ??
            -1;

    final int minute =
        int.tryParse(
          twelveMatch.group(2) ?? '',
        ) ??
            -1;

    final String period =
    (twelveMatch.group(3) ?? '')
        .toUpperCase();

    if (hour < 1 ||
        hour > 12 ||
        minute < 0 ||
        minute > 59) {
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
      2000,
      1,
      1,
      hour,
      minute,
    );
  }

  final RegExp twentyFourHourPattern =
  RegExp(
    r'^(\d{1,2}):(\d{2})(?::(\d{2}))?$',
  );

  final Match? twentyFourMatch =
  twentyFourHourPattern.firstMatch(
    raw,
  );

  if (twentyFourMatch != null) {
    final int hour =
        int.tryParse(
          twentyFourMatch.group(1) ?? '',
        ) ??
            -1;

    final int minute =
        int.tryParse(
          twentyFourMatch.group(2) ?? '',
        ) ??
            -1;

    if (hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      return null;
    }

    return DateTime(
      2000,
      1,
      1,
      hour,
      minute,
    );
  }

  return null;
}

// ============================================================================
// FORMAT MINUTES
// ============================================================================

String _formatMinutes(
    int totalMinutes,
    ) {
  if (totalMinutes <= 0) {
    return '0h';
  }

  final int hours =
      totalMinutes ~/ 60;

  final int minutes =
      totalMinutes % 60;

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