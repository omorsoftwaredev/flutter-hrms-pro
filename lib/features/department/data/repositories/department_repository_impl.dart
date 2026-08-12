import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../../domain/entities/department_entity.dart';
import '../../domain/repositories/department_repository.dart';
import '../models/department_model.dart';

class DepartmentRepositoryImpl implements DepartmentRepository {
  DepartmentRepositoryImpl(this._ref);

  final Ref _ref;

  final SupabaseClient _client = Supabase.instance.client;

  // =============================================================
  // CURRENT USER ID
  // =============================================================

  String get _currentUserId {
    final user = _ref.read(currentUserProvider);

    if (user == null) {
      throw Exception(
        'Current user information is not available.',
      );
    }

    final userId = user.userId.trim();

    if (userId.isEmpty) {
      throw Exception(
        'Current user ID is not available.',
      );
    }

    return userId;
  }

  // =============================================================
  // CURRENT COMPANY ID
  // =============================================================

  String get _currentCompanyId {
    final user = _ref.read(currentUserProvider);

    if (user == null) {
      throw Exception(
        'Current user information is not available.',
      );
    }

    final companyId = user.companyId.trim();

    if (companyId.isEmpty) {
      throw Exception(
        'Company information is not available for this account.',
      );
    }

    return companyId;
  }

  // =============================================================
  // GET DEPARTMENTS
  // =============================================================
  //
  // শুধু CurrentUser.companyId-এর departments আসবে।
  //
  // আগে:
  // সব company-এর department আসছিল।
  //
  // এখন:
  // departments.company_id == CurrentUser.companyId
  //
  // =============================================================

  @override
  Future<List<DepartmentEntity>> getDepartments() async {
    try {
      final companyId = _currentCompanyId;

      debugPrint(
        'Department List Company ID => $companyId',
      );

      final response = await _client
          .from('departments')
          .select()
          .eq('company_id', companyId)
          .order('name');

      final departments = (response as List)
          .map(
            (json) => DepartmentModel.fromJson(
          json as Map<String, dynamic>,
        ),
      )
          .toList();

      debugPrint(
        'Department List Count => ${departments.length}',
      );

      return departments;
    } on PostgrestException catch (e) {
      debugPrint(
        'Get Departments Postgrest Error: ${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Get Departments Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // GET DEPARTMENT BY ID
  // =============================================================
  //
  // ID + CurrentUser.companyId
  //
  // =============================================================

  @override
  Future<DepartmentEntity> getDepartmentById(
      String id,
      ) async {
    try {
      final companyId = _currentCompanyId;

      final departmentId = id.trim();

      if (departmentId.isEmpty) {
        throw Exception(
          'Department ID is required.',
        );
      }

      final response = await _client
          .from('departments')
          .select()
          .eq('id', departmentId)
          .eq('company_id', companyId)
          .single();

      return DepartmentModel.fromJson(
        response as Map<String, dynamic>,
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Get Department Postgrest Error: ${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Get Department Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // CREATE DEPARTMENT
  // =============================================================
  //
  // company_id:
  //     CurrentUser.companyId
  //
  // created_by:
  //     CurrentUser.userId
  //
  // code:
  //     Database trigger generate করবে।
  //
  // =============================================================

  @override
  Future<void> createDepartment(
      DepartmentEntity department,
      ) async {
    try {
      final companyId = _currentCompanyId;
      final userId = _currentUserId;

      debugPrint('CREATE DEPARTMENT');
      debugPrint('Company ID => $companyId');
      debugPrint('Created By => $userId');

      await _client.from('departments').insert({
        'company_id': companyId,
        'name': department.name.trim(),
        'description': department.description.trim(),
        'phone': department.phone.trim(),
        'email': department.email.trim(),
        'location': department.location.trim(),
        'is_active': department.isActive,
        'created_by': userId,

        // code manually পাঠানো হচ্ছে না।
        // Database trigger generate করবে।
      });

      debugPrint(
        'Department Created Successfully.',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Create Department Postgrest Error: ${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Create Department Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // UPDATE DEPARTMENT
  // =============================================================

  @override
  Future<void> updateDepartment(
      DepartmentEntity department,
      ) async {
    try {
      final companyId = _currentCompanyId;
      final userId = _currentUserId;

      final departmentId = department.id.trim();

      if (departmentId.isEmpty) {
        throw Exception(
          'Department ID is required for update.',
        );
      }

      debugPrint('UPDATE DEPARTMENT');
      debugPrint('Department ID => $departmentId');
      debugPrint('Company ID => $companyId');
      debugPrint('Updated By => $userId');

      final response = await _client
          .from('departments')
          .update({
        'name': department.name.trim(),
        'description': department.description.trim(),
        'phone': department.phone.trim(),
        'email': department.email.trim(),
        'location': department.location.trim(),
        'is_active': department.isActive,
        'updated_by': userId,
      })
          .eq('id', departmentId)
          .eq('company_id', companyId)
          .select();

      if ((response as List).isEmpty) {
        throw Exception(
          'Department not found or does not belong to the current company.',
        );
      }

      debugPrint(
        'Department Updated Successfully.',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Update Department Postgrest Error: ${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Update Department Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // UPDATE DEPARTMENT STATUS
  // =============================================================

  @override
  Future<void> updateDepartmentStatus({
    required String id,
    required bool isActive,
  }) async {
    try {
      final companyId = _currentCompanyId;
      final userId = _currentUserId;

      final departmentId = id.trim();

      if (departmentId.isEmpty) {
        throw Exception(
          'Department ID is required.',
        );
      }

      final response = await _client
          .from('departments')
          .update({
        'is_active': isActive,
        'updated_by': userId,
      })
          .eq('id', departmentId)
          .eq('company_id', companyId)
          .select();

      if ((response as List).isEmpty) {
        throw Exception(
          'Department not found or does not belong to the current company.',
        );
      }

      debugPrint(
        'Department Status Updated => $departmentId',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Update Department Status Postgrest Error: '
            '${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Update Department Status Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // DELETE DEPARTMENT
  // =============================================================

  @override
  Future<void> deleteDepartment(
      String id,
      ) async {
    try {
      final companyId = _currentCompanyId;

      final departmentId = id.trim();

      if (departmentId.isEmpty) {
        throw Exception(
          'Department ID is required.',
        );
      }

      final response = await _client
          .from('departments')
          .delete()
          .eq('id', departmentId)
          .eq('company_id', companyId)
          .select();

      if ((response as List).isEmpty) {
        throw Exception(
          'Department not found or does not belong to the current company.',
        );
      }

      debugPrint(
        'Department Deleted => $departmentId',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Delete Department Postgrest Error: '
            '${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Delete Department Error: $e',
      );

      rethrow;
    }
  }
}