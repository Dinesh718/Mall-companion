class EmergencyFacilityEntity {
  final String title;
  final String floor;
  final String location;
  final double distanceMeter;
  final int walkingTimeMinutes;
  final String status; // Operational, Closed, High Crowd
  final bool isAvailable;
  final String contactNumber;
  final String iconName;

  const EmergencyFacilityEntity({
    required this.title,
    required this.floor,
    required this.location,
    required this.distanceMeter,
    required this.walkingTimeMinutes,
    required this.status,
    required this.isAvailable,
    required this.contactNumber,
    required this.iconName,
  });
}

class EmergencyContactEntity {
  final String name;
  final String number;
  final String iconName;

  const EmergencyContactEntity({
    required this.name,
    required this.number,
    required this.iconName,
  });
}

class EmergencyInstructionEntity {
  final String title;
  final String description;
  final String iconName;

  const EmergencyInstructionEntity({
    required this.title,
    required this.description,
    required this.iconName,
  });
}

class RouteStepEntity {
  final String title;
  final String description;
  final String iconName;

  const RouteStepEntity({
    required this.title,
    required this.description,
    required this.iconName,
  });
}

class EmergencyNavigationRouteEntity {
  final String destinationName;
  final int estimatedMinutes;
  final double distanceMeter;
  final String currentFloor;
  final bool isSafeRouteActive;
  final List<RouteStepEntity> steps;

  const EmergencyNavigationRouteEntity({
    required this.destinationName,
    required this.estimatedMinutes,
    required this.distanceMeter,
    required this.currentFloor,
    required this.isSafeRouteActive,
    required this.steps,
  });
}
