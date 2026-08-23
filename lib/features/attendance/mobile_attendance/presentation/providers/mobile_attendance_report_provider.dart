import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/mobile_attendance_report_repository.dart';
import '../../domain/entities/mobile_attendance_report_entity.dart';
import '../../data/repositories/mobile_attendance_report_repository_impl.dart';

//=================================================================
// REPOSITORY PROVIDER
//=================================================================

final mobileAttendanceReportRepositoryProvider =
Provider<MobileAttendanceReportRepository>((ref) {
  return MobileAttendanceReportRepositoryImpl();
});

//=================================================================
// REPORT PROVIDER
//=================================================================

final mobileAttendanceReportProvider = ChangeNotifierProvider<
    MobileAttendanceReportProvider>((ref) {
  final repository =
  ref.read(mobileAttendanceReportRepositoryProvider);

  return MobileAttendanceReportProvider(
    repository: repository,
  );
});

//=================================================================
// MOBILE ATTENDANCE REPORT PROVIDER
//=================================================================

class MobileAttendanceReportProvider
    extends ChangeNotifier {
  final MobileAttendanceReportRepository _repository;

  MobileAttendanceReportProvider({
    required MobileAttendanceReportRepository repository,
  }) : _repository = repository;

  //=================================================================
  // STATE
  //=================================================================

  bool _isLoading = false;
  bool _isRefreshing = false;

  String? _error;

  MobileAttendanceReportEntity? _todayReport;

  List<MobileAttendanceReportEntity> _reports = [];

  Map<String, dynamic> _summary = {};

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  String? _employeeId;

  //=================================================================
  // GETTERS
  //=================================================================

  bool get isLoading => _isLoading;

  bool get isRefreshing => _isRefreshing;

  bool get isBusy =>
      _isLoading || _isRefreshing;

  String? get error => _error;

  MobileAttendanceReportEntity? get todayReport =>
      _todayReport;

  List<MobileAttendanceReportEntity> get reports =>
      List.unmodifiable(_reports);

  Map<String, dynamic> get summary =>
      Map.unmodifiable(_summary);

  DateTime? get selectedStartDate =>
      _selectedStartDate;

  DateTime? get selectedEndDate =>
      _selectedEndDate;

  String? get employeeId => _employeeId;

  bool get hasTodayReport =>
      _todayReport != null;

  bool get hasReports =>
      _reports.isNotEmpty;

  //=================================================================
  // TODAY STATUS
  //=================================================================

  bool get isPresent =>
      _todayReport?.isPresent ?? false;

  bool get isAbsent =>
      _todayReport?.isAbsent ?? false;

  bool get isLate =>
      _todayReport?.isLate ?? false;

  bool get isEarlyOut =>
      _todayReport?.isEarlyOut ?? false;

  bool get isHoliday =>
      _todayReport?.isHoliday ?? false;

  bool get isWorkingDay =>
      _todayReport?.isWorkingDay ?? true;

  //=================================================================
  // TODAY TIMES
  //=================================================================

  DateTime? get checkInTime =>
      _todayReport?.checkInTime;

  DateTime? get checkOutTime =>
      _todayReport?.checkOutTime;

  //=================================================================
  // TODAY WORK INFORMATION
  //=================================================================

  int get todayLateMinutes =>
      _todayReport?.lateMinutes ?? 0;

  int get todayEarlyLeaveMinutes =>
      _todayReport?.earlyLeaveMinutes ?? 0;

  int get todayActualWorkMinutes =>
      _todayReport?.actualWorkMinutes ?? 0;

  int get todayOvertimeMinutes =>
      _todayReport?.overtimeMinutes ?? 0;

  String get todayReportStatus =>
      _todayReport?.reportStatus ?? 'ABSENT';

  String get todayAttendanceStatus =>
      _todayReport?.attendanceStatus ?? 'PRESENT';

  //=================================================================
  // SHIFT INFORMATION
  //=================================================================

  String? get shiftName =>
      _todayReport?.shiftName;

  String? get shiftCode =>
      _todayReport?.shiftCode;

  String? get shiftStartTime =>
      _todayReport?.shiftStartTime;

  String? get shiftEndTime =>
      _todayReport?.shiftEndTime;

  int get breakMinutes =>
      _todayReport?.breakMinutes ?? 0;

  int get lateGraceMinutes =>
      _todayReport?.lateGraceMinutes ?? 0;

  int get earlyLeaveGraceMinutes =>
      _todayReport?.earlyLeaveGraceMinutes ?? 0;

  int get minimumWorkingMinutes =>
      _todayReport?.minimumWorkingMinutes ?? 0;

  int get halfDayThresholdMinutes =>
      _todayReport?.halfDayThresholdMinutes ?? 0;

  bool get isNightShift =>
      _todayReport?.isNightShift ?? false;

  bool get isFlexible =>
      _todayReport?.isFlexible ?? false;

  //=================================================================
  // INITIALIZE
  //=================================================================

  Future<void> initialize({
    required String employeeId,
  }) async {
    final id = employeeId.trim();

    if (id.isEmpty) {
      _setError('Employee ID is required.');
      return;
    }

    _employeeId = id;

    await loadTodayReport();
  }

  //=================================================================
  // SET EMPLOYEE
  //=================================================================

  void setEmployeeId(
      String employeeId,
      ) {
    final id = employeeId.trim();

    if (id.isEmpty) {
      _employeeId = null;
    } else {
      _employeeId = id;
    }

    notifyListeners();
  }

  //=================================================================
  // LOAD TODAY REPORT
  //=================================================================

  Future<void> loadTodayReport({
    String? employeeId,
  }) async {
    final id = _resolveEmployeeId(employeeId);

    if (id == null) {
      _setError('Employee ID is required.');
      return;
    }

    _setLoading(true);

    try {
      _clearError();

      final report =
      await _repository.getTodayReport(
        employeeId: id,
      );

      _todayReport = report;

      notifyListeners();
    } catch (e) {
      _setError(_cleanError(e));
    } finally {
      _setLoading(false);
    }
  }

  //=================================================================
  // GET REPORT BY DATE
  //=================================================================

  Future<MobileAttendanceReportEntity?>
  getReportByDate({
    String? employeeId,
    required DateTime date,
  }) async {
    final id = _resolveEmployeeId(employeeId);

    if (id == null) {
      _setError('Employee ID is required.');
      return null;
    }

    _setLoading(true);

    try {
      _clearError();

      final report =
      await _repository.getReportByDate(
        employeeId: id,
        date: date,
      );

      return report;
    } catch (e) {
      _setError(_cleanError(e));
      return null;
    } finally {
      _setLoading(false);
    }
  }

  //=================================================================
  // LOAD REPORTS BY DATE RANGE
  //=================================================================

  Future<void> loadReportsByDateRange({
    String? employeeId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final id = _resolveEmployeeId(employeeId);

    if (id == null) {
      _setError('Employee ID is required.');
      return;
    }

    if (endDate.isBefore(startDate)) {
      _setError(
        'End date cannot be before start date.',
      );
      return;
    }

    _setLoading(true);

    try {
      _clearError();

      _selectedStartDate = startDate;
      _selectedEndDate = endDate;

      final result =
      await _repository.getReportsByDateRange(
        employeeId: id,
        startDate: startDate,
        endDate: endDate,
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
    String? employeeId,
  }) async {
    final id = _resolveEmployeeId(employeeId);

    if (id == null) {
      _setError('Employee ID is required.');
      return;
    }

    _setLoading(true);

    try {
      _clearError();

      final now = DateTime.now();

      _selectedStartDate =
          DateTime(
            now.year,
            now.month,
            1,
          );

      _selectedEndDate =
          DateTime(
            now.year,
            now.month + 1,
            0,
          );

      final result =
      await _repository.getCurrentMonthReports(
        employeeId: id,
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
    String? employeeId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final id = _resolveEmployeeId(employeeId);

    if (id == null) {
      _setError('Employee ID is required.');
      return;
    }

    if (endDate.isBefore(startDate)) {
      _setError(
        'End date cannot be before start date.',
      );
      return;
    }

    _setLoading(true);

    try {
      _clearError();

      _selectedStartDate = startDate;
      _selectedEndDate = endDate;

      final result =
      await _repository.getReportSummary(
        employeeId: id,
        startDate: startDate,
        endDate: endDate,
      );

      _summary = Map<String, dynamic>.from(
        result,
      );

      notifyListeners();
    } catch (e) {
      _setError(_cleanError(e));
    } finally {
      _setLoading(false);
    }
  }

  //=================================================================
  // LOAD REPORT + SUMMARY
  //=================================================================

  Future<void> loadReportsAndSummary({
    String? employeeId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final id = _resolveEmployeeId(employeeId);

    if (id == null) {
      _setError('Employee ID is required.');
      return;
    }

    if (endDate.isBefore(startDate)) {
      _setError(
        'End date cannot be before start date.',
      );
      return;
    }

    _setLoading(true);

    try {
      _clearError();

      _selectedStartDate = startDate;
      _selectedEndDate = endDate;

      final results =
      await Future.wait([
        _repository.getReportsByDateRange(
          employeeId: id,
          startDate: startDate,
          endDate: endDate,
        ),
        _repository.getReportSummary(
          employeeId: id,
          startDate: startDate,
          endDate: endDate,
        ),
      ]);

      _reports =
      results[0]
      as List<MobileAttendanceReportEntity>;

      _summary =
      Map<String, dynamic>.from(
        results[1]
        as Map<String, dynamic>,
      );

      notifyListeners();
    } catch (e) {
      _setError(_cleanError(e));
    } finally {
      _setLoading(false);
    }
  }

  //=================================================================
  // REFRESH TODAY REPORT
  //=================================================================

  Future<void> refreshTodayReport({
    String? employeeId,
  }) async {
    final id = _resolveEmployeeId(employeeId);

    if (id == null) {
      _setError('Employee ID is required.');
      return;
    }

    _setRefreshing(true);

    try {
      _clearError();

      final report =
      await _repository.refreshTodayReport(
        employeeId: id,
      );

      _todayReport = report;

      notifyListeners();
    } catch (e) {
      _setError(_cleanError(e));
    } finally {
      _setRefreshing(false);
    }
  }

  //=================================================================
  // REFRESH CURRENT REPORT
  //=================================================================

  Future<void> refresh({
    String? employeeId,
  }) async {
    final id = _resolveEmployeeId(employeeId);

    if (id == null) {
      _setError('Employee ID is required.');
      return;
    }

    _setRefreshing(true);

    try {
      _clearError();

      final todayFuture =
      _repository.refreshTodayReport(
        employeeId: id,
      );

      final today =
      await todayFuture;

      _todayReport = today;

      if (_selectedStartDate != null &&
          _selectedEndDate != null) {
        final results =
        await Future.wait([
          _repository.getReportsByDateRange(
            employeeId: id,
            startDate: _selectedStartDate!,
            endDate: _selectedEndDate!,
          ),
          _repository.getReportSummary(
            employeeId: id,
            startDate: _selectedStartDate!,
            endDate: _selectedEndDate!,
          ),
        ]);

        _reports =
        results[0]
        as List<MobileAttendanceReportEntity>;

        _summary =
        Map<String, dynamic>.from(
          results[1]
          as Map<String, dynamic>,
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
  // CLEAR TODAY REPORT
  //=================================================================

  void clearTodayReport() {
    _todayReport = null;
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
    _todayReport = null;
    _reports = [];
    _summary = {};
    _selectedStartDate = null;
    _selectedEndDate = null;
    _employeeId = null;

    notifyListeners();
  }

  //=================================================================
  // PRIVATE EMPLOYEE ID
  //=================================================================

  String? _resolveEmployeeId(
      String? employeeId,
      ) {
    final supplied =
    employeeId?.trim();

    if (supplied != null &&
        supplied.isNotEmpty) {
      _employeeId = supplied;
      return supplied;
    }

    final current =
    _employeeId?.trim();

    if (current == null ||
        current.isEmpty) {
      return null;
    }

    return current;
  }

  //=================================================================
  // PRIVATE LOADING
  //=================================================================

  void _setLoading(
      bool value,
      ) {
    _isLoading = value;
    notifyListeners();
  }

  //=================================================================
  // PRIVATE REFRESHING
  //=================================================================

  void _setRefreshing(
      bool value,
      ) {
    _isRefreshing = value;
    notifyListeners();
  }

  //=================================================================
  // PRIVATE ERROR
  //=================================================================

  void _setError(
      String message,
      ) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  //=================================================================
  // ERROR CLEANER
  //=================================================================

  String _cleanError(
      Object error,
      ) {
    final message =
    error.toString().trim();

    if (message.startsWith(
      'Exception: ',
    )) {
      return message.substring(
        'Exception: '.length,
      );
    }

    if (message.isEmpty) {
      return 'Something went wrong.';
    }

    return message;
  }
}