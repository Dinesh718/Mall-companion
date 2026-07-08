import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/get_events.dart';
import '../../../../domain/usecases/register_for_event.dart';
import '../../../../domain/usecases/toggle_bookmark_event.dart';
import '../../../../domain/usecases/toggle_reminder_event.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final GetEvents getEvents;
  final ToggleBookmarkEvent toggleBookmarkEvent;
  final RegisterForEvent registerForEvent;
  final ToggleReminderEvent toggleReminderEvent;

  EventBloc({
    required this.getEvents,
    required this.toggleBookmarkEvent,
    required this.registerForEvent,
    required this.toggleReminderEvent,
  }) : super(const EventInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<RefreshEvents>(_onRefreshEvents);
    on<LoadEventDetails>(_onLoadEventDetails);
    on<BookmarkEvent>(_onBookmarkEvent);
    on<RegisterEvent>(_onRegisterEvent);
    on<ToggleReminder>(_onToggleReminder);
    on<FilterCategoryChanged>(_onFilterCategoryChanged);
    on<FilterDateChanged>(_onFilterDateChanged);
  }

  Future<void> _onLoadEvents(LoadEvents event, Emitter<EventState> emit) async {
    emit(const EventLoading());
    try {
      final list = await getEvents();
      emit(EventsLoaded(events: list));
    } catch (e) {
      emit(EventError(errorMessage: e.toString()));
    }
  }

  Future<void> _onRefreshEvents(
    RefreshEvents event,
    Emitter<EventState> emit,
  ) async {
    final currentState = state;
    try {
      final list = await getEvents();
      if (currentState is EventsLoaded) {
        emit(currentState.copyWith(events: list));
      } else {
        emit(EventsLoaded(events: list));
      }
    } catch (e) {
      emit(EventError(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadEventDetails(
    LoadEventDetails event,
    Emitter<EventState> emit,
  ) async {
    emit(const EventLoading());
    try {
      final list = await getEvents();
      final target = list.firstWhere((e) => e.id == event.eventId);
      emit(EventDetailsLoaded(event: target));
    } catch (e) {
      emit(EventError(errorMessage: e.toString()));
    }
  }

  Future<void> _onBookmarkEvent(
    BookmarkEvent event,
    Emitter<EventState> emit,
  ) async {
    final currentState = state;
    try {
      await toggleBookmarkEvent(event.eventId);
      final updatedList = await getEvents();

      if (currentState is EventsLoaded) {
        emit(currentState.copyWith(events: updatedList));
      } else if (currentState is EventDetailsLoaded) {
        final target = updatedList.firstWhere((e) => e.id == event.eventId);
        emit(EventDetailsLoaded(event: target));
      }
    } catch (e) {
      emit(EventError(errorMessage: e.toString()));
    }
  }

  Future<void> _onRegisterEvent(
    RegisterEvent event,
    Emitter<EventState> emit,
  ) async {
    final currentState = state;
    try {
      await registerForEvent(event.eventId);
      final updatedList = await getEvents();

      if (currentState is EventsLoaded) {
        emit(currentState.copyWith(events: updatedList));
      } else if (currentState is EventDetailsLoaded) {
        final target = updatedList.firstWhere((e) => e.id == event.eventId);
        emit(EventDetailsLoaded(event: target));
      }
    } catch (e) {
      emit(EventError(errorMessage: e.toString()));
    }
  }

  void _onFilterCategoryChanged(
    FilterCategoryChanged event,
    Emitter<EventState> emit,
  ) {
    final currentState = state;
    if (currentState is EventsLoaded) {
      emit(currentState.copyWith(selectedCategory: event.category));
    }
  }

  void _onFilterDateChanged(FilterDateChanged event, Emitter<EventState> emit) {
    final currentState = state;
    if (currentState is EventsLoaded) {
      emit(currentState.copyWith(selectedDateFilter: event.dateFilter));
    }
  }

  Future<void> _onToggleReminder(
    ToggleReminder event,
    Emitter<EventState> emit,
  ) async {
    final currentState = state;
    try {
      await toggleReminderEvent(event.eventId);
      final updatedList = await getEvents();

      if (currentState is EventsLoaded) {
        emit(currentState.copyWith(events: updatedList));
      } else if (currentState is EventDetailsLoaded) {
        final target = updatedList.firstWhere((e) => e.id == event.eventId);
        emit(EventDetailsLoaded(event: target));
      }
    } catch (e) {
      emit(EventError(errorMessage: e.toString()));
    }
  }
}
