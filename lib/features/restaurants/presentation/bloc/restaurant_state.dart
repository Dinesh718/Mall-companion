import '../../domain/entities/restaurant_entities.dart';

abstract class RestaurantState {
  const RestaurantState();
}

class RestaurantInitial extends RestaurantState {
  const RestaurantInitial();
}

class RestaurantLoading extends RestaurantState {
  const RestaurantLoading();
}

class RestaurantsLoaded extends RestaurantState {
  final List<RestaurantEntity> restaurants;
  final String selectedCuisine;
  final String selectedFloor;
  final bool openOnly;
  final String maxWaitTime;
  final String searchQuery;

  const RestaurantsLoaded({
    required this.restaurants,
    this.selectedCuisine = 'All',
    this.selectedFloor = 'All',
    this.openOnly = false,
    this.maxWaitTime = 'All',
    this.searchQuery = '',
  });

  RestaurantsLoaded copyWith({
    List<RestaurantEntity>? restaurants,
    String? selectedCuisine,
    String? selectedFloor,
    bool? openOnly,
    String? maxWaitTime,
    String? searchQuery,
  }) {
    return RestaurantsLoaded(
      restaurants: restaurants ?? this.restaurants,
      selectedCuisine: selectedCuisine ?? this.selectedCuisine,
      selectedFloor: selectedFloor ?? this.selectedFloor,
      openOnly: openOnly ?? this.openOnly,
      maxWaitTime: maxWaitTime ?? this.maxWaitTime,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class RestaurantDetailsLoaded extends RestaurantState {
  final RestaurantEntity restaurant;

  const RestaurantDetailsLoaded({required this.restaurant});
}

class ReservationSuccessState extends RestaurantState {
  final String message;

  const ReservationSuccessState({required this.message});
}

class RestaurantError extends RestaurantState {
  final String errorMessage;

  const RestaurantError({required this.errorMessage});
}
