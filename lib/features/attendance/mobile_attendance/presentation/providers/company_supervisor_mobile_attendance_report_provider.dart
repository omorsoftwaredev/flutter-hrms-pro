// ============================================================================
// Flutter HRMS Pro
// Company Supervisor Mobile Attendance Report Provider
//
// Purpose:
// - Manage company supervisor attendance report state
// - Manage selected company
// - Manage selected supervisor
// - Manage selected department
// - Load today's attendance report
// - Load datewise attendance report
// - Load date-range attendance report
// - Load current-month attendance report
// - Load attendance summary
// - Load reports + summary
// - Refresh attendance data
// - Provide attendance counters for UI
// - Provide detailed debug logging
//
// Architecture:
// - Riverpod
// - ChangeNotifier
// - Repository Pattern
// - Clean Architecture
// - Material 3 compatible
//
// Version : 2.0.0
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/company_supervisor_mobile_attendance_report_repository.dart';
import '../../data/repositories/company_supervisor_mobile_attendance_report_repository_impl.dart';
import '../../domain/entities/company_supervisor_mobile_attendance_report_entity.dart';

// ============================================================================
// DEBUG PREFIX
// ============================================================================

const String _debugPrefix =
    '[CompanySupervisorMobileAttendanceReportProvider]';

// ============================================================================
// REPOSITORY PROVIDER
// ============================================================================

final companySupervisorMobileAttendanceReportRepositoryProvider =
Provider<CompanySupervisorMobileAttendanceReportRepository>((ref) {
  return CompanySupervisorMobileAttendanceReportRepositoryImpl();
});

// ============================================================================
// COMPANY SUPERVISOR MOBILE ATTENDANCE REPORT PROVIDER
// ============================================================================

final companySupervisorMobileAttendanceReportProvider =
ChangeNotifierProvider<CompanySupervisorMobileAttendanceReportProvider>(
      (ref) {
    final repository = ref.read(
      companySupervisorMobileAttendanceReportRepositoryProvider,
    );

    return CompanySupervisorMobileAttendanceReportProvider(
      repository: repository,
    );
  },
);

// ============================================================================
// PROVIDER CLASS
// ============================================================================

class CompanySupervisorMobileAttendanceReportProvider
    extends ChangeNotifier {
  // ==========================================================================
  // REPOSITORY
  // ==========================================================================

  final CompanySupervisorMobileAttendanceReportRepository _repository;

  CompanySupervisorMobileAttendanceReportProvider({
    required CompanySupervisorMobileAttendanceReportRepository repository,
  }) : _repository = repository;

  // ==========================================================================
  // STATE
  // ==========================================================================

  bool _isLoading = false;

  bool _isRefreshing = false;

  String? _error;

  String? _companyId;

  String? _supervisorId;

  String? _departmentId;

  List<CompanySupervisorMobileAttendanceReportEntity> _todayReports = [];

  List<CompanySupervisorMobileAttendanceReportEntity> _reports = [];

  Map<String, dynamic> _summary = {};

  DateTime? _selectedStartDate;

  DateTime? _selectedEndDate;

  // ==========================================================================
  // BASIC GETTERS
  // ==========================================================================

  bool get isLoading => _isLoading;

  bool get isRefreshing => _isRefreshing;

  bool get isBusy => _isLoading || _isRefreshing;

  String? get error => _error;

  String? get companyId => _companyId;

  String? get supervisorId => _supervisorId;

  String? get departmentId => _departmentId;

  List<CompanySupervisorMobileAttendanceReportEntity> get todayReports =>
      List.unmodifiable(_todayReports);

  List<CompanySupervisorMobileAttendanceReportEntity> get reports =>
      List.unmodifiable(_reports);

  Map<String, dynamic> get summary => Map.unmodifiable(_summary);

  DateTime? get selectedStartDate => _selectedStartDate;

  DateTime? get selectedEndDate => _selectedEndDate;

  bool get hasTodayReports => _todayReports.isNotEmpty;

  bool get hasReports => _reports.isNotEmpty;

  bool get hasSummary => _summary.isNotEmpty;

  // ==========================================================================
  // TODAY COUNTS
  // ==========================================================================

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

  int get todayLeaveCount {
    return _todayReports.where((report) {
      return report.attendanceStatus.trim().toUpperCase() == 'LEAVE';
    }).length;
  }

  // ==========================================================================
  // REPORT COUNTS
  // ==========================================================================

  int get totalReportCount => _reports.length;

  int get presentCount =>
      _reports.where((report) => report.isPresent).length;

  int get absentCount =>
      _reports.where((report) => report.isAbsent).length;

  int get lateCount =>
      _reports.where((report) => report.isLate).length;

  int get earlyOutCount =>
      _reports.where((report) => report.isEarlyOut).length;

  int get holidayCount =>
      _reports.where((report) => report.isHoliday).length;

  int get leaveCount {
    return _reports.where((report) {
      return report.attendanceStatus.trim().toUpperCase() == 'LEAVE';
    }).length;
  }

  // ==========================================================================
  // WORK INFORMATION
  // ==========================================================================

  int get totalLateMinutes {
    return _reports.fold(
      0,
          (total, report) => total + report.lateMinutes,
    );
  }

  int get totalEarlyLeaveMinutes {
    return _reports.fold(
      0,
          (total, report) => total + report.earlyLeaveMinutes,
    );
  }



  // ==========================================================================
  // INITIALIZE
  // ==========================================================================

  Future<void> initialize({
    required String companyId,
    required String supervisorId,
    String? departmentId,
  }) async {
    _debug(
      'initialize() called',
    );

    _debug(
      'companyId="$companyId", '
          'supervisorId="$supervisorId", '
          'departmentId="$departmentId"',
    );

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

    _debugState();

    await loadTodayReports();
  }

  // ==========================================================================
  // SET COMPANY
  // ==========================================================================

  void setCompanyId(String companyId) {
    final value = companyId.trim();

    _companyId = value.isEmpty ? null : value;

    _debug(
      'setCompanyId() => "$_companyId"',
    );

    notifyListeners();
  }

  // ==========================================================================
  // SET SUPERVISOR
  // ==========================================================================

  void setSupervisorId(String supervisorId) {
    final value = supervisorId.trim();

    _supervisorId = value.isEmpty ? null : value;

    _debug(
      'setSupervisorId() => "$_supervisorId"',
    );

    notifyListeners();
  }

  // ==========================================================================
  // SET DEPARTMENT
  // ==========================================================================

  void setDepartmentId(String? departmentId) {
    _departmentId = _normalizeDepartmentId(departmentId);

    _debug(
      'setDepartmentId() => "$_departmentId"',
    );

    notifyListeners();
  }

  // ==========================================================================
  // LOAD TODAY REPORTS
  // ==========================================================================

  Future<void> loadTodayReports({
    String? companyId,
    String? supervisorId,
    String? departmentId,
  }) async {
    _debug('------------------------------------------------------------');

    _debug('loadTodayReports() START');

    final company = _resolveCompanyId(companyId);

    final supervisor = _resolveSupervisorId(supervisorId);

    final department = _resolveDepartmentId(departmentId);

    _debug(
      'Resolved parameters => '
          'companyId="$company", '
          'supervisorId="$supervisor", '
          'departmentId="$department"',
    );

    if (company == null) {
      _setError('Company ID is required.');
      return;
    }

    if (supervisor == null) {
      _setError('Supervisor ID is required.');
      return;
    }

    _setLoading(true);

    try {
      _clearError();

      _debug(
        'Repository call => getTodayReports('
            'companyId="$company", '
            'supervisorId="$supervisor", '
            'departmentId="$department")',
      );

      final result = await _repository.getTodayReports(
        companyId: company,
        supervisorId: supervisor,
        departmentId: department,
      );

      _debug(
        'Repository response => ${result.length} today report(s)',
      );

      _todayReports = result;

      _debugTodayCounts();

      notifyListeners();
    } catch (e) {
      _debugError('loadTodayReports()', e);

      _setError(_cleanError(e));
    } finally {
      _setLoading(false);

      _debug('loadTodayReports() END');
    }
  }

  // ==========================================================================
  // LOAD REPORT BY DATE
  // ==========================================================================

  Future<void> loadReportsByDate({
    String? companyId,
    String? supervisorId,
    required DateTime date,
    String? departmentId,
  }) async {
    _debug('------------------------------------------------------------');

    _debug(
      'loadReportsByDate() START => '
          '${_formatDate(date)}',
    );

    final company = _resolveCompanyId(companyId);

    final supervisor = _resolveSupervisorId(supervisorId);

    final department = _resolveDepartmentId(departmentId);

    if (company == null) {
      _setError('Company ID is required.');
      return;
    }

    if (supervisor == null) {
      _setError('Supervisor ID is required.');
      return;
    }

    final normalizedDate = _normalizeDate(date);

    _debug(
      'Resolved parameters => '
          'companyId="$company", '
          'supervisorId="$supervisor", '
          'departmentId="$department", '
          'date="${_formatDate(normalizedDate)}"',
    );

    _setLoading(true);

    try {
      _clearError();

      final result = await _repository.getReportsByDate(
        companyId: company,
        supervisorId: supervisor,
        date: normalizedDate,
        departmentId: department,
      );

      _debug(
        'Repository response => ${result.length} report(s)',
      );

      _reports = result;

      _selectedStartDate = normalizedDate;

      _selectedEndDate = normalizedDate;

      _debugReportCounts();

      notifyListeners();
    } catch (e) {
      _debugError('loadReportsByDate()', e);

      _setError(_cleanError(e));
    } finally {
      _setLoading(false);

      _debug('loadReportsByDate() END');
    }
  }

  // ==========================================================================
  // LOAD REPORTS BY DATE RANGE
  // ==========================================================================

  Future<void> loadReportsByDateRange({
    String? companyId,
    String? supervisorId,
    required DateTime startDate,
    required DateTime endDate,
    String? departmentId,
  }) async {
    _debug('------------------------------------------------------------');

    _debug('loadReportsByDateRange() START');

    final company = _resolveCompanyId(companyId);

    final supervisor = _resolveSupervisorId(supervisorId);

    final department = _resolveDepartmentId(departmentId);

    final start = _normalizeDate(startDate);

    final end = _normalizeDate(endDate);

    _debug(
      'Resolved parameters => '
          'companyId="$company", '
          'supervisorId="$supervisor", '
          'departmentId="$department", '
          'startDate="${_formatDate(start)}", '
          'endDate="${_formatDate(end)}"',
    );

    if (company == null) {
      _setError('Company ID is required.');
      return;
    }

    if (supervisor == null) {
      _setError('Supervisor ID is required.');
      return;
    }

    if (end.isBefore(start)) {
      _setError('End date cannot be before start date.');
      return;
    }

    _setLoading(true);

    try {
      _clearError();

      final result = await _repository.getReportsByDateRange(
        companyId: company,
        supervisorId: supervisor,
        startDate: start,
        endDate: end,
        departmentId: department,
      );

      _debug(
        'Repository response => ${result.length} report(s)',
      );

      _selectedStartDate = start;

      _selectedEndDate = end;

      _reports = result;

      _debugReportCounts();

      notifyListeners();
    } catch (e) {
      _debugError('loadReportsByDateRange()', e);

      _setError(_cleanError(e));
    } finally {
      _setLoading(false);

      _debug('loadReportsByDateRange() END');
    }
  }

  // ==========================================================================
  // LOAD CURRENT MONTH
  // ==========================================================================

  Future<void> loadCurrentMonthReports({
    String? companyId,
    String? supervisorId,
    String? departmentId,
  }) async {
    _debug('------------------------------------------------------------');

    _debug('loadCurrentMonthReports() START');

    final company = _resolveCompanyId(companyId);

    final supervisor = _resolveSupervisorId(supervisorId);

    final department = _resolveDepartmentId(departmentId);

    if (company == null) {
      _setError('Company ID is required.');
      return;
    }

    if (supervisor == null) {
      _setError('Supervisor ID is required.');
      return;
    }

    final now = DateTime.now();

    final startDate = DateTime(
      now.year,
      now.month,
      1,
    );

    final endDate = DateTime(
      now.year,
      now.month + 1,
      0,
    );

    _debug(
      'Current month => '
          '${_formatDate(startDate)} to ${_formatDate(endDate)}',
    );

    _debug(
      'Parameters => '
          'companyId="$company", '
          'supervisorId="$supervisor", '
          'departmentId="$department"',
    );

    _setLoading(true);

    try {
      _clearError();

      final result = await _repository.getCurrentMonthReports(
        companyId: company,
        supervisorId: supervisor,
        departmentId: department,
      );

      _debug(
        'Repository response => ${result.length} report(s)',
      );

      _selectedStartDate = startDate;

      _selectedEndDate = endDate;

      _reports = result;

      _debugReportCounts();

      notifyListeners();
    } catch (e) {
      _debugError('loadCurrentMonthReports()', e);

      _setError(_cleanError(e));
    } finally {
      _setLoading(false);

      _debug('loadCurrentMonthReports() END');
    }
  }

  // ==========================================================================
  // LOAD SUMMARY
  // ==========================================================================

  Future<void> loadSummary({
    String? companyId,
    String? supervisorId,
    required DateTime startDate,
    required DateTime endDate,
    String? departmentId,
  }) async {
    _debug('------------------------------------------------------------');

    _debug('loadSummary() START');

    final company = _resolveCompanyId(companyId);

    final supervisor = _resolveSupervisorId(supervisorId);

    final department = _resolveDepartmentId(departmentId);

    final start = _normalizeDate(startDate);

    final end = _normalizeDate(endDate);

    if (company == null) {
      _setError('Company ID is required.');
      return;
    }

    if (supervisor == null) {
      _setError('Supervisor ID is required.');
      return;
    }

    if (end.isBefore(start)) {
      _setError('End date cannot be before start date.');
      return;
    }

    _debug(
      'Summary parameters => '
          'companyId="$company", '
          'supervisorId="$supervisor", '
          'departmentId="$department", '
          'startDate="${_formatDate(start)}", '
          'endDate="${_formatDate(end)}"',
    );

    _setLoading(true);

    try {
      _clearError();

      final result = await _repository.getReportSummary(
        companyId: company,
        supervisorId: supervisor,
        startDate: start,
        endDate: end,
        departmentId: department,
      );

      _debug(
        'Summary response => ${result.length} field(s)',
      );

      _debug(
        'Summary data => $result',
      );

      _selectedStartDate = start;

      _selectedEndDate = end;

      _summary = Map<String, dynamic>.from(result);

      notifyListeners();
    } catch (e) {
      _debugError('loadSummary()', e);

      _setError(_cleanError(e));
    } finally {
      _setLoading(false);

      _debug('loadSummary() END');
    }
  }

  // ==========================================================================
  // LOAD REPORTS + SUMMARY
  // ==========================================================================

  Future<void> loadReportsAndSummary({
    String? companyId,
    String? supervisorId,
    required DateTime startDate,
    required DateTime endDate,
    String? departmentId,
  }) async {
    _debug('============================================================');

    _debug('loadReportsAndSummary() START');

    final company = _resolveCompanyId(companyId);

    final supervisor = _resolveSupervisorId(supervisorId);

    final department = _resolveDepartmentId(departmentId);

    final start = _normalizeDate(startDate);

    final end = _normalizeDate(endDate);

    if (company == null) {
      _setError('Company ID is required.');
      return;
    }

    if (supervisor == null) {
      _setError('Supervisor ID is required.');
      return;
    }

    if (end.isBefore(start)) {
      _setError('End date cannot be before start date.');
      return;
    }

    _debug(
      'Combined query parameters => '
          'companyId="$company", '
          'supervisorId="$supervisor", '
          'departmentId="$department", '
          'startDate="${_formatDate(start)}", '
          'endDate="${_formatDate(end)}"',
    );

    _setLoading(true);

    try {
      _clearError();

      _selectedStartDate = start;

      _selectedEndDate = end;

      _debug('Starting reports query...');

      final reportsFuture = _repository.getReportsByDateRange(
        companyId: company,
        supervisorId: supervisor,
        startDate: start,
        endDate: end,
        departmentId: department,
      );

      _debug('Starting summary query...');

      final summaryFuture = _repository.getReportSummary(
        companyId: company,
        supervisorId: supervisor,
        startDate: start,
        endDate: end,
        departmentId: department,
      );

      final results = await Future.wait([
        reportsFuture,
        summaryFuture,
      ]);

      final reports =
      results[0] as List<CompanySupervisorMobileAttendanceReportEntity>;

      final summary =
      results[1] as Map<String, dynamic>;

      _debug(
        'Reports query response => ${reports.length} report(s)',
      );

      _debug(
        'Summary query response => ${summary.length} field(s)',
      );

      _debug(
        'Summary data => $summary',
      );

      _reports = reports;

      _summary = Map<String, dynamic>.from(summary);

      _debugReportCounts();

      notifyListeners();
    } catch (e) {
      _debugError('loadReportsAndSummary()', e);

      _setError(_cleanError(e));
    } finally {
      _setLoading(false);

      _debug('loadReportsAndSummary() END');

      _debug('============================================================');
    }
  }

  // ==========================================================================
  // REFRESH TODAY
  // ==========================================================================

  Future<void> refreshTodayReports({
    String? companyId,
    String? supervisorId,
    String? departmentId,
  }) async {
    _debug('------------------------------------------------------------');

    _debug('refreshTodayReports() START');

    final company = _resolveCompanyId(companyId);

    final supervisor = _resolveSupervisorId(supervisorId);

    final department = _resolveDepartmentId(departmentId);

    if (company == null) {
      _setError('Company ID is required.');
      return;
    }

    if (supervisor == null) {
      _setError('Supervisor ID is required.');
      return;
    }

    _debug(
      'Refresh parameters => '
          'companyId="$company", '
          'supervisorId="$supervisor", '
          'departmentId="$department"',
    );

    _setRefreshing(true);

    try {
      _clearError();

      final result = await _repository.refreshTodayReports(
        companyId: company,
        supervisorId: supervisor,
        departmentId: department,
      );

      _debug(
        'Refresh response => ${result.length} today report(s)',
      );

      _todayReports = result;

      _debugTodayCounts();

      notifyListeners();
    } catch (e) {
      _debugError('refreshTodayReports()', e);

      _setError(_cleanError(e));
    } finally {
      _setRefreshing(false);

      _debug('refreshTodayReports() END');
    }
  }

  // ==========================================================================
  // REFRESH ALL
  // ==========================================================================

  Future<void> refresh({
    String? companyId,
    String? supervisorId,
    String? departmentId,
  }) async {
    _debug('============================================================');

    _debug('refresh() START');

    final company = _resolveCompanyId(companyId);

    final supervisor = _resolveSupervisorId(supervisorId);

    final department = _resolveDepartmentId(departmentId);

    if (company == null) {
      _setError('Company ID is required.');
      return;
    }

    if (supervisor == null) {
      _setError('Supervisor ID is required.');
      return;
    }

    _debug(
      'Refresh all parameters => '
          'companyId="$company", '
          'supervisorId="$supervisor", '
          'departmentId="$department"',
    );

    _setRefreshing(true);

    try {
      _clearError();

      _debug('Refreshing today reports...');

      final today = await _repository.refreshTodayReports(
        companyId: company,
        supervisorId: supervisor,
        departmentId: department,
      );

      _todayReports = today;

      _debug(
        'Today refresh response => ${today.length} report(s)',
      );

      if (_selectedStartDate != null &&
          _selectedEndDate != null) {
        final start = _selectedStartDate!;

        final end = _selectedEndDate!;

        _debug(
          'Refreshing selected range => '
              '${_formatDate(start)} to ${_formatDate(end)}',
        );

        final reportsFuture = _repository.getReportsByDateRange(
          companyId: company,
          supervisorId: supervisor,
          startDate: start,
          endDate: end,
          departmentId: department,
        );

        final summaryFuture = _repository.getReportSummary(
          companyId: company,
          supervisorId: supervisor,
          startDate: start,
          endDate: end,
          departmentId: department,
        );

        final results = await Future.wait([
          reportsFuture,
          summaryFuture,
        ]);

        final reports =
        results[0]
        as List<CompanySupervisorMobileAttendanceReportEntity>;

        final summary =
        results[1] as Map<String, dynamic>;

        _reports = reports;

        _summary = Map<String, dynamic>.from(summary);

        _debug(
          'Range refresh reports => ${reports.length} report(s)',
        );

        _debug(
          'Range refresh summary => $summary',
        );
      } else {
        _debug(
          'No selected date range. '
              'Only today reports were refreshed.',
        );
      }

      _debugTodayCounts();

      _debugReportCounts();

      notifyListeners();
    } catch (e) {
      _debugError('refresh()', e);

      _setError(_cleanError(e));
    } finally {
      _setRefreshing(false);

      _debug('refresh() END');

      _debug('============================================================');
    }
  }

  // ==========================================================================
  // CLEAR TODAY REPORTS
  // ==========================================================================

  void clearTodayReports() {
    _debug('clearTodayReports()');

    _todayReports = [];

    notifyListeners();
  }

  // ==========================================================================
  // CLEAR REPORTS
  // ==========================================================================

  void clearReports() {
    _debug('clearReports()');

    _reports = [];

    _summary = {};

    _selectedStartDate = null;

    _selectedEndDate = null;

    notifyListeners();
  }

  // ==========================================================================
  // CLEAR SUMMARY
  // ==========================================================================

  void clearSummary() {
    _debug('clearSummary()');

    _summary = {};

    notifyListeners();
  }

  // ==========================================================================
  // CLEAR ERROR
  // ==========================================================================

  void clearError() {
    if (_error == null) {
      return;
    }

    _debug('clearError()');

    _error = null;

    notifyListeners();
  }

  // ==========================================================================
  // RESET
  // ==========================================================================

  void reset() {
    _debug('reset()');

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

  // ==========================================================================
  // RESOLVE COMPANY ID
  // ==========================================================================

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

  // ==========================================================================
  // RESOLVE SUPERVISOR ID
  // ==========================================================================

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

  // ==========================================================================
  // RESOLVE DEPARTMENT ID
  // ==========================================================================

  String? _resolveDepartmentId(String? departmentId) {
    if (departmentId != null) {
      _departmentId = _normalizeDepartmentId(departmentId);
    }

    return _departmentId;
  }

  // ==========================================================================
  // NORMALIZE DEPARTMENT ID
  // ==========================================================================

  String? _normalizeDepartmentId(String? departmentId) {
    final value = departmentId?.trim();

    if (value == null || value.isEmpty) {
      return null;
    }

    return value;
  }

  // ==========================================================================
  // NORMALIZE DATE
  // ==========================================================================

  DateTime _normalizeDate(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  // ==========================================================================
  // FORMAT DATE
  // ==========================================================================

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');

    final month = date.month.toString().padLeft(2, '0');

    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  // ==========================================================================
  // SET LOADING
  // ==========================================================================

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }

    _isLoading = value;

    _debug(
      '_isLoading => $_isLoading',
    );

    notifyListeners();
  }

  // ==========================================================================
  // SET REFRESHING
  // ==========================================================================

  void _setRefreshing(bool value) {
    if (_isRefreshing == value) {
      return;
    }

    _isRefreshing = value;

    _debug(
      '_isRefreshing => $_isRefreshing',
    );

    notifyListeners();
  }

  // ==========================================================================
  // SET ERROR
  // ==========================================================================

  void _setError(String message) {
    _error = message;

    _debug(
      'ERROR => $_error',
    );

    notifyListeners();
  }

  // ==========================================================================
  // CLEAR INTERNAL ERROR
  // ==========================================================================

  void _clearError() {
    _error = null;
  }

  // ==========================================================================
  // CLEAN ERROR
  // ==========================================================================

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

  // ==========================================================================
  // DEBUG LOGGER
  // ==========================================================================

  void _debug(String message) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('$_debugPrefix $message');
  }

  // ==========================================================================
  // DEBUG ERROR
  // ==========================================================================

  void _debugError(
      String method,
      Object error,
      ) {
    if (!kDebugMode) {
      return;
    }

    debugPrint(
      '$_debugPrefix ERROR in $method => $error',
    );

    if (error is Error) {
      debugPrint(
        '$_debugPrefix STACK TRACE => ${error.stackTrace}',
      );
    }
  }

  // ==========================================================================
  // DEBUG STATE
  // ==========================================================================

  void _debugState() {
    if (!kDebugMode) {
      return;
    }

    debugPrint(
      '$_debugPrefix STATE => '
          'companyId="$_companyId", '
          'supervisorId="$_supervisorId", '
          'departmentId="$_departmentId"',
    );
  }

  // ==========================================================================
  // DEBUG TODAY COUNTS
  // ==========================================================================

  void _debugTodayCounts() {
    if (!kDebugMode) {
      return;
    }

    debugPrint(
      '$_debugPrefix TODAY COUNTS => '
          'total=$todayTotalCount, '
          'present=$todayPresentCount, '
          'absent=$todayAbsentCount, '
          'late=$todayLateCount, '
          'earlyOut=$todayEarlyOutCount, '
          'holiday=$todayHolidayCount, '
          'leave=$todayLeaveCount',
    );
  }

  // ==========================================================================
  // DEBUG REPORT COUNTS
  // ==========================================================================

  void _debugReportCounts() {
    if (!kDebugMode) {
      return;
    }

    debugPrint(
      '$_debugPrefix REPORT COUNTS => '
          'total=$totalReportCount, '
          'present=$presentCount, '
          'absent=$absentCount, '
          'late=$lateCount, '
          'earlyOut=$earlyOutCount, '
          'holiday=$holidayCount, '
          'leave=$leaveCount, '
          'lateMinutes=$totalLateMinutes, '
          'earlyLeaveMinutes=$totalEarlyLeaveMinutes, ',
    );
  }
}