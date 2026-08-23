import '../../../mobile_attendance/domain/entities/supervisor_department_entity.dart';
import '../../../mobile_attendance/data/repositories/supervisor_department_repository.dart';

class GetSupervisorDepartments {
  final SupervisorDepartmentRepository repository;

  const GetSupervisorDepartments({
    required this.repository,
  });

  Future<List<SupervisorDepartmentEntity>> call({
    required String supervisorId,
    required String companyId,
  }) {
    return repository.getSupervisorDepartments(
      supervisorId: supervisorId,
      companyId: companyId,
    );
  }
}