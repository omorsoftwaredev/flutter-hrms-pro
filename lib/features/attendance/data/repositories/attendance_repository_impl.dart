import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/i_attendance_repository.dart';
import '../datasource/attendance_remote_datasource.dart';
import '../models/attendance_model.dart';

class AttendanceRepositoryImpl
    implements IAttendanceRepository {
  final AttendanceRemoteDataSource remote;

  AttendanceRepositoryImpl(this.remote);

  @override
  Future<List<AttendanceEntity>> getAll() async {
    return await remote.getAll();
  }

  @override
  Future<AttendanceEntity?> getById(
      String id,
      ) async {
    return await remote.getById(id);
  }

  @override
  Future<void> insert(
      AttendanceEntity attendance,
      ) async {
    await remote.insert(
      AttendanceModel.fromEntity(attendance),
    );
  }

  @override
  Future<void> update(
      AttendanceEntity attendance,
      ) async {
    await remote.update(
      AttendanceModel.fromEntity(attendance),
    );
  }

  @override
  Future<void> delete(
      String id,
      ) async {
    await remote.delete(id);
  }

  @override
  Future<List<AttendanceEntity>> search(
      String keyword,
      ) async {
    return await remote.search(keyword);
  }

  @override
  Future<List<AttendanceEntity>> byEmployee(
      String employeeId,
      ) async {
    return await remote.byEmployee(employeeId);
  }

  @override
  Future<List<AttendanceEntity>> byCompany(
      String companyId,
      ) async {
    return await remote.byCompany(companyId);
  }

  @override
  Future<List<AttendanceEntity>> byDepartment(
      String departmentId,
      ) async {
    return await remote.byDepartment(departmentId);
  }

  @override
  Future<List<AttendanceEntity>> byStatus(
      String status,
      ) async {
    return await remote.byStatus(status);
  }

  @override
  Future<List<AttendanceEntity>> byDate(
      DateTime date,
      ) async {
    return await remote.byDate(date);
  }

  @override
  Future<List<AttendanceEntity>> byDateRange({
    required DateTime from,
    required DateTime to,
  }) async {
    return await remote.byDateRange(
      from: from,
      to: to,
    );
  }
}