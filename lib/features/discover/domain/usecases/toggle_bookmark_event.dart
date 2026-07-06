import '../repository/discover_repository.dart';

class ToggleBookmarkEvent {
  final DiscoverRepository repository;

  ToggleBookmarkEvent(this.repository);

  Future<void> call(String id) async {
    await repository.toggleBookmarkEvent(id);
  }
}
