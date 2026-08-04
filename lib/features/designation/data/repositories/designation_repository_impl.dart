import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/designation_entity.dart';
import '../../domain/repositories/designation_repository.dart';
import '../models/designation_model.dart';

class DesignationRepositoryImpl
    implements DesignationRepository {
  DesignationRepositoryImpl();

  final SupabaseClient _client =
      Supabase.instance.client;

  @override
  Future<List<DesignationEntity>>
  getDesignations() async {
    final response = await _client
        .from('designations')
        .select()
        .order('display_order')
        .order('name');

    return (response as List)
        .map(
          (e) =>
          DesignationModel.fromJson(
            e,
          ),
    )
        .toList();
  }

  @override
  Future<void> updateDesignationStatus({
    required String id,
    required bool isActive,
  }) async {
    await _client
        .from('designations')
        .update({
      'is_active': isActive,
    })
        .eq('id', id);
  }

  @override
  Future<DesignationEntity>
  getDesignationById(
      String id) async {
    final response = await _client
        .from('designations')
        .select()
        .eq('id', id)
        .single();

    return DesignationModel.fromJson(
      response,
    );
  }

  @override
  Future<void> createDesignation(
      DesignationEntity designation) async {
    await _client
        .from('designations')
        .insert({
      'company_id':
      designation.companyId,
      'code': designation.code,
      'name': designation.name,
      'description':
      designation.description,
      'grade':
      designation.grade,
      'display_order':
      designation.displayOrder,
      'base_salary':
      designation.baseSalary,
      'is_active':
      designation.isActive,
    }).select();
  }

  @override
  Future<void> updateDesignation(
      DesignationEntity designation) async {
    await _client
        .from('designations')
        .update({
      'company_id':
      designation.companyId,
      'code': designation.code,
      'name': designation.name,
      'description':
      designation.description,
      'grade':
      designation.grade,
      'display_order':
      designation.displayOrder,
      'base_salary':
      designation.baseSalary,
      'is_active':
      designation.isActive,
    }).eq(
      'id',
      designation.id,
    );
  }

  @override
  Future<void> deleteDesignation(
      String id) async {
    await _client
        .from('designations')
        .delete()
        .eq('id', id);
  }
}