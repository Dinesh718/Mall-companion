import '../entities/map_entities.dart';

abstract class MapRepository {
  Future<MapEntity> getMapData();
  Future<List<ShopEntity>> searchShops(String query);
  Future<ShopEntity?> getShopById(String id);
}
