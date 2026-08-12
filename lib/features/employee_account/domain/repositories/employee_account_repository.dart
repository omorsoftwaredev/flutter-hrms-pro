import '../entities/employee_account_entity.dart';

abstract class EmployeeAccountRepository {
  // =============================================================
  // GET ALL ACCOUNTS
  // =============================================================

  Future<List<EmployeeAccountEntity>> getAccounts();

  // =============================================================
  // GET ACCOUNT BY ID
  // =============================================================

  Future<EmployeeAccountEntity> getAccountById(
      String id,
      );

  // =============================================================
  // CREATE ACCOUNT
  // =============================================================

  Future<void> createAccount(
      EmployeeAccountEntity account,
      );

  // =============================================================
  // UPDATE ACCOUNT
  // =============================================================

  Future<void> updateAccount(
      EmployeeAccountEntity account,
      );

  // =============================================================
  // DELETE ACCOUNT
  // =============================================================

  Future<void> deleteAccount(
      String id,
      );

  // =============================================================
  // UPDATE ACCOUNT STATUS
  // =============================================================

  Future<void> updateAccountStatus({
    required String id,
    required bool isActive,
  });
}