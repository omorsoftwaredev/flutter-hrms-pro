/// ===============================================================
/// HRMS Pro
/// Supervisor Attendance State
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter/foundation.dart';

@immutable
class SupervisorAttendanceState {
  const SupervisorAttendanceState({
    this.isLoading = false,
    this.isLoadingEmployees = false,
    this.isLoadingAttendance = false,
    this.error,
    this.supervisorId,
    this.departmentId,
    this.departments = const [],
    this.employees = const [],
    this.attendance = const [],
  });

  // =============================================================
  // LOADING
  // =============================================================

  final bool isLoading;

  final bool isLoadingEmployees;

  final bool isLoadingAttendance;

  // =============================================================
  // ERROR
  // =============================================================

  final String? error;

  // =============================================================
  // SUPERVISOR
  // =============================================================

  final String? supervisorId;

  // =============================================================
  // SELECTED DEPARTMENT
  // =============================================================

  final String? departmentId;

  // =============================================================
  // DEPARTMENTS
  // =============================================================

  final List<Map<String, dynamic>> departments;

  // =============================================================
  // EMPLOYEES
  // =============================================================

  final List<Map<String, dynamic>> employees;

  // =============================================================
  // ATTENDANCE
  // =============================================================

  final List<dynamic> attendance;

  // =============================================================
  // COPY WITH
  // =============================================================

  SupervisorAttendanceState copyWith({
    bool? isLoading,
    bool? isLoadingEmployees,
    bool? isLoadingAttendance,

    String? error,
    bool clearError = false,

    String? supervisorId,
    String? departmentId,

    List<Map<String, dynamic>>? departments,
    List<Map<String, dynamic>>? employees,

    List<dynamic>? attendance,
  }) {
    return SupervisorAttendanceState(
      isLoading:
      isLoading ?? this.isLoading,

      isLoadingEmployees:
      isLoadingEmployees ??
          this.isLoadingEmployees,

      isLoadingAttendance:
      isLoadingAttendance ??
          this.isLoadingAttendance,

      error: clearError
          ? null
          : error ?? this.error,

      supervisorId:
      supervisorId ?? this.supervisorId,

      departmentId:
      departmentId ?? this.departmentId,

      departments:
      departments ?? this.departments,

      employees:
      employees ?? this.employees,

      attendance:
      attendance ?? this.attendance,
    );
  }
}