import '../entities/maintenance_entities.dart';

abstract class MaintenanceRepository {
  Future<List<MaintenanceReportEntity>> getReports();
  Future<MaintenanceReportEntity> submitIssue(MaintenanceReportEntity issue);
  Future<MaintenanceReportEntity> getTicket(String ticketId);
}
