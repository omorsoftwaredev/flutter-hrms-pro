import '../entities/company_supervisor_mobile_attendance_report_entity.dart';
import '../../data/repositories/company_supervisor_mobile_attendance_report_repository.dart';

///=================================================================
/// GET COMPANY SUPERVISOR MOBILE ATTENDANCE REPORTS
///=================================================================
///
/// UseCase for loading company-scoped + supervisor-scoped
/// mobile attendance reports.
///
/// Scope:
/// - Company
/// - Supervisor
/// - Optional Department
/// - Date Range
///
/// IMPORTANT:
/// Repository requires BOTH:
/// - companyId
/// - supervisorId
///
///=================================================================

class GetCompanySupervisorMobileAttendanceReports {
  //=================================================================
  // REPOSITORY
  //=================================================================

  final CompanySupervisorMobileAttendanceReportRepository _repository;

  //=================================================================
  // CONSTRUCTOR
  //=================================================================

  const GetCompanySupervisorMobileAttendanceReports({
    required CompanySupervisorMobileAttendanceReportRepository repository,
  }) : _repository = repository;

  //=================================================================
  // CALL
  //=================================================================

  Future<List<CompanySupervisorMobileAttendanceReportEntity>> call({
    required String companyId,
    required String supervisorId,
    required DateTime startDate,
    required DateTime endDate,
    String? departmentId,
  }) async {
    //===============================================================
    // VALIDATE COMPANY ID
    //===============================================================

    final normalizedCompanyId = companyId.trim();

    if (normalizedCompanyId.isEmpty) {
      throw ArgumentError(
        'Company ID is required.',
      );
    }

    //===============================================================
    // VALIDATE SUPERVISOR ID
    //===============================================================

    final normalizedSupervisorId = supervisorId.trim();

    if (normalizedSupervisorId.isEmpty) {
      throw ArgumentError(
        'Supervisor ID is required.',
      );
    }

    //===============================================================
    // VALIDATE DATE RANGE
    //===============================================================

    if (endDate.isBefore(startDate)) {
      throw ArgumentError(
        'End date cannot be before start date.',
      );
    }

    //===============================================================
    // NORMALIZE DEPARTMENT ID
    //===============================================================

    final normalizedDepartmentId =
    departmentId?.trim().isEmpty == true
        ? null
        : departmentId?.trim();

    //===============================================================
    // REPOSITORY CALL
    //===============================================================

    return _repository.getReportsByDateRange(
      companyId: normalizedCompanyId,
      supervisorId: normalizedSupervisorId,
      startDate: startDate,
      endDate: endDate,
      departmentId: normalizedDepartmentId,
    );
  }
}