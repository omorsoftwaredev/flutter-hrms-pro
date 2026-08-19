enum AttendanceReportStatus {
  present,
  late,
  earlyOut,
  absent,
  leave,
  dayOff,
  holiday,
}

class AttendanceReportEntity {
  final DateTime date;

  final AttendanceReportStatus status;

  final DateTime? checkInTime;
  final DateTime? checkOutTime;

  final String? checkInAddress;
  final String? checkOutAddress;

  final int lateMinutes;
  final int earlyExitMinutes;
  final int workMinutes;

  final bool isWeekend;
  final bool isHoliday;
  final bool isLeave;

  const AttendanceReportEntity({
    required this.date,
    required this.status,

    this.checkInTime,
    this.checkOutTime,

    this.checkInAddress,
    this.checkOutAddress,

    this.lateMinutes = 0,
    this.earlyExitMinutes = 0,
    this.workMinutes = 0,

    this.isWeekend = false,
    this.isHoliday = false,
    this.isLeave = false,
  });

  // ============================================================
  // STATUS TEXT
  // ============================================================

// ============================================================
// STATUS TEXT
// ============================================================

  String get statusText {
    // Late + Early Out
    if (hasLate && hasEarlyOut) {
      return 'Late Entry • Early Out';
    }

    // Late only
    if (hasLate) {
      return 'Late Entry';
    }

    // Early Out only
    if (hasEarlyOut) {
      return 'Early Out';
    }

    switch (status) {
      case AttendanceReportStatus.present:
        return 'Present';

      case AttendanceReportStatus.late:
        return 'Late Entry';

      case AttendanceReportStatus.earlyOut:
        return 'Early Out';

      case AttendanceReportStatus.absent:
        return 'Absent';

      case AttendanceReportStatus.leave:
        return 'Leave';

      case AttendanceReportStatus.dayOff:
        return 'Day Off';

      case AttendanceReportStatus.holiday:
        return 'Holiday';
    }
  }

  // ============================================================
  // HAS LATE
  // ============================================================

  bool get hasLate {
    return lateMinutes > 0;
  }

  // ============================================================
  // HAS EARLY OUT
  // ============================================================

  bool get hasEarlyOut {
    return earlyExitMinutes > 0;
  }

  // ============================================================
  // HAS CHECK IN
  // ============================================================

  bool get hasCheckIn {
    return checkInTime != null;
  }

  // ============================================================
  // HAS CHECK OUT
  // ============================================================

  bool get hasCheckOut {
    return checkOutTime != null;
  }
}