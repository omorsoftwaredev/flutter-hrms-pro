import '../entities/shift_entity.dart';

abstract class ShiftRepository {
  // =============================================================
  // GET ALL SHIFTS
  // =============================================================

  Future<List<ShiftEntity>> getShifts();

  // =============================================================
  // GET SHIFT BY ID
  // =============================================================

  Future<ShiftEntity> getShiftById(String id);

  // =============================================================
  // CREATE SHIFT
  // =============================================================

  Future<void> createShift(ShiftEntity shift);

  // =============================================================
  // UPDATE SHIFT
  // =============================================================

  Future<void> updateShift(ShiftEntity shift);

  // =============================================================
  // UPDATE SHIFT STATUS
  // =============================================================

  Future<void> updateShiftStatus({required String id, required bool isActive});

  // =============================================================
  // DELETE SHIFT
  // =============================================================

  Future<void> deleteShift(String id);
}
