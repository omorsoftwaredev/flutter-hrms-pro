import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../../domain/entities/shift_entity.dart';
import '../../domain/repositories/shift_repository.dart';
import '../models/shift_model.dart';

class ShiftRepositoryImpl implements ShiftRepository {
  ShiftRepositoryImpl(this._ref);

  final Ref _ref;

  final SupabaseClient _client = Supabase.instance.client;

  // =============================================================
  // CURRENT USER ID
  // =============================================================

  String get _currentUserId {
    final user = _ref.read(currentUserProvider);

    if (user == null) {
      throw Exception('Current user information is not available.');
    }

    final userId = user.userId.trim();

    if (userId.isEmpty) {
      throw Exception('Current user ID is not available.');
    }

    return userId;
  }

  // =============================================================
  // CURRENT COMPANY ID
  // =============================================================

  String get _currentCompanyId {
    final user = _ref.read(currentUserProvider);

    if (user == null) {
      throw Exception('Current user information is not available.');
    }

    final companyId = user.companyId.trim();

    if (companyId.isEmpty) {
      throw Exception('Company information is not available for this account.');
    }

    return companyId;
  }

  // =============================================================
  // GET SHIFTS
  // =============================================================
  //
  // শুধু CurrentUser.companyId-এর shifts আসবে।
  //
  // shifts.company_id
  //          =
  // CurrentUser.companyId
  //
  // =============================================================

  @override
  Future<List<ShiftEntity>> getShifts() async {
    try {
      final companyId = _currentCompanyId;

      debugPrint('Shift List Company ID => $companyId');

      final response = await _client
          .from('shifts')
          .select()
          .eq('company_id', companyId)
          .order('name');

      final shifts = (response as List)
          .map((json) => ShiftModel.fromJson(json as Map<String, dynamic>))
          .toList();

      debugPrint('Shift List Count => ${shifts.length}');

      return shifts;
    } on PostgrestException catch (e) {
      debugPrint('Get Shifts Postgrest Error: ${e.message}');

      throw Exception(e.message);
    } catch (e) {
      debugPrint('Get Shifts Error: $e');

      rethrow;
    }
  }

  // =============================================================
  // GET SHIFT BY ID
  // =============================================================
  //
  // ID + CurrentUser.companyId
  //
  // =============================================================

  @override
  Future<ShiftEntity> getShiftById(String id) async {
    try {
      final companyId = _currentCompanyId;

      final shiftId = id.trim();

      if (shiftId.isEmpty) {
        throw Exception('Shift ID is required.');
      }

      final response = await _client
          .from('shifts')
          .select()
          .eq('id', shiftId)
          .eq('company_id', companyId)
          .single();

      return ShiftModel.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      debugPrint('Get Shift Postgrest Error: ${e.message}');

      throw Exception(e.message);
    } catch (e) {
      debugPrint('Get Shift Error: $e');

      rethrow;
    }
  }

  // =============================================================
  // CREATE SHIFT
  // =============================================================
  //
  // company_id:
  //     CurrentUser.companyId
  //
  // created_by:
  //     CurrentUser.userId
  //
  // =============================================================

  @override
  Future<void> createShift(ShiftEntity shift) async {
    try {
      final companyId = _currentCompanyId;
      final userId = _currentUserId;

      debugPrint('CREATE SHIFT');
      debugPrint('Company ID => $companyId');
      debugPrint('Created By => $userId');

      await _client.from('shifts').insert({
        'company_id': companyId,

        'name': shift.name.trim(),

        'description': shift.description.trim(),

        'start_time': shift.startTime,

        'end_time': shift.endTime,

        'break_minutes': shift.breakMinutes,

        'grace_in_minutes': shift.graceInMinutes,

        'grace_out_minutes': shift.graceOutMinutes,

        'late_after_minutes': shift.lateAfterMinutes,

        'half_day_after_minutes': shift.halfDayAfterMinutes,

        'is_night_shift': shift.isNightShift,

        'is_flexible': shift.isFlexible,

        'is_active': shift.isActive,

        'created_by': userId,
      });

      debugPrint('Shift Created Successfully.');
    } on PostgrestException catch (e) {
      debugPrint('Create Shift Postgrest Error: ${e.message}');

      throw Exception(e.message);
    } catch (e) {
      debugPrint('Create Shift Error: $e');

      rethrow;
    }
  }

  // =============================================================
  // UPDATE SHIFT
  // =============================================================
  //
  // created_by:
  //     পরিবর্তন হবে না।
  //
  // updated_by:
  //     CurrentUser.userId
  //
  // id:
  //     পরিবর্তন হবে না।
  //
  // code:
  //     পরিবর্তন হবে না।
  //
  // company_id:
  //     CurrentUser.companyId
  //
  // =============================================================

  @override
  Future<void> updateShift(ShiftEntity shift) async {
    try {
      final companyId = _currentCompanyId;
      final userId = _currentUserId;

      final shiftId = shift.id.trim();

      if (shiftId.isEmpty) {
        throw Exception('Shift ID is required for update.');
      }

      debugPrint('UPDATE SHIFT');
      debugPrint('Shift ID => $shiftId');
      debugPrint('Company ID => $companyId');
      debugPrint('Updated By => $userId');

      final response = await _client
          .from('shifts')
          .update({
            'name': shift.name.trim(),

            'description': shift.description.trim(),

            'start_time': shift.startTime,

            'end_time': shift.endTime,

            'break_minutes': shift.breakMinutes,

            'grace_in_minutes': shift.graceInMinutes,

            'grace_out_minutes': shift.graceOutMinutes,

            'late_after_minutes': shift.lateAfterMinutes,

            'half_day_after_minutes': shift.halfDayAfterMinutes,

            'is_night_shift': shift.isNightShift,

            'is_flexible': shift.isFlexible,

            'is_active': shift.isActive,

            'updated_by': userId,

            // created_by update করছি না।
            // code update করছি না।
            // updated_at trigger handle করবে।
          })
          .eq('id', shiftId)
          .eq('company_id', companyId)
          .select();

      if ((response as List).isEmpty) {
        throw Exception(
          'Shift not found or does not belong to the current company.',
        );
      }

      debugPrint('Shift Updated Successfully.');
    } on PostgrestException catch (e) {
      debugPrint('Update Shift Postgrest Error: ${e.message}');

      throw Exception(e.message);
    } catch (e) {
      debugPrint('Update Shift Error: $e');

      rethrow;
    }
  }

  // =============================================================
  // UPDATE SHIFT STATUS
  // =============================================================

  @override
  Future<void> updateShiftStatus({
    required String id,
    required bool isActive,
  }) async {
    try {
      final companyId = _currentCompanyId;
      final userId = _currentUserId;

      final shiftId = id.trim();

      if (shiftId.isEmpty) {
        throw Exception('Shift ID is required.');
      }

      debugPrint('UPDATE SHIFT STATUS');
      debugPrint('Shift ID => $shiftId');
      debugPrint('Company ID => $companyId');
      debugPrint('Updated By => $userId');

      final response = await _client
          .from('shifts')
          .update({
            'is_active': isActive,

            'updated_by': userId,

            // updated_at trigger handle করবে।
          })
          .eq('id', shiftId)
          .eq('company_id', companyId)
          .select();

      if ((response as List).isEmpty) {
        throw Exception(
          'Shift not found or does not belong to the current company.',
        );
      }

      debugPrint('Shift Status Updated => $shiftId');
    } on PostgrestException catch (e) {
      debugPrint(
        'Update Shift Status Postgrest Error: '
        '${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint('Update Shift Status Error: $e');

      rethrow;
    }
  }

  // =============================================================
  // DELETE SHIFT
  // =============================================================

  @override
  Future<void> deleteShift(String id) async {
    try {
      final companyId = _currentCompanyId;

      final shiftId = id.trim();

      if (shiftId.isEmpty) {
        throw Exception('Shift ID is required.');
      }

      debugPrint('DELETE SHIFT');
      debugPrint('Shift ID => $shiftId');
      debugPrint('Company ID => $companyId');

      final response = await _client
          .from('shifts')
          .delete()
          .eq('id', shiftId)
          .eq('company_id', companyId)
          .select();

      if ((response as List).isEmpty) {
        throw Exception(
          'Shift not found or does not belong to the current company.',
        );
      }

      debugPrint('Shift Deleted => $shiftId');
    } on PostgrestException catch (e) {
      debugPrint(
        'Delete Shift Postgrest Error: '
        '${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint('Delete Shift Error: $e');

      rethrow;
    }
  }
}
