import '../entities/employee_entity.dart';

abstract class EmployeeRepository {
  // =============================================================
  // GET ALL EMPLOYEES
  // =============================================================

  Future<List<EmployeeEntity>> getEmployees();

  // =============================================================
  // GET EMPLOYEE BY ID
  // =============================================================

  Future<EmployeeEntity> getEmployeeById(
      String id,
      );

  // =============================================================
  // CREATE EMPLOYEE
  // =============================================================

  Future<void> createEmployee(
      EmployeeEntity employee,
      );

  // =============================================================
  // UPDATE EMPLOYEE
  // =============================================================

  Future<void> updateEmployee(
      EmployeeEntity employee,
      );

  // =============================================================
  // UPDATE EMPLOYEE STATUS
  // =============================================================

  Future<void> updateEmployeeStatus({
    required String id,
    required bool isActive,
  });

  // =============================================================
  // DELETE EMPLOYEE
  // =============================================================

  Future<void> deleteEmployee(
      String id,
      );
}