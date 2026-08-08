import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/attendance_report_model.dart';
import '../../data/repositories/attendance_repository.dart';
import '../../domain/entities/attendance_report_entity.dart';
import '../../domain/entities/attendance_report_filter.dart';
import 'attendance_provider.dart';

final attendanceReportProvider = StateNotifierProvider<
    AttendanceReportNotifier,
    AsyncValue<List<AttendanceReportModel>>>(
      (ref) {
    return AttendanceReportNotifier(
      ref.read(attendanceRepositoryProvider),
    );
  },
);

class AttendanceReportNotifier
    extends StateNotifier<
        AsyncValue<List<AttendanceReportModel>>> {
  AttendanceReportNotifier(this._repository)
      : super(const AsyncData([]));

  final AttendanceRepository _repository;

  Future<void> loadReport({
    required String employeeId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      state = const AsyncLoading();

      final result =
      await _repository.getEmployeeAttendanceReport(
        employeeId: employeeId,
        from: from,
        to: to,
      );

      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  List<AttendanceReportModel> filter(
      List<AttendanceReportModel> data,
      AttendanceReportFilter filter,
      ) {
    switch (filter) {
      case AttendanceReportFilter.all:
        return data;

      case AttendanceReportFilter.onTime:
        return data.where((item) {
          return item.status ==
              AttendanceReportStatus.present;
        }).toList();

      case AttendanceReportFilter.late:
        return data.where((item) {
          return item.status ==
              AttendanceReportStatus.late;
        }).toList();

      case AttendanceReportFilter.absent:
        return data.where((item) {
          return item.status ==
              AttendanceReportStatus.absent;
        }).toList();

      case AttendanceReportFilter.leave:
        return data.where((item) {
          return item.status ==
              AttendanceReportStatus.leave;
        }).toList();
    }
  }
}