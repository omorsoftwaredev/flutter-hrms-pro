import '../entities/employee_account_entity.dart';

abstract class EmployeeAccountRepository {
  /// Get All Employee Accounts
  Future<List<EmployeeAccountEntity>> getAccounts();

  /// Get Employee Account By Id
  Future<EmployeeAccountEntity> getAccountById(
      String id,
      );

  /// Create Employee Account
  Future<void> createAccount(
      EmployeeAccountEntity account,
      );

  /// Update Employee Account
  Future<void> updateAccount(
      EmployeeAccountEntity account,
      );

  /// Delete Employee Account
  Future<void> deleteAccount(
      String id,
      );
}