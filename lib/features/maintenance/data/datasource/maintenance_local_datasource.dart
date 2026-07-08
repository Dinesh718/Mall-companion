import '../../domain/entities/maintenance_entities.dart';
import '../models/maintenance_models.dart';

abstract class MaintenanceLocalDataSource {
  Future<List<MaintenanceReportEntity>> getReports();
  Future<MaintenanceReportEntity> submitIssue(MaintenanceReportEntity issue);
  Future<MaintenanceReportEntity> getTicket(String ticketId);
}

class MaintenanceLocalDataSourceImpl implements MaintenanceLocalDataSource {
  static final List<MaintenanceReportEntity> _reports = [
    MaintenanceReportModel(
      ticketId: 'MT-2026-000245',
      category: 'Lighting',
      title: 'Water leak near North Entrance',
      description:
          'Flickering overhead panel lights in the corridor are causing visibility issues for shoppers. Requesting immediate ballast check.',
      location: 'West Wing, Level 3',
      floor: '3rd Floor',
      nearestLandmark: 'Prada Flagship Store',
      priority: 'High',
      status: 'Submitted',
      assignedTeam: 'Electrical Services',
      estimatedFixTime: '24 Hours',
      createdTime: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    MaintenanceReportModel(
      ticketId: 'MT-2026-000212',
      category: 'Air Conditioning',
      title: 'HVAC Maintenance',
      description:
          'Air conditioning vent is blowing warm air instead of cool air in the central dining area. Need zone thermostat repair.',
      location: 'Food Court Area',
      floor: '2nd Floor',
      nearestLandmark: 'Main Entrance Corridor',
      priority: 'Medium',
      status: 'Assigned',
      assignedTeam: 'HVAC Services',
      estimatedFixTime: '2 Hours',
      createdTime: DateTime.now().subtract(const Duration(days: 2)),
    ),
    MaintenanceReportModel(
      ticketId: 'MT-2026-000198',
      category: 'Cleaning',
      title: 'Soda spill on walkway',
      description:
          'Large sticky spill on the marble walkway needs immediate mopping before it becomes a slipping hazard.',
      location: 'South Wing, Level 1',
      floor: '1st Floor',
      nearestLandmark: 'Zara Store Entrance',
      priority: 'Low',
      status: 'Resolved',
      assignedTeam: 'Janitorial Team B',
      estimatedFixTime: '30 Mins',
      createdTime: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  @override
  Future<List<MaintenanceReportEntity>> getReports() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_reports);
  }

  @override
  Future<MaintenanceReportEntity> submitIssue(
    MaintenanceReportEntity issue,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newReport = MaintenanceReportModel(
      ticketId: issue.ticketId,
      category: issue.category,
      title: issue.title,
      description: issue.description,
      location: issue.location,
      floor: issue.floor,
      nearestLandmark: issue.nearestLandmark,
      priority: issue.priority,
      status: issue.status,
      assignedTeam: issue.assignedTeam,
      estimatedFixTime: issue.estimatedFixTime,
      createdTime: issue.createdTime,
      photoUrl: issue.photoUrl,
    );
    _reports.insert(0, newReport);
    return newReport;
  }

  @override
  Future<MaintenanceReportEntity> getTicket(String ticketId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _reports.firstWhere(
      (report) => report.ticketId == ticketId,
      orElse: () => throw Exception('Ticket not found: $ticketId'),
    );
  }
}
