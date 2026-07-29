import '../entities/employee_entity.dart';

abstract class EmployeeRepository {
  /// Get All Employees
  Future<List<EmployeeEntity>> getEmployees();

  /// Get Employee By Id
  Future<EmployeeEntity> getEmployeeById(
      String id,
      );

  /// Create Employee
  Future<void> createEmployee(
      EmployeeEntity employee,
      );

  /// Update Employee
  Future<void> updateEmployee(
      EmployeeEntity employee,
      );

  /// Delete Employee
  Future<void> deleteEmployee(
      String id,
      );
}