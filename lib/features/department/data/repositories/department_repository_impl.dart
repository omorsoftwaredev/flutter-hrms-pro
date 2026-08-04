import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/department_entity.dart';
import '../../domain/repositories/department_repository.dart';
import '../models/department_model.dart';

class DepartmentRepositoryImpl
    implements DepartmentRepository {
  DepartmentRepositoryImpl();

  final SupabaseClient _client =
      Supabase.instance.client;

  @override
  Future<List<DepartmentEntity>>
  getDepartments() async {
    final response = await _client
        .from('departments')
        .select()
        .order('name');

    return (response as List)
        .map(
          (json) => DepartmentModel.fromJson(
        json as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  @override
  Future<void> updateDepartmentStatus({
    required String id,
    required bool isActive,
  }) async {
    await _client
        .from('departments')
        .update({
      'is_active': isActive,
    })
        .eq('id', id);
  }

  @override
  Future<DepartmentEntity>
  getDepartmentById(String id) async {
    final response = await _client
        .from('departments')
        .select()
        .eq('id', id)
        .single();

    return DepartmentModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<void> createDepartment(
      DepartmentEntity department,
      ) async {
    try {
      final response = await _client
          .from('departments')
          .insert({
        'company_id': department.companyId,
        'code': department.code,
        'name': department.name,
        'description': department.description,
        'manager_name': department.managerName,
        'phone': department.phone,
        'email': department.email,
        'location': department.location,
        'is_active': department.isActive,
      }).select();

      debugPrint('Department Insert Success: $response');
    } on PostgrestException catch (e) {
      debugPrint('Postgrest Error: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      debugPrint('Unknown Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateDepartment(
      DepartmentEntity department) async {
    await _client
        .from('departments')
        .update({
      'company_id': department.companyId,
      'code': department.code,
      'name': department.name,
      'description': department.description,
      'manager_name': department.managerName,
      'phone': department.phone,
      'email': department.email,
      'location': department.location,
      'is_active': department.isActive,
    })
        .eq('id', department.id);
  }

  @override
  Future<void> deleteDepartment(
      String id) async {
    await _client
        .from('departments')
        .delete()
        .eq('id', id);
  }
}