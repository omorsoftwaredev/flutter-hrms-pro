import '../../domain/entities/company_entity.dart';

class CompanyState {
  const CompanyState({
    this.companies = const [],
    this.filteredCompanies = const [],
    this.selectedCompany,
    this.isLoading = false,
    this.isSaving = false,
    this.search = '',
    this.error,
  });

  final List<CompanyEntity> companies;
  final List<CompanyEntity> filteredCompanies;

  final CompanyEntity? selectedCompany;

  final bool isLoading;
  final bool isSaving;

  final String search;

  final String? error;

  CompanyState copyWith({
    List<CompanyEntity>? companies,
    List<CompanyEntity>? filteredCompanies,
    CompanyEntity? selectedCompany,
    bool? isLoading,
    bool? isSaving,
    String? search,
    String? error,
  }) {
    return CompanyState(
      companies: companies ?? this.companies,
      filteredCompanies:
      filteredCompanies ?? this.filteredCompanies,
      selectedCompany:
      selectedCompany ?? this.selectedCompany,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      search: search ?? this.search,
      error: error,
    );
  }
}