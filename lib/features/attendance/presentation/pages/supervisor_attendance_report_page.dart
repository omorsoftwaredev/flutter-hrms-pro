/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Attendance Report Page
///
/// UI Update:
/// - Responsive mobile / tablet / desktop layout
/// - Professional light theme
/// - Modern cards and filters
/// - No functionality/business logic changes
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/attendance_report_filter.dart';
import '../providers/attendance_report_provider.dart';
import '../providers/supervisor_attendance_provider.dart';
import '../providers/supervisor_attendance_state.dart';
import '../widgets/attendance_report_item.dart';

class SupervisorAttendanceReportPage extends ConsumerStatefulWidget {
  const SupervisorAttendanceReportPage({
    super.key,
    required this.supervisorEmployeeId,
  });

  final String supervisorEmployeeId;

  @override
  ConsumerState<SupervisorAttendanceReportPage> createState() =>
      _SupervisorAttendanceReportPageState();
}

class _SupervisorAttendanceReportPageState
    extends ConsumerState<SupervisorAttendanceReportPage> {
  // =============================================================
  // THEME
  // =============================================================

  static const Color primaryColor = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFFEAF3FF);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF17202A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE3E8EF);

  // =============================================================
  // MODE
  // =============================================================

  SupervisorReportMode selectedMode =
      SupervisorReportMode.allEmployees;

  // =============================================================
  // DATE
  // =============================================================

  late DateTime fromDate;
  late DateTime toDate;

  // =============================================================
  // EMPLOYEE
  // =============================================================

  String? selectedEmployeeId;

  // =============================================================
  // REPORT FILTER
  // =============================================================

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
      if (!mounted) {
        return;
      }

      ref
          .read(supervisorAttendanceProvider.notifier)
          .initialize(widget.supervisorEmployeeId);
    });
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final supervisorState =
    ref.watch(supervisorAttendanceProvider);

    final employeeReportState =
    ref.watch(attendanceReportProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(supervisorState),
      body: supervisorState.isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      )
          : _buildResponsiveBody(
        supervisorState,
        employeeReportState,
      ),
    );
  }

  // =============================================================
  // APP BAR
  // =============================================================

  PreferredSizeWidget _buildAppBar(
      SupervisorAttendanceState state,
      ) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,

      leading: IconButton(
        tooltip: 'Back',
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: textPrimary,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),

      title: const Text(
        'Supervisor Attendance',
        style: TextStyle(
          color: textPrimary,
          fontSize: 19,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),

      actions: [
        IconButton(
          tooltip: 'Refresh',
          onPressed: state.isLoading ? null : _refresh,
          icon: const Icon(
            Icons.refresh_rounded,
            color: textPrimary,
          ),
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  // =============================================================
  // RESPONSIVE BODY
  // =============================================================

  Widget _buildResponsiveBody(
      SupervisorAttendanceState state,
      AsyncValue employeeReportState,
      ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final horizontalPadding = width >= 1200
            ? 32.0
            : width >= 700
            ? 24.0
            : 12.0;

        final maxContentWidth = width >= 1200
            ? 1100.0
            : width >= 700
            ? 900.0
            : double.infinity;

        return SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxContentWidth,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 12,
                ),
                child: _buildBody(
                  state,
                  employeeReportState,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // =============================================================
  // BODY
  // =============================================================

  Widget _buildBody(
      SupervisorAttendanceState state,
      AsyncValue employeeReportState,
      ) {
    if (state.error != null &&
        state.error!.trim().isNotEmpty) {
      return _buildErrorState(state.error!);
    }

    if (state.departments.isEmpty) {
      return _buildEmptyState(
        icon: Icons.domain_disabled_rounded,
        message: 'No department assigned.',
      );
    }

    return Column(
      children: [
        _buildDepartmentDropdown(state),

        const SizedBox(height: 12),

        _buildModeSelector(),

        const SizedBox(height: 12),

        Expanded(
          child: selectedMode ==
              SupervisorReportMode.allEmployees
              ? _buildTodayAttendance(state)
              : _buildSelectedEmployeeReport(
            state,
            employeeReportState,
          ),
        ),
      ],
    );
  }

  // =============================================================
  // ERROR STATE
  // =============================================================

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: _cardDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 32,
                  color: Colors.red,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Something went wrong',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 18),

              ElevatedButton.icon(
                onPressed: _refresh,
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 18,
                ),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // EMPTY STATE
  // =============================================================

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              color: textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // CARD DECORATION
  // =============================================================

  BoxDecoration _cardDecoration({
    Color color = cardColor,
    double radius = 12,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: borderColor,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.035),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  // =============================================================
  // DEPARTMENT DROPDOWN
  // =============================================================

  Widget _buildDepartmentDropdown(
      SupervisorAttendanceState state,
      ) {
    final validDepartmentId =
    _validDepartmentValue(state);

    return _filterContainer(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: validDepartmentId,

          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: textSecondary,
          ),

          hint: const Row(
            children: [
              Icon(
                Icons.domain_rounded,
                size: 19,
                color: primaryColor,
              ),
              SizedBox(width: 10),
              Text(
                'Select Department',
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          items: state.departments
              .map((department) {
            final id = department['id']
                ?.toString()
                .trim();

            if (id == null || id.isEmpty) {
              return null;
            }

            final name = department['name']
                ?.toString()
                .trim() ??
                '';

            return DropdownMenuItem<String>(
              value: id,
              child: Text(
                name.isEmpty
                    ? 'Unnamed Department'
                    : name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          })
              .whereType<DropdownMenuItem<String>>()
              .toList(),

          onChanged: (value) async {
            if (value == null ||
                value.trim().isEmpty) {
              return;
            }

            await _changeDepartment(value);
          },
        ),
      ),
    );
  }

  // =============================================================
  // FILTER CONTAINER
  // =============================================================

  Widget _filterContainer({
    required Widget child,
  }) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      decoration: _cardDecoration(),
      child: child,
    );
  }

  // =============================================================
  // VALID DEPARTMENT VALUE
  // =============================================================

  String? _validDepartmentValue(
      SupervisorAttendanceState state,
      ) {
    final departmentId =
        state.departmentId;

    if (departmentId == null ||
        departmentId.trim().isEmpty) {
      return null;
    }

    final exists = state.departments.any(
          (department) =>
      department['id']
          ?.toString()
          .trim() ==
          departmentId.trim(),
    );

    return exists ? departmentId : null;
  }

  // =============================================================
  // CHANGE DEPARTMENT
  // =============================================================

  Future<void> _changeDepartment(
      String departmentId,
      ) async {
    setState(() {
      selectedEmployeeId = null;
      selectedFilter =
          AttendanceReportFilter.all;
    });

    final notifier =
    ref.read(
      supervisorAttendanceProvider.notifier,
    );

    await notifier.selectDepartment(
      departmentId,
    );

    if (!mounted) {
      return;
    }

    if (selectedMode ==
        SupervisorReportMode.allEmployees) {
      await notifier.loadTodayAttendance();
    }
  }

  // =============================================================
  // MODE SELECTOR
  // =============================================================

  Widget _buildModeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: _cardDecoration(
        color: const Color(0xFFF1F4F8),
        radius: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildModeOption(
              title: 'All Employees',
              icon: Icons.groups_rounded,
              value:
              SupervisorReportMode.allEmployees,
            ),
          ),
          Expanded(
            child: _buildModeOption(
              title: 'Selected Employee',
              icon: Icons.person_rounded,
              value:
              SupervisorReportMode.selectedEmployee,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // MODE OPTION
  // =============================================================

  Widget _buildModeOption({
    required String title,
    required IconData icon,
    required SupervisorReportMode value,
  }) {
    final selected =
        selectedMode == value;

    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: () async {
        await _changeMode(value);
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: selected
              ? [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 17,
              color: selected
                  ? primaryColor
                  : textSecondary,
            ),

            const SizedBox(width: 6),

            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: selected
                      ? primaryColor
                      : textSecondary,
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // CHANGE MODE
  // =============================================================

  Future<void> _changeMode(
      SupervisorReportMode value,
      ) async {
    setState(() {
      selectedMode = value;
    });

    final state =
    ref.read(
      supervisorAttendanceProvider,
    );

    final departmentId =
        state.departmentId;

    if (departmentId == null ||
        departmentId.trim().isEmpty) {
      return;
    }

    if (value ==
        SupervisorReportMode.allEmployees) {
      await ref
          .read(
        supervisorAttendanceProvider
            .notifier,
      )
          .loadTodayAttendance();
    }
  }

  // =============================================================
  // TODAY ATTENDANCE
  // =============================================================

  Widget _buildTodayAttendance(
      SupervisorAttendanceState state,
      ) {
    if (state.departmentId == null ||
        state.departmentId!.trim().isEmpty) {
      return _buildEmptyState(
        icon: Icons.domain_rounded,
        message: 'Select a department first.',
      );
    }

    if (state.isLoadingAttendance) {
      return const Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      );
    }

    if (state.attendance.isEmpty) {
      return _buildEmptyState(
        icon: Icons.event_busy_rounded,
        message: 'No attendance found.',
      );
    }

    return Column(
      children: [
        _buildTodayHeader(
          state.attendance.length,
        ),

        const SizedBox(height: 4),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(
              top: 2,
              bottom: 24,
            ),
            itemCount:
            state.attendance.length,
            itemBuilder:
                (context, index) {
              final item =
              state.attendance[index];

              return _buildTodayItem(item);
            },
          ),
        ),
      ],
    );
  }

  // =============================================================
  // TODAY HEADER
  // =============================================================

  Widget _buildTodayHeader(
      int employeeCount,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryColor
                .withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.today_rounded,
            color: Colors.white,
            size: 19,
          ),

          const SizedBox(width: 9),

          const Expanded(
            child: Text(
              "Today's Attendance",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
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
              color: Colors.white
                  .withValues(alpha: 0.16),
              borderRadius:
              BorderRadius.circular(20),
            ),
            child: Text(
              '$employeeCount Employees',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // TODAY ITEM
  // =============================================================

  Widget _buildTodayItem(
      dynamic item,
      ) {
    final employeeName =
    _readString(
      item,
      'employeeName',
      fallbackKeys: [
        'employee_name',
        'full_name',
      ],
    );

    final employeeCode =
    _readString(
      item,
      'employeeCode',
      fallbackKeys: [
        'employee_code',
      ],
    );

    final statusText =
    _readString(
      item,
      'statusText',
      fallbackKeys: [
        'status_text',
        'status',
        'attendance_status',
      ],
    );

    final checkInTime =
    _readDateTime(
      item,
      'checkInTime',
      fallbackKeys: [
        'check_in_time',
      ],
    );

    final checkOutTime =
    _readDateTime(
      item,
      'checkOutTime',
      fallbackKeys: [
        'check_out_time',
      ],
    );

    final checkInAddress =
    _readStringNullable(
      item,
      'checkInAddress',
      fallbackKeys: [
        'check_in_address',
      ],
    );

    final checkOutAddress =
    _readStringNullable(
      item,
      'checkOutAddress',
      fallbackKeys: [
        'check_out_address',
      ],
    );

    final statusColor =
    _statusColor(statusText);

    return Container(
      margin: const EdgeInsets.only(
        top: 7,
        bottom: 2,
      ),
      padding: const EdgeInsets.all(15),
      decoration: _cardDecoration(
        radius: 13,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: primaryLight,
                  borderRadius:
                  BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: primaryColor,
                  size: 22,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      employeeName.isEmpty
                          ? 'Unknown Employee'
                          : employeeName,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style:
                      const TextStyle(
                        fontSize: 15,
                        color: textPrimary,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      employeeCode.isEmpty
                          ? 'No employee code'
                          : employeeCode,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style:
                      const TextStyle(
                        fontSize: 11,
                        color: textSecondary,
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              _statusChip(
                statusText.isEmpty
                    ? 'Unknown'
                    : statusText,
                statusColor,
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            height: 1,
            color: borderColor,
          ),

          const SizedBox(height: 11),

          _todayTimeRow(
            label: 'In',
            time: checkInTime,
            address: checkInAddress,
            suffix: 'Entry',
          ),

          const SizedBox(height: 9),

          _todayTimeRow(
            label: 'Out',
            time: checkOutTime,
            address: checkOutAddress,
            suffix: 'Exit',
          ),
        ],
      ),
    );
  }

  // =============================================================
  // STATUS CHIP
  // =============================================================

  Widget _statusChip(
      String text,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // =============================================================
  // TODAY TIME ROW
  // =============================================================

  Widget _todayTimeRow({
    required String label,
    required DateTime? time,
    required String? address,
    required String suffix,
  }) {
    final timeText = time == null
        ? '-'
        : DateFormat(
      'hh:mm a',
    ).format(
      time.toLocal(),
    );

    final location =
    address == null ||
        address.trim().isEmpty
        ? '-'
        : address;

    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: primaryLight,
            borderRadius:
            BorderRadius.circular(8),
          ),
          child: Icon(
            label == 'In'
                ? Icons.login_rounded
                : Icons.logout_rounded,
            size: 15,
            color: primaryColor,
          ),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: textSecondary,
                fontSize: 12,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text:
                  '$label : $timeText',
                  style: const TextStyle(
                    color: textPrimary,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                  '  •  $location  •  $suffix',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // SELECTED EMPLOYEE REPORT
  // =============================================================

  Widget _buildSelectedEmployeeReport(
      SupervisorAttendanceState state,
      AsyncValue employeeReportState,
      ) {
    if (state.departmentId == null ||
        state.departmentId!.trim().isEmpty) {
      return _buildEmptyState(
        icon: Icons.domain_rounded,
        message: 'Select a department first.',
      );
    }

    return Column(
      children: [
        _buildEmployeeDropdown(state),

        const SizedBox(height: 10),

        if (selectedEmployeeId != null) ...[
          _buildDateFilter(),

          const SizedBox(height: 10),

          _buildStatusFilter(),

          const SizedBox(height: 6),

          _buildShowDetailsButton(),
        ],

        const SizedBox(height: 10),

        if (selectedEmployeeId != null)
          _buildReportHeader(),

        Expanded(
          child: selectedEmployeeId == null
              ? _buildEmptyState(
            icon: Icons.person_search_rounded,
            message: 'Select an employee.',
          )
              : employeeReportState.when(
            loading: () {
              return const Center(
                child:
                CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            },
            error: (error, stack) {
              return Center(
                child: Padding(
                  padding:
                  const EdgeInsets.all(
                    20,
                  ),
                  child: Text(
                    error.toString(),
                    textAlign:
                    TextAlign.center,
                    style:
                    const TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
            data: (data) {
              final filtered =
              ref
                  .read(
                attendanceReportProvider
                    .notifier,
              )
                  .filter(
                data,
                selectedFilter,
              );

              if (filtered.isEmpty) {
                return _buildEmptyState(
                  icon:
                  Icons.event_busy_rounded,
                  message:
                  'No attendance found.',
                );
              }

              return ListView.builder(
                padding:
                const EdgeInsets.only(
                  top: 4,
                  bottom: 20,
                ),
                itemCount:
                filtered.length,
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
    );
  }

  // =============================================================
  // EMPLOYEE DROPDOWN
  // =============================================================

  Widget _buildEmployeeDropdown(
      SupervisorAttendanceState state,
      ) {
    final employeeValue =
    _validEmployeeValue(
      state.employees,
    );

    return _filterContainer(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: employeeValue,

          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: textSecondary,
          ),

          hint: const Row(
            children: [
              Icon(
                Icons.person_search_rounded,
                size: 19,
                color: primaryColor,
              ),
              SizedBox(width: 10),
              Text(
                'Select Employee',
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          items: state.employees
              .map((employee) {
            final id =
            employee['id']
                ?.toString()
                .trim();

            if (id == null || id.isEmpty) {
              return null;
            }

            final name =
            _employeeName(employee);

            final code =
            employee['employee_code']
                ?.toString()
                .trim();

            final title =
            code == null || code.isEmpty
                ? name
                : '$name ($code)';

            return DropdownMenuItem<String>(
              value: id,
              child: Text(
                title.isEmpty
                    ? 'Unknown Employee'
                    : title,
                overflow:
                TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          })
              .whereType<
              DropdownMenuItem<String>>()
              .toList(),

          onChanged: (value) {
            if (value == null ||
                value.trim().isEmpty) {
              return;
            }

            setState(() {
              selectedEmployeeId = value;

              selectedFilter =
                  AttendanceReportFilter.all;
            });
          },
        ),
      ),
    );
  }

  // =============================================================
  // VALID EMPLOYEE VALUE
  // =============================================================

  String? _validEmployeeValue(
      List<Map<String, dynamic>> employees,
      ) {
    final employeeId =
        selectedEmployeeId;

    if (employeeId == null ||
        employeeId.trim().isEmpty) {
      return null;
    }

    final exists = employees.any(
          (employee) =>
      employee['id']
          ?.toString()
          .trim() ==
          employeeId.trim(),
    );

    return exists ? employeeId : null;
  }

  // =============================================================
  // EMPLOYEE NAME
  // =============================================================

  String _employeeName(
      Map<String, dynamic> employee,
      ) {
    final fullName =
    employee['full_name']
        ?.toString()
        .trim();

    if (fullName != null &&
        fullName.isNotEmpty) {
      return fullName;
    }

    final firstName =
        employee['first_name']
            ?.toString()
            .trim() ??
            '';

    final lastName =
        employee['last_name']
            ?.toString()
            .trim() ??
            '';

    return '$firstName $lastName'.trim();
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
    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(12),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 7,
        ),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: primaryLight,
                borderRadius:
                BorderRadius.circular(9),
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
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
                    style:
                    const TextStyle(
                      fontSize: 10,
                      color: textSecondary,
                      fontWeight:
                      FontWeight.w600,
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
                    style:
                    const TextStyle(
                      fontSize: 13,
                      color: textPrimary,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // FROM DATE
  // =============================================================

  Future<void> _selectFromDate() async {
    final selected =
    await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
            Theme.of(context)
                .colorScheme
                .copyWith(
              primary: primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected == null ||
        !mounted) {
      return;
    }

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
    final selected =
    await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: fromDate,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
            Theme.of(context)
                .colorScheme
                .copyWith(
              primary: primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected == null ||
        !mounted) {
      return;
    }

    setState(() {
      toDate = selected;
    });
  }

  // =============================================================
  // STATUS FILTER
  // =============================================================

  Widget _buildStatusFilter() {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding:
        const EdgeInsets.symmetric(
          horizontal: 2,
        ),
        child: Row(
          children: [
            _radio(
              'All',
              AttendanceReportFilter.all,
            ),
            const SizedBox(width: 5),
            _radio(
              'On Time',
              AttendanceReportFilter.onTime,
            ),
            const SizedBox(width: 5),
            _radio(
              'Late',
              AttendanceReportFilter.late,
            ),
            const SizedBox(width: 5),
            _radio(
              'Absent',
              AttendanceReportFilter.absent,
            ),
            const SizedBox(width: 5),
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
    final selected =
        selectedFilter == value;

    return InkWell(
      borderRadius:
      BorderRadius.circular(20),
      onTap: () {
        setState(() {
          selectedFilter = value;
        });
      },
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: selected
              ? primaryLight
              : Colors.transparent,
          borderRadius:
          BorderRadius.circular(20),
          border: selected
              ? Border.all(
            color: primaryColor
                .withValues(alpha: 0.18),
          )
              : null,
        ),
        child: Row(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Radio<AttendanceReportFilter>(
              value: value,
              groupValue:
              selectedFilter,
              onChanged: (newValue) {
                if (newValue == null) {
                  return;
                }

                setState(() {
                  selectedFilter = newValue;
                });
              },
              activeColor: primaryColor,
              materialTapTargetSize:
              MaterialTapTargetSize.shrinkWrap,
              visualDensity:
              const VisualDensity(
                horizontal: -4,
                vertical: -4,
              ),
            ),

            const SizedBox(width: 1),

            Text(
              title,
              style: TextStyle(
                color: selected
                    ? primaryColor
                    : textSecondary,
                fontSize: 11,
                fontWeight: selected
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // SHOW DETAILS BUTTON
  // =============================================================

  Widget _buildShowDetailsButton() {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton.icon(
        onPressed:
        _loadSelectedEmployeeReport,
        icon: const Icon(
          Icons.search_rounded,
          size: 18,
        ),
        label: const Text(
          'Show Details',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // LOAD EMPLOYEE REPORT
  // =============================================================

  Future<void>
  _loadSelectedEmployeeReport() async {
    final employeeId =
        selectedEmployeeId;

    if (employeeId == null ||
        employeeId.trim().isEmpty) {
      return;
    }

    if (fromDate.isAfter(toDate)) {
      _showMessage(
        'From date cannot be after To date.',
      );
      return;
    }

    await ref
        .read(
      attendanceReportProvider
          .notifier,
    )
        .loadReport(
      employeeId: employeeId,
      from: fromDate,
      to: toDate,
    );
  }

  // =============================================================
  // REPORT HEADER
  // =============================================================

  Widget _buildReportHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius:
        BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 105,
            child: Text(
              'Date',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Expanded(
            child: Text(
              'Time - Punched Location',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // REFRESH
  // =============================================================

  Future<void> _refresh() async {
    final notifier =
    ref.read(
      supervisorAttendanceProvider
          .notifier,
    );

    await notifier.initialize(
      widget.supervisorEmployeeId,
    );

    if (!mounted) {
      return;
    }

    final state =
    ref.read(
      supervisorAttendanceProvider,
    );

    if (state.departmentId != null &&
        state.departmentId!
            .trim()
            .isNotEmpty &&
        selectedMode ==
            SupervisorReportMode.allEmployees) {
      await notifier.loadTodayAttendance();
    }
  }

  // =============================================================
  // MESSAGE
  // =============================================================

  void _showMessage(
      String message,
      ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        behavior:
        SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(10),
        ),
      ),
    );
  }

  // =============================================================
  // READ STRING
  // =============================================================

  String _readString(
      dynamic item,
      String property, {
        List<String> fallbackKeys = const [],
      }) {
    if (item is Map) {
      final value = item[property];

      if (value != null) {
        return value.toString();
      }

      for (final key in fallbackKeys) {
        final fallback = item[key];

        if (fallback != null) {
          return fallback.toString();
        }
      }

      return '';
    }

    try {
      final value =
      _readDynamicProperty(
        item,
        property,
      );

      if (value != null) {
        return value.toString();
      }
    } catch (_) {}

    return '';
  }

  // =============================================================
  // READ NULLABLE STRING
  // =============================================================

  String? _readStringNullable(
      dynamic item,
      String property, {
        List<String> fallbackKeys = const [],
      }) {
    final value = _readString(
      item,
      property,
      fallbackKeys: fallbackKeys,
    );

    if (value.trim().isEmpty) {
      return null;
    }

    return value;
  }

  // =============================================================
  // READ DATETIME
  // =============================================================

  DateTime? _readDateTime(
      dynamic item,
      String property, {
        List<String> fallbackKeys = const [],
      }) {
    dynamic value;

    if (item is Map) {
      value = item[property];

      if (value == null) {
        for (final key in fallbackKeys) {
          value = item[key];

          if (value != null) {
            break;
          }
        }
      }
    } else {
      try {
        value =
            _readDynamicProperty(
              item,
              property,
            );
      } catch (_) {}
    }

    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(
      value.toString(),
    );
  }

  // =============================================================
  // DYNAMIC PROPERTY
  // =============================================================

  dynamic _readDynamicProperty(
      dynamic item,
      String property,
      ) {
    switch (property) {
      case 'employeeName':
        return item.employeeName;

      case 'employeeCode':
        return item.employeeCode;

      case 'statusText':
        return item.statusText;

      case 'checkInTime':
        return item.checkInTime;

      case 'checkOutTime':
        return item.checkOutTime;

      case 'checkInAddress':
        return item.checkInAddress;

      case 'checkOutAddress':
        return item.checkOutAddress;

      default:
        return null;
    }
  }

  // =============================================================
  // STATUS COLOR
  // =============================================================

  Color _statusColor(
      String status,
      ) {
    switch (status.trim().toLowerCase()) {
      case 'present':
      case 'on time':
        return Colors.green;

      case 'late':
        return Colors.red;

      case 'absent':
        return Colors.red;

      case 'leave':
        return Colors.orange;

      case 'holiday':
        return Colors.blue;

      case 'day off':
      case 'dayoff':
        return Colors.grey;

      default:
        return Colors.grey;
    }
  }
}

// ===============================================================
// ENUM
// ===============================================================

enum SupervisorReportMode {
  allEmployees,
  selectedEmployee,
}