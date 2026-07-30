import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/attendance_repository.dart';
import '../../domain/entities/attendance_entity.dart';

final attendanceRepositoryProvider =
Provider<AttendanceRepository>(
      (ref) => AttendanceRepository(),
);

final attendanceProvider =
StateNotifierProvider<
    AttendanceNotifier,
    AsyncValue<List<AttendanceEntity>>>(
      (ref) => AttendanceNotifier(
    ref.read(attendanceRepositoryProvider),
  ),
);

class AttendanceNotifier
    extends StateNotifier<
        AsyncValue<List<AttendanceEntity>>> {
  AttendanceNotifier(this._repository)
      : super(const AsyncLoading()) {
    loadAttendance();
  }

  final AttendanceRepository _repository;

  ///=====================================
  /// LOAD
  ///=====================================

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

  ///=====================================
  /// REFRESH
  ///=====================================

  Future<void> refresh() async {
    await loadAttendance();
  }

  ///=====================================
  /// SEARCH
  ///=====================================

  Future<void> search(
      String keyword,
      ) async {
    try {
      state = const AsyncLoading();

      if (keyword.trim().isEmpty) {
        await loadAttendance();
        return;
      }

      final attendance =
      await _repository.search(keyword);

      state = AsyncData(attendance);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  ///=====================================
  /// INSERT
  ///=====================================

  Future<bool> insert(
      AttendanceEntity attendance,
      ) async {
    try {
      await _repository.insert(attendance);

      await loadAttendance();

      return true;
    } catch (_) {
      return false;
    }
  }

  ///=====================================
  /// UPDATE
  ///=====================================

  Future<bool> update(
      AttendanceEntity attendance,
      ) async {
    try {
      await _repository.update(attendance);

      await loadAttendance();

      return true;
    } catch (_) {
      return false;
    }
  }

  ///=====================================
  /// DELETE
  ///=====================================

  Future<bool> delete(
      String id,
      ) async {
    try {
      await _repository.delete(id);

      await loadAttendance();

      return true;
    } catch (_) {
      return false;
    }
  }
  ///=====================================
  /// GET TODAY ATTENDANCE
  ///=====================================
  Future<AttendanceEntity?> getTodayAttendance(
      String employeeId,
      ) async {
    try {
      return await _repository.getTodayAttendance(
        employeeId,
      );
    } catch (_) {
      return null;
    }
  }

  ///=====================================
  /// CHECK-IN
  ///=====================================

  Future<bool> checkIn({
    required AttendanceEntity attendance,
  }) async {
    try {
      await _repository.insert(attendance);

      await loadAttendance();

      return true;
    } catch (_) {
      return false;
    }
  }

  ///=====================================
  /// CHECK-OUT
  ///=====================================

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
    } catch (_) {
      return false;
    }
  }

  ///=====================================
  /// EMPLOYEE ATTENDANCE
  ///=====================================

  Future<void> employeeAttendance(
      String employeeId,
      ) async {
    try {
      state = const AsyncLoading();

      final attendance =
      await _repository.getEmployeeAttendance(
        employeeId,
      );

      state = AsyncData(attendance);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  ///=====================================
  /// TODAY
  ///=====================================

  Future<void> todayAttendance() async {
    try {
      state = const AsyncLoading();

      final attendance =
      await _repository.todayAttendance();

      state = AsyncData(attendance);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}