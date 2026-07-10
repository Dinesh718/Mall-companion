import '../entities/map_entities.dart';

abstract class MapRepository {
  Future<MapEntity> getMapData();
}
