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
  ConsumerState<EmployeeAttendanceReportPage>
  createState() =>
      _EmployeeAttendanceReportPageState();
}

class _EmployeeAttendanceReportPageState
    extends ConsumerState<EmployeeAttendanceReportPage> {
  late DateTime fromDate;
  late DateTime toDate;

  AttendanceReportFilter selectedFilter =
      AttendanceReportFilter.all;

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

      // Prevent invalid date range.
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      attendanceReportProvider,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9FF),

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF9FF),
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Employee Attendance',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: Column(
        children: [
          const SizedBox(height: 4),

          // -------------------------------------------------------
          // DATE FILTER
          // -------------------------------------------------------

          _buildDateFilter(),

          const SizedBox(height: 8),

          // -------------------------------------------------------
          // STATUS FILTER
          // -------------------------------------------------------

          _buildStatusFilter(),

          const SizedBox(height: 6),

          // -------------------------------------------------------
          // SHOW DETAILS
          // -------------------------------------------------------

          _buildShowDetailsButton(),

          const SizedBox(height: 10),

          // -------------------------------------------------------
          // HEADER
          // -------------------------------------------------------

          _buildHeader(),

          // -------------------------------------------------------
          // DATA
          // -------------------------------------------------------

          Expanded(
            child: state.when(
              // ===================================================
              // LOADING
              // ===================================================

              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },

              // ===================================================
              // ERROR
              // ===================================================

              error: (error, stack) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              },

              // ===================================================
              // DATA
              // ===================================================

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
                  return const Center(
                    child: Text(
                      'No attendance found.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(
                    top: 4,
                    bottom: 20,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (
                      context,
                      index,
                      ) {
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
    );
  }

  // ===========================================================
  // DATE FILTER
  // ===========================================================

  Widget _buildDateFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Row(
        children: [
          // -------------------------------------------------------
          // FROM DATE
          // -------------------------------------------------------

          Expanded(
            child: _dateButton(
              title: 'From Date',
              date: fromDate,
              onTap: _selectFromDate,
            ),
          ),

          const SizedBox(width: 8),

          // -------------------------------------------------------
          // TO DATE
          // -------------------------------------------------------

          Expanded(
            child: _dateButton(
              title: 'To Date',
              date: toDate,
              onTap: _selectToDate,
            ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF2196F3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month_outlined,
              size: 19,
              color: Color(0xFF2196F3),
            ),

            const SizedBox(width: 7),

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
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    DateFormat(
                      'dd-MMM-yy',
                    ).format(date),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // STATUS FILTER
  // ===========================================================

  Widget _buildStatusFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _radio(
              'All',
              AttendanceReportFilter.all,
            ),
            const SizedBox(width: 8),

            _radio(
              'On Time',
              AttendanceReportFilter.onTime,
            ),
            const SizedBox(width: 8),

            _radio(
              'Late',
              AttendanceReportFilter.late,
            ),
            const SizedBox(width: 8),

            _radio(
              'Absent',
              AttendanceReportFilter.absent,
            ),
            const SizedBox(width: 8),

            _radio(
              'Leave',
              AttendanceReportFilter.leave,
            ),
          ],
        ),
      ),
    );
  }

  Widget _radio(
      String title,
      AttendanceReportFilter value,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        setState(() {
          selectedFilter = value;
        });
      },
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
              horizontal: -3,
              vertical: -3,
            ),
            activeColor:
            const Color(0xFF2196F3),
          ),

          const SizedBox(width: 2),

          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // RADIO
  // ===========================================================


  // ===========================================================
  // SHOW DETAILS
  // ===========================================================

  Widget _buildShowDetailsButton() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Align(
          alignment: Alignment.center,
          child: ElevatedButton.icon(
            onPressed: _loadReport,

            icon: const Icon(
              Icons.search,
              size: 18,
            ),

            style: ElevatedButton.styleFrom(
              backgroundColor:
              const Color(0xFF2196F3),
              foregroundColor: Colors.white,

              elevation: 0,

              padding:
              const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),

              minimumSize: const Size(
                0,
                40,
              ),

              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(8),
              ),
            ),

            label: const Text(
              'Show Details',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // TABLE HEADER
  // ===========================================================

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
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
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
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
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}