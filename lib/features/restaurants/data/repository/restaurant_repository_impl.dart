import '../../domain/entities/restaurant_entities.dart';
import '../../domain/repository/restaurant_repository.dart';
import '../datasource/restaurant_local_datasource.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantLocalDataSource localDataSource;

  RestaurantRepositoryImpl({required this.localDataSource});

  @override
  Future<List<RestaurantEntity>> getRestaurants() async {
    return await localDataSource.getRestaurants();
  }

  @override
  Future<void> toggleFavoriteRestaurant(String id) async {
    await localDataSource.toggleFavoriteRestaurant(id);
  }

  @override
  Future<void> reserveTable(String id, String timeSlot, int guestCount) async {
    await localDataSource.reserveTable(id, timeSlot, guestCount);
  }
}
