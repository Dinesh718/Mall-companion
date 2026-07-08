import '../entities/maintenance_entities.dart';
import '../repository/maintenance_repository.dart';

class LoadReportsUseCase {
  final MaintenanceRepository repository;

  const LoadReportsUseCase(this.repository);

  Future<List<MaintenanceReportEntity>> call() async {
    return await repository.getReports();
  }
}

class SubmitIssueUseCase {
  final MaintenanceRepository repository;

  const SubmitIssueUseCase(this.repository);

  Future<MaintenanceReportEntity> call(MaintenanceReportEntity issue) async {
    return await repository.submitIssue(issue);
  }
}

class GetTicketUseCase {
  final MaintenanceRepository repository;

  const GetTicketUseCase(this.repository);

  Future<MaintenanceReportEntity> call(String ticketId) async {
    return await repository.getTicket(ticketId);
  }
}
