// lib/features/company/data/repositories/company_repository_impl.dart

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/helpers/database_error_helper.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/repositories/company_repository.dart';
import '../models/company_model.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  CompanyRepositoryImpl();

  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<CompanyEntity>> getCompanies() async {
    print("=========== COMPANY REPOSITORY ==========");

    final response = await _client
        .from('companies')
        .select('*');

    print("Raw Response: $response");
    print("Length: ${(response as List).length}");

    return response
        .map(
          (json) => CompanyModel.fromJson(
        json as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  Future<void> updateCompanyStatus({
    required String id,
    required bool isActive,
  }) async {
    await _client
        .from('companies')
        .update({
      'is_active': isActive,
    })
        .eq('id', id);
  }

  @override
  Future<CompanyEntity> getCompanyById(String id) async {
    final response = await _client
        .from('companies')
        .select()
        .eq('id', id)
        .single();

    return CompanyModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<void> createCompany(
      CompanyEntity company,
      ) async {
    try {
      await _client.from('companies').insert({
        'code': company.code,
        'name': company.name,
        'phone': company.phone,
        'email': company.email,
        'website': company.website,
        'address': company.address,
        'contact_person': company.contactPerson,
        'logo_url': company.logoUrl,
        'tax_number': company.taxNumber,
        'registration_number': company.registrationNumber,
        'notes': company.notes,
        'is_active': company.isActive,
      }).select();
    } on PostgrestException catch (e) {
      throw Exception(DatabaseErrorHelper.getMessage(e));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateCompany(
      CompanyEntity company,
      ) async {
    await _client
        .from('companies')
        .update({
      'name': company.name,
      'code': company.code,
      'email': company.email,
      'phone': company.phone,
      'address': company.address,
      'logo_url': company.logoUrl,
      'website': company.website,
      'contact_person': company.contactPerson,
      'tax_number': company.taxNumber,
      'registration_number':
      company.registrationNumber,
      'notes': company.notes,
      'is_active': company.isActive,
    })
        .eq('id', company.id);
  }

  @override
  Future<void> deleteCompany(String id) async {
    await _client
        .from('companies')
        .delete()
        .eq('id', id);
  }
}