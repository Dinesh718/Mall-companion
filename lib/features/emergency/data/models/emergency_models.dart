import '../../domain/entities/emergency_entities.dart';

class EmergencyFacilityModel extends EmergencyFacilityEntity {
  const EmergencyFacilityModel({
    required super.title,
    required super.floor,
    required super.location,
    required super.distanceMeter,
    required super.walkingTimeMinutes,
    required super.status,
    required super.isAvailable,
    required super.contactNumber,
    required super.iconName,
  });
}

class EmergencyContactModel extends EmergencyContactEntity {
  const EmergencyContactModel({
    required super.name,
    required super.number,
    required super.iconName,
  });
}

class EmergencyInstructionModel extends EmergencyInstructionEntity {
  const EmergencyInstructionModel({
    required super.title,
    required super.description,
    required super.iconName,
  });
}

class RouteStepModel extends RouteStepEntity {
  const RouteStepModel({
    required super.title,
    required super.description,
    required super.iconName,
  });
}

class EmergencyNavigationRouteModel extends EmergencyNavigationRouteEntity {
  const EmergencyNavigationRouteModel({
    required super.destinationName,
    required super.estimatedMinutes,
    required super.distanceMeter,
    required super.currentFloor,
    required super.isSafeRouteActive,
    required super.steps,
  });
}
