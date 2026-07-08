import '../../domain/entities/parking_entities.dart';
import '../../domain/repository/parking_repository.dart';
import '../datasources/parking_local_datasource.dart';
import '../models/parking_models.dart';

class ParkingRepositoryImpl implements ParkingRepository {
  final ParkingLocalDataSource localDataSource;

  ParkingRepositoryImpl({required this.localDataSource});

  @override
  Future<ParkingAvailabilityEntity> loadParkingAvailability() {
    return localDataSource.getAvailability();
  }

  @override
  Future<List<ParkingZoneEntity>> loadParkingZones() {
    return localDataSource.getZones();
  }

  @override
  Future<void> saveVehicle(SavedVehicleEntity location) {
    return localDataSource.saveVehicle(SavedVehicleModel.fromEntity(location));
  }

  @override
  Future<SavedVehicleEntity?> getSavedVehicle() {
    return localDataSource.getSavedVehicle();
  }

  @override
  Future<void> removeSavedVehicle() {
    return localDataSource.removeSavedVehicle();
  }

  @override
  Future<List<ParkingHistoryItemEntity>> getHistory() {
    return localDataSource.getHistory();
  }
}
