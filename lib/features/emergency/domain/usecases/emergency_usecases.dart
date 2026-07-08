import '../entities/emergency_entities.dart';
import '../repositories/emergency_repository.dart';

class LoadEmergencyFacilitiesUseCase {
  final EmergencyRepository repository;

  const LoadEmergencyFacilitiesUseCase(this.repository);

  Future<List<EmergencyFacilityEntity>> call() async {
    return await repository.loadEmergencyFacilities();
  }
}

class LoadEmergencyContactsUseCase {
  final EmergencyRepository repository;

  const LoadEmergencyContactsUseCase(this.repository);

  Future<List<EmergencyContactEntity>> call() async {
    return await repository.loadEmergencyContacts();
  }
}

class StartEmergencyNavigationUseCase {
  final EmergencyRepository repository;

  const StartEmergencyNavigationUseCase(this.repository);

  Future<EmergencyNavigationRouteEntity> call(String destination) async {
    return await repository.startNavigation(destination);
  }
}

class SendSOSUseCase {
  final EmergencyRepository repository;

  const SendSOSUseCase(this.repository);

  Future<void> call() async {
    return await repository.sendSOS();
  }
}

class NotifySecurityUseCase {
  final EmergencyRepository repository;

  const NotifySecurityUseCase(this.repository);

  Future<void> call() async {
    return await repository.notifySecurity();
  }
}

class LoadInstructionsUseCase {
  final EmergencyRepository repository;

  const LoadInstructionsUseCase(this.repository);

  Future<List<EmergencyInstructionEntity>> call() async {
    return await repository.loadInstructions();
  }
}
