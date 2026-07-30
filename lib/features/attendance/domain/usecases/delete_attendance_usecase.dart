import '../repositories/i_attendance_repository.dart';

class DeleteAttendanceUseCase {
  final IAttendanceRepository repository;

  DeleteAttendanceUseCase(this.repository);

  Future<void> call(
      String id,
      ) {
    return repository.delete(id);
  }
}