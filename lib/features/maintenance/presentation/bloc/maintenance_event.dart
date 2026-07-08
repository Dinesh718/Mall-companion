import '../../domain/entities/maintenance_entities.dart';

abstract class MaintenanceEvent {
  const MaintenanceEvent();
}

class LoadMaintenance extends MaintenanceEvent {
  const LoadMaintenance();
}

class LoadReports extends MaintenanceEvent {
  const LoadReports();
}

class SelectCategory extends MaintenanceEvent {
  final String category;
  const SelectCategory({required this.category});
}

class UpdateIssueTitle extends MaintenanceEvent {
  final String title;
  const UpdateIssueTitle({required this.title});
}

class UpdateDescription extends MaintenanceEvent {
  final String description;
  const UpdateDescription({required this.description});
}

class UpdatePriority extends MaintenanceEvent {
  final String priority;
  const UpdatePriority({required this.priority});
}

class AttachPhoto extends MaintenanceEvent {
  final String photoPath;
  const AttachPhoto({required this.photoPath});
}

class RemovePhoto extends MaintenanceEvent {
  const RemovePhoto();
}

class FetchCurrentLocation extends MaintenanceEvent {
  const FetchCurrentLocation();
}

class SubmitIssue extends MaintenanceEvent {
  const SubmitIssue();
}

class LoadTicket extends MaintenanceEvent {
  final String ticketId;
  const LoadTicket({required this.ticketId});
}

class RefreshTicket extends MaintenanceEvent {
  final String ticketId;
  const RefreshTicket({required this.ticketId});
}
