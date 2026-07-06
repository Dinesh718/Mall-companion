import '../entities/discover_entities.dart';
import '../repository/discover_repository.dart';

class GetDiscoverData {
  final DiscoverRepository repository;

  GetDiscoverData(this.repository);

  Future<DiscoverDataEntity> call() async {
    return await repository.getDiscoverData();
  }
}
