import '../../domain/entities/emergency_entities.dart';
import '../models/emergency_models.dart';

abstract class EmergencyLocalDataSource {
  Future<List<EmergencyFacilityEntity>> loadEmergencyFacilities();
  Future<List<EmergencyContactEntity>> loadEmergencyContacts();
  Future<EmergencyNavigationRouteEntity> startNavigation(String destination);
  Future<void> sendSOS();
  Future<void> notifySecurity();
  Future<List<EmergencyInstructionEntity>> loadInstructions();
}

class EmergencyLocalDataSourceImpl implements EmergencyLocalDataSource {
  @override
  Future<List<EmergencyFacilityEntity>> loadEmergencyFacilities() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      EmergencyFacilityModel(
        title: 'Emergency Exit North',
        floor: '2nd Floor',
        location: 'North Wing, Near Store Zara',
        distanceMeter: 45.0,
        walkingTimeMinutes: 1,
        status: 'Operational',
        isAvailable: true,
        contactNumber: '999',
        iconName: 'exit_to_app',
      ),
      EmergencyFacilityModel(
        title: 'First Aid Room',
        floor: '1st Floor',
        location: 'Central Atrium, Near Information Desk',
        distanceMeter: 120.0,
        walkingTimeMinutes: 3,
        status: 'Operational',
        isAvailable: true,
        contactNumber: '044-1234567',
        iconName: 'medical_services',
      ),
      EmergencyFacilityModel(
        title: 'Security Desk South',
        floor: 'Ground Floor',
        location: 'South Lobby, Main Gate',
        distanceMeter: 300.0,
        walkingTimeMinutes: 6,
        status: 'Operational',
        isAvailable: true,
        contactNumber: '100',
        iconName: 'security',
      ),
      EmergencyFacilityModel(
        title: 'Emergency Exit B',
        floor: '3rd Floor',
        location: 'East Wing, Near Food Court',
        distanceMeter: 180.0,
        walkingTimeMinutes: 4,
        status: 'Operational',
        isAvailable: true,
        contactNumber: '999',
        iconName: 'exit_to_app',
      ),
      EmergencyFacilityModel(
        title: 'First Aid Center East',
        floor: '3rd Floor',
        location: 'East Wing Corridor',
        distanceMeter: 220.0,
        walkingTimeMinutes: 5,
        status: 'Operational',
        isAvailable: true,
        contactNumber: '044-7654321',
        iconName: 'medical_services',
      ),
    ];
  }

  @override
  Future<List<EmergencyContactEntity>> loadEmergencyContacts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      EmergencyContactModel(
        name: 'Mall Security',
        number: '044-88889999',
        iconName: 'security',
      ),
      EmergencyContactModel(
        name: 'Police Assistance',
        number: '100',
        iconName: 'local_police',
      ),
      EmergencyContactModel(
        name: 'Ambulance Service',
        number: '108',
        iconName: 'ambulance',
      ),
      EmergencyContactModel(
        name: 'Fire Department',
        number: '101',
        iconName: 'local_fire_department',
      ),
      EmergencyContactModel(
        name: 'Visitor Help Desk',
        number: '044-11112222',
        iconName: 'info',
      ),
    ];
  }

  @override
  Future<EmergencyNavigationRouteEntity> startNavigation(
    String destination,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return EmergencyNavigationRouteModel(
      destinationName: destination,
      estimatedMinutes: 2,
      distanceMeter: 120.0,
      currentFloor: 'Level 2',
      isSafeRouteActive: true,
      steps: const [
        RouteStepModel(
          title: 'Current Location',
          description: 'Level 2 - Main Lobby',
          iconName: 'location_on',
        ),
        RouteStepModel(
          title: 'Main Corridor',
          description: 'Walk 45m straight towards the Luxury Wing',
          iconName: 'straight',
        ),
        RouteStepModel(
          title: 'Emergency Staircase B',
          description: 'Take the stairs down to Level 1',
          iconName: 'stairs',
        ),
        RouteStepModel(
          title: 'Emergency Exit North',
          description: 'Exit doors directly ahead',
          iconName: 'meeting_room',
        ),
      ],
    );
  }

  @override
  Future<void> sendSOS() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Future<void> notifySecurity() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<EmergencyInstructionEntity>> loadInstructions() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      EmergencyInstructionModel(
        title: 'Fire Emergency Protocol',
        description:
            'Immediately drop everything, proceed to the nearest illuminated Fire Exit signage. Do NOT use elevators under any circumstances.',
        iconName: 'fire_extinguisher',
      ),
      EmergencyInstructionModel(
        title: 'Earthquake Protocol',
        description:
            'Take cover under sturdy mall fixtures (Drop, Cover, and Hold On). Stand clear of store glass storefronts and light fixtures.',
        iconName: 'warning',
      ),
      EmergencyInstructionModel(
        title: 'Medical Distress Help',
        description:
            'If you or someone else is in medical distress, tap SOS. Move to a visible, open corridor and wait for first responders.',
        iconName: 'medical_services',
      ),
    ];
  }
}
