/// ===============================================================
/// Flutter HRMS Pro
/// Get Departments Use Case
///
/// Version : 3.0.0
/// ===============================================================

import '../entities/department.dart';
import '../repositories/supervisor_repository.dart';

/// ===============================================================
/// GET DEPARTMENTS USE CASE
/// ===============================================================
///
/// Company select করার পরে এই use case call হবে।
///
/// Flow:
///
/// Company Dropdown
///      ↓
/// companyId
///      ↓
/// GetDepartments
///      ↓
/// SupervisorRepository
///      ↓
/// SupervisorRepositoryImpl
///      ↓
/// SupervisorRemoteDataSource
///      ↓
/// Supabase
///
/// ===============================================================

class GetDepartments {
  final SupervisorRepository repository;

  const GetDepartments(
      this.repository,
      );

  Future<List<Department>> call(
      String companyId,
      ) {
    return repository.getDepartments(
      companyId,
    );
  }
}