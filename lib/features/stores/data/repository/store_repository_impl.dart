import '../../domain/entities/store_entities.dart';
import '../../domain/repository/store_repository.dart';
import '../datasource/store_local_datasource.dart';

class StoreRepositoryImpl implements StoreRepository {
  final StoreLocalDataSource localDataSource;

  StoreRepositoryImpl({required this.localDataSource});

  @override
  Future<List<StoreEntity>> getStores() async {
    return await localDataSource.getStores();
  }

  @override
  Future<void> toggleFavoriteStore(String id) async {
    await localDataSource.toggleFavoriteStore(id);
  }
}
