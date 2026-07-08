import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_stores_usecase.dart';
import 'store_event.dart';
import 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final GetStoresData getStoresData;
  final ToggleFavoriteStoreUseCase toggleFavoriteStoreUseCase;

  StoreBloc({
    required this.getStoresData,
    required this.toggleFavoriteStoreUseCase,
  }) : super(const StoreInitial()) {
    on<LoadStores>(_onLoadStores);
    on<RefreshStores>(_onRefreshStores);
    on<LoadStoreDetails>(_onLoadStoreDetails);
    on<SearchStores>(_onSearchStores);
    on<FilterStoresCategory>(_onFilterStoresCategory);
    on<FilterStoresFloor>(_onFilterStoresFloor);
    on<FavoriteStore>(_onFavoriteStore);
  }

  Future<void> _onLoadStores(LoadStores event, Emitter<StoreState> emit) async {
    emit(const StoreLoading());
    try {
      final stores = await getStoresData.getStores();
      emit(StoreLoaded(stores: stores));
    } catch (e) {
      emit(StoreError(errorMessage: e.toString()));
    }
  }

  Future<void> _onRefreshStores(
    RefreshStores event,
    Emitter<StoreState> emit,
  ) async {
    try {
      final stores = await getStoresData.getStores();
      if (state is StoreLoaded) {
        final current = state as StoreLoaded;
        emit(current.copyWith(stores: stores));
      } else {
        emit(StoreLoaded(stores: stores));
      }
    } catch (e) {
      emit(StoreError(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadStoreDetails(
    LoadStoreDetails event,
    Emitter<StoreState> emit,
  ) async {
    emit(const StoreLoading());
    try {
      final stores = await getStoresData.getStores();
      final store = stores.firstWhere((s) => s.id == event.storeId);
      final recommended = stores
          .where((s) => s.id != event.storeId && s.category == store.category)
          .toList();
      emit(
        StoreDetailsLoaded(
          store: store,
          recommendedStores: recommended.isNotEmpty
              ? recommended
              : stores.where((s) => s.id != event.storeId).toList(),
        ),
      );
    } catch (e) {
      emit(StoreError(errorMessage: e.toString()));
    }
  }

  void _onSearchStores(SearchStores event, Emitter<StoreState> emit) {
    if (state is StoreLoaded) {
      final current = state as StoreLoaded;
      emit(current.copyWith(searchQuery: event.query));
    }
  }

  void _onFilterStoresCategory(
    FilterStoresCategory event,
    Emitter<StoreState> emit,
  ) {
    if (state is StoreLoaded) {
      final current = state as StoreLoaded;
      emit(current.copyWith(selectedCategory: event.category));
    }
  }

  void _onFilterStoresFloor(FilterStoresFloor event, Emitter<StoreState> emit) {
    if (state is StoreLoaded) {
      final current = state as StoreLoaded;
      emit(current.copyWith(selectedFloor: event.floor));
    }
  }

  Future<void> _onFavoriteStore(
    FavoriteStore event,
    Emitter<StoreState> emit,
  ) async {
    try {
      await toggleFavoriteStoreUseCase(event.storeId);
      final stores = await getStoresData.getStores();

      if (state is StoreLoaded) {
        final current = state as StoreLoaded;
        emit(current.copyWith(stores: stores));
      } else if (state is StoreDetailsLoaded) {
        final current = state as StoreDetailsLoaded;
        final updatedStore = stores.firstWhere((s) => s.id == current.store.id);
        emit(
          current.copyWith(
            store: updatedStore,
            recommendedStores: current.recommendedStores,
          ),
        );
      }
    } catch (e) {
      emit(StoreError(errorMessage: e.toString()));
    }
  }
}
