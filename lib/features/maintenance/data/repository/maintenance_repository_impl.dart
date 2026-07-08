import '../../domain/entities/maintenance_entities.dart';
import '../../domain/repository/maintenance_repository.dart';
import '../datasource/maintenance_local_datasource.dart';

class MaintenanceRepositoryImpl implements MaintenanceRepository {
  final MaintenanceLocalDataSource localDataSource;

  const MaintenanceRepositoryImpl({required this.localDataSource});

  @override
  Future<List<MaintenanceReportEntity>> getReports() async {
    return await localDataSource.getReports();
  }

  @override
  Future<MaintenanceReportEntity> submitIssue(
    MaintenanceReportEntity issue,
  ) async {
    return await localDataSource.submitIssue(issue);
  }

  @override
  Future<MaintenanceReportEntity> getTicket(String ticketId) async {
    return await localDataSource.getTicket(ticketId);
  }
}
