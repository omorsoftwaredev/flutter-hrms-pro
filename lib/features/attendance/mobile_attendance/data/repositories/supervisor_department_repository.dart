import '../../domain/entities/supervisor_department_entity.dart';

abstract class SupervisorDepartmentRepository {
  //=================================================================
  // GET SUPERVISOR DEPARTMENTS
  //=================================================================

  Future<List<SupervisorDepartmentEntity>> getSupervisorDepartments({
    required String supervisorId,
    required String companyId,
  });

  //=================================================================
  // GET SINGLE SUPERVISOR DEPARTMENT
  //=================================================================

  Future<SupervisorDepartmentEntity?> getSupervisorDepartment({
    required String supervisorDepartmentId,
  });

  //=================================================================
  // CHECK DEPARTMENT ASSIGNMENT
  //=================================================================

  Future<bool> isDepartmentAssignedToSupervisor({
    required String supervisorId,
    required String departmentId,
    required String companyId,
  });
}