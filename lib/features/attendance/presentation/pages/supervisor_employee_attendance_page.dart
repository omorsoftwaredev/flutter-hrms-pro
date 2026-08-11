import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/auth/current_user.dart';
import '../../../../core/auth/current_user_provider.dart';
import '../providers/supervisor_attendance_provider.dart' hide SupervisorAttendanceState;
import '../providers/supervisor_attendance_state.dart';

class SupervisorEmployeeAttendancePage
    extends ConsumerStatefulWidget {
  const SupervisorEmployeeAttendancePage({
    super.key,
  });

  @override
  ConsumerState<
      SupervisorEmployeeAttendancePage>
  createState() =>
      _SupervisorEmployeeAttendancePageState();
}

class _SupervisorEmployeeAttendancePageState
    extends ConsumerState<
        SupervisorEmployeeAttendancePage> {
  // ===========================================================
  // MODE
  // ===========================================================

  SupervisorAttendanceMode mode =
      SupervisorAttendanceMode.allEmployees;

  // ===========================================================
  // DATE
  // ===========================================================

  late DateTime fromDate;
  late DateTime toDate;

  // ===========================================================
  // SELECTED EMPLOYEE
  // ===========================================================

  String? selectedEmployeeId;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    fromDate = DateTime(
      now.year,
      now.month,
      now.day,
    );

    toDate = DateTime(
      now.year,
      now.month,
      now.day,
    );

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      _initialize();
    });
  }

  // ===========================================================
  // INITIALIZE
  // ===========================================================

  Future<void> _initialize() async {
    final CurrentUser? user =
    ref.read(currentUserProvider);

    if (user == null) {
      return;
    }

    /*
     * তোমার CurrentUser-এ employeeId field থাকলে
     * এখানে user.employeeId ব্যবহার করবে।
     */

    await ref
        .read(
      supervisorAttendanceProvider
          .notifier,
    )
        .initialize(
      user.employeeId,
    );
  }

  // ===========================================================
  // DEPARTMENT CHANGE
  // ===========================================================

  Future<void> _selectDepartment(
      String? value,
      ) async {
    if (value == null) {
      return;
    }

    setState(() {
      selectedEmployeeId = null;
    });

    await ref
        .read(
      supervisorAttendanceProvider
          .notifier,
    )
        .selectDepartment(value);
  }

  // ===========================================================
  // MODE CHANGE
  // ===========================================================

  void _changeMode(
      SupervisorAttendanceMode value,
      ) {
    setState(() {
      mode = value;
      selectedEmployeeId = null;
    });

    ref
        .read(
      supervisorAttendanceProvider
          .notifier,
    )
        .clearAttendance();
  }

  // ===========================================================
  // FROM DATE
  // ===========================================================

  Future<void> _selectFromDate() async {
    final selected =
    await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selected == null) {
      return;
    }

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
    final selected =
    await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: fromDate,
      lastDate: DateTime(2100),
    );

    if (selected == null) {
      return;
    }

    setState(() {
      toDate = selected;
    });
  }

  // ===========================================================
  // SHOW DETAILS
  // ===========================================================

  Future<void> _showDetails() async {
    final notifier = ref.read(
      supervisorAttendanceProvider
          .notifier,
    );

    if (mode ==
        SupervisorAttendanceMode
            .allEmployees) {
      await notifier.loadTodayAttendance();
      return;
    }

    if (selectedEmployeeId == null) {
      _showMessage(
        'Please select an employee.',
      );
      return;
    }

    await notifier.loadEmployeeAttendance(
      employeeId: selectedEmployeeId!,
      from: fromDate,
      to: toDate,
    );
  }

  // ===========================================================
  // MESSAGE
  // ===========================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // ===========================================================
  // BUILD
  // ===========================================================

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      supervisorAttendanceProvider,
    );

    return Scaffold(
      backgroundColor:
      const Color(0xFFFFF9FF),

      // =======================================================
      // APP BAR
      // =======================================================

      appBar: AppBar(
        backgroundColor:
        const Color(0xFFFFF9FF),
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

      // =======================================================
      // BODY
      // =======================================================

      body: state.isLoading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )
          : state.error != null
          ? _buildError(
        state.error!,
      )
          : ListView(
        padding:
        const EdgeInsets.all(12),
        children: [
          // =========================================
          // DEPARTMENT
          // =========================================

          _buildDepartmentSelector(
            state,
          ),

          const SizedBox(height: 14),

          // =========================================
          // MODE
          // =========================================

          _buildModeSelector(),

          const SizedBox(height: 12),

          // =========================================
          // SELECTED EMPLOYEE
          // =========================================

          if (mode ==
              SupervisorAttendanceMode
                  .selectedEmployee)
            _buildEmployeeSelector(
              state,
            ),

          // =========================================
          // DATE
          // =========================================

          if (mode ==
              SupervisorAttendanceMode
                  .selectedEmployee) ...[
            const SizedBox(height: 10),
            _buildDateFilter(),
          ],

          const SizedBox(height: 14),

          // =========================================
          // SHOW
          // =========================================

          _buildShowButton(),

          const SizedBox(height: 18),

          // =========================================
          // RESULT
          // =========================================

          _buildResult(state),
        ],
      ),
    );
  }

  // ===========================================================
  // DEPARTMENT SELECTOR
  // ===========================================================

  Widget _buildDepartmentSelector(
      SupervisorAttendanceState state,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(10),
        border: Border.all(
          color:
          const Color(0xFF2196F3),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: state.departmentId,
          hint: const Text(
            'Select Department',
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
          ),
          items: state.departments
              .map(
                (department) {
              final id =
              department['id']
                  ?.toString();

              final name =
                  department['name']
                      ?.toString() ??
                      '-';

              if (id == null) {
                return null;
              }

              return DropdownMenuItem<
                  String>(
                value: id,
                child: Text(name),
              );
            },
          )
              .whereType<
              DropdownMenuItem<String>>()
              .toList(),
          onChanged:
          _selectDepartment,
        ),
      ),
    );
  }

  // ===========================================================
  // MODE
  // ===========================================================

  Widget _buildModeSelector() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Attendance Type',
          style: TextStyle(
            fontSize: 15,
            fontWeight:
            FontWeight.w600,
          ),
        ),

        const SizedBox(height: 5),

        Row(
          children: [
            Expanded(
              child: _radio(
                title:
                'All Employees',
                value:
                SupervisorAttendanceMode
                    .allEmployees,
              ),
            ),

            Expanded(
              child: _radio(
                title:
                'Selected Employee',
                value:
                SupervisorAttendanceMode
                    .selectedEmployee,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================
  // RADIO
  // ===========================================================

  Widget _radio({
    required String title,
    required SupervisorAttendanceMode
    value,
  }) {
    return InkWell(
      onTap: () {
        _changeMode(value);
      },
      child: Row(
        children: [
          Radio<
              SupervisorAttendanceMode>(
            value: value,
            groupValue: mode,
            activeColor:
            const Color(0xFF2196F3),
            onChanged: (value) {
              if (value == null) {
                return;
              }

              _changeMode(value);
            },
          ),
          Expanded(
            child: Text(
              title,
              style:
              const TextStyle(
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // EMPLOYEE SELECTOR
  // ===========================================================

  Widget _buildEmployeeSelector(
      SupervisorAttendanceState state,
      ) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(10),
        border: Border.all(
          color:
          const Color(0xFF2196F3),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedEmployeeId,
          hint: const Text(
            'Select Employee',
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
          ),
          items: state.employees
              .map(
                (employee) {
              final id =
              employee['id']
                  ?.toString();

              final name =
                  employee['full_name']
                      ?.toString()
                      ??
                      '${employee['first_name'] ?? ''} ${employee['last_name'] ?? ''}'
                          .trim();

              final code =
                  employee[
                  'employee_code']
                      ?.toString() ??
                      '';

              if (id == null) {
                return null;
              }

              return DropdownMenuItem<
                  String>(
                value: id,
                child: Text(
                  code.isEmpty
                      ? name
                      : '$name ($code)',
                  overflow:
                  TextOverflow.ellipsis,
                ),
              );
            },
          )
              .whereType<
              DropdownMenuItem<String>>()
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedEmployeeId =
                  value;
            });
          },
        ),
      ),
    );
  }

  // ===========================================================
  // DATE FILTER
  // ===========================================================

  Widget _buildDateFilter() {
    return Row(
      children: [
        Expanded(
          child: _dateButton(
            title: 'From Date',
            date: fromDate,
            onTap:
            _selectFromDate,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _dateButton(
            title: 'To Date',
            date: toDate,
            onTap:
            _selectToDate,
          ),
        ),
      ],
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
      borderRadius:
      BorderRadius.circular(8),
      child: Container(
        height: 58,
        padding:
        const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(8),
          border: Border.all(
            color:
            const Color(0xFF2196F3),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month_outlined,
              size: 19,
              color:
              Color(0xFF2196F3),
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
                    style:
                    const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    DateFormat(
                      'dd-MMM-yy',
                    ).format(date),
                    style:
                    const TextStyle(
                      fontSize: 14,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons
                  .keyboard_arrow_down,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // SHOW BUTTON
  // ===========================================================

  Widget _buildShowButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed:
        _showDetails,
        icon: const Icon(
          Icons.search,
        ),
        style:
        ElevatedButton.styleFrom(
          backgroundColor:
          const Color(0xFF2196F3),
          foregroundColor:
          Colors.white,
          padding:
          const EdgeInsets.symmetric(
            vertical: 12,
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
            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),
    );
  }
// ===========================================================
// RESULT
// ===========================================================

  Widget _buildResult(
      SupervisorAttendanceState state,
      ) {
    // ---------------------------------------------------------
    // LOADING
    // ---------------------------------------------------------

    if (state.isLoadingAttendance) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // ---------------------------------------------------------
    // ERROR
    // ---------------------------------------------------------

    if (state.error != null &&
        state.error!.trim().isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Text(
            state.error!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    // ---------------------------------------------------------
    // EMPTY
    // ---------------------------------------------------------

    if (state.attendance.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Text(
            'No attendance found.',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    // ---------------------------------------------------------
    // RESULT
    // ---------------------------------------------------------

    return Column(
      children: state.attendance
          .map<Widget>(
            (attendance) {
          return _buildAttendanceItem(
            attendance,
          );
        },
      )
          .toList(),
    );
  }

  // ===========================================================
  // ATTENDANCE ITEM
  // ===========================================================

  Widget _buildAttendanceItem(
      Map<String, dynamic> item,
      ) {
    final employee =
    item['employees']
    as Map<String, dynamic>?;

    final employeeName =
        employee?['full_name']
            ?.toString() ??
            '-';

    final date =
        item['attendance_date']
            ?.toString() ??
            '-';

    final status =
        item['attendance_status']
            ?.toString() ??
            '-';

    final checkIn =
        item['check_in_time']
            ?.toString() ??
            '-';

    final checkOut =
        item['check_out_time']
            ?.toString() ??
            '-';

    return Container(
      width: double.infinity,
      margin:
      const EdgeInsets.only(
        bottom: 10,
      ),
      padding:
      const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
        const Color(0xFFFFF9FF),
        borderRadius:
        BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(.07),
            blurRadius: 5,
            offset:
            const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  employeeName,
                  style:
                  const TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
              Text(
                date,
                style:
                const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            status,
            style: TextStyle(
              fontSize: 14,
              fontWeight:
              FontWeight.w600,
              color:
              _statusColor(status),
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'In  : $checkIn',
            style:
            const TextStyle(
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Out : $checkOut',
            style:
            const TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // STATUS COLOR
  // ===========================================================

  Color _statusColor(
      String status,
      ) {
    switch (
    status.toUpperCase()) {
      case 'PRESENT':
      case 'ON TIME':
        return Colors.green;

      case 'LATE':
        return Colors.orange;

      case 'ABSENT':
        return Colors.red;

      case 'LEAVE':
        return Colors.deepOrange;

      default:
        return Colors.grey;
    }
  }

  // ===========================================================
  // ERROR
  // ===========================================================

  Widget _buildError(
      String error,
      ) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(20),
        child: Text(
          error,
          textAlign:
          TextAlign.center,
          style: const TextStyle(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

// ===============================================================
// MODE
// ===============================================================

enum SupervisorAttendanceMode {
  allEmployees,
  selectedEmployee,
}