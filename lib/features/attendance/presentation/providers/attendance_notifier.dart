import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../../data/models/attendance_model.dart';
import '../../data/repositories/attendance_repository.dart';
import '../../domain/entities/attendance_entity.dart';

class AttendanceNotifier
    extends StateNotifier<List<AttendanceEntity>> {

  final Ref ref;
  final AttendanceRepository repository;

  AttendanceNotifier(
      this.ref,
      this.repository,
      ) : super([]);

  // ==============================================================
  // CURRENT USER
  // ==============================================================

  /// Current logged-in user's company ID.
  ///
  /// Company ID current user থেকেই নেওয়া হবে।
  /// UI থেকে আলাদা করে company ID পাঠানোর প্রয়োজন নেই।
  String? get currentCompanyId {
    final user = ref.read(currentUserProvider);

    final companyId =
    user?.companyId?.toString().trim();

    if (companyId == null || companyId.isEmpty) {
      return null;
    }

    return companyId;
  }

  // ==============================================================
  // LOAD ATTENDANCE
  // ==============================================================

  Future<void> loadAttendance() async {
    final companyId = currentCompanyId;

    if (companyId == null) {
      state = [];
      return;
    }

    final attendance =
    await repository.byCompany(companyId);

    state = attendance;
  }

  // ==============================================================
  // REFRESH
  // ==============================================================

  Future<void> refresh() async {
    await loadAttendance();
  }

  // ==============================================================
// ADD ATTENDANCE
// ==============================================================

  Future<void> addAttendance(
      AttendanceEntity entity,
      ) async {
    final model = AttendanceModel.fromEntity(entity);

    await repository.insert(model);

    await loadAttendance();
  }

  // ==============================================================
  // UPDATE ATTENDANCE
  // ==============================================================

  Future<void> updateAttendance(
      AttendanceEntity entity,
      ) async {
    await repository.update(entity);

    await loadAttendance();
  }

  // ==============================================================
  // DELETE ATTENDANCE
  // ==============================================================

  Future<void> deleteAttendance(
      String id,
      ) async {
    final attendanceId = id.trim();

    if (attendanceId.isEmpty) {
      return;
    }

    await repository.delete(attendanceId);

    state = state
        .where(
          (item) => item.id != attendanceId,
    )
        .toList();
  }

  // ==============================================================
  // SEARCH
  // ==============================================================

  Future<void> searchAttendance(
      String keyword,
      ) async {
    final companyId = currentCompanyId;

    if (companyId == null) {
      state = [];
      return;
    }

    final text = keyword.trim();

    if (text.isEmpty) {
      await loadAttendance();
      return;
    }

    final results =
    await repository.search(text);

    // ------------------------------------------------------------
    // IMPORTANT
    // Search result-ও current company-এর মধ্যেই রাখতে হবে।
    // ------------------------------------------------------------

    state = results
        .where(
          (item) => item.companyId == companyId,
    )
        .toList();
  }

  // ==============================================================
  // FILTER BY STATUS
  // ==============================================================

  Future<void> filterAttendance(
      String status,
      ) async {
    final companyId = currentCompanyId;

    if (companyId == null) {
      state = [];
      return;
    }

    final text = status.trim();

    if (text.isEmpty) {
      await loadAttendance();
      return;
    }

    final results =
    await repository.byStatus(text);

    // ------------------------------------------------------------
    // Current company only
    // ------------------------------------------------------------

    state = results
        .where(
          (item) => item.companyId == companyId,
    )
        .toList();
  }

  // ==============================================================
  // GET BY ID
  // ==============================================================

  AttendanceEntity? getAttendanceById(
      String id,
      ) {
    final attendanceId = id.trim();

    if (attendanceId.isEmpty) {
      return null;
    }

    for (final attendance in state) {
      if (attendance.id == attendanceId) {
        return attendance;
      }
    }

    return null;
  }

  // ==============================================================
  // CLEAR
  // ==============================================================

  void clear() {
    state = [];
  }
}