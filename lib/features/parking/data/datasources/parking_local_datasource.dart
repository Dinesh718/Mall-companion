import 'dart:math';
import '../models/parking_models.dart';

abstract class ParkingLocalDataSource {
  Future<ParkingAvailabilityModel> getAvailability();
  Future<List<ParkingZoneModel>> getZones();
  Future<void> saveVehicle(SavedVehicleModel location);
  Future<SavedVehicleModel?> getSavedVehicle();
  Future<void> removeSavedVehicle();
  Future<List<ParkingHistoryItemModel>> getHistory();
}

class ParkingLocalDataSourceImpl implements ParkingLocalDataSource {
  // Stateful simulation of vehicle location and history across app run
  static SavedVehicleModel? _savedVehicle;

  static final List<ParkingHistoryItemModel> _history = [
    const ParkingHistoryItemModel(
      id: 'hist_1',
      mallName: 'Grand Plaza Mall',
      dateText: 'Oct 24',
      arrivalTime: '2:15 PM',
      departureTime: '4:30 PM',
      zone: 'Zone A',
      slot: 'A-12',
      durationText: '2h 15m',
      vehicleType: 'Sedan',
    ),
    const ParkingHistoryItemModel(
      id: 'hist_2',
      mallName: 'Luxury Life Center',
      dateText: 'Oct 20',
      arrivalTime: '11:00 AM',
      departureTime: '3:30 PM',
      zone: 'Zone F',
      slot: 'F-88',
      durationText: '4h 30m',
      vehicleType: 'SUV',
    ),
  ];

  @override
  Future<ParkingAvailabilityModel> getAvailability() async {
    await Future.delayed(const Duration(milliseconds: 200));

    // Simulate slight fluctuation in availability (e.g. occupancy between 60% and 68%)
    final random = Random();
    final int occupancy = 60 + random.nextInt(9);
    final int total = 2000;
    final int occupied = (total * occupancy) ~/ 100;
    final int available = total - occupied;

    return ParkingAvailabilityModel(
      availableSpaces: available,
      totalSpaces: total,
      occupancyPercentage: occupancy,
      entryRate: 10 + random.nextInt(6),
      exitRate: 5 + random.nextInt(6),
      estimatedEntryTime: '~2 Mins',
    );
  }

  @override
  Future<List<ParkingZoneModel>> getZones() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return const [
      ParkingZoneModel(
        id: 'zone_a',
        name: 'Zone A',
        status: 'Available',
        occupancyPercentage: 22,
        availableSpaces: 420,
        parkingLevel: 'Level 1',
        hasEVCharging: true,
        hasAccessibleParking: true,
      ),
      ParkingZoneModel(
        id: 'zone_b',
        name: 'Zone B',
        status: 'Limited',
        occupancyPercentage: 88,
        availableSpaces: 12,
        parkingLevel: 'Level 2',
        hasEVCharging: false,
        hasAccessibleParking: true,
      ),
      ParkingZoneModel(
        id: 'zone_c',
        name: 'Zone C',
        status: 'Full',
        occupancyPercentage: 100,
        availableSpaces: 0,
        parkingLevel: 'Level 3',
        hasEVCharging: true,
        hasAccessibleParking: false,
      ),
      ParkingZoneModel(
        id: 'zone_d',
        name: 'Zone D',
        status: 'Available',
        occupancyPercentage: 45,
        availableSpaces: 180,
        parkingLevel: 'Basement 1',
        hasEVCharging: false,
        hasAccessibleParking: false,
      ),
    ];
  }

  @override
  Future<void> saveVehicle(SavedVehicleModel location) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _savedVehicle = location;
  }

  @override
  Future<SavedVehicleModel?> getSavedVehicle() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _savedVehicle;
  }

  @override
  Future<void> removeSavedVehicle() async {
    await Future.delayed(const Duration(milliseconds: 150));
    _savedVehicle = null;
  }

  @override
  Future<List<ParkingHistoryItemModel>> getHistory() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _history;
  }
}
