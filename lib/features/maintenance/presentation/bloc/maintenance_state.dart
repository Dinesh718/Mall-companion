import '../../domain/entities/maintenance_entities.dart';

abstract class MaintenanceState {
  const MaintenanceState();
}

class MaintenanceInitial extends MaintenanceState {
  const MaintenanceInitial();
}

class MaintenanceLoading extends MaintenanceState {
  const MaintenanceLoading();
}

class MaintenanceLoaded extends MaintenanceState {
  final String category;
  final String title;
  final String description;
  final String priority;
  final String? photoPath;
  final String location;
  final String floor;
  final String nearestLandmark;
  final String locationStatus;

  const MaintenanceLoaded({
    this.category = '',
    this.title = '',
    this.description = '',
    this.priority = 'Medium',
    this.photoPath,
    this.location = 'LuxeMall • 2nd Floor • North Wing',
    this.floor = '2nd Floor',
    this.nearestLandmark = 'Prada Flagship Store',
    this.locationStatus = 'Auto Detected',
  });

  MaintenanceLoaded copyWith({
    String? category,
    String? title,
    String? description,
    String? priority,
    String? photoPath,
    String? location,
    String? floor,
    String? nearestLandmark,
    String? locationStatus,
  }) {
    return MaintenanceLoaded(
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      photoPath: photoPath ?? this.photoPath,
      location: location ?? this.location,
      floor: floor ?? this.floor,
      nearestLandmark: nearestLandmark ?? this.nearestLandmark,
      locationStatus: locationStatus ?? this.locationStatus,
    );
  }
}

class GuestMaintenanceState extends MaintenanceState {
  const GuestMaintenanceState();
}

class LoggedInMaintenanceState extends MaintenanceState {
  final List<MaintenanceReportEntity> reports;
  const LoggedInMaintenanceState({required this.reports});
}

class SubmittingIssue extends MaintenanceState {
  const SubmittingIssue();
}

class IssueSubmitted extends MaintenanceState {
  final MaintenanceReportEntity ticket;
  const IssueSubmitted({required this.ticket});
}

class TicketLoaded extends MaintenanceState {
  final MaintenanceReportEntity ticket;
  const TicketLoaded({required this.ticket});
}

class ReportsLoaded extends MaintenanceState {
  final List<MaintenanceReportEntity> reports;
  const ReportsLoaded({required this.reports});
}

class MaintenanceError extends MaintenanceState {
  final String errorMessage;
  const MaintenanceError({required this.errorMessage});
}
