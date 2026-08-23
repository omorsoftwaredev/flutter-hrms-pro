import '../../../mobile_attendance/domain/entities/supervisor_department_entity.dart';
import '../../../mobile_attendance/data/repositories/supervisor_department_repository.dart';

class GetSupervisorDepartment {
  final SupervisorDepartmentRepository repository;

  const GetSupervisorDepartment({
    required this.repository,
  });

  Future<SupervisorDepartmentEntity?> call({
    required String supervisorDepartmentId,
  }) {
    return repository.getSupervisorDepartment(
      supervisorDepartmentId: supervisorDepartmentId,
    );
  }
}