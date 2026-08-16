// ===============================================================
// Flutter HRMS Pro
// Company Account Repository Impl
//
// Version : 2.1.0
//
// Database:
// company_accounts.password_hash
// ===============================================================

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/helpers/database_error_helper.dart';
import '../../domain/entities/company_account_entity.dart';
import '../../domain/repositories/company_account_repository.dart';
import '../models/company_account_model.dart';

class CompanyAccountRepositoryImpl
    implements CompanyAccountRepository {
  CompanyAccountRepositoryImpl();

  final SupabaseClient _client =
      Supabase.instance.client;

  static const String _table =
      'company_accounts';

  //==============================================================
  // Get All
  //==============================================================

  @override
  Future<List<CompanyAccountEntity>>
  getAccounts() async {
    try {
      final response = await _client
          .from(_table)
          .select('''
            *,
            companies (
              name
            )
          ''')
          .order(
        'created_at',
        ascending: false,
      );

      return (response as List)
          .map(
            (e) =>
            CompanyAccountModel.fromJson(
              e as Map<String, dynamic>,
            ),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  //==============================================================
  // Get By Id
  //==============================================================

  @override
  Future<CompanyAccountEntity>
  getAccountById(
      String id,
      ) async {
    try {
      final response = await _client
          .from(_table)
          .select('''
            *,
            companies (
              name
            )
          ''')
          .eq('id', id)
          .single();

      return CompanyAccountModel.fromJson(
        response,
      );
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  //==============================================================
  // Create
  //==============================================================

  @override
  Future<void> createAccount(
      CompanyAccountEntity account,
      ) async {
    try {
      final response = await _client
          .from(_table)
          .insert({
        'company_id':
        account.companyId,

        'username':
        account.username,

        // IMPORTANT
        // Database column:
        // password_hash
        'password_hash':
        account.passwordHash,

        'is_active':
        account.isActive,

        'must_change_password':
        account.mustChangePassword,

        'created_by':
        account.createdBy,
      })
          .select()
          .single();

      print(
        'Created Account : $response',
      );
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //==============================================================
  // Update
  //==============================================================

  @override
  Future<void> updateAccount(
      CompanyAccountEntity account,
      ) async {
    if (account.id == null) {
      throw Exception(
        'Account ID is missing.',
      );
    }

    try {
      await _client
          .from(_table)
          .update({
        'company_id':
        account.companyId,

        'username':
        account.username,

        // IMPORTANT
        // Database column:
        // password_hash
        'password_hash':
        account.passwordHash,

        'is_active':
        account.isActive,

        'must_change_password':
        account.mustChangePassword,

        'updated_at':
        DateTime.now()
            .toIso8601String(),

        'updated_by':
        account.updatedBy,
      })
          .eq(
        'id',
        account.id!,
      );
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  //==============================================================
  // Active / Inactive
  //==============================================================

  @override
  Future<void> updateAccountStatus({
    required String id,
    required bool isActive,
  }) async {
    try {
      await _client
          .from(_table)
          .update({
        'is_active':
        isActive,

        'updated_at':
        DateTime.now()
            .toIso8601String(),
      })
          .eq(
        'id',
        id,
      );
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }

  //==============================================================
  // Delete
  //==============================================================

  @override
  Future<void> deleteAccount(
      String id,
      ) async {
    try {
      await _client
          .from(_table)
          .delete()
          .eq(
        'id',
        id,
      );
    } on PostgrestException catch (e) {
      throw Exception(
        DatabaseErrorHelper.getMessage(e),
      );
    }
  }
}