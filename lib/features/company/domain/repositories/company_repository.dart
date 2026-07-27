import '../entities/company_entity.dart';

abstract class CompanyRepository {
  Future<List<CompanyEntity>> getCompanies();

  Future<CompanyEntity> getCompanyById(String id);

  Future<void> createCompany(CompanyEntity company);

  Future<void> updateCompany(CompanyEntity company);

  Future<void> deleteCompany(String id);
}