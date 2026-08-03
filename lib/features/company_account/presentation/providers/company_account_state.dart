// ===============================================================
// Flutter HRMS Pro
// Company Account State
//
// Version : 1.0.0
// ===============================================================

import '../../domain/entities/company_account_entity.dart';

class CompanyAccountState {
  final bool isLoading;
  final bool isSaving;

  final String search;
  final String? error;

  final List<CompanyAccountEntity> accounts;
  final List<CompanyAccountEntity> filteredAccounts;

  final CompanyAccountEntity? selectedAccount;

  const CompanyAccountState({
    this.isLoading = false,
    this.isSaving = false,
    this.search = '',
    this.error,
    this.accounts = const [],
    this.filteredAccounts = const [],
    this.selectedAccount,
  });

  CompanyAccountState copyWith({
    bool? isLoading,
    bool? isSaving,
    String? search,
    String? error,
    List<CompanyAccountEntity>? accounts,
    List<CompanyAccountEntity>? filteredAccounts,
    CompanyAccountEntity? selectedAccount,
  }) {
    return CompanyAccountState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      search: search ?? this.search,
      error: error,
      accounts: accounts ?? this.accounts,
      filteredAccounts:
      filteredAccounts ?? this.filteredAccounts,
      selectedAccount:
      selectedAccount ?? this.selectedAccount,
    );
  }
}