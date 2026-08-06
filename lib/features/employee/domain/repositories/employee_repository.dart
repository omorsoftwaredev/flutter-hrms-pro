import '../entities/employee_entity.dart';

abstract class EmployeeRepository {
  Future<List<EmployeeEntity>> getEmployees();

  Future<EmployeeEntity> getEmployeeById(
      String id,
      );

  Future<void> createEmployee(
      EmployeeEntity employee,
      );

  Future<void> updateEmployee(
      EmployeeEntity employee,
      );

  Future<void> deleteEmployee(
      String id,
      );
}