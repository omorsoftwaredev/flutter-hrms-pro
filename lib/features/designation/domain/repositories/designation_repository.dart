import '../entities/designation_entity.dart';

abstract class DesignationRepository {
  Future<List<DesignationEntity>>
  getDesignations();

  Future<DesignationEntity>
  getDesignationById(String id);

  Future<void> createDesignation(
      DesignationEntity designation);

  Future<void> updateDesignation(
      DesignationEntity designation);

  Future<void> deleteDesignation(
      String id);
  Future<void> updateDesignationStatus({
    required String id,
    required bool isActive,
  });
}