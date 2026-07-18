import '../../domain/entities/map_entities.dart';
import '../../domain/repositories/map_repository.dart';
import '../datasources/local_map_datasource.dart';

class DummyMapRepository implements MapRepository {
  final LocalMapDataSource localDataSource;
  MapEntity? _cachedMap;

  DummyMapRepository({required this.localDataSource});

  @override
  Future<MapEntity> getMapData() async {
    if (_cachedMap != null) return _cachedMap!;
    _cachedMap = await localDataSource.getMapData();
    return _cachedMap!;
  }

  @override
  Future<List<ShopEntity>> searchShops(String query) async {
    final map = await getMapData();
    if (query.trim().isEmpty) return [];

    final lowercaseQuery = query.toLowerCase().trim();
    final allShops = map.floors.expand((floor) => floor.shops).toList();

    return allShops.where((shop) {
      return shop.name.toLowerCase().contains(lowercaseQuery) ||
          shop.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  @override
  Future<ShopEntity?> getShopById(String id) async {
    final map = await getMapData();
    for (final floor in map.floors) {
      for (final shop in floor.shops) {
        if (shop.id == id) return shop;
      }
    }
    return null;
  }
}
