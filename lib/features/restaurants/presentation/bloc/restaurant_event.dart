abstract class RestaurantEvent {
  const RestaurantEvent();
}

class LoadRestaurants extends RestaurantEvent {
  const LoadRestaurants();
}

class RefreshRestaurants extends RestaurantEvent {
  const RefreshRestaurants();
}

class LoadRestaurantDetails extends RestaurantEvent {
  final String restaurantId;

  const LoadRestaurantDetails({required this.restaurantId});
}

class FilterRestaurants extends RestaurantEvent {
  final String? cuisine;
  final String? floor;
  final bool? openOnly;
  final String? maxWaitTime;
  final String? searchQuery;

  const FilterRestaurants({
    this.cuisine,
    this.floor,
    this.openOnly,
    this.maxWaitTime,
    this.searchQuery,
  });
}

class ToggleFavoriteRestaurant extends RestaurantEvent {
  final String restaurantId;

  const ToggleFavoriteRestaurant({required this.restaurantId});
}

class ReserveTableSlot extends RestaurantEvent {
  final String restaurantId;
  final String timeSlot;
  final int guestCount;

  const ReserveTableSlot({
    required this.restaurantId,
    required this.timeSlot,
    required this.guestCount,
  });
}
