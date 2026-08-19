import '../entities/attendance_report_entity.dart';
import '../../data/repositories/attendance_repository.dart';

class GetEmployeeAttendanceReport {
  final AttendanceRepository repository;

  const GetEmployeeAttendanceReport({
    required this.repository,
  });

  Future<List<AttendanceReportEntity>> call({
    required String employeeId,
    required DateTime from,
    required DateTime to,
  }) async {
    return repository.getEmployeeAttendanceReport(
      employeeId: employeeId,
      from: from,
      to: to,
    );
  }
}