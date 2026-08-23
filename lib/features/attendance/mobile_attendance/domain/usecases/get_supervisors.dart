import '../../../../supervisor/domain/entities/supervisor.dart';
import '../../../../supervisor/domain/repositories/supervisor_repository.dart';

class GetSupervisors {
  final SupervisorRepository repository;

  const GetSupervisors(this.repository);

  Future<List<Supervisor>> call(
      String companyId,
      ) {
    return repository.getSupervisors(
      companyId,
    );
  }
}