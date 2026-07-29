import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/shift_entity.dart';
import '../../domain/repositories/shift_repository.dart';
import '../models/shift_model.dart';

class ShiftRepositoryImpl
    implements ShiftRepository {
  ShiftRepositoryImpl();

  final SupabaseClient _client =
      Supabase.instance.client;

  @override
  Future<List<ShiftEntity>> getShifts() async {
    final response = await _client
        .from('shifts')
        .select()
        .order('name');

    return (response as List)
        .map(
          (e) => ShiftModel.fromJson(
        e as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  @override
  Future<ShiftEntity> getShiftById(
      String id) async {
    final response = await _client
        .from('shifts')
        .select()
        .eq('id', id)
        .single();

    return ShiftModel.fromJson(response);
  }

  @override
  Future<void> createShift(
      ShiftEntity shift) async {
    await _client
        .from('shifts')
        .insert(
      ShiftModel(
        id: shift.id,
        companyId: shift.companyId,
        code: shift.code,
        name: shift.name,
        description: shift.description,
        startTime: shift.startTime,
        endTime: shift.endTime,
        breakMinutes:
        shift.breakMinutes,
        graceInMinutes:
        shift.graceInMinutes,
        graceOutMinutes:
        shift.graceOutMinutes,
        lateAfterMinutes:
        shift.lateAfterMinutes,
        halfDayAfterMinutes:
        shift.halfDayAfterMinutes,
        isNightShift:
        shift.isNightShift,
        isFlexible:
        shift.isFlexible,
        weeklyOffDay:
        shift.weeklyOffDay,
        isActive:
        shift.isActive,
        createdAt:
        shift.createdAt,
        updatedAt:
        shift.updatedAt,
      ).toJson(),
    );
  }

  @override
  Future<void> updateShift(
      ShiftEntity shift) async {
    await _client
        .from('shifts')
        .update(
      ShiftModel(
        id: shift.id,
        companyId: shift.companyId,
        code: shift.code,
        name: shift.name,
        description: shift.description,
        startTime: shift.startTime,
        endTime: shift.endTime,
        breakMinutes:
        shift.breakMinutes,
        graceInMinutes:
        shift.graceInMinutes,
        graceOutMinutes:
        shift.graceOutMinutes,
        lateAfterMinutes:
        shift.lateAfterMinutes,
        halfDayAfterMinutes:
        shift.halfDayAfterMinutes,
        isNightShift:
        shift.isNightShift,
        isFlexible:
        shift.isFlexible,
        weeklyOffDay:
        shift.weeklyOffDay,
        isActive:
        shift.isActive,
        createdAt:
        shift.createdAt,
        updatedAt:
        shift.updatedAt,
      ).toJson(),
    )
        .eq('id', shift.id);
  }

  @override
  Future<void> deleteShift(
      String id) async {
    await _client
        .from('shifts')
        .delete()
        .eq('id', id);
  }
}