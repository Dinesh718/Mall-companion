import '../entities/restaurant_entities.dart';

abstract class RestaurantRepository {
  Future<List<RestaurantEntity>> getRestaurants();
  Future<void> toggleFavoriteRestaurant(String id);
  Future<void> reserveTable(String id, String timeSlot, int guestCount);
}
