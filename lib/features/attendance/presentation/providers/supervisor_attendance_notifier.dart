/// ===============================================================
/// HRMS Pro
/// Supervisor Attendance Notifier
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/attendance_repository.dart';
import '../../data/repositories/supervisor_attendance_repository.dart';

import 'supervisor_attendance_state.dart';

class SupervisorAttendanceNotifier
    extends StateNotifier<SupervisorAttendanceState> {
  SupervisorAttendanceNotifier({
    required this.supervisorRepository,
    required this.attendanceRepository,
  }) : super(
    const SupervisorAttendanceState(),
  );

  final SupervisorAttendanceRepository
  supervisorRepository;

  final AttendanceRepository
  attendanceRepository;

  // =============================================================
  // INITIALIZE SUPERVISOR
  //
  // employeeId = logged-in supervisor's employee ID
  // =============================================================

  Future<void> initialize(
      String employeeId,
      ) async {
    try {
      state = state.copyWith(
        isLoading: true,
        clearError: true,
      );

      // ---------------------------------------------------------
      // Get supervisor
      // ---------------------------------------------------------

      final supervisor =
      await supervisorRepository
          .getSupervisorByEmployeeId(
        employeeId,
      );

      if (supervisor == null) {
        state = state.copyWith(
          isLoading: false,
          error:
          'Supervisor account was not found.',
        );

        return;
      }

      final supervisorId =
      supervisor['id']?.toString();

      if (supervisorId == null ||
          supervisorId.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error:
          'Supervisor ID was not found.',
        );

        return;
      }

      // ---------------------------------------------------------
      // Get assigned departments
      // ---------------------------------------------------------

      final departments =
      await supervisorRepository
          .getSupervisorDepartments(
        supervisorId,
      );

      state = state.copyWith(
        isLoading: false,
        supervisorId: supervisorId,
        departments: departments,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // =============================================================
  // SELECT DEPARTMENT
  // =============================================================

  Future<void> selectDepartment(
      String departmentId,
      ) async {
    try {
      state = state.copyWith(
        departmentId: departmentId,
        employees: const [],
        attendance: const [],
        isLoadingEmployees: true,
        clearError: true,
      );

      // ---------------------------------------------------------
      // Load employees of selected department
      // ---------------------------------------------------------

      final employees =
      await supervisorRepository
          .getEmployeesByDepartment(
        departmentId,
      );

      state = state.copyWith(
        isLoadingEmployees: false,
        employees: employees,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingEmployees: false,
        error: e.toString(),
      );
    }
  }

  // =============================================================
  // LOAD EMPLOYEE ATTENDANCE
  //
  // Used for:
  //
  // Selected Employee
  // From Date
  // To Date
  // =============================================================

  Future<void> loadEmployeeAttendance({
    required String employeeId,
    required DateTime from,
    required DateTime to,
  }) async {
    final supervisorId =
        state.supervisorId;

    if (supervisorId == null ||
        supervisorId.isEmpty) {
      state = state.copyWith(
        error:
        'Supervisor session is not available.',
      );

      return;
    }

    try {
      state = state.copyWith(
        isLoadingAttendance: true,
        clearError: true,
      );

      // ---------------------------------------------------------
      // Security check
      //
      // Employee must belong to supervisor's
      // assigned department.
      // ---------------------------------------------------------

      final allowed =
      await supervisorRepository
          .isEmployeeUnderSupervisor(
        supervisorId: supervisorId,
        employeeId: employeeId,
      );

      if (!allowed) {
        state = state.copyWith(
          isLoadingAttendance: false,
          error:
          'This employee is not under your assigned department.',
        );

        return;
      }

      // ---------------------------------------------------------
      // Existing Attendance Repository
      // ---------------------------------------------------------

      final result =
      await attendanceRepository
          .getEmployeeAttendanceReport(
        employeeId: employeeId,
        from: from,
        to: to,
      );

      state = state.copyWith(
        isLoadingAttendance: false,
        attendance: result,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingAttendance: false,
        error: e.toString(),
      );
    }
  }

  // =============================================================
  // LOAD TODAY ATTENDANCE
  //
  // Used for:
  //
  // All Employee
  // Today
  // =============================================================

  Future<void> loadTodayAttendance() async {
    final departmentId =
        state.departmentId;

    if (departmentId == null ||
        departmentId.isEmpty) {
      state = state.copyWith(
        error:
        'Please select a department.',
      );

      return;
    }

    try {
      state = state.copyWith(
        isLoadingAttendance: true,
        clearError: true,
      );

      // ---------------------------------------------------------
      // Get employees of selected department
      // ---------------------------------------------------------

      List<Map<String, dynamic>> employees =
          state.employees;

      if (employees.isEmpty) {
        employees =
        await supervisorRepository
            .getEmployeesByDepartment(
          departmentId,
        );

        state = state.copyWith(
          employees: employees,
        );
      }

      if (employees.isEmpty) {
        state = state.copyWith(
          isLoadingAttendance: false,
          attendance: const [],
          clearError: true,
        );

        return;
      }

      // ---------------------------------------------------------
      // Employee IDs
      // ---------------------------------------------------------

      final employeeIds = employees
          .map(
            (employee) =>
            employee['id']?.toString(),
      )
          .whereType<String>()
          .where(
            (id) => id.isNotEmpty,
      )
          .toList();

      if (employeeIds.isEmpty) {
        state = state.copyWith(
          isLoadingAttendance: false,
          attendance: const [],
          clearError: true,
        );

        return;
      }

      // ---------------------------------------------------------
      // Existing Attendance Repository
      // ---------------------------------------------------------

      final attendanceRows =
      await attendanceRepository
          .getTodayAttendanceByEmployees(
        employeeIds,
      );

      // ---------------------------------------------------------
      // Employee map
      // ---------------------------------------------------------

      final Map<String, Map<String, dynamic>>
      employeeMap = {};

      for (final employee in employees) {
        final id =
        employee['id']?.toString();

        if (id != null && id.isNotEmpty) {
          employeeMap[id] = employee;
        }
      }

      // ---------------------------------------------------------
      // Attendance map
      // ---------------------------------------------------------

      final Map<String, dynamic>
      attendanceMap = {};

      for (final attendance
      in attendanceRows) {
        final employeeId =
            attendance.employeeId;

        if (employeeId != null &&
            employeeId.isNotEmpty) {
          attendanceMap[employeeId] =
              attendance;
        }
      }

      // ---------------------------------------------------------
      // Build today's report
      //
      // NOTE:
      // We keep the existing attendance objects.
      // Page can render them according to its UI.
      // ---------------------------------------------------------

      final List<dynamic> result = [];

      for (final employee
      in employees) {
        final employeeId =
        employee['id']?.toString();

        if (employeeId == null ||
            employeeId.isEmpty) {
          continue;
        }

        final attendance =
        attendanceMap[employeeId];

        // -------------------------------------------------------
        // No attendance
        // -------------------------------------------------------

        if (attendance == null) {
          result.add({
            'employee_id': employeeId,
            'employee_code':
            employee['employee_code']
                ?.toString() ??
                '',
            'employee_name':
            _employeeName(employee),
            'department_id':
            employee['department_id']
                ?.toString(),
            'department_name':
            _departmentName(employee),
            'status': 'Absent',
            'attendance': null,
          });

          continue;
        }

        // -------------------------------------------------------
        // Attendance exists
        // -------------------------------------------------------

        String statusText;

        if (attendance.isLeave) {
          statusText = 'Leave';
        } else if (attendance.isHoliday) {
          statusText = 'Holiday';
        } else if (
        attendance.lateMinutes > 0 ||
            attendance.attendanceStatus
                .toUpperCase() ==
                'LATE') {
          statusText = 'Late';
        } else {
          statusText = 'Present';
        }

        result.add({
          'employee_id': employeeId,
          'employee_code':
          employee['employee_code']
              ?.toString() ??
              '',
          'employee_name':
          _employeeName(employee),
          'department_id':
          employee['department_id']
              ?.toString(),
          'department_name':
          _departmentName(employee),
          'status': statusText,
          'attendance': attendance,
        });
      }

      state = state.copyWith(
        isLoadingAttendance: false,
        attendance: result,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingAttendance: false,
        error: e.toString(),
      );
    }
  }

  // =============================================================
  // EMPLOYEE NAME
  // =============================================================

  String _employeeName(
      Map<String, dynamic> employee,
      ) {
    final fullName =
    employee['full_name']
        ?.toString();

    if (fullName != null &&
        fullName.trim().isNotEmpty) {
      return fullName.trim();
    }

    final firstName =
        employee['first_name']
            ?.toString() ??
            '';

    final lastName =
        employee['last_name']
            ?.toString() ??
            '';

    return '$firstName $lastName'.trim();
  }

  // =============================================================
  // DEPARTMENT NAME
  // =============================================================

  String? _departmentName(
      Map<String, dynamic> employee,
      ) {
    final department =
    employee['departments'];

    if (department is Map) {
      return department['name']
          ?.toString();
    }

    return null;
  }

  // =============================================================
  // CLEAR ATTENDANCE
  // =============================================================

  void clearAttendance() {
    state = state.copyWith(
      attendance: const [],
      clearError: true,
    );
  }

  // =============================================================
  // CLEAR ALL
  // =============================================================

  void clear() {
    state =
    const SupervisorAttendanceState();
  }
}