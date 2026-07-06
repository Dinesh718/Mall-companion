import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_discover_data.dart';
import 'discover_event.dart';
import 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final GetDiscoverData getDiscoverData;

  DiscoverBloc({required this.getDiscoverData})
    : super(const DiscoverInitial()) {
    on<LoadDiscover>(_onLoadDiscover);
    on<RefreshDiscover>(_onRefreshDiscover);
    on<SelectCategory>(_onSelectCategory);
    on<SearchChanged>(_onSearchChanged);
  }

  Future<void> _onLoadDiscover(
    LoadDiscover event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(const DiscoverLoading());
    try {
      final data = await getDiscoverData();
      emit(DiscoverLoaded(discoverData: data));
    } catch (e) {
      emit(DiscoverError(errorMessage: e.toString()));
    }
  }

  Future<void> _onRefreshDiscover(
    RefreshDiscover event,
    Emitter<DiscoverState> emit,
  ) async {
    // If it's already loaded, we refresh the data in-place without showing a heavy progress loader
    final currentState = state;
    try {
      final data = await getDiscoverData();
      if (currentState is DiscoverLoaded) {
        emit(currentState.copyWith(discoverData: data));
      } else {
        emit(DiscoverLoaded(discoverData: data));
      }
    } catch (e) {
      emit(DiscoverError(errorMessage: e.toString()));
    }
  }

  void _onSelectCategory(SelectCategory event, Emitter<DiscoverState> emit) {
    final currentState = state;
    if (currentState is DiscoverLoaded) {
      // Toggle category selection
      final newCategoryId = currentState.selectedCategoryId == event.categoryId
          ? ''
          : event.categoryId;
      emit(currentState.copyWith(selectedCategoryId: newCategoryId));
    }
  }

  void _onSearchChanged(SearchChanged event, Emitter<DiscoverState> emit) {
    final currentState = state;
    if (currentState is DiscoverLoaded) {
      emit(currentState.copyWith(searchQuery: event.searchQuery));
    }
  }
}
