import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../../domain/entities/employee_account_entity.dart';
import '../../domain/repositories/employee_account_repository.dart';
import '../models/employee_account_model.dart';

class EmployeeAccountRepositoryImpl implements EmployeeAccountRepository {
  EmployeeAccountRepositoryImpl(this._ref);

  final Ref _ref;

  final SupabaseClient _client = Supabase.instance.client;

  // =============================================================
  // CURRENT USER ID
  // =============================================================

  String get _currentUserId {
    final user = _ref.read(currentUserProvider);

    if (user == null) {
      throw Exception('Current user information is not available.');
    }

    final userId = user.userId.trim();

    if (userId.isEmpty) {
      throw Exception('Current user ID is not available.');
    }

    return userId;
  }

  @override
  Future<void> updateAccountStatus({
    required String id,
    required bool isActive,
  }) async {
    try {
      await _client
          .from('employee_accounts')
          .update({
            'is_active': isActive,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to update employee account status: $e');
    }
  }

  // =============================================================
  // CURRENT COMPANY ID
  // =============================================================

  String get _currentCompanyId {
    final user = _ref.read(currentUserProvider);

    if (user == null) {
      throw Exception('Current user information is not available.');
    }

    final companyId = user.companyId.trim();

    if (companyId.isEmpty) {
      throw Exception('Company information is not available for this account.');
    }

    return companyId;
  }

  // =============================================================
  // RELATION SELECT
  // =============================================================

  String get _accountSelect => '''
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
  ''';

  // =============================================================
  // GET ALL ACCOUNTS
  // =============================================================
  //
  // শুধু CurrentUser.companyId-এর employee accounts আসবে।
  //
  // =============================================================

  @override
  Future<List<EmployeeAccountEntity>> getAccounts() async {
    try {
      final companyId = _currentCompanyId;

      debugPrint('Employee Account List Company ID => $companyId');

      final response = await _client
          .from('employee_accounts')
          .select(_accountSelect)
          .eq('company_id', companyId)
          .order('username', ascending: true);

      final accounts = (response as List)
          .map(
            (json) =>
                EmployeeAccountModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      debugPrint(
        'Employee Account List Count => '
        '${accounts.length}',
      );

      return accounts;
    } on PostgrestException catch (e) {
      debugPrint(
        'Get Employee Accounts Postgrest Error: '
        '${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint('Get Employee Accounts Error: $e');

      rethrow;
    }
  }

  // =============================================================
  // GET ACCOUNT BY ID
  // =============================================================
  //
  // ID + CurrentUser.companyId
  //
  // অন্য company-এর account access করা যাবে না।
  //
  // =============================================================

  @override
  Future<EmployeeAccountEntity> getAccountById(String id) async {
    try {
      final companyId = _currentCompanyId;

      final accountId = id.trim();

      if (accountId.isEmpty) {
        throw Exception('Employee account ID is required.');
      }

      final response = await _client
          .from('employee_accounts')
          .select(_accountSelect)
          .eq('id', accountId)
          .eq('company_id', companyId)
          .single();

      return EmployeeAccountModel.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      debugPrint(
        'Get Employee Account Postgrest Error: '
        '${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint('Get Employee Account Error: $e');

      rethrow;
    }
  }

  // =============================================================
  // CREATE ACCOUNT
  // =============================================================
  //
  // company_id:
  //   CurrentUser.companyId
  //
  // created_by:
  //   CurrentUser.userId
  //
  // updated_by:
  //   CurrentUser.userId
  //
  // Form/entity থেকে এগুলোর উপর নির্ভর করা হচ্ছে না।
  //
  // =============================================================

  @override
  Future<void> createAccount(EmployeeAccountEntity account) async {
    try {
      final companyId = _currentCompanyId;
      final userId = _currentUserId;

      final employeeId = account.employeeId.trim();

      if (employeeId.isEmpty) {
        throw Exception('Employee ID is required.');
      }

      final username = account.username.trim();

      if (username.isEmpty) {
        throw Exception('Username is required.');
      }

      debugPrint('CREATE EMPLOYEE ACCOUNT');

      debugPrint('Company ID => $companyId');

      debugPrint('Employee ID => $employeeId');

      debugPrint('Username => $username');

      debugPrint('Created By => $userId');

      await _client.from('employee_accounts').insert({
        // -------------------------------------------------------
        // COMPANY
        // -------------------------------------------------------
        'company_id': companyId,

        // -------------------------------------------------------
        // RELATIONS
        // -------------------------------------------------------
        'department_id': account.departmentId,

        'employee_id': employeeId,

        // -------------------------------------------------------
        // ACCOUNT
        // -------------------------------------------------------
        'username': username,

        'password_hash': account.passwordHash,

        'can_login': account.canLogin,

        'is_active': account.isActive,

        'is_locked': account.isLocked,

        'failed_login_attempts': account.failedLoginAttempts,

        // -------------------------------------------------------
        // PASSWORD
        // -------------------------------------------------------
        'force_change_password': account.forceChangePassword,

        'password_expire_at': account.passwordExpireAt?.toIso8601String(),

        // -------------------------------------------------------
        // AUDIT
        // -------------------------------------------------------
        'created_by': userId,
      });

      debugPrint('Employee Account Created Successfully.');
    } on PostgrestException catch (e) {
      debugPrint(
        'Create Employee Account Postgrest Error: '
        '${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint('Create Employee Account Error: $e');

      rethrow;
    }
  }

  // =============================================================
  // UPDATE ACCOUNT
  // =============================================================
  //
  // Update শুধুমাত্র current company-এর account-এ হবে।
  //
  // updated_by:
  //   CurrentUser.userId
  //
  // created_by কখনো update করা হচ্ছে না।
  //
  // =============================================================

  @override
  Future<void> updateAccount(EmployeeAccountEntity account) async {
    try {
      final companyId = _currentCompanyId;
      final userId = _currentUserId;

      final accountId = account.id.trim();

      if (accountId.isEmpty) {
        throw Exception('Employee account ID is required for update.');
      }

      final employeeId = account.employeeId.trim();

      if (employeeId.isEmpty) {
        throw Exception('Employee ID is required.');
      }

      debugPrint('UPDATE EMPLOYEE ACCOUNT');

      debugPrint('Account ID => $accountId');

      debugPrint('Company ID => $companyId');

      debugPrint('Employee ID => $employeeId');

      debugPrint('Updated By => $userId');

      final response = await _client
          .from('employee_accounts')
          .update({
            // -------------------------------------------------------
            // RELATIONS
            // -------------------------------------------------------
            'department_id': account.departmentId,

            'employee_id': employeeId,

            // -------------------------------------------------------
            // ACCOUNT
            // -------------------------------------------------------
            'username': account.username.trim(),

            'password_hash': account.passwordHash,

            'can_login': account.canLogin,

            'is_active': account.isActive,

            'is_locked': account.isLocked,

            'failed_login_attempts': account.failedLoginAttempts,

            // -------------------------------------------------------
            // LOGIN
            // -------------------------------------------------------
            'last_login_at': account.lastLoginAt?.toIso8601String(),

            'last_login_ip': account.lastLoginIp,

            // -------------------------------------------------------
            // PASSWORD
            // -------------------------------------------------------
            'password_changed_at': account.passwordChangedAt?.toIso8601String(),

            'password_reset_token': account.passwordResetToken,

            'password_reset_expire_at': account.passwordResetExpireAt
                ?.toIso8601String(),

            'force_change_password': account.forceChangePassword,

            'password_expire_at': account.passwordExpireAt?.toIso8601String(),

            'account_locked_at': account.accountLockedAt?.toIso8601String(),

            // -------------------------------------------------------
            // AUDIT
            // -------------------------------------------------------
            'updated_by': userId,

            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', accountId)
          .eq('company_id', companyId)
          .select();

      if ((response as List).isEmpty) {
        throw Exception(
          'Employee account not found or does not belong '
          'to the current company.',
        );
      }

      debugPrint('Employee Account Updated Successfully.');
    } on PostgrestException catch (e) {
      debugPrint(
        'Update Employee Account Postgrest Error: '
        '${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint('Update Employee Account Error: $e');

      rethrow;
    }
  }

  // =============================================================
  // DELETE ACCOUNT
  // =============================================================
  //
  // শুধু current company-এর account delete হবে।
  //
  // =============================================================

  @override
  Future<void> deleteAccount(String id) async {
    try {
      final companyId = _currentCompanyId;

      final accountId = id.trim();

      if (accountId.isEmpty) {
        throw Exception('Employee account ID is required.');
      }

      debugPrint('DELETE EMPLOYEE ACCOUNT');

      debugPrint('Account ID => $accountId');

      debugPrint('Company ID => $companyId');

      final response = await _client
          .from('employee_accounts')
          .delete()
          .eq('id', accountId)
          .eq('company_id', companyId)
          .select();

      if ((response as List).isEmpty) {
        throw Exception(
          'Employee account not found or does not belong '
          'to the current company.',
        );
      }

      debugPrint('Employee Account Deleted => $accountId');
    } on PostgrestException catch (e) {
      debugPrint(
        'Delete Employee Account Postgrest Error: '
        '${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint('Delete Employee Account Error: $e');

      rethrow;
    }
  }
}
