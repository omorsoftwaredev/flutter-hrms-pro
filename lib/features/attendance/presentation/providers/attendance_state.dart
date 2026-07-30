import '../../domain/entities/attendance_entity.dart';

class AttendanceState {
  final List<AttendanceEntity> attendance;

  final bool isLoading;

  final String? errorMessage;

  final String search;

  final String? statusFilter;

  final AttendanceEntity? selectedAttendance;

  const AttendanceState({
    this.attendance = const [],
    this.isLoading = false,
    this.errorMessage,
    this.search = '',
    this.statusFilter,
    this.selectedAttendance,
  });

  AttendanceState copyWith({
    List<AttendanceEntity>? attendance,
    bool? isLoading,
    String? errorMessage,
    String? search,
    String? statusFilter,
    AttendanceEntity? selectedAttendance,
    bool clearError = false,
    bool clearSelected = false,
  }) {
    return AttendanceState(
      attendance: attendance ?? this.attendance,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError
          ? null
          : (errorMessage ?? this.errorMessage),
      search: search ?? this.search,
      statusFilter: statusFilter ?? this.statusFilter,
      selectedAttendance: clearSelected
          ? null
          : (selectedAttendance ?? this.selectedAttendance),
    );
  }

  @override
  String toString() {
    return '''
AttendanceState(
  attendance: ${attendance.length},
  isLoading: $isLoading,
  search: $search,
  statusFilter: $statusFilter,
  selectedAttendance: ${selectedAttendance?.id},
  errorMessage: $errorMessage,
)
''';
  }
}