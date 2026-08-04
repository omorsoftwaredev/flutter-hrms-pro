import '../../domain/entities/shift_entity.dart';

class ShiftState {
  const ShiftState({
    this.shifts = const [],
    this.filteredShifts = const [],
    this.selectedShift,
    this.search = '',
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  final List<ShiftEntity> shifts;

  final List<ShiftEntity> filteredShifts;

  final ShiftEntity? selectedShift;

  final String search;

  final bool isLoading;

  final bool isSaving;

  final String? error;

  ShiftState copyWith({
    List<ShiftEntity>? shifts,
    List<ShiftEntity>? filteredShifts,
    ShiftEntity? selectedShift,
    String? search,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return ShiftState(
      shifts: shifts ?? this.shifts,
      filteredShifts:
      filteredShifts ?? this.filteredShifts,
      selectedShift:
      selectedShift ?? this.selectedShift,
      search: search ?? this.search,
      isLoading:
      isLoading ?? this.isLoading,
      isSaving:
      isSaving ?? this.isSaving,
      error: error ?? this.error,
    );
  }
}