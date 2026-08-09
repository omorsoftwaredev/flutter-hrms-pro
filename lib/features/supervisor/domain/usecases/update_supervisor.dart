/// ===============================================================
/// Flutter HRMS Pro
/// Update Supervisor Use Case
///
/// Version : 2.0.0
/// ===============================================================

import '../entities/supervisor.dart';
import '../repositories/supervisor_repository.dart';

class UpdateSupervisor {
  final SupervisorRepository repository;

  const UpdateSupervisor(this.repository);

  Future<Supervisor> call({
    required String supervisorId,
    required String companyId,
    required String departmentId,
    required String employeeId,
    required bool isActive,
  }) {
    return repository.updateSupervisor(
      supervisorId: supervisorId,
      companyId: companyId,
      departmentId: departmentId,
      employeeId: employeeId,
      isActive: isActive,
    );
  }
}