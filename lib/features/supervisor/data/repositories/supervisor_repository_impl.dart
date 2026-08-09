/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Repository Implementation
///
/// Version : 5.0.0
/// ===============================================================

import '../../domain/entities/department.dart';
import '../../domain/entities/employee.dart';
import '../../domain/entities/supervisor.dart';
import '../../domain/repositories/supervisor_repository.dart';
import '../datasource/supervisor_remote_datasource.dart';
import '../models/supervisor_model.dart';

class SupervisorRepositoryImpl
    implements SupervisorRepository {
  // =============================================================
  // DATASOURCE
  // =============================================================

  final SupervisorRemoteDataSource remoteDataSource;

  // =============================================================
  // CONSTRUCTOR
  // =============================================================

  const SupervisorRepositoryImpl(
      this.remoteDataSource,
      );

  // =============================================================
  // COMPANIES
  // =============================================================

  @override
  Future<List<Map<String, dynamic>>> getCompanies() async {
    return await remoteDataSource.getCompanies();
  }

  // =============================================================
  // GET SUPERVISORS
  // =============================================================

  @override
  Future<List<Supervisor>> getSupervisors(
      String companyId,
      ) async {
    final data =
    await remoteDataSource.getSupervisors(
      companyId,
    );

    return data
        .map(
          (item) => SupervisorModel.fromMap(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  // =============================================================
  // GET SUPERVISOR BY ID
  // =============================================================

  @override
  Future<Supervisor> getSupervisorById(
      String supervisorId,
      ) async {
    final data =
    await remoteDataSource.getSupervisorById(
      supervisorId,
    );

    return SupervisorModel.fromMap(
      Map<String, dynamic>.from(data),
    );
  }

  // =============================================================
  // CREATE SUPERVISOR
  // =============================================================

  // =============================================================
// CREATE SUPERVISOR
// =============================================================

  @override
  Future<Supervisor> createSupervisor({
    required String companyId,
    required String departmentId,
    required String employeeId,
    bool isActive = true,
  }) async {
    final data = await remoteDataSource.createSupervisor(
      companyId: companyId,
      departmentId: departmentId,
      employeeId: employeeId,
    );

    return SupervisorModel.fromMap(
      Map<String, dynamic>.from(data),
    );
  }

  // =============================================================
  // UPDATE SUPERVISOR
  // =============================================================

  @override
  Future<Supervisor> updateSupervisor({
    required String supervisorId,
    required String companyId,
    required String departmentId,
    required String employeeId,
    required bool isActive,
  }) async {
    final data =
    await remoteDataSource.updateSupervisor(
      supervisorId: supervisorId,
      companyId: companyId,
      departmentId: departmentId,
      employeeId: employeeId,
      isActive: isActive,
    );

    return SupervisorModel.fromMap(
      Map<String, dynamic>.from(data),
    );
  }

  // =============================================================
  // DELETE SUPERVISOR
  // =============================================================

  @override
  Future<void> deleteSupervisor(
      String supervisorId,
      ) async {
    await remoteDataSource.deleteSupervisor(
      supervisorId,
    );
  }

  // =============================================================
  // DEPARTMENTS
  // =============================================================

  @override
  Future<List<Department>> getDepartments(
      String companyId,
      ) async {
    final data =
    await remoteDataSource.getDepartments(
      companyId,
    );

    return data
        .map(
          (item) => Department.fromMap(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  // =============================================================
  // EMPLOYEES
  // =============================================================

  @override
  Future<List<Employee>> getEmployees({
    required String companyId,
    required String departmentId,
  }) async {
    final data =
    await remoteDataSource.getEmployees(
      companyId: companyId,
      departmentId: departmentId,
    );

    return data
        .map(
          (item) => Employee.fromMap(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }
}