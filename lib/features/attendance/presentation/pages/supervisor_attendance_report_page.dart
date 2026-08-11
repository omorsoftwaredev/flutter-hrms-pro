/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Attendance Report Page
///
/// Version : 2.1.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/attendance_report_entity.dart';
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
  // MODE
  // =============================================================

  SupervisorReportMode selectedMode = SupervisorReportMode.allEmployees;

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

  AttendanceReportFilter selectedFilter = AttendanceReportFilter.all;

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    fromDate = DateTime(now.year, now.month - 1, now.day);

    toDate = DateTime(now.year, now.month, now.day);

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    final supervisorState = ref.watch(supervisorAttendanceProvider);

    final employeeReportState = ref.watch(attendanceReportProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9FF),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF9FF),
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Supervisor Attendance',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: supervisorState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(supervisorState, employeeReportState),
    );
  }

  // =============================================================
  // BODY
  // =============================================================

  Widget _buildBody(
    SupervisorAttendanceState state,
    AsyncValue employeeReportState,
  ) {
    if (state.error != null && state.error!.trim().isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            state.error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red, fontSize: 14),
          ),
        ),
      );
    }

    if (state.departments.isEmpty) {
      return const Center(
        child: Text(
          'No department assigned.',
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 8),

        _buildDepartmentDropdown(state),

        const SizedBox(height: 8),

        _buildModeSelector(),

        const SizedBox(height: 8),

        Expanded(
          child: selectedMode == SupervisorReportMode.allEmployees
              ? _buildTodayAttendance(state)
              : _buildSelectedEmployeeReport(state, employeeReportState),
        ),
      ],
    );
  }

  // =============================================================
  // DEPARTMENT DROPDOWN
  // =============================================================

  Widget _buildDepartmentDropdown(SupervisorAttendanceState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF2196F3)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,

            value: state.departmentId,

            hint: const Text(
              'Select Department',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            items: state.departments
                .map((department) {
                  final id = department['id']?.toString();

                  final name = department['name']?.toString() ?? '';

                  if (id == null) {
                    return null;
                  }

                  return DropdownMenuItem<String>(
                    value: id,
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                })
                .whereType<DropdownMenuItem<String>>()
                .toList(),

            onChanged: (value) async {
              if (value == null) {
                return;
              }

              setState(() {
                selectedEmployeeId = null;
              });

              final notifier = ref.read(supervisorAttendanceProvider.notifier);

              await notifier.selectDepartment(value);

              if (!mounted) {
                return;
              }

              if (selectedMode == SupervisorReportMode.allEmployees) {
                await notifier.loadTodayAttendance();
              }
            },
          ),
        ),
      ),
    );
  }

  // =============================================================
  // MODE SELECTOR
  // =============================================================

  Widget _buildModeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildModeOption(
                title: 'All Employees',
                value: SupervisorReportMode.allEmployees,
              ),
            ),

            Expanded(
              child: _buildModeOption(
                title: 'Selected Employee',
                value: SupervisorReportMode.selectedEmployee,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // MODE OPTION
  // =============================================================

  Widget _buildModeOption({
    required String title,
    required SupervisorReportMode value,
  }) {
    final selected = selectedMode == value;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        await _changeMode(value);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<SupervisorReportMode>(
            value: value,
            groupValue: selectedMode,
            onChanged: (newValue) async {
              if (newValue == null) {
                return;
              }

              await _changeMode(newValue);
            },
            activeColor: const Color(0xFF2196F3),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
          ),

          const SizedBox(width: 2),

          Flexible(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // CHANGE MODE
  // =============================================================

  Future<void> _changeMode(SupervisorReportMode value) async {
    setState(() {
      selectedMode = value;
    });

    final state = ref.read(supervisorAttendanceProvider);

    final departmentId = state.departmentId;

    if (departmentId == null || departmentId.isEmpty) {
      return;
    }

    if (value == SupervisorReportMode.allEmployees) {
      await ref
          .read(supervisorAttendanceProvider.notifier)
          .loadTodayAttendance();
    }
  }

  // =============================================================
  // TODAY ATTENDANCE
  // =============================================================

  Widget _buildTodayAttendance(SupervisorAttendanceState state) {
    if (state.departmentId == null || state.departmentId!.isEmpty) {
      return const Center(
        child: Text(
          'Select a department first.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    if (state.isLoadingAttendance) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.attendance.isEmpty) {
      return const Center(
        child: Text(
          'No attendance found.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        _buildTodayHeader(state.attendance.length),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 4, bottom: 20),
            itemCount: state.attendance.length,
            itemBuilder: (context, index) {
              final item = state.attendance[index];

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

  Widget _buildTodayHeader(int employeeCount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF2196F3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
      ),
      child: Row(
        children: [
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

          Text(
            '$employeeCount Employees',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // TODAY ITEM
  // =============================================================

  Widget _buildTodayItem(dynamic item) {
    final employeeName = _readString(
      item,
      'employeeName',
      fallbackKeys: ['employee_name', 'full_name'],
    );

    final employeeCode = _readString(
      item,
      'employeeCode',
      fallbackKeys: ['employee_code'],
    );

    final statusText = _readString(
      item,
      'statusText',
      fallbackKeys: ['status_text', 'status', 'attendance_status'],
    );

    final checkInTime = _readDateTime(
      item,
      'checkInTime',
      fallbackKeys: ['check_in_time'],
    );

    final checkOutTime = _readDateTime(
      item,
      'checkOutTime',
      fallbackKeys: ['check_out_time'],
    );

    final checkInAddress = _readStringNullable(
      item,
      'checkInAddress',
      fallbackKeys: ['check_in_address'],
    );

    final checkOutAddress = _readStringNullable(
      item,
      'checkOutAddress',
      fallbackKeys: ['check_out_address'],
    );

    final statusColor = _statusColor(statusText);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9FF),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employeeName.isEmpty ? 'Unknown Employee' : employeeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      employeeCode,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText.isEmpty ? 'Unknown' : statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Divider(height: 1),

          const SizedBox(height: 8),

          _todayTimeRow(
            label: 'In',
            time: checkInTime,
            address: checkInAddress,
            suffix: 'Entry',
          ),

          const SizedBox(height: 7),

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
        : DateFormat('hh:mm a').format(time.toLocal());

    final location = address == null || address.trim().isEmpty ? '-' : address;

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black87, fontSize: 13),
        children: [
          TextSpan(
            text: '$label : $timeText - ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: '$location - $suffix'),
        ],
      ),
    );
  }

  // =============================================================
  // SELECTED EMPLOYEE REPORT
  // =============================================================

  Widget _buildSelectedEmployeeReport(
    SupervisorAttendanceState state,
    AsyncValue employeeReportState,
  ) {
    if (state.departmentId == null || state.departmentId!.isEmpty) {
      return const Center(
        child: Text(
          'Select a department first.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        _buildEmployeeDropdown(state),

        const SizedBox(height: 8),

        if (selectedEmployeeId != null) ...[
          _buildDateFilter(),

          const SizedBox(height: 8),

          _buildStatusFilter(),

          const SizedBox(height: 6),

          _buildShowDetailsButton(),
        ],

        const SizedBox(height: 8),

        if (selectedEmployeeId != null) _buildReportHeader(),

        Expanded(
          child: selectedEmployeeId == null
              ? const Center(
                  child: Text(
                    'Select an employee.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : employeeReportState.when(
                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },
                  error: (error, stack) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  },
                  data: (data) {
                    final filtered = ref
                        .read(attendanceReportProvider.notifier)
                        .filter(data, selectedFilter);

                    if (filtered.isEmpty) {
                      return const Center(
                        child: Text(
                          'No attendance found.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 4, bottom: 20),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return AttendanceReportItem(item: filtered[index]);
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

  Widget _buildEmployeeDropdown(SupervisorAttendanceState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF2196F3)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,

            value: _validEmployeeValue(state.employees),

            hint: const Text(
              'Select Employee',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            items: state.employees
                .map((employee) {
                  final id = employee['id']?.toString();

                  if (id == null) {
                    return null;
                  }

                  final name = _employeeName(employee);

                  final code = employee['employee_code']?.toString();

                  final title = code == null || code.isEmpty
                      ? name
                      : '$name ($code)';

                  return DropdownMenuItem<String>(
                    value: id,
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                })
                .whereType<DropdownMenuItem<String>>()
                .toList(),

            onChanged: (value) {
              if (value == null) {
                return;
              }

              setState(() {
                selectedEmployeeId = value;
              });

              ref
                  .read(attendanceReportProvider.notifier)
                  .filter(const [], AttendanceReportFilter.all);
            },
          ),
        ),
      ),
    );
  }

  // =============================================================
  // VALID EMPLOYEE VALUE
  // =============================================================

  String? _validEmployeeValue(List<Map<String, dynamic>> employees) {
    if (selectedEmployeeId == null) {
      return null;
    }

    final exists = employees.any(
      (employee) => employee['id']?.toString() == selectedEmployeeId,
    );

    return exists ? selectedEmployeeId : null;
  }

  // =============================================================
  // EMPLOYEE NAME
  // =============================================================

  String _employeeName(Map<String, dynamic> employee) {
    final fullName = employee['full_name']?.toString();

    if (fullName != null && fullName.trim().isNotEmpty) {
      return fullName;
    }

    final firstName = employee['first_name']?.toString() ?? '';

    final lastName = employee['last_name']?.toString() ?? '';

    return '$firstName $lastName'.trim();
  }

  // =============================================================
  // DATE FILTER
  // =============================================================

  Widget _buildDateFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
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
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF2196F3)),
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    DateFormat('dd-MMM-yy').format(date),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
          ],
        ),
      ),
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

    if (selected == null) {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _radio('All', AttendanceReportFilter.all),

            const SizedBox(width: 8),

            _radio('On Time', AttendanceReportFilter.onTime),

            const SizedBox(width: 8),

            _radio('Late', AttendanceReportFilter.late),

            const SizedBox(width: 8),

            _radio('Absent', AttendanceReportFilter.absent),

            const SizedBox(width: 8),

            _radio('Leave', AttendanceReportFilter.leave),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // RADIO
  // =============================================================

  Widget _radio(String title, AttendanceReportFilter value) {
    final selected = selectedFilter == value;

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
              if (newValue == null) {
                return;
              }

              setState(() {
                selectedFilter = newValue;
              });
            },
            activeColor: const Color(0xFF2196F3),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
          ),

          const SizedBox(width: 2),

          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SHOW DETAILS
  // =============================================================

  Widget _buildShowDetailsButton() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Align(
          alignment: Alignment.center,
          child: ElevatedButton.icon(
            onPressed: _loadSelectedEmployeeReport,
            icon: const Icon(Icons.search, size: 18),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              minimumSize: const Size(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            label: const Text(
              'Show Details',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // LOAD EMPLOYEE REPORT
  // =============================================================

  Future<void> _loadSelectedEmployeeReport() async {
    final employeeId = selectedEmployeeId;

    if (employeeId == null || employeeId.isEmpty) {
      return;
    }

    await ref
        .read(attendanceReportProvider.notifier)
        .loadReport(employeeId: employeeId, from: fromDate, to: toDate);
  }

  // =============================================================
  // REPORT HEADER
  // =============================================================

  Widget _buildReportHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF2196F3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 105,
            child: Text(
              'Date',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Expanded(
            child: Text(
              'Time - Punched Location',
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
      final value = _readDynamicProperty(item, property);

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
    final value = _readString(item, property, fallbackKeys: fallbackKeys);

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
        value = _readDynamicProperty(item, property);
      } catch (_) {}
    }

    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(value.toString());
  }

  // =============================================================
  // DYNAMIC PROPERTY
  // =============================================================

  dynamic _readDynamicProperty(dynamic item, String property) {
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

  Color _statusColor(String status) {
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

enum SupervisorReportMode { allEmployees, selectedEmployee }
