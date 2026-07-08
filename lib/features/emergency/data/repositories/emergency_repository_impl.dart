import '../../domain/entities/emergency_entities.dart';
import '../../domain/repositories/emergency_repository.dart';
import '../datasources/emergency_local_datasource.dart';

class EmergencyRepositoryImpl implements EmergencyRepository {
  final EmergencyLocalDataSource localDataSource;

  const EmergencyRepositoryImpl({required this.localDataSource});

  @override
  Future<void> loadEmergencyHub() async {
    // Simulated load delay
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<List<EmergencyFacilityEntity>> loadEmergencyFacilities() async {
    return await localDataSource.loadEmergencyFacilities();
  }

  @override
  Future<List<EmergencyContactEntity>> loadEmergencyContacts() async {
    return await localDataSource.loadEmergencyContacts();
  }

  @override
  Future<EmergencyNavigationRouteEntity> startNavigation(String destination) async {
    return await localDataSource.startNavigation(destination);
  }

  @override
  Future<void> sendSOS() async {
    await localDataSource.sendSOS();
  }

  @override
  Future<void> notifySecurity() async {
    await localDataSource.notifySecurity();
  }

  @override
  Future<List<EmergencyInstructionEntity>> loadInstructions() async {
    return await localDataSource.loadInstructions();
  }
}
