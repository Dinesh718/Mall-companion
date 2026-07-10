import '../../domain/entities/map_entities.dart';
import '../../domain/repositories/map_repository.dart';
import '../datasources/local_map_datasource.dart';

class DummyMapRepository implements MapRepository {
  final LocalMapDataSource localDataSource;

  DummyMapRepository({required this.localDataSource});

  @override
  Future<MapEntity> getMapData() async {
    return localDataSource.getMapData();
  }
}
