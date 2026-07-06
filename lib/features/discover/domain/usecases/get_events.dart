import '../entities/discover_entities.dart';
import '../repository/discover_repository.dart';

class GetEvents {
  final DiscoverRepository repository;

  GetEvents(this.repository);

  Future<List<MallEventEntity>> call() async {
    return await repository.getEvents();
  }
}
