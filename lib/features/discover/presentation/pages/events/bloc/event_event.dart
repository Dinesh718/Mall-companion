abstract class EventEvent {
  const EventEvent();
}

class LoadEvents extends EventEvent {
  const LoadEvents();
}

class RefreshEvents extends EventEvent {
  const RefreshEvents();
}

class LoadEventDetails extends EventEvent {
  final String eventId;

  const LoadEventDetails({required this.eventId});
}

class BookmarkEvent extends EventEvent {
  final String eventId;

  const BookmarkEvent({required this.eventId});
}

class ToggleReminder extends EventEvent {
  final String eventId;

  const ToggleReminder({required this.eventId});
}

class RegisterEvent extends EventEvent {
  final String eventId;

  const RegisterEvent({required this.eventId});
}

class FilterCategoryChanged extends EventEvent {
  final String category;

  const FilterCategoryChanged({required this.category});
}

class FilterDateChanged extends EventEvent {
  final String dateFilter;

  const FilterDateChanged({required this.dateFilter});
}
