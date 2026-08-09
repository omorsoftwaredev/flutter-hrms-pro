/// ===============================================================
/// Flutter HRMS Pro
/// Get Supervisor By ID Use Case
///
/// Version : 3.0.0
/// ===============================================================

import '../entities/supervisor.dart';
import '../repositories/supervisor_repository.dart';

class GetSupervisorById {
  final SupervisorRepository repository;

  const GetSupervisorById(
      this.repository,
      );

  Future<Supervisor> call(
      String supervisorId,
      ) {
    return repository.getSupervisorById(
      supervisorId,
    );
  }
}