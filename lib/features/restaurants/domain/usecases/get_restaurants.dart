import '../entities/restaurant_entities.dart';
import '../repository/restaurant_repository.dart';

class GetRestaurantsUseCase {
  final RestaurantRepository repository;

  GetRestaurantsUseCase(this.repository);

  Future<List<RestaurantEntity>> call() async {
    return await repository.getRestaurants();
  }
}

class ToggleRestaurantFavoriteUseCase {
  final RestaurantRepository repository;

  ToggleRestaurantFavoriteUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.toggleFavoriteRestaurant(id);
  }
}

class ReserveTableUseCase {
  final RestaurantRepository repository;

  ReserveTableUseCase(this.repository);

  Future<void> call(String id, String timeSlot, int guestCount) async {
    await repository.reserveTable(id, timeSlot, guestCount);
  }
}
