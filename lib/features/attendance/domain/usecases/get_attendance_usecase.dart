import '../entities/attendance_entity.dart';
import '../repositories/i_attendance_repository.dart';

class GetAttendanceUseCase {
  final IAttendanceRepository repository;

  GetAttendanceUseCase(this.repository);

  Future<List<AttendanceEntity>> call() {
    return repository.getAll();
  }

  Future<AttendanceEntity?> byId(
      String id,
      ) {
    return repository.getById(id);
  }

  Future<List<AttendanceEntity>> byCompany(
      String companyId,
      ) {
    return repository.byCompany(companyId);
  }

  Future<List<AttendanceEntity>> byDepartment(
      String departmentId,
      ) {
    return repository.byDepartment(departmentId);
  }

  Future<List<AttendanceEntity>> byEmployee(
      String employeeId,
      ) {
    return repository.byEmployee(employeeId);
  }

  Future<List<AttendanceEntity>> byStatus(
      String status,
      ) {
    return repository.byStatus(status);
  }

  Future<List<AttendanceEntity>> byDate(
      DateTime date,
      ) {
    return repository.byDate(date);
  }

  Future<List<AttendanceEntity>> byDateRange({
    required DateTime from,
    required DateTime to,
  }) {
    return repository.byDateRange(
      from: from,
      to: to,
    );
  }
}