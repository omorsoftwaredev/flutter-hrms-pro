import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/auth/current_user.dart';
import '../../../../core/auth/current_user_provider.dart';
import '../providers/supervisor_attendance_provider.dart'
    hide SupervisorAttendanceState;
import '../providers/supervisor_attendance_state.dart';

class SupervisorEmployeeAttendancePage
    extends ConsumerStatefulWidget {
  const SupervisorEmployeeAttendancePage({
    super.key,
  });

  @override
  ConsumerState<SupervisorEmployeeAttendancePage>
  createState() =>
      _SupervisorEmployeeAttendancePageState();
}

class _SupervisorEmployeeAttendancePageState
    extends ConsumerState<SupervisorEmployeeAttendancePage> {
  // ===========================================================
  // THEME
  // ===========================================================

  static const Color primaryColor = Color(0xFF2196F3);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF172033);
  static const Color secondaryTextColor = Color(0xFF737B8C);
  static const Color borderColor = Color(0xFFE2E7EF);

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
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

    await ref
        .read(
      supervisorAttendanceProvider.notifier,
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
      supervisorAttendanceProvider.notifier,
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
      supervisorAttendanceProvider.notifier,
    )
        .clearAttendance();
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: textColor,
            ),
          ),
          child: child!,
        );
      },
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
    final selected = await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: fromDate,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: textColor,
            ),
          ),
          child: child!,
        );
      },
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
      supervisorAttendanceProvider.notifier,
    );

    if (mode ==
        SupervisorAttendanceMode.allEmployees) {
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
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
      backgroundColor: backgroundColor,

      // =======================================================
      // APP BAR
      // =======================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,

        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: textColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        titleSpacing: 0,

        title: const Text(
          'Employee Attendance',
          style: TextStyle(
            color: textColor,
            fontSize: 19,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ),

      // =======================================================
      // BODY
      // =======================================================

      body: state.isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      )
          : state.error != null
          ? _buildError(
        state.error!,
      )
          : SafeArea(
        child: LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            final bool isDesktop =
                constraints.maxWidth >= 900;

            return Center(
              child: ConstrainedBox(
                constraints:
                BoxConstraints(
                  maxWidth: isDesktop
                      ? 850
                      : double.infinity,
                ),
                child: ListView(
                  padding:
                  EdgeInsets.symmetric(
                    horizontal:
                    isDesktop
                        ? 24
                        : 14,
                    vertical: 16,
                  ),
                  children: [
                    _buildPageHeader(
                      state,
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    _buildSectionLabel(
                      'Department',
                    ),

                    const SizedBox(
                      height: 7,
                    ),

                    _buildDepartmentSelector(
                      state,
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    _buildSectionLabel(
                      'Attendance Type',
                    ),

                    const SizedBox(
                      height: 7,
                    ),

                    _buildModeSelector(),

                    if (mode ==
                        SupervisorAttendanceMode
                            .selectedEmployee) ...[
                      const SizedBox(
                        height: 18,
                      ),

                      _buildSectionLabel(
                        'Employee',
                      ),

                      const SizedBox(
                        height: 7,
                      ),

                      _buildEmployeeSelector(
                        state,
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      _buildSectionLabel(
                        'Date Range',
                      ),

                      const SizedBox(
                        height: 7,
                      ),

                      _buildDateFilter(),
                    ],

                    const SizedBox(
                      height: 18,
                    ),

                    _buildShowButton(),

                    const SizedBox(
                      height: 24,
                    ),

                    _buildResult(state),

                    const SizedBox(
                      height: 20,
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

  // ===========================================================
  // PAGE HEADER
  // ===========================================================

  Widget _buildPageHeader(
      SupervisorAttendanceState state,
      ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2196F3),
            Color(0xFF1976D2),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(
              alpha: 0.18,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.18,
              ),
              borderRadius:
              BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.fact_check_outlined,
              color: Colors.white,
              size: 26,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Attendance Overview',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'View employee attendance records',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          if (state.departmentId != null)
            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.16,
                ),
                borderRadius:
                BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.verified_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  // ===========================================================
  // SECTION LABEL
  // ===========================================================

  Widget _buildSectionLabel(
      String title,
      ) {
    return Text(
      title,
      style: const TextStyle(
        color: textColor,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // ===========================================================
  // DEPARTMENT SELECTOR
  // ===========================================================

  Widget _buildDepartmentSelector(
      SupervisorAttendanceState state,
      ) {
    return _buildControlContainer(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: state.departmentId,

          hint: const Text(
            'Select Department',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 14,
            ),
          ),

          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: secondaryTextColor,
          ),

          items: state.departments.map(
                (department) {
              final id =
              department['id']?.toString();

              final name =
                  department['name']
                      ?.toString() ??
                      '-';

              if (id == null) {
                return null;
              }

              return DropdownMenuItem<String>(
                value: id,
                child: Row(
                  children: [
                    const Icon(
                      Icons.apartment_outlined,
                      size: 19,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        name,
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        const TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
              .whereType<
              DropdownMenuItem<String>>()
              .toList(),

          onChanged: _selectDepartment,
        ),
      ),
    );
  }

  // ===========================================================
  // COMMON CONTROL CONTAINER
  // ===========================================================

  Widget _buildControlContainer({
    required Widget child,
  }) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.025,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // ===========================================================
  // MODE
  // ===========================================================

  Widget _buildModeSelector() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _modeOption(
              title: 'All Employees',
              icon: Icons.groups_outlined,
              value:
              SupervisorAttendanceMode
                  .allEmployees,
            ),
          ),

          const SizedBox(width: 5),

          Expanded(
            child: _modeOption(
              title: 'Selected Employee',
              icon: Icons.person_outline_rounded,
              value:
              SupervisorAttendanceMode
                  .selectedEmployee,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // MODE OPTION
  // ===========================================================

  Widget _modeOption({
    required String title,
    required IconData icon,
    required SupervisorAttendanceMode value,
  }) {
    final selected = mode == value;

    return Material(
      color: selected
          ? primaryColor
          : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          _changeMode(value);
        },
        child: AnimatedContainer(
          duration:
          const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 11,
          ),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected
                    ? Colors.white
                    : secondaryTextColor,
              ),

              const SizedBox(width: 7),

              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : textColor,
                    fontSize: 12,
                    fontWeight: selected
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // EMPLOYEE SELECTOR
  // ===========================================================

  Widget _buildEmployeeSelector(
      SupervisorAttendanceState state,
      ) {
    return _buildControlContainer(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedEmployeeId,

          hint: const Text(
            'Select Employee',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 14,
            ),
          ),

          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: secondaryTextColor,
          ),

          items: state.employees.map(
                (employee) {
              final id =
              employee['id']?.toString();

              final name =
                  employee['full_name']
                      ?.toString() ??
                      '${employee['first_name'] ?? ''} ${employee['last_name'] ?? ''}'
                          .trim();

              final code =
                  employee['employee_code']
                      ?.toString() ??
                      '';

              if (id == null) {
                return null;
              }

              return DropdownMenuItem<String>(
                value: id,
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 19,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        code.isEmpty
                            ? name
                            : '$name ($code)',
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        const TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
              .whereType<
              DropdownMenuItem<String>>()
              .toList(),

          onChanged: (value) {
            setState(() {
              selectedEmployeeId = value;
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
    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final bool compact =
            constraints.maxWidth < 430;

        return Row(
          children: [
            Expanded(
              child: _dateButton(
                title: 'From Date',
                date: fromDate,
                onTap: _selectFromDate,
                compact: compact,
              ),
            ),

            const SizedBox(width: 9),

            Expanded(
              child: _dateButton(
                title: 'To Date',
                date: toDate,
                onTap: _selectToDate,
                compact: compact,
              ),
            ),
          ],
        );
      },
    );
  }

  // ===========================================================
  // DATE BUTTON
  // ===========================================================

  Widget _dateButton({
    required String title,
    required DateTime date,
    required VoidCallback onTap,
    required bool compact,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: compact ? 62 : 68,
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                  BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: primaryColor,
                ),
              ),

              const SizedBox(width: 8),

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
                        fontSize: 10,
                        color:
                        secondaryTextColor,
                        fontWeight:
                        FontWeight.w600,
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
                      style:
                      const TextStyle(
                        color: textColor,
                        fontSize: 13,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons
                    .keyboard_arrow_down_rounded,
                size: 18,
                color: secondaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // SHOW BUTTON
  // ===========================================================

  Widget _buildShowButton() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _showDetails,

        icon: const Icon(
          Icons.search_rounded,
          size: 20,
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,

          shadowColor:
          primaryColor.withValues(
            alpha: 0.25,
          ),

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
            fontWeight: FontWeight.w700,
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
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: _resultBoxDecoration(),
        child: const Column(
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child:
              CircularProgressIndicator(
                strokeWidth: 2.5,
                color: primaryColor,
              ),
            ),
            SizedBox(height: 14),
            Text(
              'Loading attendance...',
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // ---------------------------------------------------------
    // ERROR
    // ---------------------------------------------------------

    if (state.error != null &&
        state.error!.trim().isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: _resultBoxDecoration(),
        child: Column(
          children: [
            _stateIcon(
              icon: Icons.error_outline_rounded,
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            Text(
              state.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    // ---------------------------------------------------------
    // EMPTY
    // ---------------------------------------------------------

    if (state.attendance.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(28),
        decoration: _resultBoxDecoration(),
        child: Column(
          children: [
            _stateIcon(
              icon: Icons.event_busy_outlined,
              color: secondaryTextColor,
            ),
            const SizedBox(height: 12),
            const Text(
              'No attendance found.',
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // ---------------------------------------------------------
    // RESULT
    // ---------------------------------------------------------

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Attendance Records',
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: primaryColor.withValues(
                  alpha: 0.10,
                ),
                borderRadius:
                BorderRadius.circular(20),
              ),
              child: Text(
                '${state.attendance.length}',
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        ...state.attendance.map<Widget>(
              (attendance) {
            return _buildAttendanceItem(
              attendance,
            );
          },
        ),
      ],
    );
  }

  // ===========================================================
  // RESULT BOX
  // ===========================================================

  BoxDecoration _resultBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: borderColor,
      ),
    );
  }

  // ===========================================================
  // STATE ICON
  // ===========================================================

  Widget _stateIcon({
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.08,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 26,
      ),
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

    final statusColor =
    _statusColor(status);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(15),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.035,
            ),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // ---------------------------------------------------
          // TOP
          // ---------------------------------------------------

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(
                    alpha: 0.09,
                  ),
                  borderRadius:
                  BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: primaryColor,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      employeeName,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style:
                      const TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      date,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style:
                      const TextStyle(
                        color:
                        secondaryTextColor,
                        fontSize: 11,
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Divider(
            height: 1,
            color: borderColor,
          ),

          const SizedBox(height: 12),

          // ---------------------------------------------------
          // TIME
          // ---------------------------------------------------

          Row(
            children: [
              Expanded(
                child: _timeInfo(
                  icon:
                  Icons.login_rounded,
                  label: 'Check In',
                  value: checkIn,
                  color: Colors.green,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _timeInfo(
                  icon:
                  Icons.logout_rounded,
                  label: 'Check Out',
                  value: checkOut,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // TIME INFO
  // ===========================================================

  Widget _timeInfo({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius:
        BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 17,
            color: color,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color:
                    secondaryTextColor,
                    fontSize: 10,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  const TextStyle(
                    color: textColor,
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ],
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
    switch (status.toUpperCase()) {
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
        return secondaryTextColor;
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
        padding: const EdgeInsets.all(24),
        child: Container(
          constraints:
          const BoxConstraints(
            maxWidth: 500,
          ),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              _stateIcon(
                icon:
                Icons.error_outline_rounded,
                color: Colors.red,
              ),

              const SizedBox(height: 14),

              const Text(
                'Something went wrong',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                error,
                textAlign:
                TextAlign.center,
                style: const TextStyle(
                  color:
                  secondaryTextColor,
                  fontSize: 13,
                ),
              ),
            ],
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