import '../entities/attendance_entity.dart';
import '../repositories/i_attendance_repository.dart';

class SearchAttendanceUseCase {
  final IAttendanceRepository repository;

  SearchAttendanceUseCase(this.repository);

  Future<List<AttendanceEntity>> call(
      String keyword,
      ) {
    return repository.search(keyword);
  }
}