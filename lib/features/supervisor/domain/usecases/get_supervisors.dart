/// ===============================================================
/// Flutter HRMS Pro
/// Get Supervisors Use Case
///
/// Version : 2.0.0
/// ===============================================================

import '../entities/supervisor.dart';
import '../repositories/supervisor_repository.dart';

class GetSupervisors {
  final SupervisorRepository repository;

  const GetSupervisors(this.repository);

  Future<List<Supervisor>> call(
      String companyId,
      ) {
    return repository.getSupervisors(
      companyId,
    );
  }
}