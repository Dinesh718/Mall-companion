import '../entities/home_entities.dart';
import '../repository/home_repository.dart';

class GetHomeData {
  final HomeRepository repository;

  GetHomeData(this.repository);

  Future<HomeDataEntity> call() async {
    return await repository.getHomeData();
  }
}
