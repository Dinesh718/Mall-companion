import '../../domain/entities/parking_entities.dart';

abstract class ParkingState {
  const ParkingState();
}

class ParkingInitial extends ParkingState {
  const ParkingInitial();
}

class ParkingLoading extends ParkingState {
  const ParkingLoading();
}

class ParkingLoaded extends ParkingState {
  final ParkingAvailabilityEntity availability;
  final List<ParkingZoneEntity> zones;
  final SavedVehicleEntity? savedVehicle;
  final List<ParkingHistoryItemEntity> history;
  final bool isLoggedIn;
  final String? message;

  const ParkingLoaded({
    required this.availability,
    required this.zones,
    this.savedVehicle,
    required this.history,
    this.isLoggedIn = false,
    this.message,
  });

  ParkingLoaded copyWith({
    ParkingAvailabilityEntity? availability,
    List<ParkingZoneEntity>? zones,
    SavedVehicleEntity? Function()?
    savedVehicle, // Nullable function to clear value
    List<ParkingHistoryItemEntity>? history,
    bool? isLoggedIn,
    String? Function()? message,
  }) {
    return ParkingLoaded(
      availability: availability ?? this.availability,
      zones: zones ?? this.zones,
      savedVehicle: savedVehicle != null ? savedVehicle() : this.savedVehicle,
      history: history ?? this.history,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      message: message != null ? message() : this.message,
    );
  }
}

class ParkingError extends ParkingState {
  final String errorMessage;
  const ParkingError({required this.errorMessage});
}
