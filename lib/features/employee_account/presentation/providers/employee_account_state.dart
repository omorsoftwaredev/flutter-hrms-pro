import '../../domain/entities/employee_account_entity.dart';

class EmployeeAccountState {
  final bool isLoading;
  final bool isSaving;

  final List<EmployeeAccountEntity> accounts;
  final List<EmployeeAccountEntity> filteredAccounts;

  final EmployeeAccountEntity? selectedAccount;

  final String search;

  final String? error;

  const EmployeeAccountState({
    this.isLoading = false,
    this.isSaving = false,

    this.accounts = const [],
    this.filteredAccounts = const [],

    this.selectedAccount,

    this.search = '',

    this.error,
  });

  EmployeeAccountState copyWith({
    bool? isLoading,
    bool? isSaving,

    List<EmployeeAccountEntity>? accounts,
    List<EmployeeAccountEntity>? filteredAccounts,

    EmployeeAccountEntity? selectedAccount,

    String? search,

    String? error,
  }) {
    return EmployeeAccountState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,

      accounts: accounts ?? this.accounts,
      filteredAccounts:
      filteredAccounts ?? this.filteredAccounts,

      selectedAccount:
      selectedAccount ?? this.selectedAccount,

      search: search ?? this.search,

      error: error,
    );
  }

  factory EmployeeAccountState.initial() {
    return const EmployeeAccountState(
      isLoading: false,
      isSaving: false,

      accounts: [],
      filteredAccounts: [],

      selectedAccount: null,

      search: '',

      error: null,
    );
  }
}