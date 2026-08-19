import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/i_attendance_repository.dart';
import '../datasource/attendance_remote_datasource.dart';
import '../models/attendance_model.dart';

/// ===============================================================
/// Flutter HRMS Pro
/// Attendance Repository Implementation
///
/// Responsibilities:
/// - Domain ↔ Data layer bridge
/// - Attendance CRUD
/// - Search
/// - Employee attendance
/// - Department attendance
/// - Status attendance
/// - Date attendance
/// - Date range attendance
///
/// IMPORTANT:
/// - Database/Supabase logic stays inside RemoteDataSource.
/// - Entity/Model conversion stays here.
/// - Supervisor-specific methods can be exposed separately
///   through IAttendanceRepository when required.
/// ===============================================================

class AttendanceRepositoryImpl implements IAttendanceRepository {
  // =============================================================
  // DATASOURCE
  // =============================================================

  final AttendanceRemoteDataSource remote;

  // =============================================================
  // CONSTRUCTOR
  // =============================================================

  const AttendanceRepositoryImpl(this.remote);

  // =============================================================
  // GET ALL
  // =============================================================

  @override
  Future<List<AttendanceEntity>> getAll() async {
    return await remote.getAll();
  }

  // =============================================================
  // GET BY ID
  // =============================================================

  @override
  Future<AttendanceEntity?> getById(String id) async {
    return await remote.getById(id);
  }

  // =============================================================
  // INSERT
  // =============================================================

  @override
  Future<void> insert(AttendanceEntity attendance) async {
    final model = AttendanceModel.fromEntity(attendance);

    await remote.insert(model);
  }

  // =============================================================
  // UPDATE
  // =============================================================

  @override
  Future<void> update(AttendanceEntity attendance) async {
    final model = AttendanceModel.fromEntity(attendance);

    await remote.update(model);
  }

  // =============================================================
  // DELETE
  // =============================================================

  @override
  Future<void> delete(String id) async {
    await remote.delete(id);
  }

  // =============================================================
  // SEARCH
  // =============================================================

  @override
  Future<List<AttendanceEntity>> search(String keyword) async {
    return await remote.search(keyword);
  }

  // =============================================================
  // BY EMPLOYEE
  // =============================================================

  @override
  Future<List<AttendanceEntity>> byEmployee(String employeeId) async {
    return await remote.byEmployee(employeeId);
  }

  // =============================================================
  // BY DEPARTMENT
  // =============================================================

  @override
  Future<List<AttendanceEntity>> byDepartment(String departmentId) async {
    return await remote.byDepartment(departmentId);
  }

  // =============================================================
  // BY STATUS
  // =============================================================

  @override
  Future<List<AttendanceEntity>> byStatus(String status) async {
    return await remote.byStatus(status);
  }

  // =============================================================
  // BY DATE
  // =============================================================

  @override
  Future<List<AttendanceEntity>> byDate(DateTime date) async {
    return await remote.byDate(date);
  }

  // =============================================================
  // BY DATE RANGE
  // =============================================================

  @override
  Future<List<AttendanceEntity>> byDateRange({
    required DateTime from,
    required DateTime to,
  }) async {
    return await remote.byDateRange(from: from, to: to);
  }
}
