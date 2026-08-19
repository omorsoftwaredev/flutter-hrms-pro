import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/attendance_report_model.dart';
import '../../data/repositories/attendance_repository.dart';
import '../../domain/entities/attendance_report_entity.dart';
import '../../domain/entities/attendance_report_filter.dart';
import 'attendance_provider.dart';

// ============================================================
// ATTENDANCE REPORT PROVIDER
// ============================================================

final attendanceReportProvider = StateNotifierProvider<
    AttendanceReportNotifier,
    AsyncValue<List<AttendanceReportModel>>>(
      (ref) {
    return AttendanceReportNotifier(
      ref.read(attendanceRepositoryProvider),
    );
  },
);

// ============================================================
// ATTENDANCE REPORT NOTIFIER
// ============================================================

class AttendanceReportNotifier
    extends StateNotifier<
        AsyncValue<List<AttendanceReportModel>>> {
  AttendanceReportNotifier(this._repository)
      : super(const AsyncData([]));

  final AttendanceRepository _repository;

  // ============================================================
  // LOAD EMPLOYEE ATTENDANCE REPORT
  // ============================================================

  Future<void> loadReport({
    required String employeeId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      state = const AsyncLoading();

      final employee = employeeId.trim();

      if (employee.isEmpty) {
        throw Exception(
          'Employee ID is required.',
        );
      }

      if (from.isAfter(to)) {
        throw Exception(
          'From date cannot be after To date.',
        );
      }

      final result =
      await _repository.getEmployeeAttendanceReport(
        employeeId: employee,
        from: from,
        to: to,
      );

      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // ============================================================
  // CLEAR REPORT
  // ============================================================

  void clearReport() {
    state = const AsyncData([]);
  }

  // ============================================================
  // FILTER REPORT
  // ============================================================

  List<AttendanceReportModel> filter(
      List<AttendanceReportModel> data,
      AttendanceReportFilter filter,
      ) {
    switch (filter) {
    // --------------------------------------------------------
    // ALL
    // --------------------------------------------------------

      case AttendanceReportFilter.all:
        return data;

    // --------------------------------------------------------
    // ON TIME / PRESENT
    // --------------------------------------------------------

      case AttendanceReportFilter.onTime:
        return data.where((item) {
          return item.status ==
              AttendanceReportStatus.present;
        }).toList();

    // --------------------------------------------------------
    // LATE
    // --------------------------------------------------------

      case AttendanceReportFilter.late:
        return data.where((item) {
          return item.status ==
              AttendanceReportStatus.late;
        }).toList();

    // --------------------------------------------------------
    // ABSENT
    // --------------------------------------------------------

      case AttendanceReportFilter.absent:
        return data.where((item) {
          return item.status ==
              AttendanceReportStatus.absent;
        }).toList();

    // --------------------------------------------------------
    // LEAVE
    // --------------------------------------------------------

      case AttendanceReportFilter.leave:
        return data.where((item) {
          return item.status ==
              AttendanceReportStatus.leave;
        }).toList();

      // --------------------------------------------------------
      // EARLY OUT
      // --------------------------------------------------------

      case AttendanceReportFilter.earlyOut:
            return data.where((item) {
            return item.earlyExitMinutes > 0;
      }).toList();

      // --------------------------------------------------------
      // LATE & EARLY OUT
      // --------------------------------------------------------

      case AttendanceReportFilter.lateAndEarlyOut:
            return data.where((item) {
            return item.lateMinutes > 0 &&
            item.earlyExitMinutes > 0;
            }).toList();
      }
  }
}