import '../entities/attendance_entity.dart';

abstract class IAttendanceRepository {
  /// Get All
  Future<List<AttendanceEntity>> getAll();

  /// Get By Id
  Future<AttendanceEntity?> getById(String id);

  /// Insert
  Future<void> insert(
      AttendanceEntity attendance,
      );

  /// Update
  Future<void> update(
      AttendanceEntity attendance,
      );

  /// Delete
  Future<void> delete(String id);

  /// Search
  Future<List<AttendanceEntity>> search(
      String keyword,
      );

  /// Employee Wise
  Future<List<AttendanceEntity>> byEmployee(
      String employeeId,
      );

  /// Company Wise
  Future<List<AttendanceEntity>> byCompany(
      String companyId,
      );

  /// Department Wise
  Future<List<AttendanceEntity>> byDepartment(
      String departmentId,
      );

  /// Status Wise
  Future<List<AttendanceEntity>> byStatus(
      String status,
      );

  /// Single Date
  Future<List<AttendanceEntity>> byDate(
      DateTime date,
      );

  /// Date Range
  Future<List<AttendanceEntity>> byDateRange({
    required DateTime from,
    required DateTime to,
  });
}