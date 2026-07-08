import '../entities/store_entities.dart';
import '../repository/store_repository.dart';

class GetStoresData {
  final StoreRepository repository;

  GetStoresData(this.repository);

  Future<List<StoreEntity>> getStores() async {
    return await repository.getStores();
  }
}

class ToggleFavoriteStoreUseCase {
  final StoreRepository repository;

  ToggleFavoriteStoreUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.toggleFavoriteStore(id);
  }
}
