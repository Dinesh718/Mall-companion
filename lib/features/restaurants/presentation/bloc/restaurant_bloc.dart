import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_restaurants.dart';
import 'restaurant_event.dart';
import 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final GetRestaurantsUseCase getRestaurants;
  final ToggleRestaurantFavoriteUseCase toggleFavorite;
  final ReserveTableUseCase reserveTable;

  RestaurantBloc({
    required this.getRestaurants,
    required this.toggleFavorite,
    required this.reserveTable,
  }) : super(const RestaurantInitial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<RefreshRestaurants>(_onRefreshRestaurants);
    on<LoadRestaurantDetails>(_onLoadRestaurantDetails);
    on<FilterRestaurants>(_onFilterRestaurants);
    on<ToggleFavoriteRestaurant>(_onToggleFavoriteRestaurant);
    on<ReserveTableSlot>(_onReserveTableSlot);
  }

  Future<void> _onLoadRestaurants(
    LoadRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(const RestaurantLoading());
    try {
      final list = await getRestaurants();
      emit(RestaurantsLoaded(restaurants: list));
    } catch (e) {
      emit(RestaurantError(errorMessage: e.toString()));
    }
  }

  Future<void> _onRefreshRestaurants(
    RefreshRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    final currentState = state;
    try {
      final list = await getRestaurants();
      if (currentState is RestaurantsLoaded) {
        emit(currentState.copyWith(restaurants: list));
      } else {
        emit(RestaurantsLoaded(restaurants: list));
      }
    } catch (e) {
      emit(RestaurantError(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadRestaurantDetails(
    LoadRestaurantDetails event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(const RestaurantLoading());
    try {
      final list = await getRestaurants();
      final details = list.firstWhere((r) => r.id == event.restaurantId);
      emit(RestaurantDetailsLoaded(restaurant: details));
    } catch (e) {
      emit(RestaurantError(errorMessage: e.toString()));
    }
  }

  void _onFilterRestaurants(
    FilterRestaurants event,
    Emitter<RestaurantState> emit,
  ) {
    final currentState = state;
    if (currentState is RestaurantsLoaded) {
      emit(currentState.copyWith(
        selectedCuisine: event.cuisine,
        selectedFloor: event.floor,
        openOnly: event.openOnly,
        maxWaitTime: event.maxWaitTime,
        searchQuery: event.searchQuery,
      ));
    }
  }

  Future<void> _onToggleFavoriteRestaurant(
    ToggleFavoriteRestaurant event,
    Emitter<RestaurantState> emit,
  ) async {
    final currentState = state;
    try {
      await toggleFavorite(event.restaurantId);
      final updatedList = await getRestaurants();

      if (currentState is RestaurantsLoaded) {
        emit(currentState.copyWith(restaurants: updatedList));
      } else if (currentState is RestaurantDetailsLoaded) {
        final target = updatedList.firstWhere((r) => r.id == event.restaurantId);
        emit(RestaurantDetailsLoaded(restaurant: target));
      }
    } catch (e) {
      emit(RestaurantError(errorMessage: e.toString()));
    }
  }

  Future<void> _onReserveTableSlot(
    ReserveTableSlot event,
    Emitter<RestaurantState> emit,
  ) async {
    final currentState = state;
    try {
      await reserveTable(event.restaurantId, event.timeSlot, event.guestCount);
      final updatedList = await getRestaurants();

      if (currentState is RestaurantDetailsLoaded) {
        final target = updatedList.firstWhere((r) => r.id == event.restaurantId);
        emit(RestaurantDetailsLoaded(restaurant: target));
      } else if (currentState is RestaurantsLoaded) {
        emit(currentState.copyWith(restaurants: updatedList));
      }
    } catch (e) {
      emit(RestaurantError(errorMessage: e.toString()));
    }
  }
}
