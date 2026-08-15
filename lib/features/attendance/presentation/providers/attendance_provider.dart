/// ===============================================================
/// Flutter HRMS Pro
/// Attendance Provider
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/attendance_model.dart';
import '../../data/repositories/attendance_repository.dart';
import '../../domain/entities/attendance_entity.dart';

//==============================================================
// REPOSITORY PROVIDER
//==============================================================

final attendanceRepositoryProvider =
Provider<AttendanceRepository>((ref) {
  return AttendanceRepository();
});

//==============================================================
// ATTENDANCE PROVIDER
//==============================================================

final attendanceProvider = StateNotifierProvider<
    AttendanceNotifier,
    AsyncValue<List<AttendanceEntity>>>(
      (ref) {
    return AttendanceNotifier(
      ref.read(attendanceRepositoryProvider),
    );
  },
);

//==============================================================
// ATTENDANCE NOTIFIER
//==============================================================

class AttendanceNotifier
    extends StateNotifier<
        AsyncValue<List<AttendanceEntity>>> {
  AttendanceNotifier(this._repository)
      : super(const AsyncLoading()) {
    loadAttendance();
  }

  final AttendanceRepository _repository;

  //============================================================
  // LOAD ALL
  //============================================================

  Future<void> loadAttendance() async {
    try {
      state = const AsyncLoading();

      final attendance =
      await _repository.getAll();

      state = AsyncData(attendance);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  //============================================================
  // REFRESH
  //============================================================

  Future<void> refresh() async {
    await loadAttendance();
  }

  //============================================================
  // SEARCH
  //============================================================

  Future<void> search(
      String keyword,
      ) async {
    try {
      if (keyword.trim().isEmpty) {
        await loadAttendance();
        return;
      }

      state = const AsyncLoading();

      final attendance =
      await _repository.search(
        keyword.trim(),
      );

      state = AsyncData(attendance);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  //============================================================
  // INSERT
  //============================================================

  Future<bool> insert(
      AttendanceEntity attendance,
      ) async {
    try {
      final model =
      AttendanceModel.fromEntity(
        attendance,
      );

      await _repository.insert(model);

      await loadAttendance();

      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  //============================================================
  // UPDATE
  //============================================================

  Future<bool> update(
      AttendanceEntity attendance,
      ) async {
    try {
      final model =
      AttendanceModel.fromEntity(
        attendance,
      );

      await _repository.update(model);

      await loadAttendance();

      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  //============================================================
  // DELETE
  //============================================================

  Future<bool> delete(
      String id,
      ) async {
    try {
      await _repository.delete(id);

      await loadAttendance();

      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  //============================================================
  // GET TODAY ATTENDANCE
  //============================================================

  Future<AttendanceEntity?> getTodayAttendance(
      String employeeId,
      ) async {
    try {
      return await _repository
          .getTodayAttendance(
        employeeId,
      );
    } catch (_) {
      return null;
    }
  }

  //============================================================
  // CHECK-IN
  //============================================================

  Future<bool> checkIn({
    required AttendanceEntity attendance,
  }) async {
    try {
      final model =
      AttendanceModel.fromEntity(
        attendance,
      );

      await _repository.insert(model);

      await loadAttendance();

      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  //============================================================
  // CHECK-OUT
  //============================================================

  Future<bool> checkOut({
    required String attendanceId,
    required DateTime checkOutTime,
    double? latitude,
    double? longitude,
  }) async {
    try {
      await _repository.checkOut(
        attendanceId: attendanceId,
        checkOutTime: checkOutTime,
        latitude: latitude,
        longitude: longitude,
      );

      await loadAttendance();

      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  //============================================================
  // EMPLOYEE ATTENDANCE
  //============================================================

  Future<void> employeeAttendance(
      String employeeId,
      ) async {
    try {
      state = const AsyncLoading();

      final attendance =
      await _repository
          .getEmployeeAttendance(
        employeeId,
      );

      state = AsyncData(attendance);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  //============================================================
  // TODAY ATTENDANCE LIST
  //============================================================

  Future<void> todayAttendance() async {
    try {
      state = const AsyncLoading();

      final attendance =
      await _repository
          .todayAttendance();

      state = AsyncData(attendance);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}