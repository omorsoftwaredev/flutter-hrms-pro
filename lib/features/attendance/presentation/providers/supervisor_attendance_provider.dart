/// ===============================================================
/// HRMS Pro
/// Supervisor Attendance Provider
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/attendance_repository.dart';
import '../../data/repositories/supervisor_attendance_repository.dart';

import 'attendance_provider.dart';
import 'supervisor_attendance_notifier.dart';
import 'supervisor_attendance_state.dart';

// ===============================================================
// SUPERVISOR ATTENDANCE REPOSITORY
// ===============================================================

final supervisorAttendanceRepositoryProvider =
Provider<SupervisorAttendanceRepository>(
      (ref) {
    return SupervisorAttendanceRepository();
  },
);

// ===============================================================
// SUPERVISOR ATTENDANCE PROVIDER
// ===============================================================

final supervisorAttendanceProvider =
StateNotifierProvider<
    SupervisorAttendanceNotifier,
    SupervisorAttendanceState>(
      (ref) {
    return SupervisorAttendanceNotifier(
      supervisorRepository:
      ref.read(
        supervisorAttendanceRepositoryProvider,
      ),
      attendanceRepository:
      ref.read(
        attendanceRepositoryProvider,
      ),
    );
  },
);