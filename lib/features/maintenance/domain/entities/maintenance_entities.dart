class MaintenanceReportEntity {
  final String ticketId;
  final String category;
  final String title;
  final String description;
  final String location;
  final String floor;
  final String nearestLandmark;
  final String priority; // Low, Medium, High, Urgent
  final String status; // Submitted, Assigned, Repairing, Resolved
  final String assignedTeam;
  final String estimatedFixTime;
  final DateTime createdTime;
  final String? photoUrl;

  const MaintenanceReportEntity({
    required this.ticketId,
    required this.category,
    required this.title,
    required this.description,
    required this.location,
    required this.floor,
    required this.nearestLandmark,
    required this.priority,
    required this.status,
    required this.assignedTeam,
    required this.estimatedFixTime,
    required this.createdTime,
    this.photoUrl,
  });

  MaintenanceReportEntity copyWith({
    String? ticketId,
    String? category,
    String? title,
    String? description,
    String? location,
    String? floor,
    String? nearestLandmark,
    String? priority,
    String? status,
    String? assignedTeam,
    String? estimatedFixTime,
    DateTime? createdTime,
    String? photoUrl,
  }) {
    return MaintenanceReportEntity(
      ticketId: ticketId ?? this.ticketId,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      floor: floor ?? this.floor,
      nearestLandmark: nearestLandmark ?? this.nearestLandmark,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      assignedTeam: assignedTeam ?? this.assignedTeam,
      estimatedFixTime: estimatedFixTime ?? this.estimatedFixTime,
      createdTime: createdTime ?? this.createdTime,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
