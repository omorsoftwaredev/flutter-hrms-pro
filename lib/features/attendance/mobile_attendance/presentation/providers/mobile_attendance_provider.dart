import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/mobile_attendance_checkin_service.dart';
import '../../../../auth/data/repositories/current_employee_repository.dart';
import '../../../../shift/data/repositories/shift_repository_impl.dart';
import '../../../../shift/domain/entities/shift_entity.dart';
import '../../../../shift/domain/repositories/shift_repository.dart';
import '../../data/repositories/mobile_attendance_repository.dart';
import '../../domain/entities/mobile_attendance_entity.dart';

class MobileAttendanceProvider extends ChangeNotifier {
  MobileAttendanceProvider({
    MobileAttendanceRepository? repository,
    MobileAttendanceCheckInService? attendanceService,
    CurrentEmployeeRepository? employeeRepository,
    required ShiftRepository shiftService,
  })  : _repository =
      repository ?? MobileAttendanceRepository(),
        _attendanceService =
            attendanceService ?? MobileAttendanceCheckInService(),
        _employeeRepository =
            employeeRepository ?? CurrentEmployeeRepository(),
        _shiftService = shiftService;

  //=================================================================
  // DEPENDENCIES
  //=================================================================

  final MobileAttendanceRepository _repository;

  final MobileAttendanceCheckInService _attendanceService;

  final CurrentEmployeeRepository _employeeRepository;

  final ShiftRepository _shiftService;

  //=================================================================
  // ATTENDANCE STATE
  //=================================================================

  MobileAttendanceEntity? _todayAttendance;

  bool _isLoading = false;

  bool _isCheckingIn = false;

  bool _isCheckingOut = false;

  String? _error;

  String? _employeeId;

  String? _shiftId;

  //=================================================================
  // SHIFT STATE
  //=================================================================

  ShiftEntity? _shift;

  //=================================================================
  // LIVE WORK TIMER
  //=================================================================

  Timer? _workTimer;

  int _liveWorkMinutes = 0;

  //=================================================================
  // BASIC GETTERS
  //=================================================================

  MobileAttendanceEntity? get todayAttendance =>
      _todayAttendance;

  bool get isLoading =>
      _isLoading;

  bool get isCheckingIn =>
      _isCheckingIn;

  bool get isCheckingOut =>
      _isCheckingOut;

  bool get isBusy =>
      _isLoading ||
          _isCheckingIn ||
          _isCheckingOut;

  String? get error =>
      _error;

  String? get employeeId =>
      _employeeId;

  //=================================================================
  // SHIFT GETTERS
  //=================================================================

  ShiftEntity? get shift =>
      _shift;

  String? get shiftId =>
      _shift?.id ?? _shiftId;

  String? get shiftName =>
      _shift?.name;

  String? get shiftStartTime =>
      _shift?.startTime;

  String? get shiftEndTime =>
      _shift?.endTime;

  int get lateGraceMinutes =>
      _shift?.lateGraceMinutes ?? 0;

  int get earlyLeaveGraceMinutes =>
      _shift?.earlyLeaveGraceMinutes ?? 0;

  int get halfDayMinutes =>
      _shift?.halfDayAfterMinutes ?? 0;

  bool get isNightShift =>
      _shift?.isNightShift ?? false;

  //=================================================================
  // ATTENDANCE STATE
  //=================================================================

  bool get isNotCheckedIn =>
      _todayAttendance == null;

  bool get isCheckedIn =>
      _todayAttendance?.checkInTime != null &&
          _todayAttendance?.checkOutTime == null;

  bool get isCompleted =>
      _todayAttendance?.checkOutTime != null;

  bool get hasCheckedIn =>
      _todayAttendance?.checkInTime != null;

  bool get hasCheckedOut =>
      _todayAttendance?.checkOutTime != null;

  bool get canCheckIn =>
      _todayAttendance == null;

  bool get canCheckOut =>
      _todayAttendance?.checkInTime != null &&
          _todayAttendance?.checkOutTime == null;

  //=================================================================
  // ATTENDANCE STATE TEXT
  //=================================================================

  String get attendanceState {
    final attendance =
        _todayAttendance;

    if (attendance == null) {
      return 'NOT_CHECKED_IN';
    }

    if (attendance.checkInTime != null &&
        attendance.checkOutTime == null) {
      return 'CHECKED_IN';
    }

    if (attendance.checkOutTime != null) {
      return 'COMPLETED';
    }

    return 'NOT_CHECKED_IN';
  }

  //=================================================================
  // ACTUAL WORK MINUTES
  //
  // IMPORTANT:
  // This calculation uses actual attendance timestamps.
  //
  // Database work_minutes is intentionally NOT trusted for UI.
  //=================================================================

  int get actualWorkMinutes {
    final attendance =
        _todayAttendance;

    final checkIn =
        attendance?.checkInTime;

    if (checkIn == null) {
      return 0;
    }

    final checkOut =
        attendance?.checkOutTime;

    final endTime =
        checkOut ?? DateTime.now();

    final duration =
    endTime.difference(checkIn);

    if (duration.isNegative) {
      return 0;
    }

    final calculatedMinutes =
        duration.inMinutes;

    if (checkOut == null) {
      return calculatedMinutes > 0
          ? calculatedMinutes
          : _liveWorkMinutes;
    }

    return calculatedMinutes;
  }

  //=================================================================
  // ACTUAL WORK TEXT
  //=================================================================

  String get actualWorkDurationText {
    return _formatMinutes(
      actualWorkMinutes,
    );
  }

  //=================================================================
  // CALCULATED WORK MINUTES
  //=================================================================

  int get calculatedWorkMinutes {
    return actualWorkMinutes;
  }

  //=================================================================
  // RECORDED WORK MINUTES
  //
  // Kept for UI compatibility.
  //=================================================================

  int get recordedWorkMinutes {
    return actualWorkMinutes;
  }

  //=================================================================
  // RECORDED WORK TEXT
  //=================================================================

  String get recordedWorkDurationText {
    return _formatMinutes(
      recordedWorkMinutes,
    );
  }

  //=================================================================
  // SCHEDULED SHIFT MINUTES
  //=================================================================

  int get scheduledWorkMinutes {
    final currentShift =
        _shift;

    if (currentShift == null) {
      return 0;
    }

    return _calculateShiftDurationMinutes(
      currentShift.startTime,
      currentShift.endTime,
      currentShift.isNightShift,
    );
  }

  //=================================================================
  // SCHEDULED WORK TEXT
  //=================================================================

  String get scheduledWorkDurationText {
    return _formatMinutes(
      scheduledWorkMinutes,
    );
  }

  //=================================================================
  // OVERTIME MINUTES
  //
  // Actual Work - Scheduled Shift Duration
  //=================================================================

  int get calculatedOvertimeMinutes {
    final actual =
        actualWorkMinutes;

    final scheduled =
        scheduledWorkMinutes;

    if (actual <= 0 ||
        scheduled <= 0) {
      return 0;
    }

    final overtime =
        actual - scheduled;

    if (overtime <= 0) {
      return 0;
    }

    return overtime;
  }

  //=================================================================
  // OVERTIME
  //=================================================================

  int get overtimeMinutes {
    return calculatedOvertimeMinutes;
  }

  //=================================================================
  // OVERTIME TEXT
  //=================================================================

  String get overtimeDurationText {
    return _formatMinutes(
      overtimeMinutes,
    );
  }

  //=================================================================
  // INITIALIZE
  //=================================================================

  Future<void> initialize() async {
    await loadTodayAttendance();
  }

  //=================================================================
  // LOAD TODAY ATTENDANCE
  //=================================================================

  Future<void> loadTodayAttendance({
    String? employeeId,
  }) async {
    if (_isLoading) {
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      String? resolvedEmployeeId =
      employeeId?.trim();

      final employee =
      await _employeeRepository.currentEmployee();

      if (resolvedEmployeeId == null ||
          resolvedEmployeeId.isEmpty) {
        resolvedEmployeeId =
            employee?.id;
      }

      if (resolvedEmployeeId == null ||
          resolvedEmployeeId.trim().isEmpty) {
        _resetAttendanceState();

        throw Exception(
          'Current employee not found.',
        );
      }

      _employeeId =
          resolvedEmployeeId.trim();

      // -------------------------------------------------------------
      // Employee shift.
      // -------------------------------------------------------------

      final employeeShiftId =
      employee?.shiftId?.trim();

      if (employeeShiftId != null &&
          employeeShiftId.isNotEmpty) {
        _shiftId =
            employeeShiftId;
      }

      // -------------------------------------------------------------
      // Load today's attendance.
      // -------------------------------------------------------------

      _todayAttendance =
      await _repository.getTodayAttendance(
        _employeeId!,
      );

      // -------------------------------------------------------------
      // Attendance shift has priority.
      // -------------------------------------------------------------

      final attendanceShiftId =
      _todayAttendance
          ?.shiftId
          ?.trim();

      if (attendanceShiftId != null &&
          attendanceShiftId.isNotEmpty) {
        _shiftId =
            attendanceShiftId;
      }

      // -------------------------------------------------------------
      // Load shift.
      // -------------------------------------------------------------

      await _loadShift();

      // -------------------------------------------------------------
      // Calculate current work duration.
      // -------------------------------------------------------------

      _updateLiveWorkTime();

      // -------------------------------------------------------------
      // Start/stop timer.
      // -------------------------------------------------------------

      _syncWorkTimer();

      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint(
        'MobileAttendanceProvider.loadTodayAttendance error: $e',
      );

      debugPrint(
        'StackTrace: $stackTrace',
      );

      _setError(
        _cleanErrorMessage(e),
      );
    } finally {
      _setLoading(false);
    }
  }

  //=================================================================
  // LOAD SHIFT
  //=================================================================

  Future<void> _loadShift() async {
    _shift = null;

    final id =
    _shiftId?.trim();

    if (id == null ||
        id.isEmpty) {
      notifyListeners();
      return;
    }

    try {
      _shift =
      await _shiftService.getShiftById(
        id,
      );
    } catch (e, stackTrace) {
      debugPrint(
        'MobileAttendanceProvider._loadShift error: $e',
      );

      debugPrint(
        'StackTrace: $stackTrace',
      );

      _shift = null;
    }

    notifyListeners();
  }

  //=================================================================
  // REFRESH
  //=================================================================

  Future<void> refresh() async {
    if (_isLoading ||
        _isCheckingIn ||
        _isCheckingOut) {
      return;
    }

    _clearError();

    _setLoading(true);

    try {
      String? resolvedEmployeeId =
          _employeeId;

      final employee =
      await _employeeRepository.currentEmployee();

      if (resolvedEmployeeId == null ||
          resolvedEmployeeId.trim().isEmpty) {
        resolvedEmployeeId =
            employee?.id;
      }

      if (resolvedEmployeeId == null ||
          resolvedEmployeeId.trim().isEmpty) {
        _resetAttendanceState();

        throw Exception(
          'Current employee not found.',
        );
      }

      _employeeId =
          resolvedEmployeeId.trim();

      // -------------------------------------------------------------
      // Employee shift fallback.
      // -------------------------------------------------------------

      if (_shiftId == null ||
          _shiftId!.trim().isEmpty) {
        final employeeShiftId =
        employee?.shiftId?.trim();

        if (employeeShiftId != null &&
            employeeShiftId.isNotEmpty) {
          _shiftId =
              employeeShiftId;
        }
      }

      // -------------------------------------------------------------
      // Refresh attendance.
      // -------------------------------------------------------------

      _todayAttendance =
      await _repository.refreshTodayAttendance(
        _employeeId!,
      );

      // -------------------------------------------------------------
      // Attendance shift priority.
      // -------------------------------------------------------------

      final attendanceShiftId =
      _todayAttendance
          ?.shiftId
          ?.trim();

      if (attendanceShiftId != null &&
          attendanceShiftId.isNotEmpty) {
        _shiftId =
            attendanceShiftId;
      }

      // -------------------------------------------------------------
      // Reload shift.
      // -------------------------------------------------------------

      await _loadShift();

      _updateLiveWorkTime();

      _syncWorkTimer();

      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint(
        'MobileAttendanceProvider.refresh error: $e',
      );

      debugPrint(
        'StackTrace: $stackTrace',
      );

      _setError(
        _cleanErrorMessage(e),
      );
    } finally {
      _setLoading(false);
    }
  }

  //=================================================================
  // CHECK IN
  //=================================================================

  Future<bool> checkIn({
    required MobileAttendanceEntity attendance,
  }) async {
    if (_isCheckingIn ||
        _isCheckingOut ||
        _isLoading) {
      return false;
    }

    _setCheckingIn(true);
    _clearError();

    try {
      // -------------------------------------------------------------
      // Validate employee.
      // -------------------------------------------------------------

      final employeeId =
      attendance.employeeId?.trim();

      if (employeeId == null ||
          employeeId.isEmpty) {
        throw Exception(
          'Employee ID is required.',
        );
      }

      _employeeId =
          employeeId;

      // -------------------------------------------------------------
      // Attendance shift.
      // -------------------------------------------------------------

      final attendanceShiftId =
      attendance.shiftId?.trim();

      if (attendanceShiftId != null &&
          attendanceShiftId.isNotEmpty) {
        _shiftId =
            attendanceShiftId;
      }

      await _loadShift();

      // -------------------------------------------------------------
      // Duplicate protection.
      // -------------------------------------------------------------

      final existing =
      await _repository.getTodayAttendance(
        employeeId,
      );

      if (existing != null) {
        _todayAttendance =
            existing;

        final existingShiftId =
        existing.shiftId?.trim();

        if (existingShiftId != null &&
            existingShiftId.isNotEmpty) {
          _shiftId =
              existingShiftId;
        }

        await _loadShift();

        _updateLiveWorkTime();

        _syncWorkTimer();

        throw Exception(
          'You have already checked in today.',
        );
      }

      // -------------------------------------------------------------
      // Perform check-in.
      // -------------------------------------------------------------

      final success =
      await _attendanceService.checkIn(
        attendance: attendance,
      );

      if (!success) {
        throw Exception(
          'Check-in failed.',
        );
      }

      // -------------------------------------------------------------
      // IMPORTANT:
      // Reload database record after successful check-in.
      // This guarantees the provider uses the exact timestamp
      // persisted by Supabase.
      // -------------------------------------------------------------

      _todayAttendance =
      await _repository.getTodayAttendance(
        employeeId,
      );

      if (_todayAttendance == null) {
        throw Exception(
          'Check-in was completed but attendance record '
              'could not be loaded.',
        );
      }

      // -------------------------------------------------------------
      // Saved shift.
      // -------------------------------------------------------------

      final savedShiftId =
      _todayAttendance!
          .shiftId
          ?.trim();

      if (savedShiftId != null &&
          savedShiftId.isNotEmpty) {
        _shiftId =
            savedShiftId;
      }

      await _loadShift();

      // -------------------------------------------------------------
      // Reset live timer calculation from persisted check-in.
      // -------------------------------------------------------------

      _updateLiveWorkTime();

      _syncWorkTimer();

      notifyListeners();

      return true;
    } catch (e, stackTrace) {
      debugPrint(
        'MobileAttendanceProvider.checkIn error: $e',
      );

      debugPrint(
        'StackTrace: $stackTrace',
      );

      _setError(
        _cleanErrorMessage(e),
      );

      return false;
    } finally {
      _setCheckingIn(false);
    }
  }

  //=================================================================
  // CHECK OUT
  //=================================================================

  Future<bool> checkOut({
    String? employeeId,
  }) async {
    if (_isCheckingIn ||
        _isCheckingOut ||
        _isLoading) {
      return false;
    }

    _setCheckingOut(true);
    _clearError();

    try {
      String? resolvedEmployeeId =
      employeeId?.trim();

      // -------------------------------------------------------------
      // Cached employee.
      // -------------------------------------------------------------

      if (resolvedEmployeeId == null ||
          resolvedEmployeeId.isEmpty) {
        resolvedEmployeeId =
            _employeeId;
      }

      // -------------------------------------------------------------
      // Current employee fallback.
      // -------------------------------------------------------------

      if (resolvedEmployeeId == null ||
          resolvedEmployeeId.trim().isEmpty) {
        final employee =
        await _employeeRepository.currentEmployee();

        resolvedEmployeeId =
            employee?.id;

        if (_shiftId == null ||
            _shiftId!.trim().isEmpty) {
          final employeeShiftId =
          employee?.shiftId?.trim();

          if (employeeShiftId != null &&
              employeeShiftId.isNotEmpty) {
            _shiftId =
                employeeShiftId;
          }
        }
      }

      // -------------------------------------------------------------
      // Validate employee.
      // -------------------------------------------------------------

      if (resolvedEmployeeId == null ||
          resolvedEmployeeId.trim().isEmpty) {
        throw Exception(
          'Current employee not found.',
        );
      }

      _employeeId =
          resolvedEmployeeId.trim();

      // -------------------------------------------------------------
      // Always load latest attendance.
      // -------------------------------------------------------------

      final attendance =
      await _repository.getTodayAttendance(
        _employeeId!,
      );

      if (attendance == null) {
        _todayAttendance = null;

        _stopWorkTimer();

        throw Exception(
          'Today attendance not found.',
        );
      }

      _todayAttendance =
          attendance;

      // -------------------------------------------------------------
      // Attendance shift.
      // -------------------------------------------------------------

      final attendanceShiftId =
      attendance.shiftId?.trim();

      if (attendanceShiftId != null &&
          attendanceShiftId.isNotEmpty) {
        _shiftId =
            attendanceShiftId;
      }

      await _loadShift();

      // -------------------------------------------------------------
      // Check-in validation.
      // -------------------------------------------------------------

      if (attendance.checkInTime == null) {
        throw Exception(
          'You must check in before checking out.',
        );
      }

      // -------------------------------------------------------------
      // Duplicate checkout.
      // -------------------------------------------------------------

      if (attendance.checkOutTime != null) {
        _updateLiveWorkTime();

        _stopWorkTimer();

        throw Exception(
          'You have already checked out today.',
        );
      }

      // -------------------------------------------------------------
      // Perform checkout.
      // -------------------------------------------------------------

      final success =
      await _attendanceService.checkOut(
        employeeId: _employeeId!,
      );

      if (!success) {
        throw Exception(
          'Check-out failed.',
        );
      }

      // -------------------------------------------------------------
      // Reload final database attendance.
      // -------------------------------------------------------------

      _todayAttendance =
      await _repository.getTodayAttendance(
        _employeeId!,
      );

      if (_todayAttendance == null) {
        throw Exception(
          'Check-out was completed but attendance record '
              'could not be loaded.',
        );
      }

      // -------------------------------------------------------------
      // Saved shift.
      // -------------------------------------------------------------

      final savedShiftId =
      _todayAttendance!
          .shiftId
          ?.trim();

      if (savedShiftId != null &&
          savedShiftId.isNotEmpty) {
        _shiftId =
            savedShiftId;
      }

      await _loadShift();

      // -------------------------------------------------------------
      // Final work calculation.
      //
      // This is calculated from:
      //
      // checkOutTime - checkInTime
      //
      // and NOT from database work_minutes.
      // -------------------------------------------------------------

      _updateLiveWorkTime();

      // -------------------------------------------------------------
      // Stop live timer.
      // -------------------------------------------------------------

      _stopWorkTimer();

      notifyListeners();

      return true;
    } catch (e, stackTrace) {
      debugPrint(
        'MobileAttendanceProvider.checkOut error: $e',
      );

      debugPrint(
        'StackTrace: $stackTrace',
      );

      _setError(
        _cleanErrorMessage(e),
      );

      return false;
    } finally {
      _setCheckingOut(false);
    }
  }

  //=================================================================
  // LIVE WORK TIMER
  //=================================================================

  void _syncWorkTimer() {
    if (isCheckedIn) {
      _startWorkTimer();
    } else {
      _stopWorkTimer();
    }
  }

  void _startWorkTimer() {
    if (_workTimer != null) {
      return;
    }

    _updateLiveWorkTime();

    _workTimer = Timer.periodic(
      const Duration(seconds: 10),
          (_) {
        if (!isCheckedIn) {
          _stopWorkTimer();
          return;
        }

        _updateLiveWorkTime();

        notifyListeners();
      },
    );
  }

  void _stopWorkTimer() {
    _workTimer?.cancel();
    _workTimer = null;
  }

  //=================================================================
  // UPDATE LIVE WORK TIME
  //=================================================================

  void _updateLiveWorkTime() {
    final attendance =
        _todayAttendance;

    final checkIn =
        attendance?.checkInTime;

    if (checkIn == null) {
      _liveWorkMinutes = 0;
      return;
    }

    final endTime =
        attendance?.checkOutTime ??
            DateTime.now();

    final duration =
    endTime.difference(checkIn);

    if (duration.isNegative) {
      _liveWorkMinutes = 0;
      return;
    }

    _liveWorkMinutes =
        duration.inMinutes;
  }

  //=================================================================
  // CALCULATE SHIFT DURATION
  //=================================================================

  int _calculateShiftDurationMinutes(
      String? startTime,
      String? endTime,
      bool nightShift,
      ) {
    if (startTime == null ||
        endTime == null) {
      return 0;
    }

    final start =
    _parseTimeToMinutes(
      startTime,
    );

    final end =
    _parseTimeToMinutes(
      endTime,
    );

    if (start == null ||
        end == null) {
      return 0;
    }

    // -------------------------------------------------------------
    // Normal same-day shift.
    // -------------------------------------------------------------

    if (end > start) {
      return end - start;
    }

    // -------------------------------------------------------------
    // Overnight / night shift.
    //
    // Example:
    // 22:00 -> 06:00
    // = 480 minutes
    // -------------------------------------------------------------

    if (end < start) {
      return (24 * 60 - start) + end;
    }

    // -------------------------------------------------------------
    // Same start/end.
    // -------------------------------------------------------------

    if (end == start &&
        nightShift) {
      return 24 * 60;
    }

    return 0;
  }

  //=================================================================
  // PARSE SHIFT TIME
  //=================================================================

  int? _parseTimeToMinutes(
      String value,
      ) {
    final normalized =
    value.trim().toUpperCase();

    if (normalized.isEmpty) {
      return null;
    }

    // -------------------------------------------------------------
    // 24-hour format
    //
    // 09:00
    // 17:30
    // -------------------------------------------------------------

    final twentyFourHour =
    RegExp(
      r'^(\d{1,2}):(\d{2})$',
    ).firstMatch(
      normalized,
    );

    if (twentyFourHour != null) {
      final hour =
      int.tryParse(
        twentyFourHour.group(1)!,
      );

      final minute =
      int.tryParse(
        twentyFourHour.group(2)!,
      );

      if (hour == null ||
          minute == null) {
        return null;
      }

      if (hour < 0 ||
          hour > 23 ||
          minute < 0 ||
          minute > 59) {
        return null;
      }

      return hour * 60 + minute;
    }

    // -------------------------------------------------------------
    // 12-hour format
    //
    // 09:00 AM
    // 05:30 PM
    // -------------------------------------------------------------

    final twelveHour =
    RegExp(
      r'^(\d{1,2}):(\d{2})\s*(AM|PM)$',
    ).firstMatch(
      normalized,
    );

    if (twelveHour != null) {
      int? hour =
      int.tryParse(
        twelveHour.group(1)!,
      );

      final minute =
      int.tryParse(
        twelveHour.group(2)!,
      );

      final period =
      twelveHour.group(3);

      if (hour == null ||
          minute == null ||
          period == null) {
        return null;
      }

      if (hour < 1 ||
          hour > 12 ||
          minute < 0 ||
          minute > 59) {
        return null;
      }

      if (period == 'AM') {
        if (hour == 12) {
          hour = 0;
        }
      } else {
        if (hour != 12) {
          hour += 12;
        }
      }

      return hour * 60 + minute;
    }

    return null;
  }

  //=================================================================
  // RESET ATTENDANCE STATE
  //=================================================================

  void _resetAttendanceState() {
    _todayAttendance = null;

    _shift = null;

    _shiftId = null;

    _liveWorkMinutes = 0;

    _stopWorkTimer();

    notifyListeners();
  }

  //=================================================================
  // ERROR
  //=================================================================

  void clearError() {
    _clearError();
  }

  void _setLoading(
      bool value,
      ) {
    if (_isLoading == value) {
      return;
    }

    _isLoading = value;

    notifyListeners();
  }

  void _setCheckingIn(
      bool value,
      ) {
    if (_isCheckingIn == value) {
      return;
    }

    _isCheckingIn = value;

    notifyListeners();
  }

  void _setCheckingOut(
      bool value,
      ) {
    if (_isCheckingOut == value) {
      return;
    }

    _isCheckingOut = value;

    notifyListeners();
  }

  void _setError(
      String message,
      ) {
    _error = message;

    notifyListeners();
  }

  void _clearError() {
    if (_error == null) {
      return;
    }

    _error = null;

    notifyListeners();
  }

  //=================================================================
  // ERROR CLEANER
  //=================================================================

  String _cleanErrorMessage(
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

  //=================================================================
  // FORMAT MINUTES
  //=================================================================

  String _formatMinutes(
      int minutes,
      ) {
    if (minutes <= 0) {
      return '0m';
    }

    final hours =
        minutes ~/ 60;

    final remainingMinutes =
        minutes % 60;

    if (hours == 0) {
      return '${remainingMinutes}m';
    }

    if (remainingMinutes == 0) {
      return '${hours}h';
    }

    return '${hours}h ${remainingMinutes}m';
  }

  //=================================================================
  // DISPOSE
  //=================================================================

  @override
  void dispose() {
    _stopWorkTimer();

    _todayAttendance = null;

    _shift = null;

    _shiftId = null;

    _employeeId = null;

    _error = null;

    _liveWorkMinutes = 0;

    super.dispose();
  }
}

//=================================================================
// RIVERPOD PROVIDER
//=================================================================

final mobileAttendanceProvider =
ChangeNotifierProvider<MobileAttendanceProvider>(
      (ref) {
    final shiftRepository =
    ShiftRepositoryImpl(ref);

    return MobileAttendanceProvider(
      shiftService: shiftRepository,
    );
  },
);