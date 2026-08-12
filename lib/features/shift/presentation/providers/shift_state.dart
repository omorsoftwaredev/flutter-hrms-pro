import '../../domain/entities/shift_entity.dart';

class ShiftState {
  const ShiftState({
    this.shifts = const [],
    this.filteredShifts = const [],
    this.selectedShift,
    this.isLoading = false,
    this.isSaving = false,
    this.search = '',
    this.error,
  });

  final List<ShiftEntity> shifts;

  final List<ShiftEntity>
  filteredShifts;

  final ShiftEntity?
  selectedShift;

  final bool isLoading;
  final bool isSaving;

  final String search;

  final String? error;

  ShiftState copyWith({
    List<ShiftEntity>? shifts,
    List<ShiftEntity>?
    filteredShifts,
    ShiftEntity?
    selectedShift,
    bool? isLoading,
    bool? isSaving,
    String? search,
    String? error,
  }) {
    return ShiftState(
      shifts:
      shifts ?? this.shifts,

      filteredShifts:
      filteredShifts ??
          this.filteredShifts,

      selectedShift:
      selectedShift ??
          this.selectedShift,

      isLoading:
      isLoading ?? this.isLoading,

      isSaving:
      isSaving ?? this.isSaving,

      search:
      search ?? this.search,

      error:
      error,
    );
  }
}