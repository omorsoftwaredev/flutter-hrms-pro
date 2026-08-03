// lib/features/company_account/domain/repositories/company_account_repository.dart

import '../entities/company_account_entity.dart';

abstract class CompanyAccountRepository {
  Future<List<CompanyAccountEntity>> getAccounts();

  Future<CompanyAccountEntity> getAccountById(
      String id,
      );

  Future<void> createAccount(
      CompanyAccountEntity account,
      );

  Future<void> updateAccount(
      CompanyAccountEntity account,
      );

  Future<void> updateAccountStatus({
    required String id,
    required bool isActive,
  });

  Future<void> deleteAccount(
      String id,
      );
}