import '../entities/emergency_entities.dart';

abstract class EmergencyRepository {
  Future<void> loadEmergencyHub();
  Future<List<EmergencyFacilityEntity>> loadEmergencyFacilities();
  Future<List<EmergencyContactEntity>> loadEmergencyContacts();
  Future<EmergencyNavigationRouteEntity> startNavigation(String destination);
  Future<void> sendSOS();
  Future<void> notifySecurity();
  Future<List<EmergencyInstructionEntity>> loadInstructions();
}
