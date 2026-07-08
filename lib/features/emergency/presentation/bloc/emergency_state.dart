import '../../domain/entities/emergency_entities.dart';

abstract class EmergencyState {
  const EmergencyState();
}

class EmergencyInitial extends EmergencyState {
  const EmergencyInitial();
}

class EmergencyLoading extends EmergencyState {
  const EmergencyLoading();
}

class EmergencyLoaded extends EmergencyState {
  final List<EmergencyFacilityEntity> facilities;
  final List<EmergencyContactEntity> contacts;
  final List<EmergencyInstructionEntity> instructions;

  const EmergencyLoaded({
    required this.facilities,
    required this.contacts,
    required this.instructions,
  });
}

class EmergencyNavigationLoaded extends EmergencyState {
  final EmergencyNavigationRouteEntity route;

  const EmergencyNavigationLoaded({required this.route});
}

class EmergencyNavigating extends EmergencyState {
  final String destination;
  const EmergencyNavigating({required this.destination});
}

class SOSSending extends EmergencyState {
  const SOSSending();
}

class SOSSent extends EmergencyState {
  final String alertMessage;
  const SOSSent({required this.alertMessage});
}

class EmergencyFacilitiesLoaded extends EmergencyState {
  final List<EmergencyFacilityEntity> facilities;
  const EmergencyFacilitiesLoaded({required this.facilities});
}

class EmergencyContactsLoaded extends EmergencyState {
  final List<EmergencyContactEntity> contacts;
  const EmergencyContactsLoaded({required this.contacts});
}

class EmergencyError extends EmergencyState {
  final String errorMessage;
  const EmergencyError({required this.errorMessage});
}
