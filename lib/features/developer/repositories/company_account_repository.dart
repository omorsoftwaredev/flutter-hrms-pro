/// ===============================================================
/// Flutter HRMS Pro
/// Company Account Repository
///
/// Version : 1.0.0
/// ===============================================================

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/company_account_model.dart';

class CompanyAccountRepository {
  CompanyAccountRepository();

  final SupabaseClient _client = SupabaseService.client;

  // =============================================================
  // Create Company Account
  // =============================================================

  Future<void> createAccount(
      CompanyAccountModel account,
      ) async {
    await _client
        .from('company_accounts')
        .insert(account.toMap());
  }

  // =============================================================
  // Update Company Account
  // =============================================================

  Future<void> updateAccount(
      CompanyAccountModel account,
      ) async {
    await _client
        .from('company_accounts')
        .update(account.toMap())
        .eq('id', account.id!);
  }

  // =============================================================
  // Delete Company Account
  // =============================================================

  Future<void> deleteAccount(
      String id,
      ) async {
    await _client
        .from('company_accounts')
        .delete()
        .eq('id', id);
  }

  // =============================================================
  // Get Account By Id
  // =============================================================

  Future<CompanyAccountModel?> getAccount(
      String id,
      ) async {
    final response = await _client
        .from('company_accounts')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return CompanyAccountModel.fromMap(
      response,
    );
  }

  // =============================================================
  // Get All Accounts
  // =============================================================

  Future<List<CompanyAccountModel>>
  getAccounts() async {
    final response = await _client
        .from('company_accounts')
        .select()
        .order(
      'created_at',
      ascending: false,
    );

    return response
        .map<CompanyAccountModel>(
          (e) => CompanyAccountModel.fromMap(e),
    )
        .toList();
  }

  // =============================================================
  // Company Accounts
  // =============================================================

  Future<List<CompanyAccountModel>>
  getCompanyAccounts(
      String companyId,
      ) async {
    final response = await _client
        .from('company_accounts')
        .select()
        .eq('company_id', companyId);

    return response
        .map<CompanyAccountModel>(
          (e) => CompanyAccountModel.fromMap(e),
    )
        .toList();
  }

  // =============================================================
  // Username Exists
  // =============================================================

  Future<bool> usernameExists(
      String username,
      ) async {
    final response = await _client
        .from('company_accounts')
        .select('id')
        .eq('username', username)
        .maybeSingle();

    return response != null;
  }

  // =============================================================
  // Email Exists
  // =============================================================

  Future<bool> emailExists(
      String email,
      ) async {
    final response = await _client
        .from('company_accounts')
        .select('id')
        .eq('email', email)
        .maybeSingle();

    return response != null;
  }
}