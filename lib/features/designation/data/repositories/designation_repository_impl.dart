import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../../domain/entities/designation_entity.dart';
import '../../domain/repositories/designation_repository.dart';
import '../models/designation_model.dart';

class DesignationRepositoryImpl implements DesignationRepository {
  DesignationRepositoryImpl(this._ref);

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
  // GET DESIGNATIONS
  // =============================================================
  //
  // শুধু CurrentUser.companyId-এর designations আসবে।
  //
  // designations.company_id
  //          =
  // CurrentUser.companyId
  //
  // =============================================================

  @override
  Future<List<DesignationEntity>> getDesignations() async {
    try {
      final companyId = _currentCompanyId;

      debugPrint(
        'Designation List Company ID => $companyId',
      );

      final response = await _client
          .from('designations')
          .select()
          .eq('company_id', companyId)
          .order('display_order')
          .order('name');

      final designations = (response as List)
          .map(
            (json) => DesignationModel.fromJson(
          json as Map<String, dynamic>,
        ),
      )
          .toList();

      debugPrint(
        'Designation List Count => ${designations.length}',
      );

      return designations;
    } on PostgrestException catch (e) {
      debugPrint(
        'Get Designations Postgrest Error: ${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Get Designations Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // GET DESIGNATION BY ID
  // =============================================================
  //
  // ID + CurrentUser.companyId
  //
  // =============================================================

  @override
  Future<DesignationEntity> getDesignationById(
      String id,
      ) async {
    try {
      final companyId = _currentCompanyId;

      final designationId = id.trim();

      if (designationId.isEmpty) {
        throw Exception(
          'Designation ID is required.',
        );
      }

      final response = await _client
          .from('designations')
          .select()
          .eq('id', designationId)
          .eq('company_id', companyId)
          .single();

      return DesignationModel.fromJson(
        response as Map<String, dynamic>,
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Get Designation Postgrest Error: ${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Get Designation Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // CREATE DESIGNATION
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
  Future<void> createDesignation(
      DesignationEntity designation,
      ) async {
    try {
      final companyId = _currentCompanyId;
      final userId = _currentUserId;

      debugPrint('CREATE DESIGNATION');
      debugPrint('Company ID => $companyId');
      debugPrint('Created By => $userId');

      await _client.from('designations').insert({
        'company_id': companyId,

        'name': designation.name.trim(),

        'description': designation.description.trim(),

        'grade': designation.grade,

        'display_order': designation.displayOrder,

        'base_salary': designation.baseSalary,

        'is_active': designation.isActive,

        'created_by': userId,

        // code manually পাঠানো হচ্ছে না।
        // Database trigger generate করবে।
      });

      debugPrint(
        'Designation Created Successfully.',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Create Designation Postgrest Error: ${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Create Designation Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // UPDATE DESIGNATION
  // =============================================================
  //
  // created_by:
  //     পরিবর্তন হবে না।
  //
  // updated_by:
  //     CurrentUser.userId
  //
  // code:
  //     পরিবর্তন হবে না।
  //
  // company_id:
  //     CurrentUser.companyId
  //
  // =============================================================

  @override
  Future<void> updateDesignation(
      DesignationEntity designation,
      ) async {
    try {
      final companyId = _currentCompanyId;
      final userId = _currentUserId;

      final designationId = designation.id.trim();

      if (designationId.isEmpty) {
        throw Exception(
          'Designation ID is required for update.',
        );
      }

      debugPrint('UPDATE DESIGNATION');
      debugPrint('Designation ID => $designationId');
      debugPrint('Company ID => $companyId');
      debugPrint('Updated By => $userId');

      final response = await _client
          .from('designations')
          .update({
        'name': designation.name.trim(),

        'description': designation.description.trim(),

        'grade': designation.grade,

        'display_order': designation.displayOrder,

        'base_salary': designation.baseSalary,

        'is_active': designation.isActive,

        'updated_by': userId,

        // created_by update করছি না।
        // code update করছি না।
        // updated_at trigger handle করবে।
      })
          .eq('id', designationId)
          .eq('company_id', companyId)
          .select();

      if ((response as List).isEmpty) {
        throw Exception(
          'Designation not found or does not belong to the current company.',
        );
      }

      debugPrint(
        'Designation Updated Successfully.',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Update Designation Postgrest Error: ${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Update Designation Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // UPDATE DESIGNATION STATUS
  // =============================================================

  @override
  Future<void> updateDesignationStatus({
    required String id,
    required bool isActive,
  }) async {
    try {
      final companyId = _currentCompanyId;
      final userId = _currentUserId;

      final designationId = id.trim();

      if (designationId.isEmpty) {
        throw Exception(
          'Designation ID is required.',
        );
      }

      debugPrint('UPDATE DESIGNATION STATUS');
      debugPrint('Designation ID => $designationId');
      debugPrint('Company ID => $companyId');
      debugPrint('Updated By => $userId');

      final response = await _client
          .from('designations')
          .update({
        'is_active': isActive,

        'updated_by': userId,

        // updated_at trigger handle করবে।
      })
          .eq('id', designationId)
          .eq('company_id', companyId)
          .select();

      if ((response as List).isEmpty) {
        throw Exception(
          'Designation not found or does not belong to the current company.',
        );
      }

      debugPrint(
        'Designation Status Updated => $designationId',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Update Designation Status Postgrest Error: '
            '${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Update Designation Status Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // DELETE DESIGNATION
  // =============================================================

  @override
  Future<void> deleteDesignation(
      String id,
      ) async {
    try {
      final companyId = _currentCompanyId;

      final designationId = id.trim();

      if (designationId.isEmpty) {
        throw Exception(
          'Designation ID is required.',
        );
      }

      debugPrint('DELETE DESIGNATION');
      debugPrint('Designation ID => $designationId');
      debugPrint('Company ID => $companyId');

      final response = await _client
          .from('designations')
          .delete()
          .eq('id', designationId)
          .eq('company_id', companyId)
          .select();

      if ((response as List).isEmpty) {
        throw Exception(
          'Designation not found or does not belong to the current company.',
        );
      }

      debugPrint(
        'Designation Deleted => $designationId',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Delete Designation Postgrest Error: '
            '${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Delete Designation Error: $e',
      );

      rethrow;
    }
  }
}