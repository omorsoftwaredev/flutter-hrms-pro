import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/supervisor_mobile_attendance_report_repository.dart';
import '../../data/repositories/supervisor_mobile_attendance_report_repository_impl.dart';
import '../../domain/entities/supervisor_mobile_attendance_report_entity.dart';

//=================================================================
// REPOSITORY PROVIDER
//=================================================================

final supervisorMobileAttendanceReportRepositoryProvider =
Provider<SupervisorMobileAttendanceReportRepository>((ref) {
  return SupervisorMobileAttendanceReportRepositoryImpl();
});

//=================================================================
// REPORT PROVIDER
//=================================================================

final supervisorMobileAttendanceReportProvider =
ChangeNotifierProvider<SupervisorMobileAttendanceReportProvider>((ref) {
  final repository = ref.read(
    supervisorMobileAttendanceReportRepositoryProvider,
  );

  return SupervisorMobileAttendanceReportProvider(
    repository: repository,
  );
});

//=================================================================
// SUPERVISOR MOBILE ATTENDANCE REPORT PROVIDER
//=================================================================

class SupervisorMobileAttendanceReportProvider extends ChangeNotifier {
  final SupervisorMobileAttendanceReportRepository _repository;

  SupervisorMobileAttendanceReportProvider({
    required SupervisorMobileAttendanceReportRepository repository,
  }) : _repository = repository;

  //=================================================================
  // STATE
  //=================================================================

  bool _isLoading = false;

  bool _isRefreshing = false;

  String? _error;

  String? _companyId;

  String? _supervisorId;

  String? _departmentId;

  List<SupervisorMobileAttendanceReportEntity> _todayReports = [];

  List<SupervisorMobileAttendanceReportEntity> _reports = [];

  Map<String, dynamic> _summary = {};

  DateTime? _selectedStartDate;

  DateTime? _selectedEndDate;

  //=================================================================
  // GETTERS
  //=================================================================

  bool get isLoading => _isLoading;

  bool get isRefreshing => _isRefreshing;

  bool get isBusy => _isLoading || _isRefreshing;

  String? get error => _error;

  String? get companyId => _companyId;

  String? get supervisorId => _supervisorId;

  String? get departmentId => _departmentId;

  List<SupervisorMobileAttendanceReportEntity> get todayReports =>
      List.unmodifiable(_todayReports);

  List<SupervisorMobileAttendanceReportEntity> get reports =>
      List.unmodifiable(_reports);

  Map<String, dynamic> get summary => Map.unmodifiable(_summary);

  DateTime? get selectedStartDate => _selectedStartDate;

  DateTime? get selectedEndDate => _selectedEndDate;

  bool get hasTodayReports => _todayReports.isNotEmpty;

  bool get hasReports => _reports.isNotEmpty;

  bool get hasSummary => _summary.isNotEmpty;

  //=================================================================
  // TODAY COUNTS
  //=================================================================

  int get todayTotalCount => _todayReports.length;

  int get todayPresentCount =>
      _todayReports.where((report) => report.isPresent).length;

  int get todayAbsentCount =>
      _todayReports.where((report) => report.isAbsent).length;

  int get todayLateCount =>
      _todayReports.where((report) => report.isLate).length;

  int get todayEarlyOutCount =>
      _todayReports.where((report) => report.isEarlyOut).length;

  int get todayHolidayCount =>
      _todayReports.where((report) => report.isHoliday).length;

  int get todayLeaveCount => _todayReports
      .where(
        (report) => report.attendanceStatus.trim().toUpperCase() == 'LEAVE',
  )
      .length;

  //=================================================================
  // REPORT COUNTS
  //=================================================================

  int get totalReportCount => _reports.length;

  int get presentCount => _reports.where((report) => report.isPresent).length;

  int get absentCount => _reports.where((report) => report.isAbsent).length;

  int get lateCount => _reports.where((report) => report.isLate).length;

  int get earlyOutCount => _reports.where((report) => report.isEarlyOut).length;

  int get holidayCount => _reports.where((report) => report.isHoliday).length;

  int get leaveCount => _reports
      .where(
        (report) => report.attendanceStatus.trim().toUpperCase() == 'LEAVE',
  )
      .length;

  //=================================================================
  // WORK INFORMATION
  //=================================================================

  int get totalLateMinutes =>
      _reports.fold(0, (total, report) => total + report.lateMinutes);

  int get totalEarlyLeaveMinutes =>
      _reports.fold(0, (total, report) => total + report.earlyLeaveMinutes);

  int get totalActualWorkMinutes =>
      _reports.fold(0, (total, report) => total + report.actualWorkMinutes);

  int get totalOvertimeMinutes =>
      _reports.fold(0, (total, report) => total + report.overtimeMinutes);

  //=================================================================
  // INITIALIZE
  //=================================================================

  Future<void> initialize({
    required String companyId,
    required String supervisorId,
    String? departmentId,
  }) async {
    final company = companyId.trim();

    final supervisor = supervisorId.trim();

    if (company.isEmpty) {
      _setError('Company ID is required.');
      return;
    }

    if (supervisor.isEmpty) {
      _setError('Supervisor ID is required.');
      return;
    }

    _companyId = company;

    _supervisorId = supervisor;

    _departmentId = _normalizeDepartmentId(departmentId);

    await loadTodayReports();
  }

  //=================================================================
  // SET COMPANY
  //=================================================================

  void setCompanyId(String companyId) {
    final id = companyId.trim();

    if (id.isEmpty) {
      _companyId = null;
    } else {
      _companyId = id;
    }

    notifyListeners();
  }

  //=================================================================
  // SET SUPERVISOR
  //=================================================================

  void setSupervisorId(String? supervisorId) {
    final id = supervisorId!.trim();

    if (id.isEmpty) {
      _supervisorId = null;
    } else {
      _supervisorId = id;
    }

    notifyListeners();
  }

  //=================================================================
  // SET DEPARTMENT
  //=================================================================

  void setDepartmentId(String? departmentId) {
    _departmentId = _normalizeDepartmentId(departmentId);

    notifyListeners();
  }

  //=================================================================
  // LOAD TODAY REPORTS
  //=================================================================

  Future<void> loadTodayReports({
    String? companyId,
    String? supervisorId,
    String? departmentId,
  }) async {
    final company = _resolveCompanyId(companyId);

    if (company == null) {
      _setError('Company ID is required.');
      return;
    }

    final supervisor = _resolveSupervisorId(supervisorId);

    if (supervisor == null) {
      _setError('Supervisor ID is required.');
      return;
    }

    final department = _resolveDepartmentId(departmentId);

    _setLoading(true);

    try {
      _clearError();

      final result = await _repository.getTodayReports(
        companyId: company,
        supervisorId: supervisor,
        departmentId: department,
      );

      _todayReports = result;

      notifyListeners();
    } catch (e) {
      _setError(_cleanError(e));
    } finally {
      _setLoading(false);
    }
  }

  //=================================================================
  // LOAD REPORTS BY DATE
  //=================================================================

  Future<void> loadReportsByDate({
    String? companyId,
    String? supervisorId,
    required DateTime date,
    String? departmentId,
  }) async {
    final company = _resolveCompanyId(companyId);

    if (company == null) {
      _setError('Company ID is required.');
      return;
    }

    final supervisor = _resolveSupervisorId(supervisorId);

    if (supervisor == null) {
      _setError('Supervisor ID is required.');
      return;
    }

    final department = _resolveDepartmentId(departmentId);

    _setLoading(true);

    try {
      _clearError();

      final result = await _repository.getReportsByDate(
        companyId: company,
        supervisorId: supervisor,
        date: date,
        departmentId: department,
      );

      _reports = result;

      _selectedStartDate = DateTime(
        date.year,
        date.month,
        date.day,
      );

      _selectedEndDate = DateTime(
        date.year,
        date.month,
        date.day,
      );

      notifyListeners();
    } catch (e) {
      _setError(_cleanError(e));
    } finally {
      _setLoading(false);
    }
  }

  //=================================================================
  // LOAD REPORTS BY DATE RANGE
  //=================================================================

  Future<void> loadReportsByDateRange({
    String? companyId,
    String? supervisorId,
    required DateTime startDate,
    required DateTime endDate,
    String? departmentId,
  }) async {
    final company = _resolveCompanyId(companyId);

    if (company == null) {
      _setError('Company ID is required.');
      return;
    }

    final supervisor = _resolveSupervisorId(supervisorId);

    if (supervisor == null) {
      _setError('Supervisor ID is required.');
      return;
    }

    if (endDate.isBefore(startDate)) {
      _setError('End date cannot be before start date.');
      return;
    }

    final department = _resolveDepartmentId(departmentId);

    _setLoading(true);

    try {
      _clearError();

      _selectedStartDate = startDate;

      _selectedEndDate = endDate;

      final result = await _repository.getReportsByDateRange(
        companyId: company,
        supervisorId: supervisor,
        startDate: startDate,
        endDate: endDate,
        departmentId: department,
      );

      _reports = result;

      notifyListeners();
    } catch (e) {
      _setError(_cleanError(e));
    } finally {
      _setLoading(false);
    }
  }

  //=================================================================
  // LOAD CURRENT MONTH REPORTS
  //=================================================================

  Future<void> loadCurrentMonthReports({
    String? companyId,
    String? supervisorId,
    String? departmentId,
  }) async {
    final company = _resolveCompanyId(companyId);

    if (company == null) {
      _setError('Company ID is required.');
      return;
    }

    final supervisor = _resolveSupervisorId(supervisorId);

    if (supervisor == null) {
      _setError('Supervisor ID is required.');
      return;
    }

    final department = _resolveDepartmentId(departmentId);

    _setLoading(true);

    try {
      _clearError();

      final now = DateTime.now();

      _selectedStartDate = DateTime(
        now.year,
        now.month,
        1,
      );

      _selectedEndDate = DateTime(
        now.year,
        now.month + 1,
        0,
      );

      final result = await _repository.getCurrentMonthReports(
        companyId: company,
        supervisorId: supervisor,
        departmentId: department,
      );

      _reports = result;

      notifyListeners();
    } catch (e) {
      _setError(_cleanError(e));
    } finally {
      _setLoading(false);
    }
  }

  //=================================================================
  // LOAD SUMMARY
  //=================================================================

  Future<void> loadSummary({
    String? companyId,
    String? supervisorId,
    required DateTime startDate,
    required DateTime endDate,
    String? departmentId,
  }) async {
    final company = _resolveCompanyId(companyId);

    if (company == null) {
      _setError('Company ID is required.');
      return;
    }

    final supervisor = _resolveSupervisorId(supervisorId);

    if (supervisor == null) {
      _setError('Supervisor ID is required.');
      return;
    }

    if (endDate.isBefore(startDate)) {
      _setError('End date cannot be before start date.');
      return;
    }

    final department = _resolveDepartmentId(departmentId);

    _setLoading(true);

    try {
      _clearError();

      _selectedStartDate = startDate;

      _selectedEndDate = endDate;

      final result = await _repository.getReportSummary(
        companyId: company,
        supervisorId: supervisor,
        startDate: startDate,
        endDate: endDate,
        departmentId: department,
      );

      _summary = Map<String, dynamic>.from(result);

      notifyListeners();
    } catch (e) {
      _setError(_cleanError(e));
    } finally {
      _setLoading(false);
    }
  }

  //=================================================================
  // LOAD REPORTS + SUMMARY
  //=================================================================

  Future<void> loadReportsAndSummary({
    String? companyId,
    String? supervisorId,
    required DateTime startDate,
    required DateTime endDate,
    String? departmentId,
  }) async {
    final company = _resolveCompanyId(companyId);

    if (company == null) {
      _setError('Company ID is required.');
      return;
    }

    final supervisor = _resolveSupervisorId(supervisorId);

    if (supervisor == null) {
      _setError('Supervisor ID is required.');
      return;
    }

    if (endDate.isBefore(startDate)) {
      _setError('End date cannot be before start date.');
      return;
    }

    final department = _resolveDepartmentId(departmentId);

    _setLoading(true);

    try {
      _clearError();

      _selectedStartDate = startDate;

      _selectedEndDate = endDate;

      final results = await Future.wait([
        _repository.getReportsByDateRange(
          companyId: company,
          supervisorId: supervisor,
          startDate: startDate,
          endDate: endDate,
          departmentId: department,
        ),
        _repository.getReportSummary(
          companyId: company,
          supervisorId: supervisor,
          startDate: startDate,
          endDate: endDate,
          departmentId: department,
        ),
      ]);

      _reports = results[0]
      as List<SupervisorMobileAttendanceReportEntity>;

      _summary = Map<String, dynamic>.from(
        results[1] as Map<String, dynamic>,
      );

      notifyListeners();
    } catch (e) {
      _setError(_cleanError(e));
    } finally {
      _setLoading(false);
    }
  }

  //=================================================================
  // REFRESH TODAY REPORTS
  //=================================================================

  Future<void> refreshTodayReports({
    String? companyId,
    String? supervisorId,
    String? departmentId,
  }) async {
    final company = _resolveCompanyId(companyId);

    if (company == null) {
      _setError('Company ID is required.');
      return;
    }

    final supervisor = _resolveSupervisorId(supervisorId);

    if (supervisor == null) {
      _setError('Supervisor ID is required.');
      return;
    }

    final department = _resolveDepartmentId(departmentId);

    _setRefreshing(true);

    try {
      _clearError();

      final result = await _repository.refreshTodayReports(
        companyId: company,
        supervisorId: supervisor,
        departmentId: department,
      );

      _todayReports = result;

      notifyListeners();
    } catch (e) {
      _setError(_cleanError(e));
    } finally {
      _setRefreshing(false);
    }
  }

  //=================================================================
  // REFRESH ALL
  //=================================================================

  Future<void> refresh({
    String? companyId,
    String? supervisorId,
    String? departmentId,
  }) async {
    final company = _resolveCompanyId(companyId);

    if (company == null) {
      _setError('Company ID is required.');
      return;
    }

    final supervisor = _resolveSupervisorId(supervisorId);

    if (supervisor == null) {
      _setError('Supervisor ID is required.');
      return;
    }

    final department = _resolveDepartmentId(departmentId);

    _setRefreshing(true);

    try {
      _clearError();

      final today = await _repository.refreshTodayReports(
        companyId: company,
        supervisorId: supervisor,
        departmentId: department,
      );

      _todayReports = today;

      if (_selectedStartDate != null &&
          _selectedEndDate != null) {
        final results = await Future.wait([
          _repository.getReportsByDateRange(
            companyId: company,
            supervisorId: supervisor,
            startDate: _selectedStartDate!,
            endDate: _selectedEndDate!,
            departmentId: department,
          ),
          _repository.getReportSummary(
            companyId: company,
            supervisorId: supervisor,
            startDate: _selectedStartDate!,
            endDate: _selectedEndDate!,
            departmentId: department,
          ),
        ]);

        _reports = results[0]
        as List<SupervisorMobileAttendanceReportEntity>;

        _summary = Map<String, dynamic>.from(
          results[1] as Map<String, dynamic>,
        );
      }

      notifyListeners();
    } catch (e) {
      _setError(_cleanError(e));
    } finally {
      _setRefreshing(false);
    }
  }

  //=================================================================
  // CLEAR TODAY REPORTS
  //=================================================================

  void clearTodayReports() {
    _todayReports = [];

    notifyListeners();
  }

  //=================================================================
  // CLEAR REPORTS
  //=================================================================

  void clearReports() {
    _reports = [];

    _summary = {};

    _selectedStartDate = null;

    _selectedEndDate = null;

    notifyListeners();
  }

  //=================================================================
  // CLEAR SUMMARY
  //=================================================================

  void clearSummary() {
    _summary = {};

    notifyListeners();
  }

  //=================================================================
  // CLEAR ERROR
  //=================================================================

  void clearError() {
    if (_error == null) {
      return;
    }

    _error = null;

    notifyListeners();
  }

  //=================================================================
  // RESET
  //=================================================================

  void reset() {
    _isLoading = false;

    _isRefreshing = false;

    _error = null;

    _companyId = null;

    _supervisorId = null;

    _departmentId = null;

    _todayReports = [];

    _reports = [];

    _summary = {};

    _selectedStartDate = null;

    _selectedEndDate = null;

    notifyListeners();
  }

  //=================================================================
  // PRIVATE COMPANY ID
  //=================================================================

  String? _resolveCompanyId(String? companyId) {
    final supplied = companyId?.trim();

    if (supplied != null && supplied.isNotEmpty) {
      _companyId = supplied;

      return supplied;
    }

    final current = _companyId?.trim();

    if (current == null || current.isEmpty) {
      return null;
    }

    return current;
  }

  //=================================================================
  // PRIVATE SUPERVISOR ID
  //=================================================================

  String? _resolveSupervisorId(String? supervisorId) {
    final supplied = supervisorId?.trim();

    if (supplied != null && supplied.isNotEmpty) {
      _supervisorId = supplied;

      return supplied;
    }

    final current = _supervisorId?.trim();

    if (current == null || current.isEmpty) {
      return null;
    }

    return current;
  }

  //=================================================================
  // PRIVATE DEPARTMENT ID
  //=================================================================

  String? _resolveDepartmentId(String? departmentId) {
    if (departmentId != null) {
      _departmentId = _normalizeDepartmentId(departmentId);
    }

    return _departmentId;
  }

  //=================================================================
  // NORMALIZE DEPARTMENT ID
  //=================================================================

  String? _normalizeDepartmentId(String? departmentId) {
    final value = departmentId?.trim();

    if (value == null || value.isEmpty) {
      return null;
    }

    return value;
  }

  //=================================================================
  // PRIVATE LOADING
  //=================================================================

  void _setLoading(bool value) {
    _isLoading = value;

    notifyListeners();
  }

  //=================================================================
  // PRIVATE REFRESHING
  //=================================================================

  void _setRefreshing(bool value) {
    _isRefreshing = value;

    notifyListeners();
  }

  //=================================================================
  // PRIVATE ERROR
  //=================================================================

  void _setError(String message) {
    _error = message;

    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  //=================================================================
  // ERROR CLEANER
  //=================================================================

  String _cleanError(Object error) {
    final message = error.toString().trim();

    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }

    if (message.isEmpty) {
      return 'Something went wrong.';
    }

    return message;
  }
}