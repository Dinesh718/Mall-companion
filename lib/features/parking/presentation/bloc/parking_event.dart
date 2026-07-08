import '../../domain/entities/parking_entities.dart';

abstract class ParkingEvent {
  const ParkingEvent();
}

class LoadParking extends ParkingEvent {
  const LoadParking();
}

class RefreshParking extends ParkingEvent {
  const RefreshParking();
}

class SaveVehicleLocation extends ParkingEvent {
  final SavedVehicleEntity location;
  const SaveVehicleLocation({required this.location});
}

class RemoveSavedVehicle extends ParkingEvent {
  const RemoveSavedVehicle();
}

class ToggleLoginState extends ParkingEvent {
  const ToggleLoginState();
}
