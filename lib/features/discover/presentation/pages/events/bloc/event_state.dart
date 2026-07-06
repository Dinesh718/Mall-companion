import '../../../../domain/entities/discover_entities.dart';

abstract class EventState {
  const EventState();
}

class EventInitial extends EventState {
  const EventInitial();
}

class EventLoading extends EventState {
  const EventLoading();
}

class EventsLoaded extends EventState {
  final List<MallEventEntity> events;
  final String selectedCategory;
  final String selectedDateFilter;

  const EventsLoaded({
    required this.events,
    this.selectedCategory = 'All',
    this.selectedDateFilter = 'All',
  });

  EventsLoaded copyWith({
    List<MallEventEntity>? events,
    String? selectedCategory,
    String? selectedDateFilter,
  }) {
    return EventsLoaded(
      events: events ?? this.events,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedDateFilter: selectedDateFilter ?? this.selectedDateFilter,
    );
  }
}

class EventDetailsLoaded extends EventState {
  final MallEventEntity event;

  const EventDetailsLoaded({required this.event});
}

class EventError extends EventState {
  final String errorMessage;

  const EventError({required this.errorMessage});
}
