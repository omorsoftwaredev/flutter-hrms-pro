import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/repositories/company_repository.dart';
import '../models/company_model.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  CompanyRepositoryImpl();

  final SupabaseClient _client = SupabaseService.client;

  static const String _table = 'companies';

  @override
  Future<List<CompanyEntity>> getCompanies() async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .order('name', ascending: true);

      return (response as List)
          .map(
            (e) => CompanyModel.fromMap(
          e as Map<String, dynamic>,
        ),
      )
          .toList();
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(
        'Failed to fetch companies.\n$e',
      );
    }
  }

  @override
  Future<CompanyEntity> getCompanyById(
      String id,
      ) async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('id', id)
          .single();

      return CompanyModel.fromMap(response);
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(
        'Failed to fetch company.\n$e',
      );
    }
  }

  @override
  Future<void> createCompany(
      CompanyEntity company,
      ) async {
    try {
      final model = CompanyModel.fromEntity(company);

      await _client
          .from(_table)
          .insert(model.toMap());
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(
        'Failed to create company.\n$e',
      );
    }
  }

  @override
  Future<void> updateCompany(
      CompanyEntity company,
      ) async {
    try {
      final model = CompanyModel.fromEntity(company);

      await _client
          .from(_table)
          .update(model.toMap())
          .eq('id', company.id);
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(
        'Failed to update company.\n$e',
      );
    }
  }

  @override
  Future<void> deleteCompany(
      String id,
      ) async {
    try {
      await _client
          .from(_table)
          .delete()
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(
        'Failed to delete company.\n$e',
      );
    }
  }
}