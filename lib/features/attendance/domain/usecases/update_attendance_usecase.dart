import '../entities/attendance_entity.dart';
import '../repositories/i_attendance_repository.dart';

class UpdateAttendanceUseCase {
  final IAttendanceRepository repository;

  UpdateAttendanceUseCase(this.repository);

  Future<void> call(
      AttendanceEntity attendance,
      ) {
    return repository.update(attendance);
  }
}