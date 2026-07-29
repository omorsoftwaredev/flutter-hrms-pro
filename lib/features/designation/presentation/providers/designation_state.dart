import '../../domain/entities/designation_entity.dart';

class DesignationState {
  const DesignationState({
    this.designations = const [],
    this.filteredDesignations = const [],
    this.selectedDesignation,
    this.isLoading = false,
    this.isSaving = false,
    this.search = '',
    this.error,
  });

  final List<DesignationEntity> designations;
  final List<DesignationEntity> filteredDesignations;

  final DesignationEntity? selectedDesignation;

  final bool isLoading;
  final bool isSaving;

  final String search;
  final String? error;

  DesignationState copyWith({
    List<DesignationEntity>? designations,
    List<DesignationEntity>? filteredDesignations,
    DesignationEntity? selectedDesignation,
    bool? isLoading,
    bool? isSaving,
    String? search,
    String? error,
  }) {
    return DesignationState(
      designations:
      designations ?? this.designations,
      filteredDesignations:
      filteredDesignations ??
          this.filteredDesignations,
      selectedDesignation:
      selectedDesignation,
      isLoading:
      isLoading ?? this.isLoading,
      isSaving:
      isSaving ?? this.isSaving,
      search: search ?? this.search,
      error: error,
    );
  }
}