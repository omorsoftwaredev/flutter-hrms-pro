// ===============================================================
// Flutter HRMS Pro
// Create Supervisor Use Case
//
// Version : 3.0.0
// ===============================================================

import '../entities/supervisor.dart';
import '../repositories/supervisor_repository.dart';

/// ===============================================================
/// CREATE SUPERVISOR USE CASE
/// ===============================================================
///
/// Flow:
///
/// UI
///  ↓
/// SupervisorNotifier
///  ↓
/// CreateSupervisor
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

class CreateSupervisor {
  // =============================================================
  // REPOSITORY
  // =============================================================

  final SupervisorRepository repository;

  // =============================================================
  // CONSTRUCTOR
  // =============================================================

  const CreateSupervisor(
      this.repository,
      );

  // =============================================================
  // CALL
  // =============================================================

  Future<Supervisor> call({
    required String companyId,
    required String departmentId,
    required String employeeId,
    bool isActive = true,
  }) {
    return repository.createSupervisor(
      companyId: companyId,
      departmentId: departmentId,
      employeeId: employeeId,
      isActive: isActive,
    );
  }
}