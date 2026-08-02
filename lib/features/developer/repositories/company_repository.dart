/// ===============================================================
/// Flutter HRMS Pro
/// Company Repository
///
/// Version : 1.0.0
/// ===============================================================

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/company_model.dart';

class CompanyRepository {
  CompanyRepository();

  final SupabaseClient _client = SupabaseService.client;

  // =============================================================
  // Create Company
  // =============================================================

  Future<void> createCompany(
      CompanyModel company,
      ) async {
    await _client
        .from('companies')
        .insert(company.toMap());
  }

  // =============================================================
  // Update Company
  // =============================================================

  Future<void> updateCompany(
      CompanyModel company,
      ) async {
    await _client
        .from('companies')
        .update(company.toMap())
        .eq('id', company.id!);
  }

  // =============================================================
  // Delete Company
  // =============================================================

  Future<void> deleteCompany(
      String id,
      ) async {
    await _client
        .from('companies')
        .delete()
        .eq('id', id);
  }

  // =============================================================
  // Get Company
  // =============================================================

  Future<CompanyModel?> getCompany(
      String id,
      ) async {
    final response = await _client
        .from('companies')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return CompanyModel.fromMap(response);
  }

  // =============================================================
  // Company List
  // =============================================================

  Future<List<CompanyModel>> getCompanies() async {
    final response = await _client
        .from('companies')
        .select()
        .order(
      'created_at',
      ascending: false,
    );

    return response
        .map<CompanyModel>(
          (e) => CompanyModel.fromMap(e),
    )
        .toList();
  }

  // =============================================================
  // Search Company
  // =============================================================

  Future<List<CompanyModel>> searchCompany(
      String keyword,
      ) async {
    final response = await _client
        .from('companies')
        .select()
        .or(
      'name.ilike.%$keyword%,code.ilike.%$keyword%',
    );

    return response
        .map<CompanyModel>(
          (e) => CompanyModel.fromMap(e),
    )
        .toList();
  }

  // =============================================================
  // Total Company
  // =============================================================

  Future<int> totalCompanies() async {
    final companies = await _client
        .from('companies')
        .select('id');

    return companies.length;
  }
}