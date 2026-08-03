// ===============================================================
// Flutter HRMS Pro
// Company Account Repository Impl
//
// Version : 2.0.0
// ===============================================================

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/helpers/database_error_helper.dart';
import '../../domain/entities/company_account_entity.dart';
import '../../domain/repositories/company_account_repository.dart';
import '../models/company_account_model.dart';

class CompanyAccountRepositoryImpl
    implements CompanyAccountRepository {
  CompanyAccountRepositoryImpl();

  final SupabaseClient _client = Supabase.instance.client;

  static const String _table = 'company_accounts';

  //==============================================================
  // Get All
  //==============================================================

  @override
  Future<List<CompanyAccountEntity>> getAccounts() async {
    final response = await _client
        .from(_table)
        .select('''
        *,
        companies (
          name
        )
      ''')
        .order('created_at', ascending: false);

    return (response as List)
        .map(
          (e) => CompanyAccountModel.fromJson(
        e as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  //==============================================================
  // Get By Id
  //==============================================================

  @override
  Future<CompanyAccountEntity> getAccountById(
      String id,
      ) async {
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

    return CompanyAccountModel.fromJson(response);
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
        'company_id': account.companyId,
        'username': account.username,
        'password': account.passwordHash,
        'is_active': account.isActive,
        'must_change_password': account.mustChangePassword,
        'created_by': account.createdBy,
      })
          .select()
          .single();

      print("Created Account : $response");
    } on PostgrestException catch (e) {
    throw Exception(DatabaseErrorHelper.getMessage(e));
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
      throw Exception('Account ID is missing.');
    }

    try {
      await _client
          .from(_table)
          .update({
        'company_id': account.companyId,
        'username': account.username,
        'password': account.passwordHash,
        'is_active': account.isActive,
        'must_change_password': account.mustChangePassword,
        'updated_at': DateTime.now().toIso8601String(),
        'updated_by': account.updatedBy,
      })
          .eq('id', account.id!);
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
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
    await _client
        .from(_table)
        .update({
      'is_active': isActive,
      'updated_at': DateTime.now().toIso8601String(),
    })
        .eq('id', id);
  }

  //==============================================================
  // Delete
  //==============================================================

  @override
  Future<void> deleteAccount(
      String id,
      ) async {
    await _client
        .from(_table)
        .delete()
        .eq('id', id);
  }
}