/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Repository
///
/// Version : 5.0.0
/// ===============================================================

import '../entities/department.dart';
import '../entities/employee.dart';
import '../entities/supervisor.dart';

abstract class SupervisorRepository {

  // =============================================================
  // SUPERVISOR CRUD
  // =============================================================

  Future<List<Supervisor>> getSupervisors(
      String companyId,
      );

  Future<Supervisor> getSupervisorById(
      String supervisorId,
      );

  Future<Supervisor> createSupervisor({
    required String companyId,
    required String departmentId,
    required String employeeId,
    bool isActive,
  });

  Future<Supervisor> updateSupervisor({
    required String supervisorId,
    required String companyId,
    required String departmentId,
    required String employeeId,
    required bool isActive,
  });

  Future<void> deleteSupervisor(
      String supervisorId,
      );

  // =============================================================
  // DEPARTMENTS
  // =============================================================

  Future<List<Department>> getDepartments(
      String companyId,
      );

  // =============================================================
  // EMPLOYEES
  // =============================================================

  Future<List<Employee>> getEmployees({
    required String companyId,
    required String departmentId,
  });
}