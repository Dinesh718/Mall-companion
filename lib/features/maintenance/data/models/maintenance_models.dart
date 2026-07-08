import '../../domain/entities/maintenance_entities.dart';

class MaintenanceReportModel extends MaintenanceReportEntity {
  const MaintenanceReportModel({
    required super.ticketId,
    required super.category,
    required super.title,
    required super.description,
    required super.location,
    required super.floor,
    required super.nearestLandmark,
    required super.priority,
    required super.status,
    required super.assignedTeam,
    required super.estimatedFixTime,
    required super.createdTime,
    super.photoUrl,
  });

  factory MaintenanceReportModel.fromEntity(MaintenanceReportEntity entity) {
    return MaintenanceReportModel(
      ticketId: entity.ticketId,
      category: entity.category,
      title: entity.title,
      description: entity.description,
      location: entity.location,
      floor: entity.floor,
      nearestLandmark: entity.nearestLandmark,
      priority: entity.priority,
      status: entity.status,
      assignedTeam: entity.assignedTeam,
      estimatedFixTime: entity.estimatedFixTime,
      createdTime: entity.createdTime,
      photoUrl: entity.photoUrl,
    );
  }
}
