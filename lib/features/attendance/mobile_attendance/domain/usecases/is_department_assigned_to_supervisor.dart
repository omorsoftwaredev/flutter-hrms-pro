import '../../../mobile_attendance/data/repositories/supervisor_department_repository.dart';

class IsDepartmentAssignedToSupervisor {
  final SupervisorDepartmentRepository repository;

  const IsDepartmentAssignedToSupervisor({
    required this.repository,
  });

  Future<bool> call({
    required String supervisorId,
    required String departmentId,
    required String companyId,
  }) {
    return repository.isDepartmentAssignedToSupervisor(
      supervisorId: supervisorId,
      departmentId: departmentId,
      companyId: companyId,
    );
  }
}