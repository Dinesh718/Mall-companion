import '../entities/store_entities.dart';

abstract class StoreRepository {
  Future<List<StoreEntity>> getStores();
  Future<void> toggleFavoriteStore(String id);
}
