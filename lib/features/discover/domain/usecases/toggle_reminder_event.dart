import '../repository/discover_repository.dart';

class ToggleReminderEvent {
  final DiscoverRepository repository;

  ToggleReminderEvent(this.repository);

  Future<void> call(String id) async {
    await repository.toggleReminderEvent(id);
  }
}
