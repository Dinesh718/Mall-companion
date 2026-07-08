import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/parking_repository.dart';
import 'parking_event.dart';
import 'parking_state.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  final ParkingRepository repository;

  ParkingBloc({required this.repository}) : super(const ParkingInitial()) {
    on<LoadParking>(_onLoadParking);
    on<RefreshParking>(_onRefreshParking);
    on<SaveVehicleLocation>(_onSaveVehicleLocation);
    on<RemoveSavedVehicle>(_onRemoveSavedVehicle);
    on<ToggleLoginState>(_onToggleLoginState);
  }

  Future<void> _onLoadParking(
    LoadParking event,
    Emitter<ParkingState> emit,
  ) async {
    emit(const ParkingLoading());
    try {
      final availability = await repository.loadParkingAvailability();
      final zones = await repository.loadParkingZones();
      final savedVehicle = await repository.getSavedVehicle();
      final history = await repository.getHistory();

      emit(
        ParkingLoaded(
          availability: availability,
          zones: zones,
          savedVehicle: savedVehicle,
          history: history,
          isLoggedIn: false, // Default to Guest user first
        ),
      );
    } catch (e) {
      emit(ParkingError(errorMessage: e.toString()));
    }
  }

  Future<void> _onRefreshParking(
    RefreshParking event,
    Emitter<ParkingState> emit,
  ) async {
    if (state is ParkingLoaded) {
      final currentState = state as ParkingLoaded;
      try {
        final availability = await repository.loadParkingAvailability();
        final zones = await repository.loadParkingZones();

        emit(
          currentState.copyWith(
            availability: availability,
            zones: zones,
            message: () => null,
          ),
        );
      } catch (_) {
        // Keep current state on refresh failure
      }
    }
  }

  Future<void> _onSaveVehicleLocation(
    SaveVehicleLocation event,
    Emitter<ParkingState> emit,
  ) async {
    if (state is ParkingLoaded) {
      final currentState = state as ParkingLoaded;
      try {
        await repository.saveVehicle(event.location);
        emit(
          currentState.copyWith(
            savedVehicle: () => event.location,
            message: () => 'Vehicle location saved successfully!',
          ),
        );
      } catch (e) {
        emit(ParkingError(errorMessage: e.toString()));
      }
    }
  }

  Future<void> _onRemoveSavedVehicle(
    RemoveSavedVehicle event,
    Emitter<ParkingState> emit,
  ) async {
    if (state is ParkingLoaded) {
      final currentState = state as ParkingLoaded;
      try {
        await repository.removeSavedVehicle();
        emit(
          currentState.copyWith(
            savedVehicle: () => null,
            message: () => 'Saved vehicle location cleared.',
          ),
        );
      } catch (e) {
        emit(ParkingError(errorMessage: e.toString()));
      }
    }
  }

  void _onToggleLoginState(ToggleLoginState event, Emitter<ParkingState> emit) {
    if (state is ParkingLoaded) {
      final currentState = state as ParkingLoaded;
      emit(
        currentState.copyWith(
          isLoggedIn: !currentState.isLoggedIn,
          message: () => currentState.isLoggedIn
              ? 'Switched to Guest view'
              : 'Switched to Logged-In view',
        ),
      );
    }
  }
}
