import '../../domain/entities/shift_entity.dart';

class ShiftState {
  const ShiftState({
    this.shifts = const [],
    this.filteredShifts = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  final List<ShiftEntity> shifts;

  final List<ShiftEntity>
  filteredShifts;

  final bool isLoading;

  final bool isSaving;

  final String? error;

  ShiftState copyWith({
    List<ShiftEntity>? shifts,
    List<ShiftEntity>? filteredShifts,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return ShiftState(
      shifts: shifts ?? this.shifts,
      filteredShifts:
      filteredShifts ??
          this.filteredShifts,
      isLoading:
      isLoading ?? this.isLoading,
      isSaving:
      isSaving ?? this.isSaving,
      error: error,
    );
  }
}