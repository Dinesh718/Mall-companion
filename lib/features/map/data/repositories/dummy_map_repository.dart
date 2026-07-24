import '../../domain/entities/map_entities.dart';
import '../../domain/entities/shop_category.dart';
import '../../domain/entities/position_entities.dart';
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
    return getShops(query: query);
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

  @override
  Future<List<ShopCategory>> getCategories() async {
    return const [
      ShopCategory(id: 'food', name: 'Food', icon: '🍔'),
      ShopCategory(id: 'cafe', name: 'Cafe', icon: '☕'),
      ShopCategory(id: 'fashion', name: 'Fashion', icon: '👕'),
      ShopCategory(id: 'footwear', name: 'Footwear', icon: '👟'),
      ShopCategory(id: 'electronics', name: 'Electronics', icon: '📱'),
      ShopCategory(id: 'beauty', name: 'Beauty', icon: '💄'),
      ShopCategory(id: 'entertainment', name: 'Entertainment', icon: '🎮'),
      ShopCategory(id: 'banking', name: 'Banking', icon: '🏦'),
      ShopCategory(id: 'restroom', name: 'Restroom', icon: '🚻'),
      ShopCategory(id: 'parking', name: 'Parking', icon: '🚗'),
    ];
  }

  @override
  Future<List<ShopEntity>> getShopsByCategory(ShopCategory category) async {
    return getShops(category: category);
  }

  @override
  Future<List<ShopEntity>> getShops({
    String? query,
    ShopCategory? category,
  }) async {
    final map = await getMapData();
    var results = map.floors.expand((floor) => floor.shops).toList();

    if (category != null) {
      final catLower = category.name.toLowerCase().trim();
      results = results
          .where((s) => s.category.toLowerCase().trim() == catLower)
          .toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final queryLower = query.toLowerCase().trim();
      results = results
          .where(
            (s) =>
                s.name.toLowerCase().contains(queryLower) ||
                s.category.toLowerCase().contains(queryLower),
          )
          .toList();
    }

    return results;
  }

  @override
  Future<IndoorPositionEntity?> resolveNavigationNode(String nodeId) async {
    final map = await getMapData();
    for (final floor in map.floors) {
      for (final node in floor.navigationGraph.nodes) {
        if (node.id == nodeId) {
          print('Found node ${node.id} ${floor.id} ${node.x} ${node.y}');
          print('IndoorPositionEntity ${floor.id} ${node.x} ${node.y}');
          return IndoorPositionEntity(
            id: 'node_$nodeId',
            floorId: floor.id,
            x: node.x,
            y: node.y,
            accuracy: 1.0,
            timestamp: DateTime.now(),
            source: PositionSource.qr,
          );
        }
      }
    }
    return null;
  }
}
