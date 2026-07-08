import '../entities/discover_entities.dart';

abstract class DiscoverRepository {
  Future<DiscoverDataEntity> getDiscoverData();
  Future<List<MallEventEntity>> getEvents();
  Future<void> toggleBookmarkEvent(String id);
  Future<void> registerForEvent(String id);
  Future<void> toggleReminderEvent(String id);
}
