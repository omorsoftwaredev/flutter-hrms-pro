import '../entities/shift_entity.dart';

abstract class ShiftRepository {
  Future<List<ShiftEntity>> getShifts();

  Future<ShiftEntity> getShiftById(
      String id,
      );

  Future<void> createShift(
      ShiftEntity shift,
      );

  Future<void> updateShift(
      ShiftEntity shift,
      );

  Future<void> updateShiftStatus({
    required String id,
    required bool isActive,
  });

  Future<void> deleteShift(
      String id,
      );
}