import '../repository/discover_repository.dart';

class RegisterForEvent {
  final DiscoverRepository repository;

  RegisterForEvent(this.repository);

  Future<void> call(String id) async {
    await repository.registerForEvent(id);
  }
}
