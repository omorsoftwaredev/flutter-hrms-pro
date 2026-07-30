import '../entities/attendance_entity.dart';
import '../repositories/i_attendance_repository.dart';

class AddAttendanceUseCase {
  final IAttendanceRepository repository;

  AddAttendanceUseCase(this.repository);

  Future<void> call(
      AttendanceEntity attendance,
      ) {
    return repository.insert(attendance);
  }
}