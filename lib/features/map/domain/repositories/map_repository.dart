import '../entities/map_entities.dart';
import '../entities/shop_category.dart';
import '../entities/position_entities.dart';

abstract class MapRepository {
  Future<MapEntity> getMapData();
  Future<List<ShopEntity>> searchShops(String query);
  Future<ShopEntity?> getShopById(String id);
  Future<List<ShopCategory>> getCategories();
  Future<List<ShopEntity>> getShopsByCategory(ShopCategory category);
  Future<List<ShopEntity>> getShops({String? query, ShopCategory? category});
  Future<IndoorPositionEntity?> resolveNavigationNode(String nodeId);
}
