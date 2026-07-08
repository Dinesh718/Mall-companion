import '../entities/parking_entities.dart';

abstract class ParkingRepository {
  Future<ParkingAvailabilityEntity> loadParkingAvailability();
  Future<List<ParkingZoneEntity>> loadParkingZones();
  Future<void> saveVehicle(SavedVehicleEntity location);
  Future<SavedVehicleEntity?> getSavedVehicle();
  Future<void> removeSavedVehicle();
  Future<List<ParkingHistoryItemEntity>> getHistory();
}
