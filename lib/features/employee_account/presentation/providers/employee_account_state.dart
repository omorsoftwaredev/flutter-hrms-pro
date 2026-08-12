import '../../domain/entities/employee_account_entity.dart';

class EmployeeAccountState {
  const EmployeeAccountState({
    this.accounts = const [],
    this.filteredAccounts = const [],
    this.selectedAccount,
    this.isLoading = false,
    this.isSaving = false,
    this.search = '',
    this.error,
  });

  final List<EmployeeAccountEntity> accounts;

  final List<EmployeeAccountEntity> filteredAccounts;

  final EmployeeAccountEntity? selectedAccount;

  final bool isLoading;

  final bool isSaving;

  final String search;

  final String? error;

  EmployeeAccountState copyWith({
    List<EmployeeAccountEntity>? accounts,
    List<EmployeeAccountEntity>? filteredAccounts,
    EmployeeAccountEntity? selectedAccount,
    bool? isLoading,
    bool? isSaving,
    String? search,
    String? error,
  }) {
    return EmployeeAccountState(
      accounts: accounts ?? this.accounts,
      filteredAccounts:
      filteredAccounts ?? this.filteredAccounts,
      selectedAccount:
      selectedAccount ?? this.selectedAccount,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      search: search ?? this.search,
      error: error,
    );
  }

  factory EmployeeAccountState.initial() {
    return const EmployeeAccountState();
  }
}