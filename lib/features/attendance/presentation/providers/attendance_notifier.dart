import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/attendance_repository.dart';
import '../../domain/entities/attendance_entity.dart';

class AttendanceNotifier
    extends StateNotifier<List<AttendanceEntity>> {

  final AttendanceRepository repository;

  AttendanceNotifier(this.repository)
      : super([]);

  Future<void> loadAttendance() async {}

  Future<void> refresh() async {}

  Future<void> addAttendance(
      AttendanceEntity entity) async {}

  Future<void> updateAttendance(
      AttendanceEntity entity) async {}

  Future<void> deleteAttendance(
      String id) async {}

  Future<void> searchAttendance(
      String keyword) async {}

  Future<void> filterAttendance(
      String status) async {}

  AttendanceEntity? getAttendanceById(
      String id) {}

  void clear() {}
}