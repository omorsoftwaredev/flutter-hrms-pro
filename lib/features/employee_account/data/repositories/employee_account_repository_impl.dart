import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/employee_account_entity.dart';
import '../../domain/repositories/employee_account_repository.dart';
import '../models/employee_account_model.dart';

class EmployeeAccountRepositoryImpl
    implements EmployeeAccountRepository {
  EmployeeAccountRepositoryImpl();

  final SupabaseClient _client = Supabase.instance.client;

  //==============================================================
  // Get All Accounts
  //==============================================================

  @override
  Future<List<EmployeeAccountEntity>> getAccounts() async {
    final response = await _client
        .from('employee_accounts')
        .select('''
          *,
          employees (
            full_name
          ),
          departments (
            name
          ),
          companies (
            name
          )
        ''')
        .order(
      'username',
      ascending: true,
    );

    return (response as List)
        .map(
          (e) => EmployeeAccountModel.fromJson(
        e as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  //==============================================================
  // Get Account By Id
  //==============================================================

  @override
  Future<EmployeeAccountEntity> getAccountById(
      String id,
      ) async {
    final response = await _client
        .from('employee_accounts')
        .select('''
          *,
          employees (
            full_name
          ),
          departments (
            name
          ),
          companies (
            name
          )
        ''')
        .eq('id', id)
        .single();

    return EmployeeAccountModel.fromJson(response);
  }

  //==============================================================
  // Create Account
  //==============================================================

  @override
  Future<void> createAccount(
      EmployeeAccountEntity account,
      ) async {
    await _client.from('employee_accounts').insert({
      'company_id': account.companyId,
      'department_id': account.departmentId,
      'employee_id': account.employeeId,

      'username': account.username,
      'password_hash': account.passwordHash,

      'can_login': account.canLogin,
      'is_active': account.isActive,
      'is_locked': account.isLocked,

      'failed_login_attempts': account.failedLoginAttempts,

      'force_change_password': account.forceChangePassword,

      'password_expire_at':
      account.passwordExpireAt?.toIso8601String(),

      'created_by': account.createdBy,
      'updated_by': account.updatedBy,
    });
  }

  //==============================================================
  // Update Account
  //==============================================================

  @override
  Future<void> updateAccount(
      EmployeeAccountEntity account,
      ) async {
    await _client
        .from('employee_accounts')
        .update({
      'company_id': account.companyId,
      'department_id': account.departmentId,
      'employee_id': account.employeeId,

      'username': account.username,
      'password_hash': account.passwordHash,

      'can_login': account.canLogin,
      'is_active': account.isActive,
      'is_locked': account.isLocked,

      'failed_login_attempts':
      account.failedLoginAttempts,

      'last_login_at':
      account.lastLoginAt?.toIso8601String(),

      'last_login_ip':
      account.lastLoginIp,

      'password_changed_at':
      account.passwordChangedAt
          ?.toIso8601String(),

      'password_reset_token':
      account.passwordResetToken,

      'password_reset_expire_at':
      account.passwordResetExpireAt
          ?.toIso8601String(),

      'force_change_password':
      account.forceChangePassword,

      'password_expire_at':
      account.passwordExpireAt
          ?.toIso8601String(),

      'account_locked_at':
      account.accountLockedAt
          ?.toIso8601String(),

      'updated_by': account.updatedBy,
      'updated_at':
      DateTime.now().toIso8601String(),
    })
        .eq('id', account.id);
  }

  //==============================================================
  // Delete Account
  //==============================================================

  @override
  Future<void> deleteAccount(
      String id,
      ) async {
    await _client
        .from('employee_accounts')
        .delete()
        .eq('id', id);
  }
}