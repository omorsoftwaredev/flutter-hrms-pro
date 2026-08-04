import '../entities/department_entity.dart';

abstract class DepartmentRepository {
  Future<List<DepartmentEntity>> getDepartments();

  Future<DepartmentEntity> getDepartmentById(String id);

  Future<void> createDepartment(
      DepartmentEntity department,
      );

  Future<void> updateDepartment(
      DepartmentEntity department,
      );

  Future<void> deleteDepartment(
      String id,
      );

  Future<void> updateDepartmentStatus({
    required String id,
    required bool isActive,
  });
}