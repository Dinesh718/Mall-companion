import '../../domain/entities/discover_entities.dart';
import '../../domain/repository/discover_repository.dart';
import '../datasource/discover_local_datasource.dart';

class DiscoverRepositoryImpl implements DiscoverRepository {
  final DiscoverLocalDataSource localDataSource;

  DiscoverRepositoryImpl({required this.localDataSource});

  @override
  Future<DiscoverDataEntity> getDiscoverData() async {
    return await localDataSource.getDiscoverData();
  }

  @override
  Future<List<MallEventEntity>> getEvents() async {
    return await localDataSource.getEvents();
  }

  @override
  Future<void> toggleBookmarkEvent(String id) async {
    await localDataSource.toggleBookmarkEvent(id);
  }

  @override
  Future<void> registerForEvent(String id) async {
    await localDataSource.registerForEvent(id);
  }
}
