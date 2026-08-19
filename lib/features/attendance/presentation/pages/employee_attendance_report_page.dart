import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/attendance_report_filter.dart';
import '../providers/attendance_report_provider.dart';
import '../widgets/attendance_report_item.dart';

class EmployeeAttendanceReportPage
    extends ConsumerStatefulWidget {
  const EmployeeAttendanceReportPage({
    super.key,
    required this.employeeId,
  });

  final String employeeId;

  @override
  ConsumerState<EmployeeAttendanceReportPage> createState() =>
      _EmployeeAttendanceReportPageState();
}

class _EmployeeAttendanceReportPageState
    extends ConsumerState<EmployeeAttendanceReportPage> {
  late DateTime fromDate;
  late DateTime toDate;

  AttendanceReportFilter selectedFilter =
      AttendanceReportFilter.all;

  // ===========================================================
  // THEME
  // ===========================================================

  static const Color primaryColor = Color(0xFF4F6AA5);
  static const Color primaryDark = Color(0xFF435A93);
  static const Color backgroundColor = Color(0xFFF8F9FC);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF20242D);
  static const Color secondaryTextColor = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);

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

  // ===========================================================
  // LOAD REPORT
  // ===========================================================

  Future<void> _loadReport() async {
    await ref
        .read(attendanceReportProvider.notifier)
        .loadReport(
      employeeId: widget.employeeId,
      from: fromDate,
      to: toDate,
    );
  }

  // ===========================================================
  // FROM DATE
  // ===========================================================

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

  // ===========================================================
  // TO DATE
  // ===========================================================

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

  // ===========================================================
  // BUILD
  // ===========================================================

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      attendanceReportProvider,
    );

    return Scaffold(
      backgroundColor: backgroundColor,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: textColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Employee Attendance',
          style: TextStyle(
            color: textColor,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),

        centerTitle: false,
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= 700;

          final double horizontalPadding =
          isWide ? 24 : 14;

          final double contentMaxWidth =
          isWide ? 1000 : double.infinity;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: contentMaxWidth,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 14),

                  // ------------------------------------------------
                  // FILTER AREA
                  // ------------------------------------------------

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: _buildFilterSection(
                      isWide: isWide,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ------------------------------------------------
                  // HEADER
                  // ------------------------------------------------

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: _buildHeader(),
                  ),

                  // ------------------------------------------------
                  // DATA
                  // ------------------------------------------------

                  Expanded(
                    child: state.when(
                      // =================================================
                      // LOADING
                      // =================================================

                      loading: () {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        );
                      },

                      // =================================================
                      // ERROR
                      // =================================================

                      error: (error, stack) {
                        return _buildErrorState(
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
                          return _buildEmptyState();
                        }

                        return ListView.builder(
                          physics:
                          const AlwaysScrollableScrollPhysics(),

                          padding: EdgeInsets.only(
                            left: horizontalPadding,
                            right: horizontalPadding,
                            top: 8,
                            bottom: 24,
                          ),

                          itemCount: filtered.length,

                          itemBuilder: (
                              context,
                              index,
                              ) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: AttendanceReportItem(
                                item: filtered[index],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ===========================================================
  // FILTER SECTION
  // ===========================================================

  Widget _buildFilterSection({
    required bool isWide,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // ---------------------------------------------------------
          // FILTER TITLE
          // ---------------------------------------------------------

          const Row(
            children: [
              Icon(
                Icons.filter_alt_outlined,
                size: 20,
                color: primaryColor,
              ),

              SizedBox(width: 8),

              Text(
                'Attendance Filter',
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ---------------------------------------------------------
          // DATE FILTER
          // ---------------------------------------------------------

          if (isWide)
            Row(
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
            )
          else
            Row(
              children: [
                Expanded(
                  child: _dateButton(
                    title: 'From Date',
                    date: fromDate,
                    onTap: _selectFromDate,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _dateButton(
                    title: 'To Date',
                    date: toDate,
                    onTap: _selectToDate,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 12),

          // ---------------------------------------------------------
          // STATUS FILTER
          // ---------------------------------------------------------

          _buildStatusFilter(),

          const SizedBox(height: 12),

          // ---------------------------------------------------------
          // SHOW DETAILS
          // ---------------------------------------------------------

          Align(
            alignment: Alignment.centerRight,
            child: _buildShowDetailsButton(),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // DATE BUTTON
  // ===========================================================

  Widget _dateButton({
    required String title,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),

        child: Container(
          height: 58,

          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),

          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFD),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: borderColor,
            ),
          ),

          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,

                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(.10),
                  borderRadius:
                  BorderRadius.circular(10),
                ),

                child: const Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: primaryColor,
                ),
              ),

              const SizedBox(width: 9),

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

                      style: const TextStyle(
                        fontSize: 10.5,
                        color: secondaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      DateFormat(
                        'dd-MMM-yy',
                      ).format(date),

                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 13,
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 19,
                color: secondaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // STATUS FILTER
  // ===========================================================

  // ===========================================================
// STATUS FILTER
// ===========================================================

  Widget _buildStatusFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),

      child: Row(
        children: [
          // -----------------------------------------------------
          // ALL
          // -----------------------------------------------------

          _radio(
            'All',
            AttendanceReportFilter.all,
          ),

          const SizedBox(width: 4),

          // -----------------------------------------------------
          // ON TIME
          // -----------------------------------------------------

          _radio(
            'On Time',
            AttendanceReportFilter.onTime,
          ),

          const SizedBox(width: 4),

          // -----------------------------------------------------
          // LATE
          // -----------------------------------------------------

          _radio(
            'Late',
            AttendanceReportFilter.late,
          ),

          const SizedBox(width: 4),

          // -----------------------------------------------------
          // EARLY OUT
          // -----------------------------------------------------

          _radio(
            'Early Out',
            AttendanceReportFilter.earlyOut,
          ),

          const SizedBox(width: 4),

          // -----------------------------------------------------
          // LATE & EARLY OUT
          // -----------------------------------------------------

          _radio(
            'Late & Early Out',
            AttendanceReportFilter.lateAndEarlyOut,
          ),

          const SizedBox(width: 4),

          // -----------------------------------------------------
          // ABSENT
          // -----------------------------------------------------

          _radio(
            'Absent',
            AttendanceReportFilter.absent,
          ),

          const SizedBox(width: 4),

          // -----------------------------------------------------
          // LEAVE
          // -----------------------------------------------------

          _radio(
            'Leave',
            AttendanceReportFilter.leave,
          ),

          const SizedBox(width: 4),

        ],
      ),
    );
  }

// ===========================================================
// RADIO
// ===========================================================

  Widget _radio(
      String title,
      AttendanceReportFilter value,
      ) {
    final bool selected = selectedFilter == value;

    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(20),

        onTap: () {
          setState(() {
            selectedFilter = value;
          });
        },

        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),

          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 5,
          ),

          decoration: BoxDecoration(
            color: selected
                ? primaryColor.withOpacity(.10)
                : Colors.transparent,

            borderRadius: BorderRadius.circular(20),

            border: Border.all(
              color: selected
                  ? primaryColor.withOpacity(.25)
                  : Colors.transparent,
            ),
          ),

          child: Row(
            mainAxisSize: MainAxisSize.min,

            children: [
              Radio<AttendanceReportFilter>(
                value: value,
                groupValue: selectedFilter,

                onChanged: (newValue) {
                  if (newValue == null) return;

                  setState(() {
                    selectedFilter = newValue;
                  });
                },

                materialTapTargetSize:
                MaterialTapTargetSize.shrinkWrap,

                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),

                activeColor: primaryColor,
              ),

              const SizedBox(width: 2),

              Text(
                title,

                style: TextStyle(
                  fontSize: 11.5,

                  color: selected
                      ? primaryDark
                      : textColor,

                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // SHOW DETAILS BUTTON
  // ===========================================================

  Widget _buildShowDetailsButton() {
    return FilledButton.icon(
      onPressed: _loadReport,

      icon: const Icon(
        Icons.search_rounded,
        size: 18,
      ),

      style: FilledButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,

        elevation: 0,

        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 11,
        ),

        minimumSize: const Size(
          0,
          42,
        ),

        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(11),
        ),
      ),

      label: const Text(
        'Show Details',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ===========================================================
  // TABLE HEADER
  // ===========================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        vertical: 11,
        horizontal: 14,
      ),

      decoration: const BoxDecoration(
        color: primaryColor,

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),

      child: const Row(
        children: [
          // -----------------------------------------------------
          // DATE
          // -----------------------------------------------------

          SizedBox(
            width: 105,

            child: Text(
              'Date',

              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,

              style: TextStyle(
                color: Colors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // -----------------------------------------------------
          // TIME + LOCATION
          // -----------------------------------------------------

          Expanded(
            child: Text(
              'Time - Punched Location',

              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,

              style: TextStyle(
                color: Colors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // ERROR STATE
  // ===========================================================

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Container(
          padding: const EdgeInsets.all(22),

          decoration: BoxDecoration(
            color: cardColor,
            borderRadius:
            BorderRadius.circular(18),
            border: Border.all(
              color: borderColor,
            ),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Container(
                width: 54,
                height: 54,

                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(.08),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.redAccent,
                  size: 28,
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                'Unable to load attendance',
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                error,
                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 12,
                  color: secondaryTextColor,
                ),
              ),

              const SizedBox(height: 18),

              FilledButton.icon(
                onPressed: _loadReport,

                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 18,
                ),

                label: const Text(
                  'Retry',
                ),

                style: FilledButton.styleFrom(
                  backgroundColor:
                  primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // EMPTY STATE
  // ===========================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              width: 68,
              height: 68,

              decoration: BoxDecoration(
                color: primaryColor.withOpacity(.08),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.event_busy_outlined,
                color: primaryColor,
                size: 32,
              ),
            ),

            const SizedBox(height: 14),

            const Text(
              'No attendance found.',
              style: TextStyle(
                fontSize: 15,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Try changing the date or status filter.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}