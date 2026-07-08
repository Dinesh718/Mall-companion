import '../../domain/entities/store_entities.dart';

abstract class StoreState {
  const StoreState();
}

class StoreInitial extends StoreState {
  const StoreInitial();
}

class StoreLoading extends StoreState {
  const StoreLoading();
}

class StoreLoaded extends StoreState {
  final List<StoreEntity> stores;
  final String searchQuery;
  final String selectedCategory; // e.g. "All Stores", "Fashion", "Electronics", etc.
  final String selectedFloor; // e.g. "All Floors", "Ground", "L1", "L2"

  const StoreLoaded({
    required this.stores,
    this.searchQuery = '',
    this.selectedCategory = 'All Stores',
    this.selectedFloor = 'All Floors',
  });

  StoreLoaded copyWith({
    List<StoreEntity>? stores,
    String? searchQuery,
    String? selectedCategory,
    String? selectedFloor,
  }) {
    return StoreLoaded(
      stores: stores ?? this.stores,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedFloor: selectedFloor ?? this.selectedFloor,
    );
  }
}

class StoreDetailsLoaded extends StoreState {
  final StoreEntity store;
  final List<StoreEntity> recommendedStores;

  const StoreDetailsLoaded({
    required this.store,
    required this.recommendedStores,
  });

  StoreDetailsLoaded copyWith({
    StoreEntity? store,
    List<StoreEntity>? recommendedStores,
  }) {
    return StoreDetailsLoaded(
      store: store ?? this.store,
      recommendedStores: recommendedStores ?? this.recommendedStores,
    );
  }
}

class StoreError extends StoreState {
  final String errorMessage;
  const StoreError({required this.errorMessage});
}
