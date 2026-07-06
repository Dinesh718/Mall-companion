import '../entities/home_entities.dart';

abstract class HomeRepository {
  Future<HomeDataEntity> getHomeData();
}
