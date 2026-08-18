// ===============================================================
// Flutter HRMS Pro
// Supervisor Employee Attendance Report
//
// UI Improvements:
// - Theme aware
// - Light / Dark mode support
// - Responsive design
// - Mobile / Tablet / Desktop friendly
// - Modern filter controls
// - Improved spacing and typography
//
// Functionality: UNCHANGED
// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/attendance_report_filter.dart';
import '../providers/attendance_report_provider.dart';
import '../widgets/attendance_report_item.dart';

class SupervisorEmployeeAttendanceReportPage
    extends ConsumerStatefulWidget {
  const SupervisorEmployeeAttendanceReportPage({
    super.key,
    required this.employeeId,
  });

  final String employeeId;

  @override
  ConsumerState<SupervisorEmployeeAttendanceReportPage>
  createState() =>
      _EmployeeAttendanceReportPageState();
}

class _EmployeeAttendanceReportPageState
    extends ConsumerState<SupervisorEmployeeAttendanceReportPage> {
  late DateTime fromDate;
  late DateTime toDate;

  AttendanceReportFilter selectedFilter =
      AttendanceReportFilter.all;

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    fromDate = DateTime(
      now.year,
      now.month - 1,
      now.day,
    );

    toDate = DateTime(
      now.year,
      now.month,
      now.day,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReport();
    });
  }

  // =============================================================
  // LOAD REPORT
  // =============================================================

  Future<void> _loadReport() async {
    await ref
        .read(attendanceReportProvider.notifier)
        .loadReport(
      employeeId: widget.employeeId,
      from: fromDate,
      to: toDate,
    );
  }

  // =============================================================
  // FROM DATE
  // =============================================================

  Future<void> _selectFromDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selected == null) return;

    setState(() {
      fromDate = selected;

      if (fromDate.isAfter(toDate)) {
        toDate = fromDate;
      }
    });
  }

  // =============================================================
  // TO DATE
  // =============================================================

  Future<void> _selectToDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: fromDate,
      lastDate: DateTime(2100),
    );

    if (selected == null) return;

    setState(() {
      toDate = selected;
    });
  }

  // =============================================================
  // RESPONSIVE WIDTH
  // =============================================================

  double _maxContentWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= 1400) {
      return 1200;
    }

    if (width >= 1000) {
      return 1100;
    }

    return double.infinity;
  }

  // =============================================================
  // RESPONSIVE PADDING
  // =============================================================

  EdgeInsets _pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      );
    }

    if (width < 1000) {
      return const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      );
    }

    return const EdgeInsets.symmetric(
      horizontal: 26,
      vertical: 18,
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      attendanceReportProvider,
    );

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: colorScheme.onSurface,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Employee Attendance',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _maxContentWidth(context),
          ),
          child: Column(
            children: [
              // ===================================================
              // FILTER AREA
              // ===================================================

              Padding(
                padding: _pagePadding(context),
                child: Column(
                  children: [
                    // =============================================
                    // DATE FILTER
                    // =============================================

                    _buildDateFilter(),

                    const SizedBox(height: 12),

                    // =============================================
                    // STATUS FILTER
                    // =============================================

                    _buildStatusFilter(),

                    const SizedBox(height: 12),

                    // =============================================
                    // SHOW DETAILS
                    // =============================================

                    _buildShowDetailsButton(),
                  ],
                ),
              ),

              // ===================================================
              // HEADER
              // ===================================================

              _buildHeader(),

              // ===================================================
              // DATA
              // ===================================================

              Expanded(
                child: state.when(
                  // =================================================
                  // LOADING
                  // =================================================

                  loading: () {
                    return Center(
                      child: CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                    );
                  },

                  // =================================================
                  // ERROR
                  // =================================================

                  error: (error, stack) {
                    return _buildError(
                      context,
                      error.toString(),
                    );
                  },

                  // =================================================
                  // DATA
                  // =================================================

                  data: (data) {
                    final filtered = ref
                        .read(
                      attendanceReportProvider
                          .notifier,
                    )
                        .filter(
                      data,
                      selectedFilter,
                    );

                    if (filtered.isEmpty) {
                      return _buildEmpty(
                        context,
                      );
                    }

                    return ListView.builder(
                      padding:
                      const EdgeInsets.only(
                        top: 6,
                        bottom: 20,
                      ),
                      itemCount: filtered.length,
                      itemBuilder:
                          (context, index) {
                        return AttendanceReportItem(
                          item: filtered[index],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // DATE FILTER
  // =============================================================

  Widget _buildDateFilter() {
    return Row(
      children: [
        Expanded(
          child: _dateButton(
            title: 'From Date',
            date: fromDate,
            onTap: _selectFromDate,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _dateButton(
            title: 'To Date',
            date: toDate,
            onTap: _selectToDate,
          ),
        ),
      ],
    );
  }

  // =============================================================
  // DATE BUTTON
  // =============================================================

  Widget _dateButton({
    required String title,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          height: 62,
          padding:
          const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius:
            BorderRadius.circular(13),
            border: Border.all(
              color: colorScheme.primary
                  .withOpacity(.35),
            ),
          ),
          child: Row(
            children: [
              // =================================================
              // ICON
              // =================================================

              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorScheme.primary
                      .withOpacity(.09),
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.calendar_month_outlined,
                  size: 19,
                  color: colorScheme.primary,
                ),
              ),

              const SizedBox(width: 9),

              // =================================================
              // DATE
              // =================================================

              Expanded(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme
                            .onSurface
                            .withOpacity(.55),
                        fontSize: 10.5,
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      DateFormat(
                        'dd-MMM-yy',
                      ).format(date),
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: TextStyle(
                        color:
                        colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 19,
                color: colorScheme.onSurface
                    .withOpacity(.40),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // STATUS FILTER
  // =============================================================

  Widget _buildStatusFilter() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outline
              .withOpacity(.12),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _radio(
              'All',
              AttendanceReportFilter.all,
            ),

            const SizedBox(width: 6),

            _radio(
              'On Time',
              AttendanceReportFilter.onTime,
            ),

            const SizedBox(width: 6),

            _radio(
              'Late',
              AttendanceReportFilter.late,
            ),

            const SizedBox(width: 6),

            _radio(
              'Absent',
              AttendanceReportFilter.absent,
            ),

            const SizedBox(width: 6),

            _radio(
              'Leave',
              AttendanceReportFilter.leave,
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // RADIO
  // =============================================================

  Widget _radio(
      String title,
      AttendanceReportFilter value,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selected =
        selectedFilter == value;

    return Material(
      color: selected
          ? colorScheme.primary
          .withOpacity(.09)
          : Colors.transparent,
      borderRadius:
      BorderRadius.circular(22),
      child: InkWell(
        borderRadius:
        BorderRadius.circular(22),
        onTap: () {
          setState(() {
            selectedFilter = value;
          });
        },
        child: Padding(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 2,
          ),
          child: Row(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              Radio<
                  AttendanceReportFilter>(
                value: value,
                groupValue:
                selectedFilter,
                onChanged: (newValue) {
                  if (newValue == null) {
                    return;
                  }

                  setState(() {
                    selectedFilter =
                        newValue;
                  });
                },
                materialTapTargetSize:
                MaterialTapTargetSize
                    .shrinkWrap,
                visualDensity:
                const VisualDensity(
                  horizontal: -3,
                  vertical: -3,
                ),
                activeColor:
                colorScheme.primary,
              ),

              const SizedBox(width: 2),

              Text(
                title,
                style: TextStyle(
                  color:
                  colorScheme.onSurface,
                  fontSize: 11,
                  fontWeight:
                  selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),

              const SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // SHOW DETAILS BUTTON
  // =============================================================

  Widget _buildShowDetailsButton() {
    final colorScheme =
        Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton.icon(
        onPressed: _loadReport,

        icon: const Icon(
          Icons.search_rounded,
          size: 19,
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor:
          colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(12),
          ),
        ),

        label: const Text(
          'Show Details',
          style: TextStyle(
            fontSize: 14,
            fontWeight:
            FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // =============================================================
  // TABLE HEADER
  // =============================================================

  Widget _buildHeader() {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      margin:
      const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      padding:
      const EdgeInsets.symmetric(
        vertical: 11,
        horizontal: 13,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius:
        const BorderRadius.only(
          topLeft:
          Radius.circular(10),
          topRight:
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          // ===================================================
          // DATE
          // ===================================================

          const SizedBox(
            width: 105,
            child: Text(
              'Date',
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ),

          // ===================================================
          // TIME + LOCATION
          // ===================================================

          const Expanded(
            child: Text(
              'Time - Punched Location',
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // EMPTY
  // =============================================================

  Widget _buildEmpty(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: colorScheme.primary
                  .withOpacity(.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_busy_outlined,
              color: colorScheme.primary
                  .withOpacity(.65),
              size: 28,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'No attendance found.',
            style: TextStyle(
              color: colorScheme.onSurface
                  .withOpacity(.55),
              fontSize: 14,
              fontWeight:
              FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // ERROR
  // =============================================================

  Widget _buildError(
      BuildContext context,
      String error,
      ) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(20),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: colorScheme.error,
              size: 42,
            ),

            const SizedBox(height: 10),

            Text(
              error,
              textAlign:
              TextAlign.center,
              style: TextStyle(
                color: colorScheme.error,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}