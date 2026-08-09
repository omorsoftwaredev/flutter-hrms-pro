/// ===============================================================
/// Flutter HRMS Pro
/// Get Employees Use Case
///
/// Version : 3.0.0
/// ===============================================================

import '../entities/employee.dart';
import '../repositories/supervisor_repository.dart';

/// ===============================================================
/// GET EMPLOYEES USE CASE
/// ===============================================================
///
/// Company + Department select করার পরে
/// ওই department-এর active employees load করবে.
///
/// Flow:
///
/// Company
///    ↓
/// companyId
///    ↓
/// Department
///    ↓
/// departmentId
///    ↓
/// GetEmployees
///    ↓
/// SupervisorRepository
///    ↓
/// SupervisorRepositoryImpl
///    ↓
/// SupervisorRemoteDataSource
///    ↓
/// Supabase
///
/// ===============================================================

class GetEmployees {
  final SupervisorRepository repository;

  const GetEmployees(
      this.repository,
      );

  Future<List<Employee>> call({
    required String companyId,
    required String departmentId,
  }) {
    return repository.getEmployees(
      companyId: companyId,
      departmentId: departmentId,
    );
  }
}