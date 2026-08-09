/// ===============================================================
/// Flutter HRMS Pro
/// Delete Supervisor Use Case
///
/// Version : 3.0.0
/// ===============================================================

import '../repositories/supervisor_repository.dart';

/// ===============================================================
/// DELETE SUPERVISOR USE CASE
/// ===============================================================
///
/// Flow:
///
/// UI
///  ↓
/// SupervisorNotifier
///  ↓
/// DeleteSupervisor
///  ↓
/// SupervisorRepository
///  ↓
/// SupervisorRepositoryImpl
///  ↓
/// SupervisorRemoteDataSource
///  ↓
/// Supabase
///
/// ===============================================================

class DeleteSupervisor {
  // =============================================================
  // REPOSITORY
  // =============================================================

  final SupervisorRepository repository;

  // =============================================================
  // CONSTRUCTOR
  // =============================================================

  const DeleteSupervisor(
      this.repository,
      );

  // =============================================================
  // CALL
  // =============================================================

  Future<void> call(
      String supervisorId,
      ) {
    return repository.deleteSupervisor(
      supervisorId,
    );
  }
}